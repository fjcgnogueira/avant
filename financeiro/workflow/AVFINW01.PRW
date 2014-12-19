#include "TOTVS.ch"
#include "TbiConn.ch"
#include "TbiCode.ch"
#include "TopConn.ch"

/*----------------------+--------------------------------+------------------+
|   Programa: AVFINW01  | Autor: Pedro Augusto           | Data: Maio/2014  |
+-----------------------+--------------------------------+------------------+
|  Descricao: Workflow de Liberação de Pagamento de Títulos do Contas a Pagar
|			  - Envio/Retorno dos Títulos para Aprovação 
|			  - Tratamento das respostas via HTTP
|			  - Envio de e-mail de pedidos de compra aprovados / reprovados aos compradores
|			  - Envio de notificações de pedidos nao respondidos (TimeOut)
|+---------------------------------------------------------------------------+
|    Projeto: AVANT
+---------------------------------------------------------------------------+
|    Sintaxe: U_AVCOMW10()
+----------------------------------------------------------------------------
|    Retorno: Nulo                                                               
+--------------------------------------------------------------------------*/

/*-------------------------------------------------------------------------+
|  Processa todas as atividades por Empresa                                |                                            
+--------------------------------------------------------------------------*/
User Function AVFNW101()				//Empresa "01"

Private _aMatriz  := {"01","010104"}  

ConOut("["+DtoC(Date()) + ' ' + Time()+"] [U_AVFNW101] Inicio do processamento - Workflow CP.")

RpcSetType(3)
RpcSetEnv(_aMatriz[1],_aMatriz[2])
U_WKFCP(1)  		// 1 - ENVIO AP PARA APROVADORES
U_WKFCP(3)  		// 3 - ENVIO AP ITENS APROVADOS PARA SOLICITANTE
U_WKFCP(4)  		// 4 - ENVIO AP ITENS REPROVADOS PARA SOLICITANTE
RpcClearEnv()

ConOut("["+DtoC(Date()) + ' ' + Time()+"] [U_AVFNW101] Final do processamento - Workflow CP.")

Return

/*-------------------------------------------------------------------------+
|  Envio/Retorno dos Títulos para Aprovação                                |                                            
+--------------------------------------------------------------------------*/
User Function AVFINW01()
Local _nEmp
Private _aMatriz  := {"01","010101"}  // para abrir a 1a empresa //
Private _aEmpresa := {}  
Private _aNoEmp   := {}

U_CONSOLE('Inicio do processamento - CP() ',cFunc)
RpcSetType(3)
RpcSetEnv(_aMatriz[1],_aMatriz[2])

// Se o JOB ja estiver em execucao, nao continua
IF !LockByName("AVFINW01")
	Conout("JOB de aprovação de Contas a Pagar já estava em execução: Finalizado em " + DTOC(dDATABASE) + " - " + TIME() )
	RpcClearEnv()										// Limpa o ambiente, liberando a licença e fechando as conexões
    RETURN
ENDIF

//	_aNoEmp := StrToArray(GetMv("SV_EMPNAO"),";") // para excluir empresas do processo

DBSelectArea("SM0")
DBSetOrder(1)
DBSeek(_aMatriz[1],.F.)

WHILE !SM0->(EOF())                       
	Aadd(_aEmpresa, {SM0->M0_CODIGO,Alltrim(SM0->M0_CODFIL)})  
	SM0->(DBSkip())
END
RpcClearEnv()

For _nEmp := 1 To Len(_aEmpresa)   
	U_CP({_aEmpresa[_nEmp]})  		
Next 
U_CONSOLE('Final do processamento - CP() ',cFunc)
Return
   	
/*-------------------------------------------------------------------------+
|  Prepara ambiente - Empresa / Filial                                     |                                            
+--------------------------------------------------------------------------*/
User Function CP( aParam )
Local cFunc		:= "U_CP"

If aParam == Nil .OR. VALTYPE(aParam) == "U"
	U_CONSOLE("Parametros nao recebidos => CP()",cFunc)
	RETURN
EndIf
RpcSetType(3)
RpcSetEnv(aParam[1][1],aParam[1][2])
U_CONSOLE('CP(aParam)inicio:' + aParam[1][1]   +'/'+ aParam[1][2],cFunc)
U_WKFCP(1)  		// 1 - ENVIO PC PARA APROVADORES
U_WKFCP(3)  		// 3 - ENVIO PC ITENS APROVADOS PARA SOLICITANTE
U_WKFCP(4)  		// 4 - ENVIO PC ITENS REPROVADOS PARA SOLICITANTE
RpcClearEnv()
U_CONSOLE('CP(aParam) final:' + aParam[1][1]   +'/'+ aParam[1][2],cFunc)
RETURN
 
/*-------------------------------------------------------------------------+
|Rotina principal:														   |
|	- envio de e-mail de titulos para aprovacao                            |
|	- Tratamento das respostas via HTTP                                    |
|	- envio de e-mail de titulos aprovados / reprovados aos users do       |
|     financeiro                                                           |  
|  Prepara ambiente - Empresa / Filial                                     |                                            
+--------------------------------------------------------------------------*/
User Function WKFCP(_nOpc, oProcess)      
Local _lProcesso  := .F.
Local cCodFil	  := ""
Local cChaveSCR	  := ""
Local cFunc		  := "U_WKFCP"
	
Local cObs 		  := ""
Local cGrupo	  := "" , lLiberou	:= .F. 
Local cCodUsrFin  := AllTrim(GetNewPar("MV_XWFUSFI",""))
Local nTamUsrFin  := 0
Local aCodUsrFin  := {}
Local lValUsrAnC  := .F.

Local _cMailDest  := ""
Local cAlias	  := GetNextAlias()
Local nTotalTit	  := 0
Local cParcelas	  := ""
Local cChvSE2WF	  := ""
Local cCRNum	  := ""
Local cSCRChave	  := ""
Local cEmailDest  := ""
Local nX		  := 0
Local nY		  := 0
Local nTamChSCR	  := TamSX3("E2_PREFIXO")[1] + TamSX3("E2_NUM")[1] + TamSX3("E2_TIPO")[1] + TamSX3("E2_FORNECE")[1] + TamSX3("E2_LOJA")[1]
Local nTamChSE2	  := TamSX3("E2_PREFIXO")[1] + TamSX3("E2_NUM")[1] + TamSX3("E2_TIPO")[1] + TamSX3("E2_FORNECE")[1] + TamSX3("E2_LOJA")[1] + TamSX3("E2_PARCELA")[1]
Local aDocBcoCto  := {}

Local nTamSCRCpo  := 0
Local cCRFilial	  := ""
Local cCRTipo	  := ""
Local cCRNum	  := ""
Local cCRNivel	  := ""
Local cCRUser	  := ""
Local aVarChvSCR  := {}
Local aCpoChvSCR  := {}

Private _aWF    := {}
Private _aReturn

//Array com os codigos dos usuarios do Financeiro do parametro MV_XWFUSFI
While Len(cCodUsrFin) - nTamUsrFin >= 6
	aAdd(aCodUsrFin, AVWFPsqUsr(Substr(cCodUsrFin,nTamUsrFin+1,6)) )		// codigo, nome completo, e-mail do usuário
	//ConOut("["+DtoC(Date())+" "+Time()+"] ["+cFunc+"] Usr.Financ. | Cod./Nome/Email: " + aCodUsrFin[Len(aCodUsrFin),1] + "/" + aCodUsrFin[Len(aCodUsrFin),2] + "/" + aCodUsrFin[Len(aCodUsrFin),3] )
	lValUsrAnC := .T.
	nTamUsrFin += 7	
EndDo

For nY := 1 to Len(aCodUsrFin)
	If nY == 1
		_cMailDest := aCodUsrFin[nY,3]
	Else
		_cMailDest += ";" + aCodUsrFin[nY,3]		
	EndIf
Next nY

ChkFile("SCR")
ChkFile("SA2")
ChkFile("SE2")
	
