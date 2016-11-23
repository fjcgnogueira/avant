#INCLUDE "PROTHEUS.CH"
#INCLUDE "TbiConn.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ CurvaABCS()  º Autor ³ Fernando Nogueira º Data ³ 09/05/15 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Definicao de Curva ABCS dos Produtos                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Avant                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function CurvaABCS(aParam)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³aParam     |  [01]    |  [02]   |  [03]  |
//³           | Schedule | Empresa | Filial |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
// Exexutar no Formulas -> U_CURVAABCS({.F.})
// Exexutar no Schedule -> U_CURVAABCS(.T.)

Local cAliasTOT := GetNextAlias()
Local cAliasPRD := GetNextAlias()
Local cAliasSEM := GetNextAlias()
Local cAliasENT := GetNextAlias()
Local cAliasZER := GetNextAlias()
Local cAliasABC := GetNextAlias()
Local nQtdTotal := 0
Local nVlrTotal := 0
Local nVlrA     := 0
Local nVlrB     := 0
Local nSoma     := 0
Local lRecente  := .F.
Local nQtdEst   := 0
Local dDataAte
Local dDataDe

Private _lSchedule  := aParam[1]

// Caso seja disparado via workflow
If _lSchedule
	PREPARE ENVIRONMENT EMPRESA aParam[2] FILIAL aParam[3]
Endif

SET CENTURY ON

ConOut("["+DtoC(Date())+" "+Time()+"] [CurvaABCS] Inicio")

dDataAte  := FirstDay(dDataBase)-1
dDataDe   := dDataDe := FirstDay(LastDay(dDataBase)-Val(Posicione("SX5",1,xFilial("SX5")+"ZA"+"0003","X5_DESCRI")))

dbSelectArea('SB1')
dbGoTop()

// Total do Faturamento dos Ultimos Meses Estabelecidos
BeginSql alias cAliasTOT

	SELECT SUM(D2_QUANT) QUANT, SUM(D2_TOTAL) VALOR FROM %table:SF2% SF2
	INNER JOIN %table:SD2% SD2 ON F2_FILIAL = D2_FILIAL AND F2_DOC = D2_DOC AND F2_SERIE = D2_SERIE AND F2_CLIENTE = D2_CLIENTE AND F2_LOJA = D2_LOJA AND SD2.%notDel%
	INNER JOIN %table:SF4% SF4 ON D2_FILIAL = F4_FILIAL AND D2_TES = F4_CODIGO AND F4_ESTOQUE = 'S' AND F4_DUPLIC = 'S' AND SF4.%notDel%
	WHERE SF2.%notDel% AND F2_FILIAL = %xfilial:SF2% AND F2_EMISSAO BETWEEN %exp:DTOS(dDataDe)% AND %exp:DTOS(dDataAte)%

EndSql

ConOut("["+DtoC(Date())+" "+Time()+"] [CurvaABCS] Query Total Faturamento de "+DTOC(dDataDe)+" até "+DTOC(dDataAte))
ConOut("["+DtoC(Date())+" "+Time()+"] [CurvaABCS] " + GetLastQuery()[2])

nQtdTotal := (cAliasTOT)->QUANT
nVlrTotal := (cAliasTOT)->VALOR
nVlrA     := nVlrTotal * 0.7
nVlrB     := nVlrTotal * 0.2

// Total do Faturamento por Produto dos Ultimos Meses Estabelecidos
BeginSql alias cAliasPRD

	SELECT D2_COD PRODUTO, SUM(D2_QUANT) QUANT, SUM(D2_TOTAL) VALOR FROM %table:SF2% SF2
	INNER JOIN %table:SD2% SD2 ON F2_FILIAL = D2_FILIAL AND F2_DOC = D2_DOC AND F2_SERIE = D2_SERIE AND F2_CLIENTE = D2_CLIENTE AND D2_LOJA = F2_LOJA AND SD2.%notDel%
	INNER JOIN %table:SF4% SF4 ON D2_FILIAL = F4_FILIAL AND D2_TES = F4_CODIGO AND F4_ESTOQUE = 'S' AND F4_DUPLIC = 'S' AND SF4.%notDel%
	WHERE SF2.%notDel% AND F2_FILIAL = %xfilial:SF2% AND F2_EMISSAO BETWEEN %exp:DTOS(dDataDe)% AND %exp:DTOS(dDataAte)%
	GROUP BY D2_COD
	ORDER BY VALOR DESC

