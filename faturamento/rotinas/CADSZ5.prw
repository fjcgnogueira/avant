#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"
#INCLUDE "FWMVCDEF.CH"
#INCLUDE "SCROLLBX.CH"
#include "JPEG.CH"
#include 'Fileio.CH'         

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ CADSZ5   บ Autor ณ Amedeo D. P. Filho บ Data ณ  09/04/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Cadastro de Pre-Clientes (AVANT)                           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Avant                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function CADSZ5()

	Local aFiltro		:= {"1-Processados","2-Nใo Processados","3-Todas"}
	Local aIndArqu  	:= {}
	Local aPerg    		:= {}
	Local aArea := GetArea()		// Salva a area
	Local aAreaSZ5  := SZ5->(GetArea())
	Local aAreaSA1  := SA1->(GetArea())
	Local aAreaSA2  := SA2->(GetArea())
	Local aAreaSA3  := SA3->(GetArea())
	Private cCadastro 	:= "Cadastro de Pr้-Cliente (AVANT)"
	Private aRotina		:= {}
	Private aCores		:= {}
	Private cCondicao 	:= ""
	Private bFiltraBrow
	Private aRotina	:=	{ 	{"Pesquisar","AxPesqui"	,0	,1} ,;
							{"Visualizar"			,"AxVisual"		,0,2} ,;
							{"Alterar"				,"AxAltera"		,0,4} ,;
							{"Excluir"				,"AxDeleta"		,0,5} ,;
		             		{"Exportar_Cliente"		,"U_CADSZ5IMP"	,0,3} ,;
		             		{"Exportar_Fornec."		,"U_CADSA2"		,0,6} ,;
		             		{"Exportar_Vendedor"	,"U_CADSA3"		,0,6} ,;
		             		{"Filtro"				,"U_FILTROSZ5"	,0,6} ,;
		             		{"Legenda"				,"U_CADSZ5LEG"	,0,5} }

	aCores := {}
	
		aAdd( aCores, { "Z5_STATUS == 'S'" 						  						 , "BR_VERDE"  })
		aAdd( aCores, { "Z5_PRCFOR == 'S' .AND. Z5_PRCVEND <> 'S'"						 , "BR_LARANJA"   })
		aAdd( aCores, { "Z5_PRCFOR <> 'S' .AND. Z5_PRCVEND == 'S'"						 , "BR_AMARELO"})
		aAdd( aCores, { "Z5_PRCFOR == 'S' .AND. Z5_PRCVEND == 'S'"						 , "BR_PINK"  })
		aAdd( aCores, { "Z5_STATUS == 'N' .AND. Z5_PRCFOR == 'N' .AND. Z5_PRCVEND == 'N'", "BR_VERMELHO"})
		


	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณDefine as Perguntas na Abertura do Browse ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	Aadd(aPerg,{2,"Filtro"		,"",aFiltro	,120,".T.",.T.,".T."})

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณChama tela de Parametros                  ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If ParamBox(aPerg,"",,,,,,,,"CADSZ5",.T.,.T.)

		cCondicao += " Z5_FILIAL == '"+xFilial("SZ5")+"' "

		If SubStr(MV_PAR01,1,1) == "1"
			cCondicao += " .AND. Alltrim(Z5_STATUS) == 'S' "
		ElseIf SubStr(MV_PAR01,1,1) == "2"
			cCondicao += " .AND. Alltrim(Z5_STATUS) == 'N' "
		EndIf

		bFiltraBrow := {|| FilBrowse("SZ5",@aIndArqu,@cCondicao) }
		Eval(bFiltraBrow)				

		 MBrowse( 6, 1,22,75,"SZ5",,,,,,aCores) 

		DbSelectArea("SZ5")
		RetIndex("SZ5")
		DbClearFilter()
		aEval(aIndArqu,{|x| Ferase(x[1]+OrdBagExt())})			
    
    EndIF
