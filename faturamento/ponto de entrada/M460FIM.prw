#INCLUDE "Protheus.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³M460FIM   º Autor ³ Rodrigo Leite      º Data ³  01/11/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Atualiza titulo no Contas a Receber SE1, e grava o campo   º±±
±±º          ³ Regional com o codigo da regional do Cliente               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Avant                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function M460FIM()

aArea		:= GetArea()
_aAreaSE1 	:= getArea("SE1")
_aAreaSF2 	:= getArea("SF2")
_aAreaSD2 	:= getArea("SD2")
_aAreaSC5 	:= getArea("SC5")
_aAreaSC6 	:= getArea("SC6")
_aAreaSA3 	:= getArea("SA3")
_aAreaSB1 	:= getArea("SB1")
_aAreaSBM 	:= getArea("SBM")
_aAreaZZF 	:= getArea("ZZF")
_cNota      := ""
_cSerie     := ""

nDescTot    := 0
nCredito    := 0
nDebito     := 0
nVlrTotal   := 0
nRamo       := 0
nVlOri      := 0

dbSelectArea("SE1")
dbSetOrder(2)
dbSeek(xFilial("SE1")+SF2->F2_CLIENTE+SF2->F2_LOJA+SF2->F2_SERIE+SF2->F2_DOC)

While !Eof() .And. 	SE1->E1_FILIAL == xFilial("SE1") .And.;
	SE1->E1_CLIENTE == SF2->F2_CLIENTE .And.;
	SE1->E1_LOJA ==SF2->F2_LOJA .And. ;
	SE1->E1_PREFIXO == SF2->F2_SERIE .And. ;
	SE1->E1_NUM == SF2->F2_DOC

	RecLock("SE1",.F.)
		SE1->E1_REGIAO := Posicione("SA1",1,xfilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA,"A1_REGIAO")
	MsUnlock()

	dbSkip()
EndDo


dbSelectArea("SF2")
dbSetOrder(2)
dbSeek(xFilial("SF2")+SF2->F2_CLIENTE+SF2->F2_LOJA+SF2->F2_DOC+SF2->F2_SERIE)

_cNota      := SF2->F2_DOC
_cSerie     := SF2->F2_SERIE
_cCliente   := SF2->F2_CLIENTE
_cLoja      := SF2->F2_LOJA

While !Eof() .And. 	SF2->F2_FILIAL == xFilial("SF2") .And.;
	 SF2->F2_DOC ==_cNota .AND. SF2->F2_SERIE == _cSerie

	RecLock("SF2",.F.)
		SF2->F2_REGIAO  := Posicione("SA1",1,xfilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA,"A1_REGIAO")
		SF2->F2_X_CANAL := Posicione("SA1",1,xfilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA,"A1_SATIV1")
		SF2->F2_X_SEGME := Posicione("SA1",1,xfilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA,"A1_SATIV2")
		SF2->F2_X_PERFI := Posicione("SA1",1,xfilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA,"A1_SATIV4")
		SF2->F2_X_IMP   := 'N'
	MsUnlock()

	dbSkip()
EndDo

dbSelectArea("SC5")
dbSetOrder(1)
dbSelectArea("SC6")
dbSetOrder(1)
dbSelectArea("SA3")
dbSetOrder(1)

dbSelectArea("SF2")
dbSetOrder(1)
dbGoTop()
dbSeek(xFilial("SF2")+_cNota+_cSerie+_cCliente+_cLoja)

dbSelectArea("SD2")
dbSetOrder(3)
dbGoTop()
dbSeek(xFilial("SD2")+_cNota+_cSerie+_cCliente+_cLoja)

