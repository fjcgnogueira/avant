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

Local   cTes     := ""
Local   cCondPag := ""
Local   cNota    := Space(09)
Local   cSerie   := "1  "

Private aPVlNFs  := {}

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณaParam     |  [01]   |  [02]  |
	//ณ           | Empresa | Filial |
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
PREPARE ENVIRONMENT EMPRESA aParam[1] FILIAL aParam[2]

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
			(SELECT C6_NUM PEDIDO,CASE WHEN ISNULL(SC9.C9_ITEM,'SL') = 'SL' THEN 'SL' ELSE 'OK' END C9_OK FROM %table:SC5% SC5
			INNER JOIN (SELECT C9_PEDIDO FROM %table:SC9% SC9
							WHERE SC9.%notDel% AND C9_FILIAL = %xfilial:SC9% AND C9_BLCRED = ' ' AND C9_BLEST = ' ' 
							AND (C9_BLWMS = '05' AND C9_XCONF = 'S' OR C9_BLWMS = ' ')
						GROUP BY C9_PEDIDO) PED
						ON C5_NUM = PED.C9_PEDIDO
			INNER JOIN %table:SC6% SC6 ON C5_FILIAL = C6_FILIAL AND C5_NUM = C6_NUM AND SC6.%notDel%
			LEFT  JOIN (SELECT C9_PEDIDO,C9_ITEM,SUM(C9_QTDLIB) C9_QTDLIB FROM %table:SC9% SC9
							WHERE SC9.%notDel% AND C9_FILIAL = %xfilial:SC9% AND C9_BLCRED = ' ' AND C9_BLEST = ' ' 
							AND (C9_BLWMS = '05' AND C9_XCONF = 'S' OR C9_BLWMS = ' ')
						GROUP BY C9_PEDIDO,C9_ITEM) SC9 
						ON C6_NUM = SC9.C9_PEDIDO AND C6_ITEM = C9_ITEM AND C6_QTDVEN = C9_QTDLIB
			WHERE SC5.%notDel% AND C5_FILIAL = %xfilial:SC5% AND C5_LIBEROK <> ' ' AND C5_NOTA = ' ' AND C5_BLQ = ' ') PED_A_FATURAR
		PIVOT (COUNT(C9_OK) FOR C9_OK IN (SL,OK)) PED_CONFERENCIA) CONFERIDOS
	WHERE SL = 0

EndSql

TRB->(dbGoTop())

// Gera as Notas Fiscais referentes aos Pedidos Liberados
While TRB->(!EoF())

	SC9->(dbSetOrder(01))
	SC9->(dbGoTop())
	SC9->(dbSeek(xFilial("SC9")+TRB->PEDIDO))
	
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
	
	cNota := MaPvlNfs(aPVlNFs,cSerie,.F.,.F.,.T.,.F.,.F.,1,1,.T.,.F.,,,)
	
	ConOut("Gerada a Nota: "+cNota)
	
	TRB->(dbSkip())
End

RESET ENVIRONMENT

Return