#INCLUDE "Protheus.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³IntPedEdi º Autor ³ Fernando Nogueira  º Data ³ 29/07/2014  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Programa de Integracao de Pedidos EDI                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico AVANT                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function IntPedEdi(cPedEdi)

Local cPathLog	:= "\LOGS\"
Local cFileLog	:= "MATAEDI410.LOG"
Local cAliasSC5	:= GetNextAlias()
Local lRetorno	:= .T.
Local cPedNew	:= ""
Local cPedCli	:= ""
Local cTransp	:= ""
Local cMensagem	:= ""
Local cBOL		:= "'<p>'+DtoC(Date())+Space(01)+Time()+Space(01)"
Local cEOL		:= "</p>"+CHR(13)+CHR(10)
Local cTpNota	:= "N"
Local cTpOper	:= "51"
Local cTpFrete	:= "C"
Local cCodProd	:= ""
Local nQtdLib	:= 0
Local cArmazem	:= "01"
Local dDtEmiss	:= CtoD("")
Local aCabec	:= {}
Local aItens	:= {}
Local aLinha	:= {}
Local aTesInt	:= {}
Local aPrdCli	:= {}
Local aProduto	:= {}
Local cFMGrpCli	:= CriaVar("FM_GRTRIB")
Local cFMCodCli	:= CriaVar("FM_CLIENTE")
Local cFMLjCli	:= CriaVar("FM_LOJACLI")
Local cFMCodFor	:= CriaVar("FM_FORNECE")
Local cFMLjFor	:= CriaVar("FM_LOJAFOR")
Local cFMCodPrd	:= CriaVar("FM_PRODUTO")
Local cFMEst	:= CriaVar("FM_EST")
Local _nQtdMult	:= 0
Local _nPrcVen	:= 0
Local nPosPrd	:= 0
Local lSaldo	:= .T.

Private lMsErroAuto	:= .F.

// Verifica se esse Pedido jah foi integrado antes
BeginSQL Alias cAliasSC5
	SELECT	R_E_C_N_O_	AS RECC5
	FROM	%Table:SC5%
	WHERE	%NotDel%
	AND		C5_PEDEDI = %Exp:cPedEdi%
	AND 	C5_FILIAL = %Exp:xFilial("SC5")%
EndSQL

If !(cAliasSC5)->(Eof())
	lRetorno 	:= .F.
	cMensagem	+= &cBOL+"Pedido Cliente já cadastrado no Protheus Nro(s)"

	While !(cAliasSC5)->(Eof())
		DbSelectarea("SC5")
		SC5->(DbGoto( (cAliasSC5)->RECC5 ))
		cMensagem += " - " + SC5->C5_NUM
		(cAliasSC5)->(DbSkip())
	Enddo

	cMensagem+cEOL
EndIf

(cAliasSC5)->(DbCloseArea())