DO 	CASE 

	/*-------------------------------------------------------------------------+
	|  1 - Prepara os titulos a serem enviados para aprovacao                  |                                            
	+--------------------------------------------------------------------------*/
	CASE _nOpc == 1
   		U_CONSOLE("1 - Prepara Titulos a serem enviados para aprovacao",cFunc)
		U_CONSOLE("1 - EmpFil: " + cEmpAnt + cFilAnt,cFunc)

		If Select("TMP") > 0
			("TMP")->(dbCloseArea())
		Endif
  		
		//Busca as Alçada pendentes de aprovação de Títulos AP
  		BeginSQL Alias "TMP"
			select
				CR_FILIAL, CR_TIPO, left(CR_NUM,%Exp:nTamChSCR%) as CRNUM, min(CR_NUM) as CR_NUM, CR_NIVEL, CR_USER, CR_APROV
			from %Table:SCR% SCR
			where CR_FILIAL = %xFilial:SCR%
			  and CR_TIPO   = 'TP'
			  and CR_STATUS = '02'
			  and CR_WF     = ' '
			  and SCR.%NotDel%
			group by CR_FILIAL, CR_TIPO, left(CR_NUM,%Exp:nTamChSCR%), CR_NIVEL, CR_USER, CR_APROV
			order by CR_FILIAL, CR_TIPO, CR_NUM, CR_NIVEL, CR_USER, CR_APROV
  		EndSQL

		TMP->(dbGoTop())
		While !TMP->(Eof())
            
			If Select(cAlias) > 0
				(cAlias)->(dbCloseArea())
			Endif
			//Busca os Títulos AP relacionados às Alçadas; se o Título AP não for localizado o SALDO ficará como '0' (zero)
			BeginSQL Alias cAlias
				select
					CR_FILIAL, CR_TIPO, CR_NUM, CR_NIVEL, CR_USER, CR_APROV, CR_EMISSAO
				   ,isnull(E2_SALDO,0)    as E2_SALDO,   isnull(E2_DATALIB,'') as E2_DATALIB, isnull(E2_USUALIB,'') as E2_USUALIB
				   ,isnull(E2_VENCREA,'') as E2_VENCREA
				   ,isnull(E2_FILIAL,'')  as E2_FILIAL
				   ,isnull(E2_PREFIXO,'') as E2_PREFIXO, isnull(E2_NUM,'')     as E2_NUM,     isnull(E2_TIPO,'')    as E2_TIPO
				   ,isnull(E2_FORNECE,'') as E2_FORNECE, isnull(E2_LOJA,'')    as E2_LOJA,    isnull(E2_PARCELA,'') as E2_PARCELA
				from %Table:SCR% SCR
				left join %Table:SE2% SE2 on E2_FILIAL = %xFilial:SE2% and E2_PREFIXO+E2_NUM+E2_TIPO+E2_FORNECE+E2_LOJA+E2_PARCELA = left(CR_NUM,%Exp:nTamChSE2%) and SE2.%NotDel%
				where CR_FILIAL = %Exp:TMP->CR_FILIAL% and left(CR_NUM,%Exp:nTamChSCR%) = %Exp:Left(TMP->CR_NUM,nTamChSCR)%
				  and CR_TIPO   = 'TP'
				  and CR_STATUS = '02'
				  and CR_WF     = ' '
				  and SCR.%NotDel%
				order by CR_FILIAL, CR_TIPO, CR_NUM, CR_NIVEL, CR_USER, CR_APROV
			EndSQL
				  //and CR_NIVEL  = %Exp:TMP->CR_NIVEL% and CR_USER = %Exp:TMP->CR_USER%
			
			cParcelas	:= ""									//Limpa conteúdo das parcelas
			nTotalTit	:= 0									//Zera Total do Título
			cChvSE2WF	:= ""									//Chave do Titulo a Pagar SEM PARCELA
			aDocBcoCto	:= {}									//Documentos do Banco de Conhecimento
			While !(cAlias)->(Eof())
				If (cAlias)->E2_SALDO = 0 .or. ( !Empty((cAlias)->E2_DATALIB) .and. !Empty((cAlias)->E2_USUALIB) )
					// Se o Saldo do Titulo AP for zero é porque: Não foi localizado ou Já foi Baixado;
					// Ou Se já estiver aprovado, então flega SCR como enviado/processado
					U_CONSOLE("Título AP (SE2) não localizado, Já Baixado ou Já Aprovado. Fil/Num: "+ (cAlias)->CR_FILIAL+"/"+RTrim((cAlias)->CR_NUM),cFunc)
			   		SCR->(DBSetOrder(1), DbGoTop())
			   		SCR->(DBSeek((cAlias)->(CR_FILIAL+CR_TIPO+CR_NUM+CR_NIVEL)))
			   		While !SCR->(Eof()) .and. SCR->(CR_FILIAL+CR_TIPO+CR_NUM+CR_NIVEL) = (cAlias)->(CR_FILIAL+CR_TIPO+CR_NUM+CR_NIVEL)
			   			If SCR->CR_USER == (cAlias)->CR_USER
							Reclock("SCR",.F.)
								SCR->CR_WF			:= "1" 		// Status 1 - envio para aprovadores / branco-nao houve envio
			     	  			SCR->CR_X_WFID		:= "N/D"	// Rastreabilidade
							MsUnlock("SCR")
						EndIf
						SCR->(DbSkip())
					EndDo					
				Else
					If Empty(cChvSE2WF)
						cChvSE2WF	:= (cAlias)->(E2_FILIAL + E2_PREFIXO + E2_NUM + E2_TIPO + E2_FORNECE + E2_LOJA)					
					EndIf					

					If Len( AVWFPsqDoc(cChvSE2WF) ) == 0 			// Pesquisa os documentos do Banco de Conhecimento	
						SE2->(DbOrderNickName("SE2WF01"), DbGoTop()) 
						If SE2->(dbSeek( (cAlias)->(E2_FILIAL+E2_PREFIXO+E2_NUM+E2_TIPO+E2_FORNECE+E2_LOJA+E2_PARCELA) ) )
							Reclock("SE2",.F.)
								SE2->E2_X_WF	:= "9"			// (branco)=Não Enviado | 1=E-mail Enviado | 9=Tentativa de Envio sem Documento Anexo
							MsUnlock("SE2")
						EndIf
					Else
						cParcelas += Iif(!Empty(cParcelas)," | ","")
						cParcelas += Iif(Empty((cAlias)->E2_PARCELA),"",(cAlias)->E2_PARCELA + " - ") + DtoC(StoD((cAlias)->E2_VENCREA)) + " - " + Transform((cAlias)->E2_SALDO, PesqPict("SE2","E2_SALDO"))
						nTotalTit += (cAlias)->E2_SALDO
					EndIf
				
				EndIf
				(cAlias)->(DbSkip())
			EndDo
			(cAlias)->(dbCloseArea())
			
		   	If nTotalTit # 0
		   		aDocBcoCto	:= AVWFPsqDoc(cChvSE2WF)			// Pesquisa os documentos do Banco de Conhecimento
			EndIf
			
			If Len(aDocBcoCto) == 0
				U_Console("Nao existem anexos. Processamento abortado!"+CRLF+Space(30)+"SCR Fil/Num: "+ TMP->CR_FILIAL+"/"+RTrim(TMP->CR_NUM),cFunc)				
			Else
				U_Console("Encontrado anexos. Processando o envio..."+CRLF+Space(30)+"SCR Fil/Num: "+ TMP->CR_FILIAL+"/"+RTrim(TMP->CR_NUM),cFunc)				

	   			_aWF := U_EnviaCP(TMP->CR_FILIAL, TMP->CR_NUM, TMP->CR_USER, TMP->(CR_FILIAL+CR_TIPO+CR_NUM+CR_NIVEL+CR_USER), nTotalTit, , , _nOpc, cParcelas, cChvSE2WF)
				_lProcesso 	:= .T.

		   		SCR->(DBOrderNickName("SCRWF01"), DbGoTop())
		   		SCR->(DBSeek(TMP->(CR_FILIAL+CR_TIPO+CR_NUM)))
		   		While !SCR->(Eof()) .and. SCR->(CR_FILIAL+CR_TIPO) == TMP->(CR_FILIAL+CR_TIPO) .and. Left(SCR->CR_NUM,nTamChSCR) = Left(TMP->CR_NUM,nTamChSCR)
			   		If SCR->CR_NIVEL == TMP->CR_NIVEL .and. SCR->CR_USER == TMP->CR_USER .and. Empty(SCR->CR_WF)
						Reclock("SCR",.F.)
							SCR->CR_WF		:= Iif(Empty(_aWF[1])," ","1")  	// Status 1 - envio para aprovadores / branco-nao houve envio
				  			SCR->CR_X_WFID	:= _aWF[1]	                    	// Rastreabilidade
						MsUnlock("SCR")
					EndIf
					SCR->(DbSkip())
				EndDo					

			EndIf

			TMP->(DbSkip())           
		EndDo

		TMP->(dbCloseArea())

	/*-------------------------------------------------------------------------+
	|  2 - Processa O RETORNO DO EMAIL                                         |                                             
	+--------------------------------------------------------------------------*/
	CASE _nOPC	== 2
	
		U_CONSOLE("2 - Processa O RETORNO DO EMAIL",cFunc)
		U_CONSOLE("2 - EmpFil: " + cEmpAnt + cFilAnt,cFunc)

		//__cChaveSCR	:= alltrim(oProcess:oHtml:RetByName("CHAVE"))
		//_cChaveSCR	:= Padr(__cChaveSCR,60)+_cAprov

		cCodFil		:= oProcess:oHtml:RetByName("CFILANT")
		cChaveSCR	:= oProcess:oHtml:RetByName("CHAVE")
		cOpc     	:= AllTrim(oProcess:oHtml:RetByName("OPC"))
		cObs     	:= AllTrim(oProcess:oHtml:RetByName("OBS"))
		cWFID     	:= AllTrim(oProcess:oHtml:RetByName("WFID"))

		oProcess:Finish() // FINALIZA O PROCESSO
		
		U_CONSOLE("Parametros Recebidos...",cFunc)
		U_CONSOLE("2 - cFilAnt    : " + cFilAnt,cFunc)
		U_CONSOLE("2 - cChaveSCR  : " + cChaveSCR,cFunc)
		U_CONSOLE("2 - Opc        : " + cOpc,cFunc)
		U_CONSOLE("2 - Obs        : " + cObs,cFunc)
		U_CONSOLE("2 - WFId       : " + cWFID,cFunc)

		If cOpc $ "S|N"  // Aprovacao S-Sim N-Nao
			// Posiciona na tabela de Alcadas 
			DBSelectArea("SCR")
			//DBSetNickName (2)
			//DBSeek(__cChaveSCR)  
			
		    aCpoChvSCR	:= {"CR_FILIAL","CR_TIPO","CR_NUM","CR_NIVEL","CR_USER"}	//Posições Fixas; se alterar varrer o fonte
		    aVarChvSCR	:= Array(Len(aCpoChvSCR))
			nTamSCRCpo	:= 0
		    For nX := 1 To Len(aCpoChvSCR)
		    	aVarChvSCR[nX]	:= Substr(cChaveSCR,nTamSCRCpo+1,TamSX3(aCpoChvSCR[nX])[1])
				nTamSCRCpo	+= TamSX3(aCpoChvSCR[nX])[1]
				U_Console("2 - "+ PadR(aCpoChvSCR[nX],10) +" : " + aVarChvSCR[nX],cFunc)
			Next nX

	   		SCR->(DBOrderNickName("SCRWF01"), DbGoTop())				//CR_FILIAL+CR_TIPO+CR_NUM+CR_NIVEL+CR_USER
	   		SCR->(DBSeek(cChaveSCR))
	   		While !SCR->(Eof()) .and. SCR->(CR_FILIAL+CR_TIPO)    == aVarChvSCR[1]+ aVarChvSCR[2] ;
	   							.and. Left(SCR->CR_NUM,nTamChSCR) == Left(aVarChvSCR[3],nTamChSCR)
	   							//.and. SCR->CR_NIVEL == aVarChvSCR[4] .and. SCR->CR_USER == aVarChvSCR[5]
		   		If SCR->CR_NIVEL == aVarChvSCR[4] .and. SCR->CR_USER == aVarChvSCR[5] .and. ;
		   		   SCR->CR_X_WFID == cWFID .and. (Empty(SCR->CR_DATALIB) .and. !(SCR->CR_STATUS $ "03/04/05"))

					Reclock("SCR",.F.)
						SCR->CR_WF	:= "2"  							// Status 1 - envio para aprovadores / branco-nao houve envio / 2 - respondido
					MsUnlock("SCR")

					// Verifica se o titulo esta aprovado; Se estiver, finaliza o processo
					DbSelectArea("SE2")
					DbOrderNickName("SE2WF01")
					SE2->(dbSeek(xFilial("SE2")+Left(SCR->CR_NUM,nTamChSE2)))
					While !SE2->(Eof()) .and. SE2->(E2_FILIAL+E2_PREFIXO+E2_NUM+E2_TIPO+E2_FORNECE+E2_LOJA+E2_PARCELA) == xFilial("SE2")+Left(SCR->CR_NUM,nTamChSE2)

						If Empty(SE2->E2_DATALIB) 						//Título ainda Bloqueado

							lLiberou := MaAlcDoc({SCR->CR_NUM,"TP",SCR->CR_TOTAL,SCR->CR_APROV,,Alltrim(GetMV("MV_XGRAPRO")),,,,,cObs},msdate(),If(cOpc=="S",4,6))
							U_CONSOLE("2 - Liberado :" + Iif(lLiberou, "Sim", "Nao"),cFunc)
		
							If lLiberou
								U_CONSOLE("2 - Liberando titulo :" + Left(SCR->CR_NUM,nTamChSE2),cFunc)
				                Reclock("SE2",.F.)
									SE2->E2_DATALIB := dDataBase
									SE2->E2_USUALIB := UsrRetName(SCR->CR_USER)
									SE2->E2_X_WF    := " "
								SE2->(MsUnlock())
							EndIf
						Else
							U_CONSOLE("2 - Processo ja respondido via sistema :" + cWFID,cFunc)
						EndIf

						_lProcesso := .T.
						SE2->(DbSkip())
					EndDo

		   		ElseIf SCR->CR_NIVEL == aVarChvSCR[4] .and. SCR->CR_USER == aVarChvSCR[5] .and. ;
				       SCR->CR_X_WFID # cWFID
					U_CONSOLE("2 - Processo nao encontrado            :" + cWFID + CRLF + Space(30) +"2 - Processo atual :" + SCR->CR_X_WFID,cFunc)
					U_CONSOLE("2 - Semaforo Verde",cFunc)
					//Return .T.
		   		ElseIf SCR->CR_NIVEL == aVarChvSCR[4] .and. SCR->CR_USER == aVarChvSCR[5] .and. ;
				       !Empty(SCR->CR_DATALIB) .and. SCR->CR_STATUS $ "03/04/05"
					U_CONSOLE("2 - Processo ja respondido via sistema :" + cWFID,cFunc)
					//Return .T.
				EndIf

				SCR->(DbSkip())
			EndDo					

			If !SCR->(Found())  
				U_CONSOLE("2 - Processo nao encontrado (Chave SCR): "+cChaveSCR,cFunc)
				U_CONSOLE("2 - Semaforo Verde",cFunc)
				//Return .T.
			Endif
							
		EndIf				

	/*-------------------------------------------------------------------------+
	|  3 - Envia resposta de titulos aprovado para o usuário do financeiro     |                                             
	+--------------------------------------------------------------------------*/
	CASE _nOpc == 3
		U_CONSOLE("3 - Envia resposta Titulo aprovado p/ Financeiro",cFunc)
		U_CONSOLE("3 - EmpFil: " + cEmpAnt + cFilAnt,cFunc)

		If !lValUsrAnC
			ConOut("["+DtoC(Date())+" "+Time()+"] ["+cFunc+"] " + " - ERRO no conteúdo do parâmetro MV_XWFUSFI. Código do usuário informado não é valido")
		EndIf
	  	/*_cQuery := ""
	  	_cQuery += " SELECT"
	  	_cQuery += " E2_FILIAL," 
	  	_cQuery += " E2_PREFIXO,"
	  	_cQuery += " E2_NUM,"  
	  	_cQuery += " E2_PARCELA," 
	  	_cQuery += " E2_TIPO,"
	  	_cQuery += " E2_FORNECE,"
	  	_cQuery += " E2_LOJA"
	  	_cQuery += " FROM " + RetSqlName("SE2") + " SE2"
	  	_cQuery += " WHERE SE2.D_E_L_E_T_ <> '*'"
	  	_cQuery += " AND E2_FILIAL   = '" + xFilial("SE2") + "'"
	  	_cQuery += " AND E2_DATALIB <> '' "
	  	_cQuery += " AND E2_USUALIB <> '' "
	  	_cQuery += " AND E2_X_WF <> '1'"	      			// (branco)=Não Enviado | 1=E-mail Enviado | 9=Tentativa de Envio sem Documento Anexo
	  	_cQuery += " ORDER BY"
	  	_cQuery += " E2_FILIAL," 
       	_cQuery += " E2_PREFIXO,"
	  	_cQuery += " E2_NUM "

    	TcQuery _cQuery New Alias "TMP"
		dbGotop()
		
		While !TMP->(Eof())
			_cNum	   := TMP->(E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA)
			DBSelectarea("SCR")
			DBSetOrder(1)
			DBSeek(TMP->(E2_FILIAL+"TP"+_cNum),.T.)
			_lAchou  := .F.
			_lAprov	:= .F.
			_cChave	:= ''
			nTotalTit	:= 0
			While !SCR->(EOF()) 						.AND. ;
	   		   	SCR->CR_FILIAL		== TMP->E2_FILIAL  	.AND. ;
	   			SCR->CR_TIPO 	    == "TP" 			.AND. ;
	       		SCR->CR_NUM         == Padr(TMP->(E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA),50)
	       		IF SCR->CR_STATUS == '03' .AND. !EMPTY(SCR->CR_LIBAPRO)   // SOMENTE CASO APROVADO
       				_cChave	:= SCR->(CR_FILIAL+CR_TIPO+CR_NUM+CR_USER)
       				_lAprov	:= .T.
					_lAchou  := .T.        				
       				nTotalTit	:= SCR->CR_TOTAL
       			ENDIF
	       		SCR->(DBSkip())
	       	End
			IF !_lAchou
				DBSelectarea("SE2")
				DBSetOrder(1)
				IF DBSeek(TMP->(E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA))
					Reclock("SE2",.F.)
					SE2->E2_X_WF   := "1"   	                        // Status 1 - envio email
		  			SE2->E2_X_WFID := "N/D"   							// Rastreabilidade
					MSUnlock()
					TMP->(DBSkip())
				ENDIF
			ENDIF

	   		IF _lAprov
				_aWF:= U_EnviaCP(TMP->E2_FILIAL, _cNum, _cMailDest , _cChave, nTotalTit, ctod('  /  /  '), '     ',_nOpc)
				_lProcesso 	:= .T.

				While !TMP->(EOF()) .AND. _cNum == TMP->(E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA)

					DBSelectarea("SE2")
					DBSetOrder(1)
					IF DBSeek(TMP->(E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA))
						Reclock("SE2",.F.)
						SE2->E2_X_WF	:= IIF(EMPTY(_aWF[1]), " ", "1")   	// Status 1 - envio email / branco -nao enviado
			  			SE2->E2_X_WFID	:= _aWF[1]							// Rastreabilidade
						MSUnlock()
					ENDIF
					TMP->(DBSkip())
				END
			ENDIF
		END
		dbSelectArea("TMP")
		dbCloseArea())
		*/
    	
    	If Select("TMP") > 0
    		TMP->(DbCloseArea())
    	EndIf
    	// Busca todos os titulos aprovados, e que não foram Notificados pelo WF
    	BeginSQL Alias "TMP"
			select E2_FILIAL, E2_PREFIXO, E2_NUM, E2_TIPO, E2_FORNECE, E2_LOJA, min(E2_PARCELA) as E2_PARCELA
			from %Table:SE2% SE2
			where E2_FILIAL = %xFilial:SE2% and E2_DATALIB <> ' ' and E2_USUALIB <> ' ' and E2_X_WF <> '1'
			  and SE2.%NotDel%
			group by E2_FILIAL, E2_PREFIXO, E2_NUM, E2_TIPO, E2_FORNECE, E2_LOJA
			order by E2_FILIAL, E2_PREFIXO, E2_NUM, E2_TIPO, E2_FORNECE, E2_LOJA, E2_PARCELA
    	EndSQL
    	
    	While !TMP->(Eof())
    	
			cParcelas	:= ""									//Limpa conteúdo das parcelas
			nTotalTit	:= 0									//Zera Total do Título
			cChvSE2WF	:= ""
			cCRNum		:= ""
			cSCRChave	:= ""
			cEmailDest	:= ""
	    	If Select(cAlias) > 0
	    		(cAlias)->(DbCloseArea())
	    	EndIf
	    	// Busca todos os titulos aprovados, e que não foram Notificados pelo WF
	    	BeginSQL Alias cAlias
				select E2_FILIAL, E2_PREFIXO, E2_NUM, E2_TIPO, E2_FORNECE, E2_LOJA, E2_PARCELA, min(E2_VENCREA) as E2_VENCREA, min(E2_VALOR) as E2_VALOR, min(E2_X_USUAR) as E2_X_USUAR
					  ,min(CR_FILIAL) as CR_FILIAL, min(CR_TIPO) as CR_TIPO, min(CR_NUM) as CR_NUM, min(CR_NIVEL) as CR_NIVEL, min(CR_USER) as CR_USER
				from %Table:SE2% SE2
				inner join %Table:SCR% SCR
				   on SCR.CR_FILIAL = E2_FILIAL and CR_TIPO = 'TP' and CR_NUM = E2_PREFIXO+E2_NUM+E2_TIPO+E2_FORNECE+E2_LOJA+E2_PARCELA
					   and SCR.%NotDel%
				where E2_FILIAL  = %Exp:TMP->E2_FILIAL%  and E2_PREFIXO = %Exp:TMP->E2_PREFIXO% 
				  and E2_NUM     = %Exp:TMP->E2_NUM%     and E2_TIPO    = %Exp:TMP->E2_TIPO% 
				  and E2_FORNECE = %Exp:TMP->E2_FORNECE% and E2_LOJA    = %Exp:TMP->E2_LOJA%
				  and E2_DATALIB <> ' ' and E2_USUALIB <> ' ' and E2_X_WF <> '1'
				  and SE2.%NotDel%
				  and exists
					(select top 1 * from %Table:SCR% SCR3
					 where SCR3.CR_FILIAL = E2_FILIAL and SCR3.CR_TIPO = 'TP' and SCR3.CR_NUM = E2_PREFIXO+E2_NUM+E2_TIPO+E2_FORNECE+E2_LOJA+E2_PARCELA
					   and SCR3.CR_STATUS = '03' and SCR3.CR_LIBAPRO <> ' ' and SCR3.%NotDel%)
				group by E2_FILIAL, E2_PREFIXO, E2_NUM, E2_TIPO, E2_FORNECE, E2_LOJA, E2_PARCELA
				order by E2_FILIAL, E2_PREFIXO, E2_NUM, E2_TIPO, E2_FORNECE, E2_LOJA, E2_PARCELA, CR_NIVEL, CR_USER
			EndSQL

			(cAlias)->(DbGoTop())
			If (cAlias)->(Eof())
				U_CONSOLE("3 - Não Localizado Alçada (SCR) relacionado ao Titulo (SE2) liberado." + CRLF + Space(30) + ;
						  "3 - Chave WF SE2 (Fil+Pref+Num+Tp+Forn+Lj) :" + TMP->(E2_FILIAL+E2_PREFIXO+E2_NUM+E2_TIPO+E2_FORNECE+E2_LOJA),cFunc)
			EndIf
			
	    	While !(cAlias)->(Eof())

				If Empty(cChvSE2WF)
					cChvSE2WF	:= (cAlias)->(E2_FILIAL + E2_PREFIXO + E2_NUM + E2_TIPO + E2_FORNECE + E2_LOJA)
					cCRNum		:= (cAlias)->(CR_NUM)
					cSCRChave	:= (cAlias)->(CR_FILIAL+CR_TIPO+CR_NUM+CR_NIVEL+CR_USER) 					
					cEmailDest 	:= Iif( Empty((cAlias)->E2_X_USUAR), "", AVWFPsqUsr((cAlias)->E2_X_USUAR)[3] )
				EndIf					

				cParcelas += Iif(!Empty(cParcelas)," | ","")
				cParcelas += Iif(Empty((cAlias)->E2_PARCELA),"",(cAlias)->E2_PARCELA + " - ") + DtoC(StoD((cAlias)->E2_VENCREA)) + " - " + Transform((cAlias)->E2_VALOR, PesqPict("SE2","E2_VALOR"))
				nTotalTit += (cAlias)->E2_VALOR
	    		(cAlias)->(DbSkip())
	    	EndDo

		   	If nTotalTit # 0

				_cMailDest += Iif(Empty(cEmailDest), "", ";"+cEmailDest)
				_aWF := U_EnviaCP(TMP->E2_FILIAL, cCRNum, _cMailDest , cSCRChave, nTotalTit, CtoD('  /  /  '), Space(5) ,_nOpc, cParcelas, cChvSE2WF)
				_lProcesso 	:= .T.

				(cAlias)->(DbGoTop())
		    	While !(cAlias)->(Eof())
					DBSelectArea("SE2")
					SE2->(DBOrderNickName("SE2WF01"))
					If SE2->( DbSeek((cAlias)->(E2_FILIAL + E2_PREFIXO + E2_NUM + E2_TIPO + E2_FORNECE + E2_LOJA + E2_PARCELA)) )
						Reclock("SE2",.F.)
						SE2->E2_X_WF	:= IIF(EMPTY(_aWF[1]), " ", "1")   	// Status 1 - envio email / branco -nao enviado
			  			SE2->E2_X_WFID	:= _aWF[1]							// Rastreabilidade
						MsUnlock("SE2")
					EndIf
					(cAlias)->(DBSkip())
				EndDo

				(cAlias)->(dbCloseArea())

			EndIf

    		TMP->(DbSkip())
    	EndDo
		TMP->(dbCloseArea())

	/*-------------------------------------------------------------------------+
	|  4 - Envia resposta de titulos bloqueado para o usuário do financeiro    |                                             
	+--------------------------------------------------------------------------*/
	CASE _nOpc == 4
	
		U_CONSOLE("4 - Envia resposta Titulo bloqueado p/ Financeiro",cFunc)
		U_CONSOLE("4 - EmpFil: " + cEmpAnt + cFilAnt,cFunc)
		
		If !lValUsrAnC
			ConOut("["+DtoC(Date())+" "+Time()+"] ["+cFunc+"] " + " - ERRO no conteúdo do parâmetro MV_XWFUSFI. Código do usuário informado não é valido")
		EndIf
	  	/*_cQuery := ""
	  	_cQuery += " SELECT"
	  	_cQuery += " CR_FILIAL," 
	  	_cQuery += " CR_TIPO,"   
	  	_cQuery += " CR_NUM,"    
	  	_cQuery += " CR_NIVEL," 
	  	_cQuery += " CR_TOTAL," 
	  	_cQuery += " CR_USER,"   
	  	_cQuery += " CR_APROV," 
  		_cQuery += " CR_OBS"   
	  	
	  	_cQuery += " FROM " + RetSqlName("SCR") + " SCR"
	  	_cQuery += " WHERE SCR.D_E_L_E_T_ <> '*'"
	  	_cQuery += " AND CR_FILIAL = '" + cFilAnt + "'"
	  	_cQuery += " AND CR_LIBAPRO <> '      '" 					// Seleciona o Aprovador que reprovou
	  	_cQuery += " AND CR_STATUS = '04'"                          // REPROVADO
	  	_cQuery += " AND CR_TIPO = 'TP'"                            // Título a pagar
	  	_cQuery += " AND CR_WF <> '1'"	      					    // 1-Enviado
		  	
	  	_cQuery += " ORDER BY"
	  	_cQuery += " CR_FILIAL," 
	  	_cQuery += " CR_NUM,"
	  	_cQuery += " CR_NIVEL,"
	  	_cQuery += " CR_USER"
	  	
		TcQuery _cQuery New Alias "TMP"   
		
		dbGotop()
		While !TMP->(Eof())
			DBSelectArea("SE2")
			DBSetOrder(1)
			DBSeek(xFilial("SE2")+LEFT(TMP->CR_NUM,LEN(E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA)))

			IF !FOUND()  
              	DBSelectarea("SCR")
		   		DBSetOrder(2)
		   		IF DBSeek(TMP->(CR_FILIAL+CR_TIPO+CR_NUM+CR_USER))
					Reclock("SCR",.F.)
					SCR->CR_WF			:= "1" 		 // Status 1 - envio para aprovadores / branco-nao houve envio
     	  			SCR->CR_X_WFID		:= "N/D"	 // Rastreabilidade
				ENDIF	
			ELSE
				_aWF	:= U_EnviaCP(TMP->CR_FILIAL, TMP->CR_NUM, _cMailDest , TMP->(CR_FILIAL+CR_TIPO+CR_NUM+CR_APROV) , TMP->CR_TOTAL, ctod('  /  /  '), '     ', _nOpc)

				DBSelectarea("SCR")
				DBSetOrder(2)
				IF DBSeek(TMP->(CR_FILIAL+CR_TIPO+CR_NUM+CR_USER))
					Reclock("SCR",.F.)
					SCR->CR_WF			:= IIF(EMPTY(_aWF[1])," ","1")  	// Status 1 - envio para aprovadores / branco-nao houve envio
		  			SCR->CR_X_WFID		:= _aWF[1]							// Rastreabilidade
					MSUnlock()
				ENDIF
			ENDIF		
			_lProcesso := .T.
						
			dbSelectArea("TMP")
			DBSkip()
		End
		
		dbSelectArea("TMP")
		dbCloseArea()*/

    	If Select("TMP") > 0
    		TMP->(DbCloseArea())
    	EndIf
    	// Busca todos os titulos aprovados, e que não foram Notificados pelo WF
    	BeginSQL Alias "TMP"
			select E2_FILIAL, E2_PREFIXO, E2_NUM, E2_TIPO, E2_FORNECE, E2_LOJA, min(E2_PARCELA) as E2_PARCELA
			from %Table:SE2% SE2
			where E2_FILIAL = %xFilial:SE2% and E2_DATALIB = ' ' and E2_USUALIB = ' ' and E2_X_WF <> '1'
			  and SE2.%NotDel%
			group by E2_FILIAL, E2_PREFIXO, E2_NUM, E2_TIPO, E2_FORNECE, E2_LOJA
			order by E2_FILIAL, E2_PREFIXO, E2_NUM, E2_TIPO, E2_FORNECE, E2_LOJA, E2_PARCELA
    	EndSQL
    	
    	While !TMP->(Eof())
    	
			cParcelas	:= ""									//Limpa conteúdo das parcelas
			nTotalTit	:= 0									//Zera Total do Título
			cChvSE2WF	:= ""
			cCRNum		:= ""
			cSCRChave	:= ""
			cEmailDest	:= ""
	    	If Select(cAlias) > 0
	    		(cAlias)->(DbCloseArea())
	    	EndIf
	    	// Busca todos os titulos aprovados, e que não foram Notificados pelo WF
	    	BeginSQL Alias cAlias
				select E2_FILIAL, E2_PREFIXO, E2_NUM, E2_TIPO, E2_FORNECE, E2_LOJA, E2_PARCELA, min(E2_VENCREA) as E2_VENCREA, min(E2_VALOR) as E2_VALOR, min(E2_X_USUAR) as E2_X_USUAR
					  ,min(CR_FILIAL) as CR_FILIAL, min(CR_TIPO) as CR_TIPO, min(CR_NUM) as CR_NUM, min(CR_NIVEL) as CR_NIVEL, min(CR_USER) as CR_USER
				from %Table:SE2% SE2
				inner join %Table:SCR% SCR
				   on SCR.CR_FILIAL = E2_FILIAL and CR_TIPO = 'TP' and CR_NUM = E2_PREFIXO+E2_NUM+E2_TIPO+E2_FORNECE+E2_LOJA+E2_PARCELA
					   and SCR.%NotDel%
				where E2_FILIAL  = %Exp:TMP->E2_FILIAL%  and E2_PREFIXO = %Exp:TMP->E2_PREFIXO% 
				  and E2_NUM     = %Exp:TMP->E2_NUM%     and E2_TIPO    = %Exp:TMP->E2_TIPO% 
				  and E2_FORNECE = %Exp:TMP->E2_FORNECE% and E2_LOJA    = %Exp:TMP->E2_LOJA%
				  and E2_DATALIB = ' ' and E2_USUALIB = ' ' and E2_X_WF <> '1'
				  and SE2.%NotDel%
				  and exists
					(select top 1 * from %Table:SCR% SCR3
					 where SCR3.CR_FILIAL = E2_FILIAL and SCR3.CR_TIPO = 'TP' and SCR3.CR_NUM = E2_PREFIXO+E2_NUM+E2_TIPO+E2_FORNECE+E2_LOJA+E2_PARCELA
					   and SCR3.CR_STATUS = '04' and SCR3.CR_LIBAPRO <> ' ' and SCR3.%NotDel%)
				group by E2_FILIAL, E2_PREFIXO, E2_NUM, E2_TIPO, E2_FORNECE, E2_LOJA, E2_PARCELA
				order by E2_FILIAL, E2_PREFIXO, E2_NUM, E2_TIPO, E2_FORNECE, E2_LOJA, E2_PARCELA, CR_NIVEL, CR_USER
			EndSQL

			(cAlias)->(DbGoTop())
			If (cAlias)->(Eof())
				U_CONSOLE("4 - Não Localizada Alçada (SCR) REPROVADA relacionado ao Titulo (SE2) bloqueado." + CRLF + Space(30) + ;
						  "4 - Chave WF SE2 (Fil+Pref+Num+Tp+Forn+Lj) :" + TMP->(E2_FILIAL+E2_PREFIXO+E2_NUM+E2_TIPO+E2_FORNECE+E2_LOJA),cFunc)
			EndIf
			
	    	While !(cAlias)->(Eof())

				If Empty(cChvSE2WF)
					cChvSE2WF	:= (cAlias)->(E2_FILIAL + E2_PREFIXO + E2_NUM + E2_TIPO + E2_FORNECE + E2_LOJA)
					cCRNum		:= (cAlias)->(CR_NUM)
					cSCRChave	:= (cAlias)->(CR_FILIAL+CR_TIPO+CR_NUM+CR_NIVEL+CR_USER) 					
					cEmailDest 	:= Iif( Empty((cAlias)->E2_X_USUAR), "", AVWFPsqUsr((cAlias)->E2_X_USUAR)[3] )
				EndIf					

				cParcelas += Iif(!Empty(cParcelas)," | ","")
				cParcelas += Iif(Empty((cAlias)->E2_PARCELA),"",(cAlias)->E2_PARCELA + " - ") + DtoC(StoD((cAlias)->E2_VENCREA)) + " - " + Transform((cAlias)->E2_VALOR, PesqPict("SE2","E2_VALOR"))
				nTotalTit += (cAlias)->E2_VALOR
	    		(cAlias)->(DbSkip())
	    	EndDo

		   	If nTotalTit # 0

				_cMailDest += Iif(Empty(cEmailDest), "", ";"+cEmailDest)
				_aWF := U_EnviaCP(TMP->E2_FILIAL, cCRNum, _cMailDest , cSCRChave, nTotalTit, CtoD('  /  /  '), Space(5) ,_nOpc, cParcelas, cChvSE2WF)
				_lProcesso 	:= .T.

				(cAlias)->(DbGoTop())
		    	While !(cAlias)->(Eof())
					DBSelectArea("SE2")
					SE2->(DBOrderNickName("SE2WF01"))
					If SE2->( DbSeek((cAlias)->(E2_FILIAL + E2_PREFIXO + E2_NUM + E2_TIPO + E2_FORNECE + E2_LOJA + E2_PARCELA)) )
						Reclock("SE2",.F.)
						SE2->E2_X_WF	:= IIF(EMPTY(_aWF[1]), " ", "1")   	// Status 1 - envio email / branco -nao enviado
			  			SE2->E2_X_WFID	:= _aWF[1]							// Rastreabilidade
						MsUnlock("SE2")
					EndIf
					(cAlias)->(DBSkip())
				EndDo
				(cAlias)->(dbCloseArea())
			EndIf

    		TMP->(DbSkip())
    	EndDo
		TMP->(dbCloseArea())

