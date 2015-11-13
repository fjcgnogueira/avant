#INCLUDE "PROTHEUS.CH"
#INCLUDE "TbiConn.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ FatMedio() º Autor ³ Fernando Nogueira º Data ³ 03/11/2015 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Faturamento Medio dos Produtos (Periodo de um ano)         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Avant                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function FatMedio(aParam)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³aParam     |  [01]    |  [02]   |  [03]  |
//³           | Schedule | Empresa | Filial |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
// Exexutar no Formulas -> U_FatMedio({.F.})
// Exexutar no Schedule -> U_FatMedio(.T.)

Local nFatMedio

Private _lSchedule := aParam[1]

ConOut("["+DtoC(Date())+" "+Time()+"] [FatMedio] Inicio")

// Caso seja disparado via workflow
If _lSchedule
	PREPARE ENVIRONMENT EMPRESA aParam[2] FILIAL aParam[3]
Endif

dbSelectArea("SB1")
dbSetOrder(1)
dbGoTop()

// Definicao do Faturamento Medio
While SB1->(!Eof())

	If FatAnt(SB1->B1_COD,SB1->B1_X_DTULT)
		nFatMedio := MedProd(SB1->B1_COD)
	Else
		nFatMedio := MedProd(SB1->B1_COD,SB1->B1_X_DTULT)
	Endif
	
	If SB1->B1_X_FTMED <> nFatMedio
		SB1->(RecLock('SB1',.F.))
			SB1->B1_X_FTMED := nFatMedio
		SB1->(MsUnlock())
	Endif

	SB1->(dbSkip())
End

// Caso seja disparado via workflow
If _lSchedule
	RESET ENVIRONMENT
Endif

ConOut("["+DtoC(Date())+" "+Time()+"] [FatMedio] Fim")

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MedProd()  º Autor ³ Fernando Nogueira º Data ³ 04/11/2015 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Faturamento Medio Por Produto                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function MedProd(cProd,dDataRef)

Local cFatProd  := GetNextAlias()
Local dDataAte  := FirstDay(dDataBase)-1
Local dDataDe   := FirstDay(LastDay(dDataBase)-185) // 6 meses
Local nFatMed   := 0
Local nDivisor  := 6

If !Empty(dDataRef)
	If dDataRef > dDataDe
		dDataDe := dDataRef
		nDivisor := Round((dDataAte-dDataDe)/30,0)
		If Round((dDataAte-dDataDe)/30,0) < 1
			nDivisor := 1
		Endif
	Endif
Endif

// Total do Faturamento por Produto
BeginSql alias cFatProd
	
	SELECT ROUND(SUM(D2_QUANT)/%exp:nDivisor%,1) FAT_MEDIO FROM %table:SF2% SF2
	INNER JOIN %table:SD2% SD2 ON F2_FILIAL = D2_FILIAL AND F2_DOC = D2_DOC AND F2_SERIE = D2_SERIE AND F2_CLIENTE = D2_CLIENTE AND F2_LOJA = D2_LOJA AND SD2.%notDel%
	INNER JOIN %table:SF4% SF4 ON D2_FILIAL = F4_FILIAL AND D2_TES = F4_CODIGO AND F4_ESTOQUE = 'S' AND F4_DUPLIC = 'S' AND SF4.%notDel%
	WHERE SF2.%notDel% AND F2_FILIAL = %xfilial:SF2% AND F2_EMISSAO BETWEEN %exp:DTOS(dDataDe)% AND %exp:DTOS(dDataAte)% AND D2_COD = %exp:cProd%

EndSql

(cFatProd)->(dbGoTop())

If (cFatProd)->(!Eof())
	nFatMed := (cFatProd)->FAT_MEDIO
Endif
(cFatProd)->(dbCloseArea())

Return nFatMed

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ FatAnt()   º Autor ³ Fernando Nogueira º Data ³ 04/11/2015 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Faturamento Anterior do Produto                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function FatAnt(cProd,dDataRef)

Local cFatAnt  := GetNextAlias()
Local dDataDe  := FirstDay(LastDay(dDataBase)-185)
Local dDataAte := dDataRef-1


// Total do Faturamento por Produto
BeginSql alias cFatAnt
	
	SELECT D2_COD PRODUTO FROM %table:SF2% SF2
	INNER JOIN %table:SD2% SD2 ON F2_FILIAL = D2_FILIAL AND F2_DOC = D2_DOC AND F2_SERIE = D2_SERIE AND F2_CLIENTE = D2_CLIENTE AND F2_LOJA = D2_LOJA AND SD2.%notDel%
	INNER JOIN %table:SF4% SF4 ON D2_FILIAL = F4_FILIAL AND D2_TES = F4_CODIGO AND F4_ESTOQUE = 'S' AND F4_DUPLIC = 'S' AND SF4.%notDel%
	WHERE SF2.%notDel% AND F2_FILIAL = %xfilial:SF2% AND F2_EMISSAO BETWEEN %exp:DTOS(dDataDe)% AND %exp:DTOS(dDataAte)% AND D2_COD = %exp:cProd%
	GROUP BY D2_COD

EndSql

(cFatAnt)->(dbGoTop())

If (cFatAnt)->(!Eof())
	(cFatAnt)->(dbCloseArea())
	Return .T.	
Endif
(cFatAnt)->(dbCloseArea())

Return .F.