If lRetorno

	DbSelectArea("SZJ")
	SZJ->(DbSetorder(1))
	SZJ->(DbGoTop())

	If SZJ->(DbSeek(xFilial("SZJ") + cPedEdi))
		If SZJ->ZJ_STATUS <> "1"
			lRetorno 	:= .F.
			cMensagem	+= &cBOL+"Pedido: " + cPedEdi + " Está com Status " + SZJ->ZJ_STATUS + " Na tabela de Integração"+cEOL
		Else
			DbSelectarea("SA1")
			SA1->(DbSetorder(3))
			SA1->(DbGoTop())

			If !SA1->(DbSeek(xFilial("SA1") + SZJ->ZJ_CNPJENT))

				lRetorno := .F.
				cMensagem += &cBOL+"CNPJ: " + SZJ->ZJ_CNPJENT + " do cliente, não cadastrado no cadastro de clientes do Protheus."+cEOL

			Else

				dDtEmiss := SZJ->ZJ_DTPROC
				cPedEdi  := SZJ->ZJ_PEDEDI
				cPedCli  := SZJ->ZJ_PEDCLI
				cPedNew  := U_NUMPED()
				cTransp  := Posicione("SZ1",1,xFilial("SZ1")+SA1->A1_COD+SA1->A1_LOJA,"SZ1->Z1_TRANSP")

				aAdd(aCabec, {"C5_FILIAL" , SZJ->ZJ_FILIAL , NIL} )
				aAdd(aCabec, {"C5_NUM"    , cPedNew        , NIL} )
				aAdd(aCabec, {"C5_EMISSAO", dDtEmiss       , NIL} )
				aAdd(aCabec, {"C5_TIPO"   , cTpNota        , NIL} )
				aAdd(aCabec, {"C5_CLIENTE", SA1->A1_COD    , NIL} )
				aAdd(aCabec, {"C5_LOJACLI", SA1->A1_LOJA   , NIL} )
				aAdd(aCabec, {"C5_TRANSP" , cTransp        , NIL} )
				aAdd(aCabec, {"C5_CONDPAG", SA1->A1_COND   , NIL} )
				aAdd(aCabec, {"C5_TPFRETE", cTpFrete       , NIL} )
				aAdd(aCabec, {"C5_MENNOTA", SZJ->ZJ_OBSERV , NIL} )
				aAdd(aCabec, {"C5_PEDEDI" , cPedEdi        , NIL} )
				aAdd(aCabec, {"C5_PEDCLI" , cPedCli        , NIL} )
				aAdd(aCabec, {"C5_X_BLQ"  ,"S"             , NIL} )		// Fernando Nogueira - Chamado 002243

				DbSelectarea("SZK")
				SZK->(dbSetorder(1))
				SZK->(dbGoTop())
				If SZK->(DbSeek(xFilial("SZK") + cPedEdi))

					// Fernando Nogueira - Chamado 002243 - Verifica se tem saldo disponivel
					While SZK->(!Eof()) .And. SZK->ZK_FILIAL+SZK->ZK_PEDEDI == xFilial("SZK")+cPedEdi .And. lRetorno

						aPrdCli   := _fPrdCli(SZK->ZK_PRODCLI,SA1->A1_COD,SA1->A1_LOJA,SZK->ZK_QUANT)

						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³aPrdCli |       [01]       |         [02]       |       [03]       |  [04]  |    [05]    |
						//³        | Existe Amarracao | Cod. Prod. Cliente | Cod. Prod. Avant | Quant. | Prc. Venda |
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

						aAdd(aProduto,aPrdCli)

						If !aPrdCli[01]
							lRetorno := .F.
							cMensagem += &cBOL+"Não tem amarração para o Produto "+ALLTRIM(SZK->ZK_PRODCLI)+" do cliente "+SA1->A1_COD+"/"+SA1->A1_LOJA+cEOL
							Exit
						Endif

						lSaldo := IIF(lSaldo,(aPrdCli[04] <= U_SaldoProd(aPrdCli[03])),lSaldo)

						SZK->(DbSkip())
					Enddo

					If lRetorno .And. !lSaldo
						cMensagem += &cBOL+"Pedido "+cPedNew+" gerando em aberto."+cEOL
					Endif

					SZK->(dbGoTop())
					SZK->(DbSeek(xFilial("SZK") + cPedEdi))
					While lRetorno .And. SZK->(!Eof()) .And. SZK->ZK_FILIAL+SZK->ZK_PEDEDI == xFilial("SZK")+cPedEdi

						nPosPrd  := aScan(aProduto,{|x| x[02] == SZK->ZK_PRODCLI})

						cCodProd  := AllTrim(aProduto[nPosPrd,03])
						_nQtdMult := aProduto[nPosPrd,04]
						_nPrcVen  := aProduto[nPosPrd,05]
						nQtdLib   := IIF(lSaldo,_nQtdMult,0)

						aLinha := {}
						aAdd(aLinha, {"C6_FILIAL" , SZK->ZK_FILIAL	, NIL} )
						aAdd(aLinha, {"C6_ITEM"   , SZK->ZK_ITEM	, NIL} )
						aAdd(aLinha, {"C6_PRODUTO", cCodProd		, NIL} )
						aAdd(aLinha, {"C6_QTDVEN" , _nQtdMult		, NIL} )
						aAdd(aLinha, {"C6_QTDLIB" , nQtdLib			, NIL} )
						aAdd(aLinha, {"C6_OPER"   , cTpOper			, NIL} )
						aAdd(aLinha, {"C6_PEDCLI" , cPedCli			, NIL} )
						aAdd(aLinha, {"C6_LOCAL"  , cArmazem		, NIL} )
						aAdd(aLinha, {"C6_PRCVEN" , _nPrcVen		, NIL} )


						aAdd(aItens,aLinha)

						SB1->(dbSeek(xFilial("SB1")+cCodProd))
						_aAreaSFM := SFM->(GetArea())
						SFM->(dbSetOrder(2))

						// Verifica se nao tem amarracao de Tes Inteligente
						If !SFM->(dbSeek(xFilial("SFM")+cTpOper+SA1->A1_COD+SA1->A1_LOJA+cFMCodFor+cFMLjFor+SA1->A1_GRPTRIB+cFMCodPrd+SB1->B1_GRTRIB+SA1->A1_EST));
						   .And. !SFM->(dbSeek(xFilial("SFM")+cTpOper+SA1->A1_COD+SA1->A1_LOJA+cFMCodFor+cFMLjFor+cFMGrpCli+cFMCodPrd+SB1->B1_GRTRIB+SA1->A1_EST));
						   .And. !SFM->(dbSeek(xFilial("SFM")+cTpOper+cFMCodCli+cFMLjCli+cFMCodFor+cFMLjFor+SA1->A1_GRPTRIB+cFMCodPrd+SB1->B1_GRTRIB+SA1->A1_EST));
						   .And. !SFM->(dbSeek(xFilial("SFM")+cTpOper+cFMCodCli+cFMLjCli+cFMCodFor+cFMLjFor+SA1->A1_GRPTRIB+cFMCodPrd+SB1->B1_GRTRIB+cFMEst))
							aadd(aTesInt,{SB1->B1_COD,SB1->B1_DESC,SB1->B1_GRTRIB,SB1->B1_IPI,SB1->B1_POSIPI})
						EndIf

						SFM->(RestArea(_aAreaSFM))

						SZK->(DbSkip())
					Enddo

					If !Empty(aTesInt)
						U_DispEdiTes(aTesInt,cPedEdi)
					Endif

					If lRetorno
						MsExecAuto({|a, b, c| MATA410(a, b, c)}, aCabec, aItens, 3)

						If lMsErroAuto
							lRetorno	:= .F.
							cMensagem 	+= &cBOL+MostraErro(cPathLog, cFileLog)+cEOL
							RollBackSx8()
						Else
							cMensagem   += &cBOL+"Pedido Avant "+cPedNew+" integrado com sucesso."+cEOL
						EndIf
					Else
						RollBackSx8()
					Endif

					//Atualiza Status da SZJ
					SZJ->(RecLock("SZJ", .F.))
					SZJ->ZJ_STATUS	:= IIF(lRetorno, "2", "3")
					// Status
					// 1 = Pedido Importado do EDI
					// 2 = Integrado com Sucesso
					// 3 = Erro na Integracao

					SZJ->(MsUnlock())

					If !lRetorno
						U_DispEdiErr(cMensagem,cPedEdi)
					EndIf

				Else
					lRetorno  := .F.
					cMensagem += &cBOL+"Não encontrado ítens para o pedido: "+cPedEdi+cEOL
				EndIf

			EndIf

		EndIf

	Else
		lRetorno  := .F.
		cMensagem := &cBOL+"Pedido: "+cPedEdi+" Não encontrado na tabela SZJ"+cEOL
	EndIf

