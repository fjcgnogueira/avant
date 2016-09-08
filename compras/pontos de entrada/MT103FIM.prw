#include "Protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT103FIM  ºAutor  ³Cristiam Rossi      º Data ³  21/01/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de Entrada - Fim da Nota Fiscal de Entrada           º±±
±±º          ³ Quando NF for devolução, pergunta se deseja criar PV p/    º±±
±±º          ³ troca da mercadoria, se confirmado. Cria PV via ExecAuto   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Avant                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MT103FIM()
// ParamIXB[1] (nOpc do aRotina) == 3 (Inclusão)
// PARAMIXB[2] == 1 (Botão Confirma)
// criar parâmetro MV_TESDEV, com a TES que será usada na NF saída para troca

	nDebito  := 0
	nCredito := 0

	// Pergunta se deseja criar Pedido de Vendas para troca
	If (ParamIXB[1] == 3 .or. Inclui) .And. PARAMIXB[2] == 1 .And. SF1->F1_TIPO == "D" .And. !IsBlind()
		If MSGYESNO("Deseja criar Pedido de Venda para troca dos produtos?", "NF Devolução")
			U_CriaPVAV()
		EndIf
	EndIf

	// Fernando Nogueira - Envia e-mail caso a database seja retroativa
	If (ParamIXB[1] == 3 .or. Inclui) .And. PARAMIXB[2] == 1 .and. Month(dDataBase) < Month(Date())
		U_DispNFE()
	Endif

	// Fernando Nogueira - Debito de Bonificacao do Vendedor
	If SF1->F1_TIPO == "D"
		_aAreaSD1 := SD1->(getArea("SD1"))
		_aAreaSD2 := SD2->(getArea("SD2"))
		_aAreaSA3 := SA3->(getArea("SA3"))

		SD1->(dbSetOrder(1))
		SD1->(dbGoTop())
		SD1->(dbSeek(xFilial("SD1")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA))

		While SD1->(!Eof()) .And. SD1->D1_FILIAL == xFilial("SD1") .And.;
			 SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA == SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA

			SD2->(dbSeek(xFilial("SD2")+SD1->D1_NFORI+SD1->D1_SERIORI+SD1->D1_FORNECE+SD1->D1_LOJA+SD1->D1_COD+SD1->D1_ITEMORI))

			SD1->(RecLock("SD1",.F.))
				SD1->D1_X_VEND  := SD2->D2_X_VEND
			SD1->(MsUnlock())

			If AllTrim(SD2->D2_X_TPOPE) == 'VENDAS' .And. SD2->D2_X_CRVEN > 0
				nDebito := (SD1->D1_QUANT * SD2->D2_X_CRVEN) / SD2->D2_QUANT

				SD1->(RecLock("SD1",.F.))
					SD1->D1_X_DBVEN := nDebito
					SD1->D1_X_TPOPE := 'DVVENDAS'
				SD1->(MsUnlock())

				SA3->(dbSeek(xFilial("SA3")+SD2->D2_X_VEND))
				SA3->(RecLock("SA3",.F.))
					SA3->A3_ACMMKT -= nDebito
				SA3->(MsUnlock())
			ElseIf AllTrim(SD2->D2_X_TPOPE) == 'BONIFICACAO' .And. SD2->D2_X_CRVEN > 0
				nCredito := (SD1->D1_QUANT * SD2->D2_X_CRVEN) / SD2->D2_QUANT

				SD1->(RecLock("SD1",.F.))
					SD1->D1_X_DBVEN := nCredito
					SD1->D1_X_TPOPE := 'DVBONIFICACAO'
				SD1->(MsUnlock())

				SA3->(dbSeek(xFilial("SA3")+SD2->D2_X_VEND))
				SA3->(RecLock("SA3",.F.))
					SA3->A3_ACMMKT += nCredito
				SA3->(MsUnlock())
			Endif

			SD1->(dbSkip())
		EndDo

		SD1->(Restarea(_aAreaSD1))
		SD2->(Restarea(_aAreaSD2))
		SA3->(Restarea(_aAreaSA3))
	Endif

