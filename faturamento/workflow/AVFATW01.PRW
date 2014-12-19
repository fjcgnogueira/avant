#include "TOTVS.ch"
#include "rwmake.ch"
#include "TbiConn.ch"
#include "TbiCode.ch"
#include "TopConn.ch"

/*----------------------+--------------------------------+------------------+
|   Programa: AVFATW01  | Autor: Kley@TOTVS              | Data: Julho/2014 |
+-----------------------+--------------------------------+------------------+
|  Descricao: Programa que efetua o envio/recebimento do processo de
|             Aprovacao de Pedidos de Vendas.
|             Efetua tambem as notificacoes de pedidos rejeitados e ou
|             aprovados.
+---------------------------------------------------------------------------+
|    Projeto: AVANT
+---------------------------------------------------------------------------+
|    Sintaxe: U_AVFTW101()
+----------------------------------------------------------------------------
|    Retorno: Nulo                                                               
+--------------------------------------------------------------------------*/

/*-------------------------------------------------------------------------+
|  Processa todas as atividades por Empresa                                |                                            
+--------------------------------------------------------------------------*/
User Function AVFTW101()				//Empresa "01"

Private _aMatriz  := {"01","010104"}  

ConOut("["+DtoC(Date()) + ' ' + Time()+"] [U_AVFTW101] Inicio do processamento - Workflow PV.")

RpcSetType(3)
RpcSetEnv(_aMatriz[1],_aMatriz[2])
U_AVFATW01(1)  		// 1 - ENVIO DE EMAIL - PARA APROVACAO
U_AVFATW01(3)			// 3 - ENVIO DE EMAIL - NOTIFICACAO REPROVACAO
U_AVFATW01(5)			// 5 - ENVIO DE EMAIL - NOTIFICACAO APROVACAO
RpcClearEnv()

ConOut("["+DtoC(Date()) + ' ' + Time()+"] [U_AVFTW101] Final do processamento - Workflow PV.")

Return

/*-------------------------------------------------------------------------+
|  Envio do Pedido de Venda para Aprovação                                 |                                            
+--------------------------------------------------------------------------*/
  
User Function AVFATW01(_nOpc,pcPedido,oProcess,cMailCC)

Private _cIndex, _cFiltro, _cOrdem, _lProcesso := .F.
Private _cFilial, _cOpcao, _cObs,_cUserAprov
Private nSaldo 	:= 0 ,	nSalDif 	:= 0  , cTipoLim  	:= ""
Private aRetSaldo	:={} ,	cAprov    	:= "" , cObs 		:= ""
Private nTotal	:= 0 ,	cGrupo	 	:= "" , lLiberou	:= .F.
Private aAreaAnt	:= GetArea(), aAreaSC5 := SC5->( GetArea() )

If !Empty( pcPedido ) .And. FunName() $ "MATA410"
	If MsgYesNo("Confirma o envio do Pedido de Venda para aprovação?","Envio para Aprovação")
		Processa( { || AVFTW01P(_nOpc,pcPedido,oProcess,cMailCC) },"Processando o reenvio para aprovação. Aguarde..." )
	Else
		Return
	EndIf
Else
	AVFTW01P(_nOpc,pcPedido,oProcess,cMailCC)
EndIf

Return
	
/*----------------------+--------------------------------+------------------+
|   Programa: AVFTW01P  | Autor: Autor: Kley@TOTVS       | Data: Julho/2014 |
+-----------------------+--------------------------------+------------------+
|  Descricao: Processamento da verificacao dos aprovadores para envio ou
|             retorno das aprovações/rejeicoes/transferencias aos superiores.
+---------------------------------------------------------------------------+
|    Projeto: AVANT
+---------------------------------------------------------------------------+
|    Sintaxe: AVFTW01P(_nOpc,pcPedido,oProcess,cMailCC)
+----------------------------------------------------------------------------
|    Retorno: Nulo                                                               
+--------------------------------------------------------------------------*/

Static Function AVFTW01P(_nOpc,pcPedido,oProcess,cMailCC)

Local _cBlqEst                  
Local _cPed
//Local aAreaSCR
Local _lEstoque := .f.
Local cFunc	  := "U_AVFATW01::AVFTW01P"
Local aAreaSC9  := {}
Local nQtdLib	  := 0
Local _cLibEst  := .F.

Local lCredito  := .T.
Local lEstoque  := .T.
Local lAvCred	  := .T.
Local lAvEst	  := Iif( GetMv("MV_ESTNEG") == "S", .F., .T. )
Local lLiber	  := .T.
Local lTransf	  := .F.

/*-------------------------------------------------------------------------+
|  1 - Prepara os pedidos a serem enviados para aprovacao                  |                                            
+--------------------------------------------------------------------------*/
If _nOpc == 1
	U_Console("1 - Prepara os pedidos a serem enviados para aprovacao",cFunc)
	CHKfile("SC5")	// Pedido de Vendas - Cabecalho
	CHKfile("SC6")	// Pedido de Vendas - Itens
	CHKfile("SC9")	// Pedido de Vendas - Itens Liberados(apenas liberados para aprovacao)
	CHKfile("SE1")	// Contas a Receber
	CHKfile("SE5")	// Movimento Bancario / Titulos Recebidos
	CHKFile("SCR")  // Documentos com alçadas
	CHKFile("SCR",.F.,"TMP")
	_cIndex := CriaTrab(,.F.)
	_cFiltro := ""
	_cFiltro += " CR_FILIAL=='" + cFilAnt + "' 	.AND."  // Filial
	_cFiltro += " CR_TIPO=='PV'   .AND. "				// Pedido de compra
	_cFiltro += " CR_WF = ' ' .AND.  "
	_cFiltro += " CR_STATUS=='02' "
	_cOrdem	 := "CR_FILIAL+CR_NUM+CR_NIVEL+CR_USER"
	dbSelectArea("TMP")
	IndRegua("TMP",_cIndex,_cOrdem,,_cFiltro,"") //"Selecionando Registros..."
	#IFNDEF TOP
		dbSetIndex(_cIndex+OrdBagExt())
	#ENDIF
	DbGotop()
	If TMP->(Eof())
		U_Console("2 - Nao houve processamento",cFunc)
	Else   
		While !TMP->(Eof())
			_cWFId 	    := AVW01EnvPV(TMP->CR_FILIAL, TMP->CR_NUM, TMP->CR_USER , TMP->CR_APROV, TMP->(CR_FILIAL+CR_TIPO+CR_NUM+CR_USER), TMP->CR_TOTAL, TMP->CR_WF, _nOpc)
			_lProcesso  := .T.
			_cUserAprov := 	TMP->CR_USER +' '+ TMP->CR_APROV//usuario e aprovador
			DBSelectarea("SCR")
			DBSetOrder(2)
			DbGoTo( TMP->(Recno()) )
			If !SCR->(Eof())
				Reclock("SCR",.F.)
				SCR->CR_WF		 := "1"			// Status 1 - envio para aprovadores
				SCR->CR_X_WFID := _cWFId		// Rastreabilidade
				MSUnlock()
			ENDIF
			TMP->(DBSkip())
		EndDo
		Endif
	dbSelectArea("TMP")
	dbClearFilter()
	dbCloseArea()
	Ferase(_cIndex+OrdBagExt())

