#INCLUDE "Protheus.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ M410LIOK º Autor ³ Fernando Nogueira  º Data ³  28/10/13   º±±
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

Local cEOL		 := Chr(13)+Chr(10)
Local lReturn    := .T.
Local nPosQtdVen := aScan(aHeader,{|x|Trim(x[2])=="C6_QTDVEN"})
Local nPosQtdLib := aScan(aHeader,{|x|Trim(x[2])=="C6_QTDLIB"})
Local nPosLocal  := aScan(aHeader,{|x|Trim(x[2])=="C6_LOCAL"})
Local nPosOper   := aScan(aHeader,{|x|Trim(x[2])=="C6_OPER"})
Local nPosProd   := aScan(aHeader,{|x|Trim(x[2])=="C6_PRODUTO"})
Local nPosTes    := aScan(aHeader,{|x|Trim(x[2])=="C6_TES"})
Local nPosServic := aScan(aHeader,{|x|Trim(x[2])=="C6_SERVIC"})
Local nPosEndPad := aScan(aHeader,{|x|Trim(x[2])=="C6_ENDPAD"})
Local cDuplic    := ''

If aCols[n][nPosQtdLib] > 0 .And. aCols[n][nPosQtdVen] > aCols[n][nPosQtdLib]
	MsgInfo('Não é permitido liberação parcial!', 'Atenção')
	lReturn := .F.
ElseIf AllTrim(aRotina[3][2]) <> 'A410Copia' .And. Inclui .And. Empty(aCols[n][nPosOper]) .And. !aCols[n][Len(aHeader)+1]
	MsgInfo('Obrigatório o preenchimento do Tipo de Operação!', 'Atenção')
	lReturn := .F.
ElseIf Empty(M->C5_CLIENTE)
	MsgInfo('Necessário definir o Cliente antes de Incluir uma Linha!', 'Atenção')
	aCols[n][nPosOper] := Space(02)
	lReturn := .F.
ElseIf Empty(M->C5_TRANSP)
	MsgInfo('Necessário definir a Transportadora antes de Incluir uma Linha!', 'Atenção')
	aCols[n][nPosOper] := Space(02)
	lReturn := .F.
ElseIf !Empty(aCols[n][nPosServic]) .And. Empty(aCols[n][nPosEndPad]) //Fernando Nogueira - Chamado 002385
	MsgInfo('Necessário definir o End. Destino!', 'Atenção')
	lReturn := .F.
Endif


If n <> 1 .AND. !aCols[n,Len(aHeader)+1]
	If Posicione("SB1",1,xFilial("SB1")+aCols[n][nPosProd],"B1_UTLCOMS") <> Posicione("SB1",1,xFilial("SB1")+aCols[n-1][nPosProd],"B1_UTLCOMS")
		MsgAlert('Existe conflito de produtos que geram comissão com produtos que não geram! Será necessário fazer pedidos separados.', 'Atenção')
		lReturn := .F.
	Endif  
Endif

// Faz uma varredura no aCols
For _n := 1 to Len(aCols)
	// Caso a linha nao esteja deletada
	If !aCols[_n,Len(aHeader)+1]
		// Chamado 001447 - Fernando Nogueira
		If !Empty(cDuplic) .And. cDuplic <> Posicione('SF4',1,xFilial('SF4')+aCols[_n][nPosTes],'F4_DUPLIC')
			ApMsgAlert('Incompatibilidade de Geração de Duplicatas!'+cEOL+'Item que gera duplicata e item que não gera.')
			ConOut('Incompatibilidade de Geração de Duplicatas!'+cEOL+'Item que gera duplicata e item que não gera.')
			Return .F.
		EndIf
		cDuplic := Posicione('SF4',1,xFilial('SF4')+aCols[_n][nPosTes],'F4_DUPLIC')
	Endif
End

//If AllTrim(SM0->M0_CODFIL) == "010104" .And. aScan(PswRet(1)[1][10],'000057') == 0 .And. aCols[n][nPosLocal] <> '01'
//	MsgInfo('Estoque diferente de "01" somente é permitido aos usuários de logística!', 'Atenção')
//	lReturn := .F.
//Endif


/*If (aCols[n][nPosOper]$"6,51,06") .And. !IsBlind()
	lReturn := .T.
Else
	MsgInfo('Não é permitido usar esse Tipo de Operação!', 'Atenção')
	lReturn := .F.
EndIf*/
	
	
Return lReturn