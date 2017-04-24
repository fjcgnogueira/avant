#INCLUDE "PROTHEUS.CH"
#INCLUDE 'APVT100.CH'
#INCLUDE 'INKEY.CH'
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ DLGV001B บ Autor ณ Fernando Nogueira  บ Data ณ 21/07/2014  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Ponto de Entrada Antes da Confirmacao da Convocacao        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico Avant                                           บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function DLGV001B()

Local aArea      := GetArea()
Local aAreaSDB   := SDB->(GetArea())
Local cAlias1SDB := GetNextAlias()
Local cAlias2SDB := GetNextAlias()
Local cAlias3SDB := GetNextAlias()
Local cAlias5SDB := GetNextAlias()
Local cAlias6SDB := GetNextAlias()
Local cAlias7SDB := GetNextAlias()
Local cAliasDCF  := GetNextAlias()
Local cLocal     := SDB->DB_LOCAL
Local cItem      := SDB->DB_SERIE
Local cRecHum    := ParamIXB[1]
Local cTarefa    := ParamIXB[4]
Local cPedido    := ParamIXB[7]
Local lConvoca   := ParamIXB[8]
Local cStatus    := "3"
Local cStAnt     := "4"
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
		SELECT * FROM %table:SDB% SDB
		WHERE SDB.%notDel%
			AND DB_FILIAL    = %Exp:xFilial("SDB")%
			AND DB_DOC       = %Exp:cPedido%
			AND DB_TAREFA    = '002'
			AND DB_LOCAL     = %Exp:cLocal%
			AND DB_TIPO      = 'E'
			AND DB_ESTORNO   = ' '
			AND DB_STATUS    = '1'
			AND DB_X_STATU   = ' '
	EndSQL

	(cAlias1SDB)->(dbGoTop())

	// Se a chamada for de apanhe
	If cFuncao == 'DLAPANHE()'

		// Verifica se tem alguma separacao com outro recurso humano
		BeginSQL Alias cAlias3SDB
			SELECT * FROM %table:SDB% SDB
			WHERE SDB.%notDel%
				AND DB_FILIAL    = %Exp:xFilial("SDB")%
				AND DB_DOC       = %Exp:cPedido%
				AND DB_TAREFA    = '002'
				AND DB_LOCAL     = %Exp:cLocal%
				AND DB_TIPO      = 'E'
				AND DB_ESTORNO   = ' '
				AND DB_STATUS    <> '1'
				AND DB_RECHUM    <> ' '
				AND DB_RECHUM    <> %Exp:cRecHum%
				AND DB_X_STATU   = ' '
		EndSQL

		(cAlias3SDB)->(dbGoTop())

		If (cAlias3SDB)->(!Eof())
			(cAlias3SDB)->(dbCloseArea())
			aReturn  := {.F.}
			Return aReturn
		Endif
		(cAlias3SDB)->(dbCloseArea())

		// Verifica se tem alguma outra separacao com o mesmo recurso humano
		BeginSQL Alias cAlias5SDB
			SELECT TOP 1 ADVPL.DB_DOCS(%Exp:xFilial("SDB")%,%Exp:cRecHum%) DOCS FROM %table:SDB% SDB
		EndSQL

		(cAlias5SDB)->(dbGoTop())

		// Somente permite executar a separacao se nao tiver nenhuma outra para esse recurso humano ou se jah foi alocada para esse recurso humano
		// Fernando Nogueira - Chamado 002756
		If !Empty((cAlias5SDB)->DOCS) .And. !(AllTrim(cPedido) $ AllTrim((cAlias5SDB)->DOCS))
			(cAlias5SDB)->(dbCloseArea())
			aReturn  := {.F.}
			Return aReturn
		Endif
		(cAlias5SDB)->(dbCloseArea())

		If SDB->DB_RECHUM <> cRecHum .And. SDB->(RecLock("SDB",.F.))
			SDB->DB_RECHUM  := cRecHum
			SDB->(MsUnlock())
		Endif

		If (cAlias1SDB)->(Eof()) .And. DLVTAviso("Apanhe","Pedido "+cPedido+CHR(13)+CHR(10)+"Item: "+cItem+CHR(13)+CHR(10)+"Continua Nesse?",{"Sim","Nao"}) <> 1
			(cAlias1SDB)->(dbCloseArea())
			aReturn  := {.F.}
			Return aReturn
		ElseIf !(cAlias1SDB)->(Eof())

			If DLVTAviso("Apanhe","Pedido "+cPedido+" Separado Parcial"+CHR(13)+CHR(10)+"Item: "+cItem+CHR(13)+CHR(10)+"Continua Nesse?",{"Sim","Nao"}) <> 1
				(cAlias1SDB)->(dbCloseArea())
				aReturn := {.F.}
				Return aReturn
			Else
				VtClear()

					@ 01,00 VTSay PadR("Depois de Separar", VTMaxCol())
					@ 02,00 VTSay PadR("Favor Agrupar na", VTMaxCol())
					@ 03,00 VTSay PadR("Doca de Saida"   , VTMaxCol())

				VTPause()
				VTRead
			Endif
		Endif

		U_DefRecHum(cLocal,cPedido,cTarefa,cRecHum,cStatus,cStAnt,cFuncao)

	// Se a chamada for de conferencia
	ElseIf cFuncao == 'DLCONFEREN()' .And. !(cAlias1SDB)->(Eof())

		// Verifica se tem alguma conferencia com outro recurso humano
		BeginSQL Alias cAlias3SDB
			SELECT * FROM %table:SDB% SDB
			WHERE SDB.%notDel%
				AND DB_FILIAL    = %Exp:xFilial("SDB")%
				AND DB_DOC       = %Exp:cPedido%
				AND DB_TAREFA    = '003'
				AND DB_LOCAL     = %Exp:cLocal%
				AND DB_TIPO      = 'E'
				AND DB_ESTORNO   = ' '
				AND DB_RECHUM    <> ' '
				AND DB_RECHUM    <> %Exp:cRecHum%
				AND DB_X_STATU   = ' '
		EndSQL

		(cAlias3SDB)->(dbGoTop())
		
		// Verifica se tem alguma conferencia com o mesmo recurso humano
		BeginSQL Alias cAlias6SDB
			SELECT * FROM %table:SDB% SDB
			WHERE SDB.%notDel%
				AND DB_FILIAL    = %Exp:xFilial("SDB")%
				AND DB_DOC       = %Exp:cPedido%
				AND DB_TAREFA    = '003'
				AND DB_LOCAL     = %Exp:cLocal%
				AND DB_TIPO      = 'E'
				AND DB_ESTORNO   = ' '
				AND DB_RECHUM    = %Exp:cRecHum%
				AND DB_X_STATU   = ' '
		EndSQL

		(cAlias6SDB)->(dbGoTop())

		If (cAlias3SDB)->(!Eof())
			If (cAlias6SDB)->(!Eof())
				U_DefRecHum(cLocal,cPedido,cTarefa,cRecHum,cStatus,cStAnt)
			Endif
			(cAlias1SDB)->(dbCloseArea())
			(cAlias6SDB)->(dbCloseArea())
			(cAlias3SDB)->(dbCloseArea())
			SDB->(RestArea(aAreaSDB))
			RestArea(aArea)
			aReturn  := {.F.}
			Return aReturn
		Endif
		(cAlias6SDB)->(dbCloseArea())
		(cAlias3SDB)->(dbCloseArea())


		// Verifica se tem alguma execucao pendente
		BeginSQL Alias cAliasDCF
			SELECT * FROM %table:DCF% DCF
			WHERE DCF.%notDel%
				AND DCF_FILIAL   = %Exp:xFilial("DCF")%
				AND DCF_DOCTO    = %Exp:cPedido%
				AND DCF_LOCAL    = %Exp:cLocal%
				AND DCF_STSERV  <= '2'
		EndSQL

		(cAliasDCF)->(dbGoTop())

		If !(cAliasDCF)->(Eof())

			vtAlert("Pedido: "+AllTrim(cPedido)+" Incompleto na Execucao!","AVISO",.T.,4000)

			aReturn := {.F.}

		Else
			// Verifica se tem alguma separacao pendente
			BeginSQL Alias cAlias2SDB
				SELECT * FROM %table:SDB% SDB
				WHERE SDB.%notDel%
					AND DB_FILIAL    = %Exp:xFilial("SDB")%
					AND DB_DOC       = %Exp:cPedido%
					AND DB_TAREFA    = '002'
					AND DB_LOCAL     = %Exp:cLocal%
					AND DB_TIPO      = 'E'
					AND DB_ESTORNO   = ' '
					AND DB_STATUS    <> '1'
					AND DB_X_STATU   = ' '
			EndSQL

			(cAlias2SDB)->(dbGoTop())

			If !(cAlias2SDB)->(Eof())

				vtAlert("Pedido: "+AllTrim(cPedido)+" Incompleto na Separacao!","AVISO",.T.,4000)

				aReturn := {.F.}
			Endif

			(cAlias2SDB)->(dbCloseArea())

			If aReturn[1]
			
				// Verifica se tem alguma conferencia diferente do recurso humano atual ou com o status 2
				BeginSQL Alias cAlias7SDB
					SELECT * FROM %table:SDB% SDB
					WHERE SDB.%notDel%
						AND DB_FILIAL    = %Exp:xFilial("SDB")%
						AND DB_DOC       = %Exp:cPedido%
						AND DB_TAREFA    = '003'
						AND DB_LOCAL     = %Exp:cLocal%
						AND DB_TIPO      = 'E'
						AND DB_ESTORNO   = ' '
						AND (DB_RECHUM   <> %Exp:cRecHum% OR DB_STATUS = '2')
						AND DB_X_STATU   = ' '
				EndSQL
		
				(cAlias7SDB)->(dbGoTop())
				
				If (cAlias7SDB)->(!Eof())
					(cAlias7SDB)->(dbCloseArea())
					U_DefRecHum(cLocal,cPedido,cTarefa,cRecHum,cStatus,cStAnt)
				Endif

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
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออปฑฑ
ฑฑบPrograma  ณ DefRecHum บ Autor ณ Fernando Nogueira  บ Data ณ 14/09/2015 บฑฑ
ฑฑฬออออออออออุอออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออนฑฑ
ฑฑบDesc.     ณ Define o mesmo recurso humano para todo o documento        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function DefRecHum(cLocal,cPedido,cTarefa,cRecHum,cStatus,cStAnt,cFuncao)