/*-------------------------------------------------------------------------+
|  2 - Processa O RETORNO DO EMAIL                                         |                                             
+--------------------------------------------------------------------------*/
ElseIf _nOPC	== 2
	U_Console("2 - Processa O RETORNO DO EMAIL",cFunc)
	U_Console("2 - Semaforo Vermelho",cFunc)
	ChkFile("SCR")
	ChkFile("SAL")
	ChkFile("SC5")
	ChkFile("SC6")
	ChkFile("SC9")
	ChkFile("SCS")
	ChkFile("SAK")
	ChkFile("SM2")
	cFilAnt	:= alltrim(oProcess:oHtml:RetByName("WFFILIAL"))
	cChaveSCR	:= Val( alltrim(oProcess:oHtml:RetByName("CHAVE")) )
	cOpc     	:= alltrim(oProcess:oHtml:RetByName("OPC"))
	cObs     	:= alltrim(oProcess:oHtml:RetByName("OBS"))
	cWFID     	:= alltrim(oProcess:oHtml:RetByName("WFID"))
	cWFIDUser 	:= alltrim(oProcess:oHtml:RetByName("WFIDUSER"))
	U_Console("cFilAnt => ["+cFilAnt+"]",cFunc)
	U_Console("cChaveSCR => ["+Str(cChaveSCR)+"]",cFunc)
	U_Console("cOpc => ["+cOpc+"]",cFunc)
	U_Console("cObs => ["+cObs+"]",cFunc)
	U_Console("cWFID => ["+cWFID+"]",cFunc)
	U_Console("cWFID => ["+cWFIDUser+"]",cFunc)

	oProcess:Finish() // FINALIZA O PROCESSO

	If cOpc	$ "S|N"  // Aprovacao S-Sim N-Nao 
		// Posiciona na tabela de Alcadas
		DbSelectArea("SCR")
		DbSetOrder(1)
		DbGoTo(cChaveSCR)
		aAreaSCR := GetArea("SCR")
		_cPed    := PadR(RTrim(SCR->CR_NUM),TamSX3("C6_NUM")[1])
		U_Console("Recno: " + Str(SCR->(Recno())),cFunc)
		U_Console("SCR->CR_X_WFID: " + SCR->CR_X_WFID + " | cWFID: " + cWFID,cFunc)
		U_Console("_cPed : " + _cPed,cFunc)

		If SCR->(Eof()) .or. Trim(SCR->CR_X_WFID) <> Trim(cWFID)
			//U_Console("IF SCR->(Eof()) .OR. TRIM(SCR->CR_X_WFID) <> TRIM(cWFID)..." )
			//"Este processo nao foi encontrado e portanto deve ser descartado
			// abre uma notificacao a pessoa que respondeu
			U_Console("2 - O Email respondido nao corresponde a ultima revisao do pedido de vendas" + CRLF + Space(43) + ;
			          "    Código do Processo do WF divergente entre o respondido e do registro.",cFunc)
			Return .T.
		EndIf

		Reclock("SCR",.F.)
			SCR->CR_WF		:= "2"			// Status 2 - respondido
		MSUnlock()
		
		nRegSCR := SCR->( Recno() )
		If !Empty(SCR->CR_DATALIB) .And. SCR->CR_STATUS$"03#04#05"
			U_Console("2 - Semaforo Verde",cFunc)
			Return .T.
		EndIf
		
		DbSelectArea("SAK")
		DbSetOrder(1)
		MsSeek(xFilial("SAK")+SCR->CR_APROV)
		lLiberou := U_MaAlcDoc({SCR->CR_NUM,"PV",nTotal,SCR->CR_APROV,,GetMV('MV_XGRAPPV'),,,,,cObs},dDataBase,If(cOpc$"S",4,6), Nil)
		_lProcesso := .T.
		_cBlqEst   := .F.
		//RestArea(aAreaSCR)
		
		If lLiberou

			/*-------------------------------------------------------------------------+
			|  STATUS de Bloqueio do Pedido de Venda                                   |                                             
			|                                                                          |
			| C9_BLCRED - Bloqueio de Crédito                                          |
			|     " " - Liberado                                                       |
			|     01 - Bloqueio de Credito por Valor                                   |
			|     04 - Vencto do Limite de Credito - Data de Credito Vencida           |
			|     05 - Bloqueio de Credito por Estorno                                 |
			|     06 - Bloqueio de Credito por Risco                                   |
			|     09 - Rejeicao de Credito - Rejeitado Manualmente                     |
			|     10 - FATURADO                                                        |
			|                                                                          |
			| C9_BLEST - Bloqueio de Estoque                                           |
			|     " " - Liberado                                                       |
			|     02 - Bloqueio de Estoque                                             |
			|     03 - Bloqueio Manual de Estoque                                      |
			|     10 - FATURADO                                                        |
			+--------------------------------------------------------------------------*/

			DbSelectArea("SC5")
			DbSetOrder(1)
			MsSeek( xFilial("SC5") + _cPed )
			
			DbSelectArea("SC9")
			DbSetOrder(1)
			MsSeek( xFilial("SC9") + _cPed )
			
			DbSelectArea("SC6")
			DbSetOrder(1)
			MsSeek( xFilial("SC6") + _cPed )

			While !SC6->(EOF()) .and. SC6->C6_NUM == _cPed
				U_Console("2 - Processando (SC6) Fil/PV/Item PV: "+ SC6->(C6_FILIAL)+"/"+SC6->(C6_NUM)+"/"+SC6->(C6_ITEM),cFunc)
				If RecLock("SC6")
					nQtdLib  := ( SC6->C6_QTDVEN - ( SC6->C6_QTDEMP + SC6->C6_QTDENT ) )
					// Recalcula a Quantidade Liberada
					RecLock("SC6") //Forca a atualizacao do Buffer no Top
					// Libera por Item de Pedido
					Begin Transaction
						//MaLibDoFat(SC6->(RecNo()),@nQtdLib,.F.      ,.F.      ,.T.    ,.T.   ,.F.   ,.F.)
						//MaLibDoFat(SC6->(RecNo()),@nQtdLib,@lCredito,@lEstoque,lAvCred,lAvEst,lLiber,lTransf)
						  MaLibDoFat(SC6->(RecNo()),@nQtdLib,.F.      ,.F.      ,.T.    ,.T.   ,.F.   ,.F.)
					End Transaction
					SC6->C6_BLOQUEI := Space(TamSX3("C6_BLOQUEI")[1])
				EndIf
				SC6->(MsUnLock())
				// Atualiza o Flag do Pedido de Venda
				Begin Transaction
					SC6->(MaLiberOk({_cPed},.F.))
				End Transaction

				If SC9->( MsSeek(SC6->(C6_FILIAL+C6_NUM+C6_ITEM)) )
					U_Console("2 - Processando (SC9) Fil/PV/Item PV: "+ SC9->(C9_FILIAL)+"/"+SC9->(C9_PEDIDO)+"/"+SC9->(C9_ITEM),cFunc)
					DbSelectArea("SB2")
					DbSetOrder(1)
					If MsSeek(xFilial("SB2")+SC9->C9_PRODUTO+SC9->C9_LOCAL)
					   _nSaldo := SaldoSB2() //(SB2->B2_QATU - SB2->B2_RESERVA - SB2->B2_QACLASS - SB2->B2_QEMP)
					EndIf 
					DbSelectArea("SC6")
					_cLibEst := ( SC9->C9_BLEST = '02' .and. SC9->C9_QTDLIB <= _nSaldo )
					U_Console("2 - Bloqueio Estoque (C9_BLEST Antes Liberação): " + SC9->C9_BLEST,cFunc)
					aAreaSC9 := SC9->(GetArea())
					a450Grava(1,.T.,_cLibEst)
					RestArea(aAreaSC9)
					U_Console("2 - Bloqueio Estoque (C9_BLEST Após Liberação) : " + SC9->C9_BLEST,cFunc)
					SC9->( RecLock("SC9",.F.) )
						SC9->C9_BLCRED := "  "
					SC9->( MsUnLock() )
				EndIf				
								
				SC6->(DbSkip())
			End
			SC6->(dbCloseArea())
			
		EndIf
	EndIf
	
	U_Console("2 - Semaforo Verde",cFunc)
		
/*-------------------------------------------------------------------------+
|  3 - Envia resposta de Pedido de Venda Bloqueado                         |                                             
+--------------------------------------------------------------------------*/
ElseIf  _nOpc == 3
	
	U_Console("3 - Envia resposta de pedido bloqueado para o solicitante",cFunc)
	
	CHKfile("SC5")	// Pedido de Compras
	CHKFile("SCR")  // Documentos com alçadas
	CHKFile("SCR",.F.,"TMP")
	
	_cIndex := CriaTrab(,.F.)
	
	_cFiltro := ""
	_cFiltro += " CR_FILIAL=='" + cFilAnt + "' 	.AND."  // Filial
	_cFiltro += " CR_TIPO=='PV'   .AND. "				// Pedido de Vendas
	_cFiltro += " CR_STATUS=='04' .AND. "				// Reprovado
	_cFiltro += " !EMPTY(CR_LIBAPRO) .AND. "			// Seleciona o Aprovador que reprovou
	_cFiltro += " CR_WF = '2'           "			    // ' '-Reprovado manualmente / 2-reprovado via workflow
	
	_cOrdem	 := "CR_FILIAL+CR_NUM"
	
	dbSelectArea("TMP")
	
	IndRegua("TMP",_cIndex,_cOrdem,,_cFiltro,"") //"Selecionando Registros..."
	
	#IFNDEF TOP
		dbSetIndex(_cIndex+OrdBagExt())
	#ENDIF
	
	dbGotop()
	While !TMP->(Eof())
		_cWFId 	:= AVW01EnvPV(TMP->CR_FILIAL, TMP->CR_NUM, TMP->CR_USER, TMP->CR_APROV, TMP->(CR_FILIAL+CR_TIPO+CR_NUM+CR_USER), TMP->CR_TOTAL, "3")
		
		DBSelectarea("SCR")
		DBSetOrder(2)
		DbGoTo( TMP->(Recno()) )
		If !SCR->(Eof())
			Reclock("SCR",.F.)
			SCR->CR_WF		 := "1"		// Status 1 - envio email
			SCR->CR_X_WFID := _cWFId		// Rastreabilidade
			MSUnlock()
		ENDIF
		
		_lProcesso := .T.
		
		dbSelectArea("TMP")
		DBSkip()
	EndDo
	
	dbSelectArea("TMP")
	dbClearFilter()
	dbCloseArea()
	Ferase(_cIndex+OrdBagExt())
		
/*-------------------------------------------------------------------------+
| 5 - Envia resposta de Pedido de Venda Liberado                           |                                             
+--------------------------------------------------------------------------*/
ElseIf  _nOpc == 5
	
	U_Console("5 - Envia resposta de pedido APROVADO para o Solicitante",cFunc)
	
	CHKfile("SC5", .F., "TMP")	// Pedido de Venda
	CHKFile("SCR")              // Documentos com alçadas
	CHKFile("SC5")
	
	Private _cIndex  := CriaTrab(,.F.)
	Private aItensPV := {}
	
	/*-------------------------------------------------------------------------+
	| Obter a matrix para alimentar a resposta dos itens caso venha do parecer |
	| logístico.                                             
	+--------------------------------------------------------------------------*/	
	If pcPedido <> Nil
		ProcesRet(oProcess)
	EndIf
		
	//_cWF     := '5'
	_cFiltro := " SELECT C5_FILIAL, C5_NUM FROM "+RetSqlName('SC5')
	_cFiltro += " WHERE C5_FILIAL  = '"+xFilial('SC5')+"' "
	_cFiltro += " AND   C5_X_WF      = ' ' "
	_cFiltro += " AND   D_E_L_E_T_ = ' ' "
	_cFiltro += " AND   C5_FILIAL||C5_NUM IN( SELECT C9_FILIAL||C9_PEDIDO "
	_cFiltro += "                            FROM "+RetSqlName('SC9')
	If pcPedido <> Nil
		_cFiltro += "                        WHERE C9_FILIAL = '"+Left(pcPedido,2)+"' "
	Else
		_cFiltro += "                        WHERE C9_FILIAL = '"+xFilial('SC9')+"' "
	EndIf
	_cFiltro += "                            AND   C9_BLCRED = '  ' "
	_cFiltro += "                            AND   D_E_L_E_T_ = '  ' ) "
	_cFiltro += " ORDER BY C5_FILIAL, C5_NUM "
	
	U_MontaView( _cFiltro, "TMP" )
	
	DbSelectArea("TMP")
	DbGotop()
	
	While !TMP->(Eof())
		
		_cQuery := " SELECT SUM( (C6_QTDVEN - C6_QTDENT)*C6_PRCVEN ) AS TOTPED "
		_cQuery += " FROM "+RetSqlName("SC6")
		_cQuery += " WHERE C6_FILIAL  = '"+xFilial('SC6')+"' "
		_cQuery += " AND   C6_NUM     = '"+TMP->C5_NUM+"' "
		_cQuery += " AND   D_E_L_E_T_ = ' ' "
		
		U_MontaView( _cQuery, "SOMASC6" )
		
		SOMASC6->( DbGoTop() )
		
		_cWFId := AVW01EnvPV(TMP->C5_FILIAL, TMP->C5_NUM, Nil,, TMP->(C5_FILIAL+"PV"+C5_NUM), SOMASC6->TOTPED, '5')
		
		SC5->( DbSetOrder(1), DbSeek( TMP->C5_FILIAL+TMP->C5_NUM ) )
		
		SC5->( RecLock('SC5',.f.) )
		SC5->C5_X_WF := '1'
		SC5->( MsUnLock() )
		
		_lProcesso := .t.
		
		TMP->( DbSkip() )
		
	EndDo
	
	DbSelectArea("TMP")
	DbCloseArea()
	Ferase(_cIndex+OrdBagExt())
	