END CASE			
	
IF 	_lProcesso 
	U_CONSOLE("Mensagem processada ",cFunc)
ELSE
	U_CONSOLE("Nao houve processamento",cFunc)
ENDIF	
				
RETURN

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³EnviaCP   ºAutor  ³Microsiga           º Data ³             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

USER Function EnviaCP(_cFilial,_cNum, _cUser, cChaveSCR, nTotalTit, _dDTLimit, _cHRLimit, _nOpc, cParcelas, cChvSE2WF)
//  _aWF := U_EnviaCP(TMP->CR_FILIAL, TMP->CR_NUM, TMP->CR_USER, TMP->(CR_FILIAL+CR_TIPO+CR_NUM+CR_NIVEL+CR_USER), nTotalTit, , , _nOpc, cParcelas, cChvSE2WF)

Local _cHttp	 := GetNewPar("MV_WFDHTTP", "http://189.20.203.131:9898")
Local cDirDoc	 := ""
//Local _cTo	   	 := IIF(_nOpc == 1, _cUser , UsrRetMail(_cUser))
Local _cTo	   	 := _cUser 
Local _cEmail	 := UsrRetMail(_cUser)
Local _nDD   	 := GetNewPar("MV_WFTODD", 0)		// TimeOut - Dias
Local _cTimeOut	 := GetNewPar("MV_WFTOPC","24:00")
Local _dDataLib	 := IIF( !EMPTY(_dDTLimit), _dDTLimit, MSDATE() )
Local _cHoraLib	 := IIF( !EMPTY(_cHRLimit), _cHRLimit, LEFT(TIME(),5) )
Local _nTimeOut  := (_nDD * 24) + VAL(LEFT(_cTimeOut,2)) + (VAL(RIGHT(_cTimeOut,2))/60) 
Local _nVrSC	 := 0
Local _cUnidReq	 := ""  
Local _aAreaSM0	 := {}

