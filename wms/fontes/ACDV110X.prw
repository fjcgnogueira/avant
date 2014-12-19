#INCLUDE "ACDV110.ch" 
#INCLUDE "APVT100.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ACDV110X  ºAutor  ³ Amedeo D. P. Filho º Data ³  18/04/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ O objetivo do programa e consultar etiquetas de cod. barrasº±±
±±º          ³ Customizacao do fonte padrao conforme definicoes e         º±±
±±º          ³ solicitacoes AVANT.                                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico AVANT.                                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function ACDV110X()
	Local cEtiq 	:= Space(64)
	Local aTela 	:= VTSave()
	Local nL    	:= VTRow()
	Local nC    	:= VTCol()
	Local aArea    	:= GetArea()
	Local aAreaSB1 	:= GetArea('SB1')
	Local aAreaSB2 	:= GetArea('SB2')
	Local aAreaSBE 	:= GetArea('SBE')
	Local aAreaSBF 	:= GetArea('SBF')
	Local aAreaCB2 	:= GetArea('CB2')
	Local aAreaCB6 	:= GetArea('CB6')
	Local aAreaCB9 	:= GetArea('CB9')
	Local aAreaSX3 	:= GetArea('SX3')
	Local lAtvCons 	:= GetNewPar("MV_ATVCONS","1") =="1"
	Local cCodOpe  	:= CBRetOpe()
	Local ckey03
	Local bkey03
	
	Private aHist  	:={}
	
	If MscbIsPrinter() .or. InTransaction() .or. !lAtvCons
		Return
	EndIf
	
	CBChkTemplate()
	
	If !Empty(cCodOpe) .AND. !(CB1->CB1_ATVCON $ " 1")
		Return
	Endif
	
	ckey03 := VTDescKey(03)
	bkey03 := VTSetKey(03)
	
	VtClearBuffer()
	
	While .T.
		aHist := {}
		VTClear()
		If VtModelo()== "RF"
			@ 0,0  VTSay STR0010 //"Consulta"
			@ 1,0  VTSay STR0001 //"Etiqueta"
			@ 2,0  VTGet cEtiq pict '@!' VALID InfoEtiq(cEtiq)
		Else
			@ 0,0 VTSay STR0010 //"Consulta"
			@ 1,0 VTGet cEtiq pict '@!' VALID InfoEtiq(cEtiq)
		EndIf

		VTRead

		If VTLastKey() == 27
			Exit
		EndIf
	Enddo
	
	VTRestore(,,,,aTela)
	@ nL,nC VtSay ""
	
	RestArea(aArea)
	RestArea(aAreaSB1)
	RestArea(aAreaSB2)
	RestArea(aAreaSBE)
	RestArea(aAreaSBF)
	RestArea(aAreaCB2)
	RestArea(aAreaCB6)
	RestArea(aAreaCB9)
	RestArea(aAreaSX3)
	
	VTSetKey(03,bkey03,ckey03)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³InfoEtiq  ºAutor  ³ Amedeo D. P. Filho º Data ³  18/04/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Esta funcao retorna as informacoes da etiqueta              º±±
