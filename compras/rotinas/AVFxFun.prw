#include "Protheus.ch"
#include "TopConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCECF001A  บAutor  ณAndr้ Cruz          บ Data ณ  09/16/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fun็๕es de Uso Gen้rico                                    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Avant                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿


Para utiliza a fun็ใo U_NextSeq

Criar tabela  ZZT
Nome:                 ZZT_CAMPO  
Tipo:                 C       
Tamanho:              10 
Contexto:             Real
Propriedade:          Alterar
Titulo:               Campo
Descri็ใo:            Campo
Usado:                N

Nome:                 ZZT_FILTRO 
Tipo:                 C       
Tamanho:              255 
Contexto:             Real
Propriedade:          Alterar
Titulo:               Filtro
Descri็ใo:            Filtro
Usado:                N

Nome:                 ZZT_VALOR  
Tipo:                 C       
Tamanho:              20 
Contexto:             Real
Propriedade:          Alterar
Titulo:               Valor
Descri็ใo:            Valor
Usado:                N
*/

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ BDados   บAutor  ณAndr้ Cruz          บ Data ณ  09/16/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Cria as defini็๕es de AHeader e ACols para a MSNewGetDados บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
Parametro aJoin Ex.:
aAdd(aJoin, {RetSqlName("SB1") + " SB1", "SB1.B1_DESC" , "SB1.B1_FILIAL = '" + xFilial("SB1") + "' AND SB1.D_E_L_E_T_ <> '*' AND SB1.B1_COD = GD5.GD5_CODDES", "GD5_DDESPE"})
             Arquivo e Alias           , Campo origem  , Condi็ใo de relacionamento entre os arquivos                                                        , Campo destino
*/

User Function BDados(cAlias, aHDados, aCDados, nUDados, nOrd, lFilial, cCond, lStatus, cCpoLeg, cLstCpo, cElimina, cCpoNao, cStaReg, cCpoMar, cMarDef, lLstCpo, aLeg, lEliSql, lOrderBy, cCposGrpBy, cGroupBy, aCposIni, aJoin, aCposCalc, cOrderBy, aCposVis, aCposAlt, cCpoFilial)

Local aCpos := { { "T", "GFR" } }
Local aArea := U_SavArea({{Alias(), 0, 0}}), nCol := 0, nTotItens := 0, cCampo := "", nForCpos := 0, aVCposOld := {}, nCposOld := 0
Local cSql := "", cCposSql := "", cCondSql := "", nFor := 0
Local nACond := 0, aArqCond := IIF(aJoin == Nil, {}, aJoin), cArqLst := RetSqlName(cAlias) + " " + cAlias
Local nQtdLinMax := IIf(nUDados <> Nil, nUDados, 0), nPosDef := 0
Local nOperLog   := 0
Local aOperLog   := {".and.", ".anD.", ".aNd.", ".aND.", ".And.", ".AnD.", ".ANd.", ".AND.", ".OR.", ".Or.", ".oR.", ".or.", ".not.", ".noT.", ".nOt.", ".nOT.", ".Not.", ".NoT.", ".NOt.", ".NOT." }
Local lGFR       := U_ExisDic(aCpos,.F.)
Local aCVirtual  := {}
Local lFill      := .F.

Default aLeg       := {{".T.", "BR_AZUL"}}
Default aCposCalc  := {}
Default lEliSql    := .T.
Default lOrderBy   := .T.
Default lLstCpo    := .F.
Default cStaReg    := "BR_VERDE"
Default cMarDef    := "'LBNO'"
Default aCposVis   := {}
Default aCposAlt   := {}
Default lFilial    := .T.

nUDados := 0

// Para garantir valor l๓gico ao campo lFilial
lFilial := IIF(ValType(lFilial) <> "L", .T., lFilial)

// Para garantir valor l๓gico ao campo lStatus
lStatus := IIF(ValType(lStatus) <> "L", .F., lStatus)

// Para garantir o valor caracter ao campo cStaReg
cStaReg := IIF(ValType(cStaReg) <> "C", "BR_VERDE", cStaReg)

//Salva valor das variaveis de memoria para restaurar no final
DbSelectArea("SX3")
DbSetOrder(1) // X3_ARQUIVO + X3_ORDEM
DbSeek(cAlias)
While SX3->X3_ARQUIVO == cAlias
	If Type("M->" + SX3->X3_CAMPO ) <> "U"
		aAdd(aVCposOld, { "M->" + SX3->X3_CAMPO , &("M->" + SX3->X3_CAMPO) } )
	EndIf
	SX3->(DbSkip())
End

cLstCpo := IIF(cLstCpo == Nil, "", cLstCpo)

If lStatus
	nUDados++
	aAdd(aHDados, Sx3Defs(.T., "HSP_STAREG", 1, "'BR_VERMELHO'"))
EndIf

If cCpoLeg # Nil
	DbSetOrder(2)
	If DbSeek(PadR(AllTrim(cCpoLeg), 10))
		nUDados++
		aAdd(aHDados, Sx3Defs(.T., PadR(AllTrim(cCpoLeg), 10), SX3->X3_TAMANHO))
	EndIf
EndIf

DbSelectArea("SX3")
If cCpoMar # Nil
	If ValType(cCpoMar) == "A"
		For nFor := 1 To Len (cCpoMar)
			DbSetOrder(2) // X3_CAMPO
			If DbSeek(PadR(AllTrim(cCpoMar[nFor]), 10))
				nUDados++
				aAdd(aHDados, Sx3Defs(.T., PadR(AllTrim(cCpoMar[nFor]), 10), 1))
			EndIf
		Next nFor
	Else
		DbSetOrder(2)
		If DbSeek(PadR(AllTrim(cCpoMar), 10))
			nUDados++
			aAdd(aHDados, Sx3Defs(.T., PadR(AllTrim(cCpoMar), 10), 1))
		EndIf
	EndIf
EndIf

If aCposIni # Nil
	For nForCpos := 1 To Len(aCposIni)
		DbSetOrder(2)
		If DbSeek(PadR(AllTrim(aCposIni[nForCpos]), 10))
			nUDados++
			aAdd(aHDados, Sx3Defs(.F., PadR(AllTrim(aCposIni[nForCpos]), 10),,,, aCposVis, aCposAlt))
		EndIf
	Next
EndIf

