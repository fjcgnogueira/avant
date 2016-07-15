#INCLUDE "Protheus.ch"
#INCLUDE "TOPCONN.CH"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ Pedido50 º Autor ³ Fernando Nogueira  º Data ³ 11/07/2016  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Gera Pedido com todos os produtos ao Armazem 50.           º±±
±±º          ³ Chamado 003544.                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico AVANT                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function Pedido50()

Local lEnd      := .F.

Private _x_oProcess

If MsgNoYes("Colocar Pedido(s) de Sucata do Armazém 50?")
	_x_oProcess := MsNewProcess():New({|lEnd| ColocPed(lEnd)},"Processando...","Colocando Pedidos...",.T.)
	_x_oProcess:Activate()
Endif

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ColocPed  ºAutor  ³ Fernando Nogueira  º Data ³ 14/07/2016  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Colocando o(s) Pedido(s)                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ColocPed(lEnd)

Local cPathLog	:= "\LOGS\"
Local cFileLog	:= "Pedido50.LOG"
Local cPedNew 	:= ""
Local cTransp 	:= ""
Local cTpFrete	:= "C"
Local cAliasSB2	:= GetNextAlias()
Local aCabec	:= {}
Local aItens	:= {}
Local aLinha 	:= {}
Local aMensagem	:= {}
Local nPedidos	:= 0
Local nAte		:= 0
Local nCount	:= 0
Local nPreco	:= 0
Local oMemo
Local oDlg
Local oFont
Local cEOL		:= Chr(13)+Chr(10)
Local cMensagem	:= ""
Local aProdOk	:= {}
Local lContinua	:= .T.

Private nRegua1		:= 0
Private nRegua2		:= 0
Private lMsErroAuto	:= .F.

dbSelectArea("SA1")
dbSetOrder(01)
dbGoTop()

