#include "TOTVS.ch"
#include "TbiConn.ch"
#include "TbiCode.ch"
#include "TopConn.ch"

/*----------------------+--------------------------------+------------------+
|   Programa: AVCOMW10  | Autor: Kley@TOTVS              | Data: 28/04/2014 |
+-----------------------+--------------------------------+------------------+
|  Descricao: Workflow de Pedido de Compra
|				_nOpc <ExpN1>
|					1 = PC A APROVAR E PC COM APROVADOR SEM SALDO PARA APROVACAO
|					2 = Retorno
|					3 = Envia Notif REPROVADOS
|					4 = REPROVADOS
|					5 = Envia Notif APROVADOS
+---------------------------------------------------------------------------+
|    Projeto: AVANT
+---------------------------------------------------------------------------+
|    Sintaxe: U_AVCOMW10(_nOpc,pcPedido,oProcess,cMailCC)
+----------------------------------------------------------------------------
|    Retorno: Nulo                                                               
+--------------------------------------------------------------------------*/
	
User Function AVCOMW10(_nOpc,pcPedido,oProcess,cMailCC)

Local cSubject	:= ""
Local cTitle		:= ""
Local cBody		:= ""
Local cTo			:= ""
Local cFunc		:= "U_AVCOMW10"

//Private _cIndex, _cFiltro, _cOrdem, _lProcesso := .F.
Private _lProcesso := .F.
Private _cFilial, _cOpcao, _cObs,_cUserAprov

Private nSaldo 		:= 0 , nSalDif 	:= 0  , cTipoLim 	:= ""
Private aRetSaldo 	:={} ,	cAprov    	:= "" , cObs 		:= ""
Private nTotal    	:= 0 , cGrupo	 	:= "" , lLiberou	:= .F.

Private aAreaAnt, aAreaSC7
Private cEOL	:= CRLF

U_Console("Inicio do processamento do Pedido de Compra",cFunc)

If !Empty( pcPedido ) .And. FunName() $ "MATA120|MATA121"
	U_Console("Processando Envio de PC pelo Menu. Emp/Fil/PC:"+cEmpAnt+"/"+cFilAnt+"/"+pcPedido,cFunc)
	If _nOpc == 1
		cTipoEnvio := {"reenvio","Reenvio para Aprovação"}
	ElseIf _nOpc == 6
		cTipoEnvio := {"envio","Envio do Pedido ao Fornecedor"}
	Else
		cTipoEnvio := {"envio","Envio do Pedido de Compra"}
	EndIf
	aAreaAnt := GetArea()
	aAreaSC7 := SC7->( GetArea() )

	If MsgYesNo("Confirma o "+cTipoEnvio[1]+" do Pedido de Compra para aprovação?",cTipoEnvio[2])
		Processa( { || AVW10Proc(_nOpc,pcPedido,oProcess,cMailCC) },"Processando o reenvio para aprovação. Aguarde..." )
	Else
		Return
	EndIf

	RestArea(aAreaAnt)
	SC7->(RestArea(aAreaSC7))
Else
	AVW10Proc(_nOpc,pcPedido,Process)
EndIf

Return

/*----------------------+--------------------------------+------------------+
|   Programa: AVW10Proc | Autor: Kley@TOTVS              | Data: 28/04/2014 |
+-----------------------+--------------------------------+------------------+
|  Descricao: Processa o Workflow de Pedido de Compra
+---------------------------------------------------------------------------+
|    Projeto: AVANT
+---------------------------------------------------------------------------+
|    Sintaxe: U_AVW10Proc(_nOpc,pcPedido,oProcess,cMailCC)
+----------------------------------------------------------------------------
|    Retorno: Nulo                                                               
+--------------------------------------------------------------------------*/

Static Function AVW10Proc(_nOpc,pcPedido,oProcess,cMailCC)

Local cFunc	 := "U_AVCOMW10::AVW10Proc"
Local cAlias	 := GetNextAlias() //"TMP"
Local cFiltro	 := ""

Private nRecnoTMP	:= 0

/*-------------------------------------------------------------------------+
|  1 - Prepara os pedidos a serem enviados para aprovacao                  |                                            
+--------------------------------------------------------------------------*/
If _nOpc == 1
	
	U_Console("1 - Prepara os pedidos para envio de aprovacao",cFunc)
	
	ChkFile("SC7")			// Pedido de Compras
	ChkFile("SCR")  			// Documentos com alçadas

	If Select(cAlias) > 0
		(cAlias)->(dbCloseArea())
	Endif

	If !Empty(pcPedido)														// Quando vier pelo menu
		cFiltro :=  "%" + " and rtrim(CR_NUM) = '"+pcPedido+"' "
		cFiltro +=       "  and CR_WF in (' ','1','2','3') "
		cFiltro +=       "  and CR_STATUS in ('02','04') " + "%"			// Em aprovação / Bloqueado (Solicitar uma nova aprovacao)
	Else
		cFiltro :=  "%" + " and CR_WF in (' ','3') "						// ' '-Nao Enviado / 3-rejeitado por saldo insuficiente no retorno
		cFiltro +=        " and CR_STATUS = '02' " + "%"					// Em aprovação
	EndIf		

	BeginSQL Alias cAlias
		select *
		from %Table:SCR% SCR
		where CR_FILIAL  = %xFilial:SCR%
		  and CR_TIPO    = 'PC'
		  and SCR.%NotDel%
		  %Exp:cFiltro%
		order by CR_FILIAL, CR_TIPO, CR_NUM, CR_NIVEL, CR_USER
	EndSQL

	DbSelectArea(cAlias)
	(cAlias)->(DbGoTop())
	
	If !Empty(pcPedido)
		If (cAlias)->(Eof())
			U_Console("1 - Processamento pelo Menu => Nao houve Processamento: PC/AE no."+AllTrim(pcPedido),cFunc)
			If !IsBlind() // Quando vier pelo menu
				MsgStop("Não existe processo de aprovação relacionado a este Pedido de Compra."+Chr(13)+Chr(10)+;
						 "Consulte a Aprovação do documento.","Não há Aprovação para o documento")
			EndIf
			(cAlias)->( DbCloseArea() )
			SC7->( RestArea( aAreaSC7 ) )
			RestArea( aAreaAnt )
			Return
		EndIf
	EndIf

	While !(cAlias)->(Eof())
		U_Console("1 - Pedido encontrado => Iniciando Processamento: "+(cAlias)->CR_TIPO+" no."+AllTrim((cAlias)->CR_NUM),cFunc)

		_cWFId 	:= AVW10EnvPC((cAlias)->CR_FILIAL, (cAlias)->CR_NUM, (cAlias)->CR_USER , (cAlias)->CR_APROV, (cAlias)->(CR_FILIAL+CR_TIPO+CR_NUM+CR_USER), (cAlias)->CR_TOTAL, (cAlias)->CR_WF)
		_lProcesso	:= .T.
		_cUserAprov := 	(cAlias)->CR_USER +' '+ (cAlias)->CR_APROV	//usuario e aprovador

		DbSelectarea("SCR")
		DbSetOrder(2)
		If DbSeek((cAlias)->(CR_FILIAL+CR_TIPO+CR_NUM+CR_USER))
			Reclock("SCR",.F.)
				SCR->CR_WF		 := "1"						// Status 1 - envio para aprovadores
				SCR->CR_X_WFID := _cWFId	   					// Rastreabilidade
			MSUnlock()
		EndIf

		DbSelectarea("SC7")
		DbSetOrder(1)
		DbSeek((cAlias)->(CR_FILIAL+Left(CR_NUM,TamSX3("C7_NUM")[1])))
		While !SC7->(Eof()) .And. SC7->(C7_FILIAL+C7_NUM) == (cAlias)->(CR_FILIAL+Left(CR_NUM,TamSX3("C7_NUM")[1]))
			Reclock("SC7",.F.)
				SC7->C7_X_WF		:= " "						// Status ' ' - Nao enviado Notificacao para Comprador
				SC7->C7_X_WFID	:= " "              		// Rastreabilidade - Grava depois que notificar Comprador
			MSUnlock()
			SC7->(DbSkip())
		EndDo

		(cAlias)->(DbSkip())
	EndDo
	
	dbSelectArea(cAlias)
	//dbClearFilter()
	(cAlias)->(dbCloseArea())
	
	If !Empty(pcPedido)
		U_Console("1 - Processamento pelo Menu => Mensagem enviada com sucesso: PC/AE no."+AllTrim(pcPedido),cFunc)
		If !IsBlind()
			MsgInfo("O Pedido de Compra foi enviado para aprovacao.","Envio para Aprovacao")
		EndIf
		SC7->( RestArea( aAreaSC7 ) )
		RestArea( aAreaAnt )
	EndIf