EndSql

ConOut("["+DtoC(Date())+" "+Time()+"] [CurvaABCS] Query Total Faturamento por Produto de "+DTOC(dDataDe)+" até "+DTOC(dDataAte))
ConOut("["+DtoC(Date())+" "+Time()+"] [CurvaABCS] " + GetLastQuery()[2])

(cAliasPRD)->(dbGoTop())

// Produtos no Estoque que nao tiveram movimentacao nos Ultimos Meses Estabelecidos
BeginSql alias cAliasSEM

	SELECT B1_COD PRODUTO FROM %table:SB2%  SB2
	INNER JOIN %table:SB1% SB1 ON B2_COD = B1_COD AND SB1.%notDel%
	WHERE SB2.%notDel% AND B2_FILIAL = %xfilial:SB2% AND B2_QATU > 0
	AND B2_COD NOT IN
	(SELECT D2_COD PRODUTO FROM %table:SF2% SF2
	INNER JOIN %table:SD2% SD2 ON F2_FILIAL = D2_FILIAL AND F2_DOC = D2_DOC AND F2_SERIE = D2_SERIE AND F2_CLIENTE = D2_CLIENTE AND D2_LOJA = F2_LOJA AND SD2.%notDel%
	INNER JOIN %table:SF4% SF4 ON D2_FILIAL = F4_FILIAL AND D2_TES = F4_CODIGO AND F4_ESTOQUE = 'S' AND F4_DUPLIC = 'S' AND SF4.%notDel%
	WHERE SF2.%notDel% AND F2_FILIAL = %xfilial:SF2% AND F2_EMISSAO BETWEEN %exp:DTOS(dDataDe)% AND %exp:DTOS(dDataAte)%
	GROUP BY D2_COD)
	ORDER BY PRODUTO

EndSql

ConOut("["+DtoC(Date())+" "+Time()+"] [CurvaABCS] Query Produtos que não tiveram movimentação de "+DTOC(dDataDe)+" até "+DTOC(dDataAte))
ConOut("["+DtoC(Date())+" "+Time()+"] [CurvaABCS] " + GetLastQuery()[2])

(cAliasSEM)->(dbGoTop())

// Importacoes por produto nos Ultimos Meses Estabelecidos
BeginSql alias cAliasENT

	SELECT D1_COD PRODUTO, SUM(D1_QUANT) QUANT FROM %table:SF1% SF1
	INNER JOIN %table:SD1% SD1 ON F1_FILIAL = D1_FILIAL AND F1_DOC = D1_DOC AND F1_SERIE = D1_SERIE AND F1_FORNECE = D1_FORNECE AND F1_LOJA = D1_LOJA AND SD1.%notDel%
	INNER JOIN %table:SF4% SF4 ON D1_FILIAL = F4_FILIAL AND D1_TES = F4_CODIGO AND F4_ESTOQUE = 'S' AND SF4.%notDel%
	WHERE SF1.%notDel% AND F1_FILIAL = %xfilial:SF1% AND F1_FORMUL = 'S' AND F1_EST = 'EX' AND F1_DTDIGIT BETWEEN %exp:DTOS(dDataDe)% AND %exp:DTOS(dDataAte)%
	GROUP BY D1_COD
	ORDER BY PRODUTO

EndSql

ConOut("["+DtoC(Date())+" "+Time()+"] [CurvaABCS] Query Importações por produto de "+DTOC(dDataDe)+" até "+DTOC(dDataAte))
ConOut("["+DtoC(Date())+" "+Time()+"] [CurvaABCS] " + GetLastQuery()[2])

(cAliasENT)->(dbGoTop())


