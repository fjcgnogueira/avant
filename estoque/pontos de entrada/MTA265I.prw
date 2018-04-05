#Include "Totvs.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MTA265I   º Autor ³ Fernando Nogueira  º Data ³ 20/07/2017 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de Entrada Posterior ao Enderecamento do Produto     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Avant                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MTA265I()

Local aOperacao  := {}
Local lRet
Local aArea      := GetArea()
Local aAreaSBF   := SBF->(GetArea())
Local nQuant     := 0
Local cNumReserv := ""
Local cAliasZZR  := GetNextAlias()

dbSelectArea("SBF")
dbSetOrder(01)

dbSelectArea("ZZR")
dbSetOrder(01)

BeginSql alias cAliasZZR

	SELECT ZZR_TIPO,ZZR_NUM,ZZR_SOLICI,ZZR_FILIAL,ZZR_OBS,ZZR_PRODUT,ZZR_LOCAL,ZZR_QUANT FROM %table:ZZR% ZZR
	WHERE ZZR.%notDel% 
		AND ZZR_FILIAL = %xfilial:ZZR% 
		AND ZZR_STATUS IN ('A','P')
		AND ZZR_PRODUT = %Exp:SDB->DB_PRODUTO%
		AND ZZR_LOCAL = %Exp:SDB->DB_LOCAL%
	ORDER BY ZZR_NUM,ZZR_PRODUT,ZZR_LOCAL

EndSql

(cAliasZZR)->(dbGoTop())

// Fernando Nogueira - Chamado 005714
If SBF->(dbSeek(xFilial("SBF")+SDB->(DB_LOCAL+DB_LOCALIZ+DB_PRODUTO+DB_NUMSERI+DB_LOTECTL+DB_NUMLOTE)))

	While (cAliasZZR)->(!EoF())
	
		lParcial  := .F.
	
		aOperacao := {01,(cAliasZZR)->ZZR_TIPO,'P'+(cAliasZZR)->ZZR_NUM,(cAliasZZR)->ZZR_SOLICI,(cAliasZZR)->ZZR_FILIAL,(cAliasZZR)->ZZR_OBS}
		
		// Fernando Nogueira - Chamado 005536
		nQuant := If((SBF->(BF_QUANT-BF_EMPENHO)) >= (cAliasZZR)->ZZR_QUANT, (cAliasZZR)->ZZR_QUANT, (SBF->(BF_QUANT-BF_EMPENHO)))
		
		cNumReserv := NumReserv()
		
		lRet := a430Reserv(aOperacao,;
							cNumReserv,;				// Numero da reserva 
							SDB->DB_PRODUTO,;			// Produto da reserva
							SDB->DB_LOCAL,;				// Armazem da reserva 
							nQuant,;					// Quantidade a ser reservada
							{Space(TamSx3("DB_NUMLOTE")[1]),SDB->DB_LOTECTL,Space(TamSx3("DB_LOCALIZ")[1]),Space(TamSx3("DB_NUMSERI")[1])})
							
		If lRet
			ConfirmSX8()
			ZZR->(dbSeek((cAliasZZR)->(ZZR_FILIAL+ZZR_NUM+ZZR_PRODUT+ZZR_LOCAL)))
			ZZR->(RecLock("ZZR",.F.))
				ZZR->ZZR_QUANT -= nQuant
				If ZZR->ZZR_QUANT = 0
					ZZR->ZZR_STATUS := 'B'
				Else
					ZZR->ZZR_STATUS := 'P'
				Endif
			ZZR->(MsUnlock())
		Else
			RollBackSX8()
		Endif
		
		(cAliasZZR)->(dbSkip())
	End

Endif

(cAliasZZR)->(dbCloseArea())

SBF->(RestArea(aAreaSBF))
RestArea(aArea)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ NumReserv º Autor ³ Fernando Nogueira  º Data ³ 02/08/2017 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Recupera o proximo numero de Reserva                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Avant                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function NumReserv()
	Local cNumReserv := GetSX8Num("SC0", "C0_NUM")

	DbSelectArea("SC0")
	DbSetOrder(01)

	While SC0->(DbSeek(xFilial("SC0") + cNumReserv))
		ConfirmSx8()
		cNumReserv := GetSx8Num("SC0", "C0_NUM")
	Enddo

Return cNumReserv