#include "TOTVS.ch"
#include "rwmake.ch"

/*----------------------+--------------------------------+------------------+
|   Programa: M440STTS  | Autor: Kley Gonçalves          | Data: Julho/2014 |
+-----------------------+--------------------------------+------------------+
|  Descricao: Ponto de entrada para apagar os registros de Alçada de 
|				Aprovação, se existir registros na SCR.
|				Se tipo do pedido (C5_TIPO) = 'N' e gerou registro na SC9 
|				cria alcada de aprovacao. 
+---------------------------------------------------------------------------+
|    Projeto: AVANT
+--------------------------------------------------------------------------*/

User Function M440STTS

Local _lBloqueia	:= .F.
Local aAreaSC9	:= GetArea("SC9")
Local aAreaSC5	:= GetArea("SC5")
Local aAreaSC6	:= GetArea("SC6")
Local aAreaSA1	:= GetArea("SA1")
Local aAreaSE4	:= GetArea("SE4")
Local cAlias 		:= GetNextAlias()
Local cExecSQL	:= ""
Local cGrpAprov	:= Alltrim(GetMV("MV_XGRAPPV"))
Local cGrpAprCR	:= Alltrim(GetMV("MV_XGRAPCR"))

cExecSQL := " DELETE FROM "+RetSqlName('SCR')
cExecSQL += " WHERE CR_FILIAL = '"+xFilial('SCR')+"' "
cExecSQL += " AND   CR_TIPO   = 'PV' "
cExecSQL += " AND   CR_NUM    = '"+SC5->C5_NUM+"' "
cExecSQL += " AND   D_E_L_E_T_ = ' ' "
TcSqlExec(cExecSQL)

SC5->( RecLock('SC5',.f.) ) 
	SC5->C5_X_WF := ' '
SC5->( MsUnLock() )
	
/*-------------------------------------------------------------------------+
|  Gerar aprovacao de PV somente para pedidos Normais.                     |                                            
+--------------------------------------------------------------------------*/
If IsInCallStack("A410DELETA") .Or. SC5->C5_TIPO <> 'N'
	Return
EndIf

SA1->(DbSetOrder(1),DbSeek(xFilial("SA1")+SC5->(C5_CLIENTE+C5_LOJACLI)))
SE4->(DbSetOrder(1),DbSeek(xFilial("SE4")+SC5->C5_CONDPAG))

If "ANTECIPADO" $ Upper(SE4->E4_DESCRI)
	If !Empty(cGrpAprCR)
		// Comentado temporariamente para teste, pedidos de bonificacao com pgto antecipado estao entrando em aberto - Fernando Nogueira
		//cGrpAprov	:= cGrpAprCR
		If !IsBlind()
			MsgInfo("A Condição de Pagamento do Pedido é de recebimento 'Antecipado'."+CRLF+;
					 "Por isso a Alçada de Aprovação será gerada para o Grupo de Aprovação do Contas a Receber: " + cGrpAprov,"Alçada de Aprovação")
		EndIf
	Else
		If !IsBlind()
			MsgAlert("A Condição de Pagamento do Pedido é de recebimento 'Antecipado', mas " + ;
					  "o Grupo de Aprovação do Contas a Receber não está parametrizado."+CRLF+;
					 "Por isso a Alçada de Aprovação será gerada para o Grupo de Aprovação padrão do sistema: " + cGrpAprov,"Alçada de Aprovação")
		EndIf	
	EndIf
Else
	If Empty(SA1->A1_X_GRAPV)
		If !IsBlind()
			MsgAlert("Não existe Grupo de Aprovação de liberação de crédito do Pedido de Venda relacionado ao Cliente."+CRLF+;
					 "Por isso a Alçada de Aprovação será gerada para o Grupo de Aprovação padrão do sistema: " + cGrpAprov,"Alçada de Aprovação")
		EndIf
	Else
		cGrpAprov	:= SA1->A1_X_GRAPV
	EndIf
EndIf

If Select(cAlias) > 0
	(cAlias)->(dbCloseArea())
Endif
BeginSQL Alias cAlias
	select sum( (C6_QTDVEN - C6_QTDENT)*C6_PRCVEN ) as TOTPED, count(SC9.C9_ITEM+SC9.C9_SEQUEN) as REGS
	from %Table:SC6% SC6
	left join SC9010 SC9 on C9_FILIAL = C6_FILIAL 
	  and C9_CLIENTE = C6_CLI and C9_LOJA = C6_LOJA and C9_PEDIDO = C6_NUM and C9_ITEM = C6_ITEM and SC9.%NotDel%
	where SC6.C6_FILIAL = %xFilial:SC6% and SC6.C6_NUM = %Exp:SC5->C5_NUM% and SC6.%NotDel%
	group by C6_FILIAL, C6_NUM