/*-------------------------------------------------------------------------+
|  2 - Processa O RETORNO DO EMAIL                                         |                                             
+--------------------------------------------------------------------------*/
ElseIf _nOPC	== 2
	
	U_Console("2 - Processa o Retorno do Email",cFunc)
	U_Console("2 - Semaforo Vermelho",cFunc)

	ChkFile("SCR")
	ChkFile("SAL")
	ChkFile("SC7")
	ChkFile("SCS")
	ChkFile("SAK")
	ChkFile("SM2")
	
	If oProcess <> Nil
		cFilAnt	:= AllTrim(oProcess:oHtml:RetByName("CFILANT"))
		cChaveSCR	:= AllTrim(oProcess:oHtml:RetByName("CHAVE"))
		cOpc     	:= AllTrim(oProcess:oHtml:RetByName("OPC"))
		cObs     	:= AllTrim(oProcess:oHtml:RetByName("OBS"))
		cWFID     	:= AllTrim(oProcess:oHtml:RetByName("WFID"))
		cWF       	:= AllTrim(oProcess:oHtml:RetByName("WF")) //cWF -> ' '-Nao Enviado / 3-rejeitado por saldo insuficiente no retorno
		
		oProcess:Finish() // FINALIZA O PROCESSO

		U_Console("2 - cChaveSCR: " + cChaveSCR,cFunc)
		
	Else
		cFilAnt		:= ""
		cChaveSCR	:= ""
		cOpc     	:= ""
		cObs     	:= ""
		cWFID     	:= ""
		cWF       	:= ""
	EndIf
	
	// Posiciona na tabela de Alcadas
	DbSelectArea("SCR")
	SCR->(DbSetOrder(2))
	SCR->(DbSeek(cChaveSCR))
	If !Found()
		U_Console("2 - Nao encontrado registro no SCR (Aprovacao) correspondente a Chave do processo. Abortado!",cFunc)
		Return .T.
	Endif

	IF SCR->(Eof()) .or. AllTrim(SCR->CR_X_WFID) <> AllTrim(cWFID)
		// Este processo nao foi encontrado e portanto deve ser descartado
		// abre uma notificacao a pessoa que respondeu
		U_Console("2 - O Email respondido nao corresponde a ultima revisao do pedido de compras. ID do Processo (cWFID) nao corresponde ao SCR->CR_X_WFID.",cFunc)
		Return .T.
	ENDIF
	
	If cOpc	$ "S|N|T"  // Aprovacao S-Sim N-Nao T-Transfere para Superior
		
		RecLock("SCR",.F.)
			SCR->CR_WF		:= "2"			// Status 2 - respondido
			SCR->CR_DATALIB := dDataBase
		MSUnlock()
		
		If !Empty(SCR->CR_DATALIB) .And. SCR->CR_STATUS$"03#04#05"
			U_Console("2 - Processo ja aprovado. Processamento abortado! Tipo/Num: "+SCR->CR_TIPO+"/"+RTrim(SCR->CR_NUM),cFunc)
			U_Console("2 - Semaforo Verde",cFunc)
			Return .T.
		EndIf

		DbSelectArea("SAK")
		DbSetOrder(1)
		MsSeek(xFilial("SAK")+SCR->CR_APROV)
		
		If Empty(SAK->AK_APROSUP) .And. cOpc $ "T" // Tentativa de transferencia para superior

			U_Console("2 - Tentativa de transferencia da aprovacao para o Superior falhou."+;
			          " Superior nao informado no cadastro do aprovador (Cod Usuar): " + SCR->CR_USER +;
			          " " +SCR->CR_TIPO + " no.: " + RTrim(SCR->CR_NUM),cFunc)

			SCR->(Reclock("SCR",.F.))
				SCR->CR_WF		 := " "			// 2 - respondido
				SCR->CR_STATUS := "02"			// Status 02 - em aprovacao
			SCR->(MsUnlock())

			SX3->(DbSetOrder(2), DbSeek("AK_APROSUP"), X3Titulo( "AK_APROSUP" ) )

			// Envia Notificacao ao usuario de falha no processo
			cSubject := "Transferencia de Pedidos de Compras: " + SCR->CR_FILIAL +'/'+ AllTrim(SCR->CR_NUM)
			cTitle   := 'Tentativa de transferencia de alcada superior Invalida'
			cBody    := 'Sr(a) '+UsrFullName(SCR->CR_USER)+', nao ha aprovador superior relacionado ao seu codigo de aprovador. '
			cBody    += 'Este pedido lhe será reenviado para aprovação.'
			cBody    += 'DICA: Verifique o seu cadastro de aprovador no campo "'+X3Titulo( "AK_APROSUP" )+'". '
			cTo      := SCR->CR_USER // Mandar para o Aprovador
			U_EnviaNotif( cSubject, cTitle, cBody, cTo )
			
			Return
		EndIf
		
		// Verifica se o pedido de compra esta aprovado; Se estiver, finaliza o processo
		dbSelectArea("SC7")
		dbSetOrder(1)
		dbSeek(xFilial("SC7")+Alltrim(SCR->CR_NUM))
		
		IF SC7->C7_CONAPRO <> "B"  // NAO ESTIVER BLOQUEADO
			U_Console("2 - Pedido de Compra já estava liberado. Processo abortado!"+;
			          " "+SCR->CR_TIPO + " no.: " + RTrim(SCR->CR_NUM),cFunc )
			U_Console("2 - Semaforo Verde",cFunc)
			Return .T.
		ENDIF
		
		// RePosiciona na tabela de Alcadas
		DbSelectArea("SCR")
		DbSetOrder(2)
		DbSeek(cChaveSCR)
		
		// verifica quanto a saldo de alçada para aprovação
		// Se valor do pedido estiver dentro do limite Maximo e minimo
		// Do aprovador , utiliza o controle de saldos, caso contrário nao
		// faz o tratamento como vistador.
		
		DbSelectArea("SAL")
		DbSetOrder(3)
		DbSeek(xFilial("SAL")+SC7->C7_APROV+SCR->CR_APROV)
		
		If SAL->AL_LIBAPR == "A" .AND. MaAlcLim(SCR->CR_APROV,SCR->CR_TOTAL,SCR->CR_MOEDA,SCR->CR_TXMOEDA) .AND. EMPTY(cWF)
			aRetSaldo 	:= MaSalAlc(SCR->CR_APROV,dDataBase) 	// Funcao do PADRÃO
			nSaldo 	 	:= aRetSaldo[1]
			CRoeda 	 	:= A097Moeda(aRetSaldo[2])				// Funcao do PADRÃO
			nTotal   	:= xMoeda(SCR->CR_TOTAL,SCR->CR_MOEDA,aRetSaldo[2],SCR->CR_EMISSAO,,SCR->CR_TXMOEDA)
			
			nSalDif := nSaldo - nTotal
			If (nSalDif) < 0
				Reclock("SCR",.F.)
				SCR->CR_WF		:= "3" // Status 3 - rejeitado por saldo
				MSUnlock()
			EndIf
		EndIf

		//U_Console("WKFL010:: 2 - Antes de reposicionar - SCR->(Recno()): " + Str(SCR->(Recno())) )
		// RePosiciona na tabela de Alcadas
		DbSelectArea("SCR")
		SCR->( DbSetOrder(2), DbSeek(cChaveSCR) )
		//U_Console("WKFL010:: 2 - Apos reposicionar - SCR->(Recno()): " + Str(SCR->(Recno())) )

        If cOpc $ "S|N"		// S-Aprovacao - N-Reprovacao
			lLiberou := U_MaAlcDoc({SCR->CR_NUM,"PC",nTotal,SCR->CR_APROV,,SC7->C7_APROV,,,,,cObs},dDataBase,If(cOpc$"S",4,6), cWF)
		Else    			// T-Transferencia para Superior
			lLiberou := U_MaAlcDoc({SCR->CR_NUM,"PC",nTotal,SCR->CR_APROV,,SC7->C7_APROV,,,,,cObs},dDataBase,2, cWF)
		EndIf
		
		_lProcesso := .T.

		// RePosiciona na tabela de Alcadas
		SCR->( DbSetOrder(2), DbSeek(cChaveSCR) )
		
		If lLiberou
			dbSelectArea("SC7")
			dbSetOrder(1)
			dbSeek(xFilial()+Alltrim(SCR->CR_NUM))
			While !Eof() .And. SC7->C7_FILIAL+SC7->C7_NUM == SCR->CR_FILIAL+RTrim(SCR->CR_NUM)
				Reclock("SC7",.F.)
					SC7->C7_CONAPRO := "L"
				MsUnlock()
				dbSkip()
			EndDo
		EndIf
	Else
		U_Console("2 - Resposta Invalida. Aprovacao diferente se 'S/N/T'. O processo sera reenviado para aprovacao."+;
		          " Parametros recebidos ==> cChaveSCR: " + cChaveSCR + " / cOpc: " + cOpc,cFunc)
		U_Console("2 - Semaforo Verde",cFunc)

		SCR->(Reclock("SCR",.F.))
			SCR->CR_WF		 := " "			// 2 - respondido
			SCR->CR_STATUS := "02"			// Status 02 - em aprovacao
		SCR->(MsUnlock())

	EndIf
	
