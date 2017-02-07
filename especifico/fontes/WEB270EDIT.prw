#include "PROTHEUS.CH"
#include "vkey.ch"
#include "font.ch"
#define cEOL CHR(10)
#Define ENTER Chr(13)+Chr(10)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ WEB270EDIT()º Autor ³ Fernando Nogueira  º Data ³23/10/2013º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Monta pagina personalizada para abertura do chamado...	  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico AVANT.                   	                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÏÍÍÍÑÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAnalista Resp.³  Data  ³ Manutencao Efetuada                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º              ³  /  /  ³                                               º±±
±±º              ³  /  /  ³                                               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function WEB270EDIT(x,y,nOpc)

	Local cAlias1		:= "SZU"
	Local cAlias2		:= "SZV"

	Local nRec1			:= SZU->(RECNO())
	Local nRec2			:= SZV->(RECNO())
	Local nX         	:= 0
	Local xOpc			:= 0
	Local cTitOdlg		:= "Edição de Chamados"

	lOCAL bCampo   	:= {|nField| FieldName(nField) }
	Local oOk   		:= LoadBitmap( GetResources(), "BR_VERDE_OCEAN" )
	Local oNo  	    	:= LoadBitmap( GetResources(), "BR_VERMELHO_OCEAN")
	Local lOpenProc	:= IIF( GetNewPar("ES_NOTIF","S") == "S" , .T. , .F. )
	Local aArea			:= GetArea()
	Local lEncerra		:= .F.
    Local __cAnexo		:= ''

	Private cChamado
	Private cCodLoja
	Private cNome
	Private cCodAcao 	:= Space(3)
	Private cAcao 		:= Space(1)
	Private cView 		:= Space(1)
	Private cTexto		:= ""
	Private aHistorico:= u_RetHistory(SZU->ZU_CHAMADO)
	Private bOk			:= {|| IIF(TecVldOk(),(xOpc:=1,oDlg:End()),Nil) }
	Private	bCancel 	:= {|| xOpc:=0,oDlg:End() }
	Private xOpc		:= 0
	Private aBotoes	:= {}

	Private aTitles	:= {}
	Private aSize    	:= MsAdvSize()
	Private aObjects 	:= {}
	Private aInfo    	:= {aSize[1],aSize[2],aSize[3],aSize[4],3,3}
	Private aPosObj  	:= {}
	Private aPosGet  	:= {}
	Private aGets	 	:= {}
	Private aCposE1	:= { "ZU_CHAMADO" }
	Private aCposE2	:= { "ZV_CHAMADO" }

	Private lVisualiza:= IIF( nOpc == 2 , .T. , .F. )
	Private lInclui	:= IIF( nOpc == 3 , .T. , .F. )
	Private lAltera	:= IIF( nOpc == 4 , .T. , .F. )

	Private aAltE1		:= {"ZU_NOMEUSR","ZU_MAILUSR","ZU_MAILSUP","ZU_EMAILS","ZU_TELUSR","ZU_ASSUNTO","ZU_ROTINA","ZU_PRIORID",If(nOpc == 3 .And. !(funname() == 'USRMENU'),"ZU_CODUSR",''),If(nOpc == 3 .And. !(funname() == 'USRMENU'),'ZU_IP_ADDR',''),"ZU_CODSUP",If(!funname() == 'USRMENU',"ZU_DTFECHA",'') }
	Private aAltE2		:= {"ZV_TIPO"}
	Private aPosE1
	Private aPosE2

	DEFINE FONT oFontPad  NAME "Tahoma" 	SIZE 0, -12

	If lInclui

		aAdd( aAltE1 , "ZU_DIVISAO" )

		aAdd( aTitles, "&Detalhamento Técnico" )

		AAdd( aObjects, { 100, 100, .t., .t. } )
		AAdd( aObjects, { 100, 100, .t., .t. } )

	Elseif lAltera .Or. lVisualiza

		aAdd( aTitles, "&Histórico  Detalhado do Chamado" )

		If lAltera

			aAdd( aTitles, "&Detalhamento Técnico" )
			aAdd( aObjects, { 100,90,.T.,.T. } )
			aAdd( aObjects, { 100,70,.T.,.F. } )
			aAdd( aObjects, { 100,90,.T.,.T. } )

		Elseif lVisualiza

			AAdd( aObjects, { 100, 100, .t., .t. } )
			AAdd( aObjects, { 100, 100, .t., .t. } )

		Endif

	Endif

	aPosObj 	:= MsObjSize(aInfo,aObjects)
	aPosE1		:= { aPosObj[1,1]+10, aPosObj[1,2]+3, aPosObj[1,3]-2, aPosObj[1,4]-3 }
	aPosE2		:= { aPosObj[2,1]+10, aPosObj[2,2]+3, aPosObj[2,3]-2, aPosObj[2,4]-3 }

	PswOrder(2)
	If PswSeek( AllTrim(cUserName) , .T. )
		aTecnico := PswRet()
		aDados	 := aTecnico[1]
		cTecName := RTrim(aDados[4])
	Endif

	If cNivel > 8 .And. !(funname() == 'USRMENU')
		aAdd( aBotoes,{ "EXCLUIR",{|| MsDelItem(@aHistorico) },OemToAnsi("Remover linha") })
	Endif
	aAdd( aBotoes,{ "PIN"    ,{|| MsAnxItem(@__cAnexo) },OemToAnsi("Anexo") })

	If !lVisualiza .And. !lInclui
		If SZU->ZU_STATUS == "C"
			MsgInfo("Não é possível manipular um chamado já encerrado. Primeiro faça a reabertura do chamado para depois manipulá-lo.",,"INFO")
			Return
		Elseif SZU->ZU_STATUS == "F"
			MsgInfo("Chamado aguardando retorno com validação de encerramento. Solicite a confirmação do chamado ou faça a re-abertura do chamado.",,"INFO")
			Return
		Endif
	Endif


	oDlg := TDialog():New(aSize[7],0,((aSize[6]/100)*98),((aSize[5]/100)*99),cTitOdlg,,,,,,,,oMainWnd,.T.)

		aTela := {}
		aGets := {}

		If lAltera .Or. lVisualiza
			RegToMemory("SZU")
		Else
			RegToMemory("SZU",.T.)
		Endif

		TGroup():New(aPosObj[1,1], aPosObj[1,2], aPosObj[1,3], aPosObj[1,4]," Dados do Chamado ",oDlg,,,.T.)
		oSZUEnch := MsMGet():New(cAlias1,nRec1,nOpc,,,,aCposE1,aPosE1,aAltE1,3,,,,,,.T.,,)

		If lAltera

			aTela := {}
			aGets := {}
			RegToMemory("SZV",.T.)
			TGroup():New(aPosObj[2,1], aPosObj[2,2],aPosObj[2,3], aPosObj[2,4]," Ocorrência ",oDlg,,,.T.)
			oSZVEnch := MsMGet():New(cAlias2,nRec2,nOpc,,,,aCposE2,aPosE2,aAltE2,3,,,,,,.T.,,)

		Endif

		If lAltera .Or. lVisualiza

			If lAltera
				oFld := TFolder():New(aPosObj[3,1], aPosObj[3,2],aTitles,,oDlg,,,,.T.,.F., (((aPosObj[3,4]-aPosObj[3,2])/100)*99),(((aPosObj[3,3]-aPosObj[3,1])/100)*99) ,)
				oFld:nOption := 2
				oFld:Refresh()
			Else
				oFld := TFolder():New(aPosObj[2,1], aPosObj[2,2],aTitles,,oDlg,,,,.T.,.F., (((aPosObj[2,4]-aPosObj[2,2])/100)*99),(((aPosObj[2,3]-aPosObj[2,1])/100)*99) ,)
			Endif

			@ 003,004 LISTBOX oLbx VAR cVar FIELDS HEADER "Data","Hora","Tipo","Descricao","Origem","Resumo" SIZE ((((oFld:nRight)/2)/100)*98),((((oFld:nBottom-100)/2)/100)*IIF(lAltera,33,49)) OF oFld:aDialogs[1] PIXEL ;
			ON DBLCLICK( ViewDetHist( oLbx:nAt ) )
			oLbx:SetArray( aHistorico )
			oLbx:LHScroll := .F.
			oLbx:bLine := {|| {   aHistorico[oLbx:nAt,1],;
	                             aHistorico[oLbx:nAt,2],;
	                		        aHistorico[oLbx:nAt,3],;
			                       aHistorico[oLbx:nAt,4],;
			                       aHistorico[oLbx:nAt,5],;
			                       aHistorico[oLbx:nAt,8]}}

	        If lAltera
				@ 3,2  GET oTexto VAR cTexto MEMO SIZE (oFld:aDialogs[2]:nClientWidth/2)-3 , ((((oFld:nBottom-100)/2)/100)*33) FONT oFontPad PIXEL OF oFld:aDialogs[2]
			  	oTexto:oFont:= oFontPad
		  	Endif

	  	Elseif lInclui

 			oFld := TFolder():New(aPosObj[2,1], aPosObj[2,2],aTitles,,oDlg,,,,.T.,.F.,(((aPosObj[2,4]-aPosObj[2,2])/100)*99),(((aPosObj[2,3]-aPosObj[2,1])/100)*99),)

			@ 2,2  GET oTexto VAR cTexto MEMO SIZE (oFld:aDialogs[1]:nClientWidth/2)-3 , ((((oFld:nBottom-100)/2)/100)*48) FONT oFontPad PIXEL OF oFld:aDialogs[1]
		  	oTexto:oFont:= oFontPad

	  	Endif

	oDlg:Activate(,,,,,,{||EnchoiceBar(oDlg,bOk,bCancel,,aBotoes)},,)

	Do Case

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Edicao do chamado - ALTERACAO  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		Case xOpc == 1 .And. !lVisualiza .And. ( lInclui .Or. lAltera )

			DbSelectArea("SZG")
			DbSetOrder(1)
			DbSeek( xFilial("SZG") + IIF( lInclui , "001" , M->ZV_TIPO ) )

			Begin Transaction

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Faz a alocacao do chamado para o tecnico que realizar o primeiro complemento ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				RecLock( "SZU" , lInclui )

			    	If lInclui

				    	ConfirmSx8()
						SZU->ZU_FILIAL	:= xFilial("SZU")
						SZU->ZU_CHAMADO	:= M->ZU_CHAMADO
						SZU->ZU_DATA	:= Date()//ddatabase
						SZU->ZU_DATAORI	:= Date()
						SZU->ZU_HRABERT	:= Time()
						SZU->ZU_TECNICO	:= If(!(funname() == 'USRMENU'), RetCodUsr(),"AUTOMA")
						SZU->ZU_FEEDBAC	:= "S"
						SZU->ZU_DTFECHA := m->ZU_DTFECHA

						If !Empty(__cAnexo)
							cTexto += ENTER+Grv_Anexo(__cAnexo)
							__cAnexo := ''
						EndIf

						cTexto+=ENTER+ENTER+' [Contato: '+Alltrim(m->ZU_NOMEUSR/*Upper(Substr(m->ZU_NOMEUSR,1,At(" ",m->ZU_NOMEUSR)))+Substr(m->ZU_NOMEUSR,At(" ",m->ZU_NOMEUSR)+1,Len(m->ZU_NOMEUSR))*/)+']'

					Endif

					If !Empty(__cAnexo)
						cTexto += ENTER+Grv_Anexo(__cAnexo)
						__cAnexo := ''
					EndIf

					SZU->ZU_DATAATU	:= Date()
					SZU->ZU_CODUSR 	:= m->ZU_CODUSR
					SZU->ZU_NOMEUSR	:= m->ZU_NOMEUSR//Upper(Substr(m->ZU_NOMEUSR,1,At(" ",m->ZU_NOMEUSR)))+Substr(m->ZU_NOMEUSR,At(" ",m->ZU_NOMEUSR)+1,Len(m->ZU_NOMEUSR))
					SZU->ZU_MAILUSR	:= m->ZU_MAILUSR
					SZU->ZU_TELUSR 	:= m->ZU_TELUSR
					SZU->ZU_CODSUP 	:= m->ZU_CODSUP
					SZU->ZU_NOMESUP	:= m->ZU_NOMESUP//Upper(Substr(m->ZU_NOMESUP,1,At(" ",m->ZU_NOMESUP)))+Substr(m->ZU_NOMESUP,At(" ",m->ZU_NOMESUP)+1,Len(m->ZU_NOMESUP))
					SZU->ZU_MAILSUP	:= m->ZU_MAILSUP
					SZU->ZU_EMAILS 	:= m->ZU_EMAILS
					SZU->ZU_STATUS	:= IIF( lInclui , "A" , "E" )
					SZU->ZU_DIVISAO	:= m->ZU_DIVISAO
					SZU->ZU_ASSUNTO	:= m->ZU_ASSUNTO
					SZU->ZU_ROTINA		:= m->ZU_ROTINA
					SZU->ZU_IP_ADDR 	:= m->ZU_IP_ADDR
					SZU->ZU_PRIORID 	:= m->ZU_PRIORID

					IF SZU->ZU_TECNICO == "AUTOMA" .And. !(funname() == 'USRMENU')
						SZU->ZU_TECNICO	:= RetCodUsr()
					Endif

				MsUnLock()

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Gera registro de acompanhamento ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				DbSelectArea("SZV")
				RecLock( "SZV" , .T. )
					SZV->ZV_FILIAL	:= xFilial("SZV")
					SZV->ZV_CHAMADO	:= M->ZU_CHAMADO
					SZV->ZV_DATA	:= Date()//ddatabase
					SZV->ZV_TIPO	:= IIF( lInclui , "001" , M->ZV_TIPO )
					SZV->ZV_CODSYP	:= u_GrvMemo( cTexto , "ZV_CODSYP" )
					SZV->ZV_NUMSEQ	:= u_RetZVNum( M->ZU_CHAMADO )
					SZV->ZV_HORA	:= Time()
					SZV->ZV_TECNICO	:= If(!(funname() == 'USRMENU'), RetCodUsr(),"AUTO")
				MsUnLock()

			End Transaction

			If lAltera

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Da baixa no chamado de acordo com o tipo da analise ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				IF SZG->ZG_ENCERRA == "S" .AND. SZG->ZG_TRANSF != "S"

					lEncerra:= .T.
					cHr		:= Time()
					cMsg 	:= "Em " + DTOC(Date()) + " as " + cHr + " o usuário " + Alltrim(m->ZU_NOMEUSR) + " encerrou este chamado."

					Begin Transaction

						DbSelectArea("SZU")
						DbSetOrder(1)
						If DbSeek( xFilial("SZU") + M->ZU_CHAMADO  )
							RecLock("SZU",.F.)
								SZU->ZU_FEEDBAC	:= ""
								SZU->ZU_STATUS	:= "F"
								SZU->ZU_DATAOK	:= Date()//ddatabase
								SZU->ZU_HROK	:= Time()
							MsUnLock()
						Endif