Local cAlias4SDB := GetNextAlias()
Local _cRecHum   := ""
Local _lExit     := .F.

Default cFuncao := ""

// Lista os servicos a serem alterados
BeginSQL Alias cAlias4SDB
	SELECT DB_FILIAL+DB_DOC+DB_SERIE+DB_ITEM CHAVE, * FROM %table:SDB% SDB
	WHERE SDB.%notDel%
		AND DB_FILIAL    = %Exp:xFilial("SDB")%
		AND DB_STATUS    <> '1'
		AND DB_X_STATU   = ' '
		AND DB_TAREFA    = %Exp:cTarefa%
		AND DB_DOC       = %Exp:cPedido%
		AND DB_LOCAL     = %Exp:cLocal%
	ORDER BY CHAVE
EndSQL

(cAlias4SDB)->(dbGoTop())

While (cAlias4SDB)->(!Eof())
	SDB->(dbGoTop())
	SDB->(dbSetOrder(8))
	If SDB->(dbSeek(xFilial("SDB")+(cAlias4SDB)->(DB_STATUS+DB_SERVIC+DB_ORDTARE+DB_TAREFA+DB_ORDATIV+DB_ATIVID+DB_DOC+DB_SERIE+DB_CLIFOR+DB_LOJA+DB_ITEM)))
		While SDB->(DB_FILIAL+DB_STATUS+DB_SERVIC+DB_ORDTARE+DB_TAREFA+DB_ORDATIV+DB_ATIVID+DB_DOC+DB_SERIE+DB_CLIFOR+DB_LOJA+DB_ITEM) == xFilial("SDB")+(cAlias4SDB)->(DB_STATUS+DB_SERVIC+DB_ORDTARE+DB_TAREFA+DB_ORDATIV+DB_ATIVID+DB_DOC+DB_SERIE+DB_CLIFOR+DB_LOJA+DB_ITEM)
			If Empty(SDB->DB_ESTORNO) .And. SDB->DB_STATUS $ ('2.'+cStAnt)
				If Empty(SDB->DB_RECHUM)
					If SDB->(RecLock("SDB",.F.))
						SDB->DB_RECHUM := cRecHum
						If !(SDB->DB_STATUS = '2' .And. cFuncao = 'DLAPANHE()')
							SDB->DB_STATUS := cStatus
						Endif
						SDB->(MsUnlock())
					Else
						VtClear()
						@ 01,00 VTSay PadR("Registro bloqueado")
						VTPause()
						VTRead
						Final()
					Endif
				//ElseIf SDB->DB_RECHUM <> cRecHum
					//_lExit := .T.
					//Exit
				Endif
			Endif
			SDB->(dbSkip())
		End
	Endif
	//If _lExit
	//	Exit
	//Endif
	(cAlias4SDB)->(dbSkip())