/*-------------------------------------------------------------------------+
|  3 - Envia resposta de pedido bloqueado para o comprador                 |                                             
+--------------------------------------------------------------------------*/
ElseIf  _nOpc == 3

	U_Console("3 - Envia resposta de pedido bloqueado para o comprador",cFunc)
	
	ChkFile("SC7")			// Pedido de Compras
	ChkFile("SCR")  			// Documentos com alçadas

	If Select(cAlias) > 0
		(cAlias)->(dbCloseArea())
	Endif

	cFiltro := "%" + " and CR_WF in (' ','2') "						// ' '-Reprovado manualmente / 2-reprovado via workflow
	cFiltro +=       " and CR_STATUS = '04' "							// Reprovado
	cFiltro +=  	   " and ltrim(rtrim(CR_LIBAPRO)) <> '' " + "%"	// Seleciona o Aprovador que reprovou

	BeginSQL Alias cAlias
		select *
		from %Table:SCR% SCR
		where CR_FILIAL  = %xFilial:SCR%
		  and CR_TIPO    = 'PC'
		  and SCR.%NotDel%
		  %Exp:cFiltro%
		order by CR_FILIAL, CR_TIPO, CR_NUM, CR_NIVEL, CR_USER
	EndSQL

	DbSelectArea(cAlias)
	(cAlias)->(DbGoTop())
	
	While !(cAlias)->(Eof())
		U_Console("3 - Pedido Reprovados Encontrados => Iniciando Envio de Notificacao: "+(cAlias)->CR_TIPO+" no."+AllTrim((cAlias)->CR_NUM),cFunc)

		_cWFId 	:= AVW10EnvPC((cAlias)->CR_FILIAL, (cAlias)->CR_NUM, (cAlias)->CR_USER, (cAlias)->CR_APROV, (cAlias)->(CR_FILIAL+CR_TIPO+CR_NUM+CR_USER), (cAlias)->CR_TOTAL, "4")
		
		DbSelectarea("SCR")
		DbSetOrder(2)
		//DbGoTo( (cAlias)->(Recno()) )
		//If !SCR->(Eof())
		If DbSeek((cAlias)->(CR_FILIAL+CR_TIPO+CR_NUM+CR_USER))
			Reclock("SCR",.F.)
				SCR->CR_WF		 := "1"			// Status 1 - envio email
				SCR->CR_X_WFID := _cWFId		// Rastreabilidade
			MSUnlock()
		ENDIF
		
		_lProcesso := .T.
		(cAlias)->(DbSkip())
	EndDo
	
	dbSelectArea(cAlias)
	//dbClearFilter()
	dbCloseArea()