/*						DbSelectArea("SZV")
						RecLock( "SZV" , .T. )
							SZV->ZV_FILIAL	:= xFilial("SZV")
							SZV->ZV_CHAMADO	:= SZU->ZU_CHAMADO
							SZV->ZV_DATA	:= ddatabase
							SZV->ZV_TIPO	:= SZG->ZG_CODIGO
							SZV->ZV_CODSYP	:= u_GrvMemo( cMsg , "ZV_CODSYP" )
							SZV->ZV_NUMSEQ	:= u_RetZVNum( SZU->ZU_CHAMADO )
							SZV->ZV_HORA	:= cHr
							SZV->ZV_TECNICO	:= RetCodUsr()
						MsUnLock()
*/
					End Transaction

//					LjMsgRun("Aguarde ... Encerrando chamado ... ",,{|| CursorWait(),u_OpenProc(M->ZU_CHAMADO,"E",2),CursorArrow()})

				Elseif SZG->ZG_TRANSF == "S" .And. SZG->ZG_ENCERRA !="S'

					cHr		:= Time()
					cMsg 	:= "Em " + DTOC(Date()) + " as " + cHr + " o usuário " + Alltrim(m->ZU_NOMEUSR) + " transferiu este chamado para: " + Tabela("ZZ",SZG->ZG_AREA)

					Begin Transaction
						DbSelectArea("SZU")
						DbSetOrder(1)
						If DbSeek( xFilial("SZU") + M->ZU_CHAMADO  )
							RecLock("SZU",.F.)
								SZU->ZU_TECNICO	:= "AUTOMA"			// Deixa o chamado novamente sem alocacao pois foi transferido
								SZU->ZU_STATUS	:= "T"
								SZU->ZU_DIVISAO	:= SZG->ZG_AREA
								SZU->ZU_FEEDBAC	:= "S"				// Aguarda Feedback do Suporte
							MsUnLock()
						Endif

