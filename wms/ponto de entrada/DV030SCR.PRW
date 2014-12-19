#INCLUDE "PROTHEUS.CH"
#INCLUDE 'APVT100.CH'
#INCLUDE 'INKEY.CH'
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ DV030SCR º Autor ³ Guilherme Santos   º Data ³  09/12/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Exibe o Codigo do Produto e a Descricao na execucao da     º±±
±±º          ³ Convocacao do Coletor.                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAlteracao:³ Amedeo - 02/12/2012 (Ajuste na Tela)                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Avant                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function DV030SCR()
	Local aArea    := GetArea()
	Local aAreaSB1 := SB1->(GetArea())

	//--            1
	//--  01234567890123456789
	//--0 ____Conferencia____
	//--1 P000000/L0000000000
	//--2 Pedido : 000000
	
	DBSelectArea("SB1")
	DBSetorder(1)

If SB1->(DbSeek(xFilial("SB1") + SDB->DB_PRODUTO))

   VtClear()

	   //	@ 01,00 VTSay PadR("Pegue o Produto", VTMaxCol())
	    @ 01,00 VTSay PadR("Produto:"  + SDB->DB_PRODUTO , VTMaxCol())
		//@ 02,00 VTSay SDB->DB_PRODUTO
		@ 02,00 VTSay SubStr(SB1->B1_DESC, 01, 20)
		@ 03,00 VTSay SubStr(SB1->B1_DESC, 21, 20)
		@ 04,00 VTSay SubStr(SB1->B1_DESC, 41, 20)

		@ 04,00 VTSay "Ped.:"
		@ 04,06 VTSay SDB->DB_DOC
		@ 05,00 VTSay "Lote:"
		@ 05,06 VTSay SDB->DB_LOTECTL
	EndIf

 VTPause()
 VTRead

	RestArea(aAreaSB1)
	RestArea(aArea)
	
Return Nil