±±º          ³Etiqueta:                                                   º±±
±±º          ³ - Produto                                                  º±±
±±º          ³ - Localizacao                                              º±±
±±º          ³ - Dispositivo                                              º±±
±±º          ³ - Volume                                                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ ACD                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function InfoEtiq(cEtiqueta)
	Local lRetorno	:= .T.
	Local lDescric	:= .F.
	Local cTipo
	Local aItensPallet
	
	If	Empty(cEtiqueta)
		MenuPrdEnd()
		VTKeyBoard(chr(20))
		aHist := {}  //Limpa array Dados Gerais
	 	Return .F.
	EndIf

	If !CBLoad128(@cEtiqueta)
		aHist := {}  //Limpa array Dados Gerais
		Return .F.
	EndIf

	cTipo := CBRetTipo(cEtiqueta)

	If cTipo == "EAN8OU13" .or. cTipo =="EAN14"
		lRetorno := MostraDes(cEtiqueta, @lDescric)
		If lRetorno
			Cons8OU13(cEtiqueta)
		EndIf
	ElseIf cTipo =="EAN128"
		lRetorno := MostraDes(cEtiqueta, @lDescric)
		If lRetorno
			Cons128(cEtiqueta)
		EndIf
	ElseIf cTipo=="01" //produto
		lRetorno := MostraDes(cEtiqueta, @lDescric)
		If lRetorno
			Cons01(cEtiqueta)
		EndIf
	Elseif cTipo=="02" //localizacao
		lRetorno := MostraDes(cEtiqueta, @lDescric)
		If lRetorno
			Cons02(cEtiqueta)
		EndIf
	Elseif cTipo=="03" //dispositivo
		lRetorno := MostraDes(cEtiqueta, @lDescric)
		If lRetorno
			Cons03(cEtiqueta)
		EndIf
	Elseif cTipo=="05" //volume
		lRetorno := MostraDes(cEtiqueta, @lDescric)
		If lRetorno
			Cons05(cEtiqueta)
		EndIf
	ElseIf !Empty(aItensPallet := CBItPallet(cEtiqueta))
		ConsPallet(aItensPallet,cEtiqueta)
		VTKeyBoard(chr(20)) //Limpa o get
	Else
		VtBeep(2)
		VtAlert(STR0008,STR0009,.T.,4000) //"Nao ha consulta para esta etiqueta."###"Aviso"
		VTKeyBoard(chr(20)) //Limpa o get
		aHist := {}  //Limpa array Dados Gerais	
		Return .F.
	EndIf
	
	aHist := {}  //Limpa array Dados Gerais

	If lDescric
		//Limpa o Get do Produto
		VTKeyBoard(chr(20))

		//Limpa o conteudo da descricao
		If VtModelo()== "RF"
			@ 3,0 VTSay Replicate( " ", VtmaxCol()+1 )
			@ 4,0 VTSay Replicate( " ", VtmaxCol()+1 )
			@ 5,0 VTSay Replicate( " ", VtmaxCol()+1 )
			@ 6,0 VTSay Replicate( " ", VtmaxCol()+1 )
		Else
			@ 2,0 VTSay Replicate( " ", VtmaxCol()+1 )
			@ 3,0 VTSay Replicate( " ", VtmaxCol()+1 )
			@ 4,0 VTSay Replicate( " ", VtmaxCol()+1 )
			@ 5,0 VTSay Replicate( " ", VtmaxCol()+1 )
		EndIf
	EndIf
	
Return .F.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Function MostraDes (Mostra Descricao antes de chamar a Exibicao dos dados)   	³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function MostraDes(cEtiqueta, lDescric)
	Local aEtiqueta := {}
	Local cDesPro0	:= ""
	Local cDesPro1	:= ""
	Local cDesPro2	:= ""
	Local lRetorno	:= .T.
	
	aEtiqueta := CBRetEtiEan(cEtiqueta)

	If Len(aEtiqueta) >= 1
		lDescric := .T.
		SB1->(DbSetOrder(1))
		SB1->(DbSeek(xFilial("SB1")+aEtiqueta[1]))
		cDesPro0 := SubStr(SB1->B1_DESC ,1 ,20)
		cDesPro1 := SubStr(SB1->B1_DESC ,21,20)
		cDesPro2 := SubStr(SB1->B1_DESC ,41,20)

		If VtModelo()== "RF"
			@ 3,0  VTSay "Descricao"
			@ 4,0 VTGet cDesPro0 pict '@!'
			@ 5,0 VTSay cDesPro1
			@ 6,0 VTSay cDesPro2
		Else
			@ 2,0 VTSay "Descricao"
			@ 3,0 VTGet cDesPro0 pict '@!'
			@ 4,0 VTSay cDesPro1
			@ 5,0 VTSay cDesPro2
		EndIf
		VTRead

		If VTLastKey() == 27
			lRetorno := .F.
		EndIf
	Else
		lRetorno := .F.
	EndIf

Return lRetorno

Static Function MenuPrdEnd()

	Local aTela 	:= VTSave()
	Local nPos		:= 1
	
	Private cProd 	:= Space(15)
	private cArm  	:= Space(02)
	Private cEnd 	:= Space(15)

	Private M->CBA_LOCAL 	:= cArm  // utilizado na consulta de endereco

	If GetMv("MV_LOCALIZ") == "S"
		If VTModelo()=="RF"
			@ 4,0 VTSay Repli("-",20)
			nPos:=VTAchoice(5,0,7,VtmaxCol(),{STR0002,STR0011,STR0012}) //"Produto"###"Armazem"###"Endereco"
		Else
			nPos:=VTAchoice(0,0,VtMaxRow(),VtmaxCol(),{STR0002,STR0011,STR0012}) //"Produto"###"Armazem"###"Endereco"		
		EndIf
	EndIf

	VTRestore(,,,,aTela)
	VtClearBuffer()
	If nPos ==0
		Return
	EndIf

	If VTModelo()=="RF"
		If nPos == 1
			@ 5,0  VTSay STR0013 //'Produto'
			@ 6,0  VTGet cProd pict '@!' VALID VldProd(cProd) F3 "SB1"
		ElseIf nPos == 2
			@ 5,0  VTSay STR0014 //'Armazem'
			@ 6,0  VTGet cArm pict "@!" Valid VldArm(cArm,"A") 
		ElseIf nPos == 3
			@ 5,0  VTSay STR0015 //'Endereco'
			@ 6,0  VTGet cArm pict "@!" Valid VldArm(cArm,"E")
			@ 6,4  VTSay "-" VTGet cEnd pict '@!' VALID VldEnd(cArm,cEnd) F3 "CBA"
		EndIf
		VTRead
	Else
		IF nPos == 1
			@ 0,0  VTSay STR0037 //'Produto '
			@ 1,0  VTGet cProd pict '@!' VALID VldProd(cProd) F3 "SB1"
		ElseIf nPos == 2
			@ 0,0  VTSay STR0014 //'Armazem'
			@ 1,0  VTGet cArm pict "@!" Valid VldArm(cArm,"A") 
		ElseIf nPos == 3
			@ 0,0  VTSay STR0015 //'Endereco'
			@ 1,0  VTGet cArm pict "@!" Valid VldArm(cArm,"E")
			@ 1,4  VTSay "-" VTGet cEnd pict '@!' VALID VldEnd(cArm,cEnd) F3 "CBA"
		EndIf
		VTRead
	EndIf
	vtRestore(,,,,aTela)
	VTKeyBoard(chr(20)) //Limpa o get
