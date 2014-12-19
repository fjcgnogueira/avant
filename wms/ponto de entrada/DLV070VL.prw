#INCLUDE "PROTHEUS.CH"
#INCLUDE 'APVT100.CH'
#INCLUDE 'INKEY.CH'
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ DLV070VL º Autor ³ Fernando Nogueira  º Data ³ 08/03/2014  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ P.E. na Digitacao do Produto na Conferencia.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Avant                                           º±±
±±º          ³ Chamado 000975                                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function DLV070VL()

Local aRetorno	:= Array(04)
Local cProduto := PARAMIXB[1]
Local aPrdSys  := PARAMIXB[2]
Local lDigita	:= PARAMIXB[3]
Local nMax     := VTMaxCol()
Local lRet     := .T.
Local cTipId	:= ""
Local cDescPro := ""
Local aProduto := {}
Local _cLoteCt := ""

Public __aProdAtu	:= {}

//-- Formato do vetor __aProdAtu
//-- [01] = Produto
//-- [02] = Lote
//-- [03] = Quantidade registrada pelo sistema
//-- [04] = Quantidade informada pelo operador
//-- [05] = Vetor unidimensional contendo os registros do arquivo SDB
//-- [06] = Finalizou a Conferencia

ConOut("Ponto de Entrada  : DLV070VL")

If	!lDigita
	cTipId := CBRetTipo(cProduto)
	If	cTipId $ "EAN8OU13-EAN14-EAN128"
		//CBRetEtiEAN= Produto, Qtde, Lote, Validade, Serie
		aProduto := CBRetEtiEAN(cProduto)
		If	Len(aProduto) > 0
			cProduto := aProduto[1]
			nQtde    := 0 //-- Se nQtde = 0, solicita digitacao
			cLoteCtl := Padr(aProduto[3],Len(SDB->DB_LOTECTL))
			If	ExistBlock("CBRETEAN")
				nQtde := aProduto[2]
			EndIf
		EndIf
	Else
		aProduto := CBRetEti(cProduto,'01')
		If	Len(aProduto)>0
			cProduto := aProduto[1]
			nQtde    := aProduto[2]
			cLoteCtl := Padr(aProduto[16],Len(SDB->DB_LOTECTL))
		EndIf
	EndIf
	If	Empty(aProduto)
		DLVTAviso('WMSV07006','Etiqueta invalida!')
		VTKeyBoard(chr(20))
		lRet := .F.
	EndIf
EndIf

If	lRet
	SB1->(DbSetOrder(1))
	If	!SB1->(MsSeek(xFilial('SB1')+cProduto))
		DLVTAviso('WMSV07007','O produto '+AllTrim(cProduto)+' nao esta cadastrado!')
		VTKeyBoard(chr(20))
		lRet := .F.
	EndIf
	// Traz na tela o lote do produto sendo conferido - Fernando Nogueira
	For _nI := 1 to Len(aPrdSys)
		If AllTrim(aPrdSys[_nI][1]) == AllTrim(cProduto) .And. aPrdSys[_nI][3] > aPrdSys[_nI][4]
			_cLoteCt := AllTrim(aPrdSys[_nI][2])
			Exit
		ElseIf AllTrim(aPrdSys[_nI][1]) == AllTrim(cProduto)
			_cLoteCt := "Conferido"			
		Endif
	Next _nI
	If Empty(_cLoteCt)
		_cLoteCt := "Sem Lote"
	Endif
	@ 01,00 VTSay PadR("Prd - Lt: "+_cLoteCt,VTMaxCol())
	// Mostrar a descricao do produto - Fernando Nogueira - Chamado 001036
	@ 03,00 VTSay PadR(SB1->B1_DESC,VTMaxCol())
EndIf

If	lRet
	If	aSCan(aPrdSYS,{|x|x[1]==cProduto})==0
		DLVTAviso('WMSV07008','O produto '+AllTrim(cProduto)+' nao consta '+Iif(WmsCarga(SDB->DB_CARGA),'na carga','no documento'))
		VTKeyBoard(chr(20))
		lRet := .F.
	EndIf
EndIf

If lRet
	__aProdAtu := aPrdSys
	For _n := 1 To Len(aPrdSys) //.And. Len(__aProdAtu[_n]) <= 5
		aadd( __aProdAtu[_n],.F.)
	Next _n

	/*If Mod(__aProdAtu[aSCan(__aProdAtu,{|x|x[1]==cProduto})][3], SB1->B1_CONV) > 0 .And. __aProdAtu[aSCan(__aProdAtu,{|x|x[1]==cProduto})][4] == 0
		VTALERT("Nao usar a unid. "+AllTrim(SB1->B1_SEGUM),"AVISO",.T.,4000)
	EndIf*/
Endif

If	lRet
	//-- Divide Descr. do produto em 3 linhas
	cDescPro := SubStr(SB1->B1_DESC,       1,nMax)
	cDescPr2 := SubStr(SB1->B1_DESC,  nMax+1,nMax)
	cDescPr3 := SubStr(SB1->B1_DESC,2*nMax+1,nMax)
	VtGetRefresh("cProduto")
	VtGetRefresh("cDescPro")
	VtGetRefresh("cDescPr2")
	VtGetRefresh("cDescPr3")
EndIf

aRetorno[1] := lRet
aRetorno[2] := cProduto
aRetorno[3] := cDescPro
aRetorno[4] := aPrdSys

Return aRetorno