Return nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CriaPVAV  ºAutor  ³Cristiam Rossi      º Data ³  21/01/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao que cria Pedido de Vendas conforme NF de Devolução  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Avant                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function CriaPVAV()
Local   aArea       := GetArea()
Local   aAreaSD1    := SD1->(GetArea())
Local   aAreaSB1    := SB1->(GetArea())
Local   aAreaSA1    := SA1->(GetArea())
Local   aCabPV
Local   aItemPV     := {}
Local   cNumPV      := CriaVar("C5_NUM")
Local   cItem		:= CriaVar("C6_ITEM")
Local   nValTot
Private lMsErroAuto := .F.

	If Empty(cItem)
		cItem := Soma1(cItem)
	EndIf

	SD1->(dbSetOrder(1)) 	//	D1_FILIAL + D1_DOC + D1_SERIE + D1_FORNECE + D1_LOJA + D1_COD + D1_ITEM
	SB1->(dbSetOrder(1)) 	//	B1_FILIAL + B1_COD
	SA1->(dbSetOrder(1)) 	//	A1_FILIAL + A1_COD + A1_LOJA

	SD1->(dbSeek( SF1->F1_FILIAL + SF1->F1_DOC + SF1->F1_SERIE + SF1->F1_FORNECE + SF1->F1_LOJA ))

	SA1->(dbSeek( xFilial() + SF1->F1_FORNECE + SF1->F1_LOJA ))

	aCabPV := 	{{"C5_NUM"    , cNumPV					,Nil},;
				 {"C5_TIPO"   , "N"						,Nil},;
				 {"C5_CLIENTE", SA1->A1_COD				,Nil},;
				 {"C5_CLIENT" , SA1->A1_COD				,Nil},;
				 {"C5_LOJAENT", SA1->A1_LOJA			,Nil},;
				 {"C5_LOJACLI", SA1->A1_LOJA			,Nil},;
		         {"C5_EMISSAO", dDatabase				,Nil},;
				 {"C5_CONDPAG", "001",Nil},; // Cond. Pagto. Ver Parâmetro?
				 {"C5_DESC1"  , 0						,Nil},;
				 {"C5_TIPLIB" , "1"						,Nil},;
				 {"C5_MOEDA"  , 1						,Nil},;
				 {"C5_TIPOCLI", SA1->A1_TIPO			,Nil},;
				 {"C5_TPFRETE", "C"                     ,Nil} }

	While ! SD1->(EOF()) .And.  SF1->F1_FILIAL+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA == ;
								SD1->D1_FILIAL+SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA

		SB1->(dbSeek( xFilial() + SD1->D1_COD ))

		nValTot := SD1->D1_QUANT * SD1->D1_VUNIT

		AAdd(aItemPV,{	{"C6_NUM"    ,cNumPV			,Nil},;
						{"C6_ITEM"   ,cItem				,Nil},;
						{"C6_PRODUTO",SD1->D1_COD		,Nil},;
						{"C6_QTDVEN" ,SD1->D1_QUANT		,Nil},;
						{"C6_PRUNIT" ,SD1->D1_VUNIT		,Nil},;
						{"C6_PRCVEN" ,SD1->D1_VUNIT		,Nil},;
						{"C6_VALOR"  ,nValTot			,Nil},;
						{"C6_ENTREG" ,dDatabase			,Nil},;
						{"C6_UM"     ,SD1->D1_UM		,Nil},;
						{"C6_SEGUM"  ,SD1->D1_SEGUM		,Nil},;
						{"C6_TES"    ,GetMv("MV_TESDEV"),Nil},; // Tipo de Entrada/Saida do Item
						{"C6_LOCAL"  ,"01"				,Nil},;
						{"C6_CLI"    ,SA1->A1_COD		,Nil},;
						{"C6_LOJA"   ,SA1->A1_LOJA		,Nil} })

		cItem := Soma1(cItem)

		SD1->(dbSkip())
	End

	MSExecAuto({|x,y,z|Mata410(x,y,z)},aCabPv,aItemPV,3)

	If lMsErroAuto
		DisarmTransaction()
    	Mostraerro()
	Else
		ConfirmSX8()
		MsgInfo("Pedido de Vendas Nº "+cNumPV+" criado com sucesso!","Pedido de Troca criado")
	EndIf

	SA1->(RestArea(aAreaSA1))
	SB1->(RestArea(aAreaSB1))
	SD1->(RestArea(aAreaSD1))
	RestArea(aArea)

Return nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ DispNFE   ³ Autor ³ Fernando Nogueira  ³ Data  ³ 06/01/14 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Dispara e-mail na Confirmacao da Nota de Entrada          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function DispNFE()

Local aArea    := GetArea()
Local aAreaSD1 := SD1->(GetArea())
Local aAreaSB1 := SB1->(GetArea())
Local	_cMailTo  := GetMv("ES_EMAILNF")
Local	_cCorpoM  := ""
Local	_cD1Quant := PesqPict("SD1","D1_QUANT")
Local	_cD1Vunit := PesqPict("SD1","D1_VUNIT")
Local	_cD1Total := PesqPict("SD1","D1_TOTAL")