/*						DbSelectArea("SZV")
						RecLock( "SZV" , .T. )
							SZV->ZV_FILIAL	:= xFilial("SZV")
							SZV->ZV_CHAMADO	:= SZU->ZU_CHAMADO
							SZV->ZV_DATA	:= ddatabase
							SZV->ZV_TIPO	:= SZG->ZG_CODIGO
							SZV->ZV_CODSYP	:= u_GrvMemo( cMsg , "ZV_CODSYP" )
							SZV->ZV_NUMSEQ	:= u_RetZVNum( SZU->ZU_CHAMADO )
							SZV->ZV_HORA	:= cHr
							SZV->ZV_TECNICO	:= RetCodUsr()
						MsUnLock()*/
	                End Transaction

				Else

					DbSelectArea("SZU")
					DbSetOrder(1)
					If DbSeek( xFilial("SZU") + M->ZU_CHAMADO  )
						RecLock("SZU",.F.)
							SZU->ZU_STATUS	:= "E"
							IF !EMPTY(SZG->ZG_FEEDBAC)
								SZU->ZU_FEEDBAC	:= SZG->ZG_FEEDBAC
							Endif
						MsUnLock()
					Endif

				Endif


				If lOpenProc
					If lAltera
						IF lEncerra
							LjMsgRun("Criando task para encerramento automático por não validação  ... Aguarde .."  ,, { || u_OpenProc(M->ZU_CHAMADO,"E",2) })
						Else
							IF MsgYesNo("Deseja enviar a ficha do chamado atualizado via e-mail para o cliente ?","Atualização")
								LjMsgRun("Enviando mensagem ... Aguarde ..",,{|| CursorWait(),u_OpenProc(M->ZU_CHAMADO,"C",2),CursorArrow()})
							Endif
						Endif
					Endif
				Endif

		    Endif

			If lInclui
				LjMsgRun("Enviando mensagem ... Aguarde ..",,{|| CursorWait(),u_OpenProc(M->ZU_CHAMADO,"A",1),CursorArrow()})
			Endif

	EndCase

	RestArea(aArea)

