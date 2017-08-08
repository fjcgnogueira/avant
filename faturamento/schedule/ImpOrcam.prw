#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±º ImpOrcam ³ Consulta º Autor ³ Rogerio Machado    º Data ³  02/08/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Calcular impostos de orcamentos web                        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico AVANT                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function ImpOrcam()

Local lRetorno 	:= .T.
Local cPicture	:= "@E 999,999,999,999.99"

//Local cEmpCons	:= EmpCons
//Local cFilCons	:= FilCons
//Local cCliente	:= Cliente
Local cLojaCli	:= ""
Local cTpOper	:= "51"
Local cProduto	:= ""//PadR(Produto,TamSx3("B1_COD")[1])
Local cLocal	:= "01"
Local nQtdProd	:= ""
Local nVlrProd	:= 0
Local cTesOper	:= ""
Local nVlrTot	:= 0
Local nItem		:= 0
Local cItemped  := ""
Local aImpostos	:= {}
Local nVlrIcm	:= 0
Local nVlrIpi	:= 0
Local nVlrIcc	:= 0
Local nVlrDif	:= 0
Local nVlrPis	:= 0
Local nVlrCof	:= 0
Local nVlrRet	:= 0
Local nDescSuf	:= 0
Local cPedWeb	:= ""
Local lSZ4      := ""
//Local aTabelas	:= {"SA1", "SC5", "SC6", "SC9", "SD2", "SF2", "SF4", "SF5", "SFM", "SB1", "SB2", "SB9"}

//Private _lSchedule  := aParam[1]
/*
If _lSchedule
	PREPARE ENVIRONMENT EMPRESA aParam[2] FILIAL aParam[3]
Endif
*/

BeginSql alias 'TRB'

	SELECT Z3_NPEDWEB, Z3_WA1_COD, Z3_WA1_LOJ, Z4_CODPROD, Z4_QTDE, Z4_PRVEN, Z4_ITEMPED  FROM %table:SZ3% SZ3
	INNER JOIN %table:SZ4% SZ4 ON Z3_FILIAL = Z4_FILIAL AND Z3_NPEDWEB = Z4_NUMPEDW AND SZ4.%notDel%
	WHERE SZ3.%notDel% AND Z3_STATUS = '8'
	AND Z4_NUMPEDW IN ('864079','864080','864081')
	ORDER BY Z3_NPEDWEB, Z4_ITEMPED

EndSql

DbSelectArea('TRB')
DbGotop()


ConOut('['+ Dtoc(date()) +']' +' ['+ time() + '] [INICIO DA ROTINA DE GERAR IMPOSTOS DE ORCAMENTOS]')