EndIf

Return cMensagem

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ _fPrdCli  ³ Autor ³ Fernando Nogueira  ³ Data  ³30/05/2016³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Valida amarracao de Produto vs Cliente                    ³±±
±±³          ³ Retorna array com a validacao, cod. produto do cliente,   ³±±
±±³          ³ cod. produto avant, quant. da amarracao, preco de venda   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function _fPrdCli(cPrdCli,cCliente,cLoja,nQtdPrd)

Local _nQtdMult	:= 0
Local _nPrcVen 	:= 0
Local cCodProd	:= ""

SA7->(DbSelectarea("SA7"))
SA7->(dbSetorder(3))
SA7->(dbGoTop())
If SA7->(DbSeek(xFilial("SA7")+cCliente+cLoja+cPrdCli))

	cCodProd := SA7->A7_PRODUTO

	SB1->(DBSetOrder(1))
	SB1->(DbGoTop())
	SB1->(DBSeek(xFilial("SB1")+cCodProd))

	If SA7->A7_SERVTIM = "MAKRO"
		If cCodProd$(GetMv("ES_PRDM20"))
			_nQtdMult := nQtdPrd*SB1->B1_X_QTDI2
		Else
			_nQtdMult := nQtdPrd*SB1->B1_X_QTDE2
		EndIf
	Else
		If SA7->A7_SERVTIM = "ASSAI"
			If cCodProd$(GetMv("ES_PRDM202"))
				_nQtdMult := nQtdPrd*SB1->B1_X_QTDI2
			Else
				_nQtdMult := nQtdPrd*SB1->B1_X_QTDE2
			EndIf
		EndIf
		If SA7->A7_SERVTIM = "HOME"
			_nQtdMult := nQtdPrd
		EndIf
		If SA7->A7_SERVTIM = "LEROY"
			_nQtdMult := nQtdPrd
		EndIf
	EndIf

	_nPrcVen := SA7->A7_PRECO01

