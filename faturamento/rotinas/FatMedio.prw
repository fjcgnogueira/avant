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

Local cFatProd  := GetNextAlias()
Local cProdSem  := GetNextAlias()
Local dDataDe   
Local dDataAte  

Private _lSchedule := aParam[1]

ConOut("["+DtoC(Date())+" "+Time()+"] [FatMedio] Inicio")

// Caso seja disparado via workflow
If _lSchedule
	PREPARE ENVIRONMENT EMPRESA aParam[2] FILIAL aParam[3]
Endif

dDataDe  := FirstDay(LastDay(dDataBase)-366)
dDataAte := FirstDay(dDataBase)-1

// Total do Faturamento por Produto
BeginSql alias cFatProd
	
	SELECT D2_COD PRODUTO, ROUND(SUM(D2_QUANT)/12,1) FAT_MEDIO FROM %table:SF2% SF2
	INNER JOIN %table:SD2% SD2 ON F2_FILIAL = D2_FILIAL AND F2_DOC = D2_DOC AND F2_SERIE = D2_SERIE AND F2_CLIENTE = D2_CLIENTE AND F2_LOJA = D2_LOJA AND SD2.%notDel%
	INNER JOIN %table:SF4% SF4 ON D2_FILIAL = F4_FILIAL AND D2_TES = F4_CODIGO AND F4_ESTOQUE = 'S' AND F4_DUPLIC = 'S' AND SF4.%notDel%
	WHERE SF2.%notDel% AND F2_FILIAL = %xfilial:SF2% AND F2_EMISSAO BETWEEN %exp:DTOS(dDataDe)% AND %exp:DTOS(dDataAte)%
	GROUP BY D2_COD
	ORDER BY D2_COD

EndSql

(cFatProd)->(dbGoTop())

//ConOut(GetLastQuery()[2])

// Produtos sem faturamento nos ultimos 12 meses
BeginSql alias cProdSem
	
	SELECT B1_COD PRODUTO FROM %table:SB1% SB1
	WHERE SB1.%notDel% AND B1_COD NOT IN
	(SELECT D2_COD FROM %table:SF2% SF2
	INNER JOIN %table:SD2% SD2 ON F2_FILIAL = D2_FILIAL AND F2_DOC = D2_DOC AND F2_SERIE = D2_SERIE AND F2_CLIENTE = D2_CLIENTE AND F2_LOJA = D2_LOJA AND SD2.%notDel%
	INNER JOIN %table:SF4% SF4 ON D2_FILIAL = F4_FILIAL AND D2_TES = F4_CODIGO AND F4_ESTOQUE = 'S' AND F4_DUPLIC = 'S' AND SF4.%notDel%
	WHERE SF2.%notDel% AND F2_FILIAL = %xfilial:SF2% AND F2_EMISSAO BETWEEN %exp:DTOS(dDataDe)% AND %exp:DTOS(dDataAte)%
	GROUP BY D2_COD)
	AND B1_X_FTMED > 0
	ORDER BY PRODUTO

EndSql

(cProdSem)->(dbGoTop())

// Definicao do Faturamento Medio
While !(cFatProd)->(Eof())
	
	SB1->(dbSeek(xFilial('SB1')+(cFatProd)->PRODUTO))
	
	If SB1->B1_X_FTMED <> (cFatProd)->FAT_MEDIO
		SB1->(RecLock('SB1',.F.))
			SB1->B1_X_FTMED := (cFatProd)->FAT_MEDIO
		SB1->(MsUnlock())
	Endif
	
	(cFatProd)->(dbSkip())
End

// Zeramento dos Produtos sem Faturamento
While !(cProdSem)->(Eof())
	
	SB1->(dbSeek(xFilial('SB1')+(cProdSem)->PRODUTO))
	
	If SB1->B1_X_FTMED <> 0
		SB1->(RecLock('SB1',.F.))
			SB1->B1_X_FTMED := 0
		SB1->(MsUnlock())
	Endif
	
	(cProdSem)->(dbSkip())
End

(cFatProd)->(dbCloseArea())
(cProdSem)->(dbCloseArea())

// Caso seja disparado via workflow
If _lSchedule
	RESET ENVIRONMENT
Endif

ConOut("["+DtoC(Date())+" "+Time()+"] [FatMedio] Fim")

Return