End

// Fernando Nogueira - Ajuste Chamado 002453
(cAlias4SDB)->(dbGoTop())
While (cAlias4SDB)->(!Eof())
	SDB->(dbGoTop())
	SDB->(dbSetOrder(8))
	If SDB->(dbSeek(xFilial("SDB")+(cAlias4SDB)->(DB_STATUS+DB_SERVIC+DB_ORDTARE+DB_TAREFA+DB_ORDATIV+DB_ATIVID+DB_DOC+DB_SERIE+DB_CLIFOR+DB_LOJA+DB_ITEM)))
		While SDB->(DB_FILIAL+DB_STATUS+DB_SERVIC+DB_ORDTARE+DB_TAREFA+DB_ORDATIV+DB_ATIVID+DB_DOC+DB_SERIE+DB_CLIFOR+DB_LOJA+DB_ITEM) == xFilial("SDB")+(cAlias4SDB)->(DB_STATUS+DB_SERVIC+DB_ORDTARE+DB_TAREFA+DB_ORDATIV+DB_ATIVID+DB_DOC+DB_SERIE+DB_CLIFOR+DB_LOJA+DB_ITEM)
			If Empty(SDB->DB_ESTORNO) .And. !Empty(SDB->DB_RECHUM) .And. Empty(_cRecHum)
				_cRecHum := SDB->DB_RECHUM
				Exit
			Endif
			SDB->(dbSkip())
		End
	Endif
	If !Empty(_cRecHum)
		Exit
	Endif
	(cAlias4SDB)->(dbSkip())
