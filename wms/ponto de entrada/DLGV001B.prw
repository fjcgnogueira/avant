#INCLUDE "PROTHEUS.CH"
#INCLUDE 'APVT100.CH'
#INCLUDE 'INKEY.CH'
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ DLGV001B º Autor ³ Fernando Nogueira  º Data ³ 21/07/2014  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de Entrada Antes da Confirmacao da Convocacao        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Avant                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function DLGV001B()

Local aArea      := GetArea()
Local aAreaSDB   := SDB->(GetArea())
Local cAlias1SDB := GetNextAlias()
Local cAlias2SDB := GetNextAlias()
Local cAliasDCF  := GetNextAlias()
Local cLocal     := SDB->DB_LOCAL
Local cItem      := SDB->DB_SERIE 
Local cRecHum    := ParamIXB[1]
Local cTarefa    := ParamIXB[4]
Local cAtivid    := ParamIXB[5]
Local cPedido    := ParamIXB[7]
Local lConvoca   := ParamIXB[8]
Local cFuncao    := AllTrim(ParamIXB[9])
Local aReturn    := {}

If lConvoca
	aReturn := {.T.}
Else
	aReturn := {.F.}
Endif

// Fernando Nogueira - Verifica se tem servico de separacao pendente para executar a conferencia
If lConvoca .And. cFuncao $ ('DLCONFEREN().DLAPANHE()')

	// Verifica se foi feita alguma separacao
	BeginSQL Alias cAlias1SDB
		SELECT * FROM SDB010 SDB
		WHERE SDB.%notDel%
			AND DB_FILIAL    = %Exp:xFilial("SDB")%
			AND DB_DOC       = %Exp:cPedido%
			AND DB_TAREFA    = '002' 
			AND DB_LOCAL     = %Exp:cLocal%
			AND DB_TIPO      = 'E' 
			AND DB_ESTORNO   = ' '
			AND DB_STATUS    = '1' 
	EndSQL

	(cAlias1SDB)->(dbGoTop())

	// Se a chamada for de apanhe
	If cFuncao == 'DLAPANHE()'
	
		If (cAlias1SDB)->(Eof()) .And. DLVTAviso("Apanhe","Pedido "+cPedido+CHR(13)+CHR(10)+"Item: "+cItem+CHR(13)+CHR(10)+"Continua Nesse?",{"Sim","Nao"}) <> 1
			aReturn  := {.F.}
			Return aReturn
		ElseIf !(cAlias1SDB)->(Eof())
		
			If DLVTAviso("Apanhe","Pedido "+cPedido+" Separado Parcial"+CHR(13)+CHR(10)+"Item: "+cItem+CHR(13)+CHR(10)+"Continua Nesse?",{"Sim","Nao"}) <> 1
				aReturn := {.F.}
			Else
				VtClear()
				
					@ 01,00 VTSay PadR("Depois de Separar", VTMaxCol())
					@ 02,00 VTSay PadR("Favor Agrupar na", VTMaxCol())	
					@ 03,00 VTSay PadR("Doca de Saida"   , VTMaxCol())
				
				VTPause()
				VTRead
			Endif
		Endif
				
		DefRecHum(cLocal,cPedido,cTarefa,cAtivid,cRecHum)
	
	// Se a chamada for de conferencia
	ElseIf cFuncao == 'DLCONFEREN()' .And. !(cAlias1SDB)->(Eof())
	
		// Verifica se tem alguma execucao pendente
		BeginSQL Alias cAliasDCF
			SELECT * FROM DCF010 DCF
			WHERE DCF.%notDel%
				AND DCF_FILIAL   = %Exp:xFilial("DCF")%
				AND DCF_DOCTO    = %Exp:cPedido%
				AND DCF_LOCAL    = %Exp:cLocal%
				AND DCF_STSERV  <= '2'
		EndSQL
		
		(cAliasDCF)->(dbGoTop())
		
		If !(cAliasDCF)->(Eof())
		
			VtClear()
			
				@ 01,00 VTSay PadR("Pedido: "+AllTrim(cPedido), VTMaxCol())
				@ 02,00 VTSay PadR("Incompleto na" , VTMaxCol())
				@ 03,00 VTSay PadR("Execucao" , VTMaxCol())
			
			VTPause()
			VTRead
			
			aReturn := {.F.}
		
		Else	
			// Verifica se tem alguma separacao pendente
			BeginSQL Alias cAlias2SDB
				SELECT * FROM SDB010 SDB
				WHERE SDB.%notDel%
					AND DB_FILIAL    = %Exp:xFilial("SDB")%
					AND DB_DOC       = %Exp:cPedido%
					AND DB_TAREFA    = '002' 
					AND DB_LOCAL     = %Exp:cLocal%
					AND DB_TIPO      = 'E' 
					AND DB_ESTORNO   = ' '
					AND DB_STATUS    <> '1' 
			EndSQL
	
			(cAlias2SDB)->(dbGoTop())
			
			If !(cAlias2SDB)->(Eof())
	
				VtClear()
				
					@ 01,00 VTSay PadR("Pedido: "+AllTrim(cPedido), VTMaxCol())
					@ 02,00 VTSay PadR("Incompleto na" , VTMaxCol())
					@ 03,00 VTSay PadR("Separacao" , VTMaxCol())
				
				VTPause()
				VTRead
				
				aReturn := {.F.}
			Endif
						
			(cAlias2SDB)->(dbCloseArea())
			
			If aReturn[1]
				DefRecHum(cLocal,cPedido,cTarefa,cAtivid,cRecHum)
			Endif
			
		Endif
		
		(cAliasDCF)->(dbCloseArea())
	Endif
	
	(cAlias1SDB)->(dbCloseArea())	