Return .F.

Static Function VldProd(cProd)

	If Empty(cProd)
		VtKeyBoard(chr(23))
		Return .F.
	EndIf

	SB1->(DbSetOrder(1))
	If !SB1->(DbSeek(xFilial("SB1")+cProd))
		VTBEEP(2)
		VTALERT(STR0016,STR0009,.T.,4000)    //"Produto nao encontrado"###"AVISO"
		VTClearGet()
		Return .f.
	EndIf
	aHist :={	{STR0017,cProd},; //"Codigo"
				{STR0003,SB1->B1_DESC},; //"Descricao"
				{STR0018,SB1->B1_UM}} //"U.M."
	MenuProdc(cProd)

Return

Static Function VldArm(cArm,cTipo)
	Local aTela
	Local aFields
	Local aHeader
	
	If Empty(cArm)
		Return .T.
	EndIf
	SBE->(DbSetOrder(1))
	If ! SBE->(DbSeek(xFilial("SBE")+cArm))
		VTBeep(3)
		VTAlert(STR0019,STR0020,.t.,4000) //'Armazem nao existe'###'Aviso'
		VTKeyBoard(chr(20))
		Return .F.
	EndIf
	M->CBA_LOCAL := cArm  // variavel criada para filtrar a consulta

	If cTipo == "A"
		SBE->(DbSetOrder(1))
		If ! SBE->(DbSeek(xFilial("SBE")+cArm))
			VTBeep(3)
			VTAlert(STR0019,STR0020,.t.,4000) //'Armazem nao existe'###'Aviso'
			VTKeyBoard(chr(20))
			Return .F.
		EndIf
	
		DbSelectArea("SB2")
		SB2->(DbOrderNickName("ACDSB201"))
		SB2->(DbSeek(xFilial("SB2")+cArm+Str(0.01,12,2),.t.))
		If SB2->(Eof()) .Or. cArm # SB2->B2_LOCAL
			VTBeep(3)
			VTAlert(STR0034,STR0009,.t.,4000)  //"Nao existe produto a enderecar neste armazem"###"Aviso"
			VTKeyBoard(chr(20))
			Return .F.
		EndIf
		cToPCB8 	:= SB2->(xFilial("SB2")+B2_LOCAL+STR(B2_QACLASS,12,2))
		cBottomCb8 	:= SB2->(xFilial("SB2")+B2_LOCAL+REPL("9",12))  
	
		aFields 	:= {	{|| SB2->B2_COD},;
							{|| Posicione("SB1",1,xFilial("SB1")+SB2->B2_COD,"B1_DESC")},;
							{|| Transform(B2_QACLASS,CBPictQtde())} }

		aHeader 	:= {'COD',STR0035,STR0036}        //'Descricao     '###'A Classificar'
	
		aTela   	:= VtSave()
		VTClear()
		VtClearBuffer()
	
		VTDbBrowse(0,0,7,19,"SB2",aHeader,aFields,{15,20,15},,"'"+cToPCB8+"'","'"+cBottomCb8+"'")
		VTRestore(,,,,aTela)
		Return .T.
	EndIf

Return .T.

Static Function VldEnd(cArmazem,cEndereco)
	
	VTClearBuffer()
	If Empty(cEndereco)
		VtKeyBoard(chr(23))
		Return .T.
	EndIf

	SBE->(DbSetOrder(1))
	If ! SBE->(DbSeek(xFilial("SBE")+cArmazem+cEndereco))
		VTBEEP(2)
		VTALERT(STR0022,STR0009,.T.,4000)    //"Endereco nao encontrado"###"AVISO"
		VTClearGet()
		VTClearGet("cArm")
		VTGetSetFocus("cArm")
		Return .F.
	EndIf
	Cons02(NIL,cArmazem,cEndereco)

