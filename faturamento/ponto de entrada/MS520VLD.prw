#INCLUDE "Protheus.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MS520VLD º Autor ³ Fernando Nogueira  º Data ³ 08/07/2016 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Ponto de Entrada Para Validar Exclusao de Nota Fiscal de  º±±
±±º          ³ Saida. Chamado 003505.                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Avant                                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function MS520VLD()

/*/
ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»
ºStatus Nota Fiscal Eletronica     º
ÌÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹
ºF2_FIMP==' '³ NF nao transmitida  º
ºF2_FIMP=='S'³ NF Autorizada       º
ºF2_FIMP=='T'³ NF Transmitida      º
ºF2_FIMP=='D'³ NF Uso Denegado     º
ºF2_FIMP=='N'³ NF nao autorizada   º
ÈÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼
/*/

If SF2->F2_FIMP == 'S' .And. Left(DtoS(SF2->F2_EMISSAO),06) <> Left(DtoS(Date()),06)
	ApMsgInfo("Exclusão de NF autorizada deve ser feita dentro do mesmo mês em que a mesma foi emitida.")
	Return .F.
ElseIf SF2->F2_FIMP == ' ' .And. Left(DtoS(SF2->F2_EMISSAO),06) <> Left(DtoS(dDataBase),06)
	ApMsgInfo("Exclusão de NF não transmitida deve ser feita dentro do mesmo mês na data base em que a mesma foi emitida.")
	Return .F.
ElseIf SF2->F2_FIMP == 'D' .And. Left(DtoS(SF2->F2_EMISSAO),06) <> Left(DtoS(dDataBase),06)
	ApMsgInfo("Exclusão de NF denegada deve ser feita dentro do mesmo mês na data base em que a mesma foi emitida.")
	Return .F.
ElseIf SF2->F2_FIMP == 'N' .And. Left(DtoS(SF2->F2_EMISSAO),06) <> Left(DtoS(dDataBase),06)
	ApMsgInfo("Exclusão de NF não autorizada deve ser feita dentro do mesmo mês na data base em que a mesma foi emitida.")
	Return .F.
ElseIf SF2->F2_FIMP == 'T'
	ApMsgInfo("Antes de excluir uma NF transmitida, aguardar o Sefaz definir o status da Nota.")
	Return .F.
Endif

Return .T.