Else
	Return {.F.,cPrdCli,cCodProd,_nQtdMult,_nPrcVen}
Endif

Return {.T.,cPrdCli,cCodProd,_nQtdMult,_nPrcVen}

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ DispEdiErr³ Autor ³ Fernando Nogueira  ³ Data  ³ 24/04/14 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Dispara e-mail quando ocorre erro na integracao do Pedido ³±±
±±³          ³ via Web.                                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function DispEdiErr(cMensagem,cPedEdi)

Local _cMailTo   := GetMv("ES_EMAILPW")
Local _cMailVend := ""
Local _cCorpoM   := ""
Local _cZ4Quant  := PesqPict("SZ4","Z4_QTDE")
Local _cZ4VPrVen := PesqPict("SZ4","Z4_PRVEN")
Local _cZ4VPrLiq := PesqPict("SZ4","Z4_PRLIQ")

aArea		:= GetArea()
_aAreaSZ3 	:= getArea("SZ3")
_aAreaSZ4 	:= getArea("SZ4")
_aAreaSA3 	:= getArea("SA3")
_aAreaSA1 	:= getArea("SA1")

_cMailVend := Posicione("SA3",1,xFilial("SA3")+SZ3->Z3_VEND,"A3_EMAIL")

If !Empty(_cMailVend)
	_cMailTo := _cMailTo + ";" + AllTrim(_cMailVend)
Endif

SZ4->(DbSetOrder(1))