RestArea(aArea)
SZ5->(RestArea(aAreaSZ5))
SA1->(RestArea(aAreaSA1))
SA2->(RestArea(aAreaSA2))
SA3->(RestArea(aAreaSA3))    
Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCADSZ5LEG บ Autor ณ Amedeo D. P. Filho บ Data ณ  09/04/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Legenda do Cadastro de Pre-Clientes (AVANT)               บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Avant                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function CADSZ5LEG()

	BrwLegenda(cCadastro,"Legenda",{	{"BR_VERMELHO","Cadastro Nใo Importado"          },;	
										{"BR_VERDE"	  ,"Cadastro Importado P/ Clientes"  },; 	
	                                    {"BR_LARANJA" ,"Cadastro Importado P/ Fornecedor"},;
	                                    {"BR_AMARELO" ,"Cadastro Importado P/ Vendedor"  },;
	                                    {"BR_PINK"    ,"Cadastro Importado P/ Fornec./Vendedor"}})

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCADSZ5IMP บ Autor ณ Amedeo D. P. Filho บ Data ณ  09/04/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณImporta Clientes Web                                        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Avant                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function CADSZ5IMP(cAlias, nRecno, nOpc)
	Local lACAtivo  	:= GetNewPar("MV_ACATIVO", .F.)
	Local aButtons  	:= {}
	Local aValues		:= {}
    Local cTipoCli		:= "F"
    Local cAliasA1		:= ""
    Local cCgcCad		:= ""
    Local cCodCli		:= ""
    Local cLojaCli		:= ""
    Local cCodFor		:= ""
    Local cLojaFor		:= ""
    Local cEndCli		:= ""
    Local cEndCob		:= ""
    Local cEndEnt		:= ""
    Local cCodPa		:= ""
	Local lAchou		:= .F.
	Local nOpc			:= 3
	Local _cTipo	    := ""
	Local _cGRPTRIB	    := ""
	Local cMsgErro		:= ""
	Local aArea 		:= GetArea()		// Salva a area
	Local aAreaSZ5  	:= SZ5->(GetArea())
	Local aAreaSA1  	:= SA1->(GetArea())
	Local aAreaSA2  	:= SA2->(GetArea())
	Local aAreaSA3  	:= SA3->(GetArea())
	Local cPath			:= "\imagens\clientes\"
	Local cBitMap		:= AllTrim(SZ5->Z5_CGC)
	Local lIncluiu		
	Local lExistImg		:= .F.
	
	Private aRotAuto	 := Nil
	Private lMsErroAuto := .F.
	Private oRep 		 := TBmpRep():New(0, 0, 0, 0, "", .T., oMainWnd, Nil, Nil, .F., .F.)

	DbSelectarea("SZ5")
	SZ5->(DbGoto(nRecno))
	If SZ5->Z5_STATUS <> "N"
		Aviso("Aviso","Esse cadastro nใo estแ com Status para ser Importado",{"Abandona"},1,"Verifique")
		Return
	EndIf
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Verifica se ja Existe no Cadastro de Clientes		ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	DbSelectarea("SA1")
	SA1->(DbSetorder(3))
	If SA1->(DbSeek(xFilial("SA1") + SZ5->Z5_CGC))
		Aviso("Aviso",	"Cliente " + ALLTRIM(SZ5->Z5_RAZASOC) + " CNPJ/CPF: " + SZ5->Z5_CGC + CRLF +;
						"Jแ estแ cadastrado como cliente! "  + CRLF +;
						"C๓digo / Loja: " + SA1->A1_COD + " / " + SA1->A1_LOJA + CRLF, {"Abandona"},3)
		Return
	EndIf
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Verifica se ja Existe no Cadastro de Clientes		ณ
	//ณ Cliente com a mensma Base do CNPJ.            		ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If Len(Alltrim(SZ5->Z5_CGC)) == 14

		cCgcCad	 := SubStr(SZ5->Z5_CGC,1,9)
		cAliasA1 := GetNextAlias()
		cTipoCli := "J"
		
		BeginSQL Alias cAliasA1
			SELECT	A1_COD	AS CODIGO
			,		A1_LOJA	AS LOJA
			FROM	%Table:SA1%
			WHERE	%NotDel%
			AND		SUBSTRING(A1_CGC,1,9) = %Exp:cCgcCad%
			ORDER	BY A1_COD, A1_LOJA
		EndSQL
	
		If !(cAliasA1)->(Eof())
			cCodCli	:= (cAliasA1)->CODIGO
			lAchou	:= .T.
			
			While !(cAliasA1)->(Eof())
				cCodCli	:= (cAliasA1)->CODIGO  // Fernando Nogueira - Chamado 000086
				cLojaCli := (cAliasA1)->LOJA
				(cAliasA1)->(DbSkip())
			Enddo
			
			(cAliasA1)->(DbCloseArea())
			cLojaCli := Soma1(cLojaCli)
			
		EndIf
	EndIf
	
	If !lAchou
		cCodCli	 := GetSx8Num("SA1","A1_COD")
		cLojaCli := StrZero(1,TamSx3("A1_LOJA")[1])
	EndIf
	
	If SZ5->Z5_XREGESP = ' ' .OR. SZ5->Z5_GRPTRIB = ' ' .OR. SZ5->Z5_X_CANAL = ' ' .OR. SZ5->Z5_X_SEGME = ' ' .OR. SZ5->Z5_X_PERFI = ' '
		Aviso("Verificar","Um ou mais campos obrigat๓rios nใo foram preenchidos!",{"OK"},2)
		Return
	EndIf
	
	If Aviso("Aviso","Confirma Importa็ใo do Cliente para o cadastro de Clientes?" + CRLF + CRLF +;
					 "Favor verificar os campos que devem ser preenchidos ap๓s a importa็ใo.",{"Sim","Nใo"}) == 2
		Return
	EndIf
	
	cEndCli	:= Alltrim(SZ5->Z5_ENDEREC) + " ," + IIF(!Empty(SZ5->Z5_ENDERNR), SZ5->Z5_ENDERNR, "SN")
	cEndCob	:= Alltrim(SZ5->Z5_ENDPAG)  + " ," + IIF(!Empty(SZ5->Z5_ENDNRPG), SZ5->Z5_ENDNRPG, "SN") + IIF(!Empty(SZ5->Z5_COMPPAG), " - " + SZ5->Z5_COMPPAG, "")
	cEndEnt	:= Alltrim(SZ5->Z5_ENDENT)  + " ," + IIF(!Empty(SZ5->Z5_ENDNREN), SZ5->Z5_ENDNREN, "SN") + IIF(!Empty(SZ5->Z5_COMPEN), " - " + SZ5->Z5_COMPEN, "")
	cCodPa	:= Posicione("SYA",2,xFilial("SYA") + Upper(SZ5->Z5_PAIS), "SYA->YA_CODGI")
	

	If SZ5->Z5_XREGESP = "S"
		_cTipo    := "R"
		_cGRPTRIB := "060"
	Else
		_cTipo    := "S"
		_cGRPTRIB := SZ5->Z5_GRPTRIB
	EndIf
	
	// Fernando Nogueira - Chamado 004656
	If File(cPath + cBitMap + ".jpg")
		oRep:OpenRepository()
		oRep:InsertBmp(cPath + cBitMap + ".jpg", cBitMap, @lIncluiu)
		lExistImg := oRep:ExistBmp(cBitMap)
		oRep:CloseRepository()
	ElseIf File(cPath + cBitMap + ".png")
		oRep:OpenRepository()
		oRep:InsertBmp(cPath + cBitMap + ".png", cBitMap, @lIncluiu)
		lExistImg := oRep:ExistBmp(cBitMap)
		oRep:CloseRepository()
	Endif
	
	
	
	aValues	:= {	{"A1_LOJA"		,cLojaCli			   , Nil},;
					{"A1_COD"		,cCodCli			   , Nil},;
					{"A1_NOME"		,UPPER(SZ5->Z5_RAZASOC), Nil},;
					{"A1_NREDUZ"	,UPPER(SZ5->Z5_NOMEABR), Nil},;
					{"A1_PESSOA"  	,cTipoCli			   , Nil},;
					{"A1_CGC"		,SZ5->Z5_CGC		   , Nil},;
					{"A1_TIPO"  	,"S"				   , Nil},;
					{"A1_END"   	,UPPER(cEndCli)		   , Nil},;
					{"A1_EST"   	,UPPER(SZ5->Z5_UF)     , Nil},;
					{"A1_COD_MUN"	,SZ5->Z5_CDMUNIC	   , Nil},;
					{"A1_MUN"   	,UPPER(SZ5->Z5_CIDADE) , Nil},;
					{"A1_COND"		,SZ5->Z5_CONDPAG	   , Nil},;
					{"A1_INSCR"		,SZ5->Z5_INSCEST	   , Nil},;
					{"A1_CEP"		,SZ5->Z5_CEP		   , Nil},;
					{"A1_DDD"		,SZ5->Z5_TELEFDD	   , Nil},;
					{"A1_TEL"		,SZ5->Z5_TELEFON	   , Nil},;
					{"A1_VEND"		,ALLTRIM(SZ5->Z5_CODVEND), Nil},;
					{"A1_BAIRRO"	,UPPER(SZ5->Z5_BAIRRO) , Nil},;
					{"A1_CEL"		,SZ5->Z5_CELULAR	   , Nil},;
					{"A1_FAX"		,SZ5->Z5_FAX		   , Nil},;
					{"A1_CONTATO"	,UPPER(SZ5->Z5_CONTATO), Nil},;
					{"A1_COMPLEM"	,UPPER(SZ5->Z5_ENDCOMP), Nil},;
					{"A1_DTINCLU"	,SZ5->Z5_DTCADAS	   , Nil},;
					{"A1_ENDCOB"	,UPPER(cEndCob)		   , Nil},;
					{"A1_BAIRROC"	,UPPER(SZ5->Z5_BAIRROP), Nil},;
					{"A1_CEPC"		,SZ5->Z5_CEPPG		   , Nil},;
					{"A1_MUNC"		,UPPER(SZ5->Z5_CIDADEP), Nil},;
					{"A1_ESTC"		,UPPER(SZ5->Z5_UFPG)   , Nil},;
					{"A1_ENDENT"	,UPPER(cEndEnt)		   , Nil},;
					{"A1_BAIRROE"	,UPPER(SZ5->Z5_BAIRROE), Nil},;
					{"A1_CEPE"		,SZ5->Z5_CEPEN		   , Nil},;
					{"A1_EMAIL"		,SZ5->Z5_EMAIL		   , Nil},;
					{"A1_X_MAIL2"	,SZ5->Z5_EMAIL1		   , Nil},;
					{"A1_X_MALT"	,SZ5->Z5_X_MALT		   , Nil},;
					{"A1_PRF_OBS"	,SZ5->Z5_OBSERV		   , Nil},;
					{"A1_SUFRAMA"	,SZ5->Z5_SUFRAMA	   , Nil},;
					{"A1_NMGER"		,UPPER(SZ5->Z5_NMGEREN), Nil},;
					{"A1_NMPRO"		,UPPER(SZ5->Z5_NMCOMPR), Nil},;
					{"A1_DTGER"		,SZ5->Z5_ANIVGER	   , Nil},;
					{"A1_DTPROR"	,SZ5->Z5_ANIVPRO	   , Nil},;
					{"A1_DTCOMP"	,SZ5->Z5_ANIVCOM	   , Nil},;
					{"A1_NMCOMP"	,UPPER(SZ5->Z5_PROPRIE), Nil},; 
					{"A1_DESCWEB"	,SZ5->Z5_DESCWEB	   , Nil},;   
					{"A1_CNAE"		,SZ5->Z5_CNAE		   , Nil},;
					{"A1_X_HORA"	,SZ5->Z5_X_HORA	       , Nil},;
					{"A1_SATIV1"	,SZ5->Z5_X_CANAL       , Nil},;
					{"A1_SATIV2"	,SZ5->Z5_X_SEGME       , Nil},;
					{"A1_SATIV4"	,SZ5->Z5_X_PERFI       , Nil},;		
					{"A1_XREGESP"	,SZ5->Z5_XREGESP       , Nil},;
					{"A1_TIPO"	    ,_cTipo                , Nil},;
					{"A1_REGIAO"    ,SZ5->Z5_REGIAO        , Nil},;
					{"A1_BITMAP"    ,If(lExistImg,cBitMap,""), Nil},;
					{"A1_GRPTRIB"	,_cGRPTRIB             , Nil}}

	MSExecAuto({|x,y| MATA030(x,y)}, aValues, nOpc)			

	If lMsErroAuto
		RollBackSX8()
		MostraErro()
	Else
		ConfirmSX8()
		MsgInfo("Cliente: " + SA1->A1_COD + " Loja: " + SA1->A1_LOJA + " Cadastrado com Sucesso")
		DbSelectarea("SZ5")
		RecLock("SZ5",.F.)
			SZ5->Z5_STATUS	:= "S"
		MsUnlock()
		If MsgYesNo("Deseja abrir tela de Cadastro")
			AxAltera("SA1", SA1->(Recno()) ,3,/*aAcho*/,/*aCpos*/,/*nColMens*/,/*cMensagem*/,	IIF(!lAcativo, "MA030TudOk()", "MA030TudOk() .And. AC700ALTALU()"),/*cTransact*/,/*cFunc*/,aButtons,/*aParam*/,aRotAuto,/*lVirtual*/)
		EndIf
	EndIf