End

(cAlias4SDB)->(dbGoTop())
While (cAlias4SDB)->(!Eof())
	SDB->(dbGoTop())
	SDB->(dbSetOrder(8))
	If SDB->(dbSeek(xFilial("SDB")+(cAlias4SDB)->(DB_STATUS+DB_SERVIC+DB_ORDTARE+DB_TAREFA+DB_ORDATIV+DB_ATIVID+DB_DOC+DB_SERIE+DB_CLIFOR+DB_LOJA+DB_ITEM)))
		While SDB->(DB_FILIAL+DB_STATUS+DB_SERVIC+DB_ORDTARE+DB_TAREFA+DB_ORDATIV+DB_ATIVID+DB_DOC+DB_SERIE+DB_CLIFOR+DB_LOJA+DB_ITEM) == xFilial("SDB")+(cAlias4SDB)->(DB_STATUS+DB_SERVIC+DB_ORDTARE+DB_TAREFA+DB_ORDATIV+DB_ATIVID+DB_DOC+DB_SERIE+DB_CLIFOR+DB_LOJA+DB_ITEM)
			If Empty(SDB->DB_ESTORNO) .And. !Empty(_cRecHum) .And. ((SDB->DB_STATUS $ ('3') .And. SDB->DB_RECHUM <> _cRecHum) .Or. SDB->DB_STATUS $ ('2.4'))
				If SDB->(RecLock("SDB",.F.))
					SDB->DB_RECHUM := _cRecHum
					If !(SDB->DB_STATUS = '2' .And. cFuncao = 'DLAPANHE()')
						SDB->DB_STATUS := cStatus
					Endif
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
	(cAlias4SDB)->(dbSkip())
End

(cAlias4SDB)->(dbCloseArea())

Return
