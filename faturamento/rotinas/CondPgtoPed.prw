#INCLUDE "Protheus.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออออัอออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCondPgtoPed บ Autor ณ Fernando Nogueira บ Data ณ  17/04/2017 บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออออฯอออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Retorna as Condicoes de Pagto dos Pedidos parados no creditoบฑฑ
ฑฑบ          ณ Chamado 003926                                              บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico Avant                                            บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
User Function CondPgtoPed(cCliente,cLoja)

_aArea     := GetArea()
_cCondPgto := ""
_cCliente  := cCliente
_cLoja     := cLoja
_nCount    := 0

GeraArqTRB()

TRB->(DbSelectArea('TRB'))
TRB->(DbGotop())

While TRB->(!Eof())
	_nCount++
	
	If _nCount > 1
		_cCondPgto += "; "
	Endif
	
	_cCondPgto += AllTrim(TRB->COND_PED)
	TRB->(dbSkip())
End

TRB->(DbCloseArea())

RestArea(_aArea)

Return Left(_cCondPgto,TamSx3("A1_X_CPGTO")[1])

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGeraArqTRBบAutor  ณ Fernando Nogueira  บ Data ณ 18/07/2014  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFuncao Auxiliar                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function GeraArqTRB()

	BeginSql alias 'TRB'
	
		SELECT CLIENTE,LOJA,COND_CLI,COND_PED FROM
			(SELECT C5_NUM NUMERO,A1_COND,CLI.E4_DESCRI COND_CLI,C5_CONDPAG,SE4.E4_DESCRI COND_PED,C5_CLIENTE CLIENTE,C5_LOJACLI LOJA,C5_XTOTPED TOTAL FROM %table:SC5% SC5
			INNER JOIN %table:SC9% SC9 ON C5_FILIAL = C9_FILIAL AND C5_NUM = C9_PEDIDO AND C9_BLCRED <> ' ' AND C9_BLOQUEI = ' ' AND SC9.%notDel%
			INNER JOIN %table:SA1% SA1 ON C5_CLIENTE+C5_LOJACLI = A1_COD+A1_LOJA AND SA1.%notDel%
			INNER JOIN %table:SE4% SE4 ON C5_CONDPAG = SE4.E4_CODIGO AND SE4.%notDel%
			LEFT JOIN %table:SE4% CLI ON A1_COND = CLI.E4_CODIGO AND CLI.%notDel%
			WHERE C5_FILIAL = %exp:xFilial("SC5")% AND C5_NOTA = ' ' AND C5_BLQ = ' ' AND C5_X_BLQ NOT IN ('S','C') AND C5_X_BLQFI <> 'S' AND SC5.%notDel% AND C5_CLIENTE = %exp:_cCliente% AND C5_LOJACLI = %exp:_cLoja%
			GROUP BY C5_NUM,A1_COND,CLI.E4_DESCRI,C5_CONDPAG,SE4.E4_DESCRI,C5_CLIENTE,C5_LOJACLI,C5_XTOTPED) PED_BLQCRED
		GROUP BY CLIENTE,LOJA,COND_CLI,COND_PED
		ORDER BY CLIENTE,LOJA,COND_CLI,COND_PED

	EndSql

Return()
