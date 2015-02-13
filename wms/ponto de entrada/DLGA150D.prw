#INCLUDE "PROTHEUS.CH"
#INCLUDE 'APVT100.CH'
#INCLUDE 'INKEY.CH'
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ DLGA150D º Autor ³ Fernando Nogueira  º Data ³ 08/03/2014  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de Entrada antes do Estorno do Servico               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Avant                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function DLGA150D()

Local _aArea   := GetArea()
Local _cChave  := ""
Local _cDoc    := AllTrim(ParamIXB[3])
Local _cSerie  := AllTrim(ParamIXB[4])
Local aAreaSC9 := SC9->(GetArea())
Local aAreaSC5 := SC5->(GetArea())

SC9->(dbSelectArea("SC9"))
SC9->(dbSetOrder(01))

_cChave := xFilial("SC9")+_cDoc+_cSerie

SC9->(dbSeek(_cChave))

dbSelectArea("SC5")
dbSetOrder(01)
dbGoTop()
dbSeek(xFilial("SC5")+SC9->C9_PEDIDO)

If SC5->C5_VOLUME1 <> 0
	If SC5->(RecLock("SC5",.F.))
		SC5->C5_VOLUME1	:= 0
		SC5->(MsUnlock())
	Else
		ApMsgInfo("Registro Bloqueado")
	Endif
Endif

While SC9->(!Eof()) .And. xFilial("SC9")+SC9->C9_PEDIDO+SC9->C9_ITEM == _cChave .And. SC9->C9_XCONF <> 'N'
	SC9->(RecLock("SC9",.F.))
	SC9->C9_XCONF := "N"
	SC9->(MsUnLock())
	SC9->(dbSkip())
End

SC5->(RestArea(aAreaSC5))
SC9->(RestArea(aAreaSC9))
RestArea(_aArea)

Return .T.