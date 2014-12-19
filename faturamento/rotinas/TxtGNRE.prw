#INCLUDE "PROTHEUS.CH"
#INCLUDE "HBUTTON.CH"

#DEFINE		TAB				Chr(09)
#DEFINE 	DS_MODALFRAME	128

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ TXTGNRE  º Autor ³ Amedeo D. P. Filho º Data ³  27/01/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Geracao de Arquivo Texto para Exportacao dos Dados das     º±±
±±º          ³ GNREs.                                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico AVANT                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function TxtGNRE()
    Local cPerg := "TXTGNRE"
    
    AjustaSX1(cPerg)
    
    If Pergunte(cPerg, .T.)
		Processa({|| Gravacao(), "Gerando arquivo para importação..."})
    EndIf

Return Nil
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ Gravacao ºAutor  ³ Amedeo D. P. Filho º Data ³  27/01/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Processamento e gravacao do Arquivo texto.                 º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ TXTGNRE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Gravacao()
	Local cNome		:= "GNRE_" + DtoS(dDatabase) + "_" + StrTran(Time(), ":", "") + ".TXT"
	Local cPath		:= "C:\GNRE"
	Local oArquivo	:= Nil
	Local cSerNFS	:= MV_PAR01
	Local cDocIni	:= MV_PAR02
	Local cDocFin	:= MV_PAR03
	Local dDtIni	:= MV_PAR04
	Local dDtFin	:= MV_PAR05
	Local cUFGNRE	:=	GETMV("MV_UFGNRE")
	
	Local aFiltro	:= {}

	Local cFone		:= ""
	Local nQtdNfs	:= 0
	Local nPosNF	:= 0

	Local lContinua	:= .T.

	Private cAlias	:= ""

	oArquivo := Arquivo():New(cPath, cNome)
	
	If !oArquivo:ExistDir(cPath)
		If !oArquivo:CreateDir(cPath)
			MsgAlert("Impossível criar Diretório " + cPath + " Verifique")
			Return Nil
		EndIf
	EndIf

	If oArquivo:Exists()
		If !oArquivo:Erase()
			lContinua := .F.
		EndIf
	EndIf

	If lContinua
		If !oArquivo:Create()
			MsgAlert("Não foi possível gerar o arquivo " + cPath + cNome,"Verifique!!!")
			lContinua := .F.
		EndIf
	EndIf	

	ProcRegua(0)

	If lContinua

		MontaQuery(cSerNFS, cDocIni, cDocFin, dDtIni, dDtFin)
	
		If !(cAlias)->(Eof())
			lContinua := SELECIONA(@aFiltro)
		Else
			Aviso("Aviso","Não Existe dados nos Parametros Informados",{"Finalizar"})
			lContinua := .F.
		EndIf
		
		If !lContinua
			If oArquivo:Exists()
				oArquivo:Free()
				oArquivo:Close()
				oArquivo:Erase()
			EndIf
			Return Nil
		EndIf
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Gera o Arquivo GNRE      		³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		(cAlias)->(DbGotop())
		While !(cAlias)->(Eof())

			nPosNF := Ascan(aFiltro,{|x| x[01] == "A" + (cAlias)->DOC + (cAlias)->SERIE + (cAlias)->CLIENTE + (cAlias)->LOJACLI})
			
			If nPosNF == 0
				(cAlias)->(DbSkip())
				Loop
			EndIf
			
			(cAlias)->(IncProc("Gerando Arquivo Nota : " + (cAlias)->DOC))

			DbSelectArea("SA1")
			DbSetOrder(1)
			If SA1->(DbSeek(xFilial("SA1") + (cAlias)->CLIENTE + (cAlias)->LOJACLI))
	
				cFone := Alltrim(SA1->A1_DDD) + AllTrim(SA1->A1_TEL)

				If Len(cFone) >= 11
					cFone := Substr(cFone, 1, 11)
				Else
					cFone := cFone + Space(11 - Len(cFone))
				EndIf

				cTexto		:= ""
				cTexto		+= Alltrim(SA1->A1_EST) 	+ TAB
				cTexto		+= Alltrim(MV_PAR07) 		+ TAB
				cTexto		+= SM0->M0_CGC + Space(14 - Len(SM0->M0_CGC))	+ TAB
				cTexto		+= (cAlias)->DOC + TAB
				cTexto		+= "1" + SubStr((cAlias)->EMISSAO,5,2) + SubStr((cAlias)->EMISSAO,1,4) + TAB
				cTexto		+= StrTran(Alltrim(Str((cAlias)->ICMSRET,15,2)),".",",") + TAB
				cTexto		+= "0,00" + TAB
				cTexto		+= "0,00" + TAB
				cTexto		+= "0,00" + TAB
				cTexto		+= StrTran(Alltrim(Str((cAlias)->ICMSRET,15,2)),".",",") + TAB
				cTexto		+= Substr(DtoS(MV_PAR06),7,2) + "/" + Substr(DtoS(MV_PAR06),5,2) + "/" + Substr(DtoS(MV_PAR06),1,4) + TAB
				cTexto		+= Alltrim(MV_PAR18) + TAB + Alltrim(Substr(SA1->A1_NOME,1,50)) + TAB
				cTexto		+= SA1->A1_INSCR + TAB
				cTexto		+= Alltrim(SubStr(SA1->A1_END,1,50)) + TAB
				cTexto		+= Alltrim(SA1->A1_MUN) 	+ TAB
				cTexto		+= Alltrim(SA1->A1_EST) 	+ TAB
				cTexto		+= Alltrim(SA1->A1_CEP) 	+ TAB
				cTexto		+= cFone					+ TAB
				cTexto		+= Alltrim(MV_PAR09)		+ TAB
				cTexto		+= "99"
				cTexto		+ CRLF

				nQtdNfs++

				(cAlias)->(DbSkip())
				
				oArquivo:Write(cTexto)
			EndIf
		Enddo

		oArquivo:Free()
		oArquivo:Close()
	
		(cAlias)->(DbCloseArea())

		//Mensagem de Arquivos
		If nQtdNfs > 0
			Aviso("Aviso", 	"Arquivo gerado com " 	+ AllTrim(Str(nQtdNfs)) + " Notas Fiscais de Saida.", {"Ok"},2)
		Else
			Aviso("Aviso", "Nenhum Arquivo / Título Gerado", {"Abandona"})
			If oArquivo:Exists()
				oArquivo:Erase()
			EndIf
		EndIf

	EndIf
	
Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MONTAQUERYº Autor ³ Amedeo D. P. Filho º Data ³  02/08/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Faz a Selecao dos Dados.                                   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ TXTGNRE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function MontaQuery(cSerNFS, cDocIni, cDocFin, dDtIni, dDtFin,cUFGNRE)

	cAlias	:= GetNextAlias()
	

 		//----> VERIFICA SE TEM INSCRICAO NO ESTADO
 		If MV_PAR10 = 1

	BeginSQL Alias cAlias


		SELECT	F2_DOC		AS DOC
		,		F2_SERIE	AS SERIE
		,		F2_CLIENTE	AS CLIENTE
		,		F2_LOJA		AS LOJACLI
		,		F2_EMISSAO	AS EMISSAO
		,		F2_ICMSRET	AS ICMSRET
		FROM	%Table:SF2%
		WHERE	%NotDel%
		AND		F2_FILIAL = %Exp:xFilial("SF2")%
		AND		F2_ICMSRET > 0
		AND		F2_DOC BETWEEN %Exp:cDocINI% AND %Exp:cDocFin%
		AND		F2_SERIE = %Exp:cSerNFS%
		AND		F2_EMISSAO BETWEEN %Exp:dDtIni% AND %Exp:dDtFin%
 		AND		F2_EST IN ('AC','AL','AM','AP','BA','ES','MA','MG','MS','PR','PI','RJ','RN','RR','RS','SC','SE','SP','TO','RO','PB','MT')

		ORDER	BY F2_DOC, F2_SERIE

	EndSQL

	Else
	     
		BeginSQL Alias cAlias


		SELECT	F2_DOC		AS DOC
		,		F2_SERIE	AS SERIE
		,		F2_CLIENTE	AS CLIENTE
		,		F2_LOJA		AS LOJACLI
		,		F2_EMISSAO	AS EMISSAO
		,		F2_ICMSRET	AS ICMSRET
		FROM	%Table:SF2%
		WHERE	%NotDel%
		AND		F2_FILIAL = %Exp:xFilial("SF2")%
		AND		F2_ICMSRET > 0
		AND		F2_DOC BETWEEN %Exp:cDocINI% AND %Exp:cDocFin%
		AND		F2_SERIE = %Exp:cSerNFS%
		AND		F2_EMISSAO BETWEEN %Exp:dDtIni% AND %Exp:dDtFin%
 		AND		F2_EST NOT IN ('AC','AL','AM','AP','BA','ES','MA','MG','MS','PR','PI','RJ','RN','RR','RS','SC','SE','SP','TO','RO','PB','MT')

		ORDER	BY F2_DOC, F2_SERIE

	EndSQL

	EndIf



Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³SELECIONA ºAutor  ³ Amedeo D. P. Filho º Data ³  28/07/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Tela para Selecao das Notas.                               º±±
±±º          ³                                                            º±±
±±º          ³ ExpC1 : Filtro de Geracao do Arquivo                       º±±
±±º          ³ ExpC2 : Filtro de Geracao dos Titulos                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ TXTGNRE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function SELECIONA(aFiltro)

	Local oOk 		:= LoadBitmap( GetResources(), "LBOK")
	Local oNo 		:= LoadBitmap( GetResources(), "LBNO")
	Local oFont1 	:= TFont():New("Arial",,020,,.T.,,,,,.F.,.F.)
	Local lRetorno	:= .F.
	Local lCheck1 	:= .F.
	Local lCheck2 	:= .F.
	Local lContinua	:= .T.
	Local nPosDoc	:= 0
	Local nOpc		:= 0
	Local cNomCli	:= ""
	Local cEstCli	:= ""

	Local oCheck1
	Local oCheck2
	Local oPanelC
	Local oPanelR
	Local nX

	Private aListBox 	:= {}

	Static oListBox
	Static oDlg

	While !(cAlias)->(Eof())
		
		nPosDoc := Ascan(aListBox,{|x| x[2]+x[3] == (cAlias)->DOC + (cAlias)->SERIE})
		cNomCli	:= Posicione("SA1",1,xFilial("SA1") + (cAlias)->CLIENTE + (cAlias)->LOJACLI, "SA1->A1_NOME")
		cEstCli	:= Posicione("SA1",1,xFilial("SA1") + (cAlias)->CLIENTE + (cAlias)->LOJACLI, "SA1->A1_EST")
		
		
		If nPosDoc == 0
			Aadd(aListBox,{	.F.,;
							(cAlias)->DOC,;
							(cAlias)->SERIE,;
							(cAlias)->CLIENTE,;
							(cAlias)->LOJACLI,;
							cNomCli,;
							cEstCli,;
							DtoC(StoD((cAlias)->EMISSAO)),;
							(cAlias)->ICMSRET})
		Else
			aListBox[nPosDoc][09] += (cAlias)->ICMSRET
		EndIf
		
		(cAlias)->(DbSkip())

	Enddo
	
	While lContinua
		
		DEFINE MSDIALOG oDlg TITLE "Selecao de Notas Fiscais" FROM 000, 000  TO 600, 800 COLORS 0, 16777215 PIXEL
		
			@ 000, 000 MSPANEL oPanelC SIZE 400, 050 OF oDlg COLORS 0, 16777215 RAISED
			@ 255, 000 MSPANEL oPanelR SIZE 400, 045 OF oDlg COLORS 0, 16777215 RAISED
	
			@ 012, 100 SAY oSay1 PROMPT "Seleção de Notas para Geração de Arquivo / Títulos GNRE" SIZE 230, 013 OF oPanelC FONT oFont1 COLORS 0, 16777215 PIXEL
	
			@ 030, 006 CHECKBOX oCheck1 VAR lCheck1 PROMPT "Marca / Inverte Seleção (Geração do Arquivo)" 		SIZE 150, 008 OF oPanelC COLORS 0, 16777215 PIXEL ON CLICK ( aEval(aListBox,{|x| If(x[1],x[1]:=.F.,x[1]:= .T.)}), oListBox:Refresh() )PIXEL
	
		    @ 010, 005 SAY oSay1 PROMPT "(F4 / Duplo Clique) - Marca / Desmarca Coluna A - Geração do Arquivo" 	SIZE 200, 007 OF oPanelR COLORS 255, 16777215 PIXEL
		    
		    @ 010, 350 BUTTON oButton1 PROMPT "Processa" 	SIZE 037, 012 OF oPanelR PIXEL Action( nOpc := 1, oDlg:End() )
		    @ 022, 350 BUTTON oButton2 PROMPT "Sair" 		SIZE 037, 012 OF oPanelR PIXEL Action( nOpc := 0, oDlg:End() )
	
		    SET MESSAGE OF oDlg COLORS 0, 14215660
		    TMsgItem():New(oDlg:oMsgBar,"F4",,,,,.T.,{|| aListBox[oListBox:nAT,1] := !aListBox[oListBox:nAT,1] ,oListBox:DrawSelect() })

			@ 050, 000 LISTBOX oListBox Fields HEADER "A","Nota","Série","Cliente","Loja","Nome do Cliente","UF","Emissão","Valor" SIZE 400, 205 OF oDlg PIXEL ColSizes 50,50
	
			oListBox:SetArray(aListBox)
			oListBox:bLine := {||	{;
									If(	aListBox[oListBox:nAT,1],oOk,oNo),;
										aListBox[oListBox:nAt,2],;
										aListBox[oListBox:nAt,3],;
										aListBox[oListBox:nAt,4],;
										aListBox[oListBox:nAt,5],;
										aListBox[oListBox:nAt,6],;
										aListBox[oListBox:nAt,7],;
										aListBox[oListBox:nAt,8],;
										Transform(aListBox[oListBox:nAt,9],"@E 999,999,999.99");
									}}
				
			SetKey(VK_F4, { || aListBox[oListBox:nAT,1] := !aListBox[oListBox:nAT,1] ,oListBox:DrawSelect() } )
			oListBox:bLDblClick := {|| aListBox[oListBox:nAt,1] := !aListBox[oListBox:nAt,1],	oListBox:DrawSelect()}
			
			oListBox:nScrollType := 1
			
			oPanelC:Align 	:= CONTROL_ALIGN_TOP
			oPanelR:Align 	:= CONTROL_ALIGN_BOTTOM
			oListBox:Align	:= CONTROL_ALIGN_ALLCLIENT
		
		ACTIVATE MSDIALOG oDlg CENTERED
	    
		If nOpc == 1
			For nX := 1 To Len(aListBox)
				
				If aListBox[nX][01]
					lContinua 	:= .F.
					lRetorno 	:= .T.
					Aadd(aFiltro,{	If(aListBox[nX][01], "A" + aListBox[nX][02] + aListBox[nX][03] + aListBox[nX][04] + aListBox[nX][05], "")})	//[01] - Filtro de Arquivo
				EndIf
				
			Next nX
			
			If !lRetorno
				Aviso("Aviso","Nenhum Registro foi Marcado para Geração",{"Ok"})
			EndIf
		
		Else
			lContinua := .F.
		EndIf
		
    Enddo