While SD2->(!Eof()) .And. 	SD2->D2_FILIAL == xFilial("SD2") .And. SD2->D2_DOC ==_cNota .AND. SD2->D2_SERIE == _cSerie

	nDescTot := 0
	nCredito := 0
	nDebito  := 0

	SD2->(RecLock("SD2",.F.))
		SD2->D2_X_VEND := SC5->C5_VEND1
		SD2->D2_REGIAO := Posicione("SA1",1,xfilial("SA1")+SD2->D2_CLIENTE+SD2->D2_LOJA,"A1_REGIAO")
	SD2->(MsUnlock())

	// Fernando Nogueira - Credito para Bonificacao
	SC5->(dbSeek(xFilial("SC5")+SD2->D2_PEDIDO))
	SC6->(dbSeek(xFilial("SC6")+SD2->D2_PEDIDO+SD2->D2_ITEMPV))
	SA3->(dbSeek(xFilial("SA3")+SC5->C5_VEND1))
	SB1->(dbSeek(xFilial("SB1")+SD2->D2_COD))
	SBM->(dbSeek(xFilial("SBM")+SB1->B1_GRUPO))
	ZZF->(dbSeek(xFilial("ZZF")+SB1->B1_FAMAVAN))

	// Fernando Nogueira - Alimenta Volume na Nota de Saida
	If SF2->F2_VOLUME1 <> SC5->C5_VOLUME1
		SF2->(RecLock("SF2",.F.))
			SF2->F2_VOLUME1 := SC5->C5_VOLUME1
		SF2->(MsUnlock())
	Endif

	nRamo  := Iif(SC6->C6_X_RAMO  = 0, SA1->A1_DESCWEB               , SC6->C6_X_RAMO)
	nVlOri := Iif(SC6->C6_X_VLORI = 0, SB1->B1_PRV1 * (1 - nRamo/100), SC6->C6_X_VLORI)

	If AllTrim(SC6->C6_TPOPERW) == 'VENDAS' .And. SC6->C6_X_GERE < SA3->A3_X_DSCGE .And. nRamo < 19 .And. SBM->BM_BLCRVND == 'N' .And. ZZF->ZZF_BLCRVN == 'N'

		// Fernando Nogueira - Pega o preco de venda, caso ele seja maior que o de lista
		If nVlOri <= SD2->D2_PRCVEN
			nDescTot  := (SD2->D2_PRCVEN * (1 - SA3->A3_X_DSCGE/100)) * SD2->D2_QUANT
		Else
			nDescTot  := (nVlOri * (1 - SA3->A3_X_DSCGE/100)) * SD2->D2_QUANT
		Endif

		nVlrTotal := SD2->D2_TOTAL
		nCredito  := nVlrTotal - nDescTot

		// Credito Maior Igual 1, eliminando os arredondamentos
		If nCredito >= 1 .And. nDescTot > 0
			SD2->(RecLock("SD2",.F.))
				SD2->D2_X_TPOPE := SC6->C6_TPOPERW
				SD2->D2_X_CRVEN := nCredito
			SD2->(MsUnlock())

			SA3->(RecLock("SA3",.F.))
				SA3->A3_ACMMKT += nCredito
			SA3->(MsUnlock())
		Endif
	ElseIf AllTrim(SC6->C6_TPOPERW) == 'BONIFICACAO'
		nDebito := SD2->D2_VALBRUT

		SD2->(RecLock("SD2",.F.))
			SD2->D2_X_TPOPE := SC6->C6_TPOPERW
			SD2->D2_X_CRVEN := nDebito
		SD2->(MsUnlock())
		SA3->(RecLock("SA3",.F.))
			SA3->A3_ACMMKT -= nDebito
		SA3->(MsUnlock())
	Endif

	SD2->(dbSkip())
EndDo

SE1->(DBCLOSEAREA())
SF2->(DBCLOSEAREA())
SD2->(DBCLOSEAREA())

Restarea(_aAreaSE1)
Restarea(_aAreaSC5)
Restarea(_aAreaSC6)
Restarea(_aAreaSA3)
Restarea(_aAreaSB1)
Restarea(_aAreaSBM)
Restarea(_aAreaZZF)
RestArea(aArea)

Return
