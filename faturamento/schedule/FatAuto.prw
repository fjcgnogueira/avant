#INCLUDE "PROTHEUS.CH"
#INCLUDE "TbiConn.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ FatAuto  บ Autor ณ Fernando Nogueira  บ Data ณ 08/07/2015  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Rotina para faturamento automatico via schedule            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico Avant                                           บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function FatAuto(aParam)

Local cTes      := ""
Local cCondPag  := ""
Local cNota     := Space(09)
Local cSerie    := "1  "
Local lFatAut   := .T.
Local lTempExec := .T.
Local nMarcaAnt := 0
Local nMarcaAtu := 0
Local nMarcaApo := 0
Local aAreaSX5  := ""
Local cAliasSDB := GetNextAlias()

Private aPVlNFs  := {}

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณaParam     |  [01]   |  [02]  |
	//ณ           | Empresa | Filial |
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

PREPARE ENVIRONMENT EMPRESA aParam[1] FILIAL aParam[2]

SET CENTURY ON

// Fernando Nogueira - Ajuste de Ok da Conferencia - Chamado 005674
BeginSQL Alias cAliasSDB
	SELECT SC9.R_E_C_N_O_ SC9RECNO FROM %table:SDB% SDB
	INNER JOIN %table:SC9% SC9 ON DB_FILIAL = C9_FILIAL AND DB_DOC = C9_PEDIDO AND DB_SERIE = C9_ITEM AND DB_PRODUTO = C9_PRODUTO AND SC9.%notDel%
	WHERE SDB.D_E_L_E_T_ = ''
		AND DB_FILIAL = %Exp:xFilial("SDB")%
		AND SDB.%notDel%
		AND DB_TAREFA = '003'
		AND DB_TIPO = 'E' 
		AND DB_ESTORNO = ''
		AND DB_STATUS = '1'
		AND C9_XCONF <> 'S'
	ORDER BY SC9RECNO	
EndSQL

(cAliasSDB)->(dbGoTop())

dbSelectArea("SC9")

While (cAliasSDB)->(!Eof())
	SC9->(dbGoTo((cAliasSDB)->SC9RECNO))
	SC9->(RecLock("SC9",.F.))
		SC9->C9_XCONF := 'S'
	SC9->(MsUnlock())
	ConOut("["+DtoC(Date())+" "+Time()+"] [FatAuto] Acerto Conferencia do Pedido/Item: "+SC9->(C9_PEDIDO+"/"+C9_ITEM))	
	(cAliasSDB)->(dbSkip())
End

(cAliasSDB)->(dbCloseArea())

lFatAut   := &(Posicione("SX5",1,xFilial("SX5")+"ZA0005","X5_DESCRI"))

nMarcaAnt := Val(Posicione("SX5",1,xFilial("SX5")+"ZA0006","X5_DESCRI"))
nMarcaAtu := Val(DtoS(dDataBase) + StrZero(Seconds()*1000,08))

SX5->(DbSetOrder(01))
If SX5->(dbSeek(xFilial("SX5")+"ZA0006"))
	SX5->(RecLock("SX5",.F.))
		SX5->X5_DESCRI := cValToChar(nMarcaAtu)
	SX5->(MsUnlock())
Endif

Sleep(2000)

nMarcaApo := Val(Posicione("SX5",1,xFilial("SX5")+"ZA0006","X5_DESCRI"))

If !lFatAut
	ConOut("["+DtoC(Date())+" "+Time()+"] [FatAuto] Faturamento automแtico desabilitado")

// Fernando Nogueira - Chamado 004061
Elseif nMarcaAtu <= (nMarcaAnt + 240000) .And. nMarcaAtu <> nMarcaApo
	ConOut("["+DtoC(Date())+" "+Time()+"] [FatAuto] Tempo entre a execu็ใo atual e a anterior ้ inferior a 4 minutos")