Return


Static Function Cons8OU13(cEtiqueta)

	Local aEtiqueta := {}

	aEtiqueta := CBRetEtiEan(cEtiqueta)

	If Len(aEtiqueta) >= 1
		aadd(aHist,{STR0002,aEtiqueta[1]}) //"Produto"
		SB1->(DbSetOrder(1))
		SB1->(DbSeek(xFilial("SB1")+aEtiqueta[1]))
		aadd(aHist,{STR0003,Left(SB1->B1_DESC,20)}) //"Descricao"
		aadd(aHist,{"U.M.",SB1->B1_UM}) 
		aadd(aHist,{"2 U.M.",SB1->B1_SEGUM}) 
		aadd(aHist,{STR0038,SB1->B1_CONV})  //"Fator Conv."
	EndIf
	
	If Len(aEtiqueta) >= 2
		aadd(aHist,{STR0004,Str(aEtiqueta[2],6)}) //"Quantidade"
	EndIf
	
	Aadd(aHist,{STR0023,cEtiqueta}) //"Codigo Barras"

	If Empty(aEtiqueta)
		DadosGerais()
	Else
		MenuProdc(aEtiqueta[1])
	EndIf

Return .F.


Static Function Cons128(cEtiqueta)
	Local nX
	Local aEtiqueta  := {}
	Local aEtiqueta2 := {}

	aEtiqueta := CBRetEtiEan(cEtiqueta)
	
	If Len(aEtiqueta) >= 1
		aadd(aHist,{STR0002,aEtiqueta[1]}) //"Produto"
		SB1->(DbSetOrder(1))
		SB1->(DbSeek(xFilial("SB1")+aEtiqueta[1]))
		aadd(aHist,{STR0003,Left(SB1->B1_DESC,20)}) //"Descricao"
		aadd(aHist,{STR0018,SB1->B1_UM})  //"U.M."
		aadd(aHist,{STR0039,SB1->B1_SEGUM})  //"2 U.M."
		aadd(aHist,{STR0038,SB1->B1_CONV})  //"Fator Conv."
	EndIf
	If Len(aEtiqueta) >= 2
		aadd(aHist,{STR0004,Str(aEtiqueta[2],6)}) //"Quantidade"
		aadd(aHist,{"---------------","---------------"})
	EndIf
	
	aEtiqueta2 := CBAnalisa128(cEtiqueta)
	If len(aEtiqueta2) > 0
		For nx:= 1 to Len(aEtiqueta2)
			aadd(aHist,{aEtiqueta2[nx,1]+'-'+aEtiqueta2[nx,3],aEtiqueta2[nx,2]})
		Next
	EndIf
	If Empty(aEtiqueta) .And. ! Empty(aEtiqueta2)
		DadosGerais()
	ElseIf ! Empty(aEtiqueta)
		MenuProdc(aEtiqueta[1])
	EndIf

Return .F.

Static Function ConsPallet(aItens,cEtiqueta)
	Local nx
	Local aEtiqueta
	Local aHist:={}
	Local aSize
	Local aCab
	Local aTela
	Local nPos
	Local nTot:=0
	If UsaCb0("01")
		For nx:= 1 to Len(aItens)
			aEtiqueta:= CBRetEti(aItens[nx])
			aadd(aHist,{CB0->CB0_CODETI,CB0->CB0_CODPRO,Transform(CB0->CB0_QTDE,"@E 999,999,999.999"),CB0->CB0_LOTE,CB0->CB0_SLOTE})
			nTot+=CB0->CB0_QTDE
		Next
		aSize := {15,15,15,15,15}
		aCab  := {STR0001,STR0002,STR0004,STR0025,STR0026} //"Etiqueta"###"Produto"###"Quantidade"###"Lote"###"SubLote" 
		aTela := VTSave()
		While .t.
			VTClear()
			@ 0,0 VTSay STR0040+CB0->CB0_PALLET //"Pallet "
			@ 1,0 VTSay STR0041+Transform(nTot,"@E 9,999,999.999") //"Total:"
			nPos := VTaBrowse(2,0,VTMaxRow(),VtmaxCol(),aCab,aHist,aSize)
		
			If VtLastkey() == 27
				Exit
			EndIf
			Cons01(aHist[nPos,1])
		
		End
		VtRestore(,,,,aTela)
	Else
	
		For nx:= 1 to Len(aItens)
			aEtiqueta:= CBRetEtiEan(aItens[nx])
			aadd(aHist,aClone(aEtiqueta))
		Next
		aSize := {15,15,15,10,15}
		aCab  := {STR0002,STR0004,STR0025,"Dt.Valid","Serie"} //"Produto"###"Quantidade"###"Lote"###"SubLote" 
		aTela := VTSave()
		While .t.
			VTClear()
			@ 0,0 VTSay STR0040+cEtiqueta //"Pallet "
			@ 1,0 VTSay STR0041+Transform(len(aItens),"@E 9,999,999.999") //"Total:"
			nPos := VTaBrowse(2,0,VTMaxRow(),VtmaxCol(),aCab,aHist,aSize)
		
			If VtLastkey() == 27
				Exit
			EndIf
			VldProd(aHist[nPos,1])
		
		End
		VtRestore(,,,,aTela)
	
	EndIf	
	