EndIf

IF 	_lProcesso
	U_Console("Mensagem processada ",cFunc)
ELSE
	U_Console("Nao houve processamento",cFunc)
ENDIF

RETURN
	
/*----------------------+--------------------------------+------------------+
|   Programa: AVW01EnvPV| Autor: Kley@TOTVS              | Data: Julho/2014 |
+-----------------------+--------------------------------+------------------+
|  Descricao: Workflow de Pedido de Venda
|             _cWF ' ' - Envia email para aprovador
|             _cWF '3' - Reenvia email para aprovador, foi rejeitado por insuficiencia de saldo
|             _cWF '4' - Envia email informando que o PV está reprovado
|             _cWF '5' - Envia email informando que o PV está aprovado
+---------------------------------------------------------------------------+
|    Projeto: AVANT
+---------------------------------------------------------------------------+
|    Sintaxe: AVW01EnvPV(_cFilial,_cNum, _cUser, _cAprov, _cChave, _nTotal, _cWF, cMailCC)
+----------------------------------------------------------------------------
|    Retorno: ID do Workflow                                                               
+--------------------------------------------------------------------------*/

Static Function AVW01EnvPV(_cFilial, _cNum, _cUser, _cAprov, _cChave, _nTotal, _cWF, _nOpc)

Local nLines
Local lWrap 		:= .f.
Local cNum  		:= PadR(_cNum,TamSX3("C6_NUM")[1])
Local cChaveSCR 	:= SUBS(_cCHAVE, 1, TamSX3('CR_NUM')[1])
Local nLineSize 	:= 80, nTabSize  := 2
Local cObsAM 		:= ""
Local _cHttp		:= GetNewPar("MV_WFDHTTP", "http://192.168.10.22:8081")
Local _cEmail		:= Alltrim(UsrRetMail(_cUser))
Local _dDataLib	:= MSDATE() 
Local _cHoraLib	:= LEFT(TIME(),5) 
Local _cTo			:= IIF(_nOpc == 1, _cUser , UsrRetMail(_cUser))
Local cFunc	 	:= "U_AVFATW01::AVW01EnvPV"
Local _cWfDir  	:= "\workflow\"
Local cDirHtml 	:= "html\"
Local cAliasUsr	:= GetNextAlias()
Local cDestEmail  := ""
Local aDocBcoCto	:= {}
Local cDirDoc	 := ""

ChkFile("SE4")
ChkFile("SA1")
ChkFile("SB1")
ChkFile("SBM")

SBM->( DbSetOrder(1) )
SB1->( DbSetOrder(1) )
SC5->( DbSetOrder(1), DbSeek( xFilial('SC5')+cNum ) )
SC9->( DbSetOrder(1), DbSeek( xFilial('SC9')+cNum ) )
SA1->( DbSetOrder(1), DbSeek( xFilial('SA1')+SC5->(C5_CLIENTE+C5_LOJACLI) ) )
SE4->( DbSetOrder(1), DbSeek( xFilial('SE4')+SC5->C5_CONDPAG ) )
PswSeek( Left( EMBARALHA(SC5->C5_USERLGI,1), 15 ) )

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

//Define o diretório virtual como raiz, para ser usado pelo link do formulário de aprovação e do documento do banco de conhecimento
If "workflow/" $ Lower(_cHttp)
	_cHttp := Replace(Lower(_cHttp),"workflow/","")
ElseIf "workflow" $ Lower(_cHttp)
	_cHttp := Replace(Lower(_cHttp),"workflow","")
EndIf

_cHttp := Iif( Right(RTrim(_cHttp),1)=="/", Left(RTrim(_cHttp),Len(RTrim(_cHttp))-1), RTrim(_cHttp) )

If Empty(FWxFilial("ACB"))
	cDirDoc	:= _cHttp + "/dirdoc/co"+cEmpAnt+"/shared/"
Else
	cDirDoc	:= _cHttp + "/dirdoc/co"+cEmpAnt+"/br"+AllTrim(FWxFilial("ACB"))+"/"
EndIf

/*--------------------------------------------------------------------------------------+
| Quando for Notificação de Pedido de Venda Aprov./Reprov. busca todos os destinatários |
| do processo para envio dee-mail: Aprovadores do Grp.Aprov., Vendedor e Ger.Vendas.    |
| Dos Vendedores e Gerentes busca o e-mail do SA3 e do Cadastro de Usuário do Sistema.  |
+---------------------------------------------------------------------------------------*/
If Trim(_cWF) $ '3/5'

	If Select(cAliasUsr) > 0
		(cAliasUsr)->(dbCloseArea())
	Endif
	BeginSQL Alias cAliasUsr
		select distinct CR_USER as CR_USER from (
			select distinct CR_USER
			from %Table:SCR% SCR
			where CR_FILIAL = %xFilial:SCR% and CR_TIPO = 'PV' and CR_NUM like '%'+%Exp:cNum%+'%' 
			  and SCR.%NotDel%
			union all
			select isnull(SA3V.A3_CODUSR,' ') as A3_CODUSR
			from %Table:SC5% SC5
			left join %Table:SA1% SA1 on A1_FILIAL = %xFilial:SA1% and A1_COD = C5_CLIENTE and A1_LOJA = C5_LOJACLI and SA1.%NotDel%
			left join %Table:SA3% SA3V on SA3V.A3_FILIAL = %xFilial:SA3% and SA3V.A3_COD = A1_VEND       and SA3V.%NotDel%
			where C5_FILIAL = %xFilial:SC5% and C5_NUM like '%'+%Exp:cNum%+'%' 
			  and SC5.%NotDel%
			union all
			select isnull(SA3V.A3_EMAIL,' ') as A3_CODUSR
			from %Table:SC5% SC5
			left join %Table:SA1% SA1 on A1_FILIAL = %xFilial:SA1% and A1_COD = C5_CLIENTE and A1_LOJA = C5_LOJACLI and SA1.%NotDel%
			left join %Table:SA3% SA3V on SA3V.A3_FILIAL = %xFilial:SA3% and SA3V.A3_COD = A1_VEND       and SA3V.%NotDel%
			where C5_FILIAL = %xFilial:SC5% and C5_NUM like '%'+%Exp:cNum%+'%' 
			  and SC5.%NotDel%
			union all
			select isnull(SA3G.A3_CODUSR,' ') as A3_CODUSR
			from %Table:SC5% SC5
			left join %Table:SA1% SA1 on A1_FILIAL = %xFilial:SA1% and A1_COD = C5_CLIENTE and A1_LOJA = C5_LOJACLI and SA1.%NotDel%
			left join %Table:SA3% SA3V on SA3V.A3_FILIAL = %xFilial:SA3% and SA3V.A3_COD = A1_VEND       and SA3V.%NotDel%
			left join %Table:SA3% SA3G on SA3G.A3_FILIAL = %xFilial:SA3% and SA3G.A3_COD = SA3V.A3_GEREN and SA3G.%NotDel%
			where C5_FILIAL = %xFilial:SC5% and C5_NUM like '%'+%Exp:cNum%+'%' 
			  and SC5.%NotDel%
			union all
			select isnull(SA3G.A3_EMAIL,' ') as A3_CODUSR
			from %Table:SC5% SC5
			left join %Table:SA1% SA1 on A1_FILIAL = %xFilial:SA1% and A1_COD = C5_CLIENTE and A1_LOJA = C5_LOJACLI and SA1.%NotDel%
			left join %Table:SA3% SA3V on SA3V.A3_FILIAL = %xFilial:SA3% and SA3V.A3_COD = A1_VEND       and SA3V.%NotDel%
			left join %Table:SA3% SA3G on SA3G.A3_FILIAL = %xFilial:SA3% and SA3G.A3_COD = SA3V.A3_GEREN and SA3G.%NotDel%
			where C5_FILIAL = %xFilial:SC5% and C5_NUM like '%'+%Exp:cNum%+'%' 
			  and SC5.%NotDel%) as USERS
	EndSQL

	(cAliasUsr)->(DbGoTop())
	While !(cAliasUsr)->(Eof())
		cDestEmail	+= Iif(!Empty(cDestEmail).or.!Empty((cAliasUsr)->(CR_USER)),";","")
		If Len(RTrim((cAliasUsr)->(CR_USER))) == 6
			cDestEmail	+= UsrRetMail(RTrim((cAliasUsr)->(CR_USER)))
		Else
			cDestEmail	+= RTrim((cAliasUsr)->(CR_USER))		
		EndIf
		(cAliasUsr)->(DbSkip())
	EndDo
	(cAliasUsr)->(dbCloseArea())
EndIf