While TRB->(!EoF())

	
	cCliente = TRB->Z3_WA1_COD
	cLojaCli = TRB->Z3_WA1_LOJ
	cPedWeb  = PadL(TRB->Z3_NPEDWEB,TamSx3("Z3_NPEDWEB")[01])
	cProduto = Alltrim(TRB->Z4_CODPROD)
	nQtdProd = TRB->Z4_QTDE
	nVlrProd = TRB->Z4_PRVEN
	nVlrTot  = (nQtdProd * nVlrProd)
	cItemped = TRB->Z4_ITEMPED	
	
	nVlrTot := nQtdProd * nVlrProd
	

		
	DbSelectarea("SA1")
	SA1->(DbSetorder(1))
	SZ4->(dbGoTop())

	If DbSeek(xFilial("SA1") + cCliente + cLojaCli)
		
		//Inicializa a Funcao Fiscal
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
					Nil				,;		// 14-Grupo Cliente
					Nil				,;		// 15-Recolhe ISS
					Nil				,;		// 16-Codigo do cliente de entrega na nota fiscal de saida
					Nil				,;		// 17-Loja do cliente de entrega na nota fiscal de saida
					Nil				)		// 18-Informacoes do transportador [01]-UF,[02]-TPTRANS
					
			
		//Recupera a TES de Saida para a Operacao Informada
		cTesOper := MaTesInt(2, cTpOper, SA1->A1_COD, SA1->A1_LOJA, "C", cProduto, NIL)
		
		//Adiciona o Produto para Calculo dos Impostos
		nItem := 	MaFisAdd(	cProduto	,;   	// 1-Codigo do Produto ( Obrigatorio )
								cTesOper	,;	   	// 2-Codigo do TES ( Opcional )
								nQtdProd	,;	   	// 3-Quantidade ( Obrigatorio )
								nVlrProd	,;   	// 4-Preco Unitario ( Obrigatorio )
								0			,;  	// 5-Valor do Desconto ( Opcional )
								""			,;	   	// 6-Numero da NF Original ( Devolucao/Benef )
								""			,;		// 7-Serie da NF Original ( Devolucao/Benef )
								0			,;		// 8-RecNo da NF Original no arq SD1/SD2
								0			,;		// 9-Valor do Frete do Item ( Opcional )
								0			,;		// 10-Valor da Despesa do item ( Opcional )
								0			,;		// 11-Valor do Seguro do item ( Opcional )
								0			,;		// 12-Valor do Frete Autonomo ( Opcional )
								nVlrTot		,;		// 13-Valor da Mercadoria ( Obrigatorio )
								0			,;		// 14-Valor da Embalagem ( Opiconal )
								NIL			,;		// 15-RecNo do SB1
								NIL			,;		// 16-RecNo do SF4
								NIL			)
	
		aImpostos	:= MafisRet(NIL, "NF_IMPOSTOS")
		nPosIcm		:= Ascan(aImpostos, {|x| AllTrim(x[01]) == "ICM"})
		nPosIpi		:= Ascan(aImpostos, {|x| AllTrim(x[01]) == "IPI"})
		nPosIcc		:= Ascan(aImpostos, {|x| AllTrim(x[01]) == "ICC"})
		nPosDif		:= Ascan(aImpostos, {|x| AllTrim(x[01]) == "DIF"})
		nPosPis		:= Ascan(aImpostos, {|x| AllTrim(x[01]) == "PS2"})
		nPosCof		:= Ascan(aImpostos, {|x| AllTrim(x[01]) == "CF2"})
		nPosRet		:= Ascan(aImpostos, {|x| AllTrim(x[01]) == "ICR"})
		
		If nPosIcm > 0
			nVlrIcm := aImpostos[nPosIcm][05]
		EndIf
	
		If nPosIpi > 0
			nVlrIpi := aImpostos[nPosIpi][05]
		EndIf
		
		If nPosIcc > 0
			nVlrIcc := aImpostos[nPosIcc][05]
		EndIf
	
		If nPosDif > 0
			nVlrDif := aImpostos[nPosDif][05]
		EndIf
	
		If nPosPis > 0
			nVlrPis := aImpostos[nPosPis][05]
		EndIf
	
		If nPosCof > 0
			nVlrCof := aImpostos[nPosCof][05]
		EndIf
	
		If nPosRet > 0
			nVlrRet := aImpostos[nPosRet][05]
		EndIf
		
		If SA1->A1_CALCSUF = 'S'
			nDescSuf := MafisRet(,"IT_DESCZF")
		Endif
		
		MaFisEnd()
		
				
	EndIf



	DbSelectarea("SZ4")
	SZ4->(DbSetorder(1))
	SZ4->(dbGoTop())
	
	If DbSeek(xFilial("SZ4") + cPedWeb + cItemped)
		SZ4->(Reclock("SZ4",.F.))
		SZ4->Z4_IPI := nVlrIpi
		SZ4->Z4_ST  := nVlrRet
		SZ4->(MSUNLOCK())
	EndIf
	
	DbSelectarea("SZ3")
	SZ3->(DbSetorder(1))
	SZ3->(dbGoTop())
	
	DbSeek(xFilial("SZ3") + cPedWeb)
	
	SZ3->(Reclock("SZ3",.F.))
	SZ3->Z3_STATUS := "7"
	SZ3->(MSUNLOCK())
	
	ConOut('[ Pedido: ' +Alltrim(cPedWeb) +' ] [ Item: '+ Alltrim(cProduto) +']')

	TRB->(DbSkip())

End

ConOut('['+ Dtoc(date()) +']' +' ['+ time() + '] [FIM DA ROTINA DE GERAR IMPOSTOS DE ORCAMENTOS]')

Return()