/*-------------------------------------------------------------------------+
|  4 - Processa O RETORNO DO EMAIL DE PC REPROVADO                         |                                             
+--------------------------------------------------------------------------*/
ElseIf  _nOPC	== 4
	
	U_Console("4 - Processa O RETORNO DO EMAIL DE PC REPROVADO",cFunc)
	U_Console("4 - Semaforo Vermelho",cFunc)

	ChkFile("SCR")
	ChkFile("SAL")
	ChkFile("SC7")
	ChkFile("SCS")
	ChkFile("SAK")
	ChkFile("SM2")
	
	If oProcess <> nil
		cFilAnt		:= AllTrim(oProcess:oHtml:RetByName("CFILANT"))
		cChaveSCR	:= AllTrim(oProcess:oHtml:RetByName("CHAVE"))
		cOpc     	:= AllTrim(oProcess:oHtml:RetByName("OPC"))
		cWFID     	:= AllTrim(oProcess:oHtml:RetByName("WFID"))

		U_Console("4 - cChaveSCR: " + cChaveSCR,cFunc)
	
		oProcess:Finish() // FINALIZA O PROCESSO
	ENDIF
	
	// Posiciona na tabela de Alcadas
	DbSelectArea("SCR")
	DbSetOrder(2)
	DbSeek(cChaveSCR)

	//DbGoTo(cChaveSCR)
	If !Found()
		U_Console("4 - Nao encontrado registro no SCR (Aprovacao) correspondente a Chave do processo. Abortado!",cFunc)
		Return .T.
	Endif

	If SCR->(Eof()) .OR. TRIM(SCR->CR_X_WFID) <> TRIM(cWFID)
		// Este processo nao foi encontrado e portanto deve ser descartado
		// abre uma notificacao a pessoa que respondeu
		U_Console("4 - O Email respondido nao corresponde a ultima revisao do pedido de compras. ID do Processo (cWFID) nao corresponde ao SCR->CR_X_WFID.",cFunc)
		U_Console("4 - Semaforo Verde",cFunc)
		Return .T.
	EndIf
	
	Reclock("SCR",.F.)
		SCR->CR_WF		:= "2"	// Status 2 - respondido
	MSUnlock()
	
	dbSelectArea("SC7")
	dbSetOrder(1)
	dbSeek(xFilial()+Alltrim(SCR->CR_NUM))
	
	IF !FOUND()
		U_Console("4 - Nao encontrado PEDIDO DE COMPRA relacionado ao processo de aprovacao."+;
		          " "+SCR->CR_TIPO+" no."+AllTrim(SCR->CR_NUM),cFunc)
		U_Console("4 - Semaforo Verde",cFunc)
		Return .T.
	ENDIF
	
	IF cOpc	== "S"  // Submete o pedido de compra a nova aprovação ?
		lEstorna := U_MaAlcDoc({SCR->CR_NUM,"PC",SCR->CR_TOTAL,SCR->CR_LIBAPRO,,SC7->C7_APROV},SC7->C7_EMISSAO,5)
		
		_lProcesso := .T.
		
		dbSelectArea("SC7")
		dbSetOrder(1)
		dbSeek(xFilial()+Alltrim(SCR->CR_NUM))
		
		// NUMERO DE VEZES EM QUE ESSE PC ESTA SENDO SUBMETIDO A UMA NOVA APROVACAO
		
		While !SC7->(Eof()) .And. SC7->C7_FILIAL+SC7->C7_NUM == SCR->CR_FILIAL+TRIM(SCR->CR_NUM)
			Reclock("SC7",.F.)
				SC7->C7_CONAPRO := "B"
			MsUnlock()
			SC7->(DbSkip())
		EndDo
	EndIf
	
	U_Console("4 - Semaforo Verde",cFunc)
	
/*-------------------------------------------------------------------------+
| 5 - Envia resposta de pedido aprovado para o comprador                   |                                             
+--------------------------------------------------------------------------*/
ElseIf  _nOpc == 5
	
	U_Console("5 - Envia resposta de pedido APROVADO para o comprador",cFunc)
	
	ChkFile("SCR")              // Documentos com alçadas
	ChkFile("SC7")				// Pedido de Compra
	Chkfile("SC7",, cAlias)		// Pedido de Compras
	
	/*---------------------------------------------------------+
	| C7_X_WF -> Controle de Envio de Notificação do PC por E-mail 
	|   ' ' = não enviado
	|    1  = enviado para comprador somente
	|    2  = enviado para fornecedor somente
	|    3  = enviado para ambos, comprador e fornecedor
	+---------------------------------------------------------*/

	If Select(cAlias) > 0
		(cAlias)->(dbCloseArea())
	Endif
	
	BeginSQL Alias cAlias
		select * 
		from %Table:SC7% SC7
		where C7_FILIAL  = %xFilial:SC7%
		  and C7_TIPO    = 1
		  and C7_CONAPRO = 'L'
		  and C7_X_WF not in ('1','3')
		  and SC7.%NotDel%
		order by C7_FILIAL, C7_NUM, C7_ITEM
	EndSQL

	DbSelectArea(cAlias)
	(cAlias)->(DbGoTop())

	While !(cAlias)->(Eof())
		
		_cNum	:= (cAlias)->C7_NUM
		_cWFID := ""
		
		DBSelectarea("SCR")
		DBSetOrder(1)
		DBSeek((cAlias)->(C7_FILIAL+"PC"+C7_NUM),.T.)
		
		IF (cAlias)->C7_FILIAL == SCR->CR_FILIAL 	.and. ;
			SCR->CR_TIPO 	== "PC" 			.AND. ;
			TRIM((cAlias)->C7_NUM) 	== TRIM(SCR->CR_NUM)
			
			_cWFId 	:= AVW10EnvPC((cAlias)->C7_FILIAL, (cAlias)->C7_NUM, (cAlias)->C7_USER,, SCR->(CR_FILIAL+CR_TIPO+CR_NUM+CR_USER), SCR->CR_TOTAL, "5")
			_lProcesso := .T.
		Else
			(cAlias)->(DbSkip())
		ENDIF
		
		While !(cAlias)->(EOF()) .AND. _cNum == (cAlias)->C7_NUM .AND. !EMPTY(_cWFID)
			_cNum	:= (cAlias)->C7_NUM
			
			DbSelectarea("SC7")
			DbSetOrder(1)
			IF DBSeek((cAlias)->(C7_FILIAL+C7_NUM+C7_ITEM+C7_SEQUEN))
				Reclock("SC7",.F.)
				If SC7->C7_X_WF == " "			// ' ' = não enviado
					SC7->C7_X_WF	:= "1"			//  1  = enviado para o comprador somente
				ElseIf SC7->C7_X_WF == "2"			//  2  = enviado para o fornecedor somente
					SC7->C7_X_WF	:= "3"			//  3  = enviado para ambos, comprador e fornecedor
				EndIf
				SC7->C7_X_WFID		:= _cWFId		// Rastreabilidade
				MSUnlock()
			ENDIF
			
			(cAlias)->(DBSkip())
		ENDDo
	EndDo
	
	(cAlias)->(DbCloseArea())
	