RestArea(aArea)	
SZ5->(RestArea(aAreaSZ5))
SA1->(RestArea(aAreaSA1))
SA2->(RestArea(aAreaSA2))
SA3->(RestArea(aAreaSA3))
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ CADSA2   บ Autor ณ Rogerio Machado    บ Data ณ  19/07/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Cadastro de Pre-Clientes (AVANT)                           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Avant                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function CADSA2()

	Local aButtons  	:= {}
	Local aValues		:= {}
    Local cTipoFor		:= "F"
    Local cCgcCad		:= ""
    Local cCodFor		:= ""
    Local cLojaFor		:= ""
    Local cCodPa		:= ""
	Local lAchou		:= .F.
	Local nOpc			:= 3
	Local _cTipo	    := ""
	Local _cGRPTRIB	    := ""
	Local cEndFor       := ""
	Local aArea := GetArea()		// Salva a area
	Local aAreaSZ5  := SZ5->(GetArea())
	Local aAreaSA1  := SA1->(GetArea())
	Local aAreaSA2  := SA2->(GetArea())
	Local aAreaSA3  := SA3->(GetArea())
	Private aRotAuto 	:= Nil
	Private lMsErroAuto := .F.

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Verifica se ja Existe no Cadastro de Fornecedores	ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	DbSelectarea("SA2")
	SA2->(DbSetorder(3))
	
	If SA2->(DbSeek(xFilial("SA2") + SZ5->Z5_CGC))
		Aviso("Aviso",	"Fornecedor " + ALLTRIM(SZ5->Z5_RAZASOC) + " CNPJ/CPF: " + SZ5->Z5_CGC + CRLF +;
						"Jแ estแ cadastrado como fornecedor!" + CRLF +;
						"C๓digo / Loja: " + SA2->A2_COD + " / " + SA2->A2_LOJA + CRLF, {"Abandona"},3)
		Return
	Else
		cCodFor	 := GetSx8Num("SA2","A2_COD")
		cLojaFor := StrZero(1,TamSx3("A2_LOJA")[1])
	EndIf
	
	If Len(Alltrim(SZ5->Z5_CGC)) == 14
		cTipoFor := "J"
	EndIf
	
	cEndFor := ALLTRIM(UPPER(SZ5->Z5_ENDEREC)) +", "+ UPPER(SZ5->Z5_ENDERNR) +" - "+ UPPER(SZ5->Z5_ENDCOMP)

	aValues	:= {	{"A2_LOJA"		,cLojaFor			   , Nil},;
		{"A2_COD"		,cCodFor			   , Nil},;
		{"A2_NOME"		,UPPER(SZ5->Z5_RAZASOC), Nil},;
		{"A2_NREDUZ"	,UPPER(SZ5->Z5_NOMEABR), Nil},;
		{"A2_TIPO"  	,cTipoFor			   , Nil},;
		{"A2_CGC"		,SZ5->Z5_CGC		   , Nil},;
		{"A2_END"   	,cEndFor               , Nil},;
		{"A2_EST"   	,UPPER(SZ5->Z5_UF)     , Nil},;
		{"A2_COD_MUN"	,SZ5->Z5_CDMUNIC	   , Nil},;
		{"A2_MUN"   	,UPPER(SZ5->Z5_CIDADE) , Nil},;
		{"A2_INSCR"		,SZ5->Z5_INSCEST	   , Nil},;
		{"A2_CEP"		,SZ5->Z5_CEP		   , Nil},;
		{"A2_DDD"		,SZ5->Z5_TELEFDD	   , Nil},;
		{"A2_TEL"		,SZ5->Z5_TELEFON	   , Nil},;
		{"A2_BAIRRO"	,UPPER(SZ5->Z5_BAIRRO) , Nil},;
		{"A2_CEL"		,SZ5->Z5_CELULAR	   , Nil},;
		{"A2_FAX"		,SZ5->Z5_FAX		   , Nil},;
		{"A2_CONTATO"	,UPPER(SZ5->Z5_CONTATO), Nil},;
		{"A2_COMPLEM"	,UPPER(SZ5->Z5_ENDCOMP), Nil},;
		{"A2_ENDC"		,UPPER(SZ5->Z5_ENDPAG) , Nil},;
		{"A2_BAIRROC"	,UPPER(SZ5->Z5_BAIRROP), Nil},;
		{"A2_CEPC"		,SZ5->Z5_CEPPG		   , Nil},;
		{"A2_MUNC"		,UPPER(SZ5->Z5_CIDADEP), Nil},;
		{"A2_ESTC"		,UPPER(SZ5->Z5_UFPG)   , Nil},;
		{"A2_EMAIL"		,SZ5->Z5_EMAIL		   , Nil},;
		{"A2_TIPORUR"	,"J" 				   , Nil},;
		{"A2_TPESSOA"	,"OS"				   , Nil},;
		{"A2_PAIS"		,ALLTRIM("105")		   , Nil}}

	If Aviso("Aviso","Confirma Importa็ใo do Cliente para o cadastro de Fornecedores?" + CRLF + CRLF +;
					 "Favor verificar os campos que devem ser preenchidos ap๓s a importa็ใo.",{"Sim","Nใo"}) == 2
		Return
	EndIf

	MSExecAuto({|x,y| MATA020(x,y)}, aValues, 3)
	If lMsErroAuto
		RollBackSX8()
		MostraErro()
	Else
		ConfirmSX8()
		If MsgYesNo("Deseja abrir tela de Cadastro?")
			AxAltera("SA2", SA2->(Recno()) ,3,/*aAcho*/,/*aCpos*/,/*nColMens*/,/*cMensagem*/,	/*IIF(!lAcativo, "MA030TudOk()", "MA030TudOk() .And. AC700ALTALU()")*/,/*cTransact*/,/*cFunc*/,aButtons,/*aParam*/,aRotAuto,/*lVirtual*/)
		EndIf
		MsgInfo("Fornecedor " +cCodFor+ " loja " +cLojaFor+ " cadastrado com sucesso!","TOTVS")
		RecLock("SZ5",.F.)
			SZ5->Z5_PRCFOR	:= "S"
		MsUnlock()
	EndIf