If dbSeek(xFilial("SA1")+AllTrim(GetMv("ES_CLI50")))

	BeginSQL Alias cAliasSB2
		SELECT B2_COD,B2_LOCAL,B1_MSBLQL,B2_QATU,B2_CM1,B2_VATU1,B2_RESERVA,B2_QEMP,B2_QACLASS FROM %Table:SB2% SB2
		INNER JOIN %Table:SB1% SB1 ON B2_COD = B1_COD AND SB1.%NotDel%
		WHERE SB2.%NotDel%
			AND B2_FILIAL = %Exp:xFilial("SB2")% 
			AND B2_LOCAL = '50' 
			AND B2_QATU > 0
	EndSQL
	
	(cAliasSB2)->(dbGoTop())
	
	While !(cAliasSB2)->(Eof())
	
		If Empty(cMensagem) .And. ((cAliasSB2)->(B2_RESERVA+B2_QEMP+B2_QACLASS) > 0 .Or. (cAliasSB2)->B1_MSBLQL == '1' .Or. (cAliasSB2)->B2_CM1 == 0)
			cMensagem += "Produtos com Restrição:" + cEOL + cEOL
		Endif
		
		If (cAliasSB2)->(B2_RESERVA+B2_QEMP+B2_QACLASS) > 0
			cMensagem += "Produto " + AllTrim((cAliasSB2)->B2_COD) + " sem saldo disponível" + cEOL
		ElseIf (cAliasSB2)->B1_MSBLQL == '1'
			cMensagem += "Produto " + AllTrim((cAliasSB2)->B2_COD) + " bloqueado" + cEOL
		ElseIf (cAliasSB2)->B2_CM1 == 0
			cMensagem += "Produto " + AllTrim((cAliasSB2)->B2_COD) + " com custo zero" + cEOL
		Else
			aAdd(aProdOk,{(cAliasSB2)->B2_COD,(cAliasSB2)->B2_QATU,(cAliasSB2)->B2_LOCAL,(cAliasSB2)->B2_CM1})
		Endif
		
		(cAliasSB2)->(dbSkip())
	End
	
	If !Empty(cMensagem)
		cMensagem += cEOL + "Caso queira continuar o processo, serão colocados" + cEOL
		cMensagem += "os Pedidos sem esses produtos."
		
		DEFINE MSDIALOG oDlg TITLE "Produtos com Restrição" From 3,0 to 340,417 PIXEL
		@ 5,5 GET oMemo VAR cMensagem MEMO SIZE 200,145 OF oDlg PIXEL READONLY
		oMemo:bRClicked := {||AllwaysTrue()}
		oMemo:oFont:=oFont
		DEFINE SBUTTON  FROM 153,145 TYPE 1 ACTION (lContinua:=MsgNoYes("Continuar assim mesmo?"),oDlg:End()) ENABLE OF oDlg PIXEL
		DEFINE SBUTTON  FROM 153,175 TYPE 2 ACTION (lContinua:=.F.,oDlg:End()) ENABLE OF oDlg PIXEL
		ACTIVATE MSDIALOG oDlg CENTER
	Endif

	If !lContinua
		Return
	Endif

	nRegua1 := Len(aProdOk)
	
	_x_oProcess:SetRegua1(nRegua1)
	
	nPedidos := NoRound(nRegua1/99,0)
	nResto   := Mod(nRegua1,99)
	
	If nResto > 0
		nPedidos++
	Endif
	
	cTransp  := Posicione("SZ1",1,xFilial("SZ1")+SA1->A1_COD+SA1->A1_LOJA,"SZ1->Z1_TRANSP")

	For _y := 1 To nRegua1
	
		aCabec  := {}
		aItens  := {}
		cPedNew	:= U_NUMPED()
		
		aAdd(aCabec, {"C5_FILIAL" , xFilial("SC5")	, NIL} )
		aAdd(aCabec, {"C5_NUM"    , cPedNew       	, NIL} )
		aAdd(aCabec, {"C5_EMISSAO", Date()			, NIL} )
		aAdd(aCabec, {"C5_TIPO"   , "N"				, NIL} )
		aAdd(aCabec, {"C5_CLIENTE", SA1->A1_COD   	, NIL} )
		aAdd(aCabec, {"C5_LOJACLI", SA1->A1_LOJA  	, NIL} )
		aAdd(aCabec, {"C5_TRANSP" , cTransp       	, NIL} )
		aAdd(aCabec, {"C5_CONDPAG", SA1->A1_COND  	, NIL} )
		aAdd(aCabec, {"C5_TPFRETE", cTpFrete      	, NIL} )
		
		nCount++
		
		If nCount == nPedidos .And. nResto > 0
			nRegua2 := nResto
		Else
			nRegua2 := 99
		Endif
		
		_x_oProcess:SetRegua2(nRegua2)		
		
		For _n := 1 To 99
		
			_x_oProcess:IncRegua1("Colocando Pedido "+StrZero(nCount,02)+"/"+StrZero(nPedidos,02))
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³aProdOk    |  [01]   |  [02]  |  [03]   | [02]  |
			//³           | Produto | Quant. | Armazem | Preco |
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

			aLinha := {}
			aAdd(aLinha, {"C6_FILIAL" , xFilial("SC6")	, NIL} )
			aAdd(aLinha, {"C6_ITEM"   , StrZero(_n,02)	, NIL} )
			aAdd(aLinha, {"C6_PRODUTO", aProdOk[_y,01]	, NIL} )
			aAdd(aLinha, {"C6_QTDVEN" , aProdOk[_y,02]	, NIL} )
			aAdd(aLinha, {"C6_QTDLIB" , aProdOk[_y,02]	, NIL} )
			aAdd(aLinha, {"C6_OPER"   , "72"			, NIL} )
			aAdd(aLinha, {"C6_LOCAL"  , aProdOk[_y,03]	, NIL} )
			aAdd(aLinha, {"C6_PRCVEN" , aProdOk[_y,04]	, NIL} )
		
			aAdd(aItens,aLinha)
			
			_y++
			
			If _y > nRegua1
				lContinua	:= .F.
				Exit
			Endif
		Next
		
		If Len(aItens) > 0
			MsExecAuto({|a, b, c| MATA410(a, b, c)}, aCabec, aItens, 3)
			
			If lMsErroAuto
				lRetorno	:= .F.
				MostraErro(cPathLog, cFileLog)
				aAdd(aMensagem,"Pedido "+cPedNew+" com erro na integração, verificar log.")
				RollBackSx8()
			Else
				aAdd(aMensagem,"Pedido "+cPedNew+" integrado com sucesso.")
			EndIf
		Endif
		
		If lContinua
			_y--
		Endif
	Next
	
	If Len(aMensagem) == 0
		aAdd(aMensagem,"Nenhum Pedido a Colocar")
	Endif
	
	aArrBut := {{1, .T., {|| lExeFun := .T., FechaBatch()}}}
	FormBatch('Integração de Pedidos',aMensagem,aArrBut)
	
	(cAliasSB2)->(DbCloseArea())

Else
	ApMsgInfo("Cliente para Nota de Sucata Invélido")
Endif

Return