Local _nVALMERC	 := 0
Local _nVALIPI	 := 0
Local _nFRETE	 := 0
Local _nSEGURO	 := 0
Local _nDESCONTO := 0   
Local _nDESPESA	 := 0   	
Local _nVALTOT	 := 0
Local _lCotacao  := .F.
Local nW		 := 0
Local aDocBcoCto := {}
Local _lDoc		 := .F.
Local nTamChvSCR := TamSX3("CR_FILIAL")[1] + TamSX3("CR_TIPO")[1] +TamSX3("CR_NUM")[1]
Local cAlias	 := GetNextAlias()

_aTimeOut	:= U_GetTimeOut(_nTimeOut,_dDATALIB,_cHoraLib)
Private _aPedidos:= {}       

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


//------------------- VALIDACAO
_lError := .F.
if Empty(_cTo)
   aMsg := {}
   cTitle  := "Administrador do Workflow : NOTIFICACAO" 
   aADD(aMsg , REPLICATE('*',80) )
   aADD(aMsg , Dtoc(MSDate()) + " - " + Time() + ' * Ocorreu um ERRO no envio da mensagem :' )
   aADD(aMsg , "Titulo a pagar (completar dados) No: " + ALLTRIM(SE2->E2_NUM)  + " Filial : " + cFilAnt + " Usuario : " + UsrRetName(_cUser) )
   aADD(aMsg , "Campo EMAIL do cadastro de usuario NAO PREENCHIDO" )
   aADD(aMsg , REPLICATE('*',80) )
		
   _lError := .T.
