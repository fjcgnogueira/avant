#Include "topconn.ch"
#include "protheus.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ BIEXTGRV º Autor ³ Ewerson Silva      º Data ³ 05/02/2016  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ P.E. para adicionar informacao aos campos livres do BI.    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico AVANT                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function BIEXTGRV()

Local cAlias := PARAMIXB[1] // Alias da Fato ou Dimensao em gravação no momento
Local aRet    := PARAMIXB[2] // Array contendo os dados do registro para manipulacao
Local lIsDim  := PARAMIXB[3] // Variavel que indica quando estah gravando em uma Dimensao (.T.) ou Fato (.F.)

Local nPLivre0 := aScan(aRet, {|x| AllTrim(x[1]) == cAlias + "_LIVRE0"})
Local nPLivre1 := aScan(aRet, {|x| AllTrim(x[1]) == cAlias + "_LIVRE1"})
Local nPLivre2 := aScan(aRet, {|x| AllTrim(x[1]) == cAlias + "_LIVRE2"})
Local nPLivre3 := aScan(aRet, {|x| AllTrim(x[1]) == cAlias + "_LIVRE3"})
Local nPLivre4 := aScan(aRet, {|x| AllTrim(x[1]) == cAlias + "_LIVRE4"})
Local nPLivre5 := aScan(aRet, {|x| AllTrim(x[1]) == cAlias + "_LIVRE5"})
Local nPLivre6 := aScan(aRet, {|x| AllTrim(x[1]) == cAlias + "_LIVRE6"})
Local nPLivre7 := aScan(aRet, {|x| AllTrim(x[1]) == cAlias + "_LIVRE7"})
Local nPLivre8 := aScan(aRet, {|x| AllTrim(x[1]) == cAlias + "_LIVRE8"})
Local nPLivre9 := aScan(aRet, {|x| AllTrim(x[1]) == cAlias + "_LIVRE9"})

Local nPCliente := aScan(aRet, {|x| AllTrim(x[1]) == cAlias + "_CODIGO"})
Local nPLojaCli := aScan(aRet, {|x| AllTrim(x[1]) == cAlias + "_LOJA"})

If cAlias == 'HJ7'
	DbSelectArea("SA1")
	DbSetOrder(1)
	If DbSeek(xFilial('SA1')+AllTrim(aRet[nPCliente][2]) + AllTrim(aRet[nPLojaCli][2])) 
		If SA1->(FieldPos('A1_END'))> 0
			aRet[nPlivre0][2] := SA1->A1_END
		EndIf
	EndIf
		
If SA1->(FieldPos('A1_BAIRRO'))> 0
			aRet[nPlivre1][2] := SA1->A1_BAIRRO
		EndIf
	 
 If SA1->(FieldPos('A1_CONTATO'))> 0
			aRet[nPlivre2][2] := SA1->A1_CONTATO
	EndIf

 If SA1->(FieldPos('A1_EMAIL'))> 0
			aRet[nPlivre3][2] := SA1->A1_EMAIL
	EndIf
	
 If SA1->(FieldPos('A1_TEL'))> 0
			aRet[nPlivre4][2] := SA1->A1_TEL
	EndIf	

EndIf
	
Return aRet