DbSetOrder(1)
DbSeek(cAlias)
While !Eof() .And. SX3->X3_ARQUIVO == cAlias
	If cLstCpo == "ALL" .Or. ;
		(X3Uso(SX3->X3_USADO) .And. cNivel >= SX3->X3_NIVEL .And. SX3->X3_BROWSE == "S" .And. ;
		IIF(aCposIni == Nil, .T., aScan(aCposIni, SX3->X3_CAMPO) == 0) .And. ;
		IIF(cCpoLeg == Nil, .T., SX3->X3_CAMPO # PadR(AllTrim(cCpoLeg), 10)) .And. ;
		IIF(cCpoMar == Nil, .T., IIf(ValType(cCpoMar) == "C" , SX3->X3_CAMPO # PadR(AllTrim(cCpoMar), 10), aScan(cCpoMar,{|aVet| SX3->X3_CAMPO == PadR(AllTrim(cCpoMar[1]),10) }) == 0 )) .And. ;
		IIF(cCpoNao == Nil, .T., !(SX3->X3_CAMPO $ cCpoNao))) .And. !lLstCpo .Or. ;
		(IIF(!Empty(cLstCpo), SX3->X3_CAMPO $ cLstCpo, lLstCpo))
		
		nUDados++
		aAdd(aHDados, Sx3Defs(.F., SX3->X3_CAMPO,,,, aCposVis, aCposAlt))
		
		If SX3->X3_TIPO # "M" .And. SX3->X3_CONTEXT == "V" .And. !Empty(SX3->X3_RELACAO) .And. IsJoin(SX3->X3_RELACAO)
			aAdd(aCVirtual, {SX3->X3_CAMPO, STRTRAN(STRTRAN(UPPER(SX3->X3_RELACAO), " ", ""), "'", '"'), SX3->X3_ORDEM})
		EndIf
	EndIf
	
	If SX3->X3_CONTEXT # "V" .And. SX3->X3_TIPO # "M"
		cCposSql += IIF(!Empty(cCposSql), ", ", "") + cAlias + "." + AllTrim(SX3->X3_CAMPO)
	ElseIf SX3->X3_CONTEXT # "V" .And. SX3->X3_TIPO == "M"
		cCposSql += IIF(!Empty(cCposSql), ", ", "") + cAlias + ".R_E_C_N_O_ " + AllTrim(SX3->X3_CAMPO)
	EndIf
	
	DbSkip()
EndDo

If Len(aCposCalc) > 0
	For nForCpos := 1 To Len(aCposCalc)
		DbSetOrder(2)
		If DbSeek(PadR(AllTrim(aCposCalc[nForCpos, 1]), 10))
			nUDados++
			aAdd(aHDados, Sx3Defs(.F., aCposCalc[nForCpos, 3],,, aCposCalc[nForCpos, 2]))
		EndIf
	Next
EndIf

If cCond # Nil
	U_ArqCond(cAlias, @aArqCond, aCVirtual, lFilial, cCpoFilial)
	
	For nACond := 1 To Len(aArqCond)
		If !Empty(aArqCond[nACond, 1]) .And. !Empty(aArqCond[nACond, 3])
			cArqLst += " INNER JOIN " + aArqCond[nACond, 1] + " ON " + aArqCond[nACond, 3] + " "
		EndIf
		
		If !Empty(aArqCond[nACond, 2])
			cCposSql += ", " + aArqCond[nACond, 2] + " " + aArqCond[nACond, 4]
		EndIf
	Next
	
	// Monta Ramk para o restante dos bancos diferentes de DB2
	If !("DB2" $ TCGetDB()) .And. nQtdLinMax > 0
		If "ORACLE" $ TCGetDB()
			cSql := "SELECT " + IIF(cCposGrpBy # Nil, cCposGrpBy, cCposSql) + " FROM " + cArqLst + " " + ;
			"WHERE ROWNUM <= "  + AllTrim(Str(nQtdLinMax)) + " AND " + IIF(lFilial, cAlias + "." + PrefixoCpo(cAlias) + "_FILIAL = '" + xFilial(cAlias) + "' AND ", "") + cAlias + ".D_E_L_E_T_ <> '*'"
			
		Else
			cSql := "SELECT TOP " + AllTrim(Str(nQtdLinMax)) + " " + IIF(cCposGrpBy # Nil, cCposGrpBy, cCposSql) + " FROM " + cArqLst + " " + ;
			"WHERE " + IIF(lFilial, cAlias + "." + PrefixoCpo(cAlias) + "_FILIAL = '" + xFilial(cAlias) + "' AND ", "") + cAlias + ".D_E_L_E_T_ <> '*'"
			
		EndIf
	Else
		cSql := "SELECT " + IIF(cCposGrpBy # Nil, cCposGrpBy, cCposSql) + " FROM " + cArqLst + " " + ;
		"WHERE " + IIF(lFilial, cAlias + "." + PrefixoCpo(cAlias) + "_FILIAL = '" + xFilial(cAlias) + "' AND ", "") + cAlias + ".D_E_L_E_T_ <> '*'"
	EndIf
	If !Empty(cCond)
		cCondSql := cCond
		
		For nOperLog := 1 to len(aOperLog)
			cCondSql := StrTran(cCondSql, aOperLog[nOperLog], IIF(LEN(aOperLog[nOperLog]) == 4, " OR ", IIF(UPPER(SUBSTR( ;
			aOperLog[nOperLog],2,1)) == "A", " AND ", " NOT ")))
		Next nOperLog
		
		cCondSql := StrTran(cCondSql, "->", ".")
		cCondSql := StrTran(cCondSql, "==", "=")
		cCondSql := StrTran(cCondSql, "#", "<>")
		cSql += " AND (" + cCondSql + ")"
	EndIf
	
	If !Empty(cElimina) .And. lEliSql
		cCondSql := cElimina
		
		For nOperLog := 1 to len(aOperLog)
			cCondSql := StrTran(cCondSql, aOperLog[nOperLog], IIF(LEN(aOperLog[nOperLog]) == 4, " OR ", IIF(UPPER(SUBSTR( ;
			aOperLog[nOperLog],2,1)) == "A", " AND ", " NOT ")))
		Next nOperLog
		
		cCondSql := StrTran(cCondSql, "->", ".")
		cCondSql := StrTran(cCondSql, "==", "=")
		cCondSql := StrTran(cCondSql, "#", "<>")
		cSql += " AND NOT (" + cCondSql + ")"
	EndIf
	
	If cGroupBy # Nil
		cSql += " GROUP BY " + cGroupBy
	EndIf
	
	If lOrderBy
		If cOrderBy # Nil .And. !Empty(cOrderBy)
			cSql += " ORDER BY " + cOrderBy
		ElseIf IIF(!Empty(nOrd), U_ExisDic({{"I", cAlias, nOrd}}, .F.), .T.)
			cSql += " ORDER BY " + SqlOrder((cAlias)->(IndexKey(nOrd)))
		EndIf
	EndIf
	
	// Monta Ramk para banco de dados DB2
	If "DB2" $ TCGetDB() .And. nQtdLinMax > 0
		cSql += " FETCH FIRST " + AllTrim(Str(nQtdLinMax)) + " ROWS ONLY"
	EndIf
	
	cSql := ChangeQuery(cSql)
	
	TCQuery cSql New Alias "TMP" + cAlias
	
	For nCol := 1 To Len(aHDados)
		If aHDados[nCol, 10] <> "V" .And. aHDados[nCol, 08] $ "D/N"
			TCSetField("TMP" + cAlias, aHDados[nCol, 02], aHDados[nCol, 08], aHDados[nCol, 04], aHDados[nCol, 05])
		EndIf
	Next
	
	If ValType(cMarDef) == "A"
		For nFor := 1 To Len(cMarDef)
			cMarDef[nFor] := StrTran(cMarDef[nFor], cAlias + "->", "TMP" + cAlias + "->")
		Next nFor
	Else
		cMarDef := StrTran(cMarDef, cAlias + "->", "TMP" + cAlias + "->")
	EndIf
	
	cAlias := "TMP" + cAlias
	DbSelectArea(cAlias)
	
	While !Eof()
		If cElimina # Nil .And. !lEliSql .And. &(cElimina)
			DbSkip()
			Loop
		EndIf
		
		aAdd(aCDados, Array(nUDados + 1))
		For nCol := 1 To nUDados
			nPosDef := 0
			If (nForCpos := aScan(aCposCalc, {| aVet | aVet[3] == aHDados[nCol, 2]})) > 0
				aCDados[Len(aCDados), nCol] := &(aCposCalc[nForCpos, 4])
			ElseIf IIf(ValType(cCpoMar) == "C", aHDados[nCol, 2] == PadR(AllTrim(cCpoMar), 10) , (nPosDef := aScan(cCpoMar,{|aVet| aHDados[nCol, 2] == PadR(AllTrim(aVet),10) })) <> 0 )
				aCDados[Len(aCDados), nCol] := IIf(nPosDef == 0, &(cMarDef), &(cMarDef[nPosDef]))
			ElseIf aHDados[nCol, 2] == PadR(AllTrim(cCpoLeg), 10)
				aCDados[Len(aCDados), nCol] := LegBD(aLeg,cCond)
			ElseIf aHDados[nCol, 2] == "HSP_STAREG"
				aCDados[Len(aCDados), nCol] := cStaReg
			Else
				If aHDados[nCol, 10] # "V" .OR. ( aArqCond # Nil .AND. aArqCond[1][4] == aHDados[nCol, 2] )
					aCDados[Len(aCDados), nCol] := FieldGet(FieldPos(aHDados[nCol, 2]))
				ElseIf aHDados[nCol, 10] == "V" .AND. aArqCond # Nil 
                    lFill := .F.
				    For i := 1 To Len(aArqCond)
				       If aHDados[nCol, 2] == aArqCond[i][4]
				          aCDados[Len(aCDados), nCol] := FieldGet(FieldPos(aHDados[nCol, 2]))
				          lFill := .T.
				          Exit
				       EndIf
				    Next
                    If !lFill
				       aCDados[Len(aCDados), nCol] := RPadrao(cAlias, aHDados[nCol], aArqCond)
				    EndIf
				Else
					aCDados[Len(aCDados), nCol] := RPadrao(cAlias, aHDados[nCol], aArqCond)
				EndIf
				cCampo    := "M->" + aHDados[nCol, 2]
				&(cCampo) := aCDados[Len(aCDados), nCol]
			EndIf
		Next
		aCDados[Len(aCDados), nUDados + 1] := .F.
		nTotItens++
		
		DbSelectArea(cAlias)
		DbSkip()
	EndDo
EndIf

If Empty(aCDados)
	aAdd(aCDados, Array(nUDados + 1))
	For nCol := 1 To nUDados
		nPosDef := 0
		If (nForCpos := aScan(aCposCalc, {| aVet | aVet[3] == aHDados[nCol, 2]})) > 0
			aCDados[Len(aCDados), nCol] := &(aCposCalc[nForCpos, 4])
		ElseIf IIf(ValType(cCpoMar) == "C", aHDados[nCol, 2] == PadR(AllTrim(cCpoMar), 10) , (nPosDef := aScan(cCpoMar,{|aVet| aHDados[nCol, 2] == PadR(AllTrim(aVet),10) })) <> 0 )
			aCDados[Len(aCDados), nCol] := IIf(nPosDef == 0, &(cMarDef), &(cMarDef[nPosDef]))
		ElseIf aHDados[nCol, 2] == PadR(AllTrim(cCpoLeg), 10)
			aCDados[Len(aCDados), nCol] := LegBD(aLeg,cCond)
		Else
			aCDados[Len(aCDados), nCol] := RPadrao(cAlias, aHDados[nCol], aArqCond)
			
			cCampo    := "M->" + aHDados[nCol, 2]
			&(cCampo) := aCDados[Len(aCDados), nCol]
		EndIf
	Next
	aCDados[Len(aCDados), nUDados + 1] := .F.
EndIf

If cCond # Nil
	DbSelectArea(cAlias)
	DbCloseArea()
EndIf

U_ResArea(aArea)
DbSelectArea(aArea[1][1])

For nCposOld := 1 To Len(aVCposOld)
	&(aVCposOld[nCposOld, 1]) := aVCposOld[nCposOld, 2]
Next
Return(nTotItens)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ ArqCond  บAutor  ณ Andr้ Cruz         บ Data ณ  09/16/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Cria as condi็๕es SQL utilizadas para filtro em queries.   บฑฑ
ฑฑบ          ณ Utilizada pela BDados                                      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function ArqCond(cADes, aArqCond, aCVirtual, lFilial, cCpoFilial)
Local nCVirtual  := 0
Local nPStr      := 0
Local cRStr      := ""
Local cAOri      := ""
Local cNOrd      := ""
Local cPChv      := ""
Local cIChv      := ""
Local nIChv      := 0
Local nPChv      := 0
Local cRCpo      := ""
Local cCond      := ""
Local lCpoFilial := !Empty(cCpoFilial) .And. &(cADes)->(FieldPos(cCpoFilial)) > 0
Local lArqExclus := .F.

// Inclui o alias do arquivo principal no campo
cCpoFilial := IIf(!Empty(cCpoFilial), cADes + "." + cCpoFilial, Nil)

For nCVirtual := 1 To Len(aCVirtual)
	cRStr := aCVirtual[nCVirtual][2]
	
	//POSICIONE("GD4",1,xFilial("GD4")+GCZ->GCZ_REGGER+GCZ->GCZ_CODPLA,"GD4_MATRIC")
	If     "POSICIONE(" $ cRStr
		nPStr := At("POSICIONE(", cRStr) + 10
		
		//U_IniPadr("GFV",1,GCZ->GCZ_CODPLA+GCZ->GCZ_SQCATP,"GFV_NOMCAT",,.F.)
	ElseIf "U_INIPADR(" $ cRStr
		nPStr := At("U_INIPADR(", cRStr) + 11
		
		//U_X3RELAC("GCM", 2, "GD4_CODPLA", "GCM_DESPLA")
	ElseIf "U_X3RELAC(" $ cRStr
		nPStr := At("U_X3RELAC(", cRStr) + 11
		
	EndIf
	
	// Pega o Alias
	cRStr := SubStr(cRStr, nPStr + 1)
	cAOri := SubStr(cRStr, 1, (nPStr := At(",", cRStr)) - 2)
	
	// Pega o Indice
	cRStr := SubStr(cRStr, nPStr + 1)
	cNOrd := U_CInd(Val(SubStr(cRStr, 1, (nPStr := At(",", cRStr)) - 1)))
	
	// Posiciona no dicionแrio de indices para pegar a chave de pesquisa e retirar o campo filial
	SIX->(DbSeek(cAOri + cNOrd))
	cIChv := StrTran(AllTrim(Upper(SIX->CHAVE)), " ", "")
	cIChv := SubStr(cIChv, At("+", cIChv) + 1)
	
	// Pega a chave para pesquisa
	If "U_X3RELAC(" $ aCVirtual[nCVirtual][2]
		cRStr := SubStr(cRStr, nPStr + 2)
	Else
		cRStr := SubStr(cRStr, nPStr + 1)
	EndIf
	// Retira a fun็ใo xFilial()
	If "POSICIONE(" $ aCVirtual[nCVirtual][2]
		cRStr := SubStr(cRStr, At("+", cRStr) + 1)
	EndIf
	If "U_X3RELAC(" $ aCVirtual[nCVirtual][2]
		cPChv := SubStr(cRStr, 1, (nPStr := At(",", cRStr)) - 2)
	Else
		cPChv := SubStr(cRStr, 1, (nPStr := At(",", cRStr)) - 1)
	EndIf
	
	cPChv := StrTran(cPChv, '"', "'")
	
	// Pega o campo que serแ retornado na query
	cRStr := SubStr(cRStr, nPStr + 2)
	cRCpo := SubStr(cRStr, 1, At('"', cRStr) - 1)
	
	// Acerta a chave do indice para montar a condi็ใo do join
	cIChv := cAOri + aCVirtual[nCVirtual][3] + "." + StrTran(cIChv, "+", " || " + cAOri + aCVirtual[nCVirtual][3] + ".")
	
	// Acerta a chave de pesquisa para montar a condi็ใo do join
	cPChv := StrTran(cPChv, cADes + "->", "")
	cPChv := StrTran(cPChv,        "M->", "")
	cPChv := cADes + "." + StrTran(cPChv, "+", " || " + cADes + ".")
	cPChv := StrTran(cPChv, cADes + ".'", "'")
	
	If (nIChv := U_CntChr(cIChv, "|")) <> (nPChv := U_CntChr(cPChv, "|"))
		//ConOut("Indice   [" + cIChv + "]")
		//ConOut("Pesquisa [" + cPChv + "]")
		
		nIChv := 1
		nPChv := ((nPChv + 2) / 2)
		
		cRStr := cIChv
		cIChv := ""
		While nIChv <= nPChv
			cIChv += IIf(!Empty(cIChv), " || ", "") + SubStr(cRStr, 1, At("||", cRStr)-2)
			nIChv++
			cRStr := SubStr(cRStr, At("||", cRStr)+3)
		End
		//ConOut("Indice   [" + cIChv + "]")
	EndIf
	
	lArqExclus := !Empty(xFilial(cAOri))
	
	cCond := IIF(lFilial .Or. (lCpoFilial .And. lArqExclus), cAOri + aCVirtual[nCVirtual][3] + "." + PrefixoCpo(cAOri) + "_FILIAL = " + IIf(lCpoFilial .And. !lFilial, cCpoFilial, "'" + xFilial(cAOri) + "'") + " AND ", "") + ;
	IIf(cAOri == "SRA", cAOri + aCVirtual[nCVirtual][3] + ".RA_CODIGO <> '" + Space(TamSx3("RA_CODIGO")[1]) + "' AND ", "") + ;
	cAOri + aCVirtual[nCVirtual][3] + ".D_E_L_E_T_ <> '*' AND " + ;
	cIChv + " = " + cPChv
	
	If aScan(aArqCond, {| aVet | Upper(aVet[4]) == Upper(aCVirtual[nCVirtual][1])}) == 0 .And. aScan(aArqCond, {| aVet | Right(Upper(aVet[1]), Len(cAOri + aCVirtual[nCVirtual][3])) == Upper(cAOri + aCVirtual[nCVirtual][3])}) == 0
		aAdd(aArqCond, {" LEFT JOIN " + RetSqlName(cAOri) + " " + cAOri + aCVirtual[nCVirtual][3], cAOri + aCVirtual[nCVirtual][3] + "." + cRCpo, cCond, aCVirtual[nCVirtual][1]})
	EndIf
Next

Return(Nil)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ Sx3Defs  บAutor  ณ Andr้ Cruz         บ Data ณ  09/16/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Retorna as Defini็๕es do campo com base no conte๚do do SX3 บฑฑ
ฑฑบ          ณ Utilizada pela BDados                                      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function Sx3Defs(lBmpCpo, cNomCpo, nTamCpo, cRelaca, cTitulo, aCposVis, aCposAlt, cPictur)

Local aRetSx3 := {}
Local cX3_CBox := IIf(SubStr(SX3->X3_CBOX, 1, 1) == "#", &(AllTrim(SubStr(SX3->X3_CBOX, 2))), SX3->X3_CBOX)

Default cRelaca  := ""
Default cPictur  := "@BMP"
Default aCposVis := {}
Default aCposAlt := {}

aRetSx3 := {IIF(lBmpCpo, " "    , TRIM(IIF(!Empty(cTitulo), cTitulo, X3Titulo()))), ;
IIF(lBmpCpo, cNomCpo, IIF(!Empty(cNomCpo), cNomCpo, SX3->X3_CAMPO)),	;
IIF(lBmpCpo, cPictur, SX3->X3_PICTURE ), ;
IIF(lBmpCpo, nTamCpo, SX3->X3_TAMANHO ), ;
IIF(lBmpCpo, 0      , SX3->X3_DECIMAL ), ;
IIF(lBmpCpo, .F.    , SX3->X3_VALID   ), ;
IIF(lBmpCpo, ""     , SX3->X3_USADO   ), ;
IIF(lBmpCpo, "C"    , SX3->X3_TIPO    ), ;
IIF(lBmpCpo, ""     , SX3->X3_F3      ), ;
IIF(lBmpCpo, "V"    , SX3->X3_CONTEXT ), ;
IIF(lBmpCpo, ""     , cX3_CBox        ), ;
IIF(lBmpCpo, cRelaca, IIF(!Empty(cRelaca), cRelaca, SX3->X3_RELACAO)), ;
IIF(lBmpCpo, ""     , SX3->X3_WHEN    ), ;
IIF(lBmpCpo, "V"    , SX3->X3_VISUAL  ), ;
IIF(lBmpCpo, ""     , SX3->X3_VLDUSER ), ;
IIF(lBmpCpo, ""     , SX3->X3_PICTVAR ), ;
IIF(lBmpCpo, ""     , X3Obrigat(SX3->X3_CAMPO))}

If aScan(aCposVis, cNomCpo) > 0
	aRetSx3[14] := "V"
ElseIf aScan(aCposAlt, cNomCpo) > 0
	aRetSx3[14] := "A"
EndIf

Return(aRetSx3)



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ RPadrao  บAutor  ณ Andr้ Cruz         บ Data ณ  09/16/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Retorna dados para a aCols.                                บฑฑ
ฑฑบ          ณ Utilizada pela BDados                                      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function RPadrao(cAlias, aCampo, aArqCond)

Local cRPadrao := "", nPosRet := 0

If "TMP" $ cAlias
	If aArqCond # Nil .And. (nPosRet := aScan(aArqCond, {| aVet | aVet[4] == aCampo[2]})) > 0 .And. Type(cAlias + "->" + aArqCond[nPosRet, 4]) <> "U"
		cRPadrao := &(cAlias + "->" + aArqCond[nPosRet, 4])
	Else
		If !Empty(aCampo[12])
			cRPadrao := &(StrTran(aCampo[12], SubStr(cAlias, 4, Len(cAlias) - 3) + "->", cAlias + "->"))
		Else
			cRPadrao := IIF(aCampo[8] == "N", 0, IIF(aCampo[8] == "D", CToD(""), Space(aCampo[4])))
		EndIf
	EndIf
ElseIf !Empty(aCampo[12])
	cRPadrao := &(aCampo[12])
Else
	cRPadrao := IIF(aCampo[8] == "N", 0, IIF(aCampo[8] == "D", CToD(""), Space(aCampo[4])))
EndIf

Return(cRPadrao)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ LegBD    บAutor  ณ Andr้ Cruz         บ Data ณ  09/16/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Retorna o conte๚do de legenda para MSNewGetDados           บฑฑ
ฑฑบ          ณ Utilizada pela BDados                                      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function LegBD(aLeg,cCond)

Local nLeg := 0, cCorLeg := "BR_CINZA"
If cCond <> nil
	For nLeg := 1 To Len(aLeg)
		If &(aLeg[nLeg, 1])
			cCorLeg := aLeg[nLeg, 2]
		EndIf
	Next
EndIf

Return(cCorLeg)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ SavArea  บAutor  ณ Andr้ Cruz         บ Data ณ  09/16/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Salva vแria แreas, passadas pela matriz aArea              บฑฑ
ฑฑบ          ณ Utilizada pela BDados                                      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function SavArea(aArea)
Local nArea := 1
For nArea := 1 To Len(aArea)
	aArea[nArea, 2] := &(aArea[nArea, 1] + "->(IndexOrd())")
	aArea[nArea, 3] := &(aArea[nArea, 1] + "->(RecNo())")
Next
Return(aArea)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ ResArea  บAutor  ณ Andr้ Cruz         บ Data ณ  09/16/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Restaura vแria แreas, passadas pela matriz aArea           บฑฑ
ฑฑบ          ณ Utilizada pela BDados                                      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function ResArea(aArea)
Local nArea := 1
For nArea := 1 To Len(aArea)
	&(aArea[nArea, 1] + "->(DbSetOrder(" + AllTrim(Str(aArea[nArea, 2])) + "))")
	&(aArea[nArea, 1] + "->(DbGoTo(" + AllTrim(Str(aArea[nArea, 3])) + "))")
Next
Return(Nil)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ ExisDic  บAutor  ณ Andr้ Cruz         บ Data ณ  09/16/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Verifica a existencia dos dados no dicionario de dados e reบฑฑ
ฑฑบ          ณ torna qual atualizador deve ser aplicado para a rotina.    บฑฑ
ฑฑบ          ณ Utilizada pela BDados                                      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function ExisDic(aCampos, lMsg)

Local aArea      := GetArea()
Local nFor       := 0
Local nForCpo    := 0
Local aCpos      := {}
Local cMsgCDic   := ""
Local cMsgTDic   := ""
Local cMsgIDic   := ""
Local cMsgCBco   := ""
Local cMsgTBco   := ""
Local cMsgIBco   := ""
Local cMsgBops   := ""
Local lRet       := .T.
Local cBops      := ""

Private cPrefixo := ""
Private cCampo   := ""

Default lMsg     := .T.

For nFor := 1 To Len(aCampos)
	
	cPrefixo := PADL(SubStr(aCampos[nFor, 2], 1, aT("_",aCampos[nFor, 2])-1), 3, "S")
	cCampo   := aCampos[nFor, 2]
	cBops    := IIf(len(aCampos[nFor]) == 3,aCampos[nFor,3],"") // Pega o Bops se existir ou em branco se for sistema antigo
	
	If aCampos[nFor, 1] == "T"
		DbSelectArea("SX2")
		DbSetOrder(1) //X2_CHAVE
		If !DbSeek(cCampo) //verifica exist๊ncia da tabela no dicionแrio de dados
			aAdd(aCpos, {"T", cCampo, 1,cBops})
		EndIf
	ElseIf aCampos[nFor, 1] == "C"
		DbSelectArea("SX3")
		DbSetOrder(2) // X3_CAMPO
		If !DbSeek(cCampo) //verifica exist๊ncia do campo no dicionแrio de dados
			aAdd(aCpos, {"C", cCampo, 1, cBops})
		ElseIf &(cPrefixo + "->(FieldPos(cCampo))") == 0 .AND. SX3->X3_CONTEXT <> "V"//verifica exist๊ncia do campo no banco de dados
			aAdd(aCpos, {"C", cCampo, 2, cBops})
		EndIf
	ElseIf aCampos[nFor, 1] == "I"
		DbSelectArea("SIX")
		DbSetOrder(1) //INDICE+ORDEM
		If !DbSeek(cPrefixo + U_CInd(aCampos[nFor, 3])) //verifica exist๊ncia do ํndice no dicionแrio de dados
			aAdd(aCpos, {"I", RetSqlName(cPrefixo) + U_CIND(aCampos[nFor, 3]), 1, cBops})
		ElseIf !(TCCANOPEN(RetSqlName(cPrefixo), RetSqlName(cPrefixo) + U_CIND(aCampos[nFor, 3])))//verifica exist๊ncia do ํndice no banco de dados
			aAdd(aCpos, {"I", RetSqlName(cPrefixo) + U_CIND(aCampos[nFor, 3]), 2, cBops})
		EndIf
	EndIf
Next

aSort(aCampos,,, {|x, y| x[1] < y[1]})

If !(lRet := Empty(aCpos)) .And. lMsg
	For nForCpo := 1 To Len(aCpos)
		If aCpos[nForCpo, 1] == "C"
			If aCpos[nForCpo, 3] == 1 //verifica se o campo nใo foi encontrado no dicionแrio
				If !Empty(cMsgCDic)
					cMsgCDic += ", "
					cMsgCDic += aCpos[nForCpo, 2]
				Else
					cMsgCDic += aCpos[nForCpo, 2]
				EndIf
			ElseIf aCpos[nForCpo, 3] == 2 //verifica se o campo nใo foi encontrado no banco
				If !Empty(cMsgCBco)
					cMsgCBco += ", "
					cMsgCBco += aCpos[nForCpo, 2]
				Else
					cMsgCBco += aCpos[nForCpo, 2]
				EndIf
			EndIf
		ElseIf aCpos[nForCpo, 1] == "T"
			If aCpos[nForCpo, 3] == 1 //verifica se a tabela nใo foi encontrada no dicionแrio
				If !Empty(cMsgTDic)
					cMsgTDic += ", "
					cMsgTDic += aCpos[nForCpo, 2]
				Else
					cMsgTDic += aCpos[nForCpo, 2]
				EndIf
			ElseIf aCpos[nForCpo, 3] == 2 //verifica se a tabela nใo foi encontrada no banco
				If !Empty(cMsgTBco)
					cMsgTBco += ", "
					cMsgTBco += aCpos[nForCpo, 2]
				Else
					cMsgTBco := aCpos[nForCpo, 2]
				EndIf
			EndIf
		ElseIf aCpos[nForCpo, 1] == "I"
			If aCpos[nForCpo, 3] == 1 //verifica se o ํndice nใo foi encontrado no dicionแrio
				If !Empty(cMsgIDic)
					cMsgIDic += ", "
					cMsgIDic += aCpos[nForCpo, 2]
				Else
					cMsgIDic += aCpos[nForCpo, 2]
				EndIf
			ElseIf aCpos[nForCpo, 3] == 2 //verifica se o ํndice nใo foi encontrado no banco
				If !Empty(cMsgIBco)
					cMsgIBco += ", "
					cMsgIBco += aCpos[nForCpo, 2]
				Else
					cMsgIBco += aCpos[nForCpo, 2]
				EndIf
			EndIf
		EndIf
		
		// Guarda mensagens informando o BOPS
		If !Empty(cMsgBops)
			If at(aCpos[nForCpo, 4], cMsgBops) == 0
				cMsgBops += ", "
				cMsgBops += aCpos[nForCpo, 4]
			Endif
		Else
			cMsgBops = aCpos[nForCpo, 4]
		EndIf
	Next
	
	
	If len(aCampos[1]) == 3 // Se for no sitema novo informa o bops a ser executado
		If cMsgBops <> ""
			U_MsgInf("Por favor, para a atualiza็ใo desta rotina, execute o(s) atualizador(es):" + cMsgBops + ".", "Aten็ใo", "Valida็ใo de Dicionแrios")
		Endif
	Else // Sistema antigo
		If aScan(aCpos, {| aVet | aVet[1] == "T"}) <> 0
			If cMsgTDic <> ""
				U_MsgInf("Por favor, para executar esta rotina, verifique a exist๊ncia da(s) tabela(s) " + cMsgTDic + " no dicionแrio de dados.", "Aten็ใo", "Valida็ใo de Dicionแrios")
			ElseIf cMsgTBco <> ""
				U_MsgInf("Por favor, para executar esta rotina, verifique a exist๊ncia da(s) tabela(s) " + cMsgTBco + " no banco de dados.", "Aten็ใo", "Valida็ใo de Bancos")
			EndIf
		ElseIf aScan(aCpos, {| aVet | aVet[1] == "C"}) <> 0
			If cMsgCDic <> ""
				U_MsgInf("Por favor, para executar esta rotina, verifique a exist๊ncia do(s) campo(s) " + cMsgCDic + " no dicionแrio de dados.", "Aten็ใo", "Valida็ใo de Dicionแrios")
			ElseIf cMsgCBco <> ""
				U_MsgInf("Por favor, para executar esta rotina, verifique a exist๊ncia do(s) campo(s) " + cMsgCBco + " no banco de dados.", "Aten็ใo", "Valida็ใo de Bancos")
			EndIf
		ElseIf aScan(aCpos, {| aVet | aVet[1] == "I"}) <> 0
			If cMsgIDic <> ""
				U_MsgInf("Por favor, para executar esta rotina, verifique a exist๊ncia do(s) ํndice(s) " + cMsgIDic + " no dicionแrio de dados.", "Aten็ใo", "Valida็ใo de Dicionแrios")
			ElseIf cMsgIBco <> ""
				U_MsgInf("Por favor, para executar esta rotina, verifique a exist๊ncia do(s) ํndice(s) " + cMsgIBco + " no banco de dados.", "Aten็ใo", "Valida็ใo de Bancos")
			EndIf
		EndIf
	Endif
	
EndIf

RestArea(aArea)

Return(lRet)

User Function X3RELAC(cAlias, nOrdem, cCpoChv, cCpoRet)
Local cCodChave := IIf(Inclui, "", IIf("TMP" $ Alias(), &(cCpoChv), ""))
Local cDescri   := ""
If !EMPTY(cCodChave)
	cDescri := U_INIPADR(cAlias, nOrdem, cCodChave, cCpoRet,, .F.)
EndIf
Return(cDescri)

User Function IniPadr(cAlias, nOrdem, cChave, cCampo, lSoftSeek, lInclui, cChvURel, cFilAlias)
//cChvURel: se veio preenchido, a rotina deve retornar conteudo somente se ha somente 1 registro para esta chave

Local cRet := "", cAliasOld := Alias()
Local cChvPesq := ""
Local cChvComp := ""
Local cInic    := ""
Local aAreaSX3 := U_SavArea({{"SX3", 0, 0}})

Default lSoftSeek := .F.
Default lInclui   := .T.
Default cFilAlias := ""

cChvPesq := IIF(!Empty(cFilAlias) .And. !Empty(xFilial(cAlias)), cFilAlias, xFilial(cAlias)) + cChave

If !Empty(cChvURel)
	cChvComp := cAlias + "->" + PrefixoCpo(cAlias) + "_FILIAL + " + cAlias + "->" + cChvURel
Endif

If cCampo <> Nil .And. !Empty(cCampo)
	SX3->(DbSetOrder(2))
	SX3->(DbSeek(cCampo))
	cInic := IIf(SX3->X3_TIPO == "D", CToD(" "), IIf(SX3->X3_TIPO == "N", 0, SPACE(SX3->X3_TAMANHO)))
	cRet  := cInic
EndIf

If !Empty(cChave) .And. IIf(lInclui .And. Type("Inclui") <> "U", !Inclui, .T.)
	IIf((cAlias)->(IndexOrd()) == nOrdem, .T., (cAlias)->(DbSetOrder(nOrdem)))
	If (cAlias)->(DbSeek(cChvPesq, lSoftSeek)) .And. cCampo <> Nil .And. !Empty(cCampo)
		cRet := (cAlias)->(FieldGet(FieldPos(cCampo)))
		If !Empty(cChvURel)
			(cAlias)->(DbSkip())
			cRet := IIf((cAlias)->(Eof()) .Or. &(cChvComp) <> cChvPesq, cRet, cInic)
		Endif
	EndIf
EndIf

U_ResArea(aAreaSX3)
If !Empty(cAliasOld)
	DbSelectArea(cAliasOld)
Endif
Return(cRet)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ MsgInf   บAutor  ณ Andr้ Cruz         บ Data ณ  09/16/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Explode uma mensagem de alerta na tela.                    บฑฑ
ฑฑบ          ณ Utilizada pela BDados                                      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function MsgInf(cMsgErro, cTitulo, cRotina)
Local oDlgMsg, oTexto, oBtnOk
Local cReadVar := IIF(Type("__ReadVar") <> "U".And. !Empty(__ReadVar), __ReadVar, "") //Guarda o conteudo do ReadVar porque o SetFocus limpa essa variavel

DEFINE MSDIALOG oDlgMsg FROM	62,100 TO 320,510 TITLE OemToAnsi(cTitulo) PIXEL

@ 003, 004 TO 027, 200 LABEL "Help" OF oDlgMsg PIXEL //
@ 030, 004 TO 110, 200 OF oDlgMsg PIXEL

@ 010, 008 MSGET OemToAnsi(cRotina) WHEN .F. SIZE 188, 010 OF oDlgMsg PIXEL

@ 036, 008 GET oTexto VAR OemToAnsi(cMsgErro) MEMO READONLY /*NO VSCROLL*/ SIZE 188, 070 OF oDlgMsg PIXEL

oBtnOk := tButton():New(115, 170, "Ok", oDlgMsg, {|| oDlgMsg:End()},,,,,,.T.)
oBtnOk:SetFocus()

ACTIVATE MSDIALOG oDlgMsg CENTERED

If !Empty(cReadVar)
	__ReadVar := cReadVar
EndIf

Return(Nil)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ MsgInf   บAutor  ณ Andr้ Cruz         บ Data ณ  09/16/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Retorna o c๓digo do ํndice que ้ utilizado na SIX.         บฑฑ
ฑฑบ          ณ Utilizada pela BDados                                      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function CInd(nInd)
Local cInd := " "
Local cIndOrd := "123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"

cInd := SubStr(cIndOrd, nInd, 1)
Return(cInd)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ MsgInf   บAutor  ณ Andr้ Cruz         บ Data ณ  09/16/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Conta a quantidade de um determinado caracter na string    บฑฑ
ฑฑบ          ณ passada pelo parametro cString.                            บฑฑ
ฑฑบ          ณ Utilizada pela BDados                                      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function CntChr(cString, cChr)
Local nChr := 0, nCnt := 0
For nChr := 0 To Len(cString)
	If SubStr(cString, nChr, 1) == cChr
		nCnt++
	EndIf
Next
Return(nCnt)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ GrvCpo   บAutor  ณ Andr้ Cruz         บ Data ณ  09/16/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Grava autmoaticamente os registros que sใo apresentados    บฑฑ
ฑฑบ          ณ na tela.                                                   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function GrvCpo(cAliasGrv,aColsGrv,aHeaderGrv,ni)
Local bCampo3   := { |nCPO| FieldName(nCPO) }
Local cSavAlias := Alias()
Local nCpoMem   := 0, cCampoGrv := "", nxi, nix
Local cPrefix   := Iif( SubStr(cAliasGrv, 1, 1) == 'S', SubStr(cAliasGrv, 2, 2), cAliasGrv )
	DbSelectArea(cAliasGrv)
	
	If aColsGrv == NIL
		For nxi := 1 to FCount()
			If Type("M->"+(EVAL(bCampo3,nxi))) != "U"
				&(EVAL(bCampo3, nxi)) := M->&(EVAL(bCampo3, nxi))
			EndIf
		Next
		&(Alltrim(cAliasGrv)+"->"+cPrefix+"_FILIAL")  := xFilial(cAliasGrv)
		
		aMemos := U_AMemos(cAliasGrv)
		
		If Type("aMemos") == "A" .And. Len(aMemos) > 0 .And. Upper(SubStr(aMemos[1, 1], 1, At("_", aMemos[1, 1]) - 1)) == Upper(cAliasGrv)
			For nCpoMem := 1 To Len(aMemos)
				cCampoGrv := aMemos[nCpoMem, 2]
				DbSelectArea("SX3")
				DbSetOrder(2)
				DbSeek(cCampoGrv)
				DbSelectArea(cAliasGrv)
				If SX3->X3_TIPO == "M" .And. SX3->X3_CONTEXT == "V" .And. Type("M->" + cCampoGrv) <> "U"
					MSMM(, TamSx3(cCampoGrv)[1],, &("M->" + cCampoGrv), 1,,, cAliasGrv, aMemos[nCpoMem, 1])
				EndIf
			Next
		EndIf
	Else
		For nix := 1 to Len(aHeaderGrv)
			&(aHeaderGrv[nix,2]) := aColsGrv[ni,nix]
		Next
	EndIf
	
	DbSelectArea(cSavAlias)
Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ AMemos   บAutor  ณ Andr้ Cruz         บ Data ณ  09/16/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Trata o conte๚do de campos Memo Virtuais e Reais.          บฑฑ
ฑฑบ          ณ Utilizada pela GrvCpo                                      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function AMemos(cAliasSx3)
Local aMemos := {}
Local cAliasOld := Alias()
Local nOrderSx3, nRecSx3, nCodObsF

	DbSelectArea("SX3")
	nOrderSx3 := IndexOrd()
	DbSetOrder(1)
	nRecSx3 := RecNo()
	DbSeek(cAliasSx3)

	While !Eof() .and. SX3->X3_ARQUIVO == cAliasSx3

		If SX3->X3_CONTEXT == "V" .And. SX3->X3_TIPO == "M"

			If (nCodObs := AT(cAliasSx3 + "_", SX3->X3_RELACAO)) > 0

				nCodObsF := At(",", SX3->X3_RELACAO)
				If nCodObsF == 0
					nCodObsF := At(")", SX3->X3_RELACAO)
				EndIf
				nCodObsF := nCodObsF - (nCodObs - 1) - 1
				aAdd(aMemos, {Upper(AllTrim(SubStr(SX3->X3_RELACAO, nCodObs, nCodObsF))), AllTrim(SX3->X3_CAMPO)})

			EndIf

		EndIf
		DbSkip()

	End

	DbGoTo(nRecSx3)
	DbSetOrder(nOrderSx3)
	DbSelectArea(cAliasOld)
Return(aMemos)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFuno    ณ  NextSeq      ณ Autor ณ Andr้ Cruz       ณ Data ณ 20100910 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescricao ณ  Encontra a proxima sequencia para um c๓digo numa tabela   ณฑฑ
ฑฑณ          ณ  qualquer, utilizando um semaforo mutex quando ้ criada a  ณฑฑ
ฑฑณ          ณ  tabela ZZT, com condi็ใo de filtro para valores           ณฑฑ
ฑฑณ          ณ  dependentes de dados.                                     ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ Uso      ณ  AP                                                        ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static lExistZZT := .F.

User Function NextSeq( cFld, cSeqBase, nLen, cFiltro )
Local aArea     := GetArea()
Local cSeq      := ""
Local cPref     := SubStr(cFld, 1, At("_", cFld)-1)
Local cTbl      := Iif(At("_", cFld) == 3, "S", "") + cPref
Local cDatabase := TCGetDb()
Local lExistFld := .F.
Local cSql      := ""
Default cSeqBase := "" // StrZero(1, TamSX3(cFld)[1])
Default nLen     := TamSX3(cFld)[1]
Default cFiltro  := ""

DbSelectArea("SX2")
DbSetOrder(1) // X2_CHAVE

If ( lExistZZT := DbSeek("ZZT") )
   DbSelectArea("ZZT")
   DbSetOrder(1)
EndIf

DbSelectArea("SX3")
DbSetOrder(2) // X3_CAMPO
lExistFld := DbSeek(cFld)

While !LockByName("U_NextSeq"+cEmpAnt+xFilial(cTbl))
   Inkey(1)
End
   

If lExistFld
   cSql += " SELECT MAX(" + cFld + ") SEQ " 
   cSql += "   FROM " + RetSqlName(cTbl) + " 
   cSql += "  WHERE D_E_L_E_T_ = ' ' " 
   cSql += "    AND " + cPref + "_FILIAL = '" + xFilial(cTbl) + "' "
   If !Empty(cFiltro)
      cSql += "    AND ( " + cFiltro + " ) "
   EndIf
   If !Empty(cSeqBase)
      If "ORACLE" $ cDatabase 
         cSql += "    AND SUBSTR( " + cFld + ", 1, " + Str(Len(AllTrim(cSeqBase))) + " ) = '" + cSeqBase + "' "
      ElseIf "MSSQL" $ cDatabase
         cSql += "    AND SUBSTRING( " + cFld + ", 1, " + Str(Len(AllTrim(cSeqBase))) + " ) = '" + cSeqBase + "' "
      Else
	      Final("A fun็ใo 'U_NextSeq' nใo foi implementada para o banco de dados " + cDatabase + ". Entre em contato com o Administrador. " + CRLF + CRLF + "O Protheus serแ finalizado.")
      EndIf
   EndIf
EndIf

If lExistZZT
   If lExistFld
      cSql += "  UNION ALL "
   EndIf
   cSql += " SELECT MAX(ZZT_VALOR) SEQ"
   cSql += "   FROM " + RetSqlName("ZZT") + " "
   cSql += "  WHERE D_E_L_E_T_ = ' ' "
   cSql += "    AND ZZT_CAMPO = '" + cFld + "' "
   If !Empty(cFiltro)
      cSql += "    AND ZZT_FILTRO = '" + StrTran(cFiltro, "'", "{ASP}") + "' "
   EndIf
EndIf

If !Empty(cSeqBase)
   If "ORACLE" $ cDatabase 
      cSql += "    AND SUBSTR( ZZT_VALOR, 1, " + Str(Len(AllTrim(cSeqBase))) + " ) = '" + cSeqBase + "' "
   ElseIf "MSSQL" $ cDatabase
      cSql += "    AND SUBSTRING( ZZT_VALOR, 1, " + Str(Len(AllTrim(cSeqBase))) + " ) = '" + cSeqBase + "' "
   Else
      Final("A fun็ใo 'U_NextSeq' nใo foi implementada para o banco de dados " + cDatabase + ". Entre em contato com o Administrador. " + CRLF + CRLF + "O Protheus serแ finalizado.")
   EndIf
EndIf
   cSql += " ORDER BY 1 DESC "

   DbUseArea( .T., "TOPCONN", TcGenQry(,,cSql), "NXTSEQ", .T., .F. )

   cSeq := SubStr(NXTSEQ->SEQ, Len(cSeqBase)+1, nLen )

   NXTSEQ->(DbCloseArea())

   cSeq :=  AllTrim(cSeqBase + Iif( Empty(cSeq), StrZero( 1, nLen ), Soma1( cSeq ) ))
   
   If lExistZZT
      DbSelectArea("ZZT")
      DbSetOrder(1) // ZZT_FILIAL+ZZT_CAMPO+ZZT_FILTRO+ZZT_VALOR
      RecLock("ZZT", .T.)
         ZZT->ZZT_FILIAL := xFilial(cTbl)
         ZZT->ZZT_CAMPO  := cFld
         ZZT->ZZT_FILTRO := StrTran(cFiltro, "'", "{ASP}")
         ZZT->ZZT_VALOR  := cSeq
      MsUnlock()
   EndIf

   UnlockByName("U_NextSeq"+cEmpAnt+xFilial(cTbl))
   
RestArea(aArea)
Return cSeq



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCloseSeq  บAutor  ณMicrosiga           บ Data ณ  02/09/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Finaliza o semaforo descartando o valor, quando nใo utilizaบฑฑ
ฑฑบ          ณ do.                                                        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function CloseSeq(cFld, cFiltro, cValor)
Local aArea     := GetArea()
Local cPref     := SubStr(cFld, 1, At("_", cFld)-1)
Local cTbl      := Iif(At("_", cFld) == 3, "S", "") + cPref

Default cFiltro := ""

If lExistZZT
   While !LockByName("U_NextSeq"+cEmpAnt+xFilial(cTbl))
      Inkey(1)
   End
   
   DbSelectArea("ZZT")
   DbSetOrder(1) // ZZT_FILIAL+ZZT_CAMPO+ZZT_FILTRO+ZZT_VALOR
   If ZZT->(DbSeek(xFilial(cTbl)+PadR(cFld, Len(SX3->X3_CAMPO))+PadR(StrTran(cFiltro, "'", "{ASP}"), TamSX3("ZZT_FILTRO")[1])+cValor))
      RecLock("ZZT", .F.)
      DBDelete()
   	  MsUnlock()
   EndIf
   UnlockByName("U_NextSeq"+cEmpAnt+xFilial(cTbl))

   RestArea(aArea)
EndIf
Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ AMemos   บAutor  ณ Andr้ Cruz         บ Data ณ  09/16/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Carrega as rela็๕es de Join a partir do dicionario de dadosบฑฑ
ฑฑบ          ณ Utilizada pela Fun็ใo BDados.                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function IsJoin(cX3Relacao)
 Local lRet     := .F.
 Local cX3Alias := ""
 
 cX3Relacao := StrTran(Upper(cX3Relacao), " ", "")
 
 If     "POSICIONE("  $ StrTran(Upper(SX3->X3_RELACAO), " ", "")
  lRet := .T.
  cX3Alias := SubStr(cX3Relacao, At("POSICIONE(", cX3Relacao) + 11, 3)
  
 ElseIf "U_INIPADR(" $ StrTran(Upper(SX3->X3_RELACAO), " ", "")
  lRet := .T.
  cX3Alias := SubStr(cX3Relacao, At("U_INIPADR(", cX3Relacao) + 12, 3)
  
 ElseIf "U_X3RELAC(" $ StrTran(Upper(SX3->X3_RELACAO), " ", "")
  lRet := .T.
  cX3Alias := SubStr(cX3Relacao, At("U_X3RELAC(", cX3Relacao) + 12, 3)
  
 EndIf
            
 // Caso a origem seja um dicionแrio nใo faz o join
 If lRet .And. cX3Alias <> "SX5" .And. (SubStr(cX3Alias, 1, 2) == "SX" .Or. cX3Alias == "SIX")
  lRet := .F.
 EndIf 
 
Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณProcVal   บAutor  ณAndr้ Cruz          บ Data ณ  07/10/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณProcura na pilha a rotina passada no parametro.             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function ProcVal(cFuncao)
Local lRet       := .f.
Local nConta     := 0
 
While !lRet .AND. !Empty(Alltrim(ProcName(nConta)))

 lRet := Upper(cFuncao) $ Upper(ProcName(nConta))
 nConta++

EndDo
 
Return( lRet )


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ PosSX1   บAutor  ณ Andr้ Cruz         บ Data ณ  10/18/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Altara o conte๚do padrใo de um campo de pergunta no SX1.   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function PosSX1(aChave)
 Local aArea      := GetArea()
 Local nLenChave  := Len(aChave)
 Local nForChave  := 0
 Local nForSX1    := 0
 Local cP_Defs    := ""
 Local cP_DefsTmp := ""
 Local nPFLin     := 0
 Local lProfAlias := Select("PROFALIAS") > 0
 Local nPosGrupo  := 1
 Local nPosOrdem  := 2
 Local nPosCont   := 3

 For nForChave := 1 To nLenChave

  If aChave[nForChave][nPosCont] == Nil 
   aChave[nForChave][nPosCont] := Space(SX1->X1_TAMANHO)
  EndIf

  If lProfAlias
   DBSelectArea("PROFALIAS")
   DbSetOrder(1)
   If DbSeek(PadR(AllTrim(cUserName)          , Len(PROFALIAS->P_NAME)) + ;
             PadR(aChave[nForChave][nPosGrupo], Len(PROFALIAS->P_PROG)) + ;
             PadR("PERGUNTE"                  , Len(PROFALIAS->P_TASK)) + ;
             PadR("MV_PAR"                    , Len(PROFALIAS->P_TYPE)))

    cP_DefsTmp := PROFALIAS->P_DEFS
	  
    While !Empty(cP_DefsTmp)
    
     nPFLin := At(Chr(13) + Chr(10), cP_DefsTmp)
	  
     If  nForSx1 == Val(aChave[nForChave][nPosOrdem])
      cP_Defs += SubStr(cP_DefsTmp, 1, 4) + aChave[nForChave][nPosCont] + Chr(13) + Chr(10)
     Else 
      cP_Defs += SubStr(cP_DefsTmp, 1, nPFLin + 1)
     EndIf 

     cP_DefsTmp := SubStr(cP_DefsTmp, nPFLin + 2)
     nForSx1++
    
    End
	  
    RecLock("PROFALIAS", .F.)
    PROFALIAS->P_DEFS := cP_Defs
    MsUnLock() 
   Else 
    PosSx1(PADR(aChave[nForChave][nPosGrupo], Len(SX1->X1_GRUPO))+aChave[nForChave][nPosOrdem], aChave[nForChave][nPosCont])
   EndIf
  Else	                         
   PosSx1(PADR(aChave[nForChave][nPosGrupo], Len(SX1->X1_GRUPO))+aChave[nForChave][nPosOrdem], aChave[nForChave][nPosCont])
  EndIf
 Next nForChave

 RestArea(aArea)
Return(Nil)



Static Function PosSx1(cChave, xConteudo)
 Local nForSx1 := 0
 
 DbSelectArea("SX1")
 DbSetOrder(1) // X1_GRUPO + X1_ORDEM           
 If DbSeek(cChave)	
  If Type("xConteudo") == "A"
   For nForSx1 := 1 To Len(xConteudo)
    RecLock("SX1", .F.)
    &(xConteudo[nForSx1][1]) := xConteudo[nForSx1][2]
    MsUnLock()
   Next
  Else
   RecLock("SX1", .F.)
   SX1->X1_CNT01 := xConteudo
   MsUnLock()
  EndIf
 EndIf
Return(Nil)	 


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ AToS     บAutor  ณ Andr้ Cruz         บ Data ณ  10/18/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Converte uma matriz numa string.                           บฑฑ
ฑฑบ          ณ Pode ser usado para simula็ใo de serializa็ใo no protheus  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function AToS(aArray)

Local cArray    := ""
Local nLenArray := Len(aArray)
Local i

If ValType(aArray) == 'A'
	
	cArray += '{ '
	
	For i := 1 To nLenArray
		If ValType(aArray[i]) == 'U'
			cArray += 'Nil'
		ElseIf ValType(aArray[i]) == 'C'
			If At( '"', aArray[i] ) > 0
				cArray += "'" + aArray[i] + "'"
			Else
				cArray += '"' + aArray[i] + '"'
			EndIf
		ElseIf ValType(aArray[i]) == 'N'
			cArray +=  AllTrim(Str(aArray[i]))
		ElseIf ValType(aArray[i]) == 'D'
			cArray +=  'CToD("' + DToC(aArray[i]) + '")'
		ElseIf ValType(aArray[i]) == 'L'
			cArray +=  Iif(aArray[i],'.T.', '.F.')
		ElseIf ValType(aArray[i]) == 'A'
			cArray +=  U_AToS(aArray[i])
		EndIf
		If i != nLenArray
			cArray += ', '
		EndIf
	Next
	
	cArray += ' }'
EndIf

Return cArray


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ InSql    บAutor  ณ Andr้ Cruz         บ Data ณ  11/30/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Formata uma condi็ใo SQL para utiliza็ใo com comando IN.   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function InSql( cString, xVar )
Local cInString  := ""
Local nLen 
Local cChar
Default xVar       := 1

If ValType(xVar) == 'N'
	nLen := xVar
ElseIf ValType(xVar) == 'C'
	cChar := xVar
Else
	ConOut("[inSql] Conte๚do do parametro 2 ้ invแlido.")
	Return Nil
EndIf

If cChar != Nil
	While ( nLen := At(cChar, cString) ) > 0
		cInString += Iif(!Empty(cInString), ",'", " '") + SubStr(cString, 1, nLen-1) + "' "
		cString := SubStr(cString, nLen+1)
	End
	If !Empty( cString )
		cInString += Iif(Empty(cInString), ",'", " '") + cString + "' "
	EndIf
Else
    For i:= 1 To Len( cString ) Step nLen
		cInString += Iif(!Empty(cInString), ",'", " '") + SubStr(cString, i, nLen) + "' "
    End
EndIf

Return cInString



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ AReplace บAutor  ณ Andr้ Cruz         บ Data ณ  12/10/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Substitui um valor numa matriz.                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function AReplace(aMat, xVal, xRepl, lAll, lRet)
Local nLen       := Len(aMat)
Local i
Default lRet       := .F.
Default lAll       := .F.

   For i := 1 To nLen
      If ValType(aMat[i]) == "A"
         If !lAll .AND. ( lRet := U_AReplace(aMat[i], xVal, xRepl, lAll, lRet) )
            Exit
         EndIf
      ElseIf ValType(xVal) == ValType(aMat[i]) .AND. xVal == aMat[i]
         aMat[i] := xRepl
         lRet := .T.                                                           
         If !lAll
            Exit
         EndIf
      EndIf
   Next

Return lRet



uSER fuNCTION cRIAtAB()
U_RunFunc("U_ct()","99", "01")
return Nil

User Function CT()
DbSelectArea("ZZW")
DbSetOrder(1)
Return Nil


