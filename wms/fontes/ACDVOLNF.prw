#INCLUDE "PROTHEUS.CH"
#INCLUDE "APVT100.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ ACDVOLNF º Autor ³ Fernando Nogueira  º Data ³ 02/03/2016  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Alteracao de Volume da Nota Fiscal Via Coletor.            º±±
±±º          ³ Chamado 002640                                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AVANT                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function ACDVOLNF()

	Private nVolumes := 0
	Private nVolAtu	  := 0
	Private cNota  := Space(09)
	
	VtClear()
	
	@ 01,00 VTSay "Numero da NF"
	@ 02,00 VTGet cNota Valid(ValidNF(cNota))
	
	VTRead
	
	If VTLastKey() == 27
		Return Nil
	EndIf
	
	VtClear()
	
	@ 01,00 VTSay "NF:" + SF2->F2_DOC		
	@ 02,00 VTSay "Qtd Volumes Atual"
	@ 03,00 VTGet nVolAtu When .F.
	@ 04,00 VTSay "Qtd Volumes Novo"
	@ 05,00 VTGet nVolumes Valid(nVolumes > 0)
	
	VTRead
	
	If VTLastKey() == 27
		Return Nil
	EndIf
	
	If SF2->(RecLock("SF2",.F.))
		If SF2->F2_VOLUME1 == nVolumes
			VtAlert("A quantidade de volumes eh igual, nao foi preciso alterar","Aviso",.T.,4000,3)
		Else
			SF2->F2_VOLUME1	:= nVolumes
			VtAlert("Qtd de Volumes da NF "+SF2->F2_DOC+" Alterada","Aviso",.T.,4000,3)
		Endif
		SF2->(MsUnlock())
	Else
		VtAlert("Registro Bloqueado","Aviso",.T.,4000,3)
	Endif
	
Return Nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ ValidNF   ³ Autor ³ Fernando Nogueira  ³ Data  ³ 02/03/2016 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Valida Nota Fiscal                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ValidNF(cNota)
	Local lRetorno := .T.

	DbSelectarea("SF2")
	SF2->(DbSetorder(01))
	If !SF2->(DbSeek(xFilial("SF2") + cNota))
		VtAlert("NF " + cNota + "Não Encontrada","Aviso",.T.,4000,3)
		lRetorno := .F.
	Else
		If !Empty(SF2->F2_CHVNFE)
			VtAlert("NF " + cNota + " ja foi transmitida","Aviso",.T.,4000,3)
			lRetorno := .F.
		Else
			nVolAtu := SF2->F2_VOLUME1
		Endif
	EndIf
	
Return lRetorno