/*--------------------------------------------------------+
| Cria objeto oProcess e busca modelo HTML                |
+---------------------------------------------------------*/
oProcess := TWFProcess():New( "000021", "Envio de PV :" + _cFilial + "/" +  TRIM(cNum) )
If EMPTY(_cWF)
	oProcess          	:NewTask( "Envio PV : "+_cFilial + cNum, "\workflow\Faturamento\PVAprovacao.htm" )
	oProcess:cSubject 	:= "Aprovacao de Pedido de Vendas Nro. "+SC5->C5_NUM+"/"+SC5->C5_FILIAL
	oProcess:bReturn  	:= "U_AVFATW01(2,'')"
	oProcess:cTo      	:= UsrRetMail(_cUser)
ElseIf TRIM(_cWF) == "3"
	oProcess          	:NewTask( "Envio Pv : "+_cFilial + cNum, "\workflow\Faturamento\PVReprovado.htm" )
	oProcess:cSubject 	:= "Pedido de Vendas foi REPROVADO: "+SC5->C5_NUM+"/"+SC5->C5_FILIAL
	oProcess:cTo      	:= cDestEmail	//UsrRetMail(PswId())
ElseIf TRIM(_cWF) == "5"
	oProcess          	:NewTask( "Envio PV : "+_cFilial + cNum, "\workflow\Faturamento\PVAprovado.htm" )
	oProcess:cSubject 	:= "Pedido de Vendas APROVADO(Crédito Aprovado): "+SC5->C5_NUM+"/"+SC5->C5_FILIAL
	oProcess:cTo      	:= cDestEmail	//UsrRetMail(PswId())
EndIf

oProcess:UserSiga	:= PswId()
oProcess:NewVersion(.T.)

oHtml     			:= oProcess:oHTML

If !_cWF $ '4/5'
	oHtml:ValByName("OBS", "" )
	oHtml:ValByName("CFILANT", SM0->M0_FILIAL)
	If _cWF $ " /1/3"
		oHtml:ValByName("CHAVE", TMP->( Recno() ) )
	Else
		oHtml:ValByName("CHAVE", SC5->(C5_FILIAL+C5_NUM) )
	EndIf
	oHtml:ValByName("WFID", oProcess:fProcessId )
	oHtml:ValByName("WFIDUSER", PswId() )
EndIf

_aViewTA	:= U_MontaTit(1)
_aViewTR	:= U_MontaTit(2)

Do Case
	Case SC9->C9_BLCRED $ "01/02"
		_cBLCRED	:= "Bloqueio de Credito por Valor"
	Case SC9->C9_BLCRED $ "04"
		_cBLCRED	:= "Vencto do Limite de Credito - Data de Credito Vencida"
	Case SC9->C9_BLCRED $ "05"
		_cBLCRED	:= "Bloqueio de Credito por Estorno"
	Case SC9->C9_BLCRED $ "06"
		_cBLCRED	:= "Bloqueio de Credito por Risco"
	Case SC9->C9_BLCRED $ "09"
		_cBLCRED	:= "Rejeicao de Credito - Rejeitado Manualmente"
	Case SC9->C9_BLCRED == "  "
		_cBLCRED	:= "Liberado"
	Otherwise
		_cBLCRED	:= ""	
EndCase

// TRATAMENTO DAS VARIAVEIS DE CREDITO
nMcusto   	:= Iif(SA1->A1_MOEDALC > 0, SA1->A1_MOEDALC, Val(GetMv("MV_MCUSTO")))
aTab1Cred	:= {}
aTab2Cred	:= {}
aTab3Cred	:= {}
aTab4Cred	:= {}

// PRIMEIRA TABELA
AADD( aTab1Cred, Transform(xMoeda(SA1->A1_LC, nMcusto, 1,dDataBase),PesqPict("SA1","A1_LC",14,1))) 							// LIMITE DE CREDITO
AADD( aTab1Cred, TRansform(SA1->A1_SALDUP,PesqPict("SA1","A1_SALDUP",14,1)))														// SALDO ATUAL
AADD( aTab1Cred, TRansform(xMoeda(SA1->A1_LCFIN,nMcusto,1,dDatabase,MsDecimais(1)),PesqPict("SA1","A1_LCFIN",14,1)))		// LIMITE CREDITO SEC
AADD( aTab1Cred, TRansform(SA1->A1_SALFIN,PesqPict("SA1","A1_SALFIN",14,1)))														// SALDO LC CRED
AADD( aTab1Cred, TRansform(xMoeda(SA1->A1_MCOMPRA, nMcusto ,1, dDataBase,MsDecimais(1) ),PesqPict("SA1","A1_MCOMPRA",14,1)))		// MAIOR COMPRA

// SEGUNDA TABELA
AADD( aTab2Cred, DtoC(SA1->A1_VENCLC)) 																								// Vencto Limite Credito
AADD( aTab2Cred, Transform(SA1->A1_MATR,PesqPict("SA1","A1_MATR",14))) 															// Maior Atraso
AADD( aTab2Cred, Transform(SA1->A1_METR,PesqPict("SA1","A1_METR",14))) 															// Media Atraso
AADD( aTab2Cred, TRansform(xMoeda(SA1->A1_MSALDO, nMcusto ,1, dDataBase,MsDecimais(1) ),PesqPict("SA1","A1_MSALDO",14,1))) // Maior Saldo
AADD( aTab2Cred, DtoC(SA1->A1_PRICOM)) // Primeira Compra
AADD( aTab2Cred, DtoC(SA1->A1_ULTCOM)) // Ultima Compra

// TERCEIRA TABELA
AADD( aTab3Cred, Transform(SA1->A1_CHQDEVO,PesqPict("SA1","A1_CHQDEVO",14))) 	// Cheque Devolvido Quantidade
AADD( aTab3Cred, DtoC(SA1->A1_DTULCHQ))		 								    	// Cheque Devolvido Ultimo

// QUARTA TABELA
AADD( aTab4Cred, Transform(SA1->A1_TITPROT,PesqPict("SA1","A1_TITPROT",14))) 	// Titulo Protestado Quantidade
AADD( aTab4Cred, DtoC(SA1->A1_DTULTIT))		 								    	// Titulo Protestado Ultimo

//Cabeçalho
oHtml:ValByName( "C9_PEDIDO"	, Iif(Empty(SC5->C5_FILIAL),"",RTrim(SC5->C5_FILIAL)+"/") + SC5->C5_NUM )
oHtml:ValByName( "C5_EMISSAO"	, DTOC(SC5->C5_EMISSAO) )
oHtml:ValByName( "E4_DESCRI"   	, SE4->E4_DESCRI )
oHtml:ValByName( "C5_USER"		, UsrFullName(PswID()) )
oHtml:ValByName( "C5_VEND1"		, RTrim(Posicione("SA3",1,xFilial('SA3')+SC5->C5_VEND1,"A3_NOME")) + " ("+SC5->C5_VEND1+")" )
oHtml:ValByName( "C5_OBS_AM"	, RTrim(SC5->C5_OBSERV) )

//DADOS DO CLIENTE
oHtml:ValByName( "A1_NOME"		, SA1->A1_NOME + " " + SA1->A1_COD + "-"+ SA1->A1_LOJA )
oHtml:ValByName( "A1_CGC"		, Transform( SA1->A1_CGC, PesqPict('SA1','A1_CGC') ) )
oHtml:ValByName( "A1_TEL"		, SA1->A1_TEL )
oHtml:ValByName( "A1_RISCO"		, "Risco " + SA1->A1_RISCO )

//MOTIVO DO BLOQUEIO
oHtml:ValByName( "C9_BLCRED"	, _cBLCRED )

//ANALISE DE CREDITO
//TABELA 1
oHtml:ValByName( "t11"	, aTab1Cred[1] )
oHtml:ValByName( "t12"	, aTab1Cred[2] )
oHtml:ValByName( "t13"	, aTab1Cred[3] )
oHtml:ValByName( "t14"	, aTab1Cred[4] )
oHtml:ValByName( "t15"	, aTab1Cred[5] )

//TABELA 2
oHtml:ValByName( "t21"	, aTab2Cred[1] )
oHtml:ValByName( "t22"	, aTab2Cred[2] )
oHtml:ValByName( "t23"	, aTab2Cred[3] )
oHtml:ValByName( "t24"	, aTab2Cred[4] )
oHtml:ValByName( "t25"	, aTab2Cred[5] )
oHtml:ValByName( "t26"	, aTab2Cred[6] )

//TABELA 3
oHtml:ValByName( "t31"	, aTab3Cred[1] )
oHtml:ValByName( "t32"	, aTab3Cred[2] )

//TABELA 4
oHtml:ValByName( "t41"	, aTab4Cred[1] )
oHtml:ValByName( "t42"	, aTab4Cred[2] )

aDocBcoCto	:= AVWFPsqDoc( SA1->(A1_FILIAL + A1_COD + A1_LOJA) )
If Len(aDocBcoCto) > 0 .and. SA1->A1_X_ENVBC == "2"
	oHtml:ValByName( "t43"	, "<a target='_blank' href='" + cDirDoc + Alltrim(aDocBcoCto[1][2]) + "'>"+Alltrim(aDocBcoCto[1][1])+"</a>")	
Else	
	oHtml:ValByName( "t43"	, "" )	
EndIf