If SZ4->(dbSeek(SZ3->Z3_FILIAL+cPedEdi))
	_cCorpoM += '<html>'
	_cCorpoM += '<head>'
	_cCorpoM += '<title>Erro de Integração Pedido Web</title>'
	_cCorpoM += '<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">'
	_cCorpoM += '<style type="text/css">'
	_cCorpoM += '<!--'
	_cCorpoM += '.style1 {font-family: Arial, Helvetica, sans-serif}'
	_cCorpoM += '.style3 {font-family: Arial, Helvetica, sans-serif; font-weight: bold; }'
	_cCorpoM += '.style4 {color: #FF0000}'
	_cCorpoM += '-->'
	_cCorpoM += '</style>'
	_cCorpoM += '</head>'
	_cCorpoM += '<body>'
	_cCorpoM += '  <p align="center" class="style1"><strong>AVISO DE ERRO DE INTEGRAÇÃO PEDIDO WEB</strong></p>'
	_cCorpoM += '  <p class="style1"><strong>Data: </strong>'+DtoC(Date())+'</p>'
	_cCorpoM += '  <p class="style1"><strong>Hora: </strong>'+Substr(Time(),1,5)+'</p>'
	_cCorpoM += '  <p class="style1"><strong>Filial : </strong>'+SM0->M0_FILIAL+'</p>'
	_cCorpoM += '  <p class="style1"><strong>Pedido Web: </strong>'+cPedEdi+'</p>'
	_cCorpoM += '  <p class="style1"><strong>Cliente/Loja: </strong>'+Posicione("SA1",3,xFilial("SA1")+SZ3->Z3_CNPJ,"A1_COD")+"/"+SA1->A1_LOJA+'</p>'
	_cCorpoM += '  <p class="style1"><strong>Mensagem: </strong>'+cMensagem+'</p>'
	_cCorpoM += '  <table width="1900" border="1" align="left"> '
	_cCorpoM += '    <tr>
	_cCorpoM += '      <td align="center" width="35"><span class="style3">Item</span></td>'
	_cCorpoM += '      <td align="center" width="80"><span class="style3">Produto</span></td>'
	_cCorpoM += '      <td align="center" width="250"><span class="style3">Descricao</span></td>'
	_cCorpoM += '      <td align="center" width="70"><span class="style3">Quantidade</span></td>'
	_cCorpoM += '      <td align="center" width="70"><span class="style3">Prc Venda</span></td>'
	_cCorpoM += '      <td align="center" width="70"><span class="style3">Prc Unit.</span></td>'
	_cCorpoM += '    </tr>'
	While SZ4->(!Eof()) .And. SZ4->Z4_NUMPEDW == SZ3->Z3_NPEDWEB

		_cCorpoM += '    <tr>'
		_cCorpoM += '     <td align="center"><span>'+SZ4->Z4_ITEMPED+'</span></td>'
		_cCorpoM += '	   <td align="center"><span>'+SZ4->Z4_CODPROD+'</span></td>'
		_cCorpoM += '	   <td><span>'+SZ4->Z4_DESCPRO+'</span></td>'
		_cCorpoM += '	   <td align="right"><span>'+Transform(SZ4->Z4_QTDE , _cZ4Quant)+'</span></td>'
		_cCorpoM += '	   <td align="right"><span>'+Transform(SZ4->Z4_PRVEN, _cZ4VPrVen)+'</span></td>'
		_cCorpoM += '	   <td align="right"><span>'+Transform(SZ4->Z4_PRLIQ, _cZ4VPrLiq)+'</span></td>'
		_cCorpoM += '    </tr>'
		SZ4->(dbSkip())
	EndDo
	_cCorpoM += '  </table>'
	_cCorpoM += '</body>'
	_cCorpoM += '</html>'
	U_MHDEnvMail(_cMailTo, "", "", "Pedido Edi "+cPedEdi+" Não Integrado ["+AllTrim(SM0->M0_CODFIL)+" / "+AllTrim(SM0->M0_FILIAL)+"]", _cCorpoM, "")
EndIf

Restarea(_aAreaSA1)
Restarea(_aAreaSZ3)
Restarea(_aAreaSZ4)
Restarea(_aAreaSA3)
RestArea(aArea)

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ DispEdiTes³ Autor ³ Fernando Nogueira  ³ Data  ³ 24/04/14 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Dispara e-mail quando falta amarracao de Tes Inteligente  ³±±
±±³          ³ em Pedido colocado via Web.                               ³±±
±±³          ³ Chamado 000471                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function DispEdiTes(aTesInt,cPedEdi)

Local _cMailTo  := GetMv("ES_MAILFIS")
Local _cMailCC  := GetMv("ES_EMAILTI")
Local _cCorpoM  := ""
Local _cTipo	  := SA1->A1_TIPO
Local _cB1IPI   := PesqPict("SB1","B1_IPI")
Local _cB1POIPI := PesqPict("SB1","B1_POSIPI")

aArea		:= GetArea()
_aAreaSA1 	:= getArea("SA1")
_aAreaSA3 	:= getArea("SA3")

_cMailVend := Posicione("SA3",1,xFilial("SA3")+SZ3->Z3_VEND,"A3_EMAIL")

// Fernando Nogueira - Chamado 004689 (comentario)
//If !Empty(_cMailVend)
//	_cMailTo := _cMailTo + ";" + AllTrim(_cMailVend)
//Endif

If _cTipo == 'S'
	_cTipo := 'REVENDEDOR'
ElseIf _cTipo == 'F'
	_cTipo := 'CONS. FINAL'
ElseIf _cTipo == 'L'
	_cTipo := 'PRODUTOR RURAL'
ElseIf _cTipo == 'R'
	_cTipo := 'IND/OBRA'
ElseIf _cTipo == 'X'
	_cTipo := 'EXPORTAÇÃO'
EndIf

SZ4->(DbSetOrder(1))