Return lRetorno

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AjustaSX1 ºAutor  ³ Amedeo D. P. Filho º Data ³  27/01/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Gravacao das Perguntas no SX1                              º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ TXTGNRE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function AjustaSX1(cPerg)
	Local nXX	:= 0
	Local aPerg	:= {}
	
	If Len(SX1->X1_GRUPO) > Len(cPerg)
		cPerg := cPerg + Space(Len(SX1->X1_GRUPO) - Len(cPerg))
	EndIf

	Aadd( aPerg, {"Serie NF"		, "C", 03, 00, "G", "", "", "", "", "", "" } ) //01
	Aadd( aPerg, {"NF Inicial"		, "C", 09, 00, "G", "", "", "", "", "", "" } ) //02
	Aadd( aPerg, {"NF Final"		, "C", 09, 00, "G", "", "", "", "", "", "" } ) //03
	Aadd( aPerg, {"Data Inicial"	, "D", 08, 00, "G", "", "", "", "", "", "" } ) //04
	Aadd( aPerg, {"Data Final"		, "D", 08, 00, "G", "", "", "", "", "", "" } ) //05
	Aadd( aPerg, {"Vencimento"		, "D", 08, 00, "G", "", "", "", "", "", "" } ) //06
	Aadd( aPerg, {"Cod. da Receita"	, "C", 06, 00, "G", "", "", "", "", "", "" } ) //07
	Aadd( aPerg, {"Cod. Convenio"	, "C", 30, 00, "G", "", "", "", "", "", "" } ) //08
	Aadd( aPerg, {"Mensagem"		, "C", 30, 00, "G", "", "", "", "", "", "" } ) //09

	For nXX := 1 To Len(aPerg)
		If !SX1->(Dbseek(cPerg + StrZero(nXX, 2)))
			Reclock("SX1",.T.)
			SX1->X1_GRUPO 		:= cPerg
			SX1->X1_ORDEM		:= StrZero(nXX, 2)
			SX1->X1_VARIAVL		:= "mv_ch" + Chr( nXX +96 )
			SX1->X1_VAR01		:= "mv_par" + StrZero(nXX,2)
			SX1->X1_PRESEL		:= 1
			SX1->X1_PERGUNT		:= aPerg[ nXX , 01 ]
			SX1->X1_TIPO 		:= aPerg[ nXX , 02 ]
			SX1->X1_TAMANHO		:= aPerg[ nXX , 03 ]
			SX1->X1_DECIMAL		:= aPerg[ nXX , 04 ]
			SX1->X1_GSC  		:= aPerg[ nXX , 05 ]
			SX1->X1_DEF01		:= aPerg[ nXX , 06 ]
			SX1->X1_DEF02		:= aPerg[ nXX , 07 ]
			SX1->X1_DEF03		:= aPerg[ nXX , 08 ]
			SX1->X1_DEF04		:= aPerg[ nXX , 09 ]
			SX1->X1_DEF05		:= aPerg[ nXX , 10 ]
			SX1->X1_F3   		:= aPerg[ nXX , 11 ]
			SX1->(MsUnlock())
		EndIf
	Next nXX

Return Nil