RestArea(aArea)
SZ5->(RestArea(aAreaSZ5))
SA1->(RestArea(aAreaSA1))
SA2->(RestArea(aAreaSA2))
SA3->(RestArea(aAreaSA3))
Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ CADSA3   บ Autor ณ Rogerio Machado    บ Data ณ  19/07/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Cadastro de Pre-Clientes (AVANT)                           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Avant                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function CADSA3()
	Local aButtons  	:= {}
	Local aValues		:= {}
    Local cTipoVend		:= "E"
    Local cCgcCad		:= ""
    Local cCodVend		:= ""
    Local cLojaVend		:= ""
    Local cCodPa		:= ""
	Local lAchou		:= .F.
	Local nOpc			:= 3
	Local _cTipo	    := ""
	Local _cGRPTRIB	    := ""
	Local cEndVend      := ""
	Local aArea := GetArea()		// Salva a area
	Local aAreaSZ5  := SZ5->(GetArea())
	Local aAreaSA1  := SA1->(GetArea())
	Local aAreaSA2  := SA2->(GetArea())
	Local aAreaSA3  := SA3->(GetArea())
	Private aRotAuto 	:= Nil
	Private lMsErroAuto := .F.



	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Verifica se ja Existe no Cadastro de Vendedores     ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	DbSelectarea("SA3")
	SA3->(DbSetorder(3))
	If SA3->(DbSeek(xFilial("SA3") + SZ5->Z5_CGC))
		Aviso("Aviso",	"Vendedor " + ALLTRIM(SZ5->Z5_RAZASOC) + " CNPJ/CPF: " + SZ5->Z5_CGC + CRLF +;
						"Jแ estแ cadastrado como vendedor!" + CRLF +;
						"C๓digo / Loja: " + SA3->A3_COD + " / " + SA3->A3_LOJA + CRLF, {"Abandona"},3)
		Return
	Else
		cCodVend	 := GetSx8Num("SA3","A3_COD")
		cLojaVend := StrZero(1,TamSx3("A3_LOJA")[1])
	EndIf
	
	cEndVend := ALLTRIM(UPPER(SZ5->Z5_ENDEREC)) +", "+ UPPER(SZ5->Z5_ENDERNR) +" - "+ UPPER(SZ5->Z5_ENDCOMP)

	aValues	:= {	{"A3_COD"		,cCodVend  , Nil},;
		{"A3_NOME"		,UPPER(SZ5->Z5_RAZASOC), Nil},;
		{"A3_NREDUZ"	,UPPER(SZ5->Z5_NOMEABR), Nil},;
		{"A3_TIPO"  	,cTipoVend			   , Nil},;
		{"A3_CGC"		,SZ5->Z5_CGC		   , Nil},;
		{"A3_END"   	,cEndVend              , Nil},;
		{"A3_EST"   	,UPPER(SZ5->Z5_UF)     , Nil},;
		{"A3_MUN"   	,UPPER(SZ5->Z5_CIDADE) , Nil},;
		{"A3_INSCR"		,SZ5->Z5_INSCEST	   , Nil},;
		{"A3_CEP"		,SZ5->Z5_CEP		   , Nil},;
		{"A3_DDDTEL"	,SZ5->Z5_TELEFDD	   , Nil},;
		{"A3_TEL"		,SZ5->Z5_TELEFON	   , Nil},;
		{"A3_BAIRRO"	,UPPER(SZ5->Z5_BAIRRO) , Nil},;
		{"A3_FAX"		,SZ5->Z5_FAX		   , Nil},;
		{"A3_X_END"		,UPPER(SZ5->Z5_ENDPAG) , Nil},;
		{"A3_X_BAIRR"	,UPPER(SZ5->Z5_BAIRROP), Nil},;
		{"A3_X_CEP"		,SZ5->Z5_CEPPG		   , Nil},;
		{"A3_X_MUN"		,UPPER(SZ5->Z5_CIDADEP), Nil},;
		{"A3_X_EST"		,UPPER(SZ5->Z5_UFPG)   , Nil},;
		{"A3_EMAIL"		,SZ5->Z5_EMAIL		   , Nil},;
		{"A3_GERASE2"	,"S"                   , Nil},;
		{"A3_DDD"		,"F"                   , Nil},;
		{"A3_DIA"		,10                    , Nil},;
		{"A3_REGIAO"	,UPPER(SZ5->Z5_REGIAO) , Nil}}

	If Aviso("Aviso","Confirma Importa็ใo do Cliente para o cadastro de Vendedores?" + CRLF + CRLF +;
					 "Favor verificar os campos que devem ser preenchidos ap๓s a importa็ใo.",{"Sim","Nใo"}) == 2
		Return
	EndIf

	MSExecAuto({|x,y| MATA040(x,y)}, aValues, 3)
	If lMsErroAuto
		RollBackSX8()
		MostraErro()
	Else
		ConfirmSX8()
		If MsgYesNo("Deseja abrir tela de Cadastro?")
			AxAltera("SA3", SA3->(Recno()) ,3,/*aAcho*/,/*aCpos*/,/*nColMens*/,/*cMensagem*/,	/*IIF(!lAcativo, "MA030TudOk()", "MA030TudOk() .And. AC700ALTALU()")*/,/*cTransact*/,/*cFunc*/,aButtons,/*aParam*/,aRotAuto,/*lVirtual*/)
		EndIf
		MsgInfo("Vendedor " +cCodVend+ " loja " +cLojaVend+ " cadastrado com sucesso!","TOTVS")
		RecLock("SZ5",.F.)
			SZ5->Z5_PRCVEND	:= "S"
		MsUnlock()
	EndIf