// Produtos S zerados, devem sair da curva S
BeginSql alias cAliasZER

	SELECT * FROM
	(SELECT B1_COD PRODUTO, SUM(B2_QATU) QATU FROM %table:SB2% SB2
	INNER JOIN %table:SB1% SB1 ON B2_COD = B1_COD AND SB1.%notDel%
	WHERE SB2.%notDel% AND B2_FILIAL = %xfilial:SB2% AND B1_X_CURVA = 'S'
	GROUP BY B1_COD) TODOS_ARM
	WHERE QATU = 0
	ORDER BY PRODUTO

EndSql

ConOut("["+DtoC(Date())+" "+Time()+"] [CurvaABCS] Query Produtos S zerados ")
ConOut("["+DtoC(Date())+" "+Time()+"] [CurvaABCS] " + GetLastQuery()[2])

(cAliasZER)->(dbGoTop())

// Produtos ABC que nao estao nos Ultimos Meses Estabelecidos
BeginSql alias cAliasABC

	SELECT B1_COD PRODUTO FROM %table:SB1% SB1
	WHERE SB1.%notDel% AND B1_X_CURVA IN ('A','B','C') AND B1_COD NOT IN
	(SELECT D2_COD PRODUTO FROM %table:SF2% SF2
	INNER JOIN %table:SD2% SD2 ON F2_FILIAL = D2_FILIAL AND F2_DOC = D2_DOC AND F2_SERIE = D2_SERIE AND F2_CLIENTE = D2_CLIENTE AND D2_LOJA = F2_LOJA AND SD2.%notDel%
	INNER JOIN %table:SF4% SF4 ON D2_FILIAL = F4_FILIAL AND D2_TES = F4_CODIGO AND F4_ESTOQUE = 'S' AND F4_DUPLIC = 'S' AND SF4.%notDel%
	WHERE SF2.%notDel% AND F2_FILIAL = %xfilial:SF2% AND F2_EMISSAO BETWEEN %exp:DTOS(dDataDe)% AND %exp:DTOS(dDataAte)%
	GROUP BY D2_COD)
	ORDER BY PRODUTO

EndSql

ConOut("["+DtoC(Date())+" "+Time()+"] [CurvaABCS] Query Produtos ABC que nao estao dentro de "+DTOC(dDataDe)+" até "+DTOC(dDataAte))
ConOut("["+DtoC(Date())+" "+Time()+"] [CurvaABCS] " + GetLastQuery()[2])

(cAliasABC)->(dbGoTop())

// Definicao da Curva, Quantidade e Valor nos Produtos
While !(cAliasPRD)->(Eof())

	nSoma += (cAliasPRD)->VALOR

	SB1->(dbSeek(xFilial('SB1')+(cAliasPRD)->PRODUTO))

	SB1->(RecLock('SB1',.F.))

		If nSoma <= nVlrA
			If SB1->B1_X_CURVA <> 'A'
				SB1->B1_X_CURVA := 'A'
			Endif
		ElseIf nSoma <= nVlrA + nVlrB
			If SB1->B1_X_CURVA <> 'B'
				SB1->B1_X_CURVA := 'B'
			Endif
		Else
			If SB1->B1_X_CURVA <> 'C'
				SB1->B1_X_CURVA := 'C'
			Endif
		Endif

		If SB1->B1_X_QTD <> (cAliasPRD)->QUANT
			SB1->B1_X_QTD := (cAliasPRD)->QUANT
		Endif

		If SB1->B1_X_VLR <> (cAliasPRD)->VALOR
			SB1->B1_X_VLR := (cAliasPRD)->VALOR
		Endif

		If SB1->B1_X_DTULT <> UltDtEnt((cAliasPRD)->PRODUTO)
			SB1->B1_X_DTULT := UltDtEnt((cAliasPRD)->PRODUTO)
		Endif

	SB1->(MsUnlock())

	(cAliasPRD)->(dbSkip())
End

