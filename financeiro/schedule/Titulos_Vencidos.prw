#INCLUDE "PROTHEUS.CH"           
#INCLUDE "TbiConn.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ TitVencidoº Autor ³ Fernando Nogueira  º Data ³ 23/11/2016  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ WorkFlow de Titulos Vencidos via Schedule                   º±±
±±º          ³ Chamado 004354                                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Avant                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function TitVencido(aParam)

Local aTabelas  := {"SE1","SA1"}
Local cAliasSE1 := GetNextAlias()
Local cCliente  := ""
Local cLoja     := ""
Local aTitulos  := {}
Local _cQuery   := ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³aParam     |  [01]   |  [02]  |
//³           | Empresa | Filial |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
RpcClearEnv()
RPCSetType(3)
RpcSetEnv(aParam[1], aParam[2], NIL, NIL, "FIN", NIL, aTabelas)

// Marca como nao enviado os titulos vencidos na segunda-feira para enviar novamente
If Dow(dDataBase) == 2

	_cQuery := "UPDATE  "+RetSQLName("SE1")+" SET E1_X_WFDV = 'N' FROM "+RetSQLName("SE1")+" SE1 "
	_cQuery += "INNER JOIN "+RetSQLName("SA1")+" SA1 ON E1_CLIENTE+E1_LOJA = A1_COD+A1_LOJA AND SA1.D_E_L_E_T_ = ' ' "
	_cQuery += "WHERE SE1.D_E_L_E_T_ = ' ' "
	_cQuery += "    AND E1_FILIAL = "+xFilial('SE1')+" "
	_cQuery += "    AND E1_SALDO > 0 "
	_cQuery += "    AND E1_TIPO = 'NF' "
	_cQuery += "    AND E1_VENCREA < GETDATE() "
	_cQuery += "    AND E1_X_WFDV = 'S' "
	_cQuery += "    AND A1_X_WFDV = 'S' "
	
	TcSqlExec(_cQuery)

Endif

// Titulos a serem enviados pelo work flow
BeginSql alias cAliasSE1

	SELECT E1_CLIENTE,E1_LOJA,E1_PREFIXO,E1_NUM,E1_PARCELA,E1_VENCTO,E1_VENCREA,E1_VALOR,E1_SALDO FROM %table:SE1% SE1
	INNER JOIN %table:SA1% SA1 ON E1_CLIENTE+E1_LOJA = A1_COD+A1_LOJA AND SA1.%notDel%
	WHERE SE1.%notDel%
		AND E1_FILIAL = %xfilial:SE1%
		AND E1_SALDO > 0 
		AND E1_TIPO = 'NF' 
		AND E1_VENCREA < GETDATE()
		AND E1_X_WFDV <> 'S'
		AND A1_X_WFDV = 'S'
	ORDER BY E1_CLIENTE,E1_LOJA,E1_NUM,E1_PARCELA

EndSql

(cAliasSE1)->(dbGoTop())

// Faz o envio dos workflows
While (cAliasSE1)->(!EoF())

	cCliente := (cAliasSE1)->E1_CLIENTE
	cLoja    := (cAliasSE1)->E1_LOJA
	aTitulos := {}
	
	While (cAliasSE1)->(!EoF()) .And. cCliente+cLoja == (cAliasSE1)->E1_CLIENTE+(cAliasSE1)->E1_LOJA
	
		// Somente adiciona quando o vecimento estiver atrasado a mais de 3 dias uteis
		If Stod((cAliasSE1)->E1_VENCREA) <= U_RetDiasUteis(03)
			AADD(aTitulos,{cCliente,cLoja,(cAliasSE1)->E1_PREFIXO,(cAliasSE1)->E1_NUM,(cAliasSE1)->E1_PARCELA,Stod((cAliasSE1)->E1_VENCREA),(cAliasSE1)->E1_VALOR,(cAliasSE1)->E1_SALDO})
		Endif
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ aTitulos:                                            ³
		//³ [1] Cliente                                          ³
		//³ [2] Loja                                             ³
		//³ [3] Prefixo                                          ³
		//³ [4] Numero do Titulo                                 ³
		//³ [5] Parcela                                          ³
		//³ [6] Data do Vencimento Real                          ³
		//³ [7] Valor                                            ³
		//³ [8] Saldo                                            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

		(cAliasSE1)->(dbSkip())
	End
	
	If !Empty(aTitulos)
		EnvTit(aTitulos)
	Endif
End

(cAliasSE1)->(DbCloseArea())

RpcClearEnv()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ EnvTit   ºAutor  ³ Fernando Nogueira  º Data ³ 28/11/2016  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Envia o Workflow com Titulos Vencidos do Cliente           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function EnvTit(aTitulos)

Local cArquivo  := "\MODELOS\COBRANCA_DV.HTM"
Local cPara     := Iif(!Empty(AllTrim(Posicione("SA1",1,xFilial("SA1")+aTitulos[01,01]+aTitulos[01,02],"A1_X_MAILC"))),AllTrim(SA1->A1_X_MAILC),AllTrim(SA1->A1_EMAIL))
Local cMailBCC  := AllTrim(GetMv("ES_MAILCDV"))
Local oProcess  := Nil
Local cMensTit  := ""
Local nDias     := 0
Local nJurCust  := 0
Local nTotal    := 0

oProcess := TWFProcess():New("TITAVENC","TITULOS VENCIDOS")
oProcess:NewTask("Enviando Titulos Vencidos",cArquivo)
oHTML := oProcess:oHTML

For _n := 1 To Len(aTitulos)

	nDias    := dDataBase - aTitulos[_n,06]
	nJurCust := ((aTitulos[_n,08]*1.10)+((aTitulos[_n,08]*0.002)*nDias))-aTitulos[_n,08] // 10% de multa + 6% ao mes (0,2% ao dia), juros simples

	aAdd((oHTML:ValByName("aR.cTit")), aTitulos[_n,04])
	aAdd((oHTML:ValByName("aR.cPar")), aTitulos[_n,05])
	aAdd((oHTML:ValByName("aR.cVnR")), aTitulos[_n,06])
	aAdd((oHTML:ValByName("aR.cVlr")), Transform(aTitulos[_n,07], PesqPict("SE1","E1_VALOR")))
	aAdd((oHTML:ValByName("aR.cSld")), Transform(aTitulos[_n,08], PesqPict("SE1","E1_SALDO")))
	aAdd((oHTML:ValByName("aR.cJrs")), Transform(nJurCust, PesqPict("SE1","E1_VALOR")))
	aAdd((oHTML:ValByName("aR.cVlt")), Transform(nJurCust+aTitulos[_n,08], PesqPict("SE1","E1_VALOR")))
	
	nTotal += nJurCust+aTitulos[_n,08]

	// Marca que o titulo que jah foi enviado via workflow
	If SE1->(dbSeek(xFilial("SE1")+aTitulos[_n,03]+aTitulos[_n,04]+aTitulos[_n,05]))
		SE1->(RecLock("SE1",.F.))
			SE1->E1_X_WFDV := "S"
		SE1->(MsUnlock())	
	Endif
Next

oHtml:ValByName("cTotal"  , Transform(nTotal, PesqPict("SE1","E1_VALOR")))
oHtml:ValByName("cDataPag", DtoC(DataValida(dDataBase+1)))

oProcess:cSubject := "[Titulos Vencidos Avant - "+DtoC(Date())+"] "
oProcess:USerSiga := "000000"
oProcess:cTo      := cPara
oProcess:cBCC     := cMailBCC

oProcess:Start()
oProcess:Finish()

Return