Else

	// Tabelas utilizadas
	dbSelectArea("SC5")
	dbSelectArea("SB1")
	dbSelectArea("SB2")
	dbSelectArea("SF4")
	dbSelectArea("SE4")
	dbSelectArea("SC6")
	dbSelectArea("SC9")

	BeginSql alias 'TRB'

		SELECT PEDIDO FROM
			(SELECT * FROM
				(SELECT C6_NUM PEDIDO,A1_X_FATPA FATPA,CASE WHEN SC9.C9_BLCRED = ' ' AND SC9.C9_BLEST = ' ' AND ((SC9.C9_BLWMS = '05' AND SC9.C9_XCONF = 'S') OR SC9.C9_BLWMS = ' ') AND (C6_QTDVEN = SC9.C9_QTDLIB OR A1_X_FATPA = 'S') THEN 'OK' ELSE 'BL' END C9_LIB FROM %table:SC5% SC5
				INNER JOIN %table:SA1% SA1 ON C5_CLIENTE+C5_LOJACLI = A1_COD+A1_LOJA AND SA1.%notDel%
				INNER JOIN (SELECT C9_PEDIDO,C9_BLWMS FROM %table:SC9% SC9
								WHERE SC9.%notDel% AND C9_FILIAL = %xfilial:SC9% AND C9_BLCRED = ' ' AND C9_BLEST = ' '
								AND ((C9_BLWMS = '05' AND C9_XCONF = 'S') OR C9_BLWMS = ' ')
							GROUP BY C9_PEDIDO,C9_BLWMS) PED
							ON C5_NUM = PED.C9_PEDIDO AND ((C9_BLWMS = '05' AND C5_VOLUME1 > 0) OR C9_BLWMS = ' ')
				INNER JOIN %table:SC6% SC6 ON C5_FILIAL = C6_FILIAL AND C5_NUM = C6_NUM AND SC6.%notDel%
				LEFT  JOIN (SELECT C9_PEDIDO,C9_ITEM,C9_BLCRED,C9_BLEST,C9_BLWMS,C9_XCONF,SUM(C9_QTDLIB) C9_QTDLIB FROM %table:SC9% SC9
								WHERE SC9.%notDel% AND C9_FILIAL = %xfilial:SC9% AND C9_BLCRED <> '10'
							GROUP BY C9_PEDIDO,C9_ITEM,C9_BLCRED,C9_BLEST,C9_BLWMS,C9_XCONF) SC9
							ON C6_NUM = SC9.C9_PEDIDO AND C6_ITEM = C9_ITEM
				WHERE SC5.%notDel% AND C5_FILIAL = %xfilial:SC5% AND C5_NOTA = ' ' AND C5_BLQ = ' ' AND C5_X_BLQ NOT IN ('S','C') AND C5_X_BLQFI <> 'S' AND C5_X_BLFIN <> 'S' AND NOT (COALESCE(SC9.C9_ITEM,'SL') = 'SL' AND A1_X_FATPA = 'S')) PED_A_FATURAR
			PIVOT (COUNT(C9_LIB) FOR C9_LIB IN (BL,OK)) PED_CONFERENCIA) CONFERIDOS
			WHERE BL = 0
		ORDER BY PEDIDO

	EndSql

	TRB->(dbGoTop())

	// Gera as Notas Fiscais referentes aos Pedidos Liberados
	While TRB->(!EoF())

		SC9->(dbSetOrder(01))
		SC9->(dbGoTop())
		SC9->(dbSeek(xFilial("SC9")+TRB->PEDIDO))

		aPVlNFs  := {}

		While SC9->(!Eof()) .And. SC9->C9_PEDIDO == TRB->PEDIDO

			cTes     := Posicione("SC6",1,xFilial("SC6")+SC9->C9_PEDIDO+SC9->C9_ITEM,"C6_TES")
			cCondPag := Posicione("SC5",1,xFilial("SC5")+SC9->C9_PEDIDO,"C5_CONDPAG")

			aadd(aPvlNfs,{	SC9->C9_PEDIDO,;
							SC9->C9_ITEM,;
							SC9->C9_SEQUEN,;
							SC9->C9_QTDLIB,;
							SC9->C9_PRCVEN,;
							SC9->C9_PRODUTO,;
							Posicione("SF4",1,xFilial("SF4")+cTes,"F4_ISS")=="S",;
							SC9->(RecNo()),;
							SC5->(Recno(Posicione("SC5",1,xFilial("SC5")+SC9->C9_PEDIDO,""))),;
							SC6->(Recno(Posicione("SC6",1,xFilial("SC6")+SC9->C9_PEDIDO+SC9->C9_ITEM,""))),;
							SE4->(Recno(Posicione("SE4",1,xFilial("SE4")+cCondPag,""))),;
							SB1->(Recno(Posicione("SB1",1,xFilial("SB1")+SC9->C9_PRODUTO,""))),;
							SB2->(Recno(Posicione("SB2",1,xFilial("SB2")+SC9->C9_PRODUTO+SC9->C9_LOCAL,""))),;
							SF4->(Recno(Posicione("SF4",1,xFilial("SF4")+cTes,"")))})

			SC9->(dbSkip())
		End

		/*/
		ฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		ณParametrosณExpA1: Array com os itens a serem gerados                                                 ณ
		ณ          ณExpC2: Serie da Nota Fiscal                                                               ณ
		ณ          ณExpL3: Mostra Lct.Contabil                                                                ณ
		ณ          ณExpL4: Aglutina Lct.Contabil                                                              ณ
		ณ          ณExpL5: Contabiliza On-Line                                                                ณ
		ณ          ณExpL6: Contabiliza Custo On-Line                                                          ณ
		ณ          ณExpL7: Reajuste de preco na nota fiscal                                                   ณ
		ณ          ณExpN8: Tipo de Acrescimo Financeiro                                                       ณ
		ณ          ณExpN9: Tipo de Arredondamento                                                             ณ
		ณ          ณExpLA: Atualiza Amarracao Cliente x Produto                                               ณ
		ณ          ณExplB: Cupom Fiscal                                                                       ณ
		ณ          ณExpCC: Numero do Embarque de Exportacao                                                   ณ
		ณ          ณExpBD: Code block para complemento de atualizacao dos titulos financeiros.                ณ
		ณ          ณExpBE: Code block para complemento de atualizacao dos dados apos a geracao da nota fiscal.ณ
		ณ          ณExpBF: Code Block de atualizacao do pedido de venda antes da geracao da nota fiscal       ณ
		ภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		/*/

		cNota := MaPvlNfs(aPVlNFs,cSerie,.F.,.F.,.T.,.F.,.F.,1,1,.F.,.F.,,,)

		Sleep(20000)

		ConOut("["+DtoC(Date())+" "+Time()+"] [FatAuto] Gerada a Nota: "+cNota)

		aAreaSX5  := SX5->(GetArea())

		SX5->(DbSetOrder(01))
		If SX5->(dbSeek(xFilial("SX5")+"ZA0006"))
			SX5->(RecLock("SX5",.F.))
				SX5->X5_DESCRI := DtoS(dDataBase) + StrZero(Seconds()*1000,08)
			SX5->(MsUnlock())
		Endif

		SX5->(RestArea(aAreaSX5))

		TRB->(dbSkip())
	End

	If Empty(cNota)
		ConOut("["+DtoC(Date())+" "+Time()+"] [FatAuto] Nenhuma nota a gerar")
	Endif

Endif

RESET ENVIRONMENT

Return