// Definicao dos Produtos Sem Movimentacao
While !(cAliasSEM)->(Eof())

	lRecente  := .F.

	SB1->(dbSeek(xFilial('SB1')+(cAliasSEM)->PRODUTO))

	(cAliasENT)->(dbGoTop())

	// Verifica se teve entrada do produto nos Ultimos Meses Estabelecidos
	While !(cAliasENT)->(Eof())
		If (cAliasENT)->PRODUTO == (cAliasSEM)->PRODUTO
			lRecente  := .T.
			Exit
		Endif
		(cAliasENT)->(dbSkip())
	End

	SB1->(RecLock('SB1',.F.))
		If lRecente
			If SB1->B1_X_CURVA <> 'R'
				SB1->B1_X_CURVA := 'R'
				SB1->B1_X_QTD   := 0
				SB1->B1_X_VLR   := 0
			Endif
		ElseIf SB1->B1_X_CURVA <> 'S'
			SB1->B1_X_CURVA := 'S'
			SB1->B1_X_QTD   := 0
			SB1->B1_X_VLR   := 0
		Endif
		If SB1->B1_X_DTULT <> UltDtEnt((cAliasSEM)->PRODUTO)
			SB1->B1_X_DTULT := UltDtEnt((cAliasSEM)->PRODUTO)
		Endif
	SB1->(MsUnlock())

	(cAliasSEM)->(dbSkip())
End

// Limpando a curva dos produtos S sem saldo
While !(cAliasZER)->(Eof())

	SB1->(dbSeek(xFilial('SB1')+(cAliasZER)->PRODUTO))

	SB1->(RecLock('SB1',.F.))
		SB1->B1_X_CURVA := ' '
	SB1->(MsUnlock())

	(cAliasZER)->(dbSkip())
End

// Limpando a curva dos produtos ABC que naum estao no faturamento dos Ultimos Meses Estabelecidos
While !(cAliasABC)->(Eof())

	SB1->(dbSeek(xFilial('SB1')+(cAliasABC)->PRODUTO))

	SB1->(RecLock('SB1',.F.))
		SB1->B1_X_CURVA := ' '
	SB1->(MsUnlock())

	(cAliasABC)->(dbSkip())
End

(cAliasTOT)->(dbCloseArea())
(cAliasPRD)->(dbCloseArea())
(cAliasSEM)->(dbCloseArea())
(cAliasENT)->(dbCloseArea())
(cAliasZER)->(dbCloseArea())
(cAliasABC)->(dbCloseArea())

ConOut("["+DtoC(Date())+" "+Time()+"] [CurvaABCS] Fim")

// Caso seja disparado via workflow
If _lSchedule
	RESET ENVIRONMENT
Endif

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ UltDtEnt()   º Autor ³ Fernando Nogueira º Data ³ 27/10/15 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Data da Ultima Entrada de nota do Produto                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Avant                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function UltDtEnt(cProduto)

Local cAliasULT := GetNextAlias()
Local dData     := STOD("20100101")

BeginSql alias cAliasULT

	SELECT TOP 1 D1_DTDIGIT FROM %table:SF1% SF1
	INNER JOIN %table:SD1% SD1 ON F1_FILIAL = D1_FILIAL AND F1_DOC = D1_DOC AND F1_SERIE = D1_SERIE AND F1_FORNECE = D1_FORNECE AND F1_LOJA = D1_LOJA AND SD1.%notDel%
	INNER JOIN %table:SF4% SF4 ON D1_FILIAL = F4_FILIAL AND D1_TES = F4_CODIGO AND F4_ESTOQUE = 'S' AND SF4.%notDel%
	WHERE SF1.%notDel% AND F1_FILIAL = %xfilial:SF1% AND F1_FORMUL = 'S' AND F1_EST = 'EX'
		AND D1_COD = %exp:cProduto%
	ORDER BY D1_DTDIGIT DESC

EndSql

(cAliasULT)->(dbGoTop())

If (cAliasULT)->(!Eof())
	dData := STOD((cAliasULT)->D1_DTDIGIT)
Endif

(cAliasULT)->(dbCloseArea())

Return dData
