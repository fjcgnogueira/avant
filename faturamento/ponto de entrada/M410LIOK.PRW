#INCLUDE "Protheus.CH"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ M410LIOK º Autor ³ Fernando Nogueira  º Data ³  28/10/2013 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Ponto de entrada na validacao de linha do Pedido de Vendas.º±±
±±º          ³ Chamado 000022.                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Avant                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function M410LIOK()

Local lReturn    := .T.
Local nPosQtdVen := aScan(aHeader,{|x|Trim(x[2])=="C6_QTDVEN"})
Local nPosQtdLib := aScan(aHeader,{|x|Trim(x[2])=="C6_QTDLIB"})
Local nPosLocal  := aScan(aHeader,{|x|Trim(x[2])=="C6_LOCAL"})
Local nPosOper   := aScan(aHeader,{|x|Trim(x[2])=="C6_OPER"})
Local nPosProd   := aScan(aHeader,{|x|Trim(x[2])=="C6_PRODUTO"})
Local nPosServic := aScan(aHeader,{|x|Trim(x[2])=="C6_SERVIC"})
Local nPosEndPad := aScan(aHeader,{|x|Trim(x[2])=="C6_ENDPAD"})
Local nPosItem   := aScan(aHeader,{|x|Trim(x[2])=="C6_ITEM"})
Local nPosTes    := aScan(aHeader,{|x|Trim(x[2])=="C6_TES"})
Local nPosReserv := aScan(aHeader,{|x|Trim(x[2])=="C6_RESERVA"})
Local aAreaSF4   := SF4->(GetArea())
Local aAreaSB1   := SB1->(GetArea())
Local aAreaSA1   := SA1->(GetArea())

If IsMemVar("_x_oProcess")
	_x_oProcess:IncRegua2("Colocando Pedido "+AllTrim(M->C5_NUM)+" Item "+aCols[n][nPosItem]+"/"+StrZero(nRegua2,02))
Endif

If Empty(M->C5_TRANSP)
	MsgInfo('Necessário definir a Transportadora antes de Incluir uma Linha!', 'Atenção')
	lReturn := .F.
ElseIf AllTrim(aRotina[3][2]) <> 'A410Copia' .And. Inclui .And. Empty(aCols[n][nPosOper]) .And. !aCols[n][Len(aHeader)+1]
	MsgInfo('Obrigatório o preenchimento do Tipo de Operação!', 'Atenção')
	lReturn := .F.
ElseIf Empty(M->C5_CLIENTE)
	MsgInfo('Necessário definir o Cliente antes de Incluir uma Linha!', 'Atenção')
	aCols[n][nPosOper] := Space(02)
	lReturn := .F.
ElseIf Posicione("SA1",01,xFilial("SA1")+M->C5_CLIENTE+M->C5_LOJACLI,"A1_X_FATPA") <> 'S' .And. ; //Fernando Nogueira - Chamado 004777
				  aCols[n][nPosQtdLib] > 0 .And. aCols[n][nPosQtdVen] > aCols[n][nPosQtdLib]
	MsgInfo('Não é permitido liberação parcial para esse cliente!', 'Atenção')
	aCols[n][nPosOper] := Space(02)
	lReturn := .F.
ElseIf !Empty(aCols[n][nPosServic]) .And. Empty(aCols[n][nPosEndPad]) //Fernando Nogueira - Chamado 002385
	MsgInfo('Necessário definir o End. Destino!', 'Atenção')
	lReturn := .F.
Endif

If lReturn .And. n <> 1 .AND. !aCols[n,Len(aHeader)+1]
	If Posicione("SB1",1,xFilial("SB1")+aCols[n][nPosProd],"B1_UTLCOMS") <> Posicione("SB1",1,xFilial("SB1")+aCols[n-1][nPosProd],"B1_UTLCOMS")
		If Posicione('SF4',1,xFilial('SF4')+aCols[n][nPosTes],'F4_DUPLIC') == "S"  // Fernando Nogueira - Chamado 005259
			MsgAlert('Existe conflito de produtos que geram comissão com produtos que não geram! Será necessário fazer pedidos separados.', 'Atenção')
			lReturn := .F.
		Endif
	Endif
Endif

//If AllTrim(SM0->M0_CODFIL) == "010104" .And. aScan(PswRet(1)[1][10],'000057') == 0 .And. aCols[n][nPosLocal] <> '01'
//	MsgInfo('Estoque diferente de "01" somente é permitido aos usuários de logística!', 'Atenção')
//	lReturn := .F.
//Endif

// Verifica se a quantidade liberada eh maior que o saldo disponivel em estoque na inclusao do Pedido de Vendas
If Posicione('SF4',1,xFilial('SF4')+aCols[n][nPosTes],'F4_ESTOQUE') == "S" //Chamado 002624
	If lReturn .And. Inclui .And. Empty(aCols[n][nPosReserv]) .And. aCols[n][nPosQtdLib] > U_SaldoProd(aCols[n][nPosProd],aCols[n][nPosLocal])
		MsgInfo('Quantidade liberada do produto '+AllTrim(aCols[n][nPosProd])+' maior que o saldo disponível em estoque!', 'Atenção')
		lReturn := .F.
	Endif
Endif

SF4->(Restarea(aAreaSF4))
SB1->(Restarea(aAreaSB1))
SA1->(Restarea(aAreaSA1))

/*If (aCols[n][nPosOper]$"6,51,06") .And. !IsBlind()
	lReturn := .T.
Else
	MsgInfo('Não é permitido usar esse Tipo de Operação!', 'Atenção')
	lReturn := .F.
EndIf*/

Return lReturn