Return .F.

Static Function Cons01(cEtiqueta)
	Local nY
	Local aEtiqueta	:= {}
	Local cAlias 	:= "CB0"
	
	aEtiqueta := CBRetEti(cEtiqueta,"01",.T.,.T.)
	
	dbSelectArea("SX3")
	dbSetOrder(1)
	dbSeek(cAlias)
	While !EOF() .And. (x3_arquivo == cAlias)
		If X3USO(x3_usado) .AND. cNivel >= x3_nivel .and. x3_visual<>"V"
			nY := &(cAlias)->(FieldPos(SX3->X3_CAMPO))
			If ! Empty(&(cAlias)->(FieldGet(nY)))
				If Valtype(&(cAlias)->(FieldGet(nY))) == "C"
					If ! Empty(SX3->X3_CBOX)
					aadd(aHist,{X3Titulo(),X3Combo(SX3->X3_CAMPO ,&(cAlias)->(FieldGet(nY)))})
					Else
						aadd(aHist,{X3Titulo(),&(cAlias)->(FieldGet(nY))})
					EndIf
				ElseIf	Valtype(&(cAlias)->(FieldGet(nY))) == "N"
					aadd(aHist,{X3Titulo(),Alltrim(Str(&(cAlias)->(FieldGet(nY))))})
				ElseIf	Valtype(&(cAlias)->(FieldGet(nY))) == "D"
					aadd(aHist,{X3Titulo(),Alltrim(Dtoc(&(cAlias)->(FieldGet(nY))))})
				EndIf
			EndIf
		EndIf
		dbSkip()
	End
	
	dbSelectArea(cAlias)
	If Empty(aEtiqueta)
		DadosGerais()
	Else
		SB1->(DbSetOrder(1))
		SB1->(DbSeek(xFilial("SB1")+aEtiqueta[1]))
		aadd(aHist,{Repl("-",20),Repl("-",20)})
		aadd(aHist,{STR0003,Left(SB1->B1_DESC,20)}) //"Descricao"
		aadd(aHist,{STR0018,SB1->B1_UM})  //"U.M."
		aadd(aHist,{STR0039,SB1->B1_SEGUM})  //"2 U.M."
		aadd(aHist,{STR0038,SB1->B1_CONV})  //"Fator conv."
		MenuProdc(aEtiqueta[1])
	EndIf 

	aHist := {}

Return .F.

