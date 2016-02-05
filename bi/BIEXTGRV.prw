#Include "topconn.ch"
#include "protheus.ch"
User Function BIEXTGRV BIEXTGRV 

Local cAlias   := PARAMIXB[1] // Alias da Fato ou Dimensão em gravação no momento
Local aRet     := PARAMIXB[2] // Array contendo os dados do registro para manipulação
Local lIsDim   := PARAMIXB[3] // Variável que indica quando está gravando em uma Dimensão (.T.) ou Fato (.F.)

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
ConOut("Passou pelo ponto SA1")
	//A1_END
	DbSelectArea("SA1")
	DbSetOrder(1)
ConOut (aRet[nPCliente][2] + aRet[nPLojaCli][2])
	If DbSeek(xFilial('SA1')+AllTrim(aRet[nPCliente][2]) + AllTrim(aRet[nPLojaCli][2])) 
ConOut(A1_END)
		If SA1->(FieldPos('A1_END'))> 0
ConOut("Ewerson")
			aRet[nPlivre0][2] := SA1->A1_END
		EndIf
	EndIf
 EndIf

ElseIf cAlias == 'HJ7'
ConOut("Passou pelo ponto SA1")
	//A1_MUN
	DbSelectArea("SA1")
	DbSetOrder(1)
ConOut (aRet[nPCliente][2] + aRet[nPLojaCli][2])
	If DbSeek(xFilial('SA1')+AllTrim(aRet[nPCliente][2]) + AllTrim(aRet[nPLojaCli][2])) 
ConOut(A1_MUN)
		If SA1->(FieldPos('A1_MUN'))> 0
ConOut("Municipio")
			aRet[nPlivre1][2] := SA1->A1_MUN
		EndIf
	EndIf
 EndIf






Return aRet