SD1->(DbSetOrder(1))

If SD1->(dbSeek(SF1->F1_FILIAL+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA))
	_cCorpoM += '<html>'
	_cCorpoM += '<head>'
	_cCorpoM += '<title>Entrada de Nota com Data de Mês Retroativo</title>'
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
	_cCorpoM += '  <p align="center" class="style1"><strong>AVISO DE ENTRADA DE NFE COM DATA DE MÊS RETROATIVO</strong></p>'
	_cCorpoM += '  <p class="style1"><strong>Data: </strong>'+DtoC(Date())+'</p>'
	_cCorpoM += '  <p class="style1"><strong>Hora: </strong>'+Substr(Time(),1,5)+'</p>'
	_cCorpoM += '  <p class="style1"><strong>Filial : </strong>'+SM0->M0_FILIAL+'</p>'
	_cCorpoM += '  <p class="style1"><strong>NFE/Série: </strong>'+SF1->F1_DOC+"/"+SF1->F1_SERIE+'</p>'
	_cCorpoM += '  <p class="style1"><strong>Cliente/Loja: </strong>'+SF1->F1_FORNECE+"/"+SF1->F1_LOJA+'</p>'
	_cCorpoM += '  <p class="style1"><strong>Data Base/Data Real: </strong>'+DTOC(dDataBase)+" - "+DTOC(Date())+'</p>'
	_cCorpoM += '  <p class="style1"><strong>Usuário: </strong>'+cUserName+'</p>'
	_cCorpoM += '  <table width="1900" border="1" align="left"> '
	_cCorpoM += '    <tr>
	_cCorpoM += '      <td align="center" width="35"><span class="style3">Item</span></td>'
	_cCorpoM += '      <td align="center" width="80"><span class="style3">Produto</span></td>'
	_cCorpoM += '      <td align="center" width="250"><span class="style3">Descricao</span></td>'
	_cCorpoM += '      <td align="center" width="70"><span class="style3">Quantidade</span></td>'
	_cCorpoM += '      <td align="center" width="70"><span class="style3">Vlr Unit</span></td>'
	_cCorpoM += '      <td align="center" width="70"><span class="style3">Vlr Total</span></td>'
	_cCorpoM += '      <td align="center" width="70"><span class="style3">TES</span></td>'
	_cCorpoM += '      <td align="center" width="90"><span class="style3">CFOP</span></td>'
	_cCorpoM += '    </tr>'
	While SD1->(!Eof()) .And. SD1->D1_FILIAL+SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA == SF1->F1_FILIAL+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA

		_cCorpoM += '    <tr>'
		_cCorpoM += '     <td align="center"><span>'+SD1->D1_ITEM+'</span></td>'
		_cCorpoM += '	   <td align="center"><span>'+SD1->D1_COD+'</span></td>'
		_cCorpoM += '	   <td><span>'+AllTrim(Posicione("SB1",1,xFilial("SB1")+SD1->D1_COD,"B1_DESC"))+'</span></td>'
		_cCorpoM += '	   <td align="right"><span>'+Transform(SD1->D1_QUANT  , _cD1Quant)+'</span></td>'
		_cCorpoM += '	   <td align="right"><span>'+Transform(SD1->D1_VUNIT, _cD1Vunit)+'</span></td>'
		_cCorpoM += '	   <td align="right"><span>'+Transform(SD1->D1_TOTAL, _cD1Total)+'</span></td>'
		_cCorpoM += '	   <td align="center"><span">'+SD1->D1_TES+'</span></td>'
		_cCorpoM += '	   <td align="center"><span">'+SD1->D1_CF+'</span></td>'
		_cCorpoM += '    </tr>'
		SD1->(dbSkip())
	EndDo
	_cCorpoM += '  </table>'
	_cCorpoM += '</body>'
	_cCorpoM += '</html>'
	U_MHDEnvMail(_cMailTo, "", "", "Entrada da Nota: "+SF1->F1_DOC+"/"+SF1->F1_SERIE+" com Data Retroativa ["+AllTrim(SM0->M0_CODFIL)+" / "+AllTrim(SM0->M0_FILIAL)+"]", _cCorpoM, "")
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³  Retorna a situacao inicial       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SB1->(RestArea(aAreaSB1))
SD1->(RestArea(aAreaSD1))
RestArea(aArea)

Return