Static Function Cons02(cEtiqueta,cArmazem,cEndereco)
	Local aSize     := {}
	Local aCab      := {}
	Local aTamCpo   := {}
	Local aEtiqueta := {}
	Local cQuery	:= ""
	Local cWhere	:= ""
	Local lA110FEND := ExistBlock("A110FEND")
	Local aTela
	
	If cEtiqueta <>NIL
		aEtiqueta := CBRetEti(cEtiqueta,"02")
		If Empty(aEtiqueta)
			VTBEEP(2)
			VTALERT(STR0024,STR0009,.T.,4000)  //"Etiqueta Invalida"###"Aviso"
			VTKeyBoard(chr(20)) //Limpa o get
			Return .F.
		EndIf
		cArmazem  := aEtiqueta[02]
		cEndereco := aEtiqueta[01]
	EndIf
	
	#IFDEF TOP //Saldo por localizacao
		cAlias := GetNextAlias()
		cQuery := "SELECT SBF.BF_PRODUTO,SB1.B1_DESC,SBF.BF_QUANT,SBF.BF_LOTECTL,SBF.BF_NUMLOTE,SBF.BF_EMPENHO "
		cQuery += "FROM "+RetSqlName("SBF")+" SBF, "+RetSqlName("SB1")+" SB1 "
		cQuery += "WHERE SBF.BF_FILIAL ='"+xFilial("SBF")+"' "
		cQuery += "AND SBF.BF_LOCAL ='"+cArmazem+"' "
		cQuery += "AND SBF.BF_LOCALIZ ='"+cEndereco+"' "
		//cQuery += "AND SBF.BF_FILIAL = SB1.B1_FILIAL "
		cQuery += "AND SBF.BF_PRODUTO = SB1.B1_COD "
		cQuery += "AND SBF.D_E_L_E_T_ <> '*' "
		cQuery += "AND SB1.D_E_L_E_T_ <> '*' "
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ A110FEND - Ponto de Entrada para filtro da consulta de etiquetas por endereço ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If lA110FEND
			cWhere := ExecBlock("A110FEND",.F.,.F.,{cQuery})
			If ValType(cWhere) == "C" .And. Len(cWhere) > 1
				cQuery += " AND "+ cWhere + " "
			EndIf
		EndIf
		
		cQuery    := ChangeQuery(cQuery)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)
	
		aTamCpo := TamSX3("BF_QUANT")
		While !(cAlias)->(Eof())
			Aadd(aHist,{(cAlias)->BF_PRODUTO,Left((cAlias)->B1_DESC,20),Str((cAlias)->BF_QUANT,aTamCpo[1],aTamCpo[2]),(cAlias)->BF_LOTECTL,(cAlias)->BF_NUMLOTE,Transform((cAlias)->BF_EMPENHO,"@E 999,999,999.999") })
			(cAlias)->(DbSkip())
		EndDo
		(cAlias)->(DbCloseArea())
	#ELSE
		dbSelectarea("SBF")  //Saldo por localizacao
		SBF->(dbSetOrder(1))
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ A110FEND - Ponto de Entrada para filtro da consulta de etiquetas por endereço ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If lA110FEND
			cWhere := ExecBlock("A110FEND",.F.,.F.,{cQuery})
			If ValType(cWhere) == "C" .And. Len(cWhere) > 1
				Set Filter To &(cWhere)
			EndIf
		EndIf
		
		If SBF->(dbSeek(xFilial("SBF")+cArmazem+cEndereco))
			aTamCpo := TamSX3("BF_QUANT")
			While ! SBF->(Eof()) .And. xFilial("SBF") == SBF->BF_FILIAL .And. SBF->BF_LOCAL == cArmazem .And. SBF->BF_LOCALIZ == cEndereco
				SB1->(DbSetOrder(1))
				SB1->(DbSeek(xFilial("SB1")+SBF->BF_PRODUTO))
				Aadd(aHist,{SBF->BF_PRODUTO,Left(SB1->B1_DESC,20),Str(SBF->BF_QUANT,aTamCpo[1],aTamCpo[2]),SBF->BF_LOTECTL,SBF->BF_NUMLOTE,Transform(SBF->BF_EMPENHO,"@E 999,999,999.999") })
				SBF->(dbSkip())
			EndDo
		EndIf
		
		If lA110FEND
			Set Filter To
		EndIf
	#ENDIF
	
	If !Empty(aHist)
		aTela := VTSave()
		VTClear()
		aSize := {15,20,12,15,15,15}
		aCab  := {STR0002,STR0003,STR0004,STR0025,STR0026,STR0033} //"Produto"###"Descricao"###"Quantidade" //"Lote"###"SubLote" //"Empenho"
		If VTModelo()=="RF"
			@0,0 VTSay cArmazem+'-'+cEndereco
			VTaBrowse(1,0,VTMaxRow(),VtmaxCol(),aCab,aHist,aSize)
		Else
			VTaBrowse(0,0,VTMaxRow(),VtmaxCol(),aCab,aHist,aSize)
		EndIf
		vtRestore(,,,,aTela)
		VtClearBuffer()
	Else
		VTBeep()
		VTAlert(STR0027,STR0020,.t.,4000) //'Endereco Vazio'###'Aviso'
	EndIf
	VTKeyBoard(chr(20))

Return .F.