If SZ4->(dbSeek(SZ3->Z3_FILIAL+cPedEdi))
	_cCorpoM += '<html>'
	_cCorpoM += '<head>'
	_cCorpoM += '<title>Sem Amarração de Tes Inteligente</title>'
	_cCorpoM += '<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">'
	_cCorpoM += '<style type="text/css">'
	_cCorpoM += '<!--'
	_cCorpoM += '.style1 {font-family: Arial, Helvetica, sans-serif}'
	_cCorpoM += '.style3 {font-family: Arial, Helvetica, sans-serif; font-weight: bold; }'
	_cCorpoM += '.style4 {color: #FF0000}'
	_cCorpoM += '-->'
	_cCorpoM += '</style>'
	_cCorpoM += '</head>'
	_cCorpoM += '<body>'
	_cCorpoM += '  <p align="center" class="style1"><strong>AVISO DE FALTA DE AMARRAÇÃO DE TES INTELIGENTE</strong></p>'
	_cCorpoM += '  <p class="style1"><strong>Data: </strong>'+DtoC(Date())+'</p>'
	_cCorpoM += '  <p class="style1"><strong>Hora: </strong>'+Substr(Time(),1,5)+'</p>'
	_cCorpoM += '  <p class="style1"><strong>Filial : </strong>'+SM0->M0_FILIAL+'</p>'
	_cCorpoM += '  <p class="style1"><strong>Pedido Web: </strong>'+cPedEdi+'</p>'
	_cCorpoM += '  <p class="style1"><strong>Cliente/Loja: </strong>'+Posicione("SA1",3,xFilial("SA1")+SZ3->Z3_CNPJ,"A1_COD")+"/"+SA1->A1_LOJA+'</p>'
	_cCorpoM += '  <p class="style1"><strong>Tipo do Cliente: </strong>'+_cTipo+'</p>'
	_cCorpoM += '  <p class="style1"><strong>Estado do Cliente: </strong>'+SA1->A1_EST+'</p>'
	_cCorpoM += '  <p class="style1"><strong>Grupo de Tributação do Cliente: </strong>'+SA1->A1_GRPTRIB+'</p>'
	_cCorpoM += '  <p class="style1"><strong>Tipo de Operação: </strong>'+cTpOper+'</p>'
	_cCorpoM += '  <p class="style1"><strong>Produtos sem amarração: </strong> </p>'
	_cCorpoM += '  <table width="960" border="1" align="left"> '
	_cCorpoM += '    <tr>
	_cCorpoM += '      <td align="center" width="80"><span class="style3">Produto</span></td>'
	_cCorpoM += '      <td align="center" width="200"><span class="style3">Descricao</span></td>'
	_cCorpoM += '      <td align="center" width="160"><span class="style3">Grp Trib</span></td>'
	_cCorpoM += '      <td align="center" width="160"><span class="style3">Aliq. IPI</span></td>'
	_cCorpoM += '      <td align="center" width="160"><span class="style3">POS IPI</span></td>'
	_cCorpoM += '    </tr>'
	For _nI := 1 To Len(aTesInt)
		_cCorpoM += '    <tr>'
		_cCorpoM += '	   <td align="center"><span>'+aTesInt[_nI,1]+'</span></td>'
		_cCorpoM += '	   <td><span>'+aTesInt[_nI,2]+'</span></td>'
		_cCorpoM += '	   <td align="center"><span>'+aTesInt[_nI,3]+'</span></td>'
		_cCorpoM += '	   <td align="center"><span>'+Transform(aTesInt[_nI,4], _cB1IPI)+'</span></td>'
		_cCorpoM += '	   <td align="center"><span>'+Transform(aTesInt[_nI,5], _cB1POIPI)+'</span></td>'
		_cCorpoM += '    </tr>'
		SZ4->(dbSkip())
	Next _nI
	_cCorpoM += '  </table>'
	_cCorpoM += '</body>'
	_cCorpoM += '</html>'
	U_MHDEnvMail(_cMailTo, _cMailCC, "", "Pedido Edi "+cPedEdi+" com Produto(s) sem Amarracao de Tes Inteligente ["+AllTrim(SM0->M0_CODFIL)+" / "+AllTrim(SM0->M0_FILIAL)+"]", _cCorpoM, "")
EndIf

Restarea(_aAreaSA3)
Restarea(_aAreaSA1)
RestArea(aArea)

Return