Endif
                  
IF _lError
   U_NotifyAdm(cTitle, aMsg)
   _aReturn := {}
   AADD(_aReturn, "")
   AADD(_aReturn, _aTimeOut[1])
   AADD(_aReturn, _aTimeOut[2])
	
   RETURN _aReturn
ENDIF

// ----- FIM DA VALIDACAO
              
//_cChaveSCR	:= PADR(_cFilial + 'TP' + _cNum,60)
//_cNum 		:= PADR(ALLTRIM(_cNum),LEN(E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA) )

DBSelectArea("SCR")
//DBSetOrder(2)
//DBSeek(cChaveSCR)
SCR->(DBOrderNickName("SCRWF01"), DBSeek(cChaveSCR))

DBSelectArea("SM0")
DBSetOrder(1)
DBSeek(cEmpAnt+cFilAnt)

DBSelectArea("SE2")
//DBSetOrder(1)
//DBSeek(_cFilial+_cNum)
SE2->(DBOrderNickName("SE2WF01"), DbSeek(cChvSE2WF))

DBSelectArea("SA2")
//DBSetOrder(1)
//DBSeek(xFilial("SA2")+SE2->E2_FORNECE+SE2->E2_LOJA)
SA2->(DBSetOrder(1), DbSeek(xFilial("SA2")+SE2->E2_FORNECE+SE2->E2_LOJA))
//_cFornece := SE2->E2_FORNECE
//_cLojaFor := SE2->E2_LOJA
       