/*---------------------------------------------------------+
| 6 - Envia Pedido de Compra Liberado para Fornecedor
+---------------------------------------------------------*/
ElseIf _nOpc == 6
	

	U_Console("6 - Envia Pedido de Compra Liberado para Fornecedor",cFunc)
	
	ChkFile("SCR")              // Documentos com alçadas
	ChkFile("SC7")				// Pedido de Compra
	Chkfile("SC7",, cAlias)		// Pedido de Compras
	
	// Seleciona os registros do SCR - DBF / INDREGUA
	// Abre um novo Alias para evitar problemas com filtros ja existentes.
	
	If Select(cAlias) > 0
		(cAlias)->(dbCloseArea())
	Endif
	
	If !Empty(pcPedido)															// Quando vier pelo menu
		cFiltro :=  "%" + " rtrim(C7_NUM) = '"+pcPedido+"' " + "%"
	Else
		cFiltro :=  "%" + " C7_X_WF not in ('2','3') " + "%"					// Em aprovação
	EndIf		

	/*---------------------------------------------------------+
	| C7_X_WF -> Controle de Envio de Notificação do PC por E-mail 
	|   ' ' = não enviado
	|    1  = enviado para comprador somente
	|    2  = enviado para fornecedor somente
	|    3  = enviado para ambos, comprador e fornecedor
	+---------------------------------------------------------*/

	BeginSQL Alias cAlias
		select * 
		from %Table:SC7% SC7
		where C7_FILIAL  = %xFilial:SC7%
		  and C7_TIPO    = 1
		  and C7_CONAPRO = 'L'
		  and %Exp:cFiltro%
		  and SC7.%NotDel%
		order by C7_FILIAL, C7_NUM, C7_ITEM
	EndSQL

	DbSelectArea(cAlias)
	(cAlias)->(DbGoTop())

	If !Empty(pcPedido)
		If (cAlias)->(Eof())
			U_Console("6 - Processamento pelo Menu => Nao houve Processamento: PC/AE no."+AllTrim(pcPedido),cFunc)
			If !IsBlind() 						// Quando vier pelo menu
				MsgStop("Este Pedido de Compra não está Liberado, e portanto não pode ser enviado ao fornecedor."+Chr(13)+Chr(10)+;
						"Consulte o status do documento.","Pedido não liberado")
			EndIf
			(cAlias)->(DbCloseArea())
			SC7->(RestArea(aAreaSC7))
			RestArea(aAreaAnt)
			Return
		EndIf
	EndIf
	
	While !(cAlias)->(Eof())
		
		_cNum	:= (cAlias)->C7_NUM
		_cWFID	:= ""
		
		DBSelectarea("SCR")
		SCR->(DBSetOrder(1), DBSeek((cAlias)->(C7_FILIAL+"PC"+C7_NUM),.T.))
		
		If (cAlias)->C7_FILIAL == SCR->CR_FILIAL .and. SCR->CR_TIPO == "PC" .and. (cAlias)->C7_NUM == Left(SCR->CR_NUM,TamSX3("C7_NUM")[1])			
			_cWFId 	:= AVW10EnvPC((cAlias)->C7_FILIAL, (cAlias)->C7_NUM, (cAlias)->C7_USER,, SCR->(CR_FILIAL+CR_TIPO+CR_NUM+CR_USER), SCR->CR_TOTAL,"6",cMailCC)
			_lProcesso := .T.
		Else
			(cAlias)->(DbSkip())
		ENDIF
		
		While !(cAlias)->(EOF()) .AND. _cNum == (cAlias)->C7_NUM .AND. !EMPTY(_cWFID)
			_cNum	:= (cAlias)->C7_NUM
			
			DbSelectarea("SC7")
			DbSetOrder(1)
			IF DBSeek((cAlias)->(C7_FILIAL+C7_NUM+C7_ITEM+C7_SEQUEN))
				Reclock("SC7",.F.)
				If SC7->C7_X_WF == " "			// ' ' = não enviado
					SC7->C7_X_WF	:= "2"			//  2  = enviado para o fornecedor somente
				ElseIf SC7->C7_X_WF == "1"		//  1  = enviado para o comprador somente
					SC7->C7_X_WF	:= "3"			//  3  = enviado para ambos, comprador e fornecedor
				EndIf
				MSUnlock()
			ENDIF
			
			(cAlias)->(DBSkip())
		ENDDo
	EndDo
	
	(cAlias)->(DbCloseArea())
	
EndIf

IF 	_lProcesso
	U_Console(LTrim(Str(_nOpc)) + " - Mensagem processada",cFunc)
ELSE
	U_Console(LTrim(Str(_nOpc)) + " - Nao houve processamento",cFunc)
ENDIF

RETURN

/*----------------------+--------------------------------+------------------+
|   Programa: AVW10EnvPC| Autor: Kley@TOTVS              | Data: 28/04/2014 |
+-----------------------+--------------------------------+------------------+
|  Descricao:  Workflow de Pedido de Compra
|              _cWF ' ' - Envia email para aprovador
|              _cWF '3' - Reenvia email para aprovador, foi rejeitado por insuficiencia de saldo
|              _cWF '4' - Envia email para o comprador informando que o PC está reprovado
|              _cWF '5' - Envia email para o comprador informando que o PC está aprovado
|          	 _cWF '6' - Envia email do Pedido de Compra para o Fornecedor
+---------------------------------------------------------------------------+
|    Projeto:  AVANT
+---------------------------------------------------------------------------+
|    Sintaxe:  U_AVW10EnvPC(_cFilial,_cNum, _cUser, _cAprov, _cChave, _nTotal, _cWF, cMailCC)
+----------------------------------------------------------------------------
|    Retorno:  ID do Workflow                                                               
+--------------------------------------------------------------------------*/

Static Function AVW10EnvPC(_cFilial,_cNum, _cUser, _cAprov, _cChave, _nTotal, _cWF, cMailCC)

Local lObs	     	:= .F.
Local nTotPed  	:= 0, nTotDesc := 0, nTotGer := 0, nTotIPI := 0, nTotFre := 0, nTotDesp := 0, nTotSeg := 0
Local cNum     	:= RTrim(_cNum)
Local cChaveSCR	:= Substr(_cChave, 1, 54)
Local cSituacao	:= ""
Local cFunc	 	:= "U_AVCOMW10::AVW10EnvPC"
Local _cWfDir  	:= "\workflow\"
Local cDirHtml 	:= "html\"
Local aDirHtml 	:= {}
Local _cProcesso	:= ""

ChkFile("SE4")
ChkFile("SC1")
ChkFile("SC8")
ChkFile("SA2")
ChkFile("SB1")
ChkFile("SBM")

SBM->( DbSetOrder(1) )
SB1->( DbSetOrder(1) )
SC7->( DbSetOrder(1), DbSeek( xFilial('SC7')+cNum ) )
SA2->( DbSetOrder(1), DbSeek( xFilial('SA2')+SC7->(C7_FORNECE+C7_LOJA) ) )
SE4->( DbSetOrder(1), DbSeek( xFilial('SE4')+SC7->C7_COND ) )
SY1->( DbSetOrder(3), DbSeek( xFilial('SY1')+SC7->C7_USER ) )					// Y1_FILIAL+Y1_USER

//- " " -> ENVIO - 3 -> RENVIO DE EMAIL PARA REAPROVAÇÃO
//- 4-> ENVIO PARA COMPRADOR(REPROVADO) - 5 -> ENVIO PARA COMPRADOR(APROVADO)