RestArea(aArea)
SZ5->(RestArea(aAreaSZ5))
SA1->(RestArea(aAreaSA1))
SA2->(RestArea(aAreaSA2))
SA3->(RestArea(aAreaSA3))
Return




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ FILTROSZ5 บ Autor ณ Rogerio Machado    บ Data ณ  19/07/16   บฑฑ
ฑฑฬออออออออออุอออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Cadastro de Pre-Clientes (AVANT)                            บฑฑ
ฑฑบ          ณ                                                             บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Avant                                                       บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function FILTROSZ5()
	Local aPerg    		:= {}
	Local aIndArqu  	:= {}
	Local aFiltro		:= {"1-Processados","2-Nใo Processados","3-Todas"}
	Private cCondicao 	:= ""
	Private bFiltraBrow
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณDefine as Perguntas na Abertura do Browse ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	Aadd(aPerg,{2,"Filtro"		,"",aFiltro	,120,".T.",.T.,".T."})

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณChama tela de Parametros                  ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If ParamBox(aPerg,"",,,,,,,,"CADSZ5",.T.,.T.)

		cCondicao += " Z5_FILIAL == '"+xFilial("SZ5")+"' "

		If SubStr(MV_PAR01,1,1) == "1"
			cCondicao += " .AND. Alltrim(Z5_STATUS) == 'S' "
		ElseIf SubStr(MV_PAR01,1,1) == "2"
			cCondicao += " .AND. Alltrim(Z5_STATUS) == 'N' "
		EndIf

		bFiltraBrow := {|| FilBrowse("SZ5",@aIndArqu,@cCondicao) }
		Eval(bFiltraBrow)				

		MBrowse( 6, 1,22,75,"SZ5",,,,,,aCores) 
   EndIF

Return