EndSQL
(cAlias)->(DbGoTop())

/*--------------------------------------------------------------------------+
| Verificar se houve a geracao do SC9. Se nao foi gerado, nao deve-se utili-|
| zar a geracao de alcadas. Caso contrario, prosseguir com as alcadas.      |
| Caso o PV entrou sem bloqueio de Crédito, gerar o SCR com status que sina-|
| lize liberacao automatica:                                                |
|  Gerar aprovacao de PV somente para pedidos Normais.                      |                                            
+---------------------------------------------------------------------------*/

If Empty(cGrpAprov) .and. !IsBlind()
	MsgStop("Não gerada Alçada de Aprovação, porque o Grupo de Aprovação não está parametrizado corretamente.","Alçada de Aprovação")
EndIf

If (cAlias)->REGS > 0
	U_MaAlcDoc( {SC5->C5_NUM,"PV",(cAlias)->TOTPED,,,cGrpAprov,,,,,},Date(),1, "" )
	If !IsBlind()
		MsgInfo("Alçada de Aprovação gerada.","Alçada de Aprovação")	&&Kley
	EndIf
Else
	If !IsBlind()
		MsgInfo("Não gerada Alçada de Aprovação.","Alçada de Aprovação")	&&Kley
	EndIf
EndIf

// Grava o Total com Impostos no Pedido na Rotina de Liberacao
If AllTrim(FUNNAME()) == 'MATA440'
	XTOTPED()
Endif

SE4->( RestArea(aAreaSE4) )
SA1->( RestArea(aAreaSA1) )
SA1->( RestArea(aAreaSC6) )
SA1->( RestArea(aAreaSC5) )
SA1->( RestArea(aAreaSC9) )

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ XTOTPED  ³ Autor ³ Fernando Nogueira     ³ Data ³23/05/2016³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Atualiza valor total do Pedido com Impostos (C5_XTOTPED)   ³±±
±±³          ³ Chamado 003021                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Utilizacao³ AVANT                                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function XTOTPED()

Local nPosProd 	:= aScan(aHeader,{|x| AllTrim(x[2]) == "C6_PRODUTO"})
Local nPosTes	:= aScan(aHeader,{|x| AllTrim(x[2]) == "C6_TES"})
Local nPosPrc	:= aScan(aHeader,{|x| AllTrim(x[2]) == "C6_PRCVEN"})
Local nPosTot	:= aScan(aHeader,{|x| AllTrim(x[2]) == "C6_VALOR"})
Local cCliente	:= M->C5_CLIENTE
Local cLojaCli	:= M->C5_LOJACLI
Local nFrete	:= M->C5_FRETE
Local cEstFrete	:= Posicione("SX5",1,xFilial("SX5")+"ZA"+"0002","X5_DESCRI")
Local cEstado 	:= Posicione("SA1",1,xFilial("SA1")+M->C5_CLIENTE+M->C5_LOJACLI,"A1_EST")
Local cHabFrete	:= SA1->A1_X_HBFRT
Local cPessoa	:= SA1->A1_PESSOA
Local nSomaTot	:= 0
Local aImpostos	:= {}
Local nPrcVen	:= 0
Local nTotPed	:= 0
Local nX		:= 0
Local nDescSuf 	:= 0
Local _nItens 	:= 0

Local aArea		:= GetArea()
Local aAreaSC5	:= SC5->(GetArea())
Local aAreaSA1	:= SA1->(GetArea())

Local lFim := .T.
Local oDlg      := Nil
Local cTeste := Space(60)

// Quantidade de itens do Pedido
For _nX := 1 To Len(aCols)
	If !aCols[_nX][Len(aHeader)+1]
		nSomaTot += aCols[_nX,nPosTot]
		_nItens++
	Endif
Next _nX

If nSomaTot > 0 .And. nSomaTot < 1500 .And. cEstado $ cEstFrete .And. M->C5_TPFRETE == "C" .And. cPessoa <> "F" .And. nFrete == 0 .And. cHabFrete == "S"
	nFrete := Val(Substr(cEstFrete,At(cEstado,cEstFrete)+2,6))/100
Endif