// Verifica e cria, se necessario, o diretorio para gravacao do HTML
aDirHtml   := Directory(_cWfDir+"emp"+cEmpAnt+"\*.*", "D",Nil,.T.)
If aScan( aDirHtml, {|aDir| aDir[1] == Upper( Iif(Right(cDirHtml,1)=="\", Left(cDirHtml,Len(cDirHtml)-1), cDirHtml) ) } ) == 0
	If MakeDir(_cWfDir+"emp"+cEmpAnt+"\"+cDirHtml)	 == 0
		U_Console("Diretorio dos HTML's criado com sucesso. -> "+_cWfDir+"emp"+cEmpAnt+"\"+cDirHtml,cFunc)
	Else
		U_Console("Erro na criacao do diretorio dos HTML's! -> "+_cWfDir+"emp"+cEmpAnt+"\"+cDirHtml,cFunc)
		cDirHtml := "temp\"
	EndIf
EndIf

/*--------------------------------------------------------+
| Cria objeto oProcess e busca modelo HTML                |
+---------------------------------------------------------*/
oProcess := TWFProcess():New( "000001", "Pedido de Compra" )
If EMPTY(_cWF)
	oProcess          	:NewTask( "Envio PC : "+_cFilial + cNum, _cWfDir + "Compras\PcAprov.htm" )
	oProcess:cSubject 	:= "Aprovacao de Pedido de Compras fil/no."+RTrim(SC7->C7_FILIAL)+"/"+SC7->C7_NUM
	oProcess:bReturn  	:= "U_AVCOMW10(2,'')"
	oProcess:cTo      	:= UsrRetMail(_cUser)
ElseIf TRIM(_cWF) $ "1|3"
	oProcess          	:NewTask( "Envio PC : "+_cFilial + cNum, _cWfDir + "Compras\PcAprov.htm" )
	oProcess:cSubject 	:= "REAprovacao de Pedido de Compras fil/no."+RTrim(SC7->C7_FILIAL)+"/"+SC7->C7_NUM
	oProcess:bReturn  	:= "U_AVCOMW10(2,'')"
	oProcess:cTo      	:= UsrRetMail(_cUser)
ElseIf TRIM(_cWF) == "4"
	oProcess          	:NewTask( "Envio PC : "+_cFilial + cNum, _cWfDir + "Compras\PcNotif.htm" )
	oProcess:cSubject 	:= "Notificacao de Pedido de Compra REPROVADO fil/no."+RTrim(SC7->C7_FILIAL)+"/"+SC7->C7_NUM
	oProcess:cTo      	:= UsrRetMail(SC7->C7_USER)
	cSituacao			:= '<font color="#CC0000">REPROVADO</font>'
ElseIf TRIM(_cWF) == "5"
	oProcess          	:NewTask( "Envio PC : "+_cFilial + cNum, _cWfDir + "Compras\PcNotif.htm" )
	oProcess:cSubject 	:= "Notificacao de Pedido de Compra APROVADO fil/no."+RTrim(SC7->C7_FILIAL)+"/"+SC7->C7_NUM
	oProcess:cTo      	:= UsrRetMail(SC7->C7_USER)
	cSituacao			:= '<font color="#0000FF">APROVADO</font>'
ElseIf TRIM(_cWF) == "6"
	oProcess          	:NewTask( "Envio PC ao Fornecedor : "+_cFilial + cNum, _cWfDir + "Compras\PcFornec.htm" )
	oProcess:cSubject 	:= "Pedido de Compra fil./no."+RTrim(SC7->C7_FILIAL)+"/"+SC7->C7_NUM
	If Empty(SA2->A2_EMAIL)
		oProcess:cTo		:= Iif(!Empty(cMailCC),cMailCC,"")
	Else
		oProcess:cTo		:= SA2->A2_EMAIL
		oProcess:cCc		:= Iif(!Empty(cMailCC),cMailCC,"")
	EndIf
	oProcess:NewVersion(.T.)
	_cProcesso			:= "Pedido de Compra"
EndIf

oProcess:UserSiga	:= _cUser	&&SC7->C7_USER
oProcess:NewVersion(.T.)
lObs		 		:= .T.
oHtml     			:= oProcess:oHTML

/*--------------------------------------------------------+
| Preenche dados do CABEÇALHO do Pedido de Compra         |
+---------------------------------------------------------*/
oHtml:ValByName( "C7_FILIAL"	, SC7->C7_FILIAL )
oHtml:ValByName( "C7_NUM"		, SC7->C7_NUM )

If Trim(_cWF) $ "4|5"
	oHtml:ValByName( "SITUACAO"		, cSituacao )
EndIf

If Trim(_cWF) # "6"
	oHtml:ValByName( "C7_EMISSAO"	, DTOC(SC7->C7_EMISSAO) )
	oHtml:ValByName( "CR_USER"		, UsrFullName(_cUser))
	oHtml:ValByName( "C7_USER"		, UsrFullName(SC7->C7_USER))
	oHtml:ValByName( "E4_DESCRI"    , SE4->E4_DESCRI)
	oHtml:ValByName( "A2_NOME"		, SA2->A2_NOME + " " + SA2->A2_COD)
	If SC7->C7_MOEDA == 0
		oHtml:ValByName( "MOEDA"  		, " - ")
	Else
		oHtml:ValByName( "MOEDA"  		, GETMV('MV_SIMB'+StrZero(SC7->C7_MOEDA,1))+' - '+GETMV('MV_MOEDA'+StrZero(SC7->C7_MOEDA,1)) )
	EndIf
	
	//oHtml:ValByName( "ENCARGO"		, TRANSFORM(SC7->C7_EF, PesqPict("SC7","C7_EF") ) )
	oHtml:ValByName( "ENCARGO"		, TRANSFORM(0,'@E 999,999.999'))
Else
	// Local para Faturamento e Cobrança
	oHtml:ValByName( "COB_RAZAOSOCIAL"   	, U_SM0Filiais(Iif(Empty(SC7->C7_FILIAL),SC7->C7_FILENT,SC7->C7_FILIAL), "M0_NOMECOM") )
	oHtml:ValByName( "COB_ENDERECO"			, U_SM0Filiais(Iif(Empty(SC7->C7_FILIAL),SC7->C7_FILENT,SC7->C7_FILIAL), "M0_ENDCOB") )
	oHtml:ValByName( "COB_CEP"   			, U_SM0Filiais(Iif(Empty(SC7->C7_FILIAL),SC7->C7_FILENT,SC7->C7_FILIAL), "M0_CEPCOB") )
	oHtml:ValByName( "COB_CIDADE" 			, RTrim(U_SM0Filiais(Iif(Empty(SC7->C7_FILIAL),SC7->C7_FILENT,SC7->C7_FILIAL), "M0_CIDCOB")) )
	oHtml:ValByName( "COB_ESTADOPAIS" 		, U_SM0Filiais(Iif(Empty(SC7->C7_FILIAL),SC7->C7_FILENT,SC7->C7_FILIAL), "M0_ESTCOB") + " / BRASIL" )
	oHtml:ValByName( "COB_CNPJ"				, U_SM0Filiais(Iif(Empty(SC7->C7_FILIAL),SC7->C7_FILENT,SC7->C7_FILIAL), "M0_CGC") )
	oHtml:ValByName( "COB_COMPRADOR"		, SY1->Y1_NOME )
	oHtml:ValByName( "COB_TELEFONE"			, SY1->Y1_TEL )
	oHtml:ValByName( "COB_EMAIL"			, SY1->Y1_EMAIL )
	// Dados do fornecedor
	oHtml:ValByName( "FOR_RAZAOSOCIAL"		, SA2->A2_NOME )
	oHtml:ValByName( "FOR_ENDERECO"			, SA2->A2_END )
	oHtml:ValByName( "FOR_CEP"				, SA2->A2_CEP )
	oHtml:ValByName( "FOR_CIDADE"			, Alltrim(SA2->A2_MUN) )
	oHtml:ValByName( "FOR_ESTADOPAIS"		, SA2->A2_EST + " / " + E_Field("A2_PAIS","YA_DESCR") )
	oHtml:ValByName( "FOR_CNPJ"				, SA2->A2_CGC )
	oHtml:ValByName( "FOR_CONTATO"			, SA2->A2_CONTATO )
	oHtml:ValByName( "FOR_TELEFONE"			, SA2->A2_TEL )
	oHtml:ValByName( "FOR_EMAIL"			, SA2->A2_EMAIL )	
EndIf

If Empty(_cWF) .Or. Trim(_cWF) $ "1|2|3"
	oHtml:ValByName( "OBS"	    , "" )
	// Hidden Fields
	oHtml:ValByName( "CHAVE"	    , _cChave)
	//oHtml:ValByName( "CHAVE"	    , (cAlias)->(Recno()) )
	oHtml:ValByName( "CFILANT"	    , cFilAnt)
	oHtml:ValByName( "WF"   		, TRIM(_cWF))
	oHtml:ValByName( "WFID"			, oProcess:fProcessId)
EndIf

/*--------------------------------------------------------+
| Preenche dados dos ITENS do Pedido de Compra            |
+---------------------------------------------------------*/
While !SC7->(EOF()) .AND. SC7->(C7_FILIAL+C7_NUM) == _cFilial+cNum
	
	SB1->( DBSeek(xFilial('SBM')+SC7->C7_PRODUTO) )
	SBM->( DBSeek(xFilial('SB1')+SB1->B1_GRUPO) )
	
	If Trim(_cWF) # "6"
		AAdd( (oHtml:ValByName( "t1.1"    )), SC7->C7_ITEM)
		AAdd( (oHtml:ValByName( "t1.2"    )), SC7->C7_PRODUTO)
		AAdd( (oHtml:ValByName( "t1.3"    )), SC7->C7_DESCRI)
		AAdd( (oHtml:ValByName( "t1.4"    )), SC7->C7_UM)
		AAdd( (oHtml:ValByName( "t1.5"    )), TRANSFORM(SC7->C7_QUANT,'@E 999,999.999'))
		// Historico dos 3 Precos:
		aPrecos := U_BuscaPrc( SC7->C7_FILIAL, SC7->C7_PRODUTO )
		
	    //AAdd( (oHtml:ValByName( "t1.6"    )), TRANSFORM(aPrecos[1],'@E 999,999.99'))
	    AAdd( (oHtml:ValByName( "t1.6"    )), SC7->C7_CC)
		AAdd( (oHtml:ValByName( "t1.7"    )), TRANSFORM(aPrecos[2],'@E 999,999.99'))
		AAdd( (oHtml:ValByName( "t1.8"    )), TRANSFORM(aPrecos[3],'@E 999,999.99'))
		AAdd( (oHtml:ValByName( "t1.9"    )), TRANSFORM(SC7->C7_PRECO,'@E 999,999.99'))
		
		// Obter a variacao de preco caso exista o ultimo preco para o produto:
		
		AAdd( (oHtml:ValByName( "t1.10"    )), TRANSFORM( ( ( SC7->C7_PRECO / aPrecos[3] ) * 100 ) - 100 ,'@E 999,999,999.9999'))
		AAdd( (oHtml:ValByName( "t1.11"    )), TRANSFORM(SC7->C7_PICM,'@E 99.99'))
		AAdd( (oHtml:ValByName( "t1.12"    )), TRANSFORM(SC7->C7_IPI,'@E 99.99'))
		AAdd( (oHtml:ValByName( "t1.13"    )), TRANSFORM(SC7->C7_TOTAL,'@E 99,999,999.99'))
		AAdd( (oHtml:ValByName( "t1.14"    )), SC7->C7_DATPRF)
	Else
		SB1->(dbSeek(xFilial("SB1") + SC7->C7_PRODUTO))

		AAdd( (oHtml:ValByName( "t1.1"  )), SC7->C7_ITEM)
		AAdd( (oHtml:ValByName( "t1.2"  )), SC7->C7_PRODUTO)
		AAdd( (oHtml:ValByName( "t1.3"  )), Alltrim(SB1->B1_DESC)) 
		AAdd( (oHtml:ValByName( "t1.4"  )), TransForm(SC7->C7_QUANT, PesqPict("SC7","C7_QUANT")))
		AAdd( (oHtml:ValByName( "t1.5"  )), SC7->C7_UM)
		AAdd( (oHtml:ValByName( "t1.6"  )), TransForm(SC7->C7_PRECO, PesqPict("SC7","C7_PRECO")))
		AAdd( (oHtml:ValByName( "t1.7"  )), TransForm(SC7->C7_TOTAL, PesqPict("SC7","C7_TOTAL")))
		AAdd( (oHtml:ValByName( "t1.8"  )), SC7->C7_DATPRF)
		AAdd( (oHtml:ValByName( "t1.9"  )), Alltrim(SB1->B1_DESC))
	EndIf
	
	nTotPed   += SC7->C7_TOTAL
	nTotDesc  += SC7->C7_VLDESC
	nTotGer   += ( SC7->C7_TOTAL+SC7->C7_VALIPI+SC7->C7_SEGURO+SC7->C7_DESPESA+SC7->C7_VALFRE )
	nTotIPI   += SC7->C7_VALIPI
	nTotFre   += SC7->C7_VALFRE
	nTotDesp  += SC7->C7_DESPESA
	nTotSeg   += SC7->C7_SEGURO
	
	SC7->(DbSkip())
	
Enddo

/*--------------------------------------------------------+
| Preenche dados dos TOTAIS do Pedido de Compra           |
+---------------------------------------------------------*/
oHtml:ValByName( "TOTPED"		, TRANSFORM(nTotPed,   PesqPict("SC7","C7_TOTAL") ) )

If Trim(_cWF) # "6"
	oHtml:ValByName( "DESCONTOS"   	, TRANSFORM(nTotDesc,  PesqPict("SC7","C7_VLDESC") ) )
	oHtml:ValByName( "TOTIPI"      	, TRANSFORM(nTotIPI,   PesqPict("SC7","C7_VALIPI") )  )
	oHtml:ValByName( "TOTFRETE"    	, TRANSFORM(nTotFRE,   PesqPict("SC7","C7_VALFRE") ) )
	oHtml:ValByName( "DESPESAS"    	, TRANSFORM(nTotDesp,  PesqPict("SC7","C7_DESPESA") ) )
	oHtml:ValByName( "TOTSEG"      	, TRANSFORM(nTotSEG,   PesqPict("SC7","C7_SEGURO") ) )
	oHtml:ValByName( "TOTGER"      	, TRANSFORM(nTotGER - nTotDesc,   PesqPict("SC7","C7_TOTAL") ) )
EndIf

/*--------------------------------------------------------+
| Preenche dados do PROCESSO DE APROVAÇÃO do Ped. Compra  |
+---------------------------------------------------------*/
If Trim(_cWF) # "6"
	SC7->( DbSeek(xFilial('SC7')+cNum) )
	SAL->( DbSetOrder(3) ) // Grupo + Aprovador
	SCR->( DbSetOrder(1), DbSeek(cChaveSCR,.T.) )
	
	While !SCR->(Eof()) .AND. AllTrim(SCR->(CR_FILIAL+CR_TIPO+CR_NUM)) == AllTrim(cChaveSCR)
		cSituaca := ""
		
		// Posicionar no SAL para identificar o tipo de aprovacao do aprovador
		// referente ao item atual:
		
		// CR_USERLIB = Codigo do Usuario Aprovador
		// C7_APROV   = Codigo do Grupo de Aprovacao no Pedido de Vendas
		
		SAL->( DbSeek(xFilial('SAL')+SC7->C7_APROV+SCR->CR_LIBAPRO) )
		
		Do Case
			Case SCR->CR_STATUS == "01"
				cSituaca := 'Aguardando'
			Case SCR->CR_STATUS == "02"
				cSituaca := 'Em Aprovacao'
			Case SCR->CR_STATUS == "03"
				If SAL->AL_LIBAPR == 'V'
					cSituaca := 'Vistado'
				Else
					cSituaca := 'Aprovado'
				EndIf
			Case SCR->CR_STATUS == "04"
				cSituaca := 'Bloqueado'
			Case SCR->CR_STATUS == "05"
				cSituaca := 'Nivel Liberado'
		EndCase
		
		_cT4 := UsrRetName(SCR->CR_USERLIB)
		If SCR->( FieldPos('CR_WFOBS') ) > 0
			_cT6 := SCR->CR_WFOBS
		Else
			_cT6 := SCR->CR_OBS
		EndIf
		
		AAdd( (oHtml:ValByName( "t.1"    )), SCR->CR_NIVEL)
		AAdd( (oHtml:ValByName( "t.2"    )), UsrFullName(SCR->CR_USER))
		AAdd( (oHtml:ValByName( "t.3"    )), cSituaca    )
		AAdd( (oHtml:ValByName( "t.4"    )), IIF(EMPTY(_cT4),"", _cT4))
		AAdd( (oHtml:ValByName( "t.5"    )), DTOC(SCR->CR_DATALIB))
		AAdd( (oHtml:ValByName( "t.6"    )), IIF(EMPTY(_cT6),"", _cT6))
		
		SCR->(DBSkip())
		
	ENDDO
EndIf

/*-------------------------------------------------------------------------+
| OBSERVACAO - SOLICITACAO DE COMPRAS                                      |                                             
+--------------------------------------------------------------------------*/
If Trim(_cWF) # "6"
	IF lOBS
		aViewSC1 := MontaSC(cNum)
		
		if Len(aViewSC1) > 0
			For nLin := 1 TO LEN(aViewSC1)
				AAdd( (oHtml:ValByName( "t2.1"    )), aViewSC1[nLin])
			Next
		Else
			AAdd( (oHtml:ValByName( "t2.1"    )), "Nao ha observacoes")
		EndIf
	ENDIF
EndIf

/*--------------------------------------------------------+
| Preenche dados do RODAPÉ do PED.COMPRA AO FORNECEDOR    |
+---------------------------------------------------------*/
If Trim(_cWF) == "6"
	// Local de Entrega
	oHtml:ValByName( "LOC_RAZAOSOCIAL"   	, U_SM0Filiais(SC7->C7_FILENT, "M0_NOMECOM") )
	oHtml:ValByName( "LOC_ENDERECO"			, U_SM0Filiais(SC7->C7_FILENT, "M0_ENDENT") )
	oHtml:ValByName( "LOC_BAIRRO"   		, U_SM0Filiais(SC7->C7_FILENT, "M0_BAIRENT") )
	oHtml:ValByName( "LOC_CIDADE" 			, RTrim(U_SM0Filiais(SC7->C7_FILENT, "M0_CIDENT")) )
	oHtml:ValByName( "LOC_ESTADOPAIS" 		, U_SM0Filiais(SC7->C7_FILENT, "M0_ESTENT") + " / BRASIL" )
	// Condição de Pagamento
	oHtml:ValByName( "CONDICAOPAGTO"    	, SE4->E4_DESCRI)
EndIf

/*--------------------------------------------------------+
| Cria ID do Processo e faz o envio do e-mail             |
+---------------------------------------------------------*/
_cWFID := oProcess:fProcessId

If !TRIM(_cWF) $ "4|5|6"
	
	_cProcesso := "Segue link para aprovação de documento gerado pelo workflow do sistema Microsiga Protheus.<p>"+;
                  "Para visualização, por favor clique: "
	
	cOldTo  := oProcess:cTo
	cOldCC  := oProcess:cCC
	cOldBCC := oProcess:cBCC
	
	//Uso um endereco invalido, apenas para criar o processo de workflow, mas sem envia-lo
	oProcess:cTo  := NIL
	oProcess:cCC  := NIL
	oProcess:cBCC := NIL
	
	cMailId    := oProcess:Start(_cWfDir+"emp"+cEmpAnt+"\"+cDirHtml,.T.)
	//chtmlfile  := cmailid + ".htm"
	cHtmlFile  := "emp"+cEmpAnt+"\"+cDirHtml+cMailId + ".htm"
	If File(_cWfDir+cHtmlFile)
		U_Console("Arquivo HTML copiado com sucesso: "+_cWfDir+cHtmlFile,cFunc)
	Else
		U_Console("ATENCAO! Arquivo HTML NAO copiado: "+_cWfDir+cHtmlFile,cFunc)
	EndIf

	U_EnviaLink(cHtmlFile,cOldTo,cOldCC,cOldBCC,oProcess:cSubject,cFilAnt,'PC',cNum,_cProcesso,UsrFullName(_cUser))		//faz a criacao e envio do link para resposta
	
Else
	oProcess:Start()  // Crio o processo e gravo o ID do processo de Workflow
EndIf

Return _cWFId

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MontaSC   ºAutor  ³ Microsiga          º Data ³  08/15/02   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function MontaSC(cNumSC7)

Local aViewSC1 := {}, _aAreaSC7 := SC7->(GetArea())

SC7->( DbSetOrder(1), DbSeek(xFilial('SC7')+cNumSC7) )

While !SC7->(Eof()) .And. SC7->(C7_FILIAL+C7_NUM) == xFilial('SC7')+cNumSC7
	
	IF !Empty(ALLTRIM(SC7->C7_OBS))
		If Ascan(aViewSC1, SC7->C7_OBS)==0
			AADD(aViewSC1 ,SC7->C7_OBS)
		Endif
	ENDIF
	
	SC7->(DBSkip())
EndDo

SC7->(RestArea(_aAreaSC7))

Return aViewSC1