Endif

SDB->(RestArea(aAreaSDB))
RestArea(aArea)

Return aReturn

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ DefRecHum º Autor ³ Fernando Nogueira  º Data ³ 14/09/2015 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Define o mesmo recurso humano para todo o documento        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function DefRecHum(cLocal,cPedido,cTarefa,cAtivid,cRecHum)

Local cAlias3SDB := GetNextAlias()

// Lista os servicos pendentes de separacao
BeginSQL Alias cAlias3SDB
	SELECT * FROM SDB010 SDB
	WHERE SDB.%notDel%
		AND DB_FILIAL    = %Exp:xFilial("SDB")%
		AND DB_STATUS    = '4'
		AND DB_TAREFA    = %Exp:cTarefa%
		AND DB_ATIVID    = %Exp:cAtivid%
		AND DB_DOC       = %Exp:cPedido%
		AND DB_LOCAL     = %Exp:cLocal%
EndSQL

(cAlias3SDB)->(dbGoTop())

While (cAlias3SDB)->(!Eof())
	SDB->(dbGoTop())
	SDB->(dbSetOrder(8))
	If SDB->(dbSeek(xFilial("SDB")+(cAlias3SDB)->(DB_STATUS+DB_SERVIC+DB_ORDTARE+DB_TAREFA+DB_ORDATIV+DB_ATIVID+DB_DOC+DB_SERIE+DB_CLIFOR+DB_LOJA+DB_ITEM)))
		While SDB->(DB_FILIAL+DB_STATUS+DB_SERVIC+DB_ORDTARE+DB_TAREFA+DB_ORDATIV+DB_ATIVID+DB_DOC+DB_SERIE+DB_CLIFOR+DB_LOJA+DB_ITEM) == xFilial("SDB")+(cAlias3SDB)->(DB_STATUS+DB_SERVIC+DB_ORDTARE+DB_TAREFA+DB_ORDATIV+DB_ATIVID+DB_DOC+DB_SERIE+DB_CLIFOR+DB_LOJA+DB_ITEM)
			If Empty(SDB->DB_ESTORNO)
				If SDB->(RecLock("SDB",.F.))
					SDB->DB_RECHUM := cRecHum
					SDB->(MsUnlock())
				Else
					VtClear()
					@ 01,00 VTSay PadR("Registro bloqueado")
					VTPause()
					VTRead
					Final()
				Endif
			Endif
			SDB->(dbSkip())
		End
	Endif
	(cAlias3SDB)->(dbSkip())
End

(cAlias3SDB)->(dbCloseArea())

Return