For nX := 1 To Len(aCols)
	If !aCols[nX][Len(aHeader)+1]

		DbSelectarea("SA1")
		SA1->(DbSetorder(1))
		If SA1->(DbSeek(xFilial("SA1") + cCliente + cLojaCli))

			MaFisIni(	SA1->A1_COD		,;		// 01-Codigo Cliente
						SA1->A1_LOJA	,;		// 02-Loja do Cliente
						"C"				,;		// 03-C:Cliente , F:Fornecedor
						"N"				,;		// 04-Tipo da NF
						SA1->A1_TIPO	,;		// 05-Tipo do Cliente
						Nil				,;		// 06-Relacao de Impostos que suportados no arquivo
						Nil				,;		// 07-Tipo de complemento
						Nil				,;		// 08-Permite Incluir Impostos no Rodape .T./.F.
						"SB1"			,;		// 09-Alias do Cadastro de Produtos - ("SBI" P/ Front Loja)
						"MATA461"		,;		// 10-Nome da rotina que esta utilizando a funcao
						Nil				,;		// 11-Tipo de documento
						Nil				,;		// 12-Especie do documento
						Nil				,;		// 13-Codigo e Loja do Prospect
						SA1->A1_GRPTRIB,;		// 14-Grupo Cliente
						Nil				,;		// 15-Recolhe ISS
						Nil				,;		// 16-Codigo do cliente de entrega na nota fiscal de saida
						Nil				,;		// 17-Loja do cliente de entrega na nota fiscal de saida
						Nil				)		// 18-Informacoes do transportador [01]-UF,[02]-TPTRANS


			nPrcVen	:= aCols[nX][nPosTot]

			//Adiciona o Produto para Calculo dos Impostos
			nItem := 	MaFisAdd(	aCols[nX][nPosProd]		,;   	// 1-Codigo do Produto ( Obrigatorio )
									aCols[nX][nPosTes]		,;	   	// 2-Codigo do TES ( Opcional )
									1						,;	   	// 3-Quantidade ( Obrigatorio )
									aCols[nX][nPosPrc]		,;   	// 4-Preco Unitario ( Obrigatorio )
									0						,;  	// 5-Valor do Desconto ( Opcional )
									""						,;	   	// 6-Numero da NF Original ( Devolucao/Benef )
									""						,;		// 7-Serie da NF Original ( Devolucao/Benef )
									0						,;		// 8-RecNo da NF Original no arq SD1/SD2
									nFrete*(aCols[nX][nPosTot]/nSomaTot),;	// 9-Valor do Frete do Item ( Opcional )
									0						,;		// 10-Valor da Despesa do item ( Opcional )
									0						,;		// 11-Valor do Seguro do item ( Opcional )
									0						,;		// 12-Valor do Frete Autonomo ( Opcional )
									aCols[nX][nPosTot]		,;		// 13-Valor da Mercadoria ( Obrigatorio )
									0						,;		// 14-Valor da Embalagem ( Opiconal )
									NIL						,;		// 15-RecNo do SB1
									NIL						,;		// 16-RecNo do SF4
									NIL						)

			aImpostos	:= MafisRet(NIL, "NF_IMPOSTOS")
			If Len(aImpostos) > 0
				nPosRet		:= Ascan(aImpostos, {|x| AllTrim(x[01]) == "ICR"})
				nPosIPI		:= Ascan(aImpostos, {|x| AllTrim(x[01]) == "IPI"})

				If nPosRet > 0
					nPrcVen	:= nPrcVen + aImpostos[nPosRet][05]
				EndIf

				If nPosIPI > 0
					nPrcVen	:= nPrcVen + aImpostos[nPosIPI][05]
				EndIf

				If SA1->A1_CALCSUF = 'S'
					nDescSuf := MafisRet(,"IT_DESCZF")
					nPrcVen  := nPrcVen - nDescSuf
				Endif

			EndIf

			nTotFrete   := MaFisRet(NIL, "NF_FRETE")
			If nTotFrete > 0
				nPrcVen += nTotFrete
			Endif

			//Finaliza Funcao Fiscal
			MaFisEnd()

			nTotPed += nPrcVen

		EndIf

	EndIf

Next nX

// Grava o Valor Total
If nTotPed > 0
	If SC5->(Reclock("SCR",.F.))
		SC5->C5_XTOTPED := nTotPed
	Endif
	// Atualiza Total com impostos no cadastro de clientes
	SA1->(RecLock("SA1",.F.))
		SA1->A1_X_VLRTO := U_TotPedCred(cCliente,cLojaCli)
	SA1->(MsUnlock())
EndIf

RestArea(aArea)
SA1->(RestArea(aAreaSA1))
SC5->(RestArea(aAreaSC5))

Return