Return(IIF(xOpc==1,.T.,.F.))


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³ Grv_Anexo() º Autor ³ Fernando Nogueira  º Data ³23/10/2013º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Grava um item com o anexo... 						   	  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Grv_Anexo(__cAnexo)

	__nLi  := 1
	__cRt  := ''

	DbSelectArea("SZV")
	DbSetOrder(1)
	If DbSeek( xFilial("SZV") +  M->ZU_CHAMADO)
		While !SZV->(Eof()) .And. SZV->ZV_FILIAL+SZV->ZV_CHAMADO == xFilial("SZV")+ M->ZU_CHAMADO
			__nLi ++
			DbSelectArea("SZV")
			DbSkip()
		End
	Endif

	cArqDest := '\web\ws\anexos\'+M->ZU_CHAMADO
	MakeDir(cArqDest)
	cArqDest := '\web\ws\anexos\'+M->ZU_CHAMADO+'\'+StrZero(__nLi++,3)
    MakeDir(cArqDest)

	CpyT2S( alltrim(__cAnexo) , cArqDest, .F. )

	__lVai    := .t.
	__nGuarda := 0
	__cGuarda := alltrim(__cAnexo)

	While __lVai
		If at('\',__cGuarda) <> 0
			__nGuarda := at('\',__cGuarda)
			__cGuarda := SubStr(__cGuarda,1,at('\',__cGuarda)-1)+'|'+SubStr(__cGuarda,__nGuarda+1,Len(alltrim(__cGuarda)))
		Else
			__lVai := .F.
		EndIf
	EndDo

	_cArqZip := cArqDest+'\'+M->ZU_CHAMADO+'.zip'
	GzCompress(cArqDest+SubStr(__cAnexo,__nGuarda,Len(alltrim(__cAnexo))),_cArqZip)
//	aAdd( aItens,alltrim(cArqDest+SubStr(__cAnexo,__nGuarda,Len(alltrim(__cAnexo)))) )
//	tarCompress( aItens, _cArqZip )

	If !File(_cArqZip) //Caso nao tenha sucesso na compactacao do arquivo, anexa arquivo assim mesmo
		cArqNv := NoAcento(RemoveAcento(cArqDest+SubStr(__cAnexo,__nGuarda,Len(alltrim(__cAnexo)))))
	//	cArqNv := RemoveAcento(cArqDest+SubStr(__cAnexo,__nGuarda,Len(alltrim(__cAnexo))))

	    If at(' ',cArqNv) <> 0
	    	cArqNv := lower(StrTran(alltrim(cArqNv), " " ,"_" ))
	    EndIf

	    FRename(cArqDest+SubStr(__cAnexo,__nGuarda,Len(alltrim(__cAnexo))),cArqNv)
	Else
		Ferase(cArqDest+SubStr(__cAnexo,__nGuarda,Len(alltrim(__cAnexo))))
		cArqNv := cArqDest+'\'+M->ZU_CHAMADO+'.zip'
	Endif

	If File(cArqNv)
		__cRt :=  'Foi enviado o anexo <a href="http://192.168.0.8:8088'+StrTran(alltrim(substr(cArqNv,8,300)), "\" ,"/" ) +'" target="_blank">'+Substr(Alltrim(SubStr(StrTran(alltrim(lower(__cAnexo)), " " ,"_" ),__nGuarda,Len(alltrim(StrTran(alltrim(lower(__cAnexo)), " " ,"_" ))))),2,200)+'</a>'+Chr(13)+Chr(10)+Chr(13)+Chr(10)
		__cRt +=  '* Caso nao consiga acessar o anexo click <a href="http://192.168.0.8:8088/winrar/wrar500.exe" target="_blank"> aqui.</a>'
	Else
		MsgInfo('Problema na gravação do anexo...')
	EndIf

Return(__cRt)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³ RemoveAcentoº Autor ³ Fernando Nogueira  º Data ³23/10/2013º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Remove acentos/caracteres especiais... 			   		  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function RemoveAcento(cString)

	Local nX        := 0
	Local nY        := 0
	Local cSubStr   := ""
	Local cRetorno  := ""

	Local cStrEsp	:= "ÁÃÂÀáàâãÓÕÔóôõÇçÉÊéêºíìÍÌúùÚÙ"
	Local cStrEqu   := "AAAAaaaaOOOoooCcEEeeriiIIuuUU" //char equivalente ao char especial

	For nX:= 1 To Len(cString)
		cSubStr := SubStr(cString,nX,1)
		nY := At(cSubStr,cStrEsp)
		If nY > 0
			cSubStr := SubStr(cStrEqu,nY,1)
		EndIf

		cRetorno += cSubStr
	Next nX

Return cRetorno
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³ MsAnxItem() º Autor ³ Fernando Nogueira  º Data ³23/10/2013º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Faz anexo de documento tecnico no sistema de chamado...    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function MsAnxItem(__cAnexo)

	Local _cDirect := Space(999999)
	Local oDlgSalva, oDirect
	Local _lRet := .F.
	Local nOpcao
	Local _nI

	Default __cAnexo := ''

	DEFINE MSDIALOG oDlgSalva FROM  154,321 TO 280,643 TITLE OemToAnsi("Envio de anexo:") PIXEL

	@  7,5 SAY OemToAnsi("Informe arquivo anexos que devera ser enviado:") Size 125,8 OF oDlgSalva PIXEL COLOR CLR_BLUE
	@ 22,5 MSGET oDirect VAR _cDirect F3 "DIR" Picture "@x" SIZE 140,10 OF oDlgSalva PIXEL

	DEFINE SBUTTON FROM 43, 95 TYPE 1 PIXEL ACTION (nOpcao:=1, oDlgSalva:End()) ENABLE OF oDlgSalva
	DEFINE SBUTTON FROM 43,127 TYPE 2 PIXEL ACTION (nOpcao:=2, oDlgSalva:End()) ENABLE OF oDlgSalva

	ACTIVATE MSDIALOG oDlgSalva CENTER

	If (nOpcao==1)
		__cAnexo := _cDirect
	Endif

Return()
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³ViewDetHist()º Autor ³ TOTVS SA           º Data ³27/10/2011º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Faz o zoom no detalhe das ocorrencias do chamado            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ViewDetHist( nEdLin )

	Private cView	:= u_GetTexto( AllTrim( aHistorico[nEdLin,6] ) )
	Private oView
	Private oDlgMemo

	oDlgMemo := TDialog():New(612,359,915,912,"Detalhe da ocorrência",,,,,,,,oMainWnd,.T.)

		TGroup():New(002,056,136,272,"",oDlgMemo,,,.T.)

		@ 000,000 BITMAP RESNAME "LOGIN" oF oDlgMemo SIZE 065,250 NOBORDER WHEN .F. PIXEL
		@ 006,059 GET oView Var cView MEMO Size 209,126 FONT oFontPad READONLY PIXEL OF oDlgMemo
		@ 138,136 BUTTON "&Anterior" 	ACTION ( IIF( nEdLin==1 , Nil , ( nEdLin -= 1 , DbSkipDet(nEdLin) ) ) ) Size 066,012 PIXEL OF oDlgMemo
		@ 138,205 BUTTON "&Próximo" 	ACTION ( IIF( nEdLin==Len(aHistorico) , Nil , ( nEdLin += 1 , DbSkipDet(nEdLin) ) ) ) Size 066,012 PIXEL OF oDlgMemo
		oView:Refresh()

	oDlgMemo:Activate(,,,.T.,,,,,)

Return(.T.)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³ DbSkipDet() º Autor ³ TOTVS SA           º Data ³27/10/2011º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Funcao Auxiliar									          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function DbSkipDet( nDet )

	cView	:= u_GetTexto( AllTrim( aHistorico[nDet,6] ) )
	oView:Refresh()

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³ usr_campos()º Autor ³ Fernando Nogueira  º Data ³23/10/2013º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Funcao Auxiliar									          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function usr_campos(_cCodigo)

	Local aGuarda := Array(3)

	PswOrder(1)
	If PswSeek( _cCodigo , .T. )
		aTable := PswRet()[1]
		aGuarda	:= {aTable[4],Left(Alltrim(aTable[11]),6),aTable[14]}
	EndIf

Return(aGuarda)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³ TecVldOk()  º Autor ³ TOTVS SA           º Data ³27/10/2011º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Funcao que faz a validacao de todos os campos da edicao e   º±±
±±º          ³inclusao de um novo chamado modelo novo                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function TecVldOk()

	Local lValid	:= .T.
	Local aCPObrig	:= { "M->ZU_CODUSR","M->ZU_NOMEUSR","M->ZU_MAILUSR","m->ZU_TELUSR","M->ZU_DIVISAO","M->ZU_ASSUNTO","M->ZU_ROTINA","cTexto" }

	If !lVisualiza
		If lAltera
			aAdd( aCPObrig , "M->ZV_TIPO" )
		Endif

		For o := 1 To Len(aCPObrig)
		    cCampo := aCPObrig[o]
			IF Empty(&cCampo)
				lValid	:= .F.
			Endif
		Next

		If !lValid
			MsgInfo("Campos obrigatórios não preenchidos !",,"INFO")
		Endif

		If M->ZU_CODUSR <> '000072' //Somente o Nilson nao tem Superior
			If Empty(m->ZU_CODSUP)
				MsgInfo("Campos obrigatórios não preenchidos !",,"Codigo do Supervisor")
				lValid	:= .F.
			ElseIf Empty(m->ZU_NOMESUP)
				MsgInfo("Campos obrigatórios não preenchidos !",,"Nome do Supervisor")
				lValid	:= .F.
			ElseIf Empty(m->ZU_MAILSUP)
				MsgInfo("Campos obrigatórios não preenchidos !",,"E-Mail do Supervisor")
				lValid	:= .F.
			EndIf
		EndIf
	Endif

Return( lValid )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³ gat_tel()   º Autor ³ Fernando Nogueira  º Data ³30/10/2013º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Funcao Auxiliar									          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function gat_tel()

	Local cCodUsr := M->ZU_CODUSR
	Local cTelUsr := ""

	BeginSql alias 'TRB'
	
		SELECT TOP 1 ZU_TELUSR FROM %table:SZU% SZU
		WHERE SZU.%notDel%
			AND ZU_CODUSR = %exp:cCodUsr%
		ORDER BY R_E_C_N_O_ DESC
		
	EndSql

	DbSelectArea('TRB')
	DbGotop()
   
	cTelUsr := TRB->ZU_TELUSR

	TRB->(DbCloseArea())	

Return cTelUsr