Static Function Cons03(cEtiqueta)
	Local aSize     := {}
	Local aCab      := {}
	Local aTamCpo   := {}
	Local aEtiqueta := {}
	Local nPos      := 0
	Local aTela
	
	aEtiqueta := CBRetEti(cEtiqueta,"03")
	
	dbSelectArea("CB2") //Dispositivo
	If CB2->(dbSeek(xFilial("CB2")+aEtiqueta[1]))
		If	CB2->CB2_STATUS == "3" .or. CB2->CB2_STATUS == "7" //Embalagem ou Embarque
			dbSelectArea("CB6") //Volumes de Embalagem
			CB6->(dbSetOrder(3))
			If CB6->(dbSeek(xFilial("CB6")+aEtiqueta[1]))
				While ! CB6->(Eof()) .and. xFilial("CB6") == CB6->CB6_FILIAL .and. CB6->CB6_DISPID == aEtiqueta[1]
					aadd(aHist,{CB6->CB6_VOLUME,CB6->CB6_PEDIDO,X3Combo("CB6_STATUS",CB6->CB6_STATUS)})
					CB6->(dbSkip())
				EndDo
			EndIf
			If !Empty(aHist)
				aTela := VTSave()
				VTClear()
				aSize := {10,06,15}
				aCab  := {STR0005,STR0006,STR0007} //"Volume"###"Pedido"###"Status"
				VTaBrowse(0,0,VTMaxRow(),VtmaxCol(),aCab,aHist,aSize)
				vtRestore(,,,,aTela)
				VtClearBuffer()
			EndIf
		ElseIf CB2->CB2_STATUS == "2" //Em separacao
			dbSelectArea("CB9")  //Produtos separados
			CB9->(dbSetOrder(1))
			If CB9->(dbSeek(xFilial("CB9")+CB2->CB2_ORDSEP))
				aTamCpo := TamSX3("CB9_QTESEP")
				While ! CB9->(Eof()) .and. xFilial("CB9") == CB9->CB9_FILIAL .and. CB9->CB9_ORDSEP == CB2->CB2_ORDSEP
					nPos := aScan(aHist,{|x| x[1] == CB9->CB9_PROD})
					If nPos # 0
						aHist[nPos,3] := Str((Val(aHist[nPos,3]) + CB9->CB9_QTESEP),aTamCpo[1],aTamCpo[2])
					Else
						SB1->(DbSetOrder(1))
						SB1->(DbSeek(xFilial("SB1")+CB9->CB9_PROD))
						Aadd(aHist,{CB9->CB9_PROD,Left(SB1->B1_DESC,20),Str(CB9->CB9_QTESEP,aTamCpo[1],aTamCpo[2])})
					EndIf
					CB9->(dbSkip())
				EndDo
			EndIf
			If !Empty(aHist)
				aTela := VTSave()
				VTClear()
				aSize := {15,20,12}
				aCab  := {STR0002,STR0003,STR0004} //"Produto"###"Descricao"###"Quantidade"
				VTaBrowse(0,0,VTMaxRow(),VtmaxCol(),aCab,aHist,aSize)
				vtRestore(,,,,aTela)
				VtClearBuffer()
			EndIf
		EndIf
	EndIf
	VTKeyBoard(chr(20)) //Limpa o get

Return .F.

Static Function Cons05(cEtiqueta)
	Local aSize     := {} 
	Local aCab      := {}
	Local aTamCpo   := {}
	Local aEtiqueta := {}
	Local aTela
	
	aEtiqueta := CBRetEti(cEtiqueta,"05")
	
	dbSelectArea("CB9")  //Produtos separados
	CB9->(dbSetOrder(4))
	If CB9->(dbSeek(xFilial("CB9")+aEtiqueta[1]))
		aTamCpo := TamSX3("CB9_QTESEP")
		While ! CB9->(Eof()) .and. xFilial("CB9") == CB9->CB9_FILIAL .and. CB9->CB9_VOLUME == aEtiqueta[1]
	
			nPos := aScan(aHist,{|x| x[1] == CB9->CB9_PROD})
			If nPos # 0
				aHist[nPos,3] := Str((Val(aHist[nPos,3]) + CB9->CB9_QTESEP),aTamCpo[1],aTamCpo[2])
			Else
				SB1->(DbSetOrder(1))
				SB1->(DbSeek(xFilial("CB9")+CB9->CB9_PROD))
				Aadd(aHist,{CB9->CB9_PROD,Left(SB1->B1_DESC,20),Str(CB9->CB9_QTESEP,aTamCpo[1],aTamCpo[2])})
			EndIf
			CB9->(dbSkip())
		EndDo
	EndIf
	If !Empty(aHist)
		aTela := VTSave()
		VTClear()
	
		aSize := {15,20,12}
		aCab  := {STR0002,STR0003,STR0004} //"Produto"###"Descricao"###"Quantidade"
		VTaBrowse(0,0,VTMaxRow(),VtmaxCol(),aCab,aHist,aSize)
		vtRestore(,,,,aTela)
		VtClearBuffer()
	EndIf
	
	VTKeyBoard(chr(20)) //Limpa o get

Return .F.