DO CASE 
//-------------------------------------------------------- INICIO PROCESSO WORKFLOW	   		
   CASE _nOpc == 1		// Envio de email para aprovacao
		oProcess          	:= TWFProcess():New( "000011", "Envio Aprovacao CP :" + _cFilial + "/" +  ALLTRIM(SE2->E2_NUM) )
		oProcess:NewTask( "Envio CP : "+_cFilial + _cNum, "\WORKFLOW\Financeiro\TPAPROV.HTM" )
    	oProcess:cFromName 	:= "Administrador Workflow"
		oProcess:bReturn  	:= "U_WKFCP(2)"
		
   CASE _nOpc == 3		// Envio de email Aprovacao para solicitante
		oProcess          	:= TWFProcess():New( "000013", "Envio p/ o financeiro CP aprovado : " + _cFilial + "/" +  ALLTRIM(SE2->E2_NUM) )
		oProcess          	:NewTask( "Envio CP aprovado : "+_cFilial + _cNum, "\WORKFLOW\Financeiro\TPRESP.HTM" )
		_cResposta			:= " A P R O V A D O "
			
   CASE _nOpc == 4		// Envio de email Reprovado para solicitante
		oProcess          	:= TWFProcess():New( "000014", "Envio p/ o financeiro CP reprovado : " + _cFilial + "/" +  ALLTRIM(SE2->E2_NUM) )
		oProcess          	:NewTask( "Envio CP reprovado : "+_cFilial + _cNum, "\WORKFLOW\Financeiro\TPRESP.HTM" )
		_cResposta			:= "<font color='#FF0000'>R E P R O V A D O </font>"	
ENDCASE

oProcess:cTo      	:= _cTo
oProcess:UserSiga	:= _cUser
oHtml     			:= oProcess:oHTML

If _nOpc == 1
	oHtml:ValByName( "CFILANT"	   , xFilial("SCR"))
	oHtml:ValByName( "CHAVE"	   , cChaveSCR)
	oHtml:ValByName( "WFID"		   , oProcess:fProcessId)
	oHtml:ValByName( "OBS"		   , "" )
ENDIF

IF _nOpc == 3 .OR. _nOpc == 4
	oHtml:ValByName( "resposta"  	, _cResposta)	 
ENDIF
   
