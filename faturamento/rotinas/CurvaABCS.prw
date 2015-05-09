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
Local nQtdTotal := 0
Local nVlrTotal := 0
Local nVlrA     := 0
Local nVlrB     := 0
Local nSoma     := 0

Private _lSchedule  := aParam[1]

// Caso seja disparado via workflow
If _lSchedule
	PREPARE ENVIRONMENT EMPRESA aParam[2] FILIAL aParam[3]
Endif

dbSelectArea('SB1')
dbGoTop()

// Total do Faturamento dos Ultimos 6 Meses
BeginSql alias cAliasTOT
	
	SELECT SUM(D2_QUANT) QUANT, SUM(D2_TOTAL) VALOR FROM %table:SF2% SF2
	INNER JOIN %table:SD2% SD2 ON F2_FILIAL = D2_FILIAL AND F2_DOC = D2_DOC AND F2_SERIE = D2_SERIE AND F2_CLIENTE = D2_CLIENTE AND F2_LOJA = D2_LOJA AND SD2.%notDel%
	INNER JOIN %table:SF4% SF4 ON D2_FILIAL = F4_FILIAL AND D2_TES = F4_CODIGO AND F4_ESTOQUE = 'S' AND F4_DUPLIC = 'S' AND SF4.%notDel%
	WHERE SF2.%notDel% AND F2_FILIAL = %xfilial:SF2% AND F2_EMISSAO BETWEEN %exp:DTOS(Date()-180)% AND %exp:DTOS(Date())%

EndSql

nQtdTotal := (cAliasTOT)->QUANT
nVlrTotal := (cAliasTOT)->VALOR
nVlrA     := nVlrTotal * 0.7
nVlrB     := nVlrTotal * 0.2

// Total do Faturamento dos Ultimos 6 Meses por Produto
BeginSql alias cAliasPRD

	SELECT D2_COD PRODUTO, SUM(D2_QUANT) QUANT, SUM(D2_TOTAL) VALOR FROM %table:SF2% SF2
	INNER JOIN %table:SD2% SD2 ON F2_FILIAL = D2_FILIAL AND F2_DOC = D2_DOC AND F2_SERIE = D2_SERIE AND F2_CLIENTE = D2_CLIENTE AND D2_LOJA = F2_LOJA AND SD2.%notDel%
	INNER JOIN %table:SF4% SF4 ON D2_FILIAL = F4_FILIAL AND D2_TES = F4_CODIGO AND F4_ESTOQUE = 'S' AND F4_DUPLIC = 'S' AND SF4.%notDel%
	WHERE SF2.%notDel% AND F2_FILIAL = %xfilial:SF2% AND F2_EMISSAO BETWEEN %exp:DTOS(Date()-180)% AND %exp:DTOS(Date())%
	GROUP BY D2_COD
	ORDER BY VALOR DESC

EndSql

(cAliasPRD)->(dbGoTop())

// Produtos no Estoque que nao tiveram movimentacao nos ultimos 6 meses
BeginSql alias cAliasSEM

	SELECT B1_COD PRODUTO FROM %table:SB2%  SB2
	INNER JOIN %table:SB1% SB1 ON B2_COD = B1_COD AND SB1.%notDel%
	WHERE SB2.%notDel% AND B2_FILIAL = %xfilial:SB2% AND B2_QATU > 0
	AND B2_COD NOT IN
	(SELECT D2_COD PRODUTO FROM %table:SF2% SF2
	INNER JOIN %table:SD2% SD2 ON F2_FILIAL = D2_FILIAL AND F2_DOC = D2_DOC AND F2_SERIE = D2_SERIE AND F2_CLIENTE = D2_CLIENTE AND D2_LOJA = F2_LOJA AND SD2.%notDel%
	INNER JOIN %table:SF4% SF4 ON D2_FILIAL = F4_FILIAL AND D2_TES = F4_CODIGO AND F4_ESTOQUE = 'S' AND F4_DUPLIC = 'S' AND SF4.%notDel%
	WHERE SF2.%notDel% AND F2_FILIAL = %xfilial:SF2% AND F2_EMISSAO BETWEEN %exp:DTOS(Date()-180)% AND %exp:DTOS(Date())%
	GROUP BY D2_COD)
	ORDER BY PRODUTO

EndSql

(cAliasSEM)->(dbGoTop())

// Definicao da Curva, Quantidade e Valor nos Produtos
While !(cAliasPRD)->(Eof())

	nSoma += (cAliasPRD)->VALOR

	SB1->(dbSeek(xFilial('SB1')+(cAliasPRD)->PRODUTO))
	
	If nSoma <= nVlrA
		If SB1->B1_X_CURVA <> 'A'
			SB1->(RecLock('SB1',.F.))
				SB1->B1_X_CURVA := 'A'
			SB1->(MsUnlock())
		Endif
	ElseIf nSoma <= nVlrA + nVlrB
		If SB1->B1_X_CURVA <> 'B'
			SB1->(RecLock('SB1',.F.))
				SB1->B1_X_CURVA := 'B'
			SB1->(MsUnlock())
		Endif
	Else
		If SB1->B1_X_CURVA <> 'C'
			SB1->(RecLock('SB1',.F.))
				SB1->B1_X_CURVA := 'C'
			SB1->(MsUnlock())
		Endif
	Endif
	
	If SB1->B1_X_QTD <> (cAliasPRD)->QUANT
		SB1->(RecLock('SB1',.F.))
			SB1->B1_X_QTD := (cAliasPRD)->QUANT
		SB1->(MsUnlock())
	Endif
	
	If SB1->B1_X_VLR <> (cAliasPRD)->VALOR
		SB1->(RecLock('SB1',.F.))
			SB1->B1_X_VLR := (cAliasPRD)->VALOR
		SB1->(MsUnlock())
	Endif
	
	(cAliasPRD)->(dbSkip())

End

// Definicao dos Produtos Sem Movimentacao
While !(cAliasSEM)->(Eof())

	SB1->(dbSeek(xFilial('SB1')+(cAliasSEM)->PRODUTO))
	
	If SB1->B1_X_CURVA <> 'S'
		SB1->(RecLock('SB1',.F.))
			SB1->B1_X_CURVA := 'S'
			SB1->B1_X_QTD   := 0
			SB1->B1_X_VLR   := 0
		SB1->(MsUnlock())
	Endif

	(cAliasSEM)->(dbSkip())

End

Return