Static Function MenuProdC(cProduto)
	Local aDados 	:= {}
	Local nTot		:= 0
	Local nTotEmp	:= 0
	Local nPosPonto	:= 0
	Local nPosAux 	:= 0
	Local nPos
	Local aTela
	
	aadd(aDados,{STR0028,"",""}) //"Dados Gerais"
	SB2->(DbSetorder(1))
	SB2->(DbSeek(xFilial("SB2")+cProduto))
	While SB2->(! Eof() .and. B2_FILIAL+B2_COD == xFilial("SB2")+cProduto)
		aadd(aDados,{STR0029+SB2->B2_LOCAL,Transform(SB2->B2_QATU,"@E 999,999,999.999"),Transform(SB2->B2_QEMP,"@E 999,999,999.999"),SB2->B2_QACLASS}) //"Armazem "
		If SB2->B2_LOCAL == GetMv("MV_CQ")
			aDados[Len(aDados),1] :=aDados[Len(aDados),1]+STR0042 //" (C.Q.)"
		EndIf
		nTot += SB2->B2_QATU
		nTotEmp += SB2->B2_QEMP
		SB2->(DbSkip())
	EndDo
	If ExistBlock('ACDV110C')
		nPosAux   := Len(aDados)
		aDados    := aClone(ExecBlock('ACDV110C',,,{1,aDados}))
		nPosPonto := Len(aDados)
	EndIf
	aadd(aDados,{Replicate("-",18),Replicate("-",15),Replicate("-",15)})
	aadd(aDados,{STR0030,Transform(nTot,"@E 999,999,999.999"),Transform(nTotEmp,"@E 999,999,999.999")}) //"Total"
	
	aTela := VTSave()
	While .t.
		VTClear()
		nPos:=VTaBrowse(0,0,VTMaxRow(),VtmaxCol(),{STR0003,STR0004,STR0033},aDados,{18,15,15}) //"Descricao"###"Quantidade" //"Empenho"
		VtClearBuffer()
		VTKeyBoard(chr(20)) //Limpa o get
		If nPos == 0
			Exit
		ElseIf nPos == 1
			DadosGerais()
		ElseIf ExistBlock('ACDV110C') .And. nPosPonto == nPos .And. nPosPonto # nPosAux
			ExecBlock('ACDV110C',,,{2,cProduto})
		ElseIf (nPos < (Len(aDados)-1))
			If GetMv("MV_LOCALIZ") == "S"
				MostraEnd(Substr(aDados[nPos,1],9,2),aDados[nPos,4],cProduto)
			EndIf
		EndIf
	Enddo
	vtRestore(,,,,aTela)

Return .F.

Static Function DadosGerais()
	Local nPos	:= 0
	Local aTela
	Local aHistAux
	
	If Len(aHist) > 0
		If	ExistBlock("ACDV110D")
			aHistAux := aClone(aHist)
			aHist    := ExecBlock('ACDV110D',.F.,.F.,{aHist})
			If ValType(aHist) <> 'A' .OR. Len(aHist) == 0
				aHist := aClone(aHistAux)
			Endif
		Endif
		aTela := VTSave()
		VTClear()
		nPos := VTaBrowse(0,0,VTMaxRow(),VtmaxCol(),{STR0003,STR0031},aHist,{15,15}) //"Descricao"###"Conteudo "
		vtRestore(,,,,aTela)
		VtClearBuffer()
	EndIf

	VTKeyBoard(chr(20)) //Limpa o get

Return .F.

Static Function MostraEnd(cArmazem,nQtdeDistr,cProd)
	Local aDados 	:= {}
	Local nTot		:= 0
	Local nQtd		:= 0
	Local nEmpenho	:= 0
	Local aTitulo	:= {}
	Local aTela
	Local cEndereco
	Local cLoteCtl
	Local cNumLote
	Local nPos

	SBF->(DbSetorder(2))
	SBF->(DbSeek(xFilial("SBF")+cProd+cArmazem))
	aadd(aDados,{STR0032,Transform(nQtdeDistr,"@E 999,999,999.999"),"","",""}) //"A enderecar"
	nTot += nQtdeDistr

	While SBF->(! Eof() .and. BF_FILIAL+BF_PRODUTO+BF_LOCAL == xFilial("SBF")+cProd+cArmazem)
		nQtd:=0
		nEmpenho:=0
		cEndereco:= SBF->BF_LOCALIZ
		cLoteCtl := SBF->BF_LOTECTL
		cNumLote := SBF->BF_NUMLOTE	
		While SBF->(! Eof() .and. BF_FILIAL+BF_PRODUTO+BF_LOCAL == xFilial("SBF")+cProd+cArmazem) .and. cEndereco+cLoteCtl+cNumLote == SBF->BF_LOCALIZ+SBF->BF_LOTECTL+SBF->BF_NUMLOTE
			nQtd    := nQtd+SBF->BF_QUANT
			nEmpenho:= nEmpenho+SBF->BF_EMPENHO
			SBF->(DbSkip())
		Enddo
		aadd(aDados,{cEndereco,Transform(nQtd,"@E 999,999,999.999"),cLoteCtl,cNumLote,Transform(nEmpenho,"@E 999,999,999.999")})
		nTot += nQtd
	EndDo
	aTitulo:={STR0003,STR0004,STR0025,STR0026,STR0033} //"Descricao"###"Quantidade"###"Lote"###"SubLote" //"Empenho"
	
	aadd(aDados,{Replicate("-",15),Replicate("-",15),Replicate("-",15),Replicate("-",15),Replicate("-",15)})
	aadd(aDados,{STR0030,Transform(nTot,"@E 999,999,999.999"),"","",""}) //"Total"
	aTela := VTSave()
	VTClear()
	nPos:=VTaBrowse(0,0,VTMaxRow(),VtmaxCol(),aTitulo,aDados,{15,15,15,15,15})
	vtRestore(,,,,aTela)
	VtClearBuffer()

Return .F.