//Cabecalho
oHtml:ValByName( "E2_NUM"	    , RTrim(SE2->E2_PREFIXO) + "/" + RTrim(SE2->E2_NUM) + "/" + RTrim(SE2->E2_TIPO) )	// Numero
oHtml:ValByName( "E2_FILIAL"	, SM0->M0_FILIAL )                                          // Filial
oHtml:ValByName( "E2_NOME"	    , SM0->M0_NOME )                                            // Empresa

oHtml:ValByName( "E2_EMISSAO"	, DTOC(SE2->E2_EMISSAO) )
oHtml:ValByName( "VLTitulo" 	, Transform(nTotalTit, PesqPict("SE2","E2_VALOR")) )
oHtml:ValByName( "A2_NOME"		, RTrim(SA2->A2_NOME) + " (" + SA2->A2_COD + "/" + SA2->A2_LOJA + ")" ) 	// Fornecedor
//oHtml:ValByName( "E2_VENCTO"	, DTOC(SE2->E2_VENCTO) )
oHtml:ValByName( "E2_MODSPB"   	, Iif(SE2->E2_MODSPB=="1","TED",Iif(SE2->E2_MODSPB=="2","CIP","COMP")) )
oHtml:ValByName( "E2_MDPARCE"	, cParcelas )

/*-------------------------------------------------------------------------+
|  Pesquisa e alimenta os Itens da Nota Fiscal                             |                                             
+--------------------------------------------------------------------------*/
If Select("D1DOC") > 0
	("D1DOC")->(dbCloseArea())
Endif
BeginSQL Alias "D1DOC"
	select D1_DOC, D1_SERIE, D1_FORNECE, D1_LOJA, D1_ITEM, D1_COD, D1_QUANT, D1_UM, D1_VUNIT, D1_VALIPI, D1_VALICM, D1_TOTAL, B1_DESC
	from %Table:SF1% SF1
	inner join %Table:SD1% SD1 on D1_FILIAL = F1_FILIAL 
	  and D1_DOC = F1_DOC and D1_SERIE = F1_SERIE and D1_FORNECE = F1_FORNECE and D1_LOJA = F1_LOJA and SD1.%NotDel%
	inner join %Table:SB1% SB1 on B1_FILIAL = %xFilial:SB1% and B1_COD = D1_COD and SB1.%NotDel%
	where F1_FILIAL = %xFilial:SF1% and F1_DOC = %Exp:SE2->E2_NUM% and F1_SERIE = %Exp:SE2->E2_PREFIXO%
	  and F1_FORNECE = %Exp:SE2->E2_FORNECE% and F1_LOJA = %Exp:SE2->E2_LOJA%
	  and SF1.%NotDel%
	order by D1_FILIAL, D1_DOC, D1_SERIE, D1_FORNECE, D1_LOJA, D1_ITEM
EndSQL

D1DOC->(DbGoTop())
If D1DOC->(Eof())
 	_cExibe  := "<p><font color='#FF0000'>*** Nao há notas fiscais associadas ***</font></p>"
	AAdd( (oHtml:ValByName( "td.1"  )), "" )
	AAdd( (oHtml:ValByName( "td.2"  )), "" )
	AAdd( (oHtml:ValByName( "td.3"  )), _cExibe )
	AAdd( (oHtml:ValByName( "td.4"  )), "" )
	AAdd( (oHtml:ValByName( "td.5"  )), "" )
	AAdd( (oHtml:ValByName( "td.6"  )), "" )
	AAdd( (oHtml:ValByName( "td.7"  )), "" )
	AAdd( (oHtml:ValByName( "td.8"  )), "" )
	AAdd( (oHtml:ValByName( "td.9"  )), "" )
Else
	While !D1DOC->(Eof()) 	
		AAdd( (oHtml:ValByName( "td.1" )), D1DOC->D1_ITEM )
		AAdd( (oHtml:ValByName( "td.2" )), D1DOC->D1_COD )
		AAdd( (oHtml:ValByName( "td.3" )), D1DOC->B1_DESC )
		AAdd( (oHtml:ValByName( "td.4" )), D1DOC->D1_UM )
		AAdd( (oHtml:ValByName( "td.5" )), Transform(D1DOC->D1_QUANT,  PesqPict("SD1","D1_QUANT")) )
		AAdd( (oHtml:ValByName( "td.6" )), Transform(D1DOC->D1_VUNIT,  PesqPict("SD1","D1_QUANT")) )
		AAdd( (oHtml:ValByName( "td.7" )), Transform(D1DOC->D1_VALICM, PesqPict("SD1","D1_QUANT")) )
		AAdd( (oHtml:ValByName( "td.8" )), Transform(D1DOC->D1_VALIPI, PesqPict("SD1","D1_QUANT")) )
		AAdd( (oHtml:ValByName( "td.9" )), Transform(D1DOC->D1_TOTAL,  PesqPict("SD1","D1_QUANT")) )
		D1DOC->(DbSkip())
	EndDo
EndIf

DbCloseArea("D1DOC")   

/*-------------------------------------------------------------------------+
|  ALIMENTA A TELA DE DOCUMENTOS ASSOCIADOS - BCO DE CONHECIMENTO          |                                             
+--------------------------------------------------------------------------*/
aDocBcoCto	:= AVWFPsqDoc(cChvSE2WF)

//	    dbSelectArea("SE2")	
If Len(aDocBcoCto) < 1
 		_cExibe  := "<p><font color='#FF0000'>*** Nao há documentos associados ***</font></p>"
	AAdd( (oHtml:ValByName( "tc.1"  )), "" )
	AAdd( (oHtml:ValByName( "tc.2"  )), _cExibe )
	AAdd( (oHtml:ValByName( "tc.3"  )), "" )
	
Else	
    For nW := 1 To Len(aDocBcoCto)   
		AAdd( (oHtml:ValByName( "tc.1" )), aDocBcoCto[nW][1] )
		AAdd( (oHtml:ValByName( "tc.2" )), "<a target='_blank' href='" + cDirDoc + alltrim(aDocBcoCto[nW][2]) + "'>"+Alltrim(aDocBcoCto[nW][2])+"</a>")
		AAdd( (oHtml:ValByName( "tc.3" )), aDocBcoCto[nW][3] )
	Next
EndIf

//-------------------------------------------------------------
// ALIMENTA A TELA DE PROCESSO DE APROVAÇÃO DE TITULO A PAGAR
//-------------------------------------------------------------
DBSelectarea("SCR")
SCR->(DBOrderNickName("SCRWF01"), DbGoTop(), DBSeek(Left(cChaveSCR,nTamChvSCR),.T.))
While !SCR->(Eof()) .and. Left(SCR->(CR_FILIAL+CR_TIPO+CR_NUM),nTamChvSCR) == Left(cChaveSCR,nTamChvSCR)
      cSituaca := ""
	  Do Case
         Case SCR->CR_STATUS == "01"
              cSituaca := "Aguardando"
         Case SCR->CR_STATUS == "02"
              cSituaca := "Em Aprovacao"
         Case SCR->CR_STATUS == "03"
              cSituaca := "Aprovado"
         Case SCR->CR_STATUS == "04"
              cSituaca := "Reprovado"
              lBloq := .T.
         Case SCR->CR_STATUS == "05"
              cSituaca := "Nivel Liberado"
      EndCase	

	  AAdd( (oHtml:ValByName( "t1.1"    )), SCR->CR_NIVEL )
	  AAdd( (oHtml:ValByName( "t1.2"    )), UsrFullName(SCR->CR_USER) )
	  AAdd( (oHtml:ValByName( "t1.3"    )), cSituaca    )
	  AAdd( (oHtml:ValByName( "t1.4"    )), Iif(Empty(SCR->CR_USERLIB),"",UsrRetName(SCR->CR_USERLIB)) )
	  AAdd( (oHtml:ValByName( "t1.5"    )), DTOC(SCR->CR_DATALIB) )
	  AAdd( (oHtml:ValByName( "t1.6"    )), Iif(Empty(SCR->CR_OBS),"", SCR->CR_OBS) )
		
	  SCR->(DBSkip())
ENDDO

oProcess:nEncodeMime := 0

