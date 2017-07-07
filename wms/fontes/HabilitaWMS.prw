#Include "PROTHEUS.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³HabilitaWMS()º Autor ³ Fernando Nogueira  º Data ³06/05/2014º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Habilita inclusao automatica de servico WMS                º±±
±±º          ³ Chamado 001172                                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico AVANT.                                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÏÍÍÍÑÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAnalista Resp.³  Data  ³ Manutencao Efetuada                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º              ³  /  /  ³                                               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function HabilitaWMS()

Local cMensHab := 'Inclusão de Serviço WMS Habilitado para Pedidos Web'
Local cMensDes := 'Inclusão de Serviço WMS Desabilitado para Pedidos Web com valor maior que'
Local bHabWMS  := {||GrvSX5(lCheckBoxWMS,nGetLim),If(lCheckBoxWMS,MsgInfo(cMensHab),MsgInfo(cMensDes+TransForm(nGetLim, PesqPict("SC5","C5_XTOTPED")))),oDlgWMS:End()}
Local nGetLim  := Val(Posicione("SX5",1,xFilial("SX5")+"ZA0011","X5_DESCRI"))

Static oDlgWMS
Static oButCancela
Static oButConfirma
Static lCheckBoxWMS := .F.
Static oCheckBoxWMS
Static oFont1 := TFont():New("Arial",,020,,.T.,,,,,.F.,.F.)
Static oFont2 := TFont():New("Arial",,017,,.T.,,,,,.F.,.F.)
Static oGroup1
Static oSayWMS
Static oSayLim
Static oGetLim

lCheckBoxWMS := VerServWMS()

  DEFINE MSDIALOG oDlgWMS TITLE "Habilita WMS" FROM 000, 000  TO 180, 600 COLORS 0, 16777215 PIXEL

    @ 005, 005 GROUP oGroup1 TO 066, 295 PROMPT "Habilita WMS" OF oDlgWMS COLOR 0, 16777215 PIXEL
    @ 017, 010 SAY oSayWMS PROMPT "Habilita inclusão automática de serviço WMS nos Pedidos de Vendas" SIZE 275, 014 OF oDlgWMS FONT oFont1 COLORS 0, 16777215 PIXEL
    @ 035, 010 CHECKBOX oCheckBoxWMS VAR lCheckBoxWMS PROMPT "Habilitado" SIZE 050, 008 OF oDlgWMS COLORS 0, 16777215 FONT oFont2 PIXEL
    @ 050, 010 SAY oSayLim PROMPT "Limite mínimo do Pedido: " SIZE 150, 008 OF oDlgWMS FONT oFont2 PIXEL
    @ 050, 100 MSGET oGetLim VAR nGetLim PICTURE PesqPict("SC5","C5_XTOTPED") SIZE 100, 008 OF oDlgWMS COLORS 0, 16777215 FONT oFont2 PIXEL
    @ 072, 200 BUTTON oButConfirma PROMPT "Confirma" SIZE 037, 012 ACTION(Eval(bHabWMS)) OF oDlgWMS FONT oFont2 PIXEL
    @ 072, 250 BUTTON oButCancela PROMPT "Cancela" SIZE 037, 012 ACTION(oDlgWMS:End()) OF oDlgWMS FONT oFont2 PIXEL
  ACTIVATE MSDIALOG oDlgWMS CENTERED

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ VerServWMS()º Autor ³ Fernando Nogueira  º Data ³16/12/2013º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Verifica se a Inclusao de Servico WMS esta ativa           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico AVANT.                   	                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function VerServWMS()

Local lCheckBoxWMS := .F.
Local aArea:= GetArea()

DbSelectArea('SX5')
DbSetOrder(1)
DbGotop()

lCheckBoxWMS := &(Posicione("SX5",1,xFilial("SX5")+"ZA0001","X5_DESCRI"))

RestArea(aArea)

Return lCheckBoxWMS

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ GrvSX5()    º Autor ³ Fernando Nogueira  º Data ³05/07/2017º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Grava os dados na SX5                                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico AVANT.                   	                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function GrvSX5(lCheckBoxWMS,nGetLim)

If SX5->(dbSeek(xFilial("SX5")+"ZA0001"))
	SX5->(RecLock("SX5",.F.))
		SX5->X5_DESCRI := cValToChar(lCheckBoxWMS)
	SX5->(MsUnlock())
Endif

If SX5->(dbSeek(xFilial("SX5")+"ZA0011"))
	SX5->(RecLock("SX5",.F.))
		SX5->X5_DESCRI := cValToChar(nGetLim)
	SX5->(MsUnlock())
Endif

Return