/*--------------------------------------------------------+
| Títulos em Aberto                                       |
+---------------------------------------------------------*/
/*
IF Len(_aViewTA) > 0
	FOR _nLin := 1 TO Len(_aViewTA)
		AAdd( (oHtml:ValByName( "t1.1" )), _aViewTA[_nLin][1])
		AAdd( (oHtml:ValByName( "t1.2" )), _aViewTA[_nLin][2])
		AAdd( (oHtml:ValByName( "t1.3" )), DTOC(_aViewTA[_nLin][3]))
		AAdd( (oHtml:ValByName( "t1.4" )), DTOC(_aViewTA[_nLin][4]))
		AAdd( (oHtml:ValByName( "t1.5" )), Transform(_aViewTA[_nLin][5],PesqPict("SE1","E1_VALOR",14)))
		AAdd( (oHtml:ValByName( "t1.6" )), Transform(_aViewTA[_nLin][6],PesqPict("SE1","E1_SALDO",14)))
		AAdd( (oHtml:ValByName( "t1.7" )), _aViewTA[_nLin][7])
		AAdd( (oHtml:ValByName( "t1.8" )), Transform(_aViewTA[_nLin][8],"@E 9,999"))
		AAdd( (oHtml:ValByName( "t1.9" )), _aViewTA[_nLin][9])
	NEXT
ELSE
	AAdd( (oHtml:ValByName( "t1.1" )), " ")
	AAdd( (oHtml:ValByName( "t1.2" )), " ")
	AAdd( (oHtml:ValByName( "t1.3" )), "   /  /  ")
	AAdd( (oHtml:ValByName( "t1.4" )), "   /  /  ")
	AAdd( (oHtml:ValByName( "t1.5" )), " 0,00 ")
	AAdd( (oHtml:ValByName( "t1.6" )), " 0,00 ")
	AAdd( (oHtml:ValByName( "t1.7" )), " ")
	AAdd( (oHtml:ValByName( "t1.8" )), " 0 ")
	AAdd( (oHtml:ValByName( "t1.9" )), " ")
ENDIF
*/
/*--------------------------------------------------------+
| Títulos Recebidos                                       |
+---------------------------------------------------------*/
/*
IF Len(_aViewTR) > 0
	FOR _nLin := 1 TO Len(_aViewTR)
		AAdd( (oHtml:ValByName( "t2.1" )), _aViewTR[_nLin][1])
		AAdd( (oHtml:ValByName( "t2.2" )), _aViewTR[_nLin][2])
		AAdd( (oHtml:ValByName( "t2.3" )), DTOC(_aViewTR[_nLin][3]))
		AAdd( (oHtml:ValByName( "t2.4" )), DTOC(_aViewTR[_nLin][4]))
		AAdd( (oHtml:ValByName( "t2.5" )), Transform(_aViewTR[_nLin][5],PesqPict("SE1","E1_VALOR",14)))
		AAdd( (oHtml:ValByName( "t2.6" )), Transform(_aViewTR[_nLin][6],PesqPict("SE1","E1_SALDO",14)))
		AAdd( (oHtml:ValByName( "t2.7" )), _aViewTR[_nLin][7])
		AAdd( (oHtml:ValByName( "t2.8" )), Transform(_aViewTR[_nLin][8],"@E 999"))
		AAdd( (oHtml:ValByName( "t2.9" )), _aViewTR[_nLin][9])
	NEXT
ELSE
	AAdd( (oHtml:ValByName( "t2.1" )), " - ")
	AAdd( (oHtml:ValByName( "t2.2" )), " - ")
	AAdd( (oHtml:ValByName( "t2.3" )), "   /  /  ")
	AAdd( (oHtml:ValByName( "t2.4" )), "   /  /  ")
	AAdd( (oHtml:ValByName( "t2.5" )), " 0,00 ")
	AAdd( (oHtml:ValByName( "t2.6" )), " 0,00 ")
	AAdd( (oHtml:ValByName( "t2.7" )), " - ")
	AAdd( (oHtml:ValByName( "t2.8" )), " 0 ")
	AAdd( (oHtml:ValByName( "t2.9" )), " - ")
ENDIF
*/
/*--------------------------------------------------------+
| Detalhes (itens) do Pedido de Vendas                    |
+---------------------------------------------------------*/
ACDetPV(SC9->C9_FILIAL, SC9->C9_PEDIDO, SC9->C9_SEQUEN, _cWF)
oHtml:ValByName( "TOTAL"	, GETMV("MV_SIMB"+AllTrim(GETMV("MV_MCUSTO")) )+' '+TRANSFORM(_nTotal,'@E 999,999,999.99'))

/*--------------------------------------------------------+
| Processo de aprovacao do PV com a Alçada gerada         |
+---------------------------------------------------------*/
SCR->( DbSetOrder(1), DbSeek(cChaveSCR,.T.) )

While !SCR->(Eof()) .AND. AllTrim(SCR->(CR_FILIAL+CR_TIPO+CR_NUM)) == AllTrim(cChaveSCR)
	cSituaca := ""
	
	// Posicionar no SAL para identificar o tipo de aprovacao do aprovador
	// referente ao item atual:
	
	// CR_USERLIB = Codigo do Usuario Aprovador
	// C5_X_APROV = Codigo do Grupo de Aprovacao no Pedido de Vendas
	
	SAL->( DbSeek(xFilial('SAL')+GetMV('MV_XGRAPPV')+SCR->CR_LIBAPRO) )
	
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
		OtherWise
			cSituaca := 'Nao houve bloqueio de Crédito'
	EndCase
	
	_cT4 := UsrRetName(SCR->CR_USERLIB)
	If SCR->( FieldPos('CR_X_OBS') ) > 0
		_cT6 := SCR->CR_X_OBS
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

/*--------------------------------------------------------+
| Cria ID do Processo e faz o envio do e-mail             |
+---------------------------------------------------------*/
_cWFID := oProcess:fProcessId

If !TRIM(_cWF) $ "5|8"
	
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


/*----------------------+--------------------------------+------------------+
|   Programa: ACDetPV   | Autor: Kley@TOTVS              | Data: Julho/2014 |
+-----------------------+--------------------------------+------------------+
|  Descricao: Monta os produtos no HTML
+---------------------------------------------------------------------------+
|    Projeto: AVANT
+---------------------------------------------------------------------------+
|    Sintaxe: ACDetPV(_cFilial, _cPedido, _cSeq, _cWF, _cStatus)
+----------------------------------------------------------------------------
|    Retorno: Nulo                                                               
+--------------------------------------------------------------------------*/

Static Function ACDetPV(_cFilial, _cPedido, _cSeq, _cWF, _cStatus)

If _cWF <> '8'
	DBSelectArea("SC9")
	DBSetOrder(1)
	DBSeek(_cFilial+_cPedido)
	While ! SC9->(EOF()) .AND. SC9->C9_FILIAL == _cFilial .AND. SC9->C9_PEDIDO == _cPedido
		If SC9->C9_SEQUEN == _cSeq
			DbSelectArea("SB1")
			DbSetOrder(1)
			DbSeek(xFilial()+SC9->C9_PRODUTO)
			_nC9_TOTAL	:= SC9->C9_QTDLIB * SC9->C9_PRCVEN
			//If _cWF $ '5'
  					//AAdd( (oHtml:ValByName( "t3.chk1"       )), "")
			//EndIf
			AAdd( (oHtml:ValByName( "t3.1" )), SC9->C9_ITEM)
			AAdd( (oHtml:ValByName( "t3.2" )), SC9->C9_PRODUTO)
			AAdd( (oHtml:ValByName( "t3.3" )), SB1->B1_DESC)
			AAdd( (oHtml:ValByName( "t3.4" )), SB1->B1_UM)
			AAdd( (oHtml:ValByName( "t3.5" )), TRANSFORM(SC9->C9_QTDLIB,'@E 999,999.999'))
			AAdd( (oHtml:ValByName( "t3.6" )), TRANSFORM(SC9->C9_PRCVEN,'@E 999,999.99'))
			AAdd( (oHtml:ValByName( "t3.7" )), TRANSFORM(_nC9_TOTAL,'@E 99,999,999.99'))
		Endif
		SC9->(DBskip())
	EndDo
Else
	For _xp := 1 To Len( aItensPV )
		AAdd( (oHtml:ValByName( "t3.0" )), aItensPV[_xp][1])
		AAdd( (oHtml:ValByName( "t3.1" )), aItensPV[_xp][2])
		AAdd( (oHtml:ValByName( "t3.2" )), aItensPV[_xp][3])
		AAdd( (oHtml:ValByName( "t3.3" )), aItensPV[_xp][4])
		AAdd( (oHtml:ValByName( "t3.4" )), aItensPV[_xp][5])
		AAdd( (oHtml:ValByName( "t3.5" )), aItensPV[_xp][6])
		AAdd( (oHtml:ValByName( "t3.6" )), aItensPV[_xp][7])
		AAdd( (oHtml:ValByName( "t3.7" )), aItensPV[_xp][8])
	Next
EndIf
Return


/*----------------------+--------------------------------+------------------+
|   Programa: ProcesRet | Autor: Kley@TOTVS              | Data: Julho/2014 |
+-----------------------+--------------------------------+------------------+
|  Descricao: Obtem os itens e a resposta escolhida no radio button
+---------------------------------------------------------------------------+
|    Projeto: AVANT
+---------------------------------------------------------------------------+
|    Sintaxe: ProcesRet( oProcess2 )
+----------------------------------------------------------------------------
|    Retorno: Nulo                                                               
+--------------------------------------------------------------------------*/

Static Function ProcesRet( oProcess2 )

Local _nInd
For _nInd := 1 To Len(oProcess2:oHtml:RetByName("t3.1"))
	If oProcess2:oHtml:RetByName("t3.chk1")[_nInd] == "S"
		cChk1 := "<p><font color='#006600'>Sim</font></p>"
	Else
		cChk1 := "<p><font color='#FF0000'>Não</font></p>"
	EndIf
	c1  := oProcess2:oHtml:RetByName("t3.1")[_nInd]
	c2  := oProcess2:oHtml:RetByName("t3.2")[_nInd]
	c3  := oProcess2:oHtml:RetByName("t3.3")[_nInd]
	c4  := oProcess2:oHtml:RetByName("t3.4")[_nInd]
	c5  := oProcess2:oHtml:RetByName("t3.5")[_nInd]
	c6  := oProcess2:oHtml:RetByName("t3.6")[_nInd]
	c7  := oProcess2:oHtml:RetByName("t3.7")[_nInd]
	Aadd( aItensPV, { cChk1, c1, c2, c3, c4, c5, c6, c7 } )
Next
oProcess2:Finish()
Return


/*----------------------+--------------------------------+------------------+
|   Programa: MontaTit | Autor: Kley@TOTVS              | Data: Julho/2014 |
+-----------------------+--------------------------------+------------------+
|  Descricao: Retorna a posicao (1) titulos a receber ou (2)titulos recebidos
+---------------------------------------------------------------------------+
|    Projeto: AVANT
+---------------------------------------------------------------------------+
|    Sintaxe: MontaTit(nOpc)
+----------------------------------------------------------------------------
|    Retorno: Array com resultado da consulta                                                               
+--------------------------------------------------------------------------*/