DO CASE
   CASE _nOpc == 1
    	oProcess:cTo      		:= nil
	    oProcess:NewVersion(.T.)
		oHtml     				:= oProcess:oHTML
		oProcess:nEncodeMime    := 0
		cMailID := oProcess:Start(Alltrim(GetMv("MV_WFDIR"))+"\emp"+cEmpAnt+"\wfcp\")   //Faz a gravacao do e-mail no cPath
		
		chtmlfile  := cmailid + ".htm"
	
		csubj := "Aprovação Título a pagar - Filial: "+_cFilial+" / Numero: "+ALLTRIM(SE2->E2_NUM) 
		oProcess:newtask("Link", "\workflow\Financeiro\Link_avant.htm")  //Cria um novo processo de workflow que informara o Link ao usuario
		oHtml:ValByName( "descproc"	  ,"O Título a pagar abaixo aguarda sua aprovação:")
		oProcess:oHtml:ValByName("cNomeProcesso", Alltrim(GetMv("MV_WFDHTTP"))+"/emp"+cempant+"/wfcp/"+chtmlfile ) // envia o link onde esta o arquivo html
		oHtml:ValByName( "cDocto"	  ,"Título a Pagar No. "+ AllTrim(SE2->E2_NUM))
			
		oProcess:cTo 	   := _cEmail
		oProcess:cSubject  := cSubj
			
		oProcess:Start()

	OTHERWISE       
	    oProcess:cSubject    := "WORKFLOW  - Título a pagar - Filial: "+_cFilial+" / Número: " + ALLTRIM(SE2->E2_NUM)  +Iif(_nOpc=3," APROVADO"," REPROVADO")

   		oProcess:Start()
END CASE

// ARRAY DE RETORNO
_aReturn := {}
AADD(_aReturn, oProcess:fProcessId)

Return _aReturn


/*-----------------------+-------------------------------+------------------+
|   Programa: AVWFPsqDoc | Autor: Kley@TOTVS             | Data: 25/06/2014 |
+------------------------+-------------------------------+------------------+
|  Descricao: Pesquisa os documentos do Banco de Conhecimento associados ao 
|             respectivo Titulo do Contas a Pagar.
|
|			  Parâmetros recebidos:
|				<ExpC1> - cChvSE2WF = Chave do Documento
|							SE2 -> E2_FILIAL + E2_PREFIXO + E2_NUM + E2_TIPO + E2_FORNECE + E2_LOJA
|							SF1 -> 
+---------------------------------------------------------------------------+
|    Projeto: AVANT
+---------------------------------------------------------------------------+
|    Sintaxe: AVWFPsqDoc(cChvSE2WF)
+----------------------------------------------------------------------------
|    Retorno: aDocBcoCto                                                               
|             Retorna um array de três dimensões, e cada um contendo:
|				[1] = Descrição do Documento
|				[2] = Nome do objetivo/arquivo
|				[3] = Origem, SE2 ou SF1
+--------------------------------------------------------------------------*/

Static Function AVWFPsqDoc(cChvSE2WF)

Local cFunc	  := "AVWFPsqDoc"
Local cAlias	  := GetNextAlias()
Local nTamFil   := TamSX3("E2_FILIAL")[1]
Local nTamPref  := TamSX3("E2_PREFIXO")[1]
Local nTamNum   := TamSX3("E2_NUM")[1]
Local nParcela  := TamSX3("E2_PARCELA")[1]
Local nTipo	  := TamSX3("E2_TIPO")[1]
Local nFornLoja := TamSX3("E2_FORNECE")[1] + TamSX3("E2_LOJA")[1]
Local aDocBcoCto:= {}							//Array com os Documentos do Banco de Conhecimento

If Select(cAlias) > 0
	(cAlias)->(dbCloseArea())
Endif

//Busca Documento do Banco de Conhecimento relacionado ao Título AP ou ao Documento de Entrada
BeginSQL Alias cAlias
	select distinct /*E2_PREFIXO, E2_NUM, E2_TIPO, E2_FORNECE, E2_LOJA, E2_PARCELA,*/
		   AC9_FILENT, AC9_CODENT, AC9_ENTIDA, ACB_CODOBJ, ACB_OBJETO, ACB_DESCRI,
		   case AC9_ENTIDA when 'SE2' then 'Título a Pagar' when 'SF1' then 'Documento de Entrada' else AC9_ENTIDA end as AC9ENTIDA  
	from %Table:AC9% AC9
	inner join %Table:ACB% ACB on ACB_FILIAL = AC9_FILIAL and ACB_CODOBJ = AC9_CODOBJ and ACB.%NotDel%
	inner join %Table:SE2% SE2 on E2_FILIAL  = AC9_FILENT and rtrim(E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA) = rtrim(AC9_CODENT) and SE2.%NotDel%
	where AC9_FILIAL = %xFilial:AC9% and AC9_ENTIDA = 'SE2'
	  and left(AC9_FILENT+AC9_CODENT,%Exp:nTamFil+nTamPref+nTamNum%) = %Exp:Left(cChvSE2WF,nTamFil+nTamPref+nTamNum)%
	  and substring(AC9_FILENT+AC9_CODENT,%Exp:nTamFil+nTamPref+nTamNum+nParcela+1%,%Exp:nTipo+nFornLoja%) = %Exp:Substr(cChvSE2WF,nTamFil+nTamPref+nTamNum+1,nTipo+nFornLoja)%
	  and AC9.%NotDel%
	
	union all
	
	select distinct /*E2_PREFIXO, E2_NUM, E2_TIPO, E2_FORNECE, E2_LOJA, E2_PARCELA,*/
		   AC9_FILENT, AC9_CODENT, AC9_ENTIDA, ACB_CODOBJ, ACB_OBJETO, ACB_DESCRI,
		   case AC9_ENTIDA when 'SE2' then 'Título a Pagar' when 'SF1' then 'Documento de Entrada' else AC9_ENTIDA end as AC9ENTIDA  
	from %Table:AC9% AC9
	inner join %Table:ACB% ACB on ACB_FILIAL = AC9_FILIAL and ACB_CODOBJ = AC9_CODOBJ and ACB.%NotDel%
	inner join %Table:SF1% SF1 on F1_FILIAL  = AC9_FILENT and rtrim(F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA) = rtrim(AC9_CODENT) and SF1.%NotDel%
	inner join %Table:SE2% SE2 on E2_FILIAL  = F1_FILIAL  and E2_NUM  = F1_DOC and E2_PREFIXO  = F1_SERIE and E2_FORNECE = F1_FORNECE and E2_LOJA = F1_LOJA and SE2.%NotDel%
	where AC9_FILIAL = %xFilial:AC9% and AC9_ENTIDA = 'SF1'
	  and substring(AC9_FILENT,1,%Exp:nTamFil%)             = %Exp:Substr(cChvSE2WF,1,nTamFil)%
	  and substring(AC9_CODENT,1,%Exp:nTamNum%)                = %Exp:Substr(cChvSE2WF,nTamFil+nTamPref+1,nTamNum)%
	  and substring(AC9_CODENT,%Exp:nTamNum+1%,%Exp:nTamPref%) = %Exp:Substr(cChvSE2WF,nTamFil+1,nTamPref)%
	  and substring(AC9_CODENT,%Exp:nTamNum+nTamPref+1%,%Exp:nFornLoja%) = %Exp:Substr(cChvSE2WF,nTamFil+nTamPref+nTamNum+nTipo+1,nFornLoja)%
	  and AC9.%NotDel%
	order by AC9_FILENT, AC9_CODENT, AC9_ENTIDA, ACB_CODOBJ
EndSQL

While !(cAlias)->(Eof())
	aAdd(aDocBcoCto, {ACB_DESCRI,ACB_OBJETO,AC9ENTIDA})
	(cAlias)->(DbSkip())
EndDo

(cAlias)->(dbCloseArea())

Return(aDocBcoCto)


/*-----------------------+-------------------------------+------------------+
|   Programa: AVWFPsqUsr | Autor: Kley@TOTVS             | Data: 25/06/2014 |
+------------------------+-------------------------------+------------------+
|  Descricao: Pesquisa informações do Código do Usuário informado. 
|			  Parâmetros recebidos:
|				<ExpC1> - cCodUsuar = Código do Usuário do Sistema
+---------------------------------------------------------------------------+
|    Projeto: AVANT
+---------------------------------------------------------------------------+
|    Sintaxe: AVWFPsqUsr(cCodUsuar)
+----------------------------------------------------------------------------
|    Retorno: aUserInfo                                                               
|             Retorna um array de três dimensões, e cada um contendo:
|				[1] = Código do Usuário
|				[2] = Nome do Usuário
|				[3] = E-Mail do Usuário
+--------------------------------------------------------------------------*/

Static Function AVWFPsqUsr(cCodUsuar)

Local cFunc		:= "AVWFPsqUsr"
Local aUserInfo	:= {}
//Pesquisa se o Código do Usuario e valido
PswOrder(1)
If PswSeek( cCodUsuar, .T. )
	//ConOut("["+DtoC(Date())+" "+Time()+"] ["+cFunc+"] Usuário encontrado | Cod./Nome: " + PswRet()[1][1] + "/" + AllTrim(PswRet()[1][4]) )
	aUserInfo	:= {PswRet()[1][1], AllTrim(PswRet()[1][4]), AllTrim(PswRet()[1][14])}		// codigo, nome completo, e-mail do usuário
EndIf

Return(aUserInfo)