User Function MontaTit(nOpc)

Local cQuery 	:= ""
Local cQry 	:= ""
Local cChave 	:= ""
Local aQuery 	:= {}
Local aStru	:= {}
Local aAlias	:= {}
Local aParam 	:= {}

/*--------------------------------------------------------+
| Titulos em Aberto                                       |
+---------------------------------------------------------*/
If ( nOpc == 1 )     // Titulos em Aberto
	cAlias	:= 'FC010QRY01'
	
	dbSelectArea("SX3")
	dbSetOrder(2)
	
	dbSeek("E1_PREFIXO")
	aadd(aStru ,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
	aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
	
	dbSeek("E1_NUM")
	aadd(aStru ,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
	aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
	
	dbSeek("E1_PARCELA")
	aadd(aStru ,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
	aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
	
	dbSeek("E1_TIPO")
	aadd(aStru ,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
	aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
	
	dbSeek("E1_CLIENTE")
	aadd(aStru ,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
	aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
	
	dbSeek("E1_LOJA")
	aadd(aStru ,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
	aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
	
	dbSeek("E1_EMISSAO")
	aadd(aStru ,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
	aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
	
	dbSeek("E1_VENCTO")
	aadd(aStru ,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
	aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
	
	dbSeek("E1_VENCREA")
	aadd(aStru ,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
	aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
	
	dbSeek("E1_VLCRUZ")
	aadd(aStru ,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
	aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
	
	dbSeek("E1_VALJUR")
	aadd(aStru ,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
	aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
	
	aadd(aStru ,{"E1_ABT","N",14,2})
	
	dbSeek("E1_SALDO")
	aadd(aStru ,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
	aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
	
	dbSeek("E1_PORCJUR")
	aadd(aStru ,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
	aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
	
	dbSeek("E1_HIST")
	aadd(aStru ,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
	aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
	
	aadd(aStru ,{"E1_ATR","N",5,0})
	aadd(aStru ,{"XX_RECNO","N",12,0})
	
	aadd(aQuery,{"E1_MOEDA","N",02,0})
	
	dbSeek("E1_VALOR")
	aadd(aStru ,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
	aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
	
	dbSeek("X5_DESCRI")
	aadd(aStru ,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
	aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
	
	SX3->(dbSetOrder(1))
	
	If ( Select(cAlias) ==	0 )
		cArquivo := CriaTrab(,.F.)
		aadd(aAlias,{ cAlias , cArquivo })
		aadd(aStru,{"FLAG","L",01,0})
		dbCreate(cArquivo,aStru)
		dbUseArea(.T.,,cArquivo,cAlias,.F.,.F.)
		IndRegua(cAlias,cArquivo,"E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO")
		
		If ( TcSrvType()!="AS/400" )
			lQuery := .T.
			cQuery := ""
			aEval(aQuery,{|x| cQuery += ","+AllTrim(x[1])})
			cQuery := "SELECT "+SubStr(cQuery,2)
			cQuery +=         ",SE1.R_E_C_N_O_ SE1RECNO "+chr(13)+chr(10)
			
			cQuery += " FROM "+RetSqlName("SE1")+" SE1,"+chr(13)+chr(10)
			cQuery += "      "+RetSqlName("SX5")+" SX5"+chr(13)+chr(10)
			cQuery += " WHERE SE1.E1_FILIAL='"+xFilial("SE1")+"' AND "+chr(13)+chr(10)
			cQuery +=        "SE1.E1_CLIENTE='"+SA1->A1_COD+"' AND "+chr(13)+chr(10)
			cQuery +=        "SE1.E1_LOJA='"+SA1->A1_LOJA+"' AND "+chr(13)+chr(10)
			cQuery +=        "SE1.E1_EMISSAO>=' ' AND "+chr(13)+chr(10)
			//cQuery +=        "SE1.E1_EMISSAO<='"+Dtos(dDataBase)+"' AND "+chr(13)+chr(10)
			cQuery +=        "SE1.E1_VENCREA>=' ' AND "+chr(13)+chr(10)
			//cQuery +=        "SE1.E1_VENCREA<='"+Dtos(dDataBase)+"' AND "+chr(13)+chr(10)
			cQuery +=        "SE1.E1_TIPO<>'PR ' AND "+chr(13)+chr(10)
			cQuery +=      	"SE1.E1_PREFIXO>='   ' AND "+chr(13)+chr(10)
			cQuery +=      	"SE1.E1_PREFIXO<='ZZZ' AND "+chr(13)+chr(10)
			//cQuery += 		"SE1.E1_FATURA IN('"+Space(Len(SE1->E1_FATURA))+"','NOTFAT') AND "+chr(13)+chr(10)
			cQuery +=      	"SE1.E1_SALDO > 0 AND "+chr(13)+chr(10)
			cQuery +=		"SE1.D_E_L_E_T_<>'*' AND "+chr(13)+chr(10)
			cQuery +=      	"SX5.X5_FILIAL='"+xFilial("SX5")+"' AND "+chr(13)+chr(10)
			cQuery +=		"SX5.X5_TABELA='07' AND "+chr(13)+chr(10)
			cQuery +=		"SX5.X5_CHAVE=SE1.E1_SITUACA AND "+chr(13)+chr(10)
			cQuery +=		"SX5.D_E_L_E_T_<>'*' "+chr(13)+chr(10)
			
			cQuery += " AND SE1.E1_TIPO NOT LIKE '__-' UNION ALL "+cQuery+chr(13)+chr(10)
			cQuery += " AND SE1.E1_TIPO LIKE '__-'"
			
			cQuery := ChangeQuery(cQuery)
			cQry   := cArquivo+"A"
			
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cQry,.T.,.T.)
			
			aEval(aQuery,{|x| If(x[2]!="C",TcSetField(cQry,x[1],x[2],x[3],x[4]),Nil)})
		Else
			cQry := "SE1"
		EndIf
		dbSelectArea(cQry)
		If ( !lQuery )
			dbSetOrder(2)
			dbSeek(xFilial("SE1")+SA1->A1_COD+SA1->A1_LOJA)
			
			bWhile := {|| !Eof() .And. xFilial("SE1") == SE1->E1_FILIAL .And.;
			SA1->A1_COD    == SE1->E1_CLIENTE .And.;
			SA1->A1_LOJA   == SE1->E1_LOJA }
			bFiltro:= {|| !(SE1->E1_TIPO $ MVABATIM) .And.;
			SE1->E1_EMISSAO <= dDataBase  .And.;
			SE1->E1_VENCREA <= dDataBase  .And.;
			SE1->E1_TIPO!="PR "			  .And.;
			SE1->E1_PREFIXO >= '   '     .And.;
			SE1->E1_PREFIXO <= 'ZZZ'     .And.;
			SE1->E1_SALDO   > 0 }
		Else
			bWhile := {|| !Eof() }
			bFiltro:= {|| .T. }
		EndIf
		
		While ( Eval(bWhile) )
			If ( Eval(bFiltro) )
				If ( !lQuery )
					dbSelectArea("SX5")
					dbSetOrder(1)
					MsSeek(xFilial("SX5")+"07"+SE1->E1_SITUACA)
				EndIf
				dbSelectArea(cAlias)
				dbSetOrder(1)
				cChave := (cQry)->(E1_CLIENTE)+(cQry)->(E1_LOJA) +;
				(cQry)->(E1_PREFIXO)+(cQry)->(E1_NUM)+;
				(cQry)->(E1_PARCELA)
				cChave += If((cQry)->(E1_TIPO)	$ MVABATIM, "",;
				(cQry)->(E1_TIPO))
				If ( !dbSeek(cChave) )
					RecLock(cAlias,.T.)
				Else
					RecLock(cAlias,.F.)
				EndIf
				DbSetOrder(1)
				nTotAbat := 0
				For nCntFor := 1 To Len(aStru)
					Do Case
						
						Case ( AllTrim(aStru[nCntFor][1])=="X5_DESCRI" )
							If ( lQuery )
								(cAlias)->X5_DESCRI := (cQry)->X5_DESCRI
							Else
								(cAlias)->X5_DESCRI := SX5->X5_DESCRI
							EndIf
							
						Case ( AllTrim(aStru[nCntFor][1])=="E1_VALJUR" )
							
						Case ( AllTrim(aStru[nCntFor][1])=="E1_ABT" )
							nTaxaM:=round((cQry)->E1_VLCRUZ / (cQry)->E1_VALOR,4)  // Pegar a taxa da moeda usada qdo da inclusão do titulo
							If ( (cQry)->(E1_TIPO)	$ MVABATIM )
								(cAlias)->E1_ABT := (nTotAbat := xMoeda((cQry)->(E1_SALDO),(cQry)->(E1_MOEDA),1,(cQry)->(E1_EMISSAO),,nTaxaM))
							Endif
							If ( !lQuery )
								(cAlias)->E1_ABT := (nTotAbat := SomaAbat(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,"R",1,,SE1->E1_CLIENTE,SE1->E1_LOJA))
							Endif
							
						Case ( AllTrim(aStru[nCntFor][1])=="E1_SALDO" )
							nTaxaM:=round((cQry)->E1_VLCRUZ / (cQry)->E1_VALOR,4)  // Pegar a taxa da moeda usada qdo da inclusão do titulo
							If ( (cQry)->(E1_TIPO)	$ MVABATIM )
								(cAlias)->E1_SALDO -= nTotAbat
							Else
								(cAlias)->E1_SALDO += xMoeda((cQry)->(E1_SALDO),(cQry)->(E1_MOEDA),1,(cQry)->(E1_EMISSAO),,ntaxaM)
							EndIf
							If ( !lQuery )
								(cAlias)->E1_SALDO -= nTotAbat
							EndIf
							
						Case ( AllTrim(aStru[nCntFor][1])=="XX_RECNO" )
							If !( (cQry)->(E1_TIPO)	$ MVABATIM )
								If ( lQuery )
									(cAlias)->XX_RECNO := (cQry)->SE1RECNO
								Else
									(cAlias)->XX_RECNO := SE1->(RecNo())
								EndIf
							Endif
							
						Case ( AllTrim(aStru[nCntFor][1])=="E1_TIPO" )
							If ( Empty((cAlias)->E1_TIPO) )
								(cAlias)->E1_TIPO := (cQry)->E1_TIPO
							EndIf
						Case ( AllTrim(aStru[nCntFor][1])=="E1_ATR" )
							If dDataBase > DataValida((cQry)->E1_VENCREA)
								(cAlias)->E1_ATR := dDataBase - (cQry)->E1_VENCREA
							Else
								(cAlias)->E1_ATR := dDataBase - DataValida((cQry)->E1_VENCREA,.T.)
							Endif
						Case ( AllTrim(aStru[nCntFor][1])=="FLAG" )
							
						OtherWise
							If ( lQuery )
								If !( (cQry)->(E1_TIPO)	$ MVABATIM )
									(cAlias)->(FieldPut(nCntFor,(cQry)->(FieldGet(FieldPos(aStru[nCntFor][1])))))
								Endif
							Else
								(cAlias)->(FieldPut(nCntFor,(cQry)->(FieldGet(FieldPos(aStru[nCntFor][1])))))
							Endif
					EndCase
				Next nCntFor
				dbSelectArea(cAlias)
				If nTotAbat = 0
					If ( (cAlias)->E1_SALDO <= 0 )
						dbDelete()
					EndIf
				Endif
				(cAlias)->E1_VALJUR := xMoeda(FaJuros((cQry)->E1_VALOR,(cAlias)->E1_SALDO,(cAlias)->E1_VENCTO,(cQry)->E1_VALJUR,(cQry)->E1_PORCJUR,(cQry)->E1_MOEDA,(cQry)->E1_EMISSAO),(cQry)->E1_MOEDA,1)
				MsUnLock()
			EndIf
			dbSelectArea(cQry)
			dbSkip()
		EndDo
		If ( lQuery )
			dbSelectArea(cQry)
			dbCloseArea()
		EndIf
		dbSelectArea(cAlias)
		IndRegua(cAlias,cArquivo,"DTOS(E1_VENCREA)")
	EndIf
	
	aView := {}
	dbSelectArea(cAlias)
	dbGotop()
	While !EOF()
		AADD( aView, {E1_PREFIXO + '-' + E1_NUM + '/' + E1_PARCELA, E1_TIPO, E1_EMISSAO, E1_VENCREA, E1_VALOR, E1_SALDO, X5_DESCRI, E1_ATR, E1_HIST})
		dbSkip()
	Enddo
	
/*--------------------------------------------------------+
| Titulos Recebidos                                       |
+---------------------------------------------------------*/
ElseIf ( nOpc == 2 )
	cAlias	:= 'FC010QRY02'
	
	dbSelectArea("SX3")
	dbSetOrder(2)
	
	dbSeek("E1_PREFIXO")
	aadd(aStru ,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
	aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
	
	dbSeek("E1_NUM")
	aadd(aStru ,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
	aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
	
	dbSeek("E1_PARCELA")
	aadd(aStru ,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
	aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
	
	dbSeek("E1_TIPO")
	aadd(aStru ,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
	aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
	
	dbSeek("E1_VLCRUZ")
	aadd(aStru ,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
	aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
	
	dbSeek("E1_VALOR")
	aadd(aStru ,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
	aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
	
	dbSeek("E5_VALOR")
	aadd(aStru ,{"E1_PAGO",SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
	aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
	
	dbSeek("E1_EMISSAO")
	aadd(aStru ,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
	aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
	
	dbSeek("E1_VENCTO")
	aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
	
	dbSeek("E1_VENCREA")
	aadd(aStru ,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
	aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
	
	dbSeek("E5_DATA")
	aadd(aStru ,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
	aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
	
	dbSeek("E5_DTDISPO")
	aadd(aStru ,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
	aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
	
	dbSeek("E5_HISTOR")
	aadd(aStru ,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
	aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
	
	dbSeek("E5_MOTBX")
	aadd(aStru ,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
	aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
	
	dbSeek("E5_TIPODOC")
	aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
	
	aadd(aStru ,{"E1_ATR","N",5,0})
	
	aadd(aStru,{"XX_RECNO","N",12,0})
	
	SX3->(DbSetOrder(1))
	
	If ( Select(cAlias) ==	0 )
		cArquivo := CriaTrab(,.F.)
		aadd(aAlias,{ cAlias , cArquivo })
		aadd(aStru,{"FLAG","L",01,0})
		dbCreate(cArquivo,aStru)
		dbUseArea(.T.,,cArquivo,cAlias,.F.,.F.)
		IndRegua(cAlias,cArquivo,"E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO")
		
		#IFDEF TOP
			If ( TcSrvType()!="AS/400" )
				cQuery := ""
				aEval(aQuery,{|x| cQuery += ","+AllTrim(x[1])})
				cQuery := "SELECT "+SubStr(cQuery,2)+",SE5.R_E_C_N_O_ SE5RECNO "+chr(13)+chr(10)
				cQuery += " FROM "+RetSqlName("SE1")+" SE1,"+chr(13)+chr(10)
				cQuery +=         RetSqlName("SE5")+" SE5 "+chr(13)+chr(10)
				cQuery += " WHERE SE1.E1_FILIAL='"+xFilial("SE1")+"' AND "+chr(13)+chr(10)
				cQuery +=       "SE1.E1_CLIENTE='"+SA1->A1_COD+"' AND "+chr(13)+chr(10)
				cQuery +=       "SE1.E1_LOJA='"+SA1->A1_LOJA+"' AND "+chr(13)+chr(10)
				cQuery +=       "SE1.E1_EMISSAO<='"+Dtos(dDataBase)+"' AND "+chr(13)+chr(10)
				cQuery +=       "SE1.E1_VENCREA<='"+Dtos(dDataBase)+"' AND "+chr(13)+chr(10)
				cQuery +=       "SE1.E1_TIPO<>'PR ' AND "+chr(13)+chr(10)
				cQuery +=       "SE1.E1_PREFIXO>='   ' AND "+chr(13)+chr(10)
				cQuery +=       "SE1.E1_PREFIXO<='ZZZ' AND "+chr(13)+chr(10)
				cQuery +=		"SE1.E1_TIPO NOT LIKE '__-' AND "+chr(13)+chr(10)
				cQuery +=		"SE1.E1_TIPO NOT IN ('RA ','PA ','"+MV_CRNEG+"','"+MV_CPNEG+"') AND "+chr(13)+chr(10)
				cQuery +=		"SE1.D_E_L_E_T_<>'*' AND "+chr(13)+chr(10)
				cQuery +=       "SE5.E5_FILIAL='"+xFilial("SE5")+"' AND "+chr(13)+chr(10)
				cQuery +=		"SE5.E5_NATUREZ=SE1.E1_NATUREZ AND "+chr(13)+chr(10)
				cQuery +=		"SE5.E5_PREFIXO=SE1.E1_PREFIXO AND "+chr(13)+chr(10)
				cQuery +=		"SE5.E5_NUMERO=SE1.E1_NUM AND "+chr(13)+chr(10)
				cQuery +=		"SE5.E5_PARCELA=SE1.E1_PARCELA AND "+chr(13)+chr(10)
				cQuery +=		"SE5.E5_TIPO=SE1.E1_TIPO AND "+chr(13)+chr(10)
				cQuery +=		"SE5.E5_CLIFOR=SE1.E1_CLIENTE AND "+chr(13)+chr(10)
				cQuery +=		"SE5.E5_LOJA=SE1.E1_LOJA AND "+chr(13)+chr(10)
				cQuery +=		"SE5.E5_RECPAG='R' AND "+chr(13)+chr(10)
				cQuery +=		"SE5.E5_SITUACA<>'C' AND "+chr(13)+chr(10)
				cQuery +=		"SE5.D_E_L_E_T_<>'*' AND NOT EXISTS ("+chr(13)+chr(10)
				cQuery += " SELECT A.E5_NUMERO "+chr(13)+chr(10)
				cQuery += " FROM "+RetSqlName("SE5")+" A "+chr(13)+chr(10)
				cQuery += " WHERE A.E5_FILIAL='"+xFilial("SE5")+"' AND "+chr(13)+chr(10)
				cQuery +=		"A.E5_NATUREZ=SE5.E5_NATUREZ AND "+chr(13)+chr(10)
				cQuery +=		"A.E5_PREFIXO=SE5.E5_PREFIXO AND "+chr(13)+chr(10)
				cQuery +=		"A.E5_NUMERO=SE5.E5_NUMERO AND "+chr(13)+chr(10)
				cQuery +=		"A.E5_PARCELA=SE5.E5_PARCELA AND "+chr(13)+chr(10)
				cQuery +=		"A.E5_TIPO=SE5.E5_TIPO AND "+chr(13)+chr(10)
				cQuery +=		"A.E5_CLIFOR=SE5.E5_CLIFOR AND "+chr(13)+chr(10)
				cQuery +=		"A.E5_LOJA=SE5.E5_LOJA AND "+chr(13)+chr(10)
				cQuery +=		"A.E5_SEQ=SE5.E5_SEQ AND "+chr(13)+chr(10)
				cQuery +=		"A.E5_TIPODOC='ES' AND "+chr(13)+chr(10)
				cQuery +=		"A.E5_RECPAG<>'R' AND "+chr(13)+chr(10)
				cQuery +=		"A.D_E_L_E_T_<>'*')"
				
				cQuery := ChangeQuery(cQuery)
				cQry   := cArquivo+"A"
				
				dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cQry,.T.,.T.)
				
				aEval(aQuery,{|x| If(x[2]!="C",TcSetField(cQry,x[1],x[2],x[3],x[4]),Nil)})
				
				dbSelectArea(cQry)
				bWhile := {|| !Eof() }
				bFiltro:= {|| (cQry)->E5_TIPODOC $ "VL/BA/V2/CP/LJ/R$" }
				cAnterior := ""
				While ( Eval(bWhile) )
					If ( Eval(bFiltro) )
						dbSelectArea(cAlias)
						dbSetOrder(1)
						RecLock(cAlias,.T.)
						For nCntFor := 1 To Len(aStru)
							Do Case
								Case ( AllTrim(aStru[nCntFor][1])=="E1_PAGO" )
									If ( (cQry)->E5_TIPODOC $ "VL/BA/V2/CP/LJ/R$" )
										(cAlias)->E1_PAGO += (cQry)->E5_VALOR
									EndIf
								Case ( AllTrim(aStru[nCntFor][1])=="E1_VLCRUZ" )
									If ( (cQry)->E5_TIPODOC $ "VL/BA/V2/CP/LJ/R$" )
										If cAnterior != (cQry)->(E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO)
											(cAlias)->E1_VLCRUZ := (cQry)->E1_VLCRUZ
											cAnterior := (cQry)->(E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO)
										Endif
									EndIf
								Case ( AllTrim(aStru[nCntFor][1])=="E1_ATR" )
									If (cQry)->E5_DATA > DataValida((cQry)->E1_VENCREA,.T.)
										(cAlias)->E1_ATR := (cQry)->E5_DATA - (cQry)->E1_VENCREA
									Else
										(cAlias)->E1_ATR := (cQry)->E5_DATA - DataValida((cQry)->E1_VENCREA,.T.)
									Endif
								Case ( AllTrim(aStru[nCntFor][1])=="XX_RECNO" )
									(cAlias)->XX_RECNO := (cQry)->SE5RECNO
								Case ( AllTrim(aStru[nCntFor][1])=="FLAG" )
									
								OtherWise
									(cAlias)->(FieldPut(nCntFor,(cQry)->(FieldGet(FieldPos(aStru[nCntFor][1])))))
							EndCase
						Next nCntFor
						(cAlias)->(MsUnLock())
					EndIf
					dbSelectArea(cQry)
					dbSkip()
				EndDo
				dbSelectArea(cQry)
				dbCloseArea()
			Else
		#ENDIF
			dbSelectArea("SE1")
			dbSetOrder(2)
			dbSeek(xFilial("SE1")+SA1->A1_COD+SA1->A1_LOJA)
			bWhile := {|| !Eof() .And. xFilial("SE1") == SE1->E1_FILIAL .And.;
			SA1->A1_COD    == SE1->E1_CLIENTE .And.;
			SA1->A1_LOJA   == SE1->E1_LOJA }
			bFiltro:= {|| 	SubStr(SE1->E1_TIPO,3,1)!="-" .And.;
			SE1->E1_EMISSAO <= dDataBase .And.;
			SE1->E1_VENCREA <= dDataBase .And.;
			SE1->E1_TIPO!="PR "          .And.;
			SE1->E1_PREFIXO >= '   '     .And.;
			SE1->E1_PREFIXO <= 'ZZZ'}
			While ( Eval(bWhile) )
				If ( Eval(bFiltro) )
					dbSelectArea("SE5")
					dbSetOrder(4)
					dbSeek(xFilial("SE5")+SE1->E1_NATUREZ+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+SE1->E1_TIPO)
					
					While ( !Eof() .And. xFilial("SE5") == SE5->E5_FILIAL .And.;
						SE1->E1_NATUREZ == SE5->E5_NATUREZ .And.;
						SE1->E1_PREFIXO == SE5->E5_PREFIXO .And.;
						SE1->E1_NUM == SE5->E5_NUMERO      .And.;
						SE1->E1_PARCELA == SE5->E5_PARCELA .And.;
						SE1->E1_TIPO == SE5->E5_TIPO )
						
						If ((!SE5->E5_TIPO $ "RA /PA /"+MV_CRNEG+"/"+MV_CPNEG) .And. !TemBxCanc() .and. ;
							SE5->E5_SITUACA <> "C" .And. SE5->E5_TIPODOC $ "VL/BA/V2/CP/LJ/R$")
							RecLock(cAlias,.T.)
							For nCntFor := 1 To Len(aStru)
								Do Case
									Case ( AllTrim(aStru[nCntFor][1])=="E1_PAGO" )
										If ( SE5->E5_TIPODOC $ "VL/BA/V2/CP/LJ/R$" )
											(cAlias)->E1_PAGO += SE5->E5_VALOR
										EndIf
									Case ( AllTrim(aStru[nCntFor][1])=="E1_VLCRUZ" )
										If ( SE5->E5_TIPODOC $ "VL/BA/V2/CP/LJ/R$" )
											(cAlias)->E1_VLCRUZ := SE1->E1_VLCRUZ
										EndIf
									Case ( AllTrim(aStru[nCntFor][1])=="E1_ATR" )
										If SE5->E5_DATA > DataValida(SE1->E1_VENCREA,.T.)
											(cAlias)->E1_ATR := SE5->E5_DATA - SE1->E1_VENCREA
										Else
											(cAlias)->E1_ATR := SE5->E5_DATA - DataValida(SE1->E1_VENCREA,.T.)
										Endif
									Case ( AllTrim(aStru[nCntFor][1])=="XX_RECNO" )
										(cAlias)->XX_RECNO := SE5->(RecNo())
									Case ( "E5_"$AllTrim(aStru[nCntFor][1]) )
										(cAlias)->(FieldPut(nCntFor,SE5->(FieldGet(FieldPos(aStru[nCntFor][1])))))
									Case ( AllTrim(aStru[nCntFor][1])=="FLAG" )
									OtherWise
										(cAlias)->(FieldPut(nCntFor,SE1->(FieldGet(FieldPos(aStru[nCntFor][1])))))
								EndCase
							Next nCntFor
							(cAlias)->(MsUnLock())
						EndIf
						dbSelectArea("SE5")
						dbSkip()
					EndDo
				EndIf
				dbSelectArea("SE1")
				dbSkip()
			EndDo
		EndIf
		dbSelectArea(cAlias)
		IndRegua(cAlias,cArquivo,"DTOS(E1_VENCREA)")
	EndIf
	
	aView := {}
	dbSelectArea(cAlias)
	dbGotop()
	While !EOF()
		AADD( aView, {E1_PREFIXO + '-' + E1_NUM + '/' + E1_PARCELA, E1_TIPO, E1_EMISSAO, E1_VENCREA, E1_VALOR, E1_PAGO, E5_MOTBX, E1_ATR, E5_HISTOR})
		dbSkip()
	Enddo
	
EndIf

(cAlias)->(dbCloseArea())
Ferase(cArquivo+GetDBExtension())
Ferase(cArquivo+OrdBagExt())

Return aView

/*-----------------------+-------------------------------+------------------+
|   Programa: AVWFPsqDoc | Autor: Kley@TOTVS             | Data: 25/06/2014 |
+------------------------+-------------------------------+------------------+
|  Descricao: Pesquisa os documentos do Banco de Conhecimento associados ao 
|             respectivo Titulo do Contas a Pagar.
|
|			  Parâmetros recebidos:
|				<ExpC1> - cChvSA1WF = Chave do Documento
|						   SA1 -> A1_FILIAL + A1_FORNECE + A1_LOJA
+---------------------------------------------------------------------------+
|    Projeto: AVANT
+---------------------------------------------------------------------------+
|    Sintaxe: AVWFPsqDoc( SA1 ->( A1_FILIAL + A1_FORNECE + A1_LOJA ) )
+----------------------------------------------------------------------------
|    Retorno: aDocBcoCto                                                               
|             Retorna um array de três dimensões, e cada um contendo:
|				[1] = Descrição do Documento
|				[2] = Nome do objetivo/arquivo
|				[3] = Origem, SE2 ou SF1
+--------------------------------------------------------------------------*/

Static Function AVWFPsqDoc(cChvSA1WF)

Local cFunc	   := "AVWFPsqDoc"
Local cAlias	   := GetNextAlias()
Local aDocBcoCto := {}							//Array com os Documentos do Banco de Conhecimento
Local cFilCli	   := Substr(cChvSA1WF,1,TamSX3("A1_FILIAL")[1])
Local cCodCli	   := Substr(cChvSA1WF,TamSX3("A1_FILIAL")[1]+1,TamSX3("A1_COD")[1])
Local cLojaCli   := Substr(cChvSA1WF,TamSX3("A1_FILIAL")[1]+TamSX3("A1_COD")[1]+1,TamSX3("A1_LOJA")[1])

If Select(cAlias) > 0
	(cAlias)->(dbCloseArea())
Endif

//Busca Documento do Banco de Conhecimento relacionado ao Título AP ou ao Documento de Entrada
BeginSQL Alias cAlias
	select top 1 AC9_FILENT, AC9_CODENT, AC9_ENTIDA, ACB_CODOBJ, ACB_OBJETO, ACB_DESCRI,
		   case AC9_ENTIDA when 'SA1' then 'Cliente' else AC9_ENTIDA end as AC9ENTIDA
	from %Table:AC9% AC9
	inner join %Table:ACB% ACB on ACB_FILIAL = AC9_FILIAL and ACB_CODOBJ = AC9_CODOBJ and ACB.%NotDel%
	inner join %Table:SA1% SA1 on A1_FILIAL  = AC9_FILENT and rtrim(A1_COD+A1_LOJA) = rtrim(AC9_CODENT) and SA1.%NotDel%
	where AC9_FILIAL = '010104' and AC9_ENTIDA = 'SA1'
	  and AC9_FILENT = %Exp:cFilCli%
	  and rtrim(AC9_CODENT) = rtrim(%Exp:cCodCli+cLojaCli%)
	  and AC9.%NotDel%
	order by AC9_CODOBJ desc
EndSQL

While !(cAlias)->(Eof())
	aAdd(aDocBcoCto, {ACB_DESCRI,ACB_OBJETO,AC9ENTIDA})
	(cAlias)->(DbSkip())
EndDo

(cAlias)->(dbCloseArea())

Return(aDocBcoCto)
