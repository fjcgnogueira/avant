#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"

User Function IMPAVANT()
Return Nil
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออออัอออออออออออออออหอออออออัออออออออออออออออออออออหออออออัออออออออออปฑฑ
ฑฑบWeb Service ณ IMPAVANT      บ Autor ณ Amedeo D. P. Filho   บ Data ณ18/04/2012บฑฑ
ฑฑฬออออออออออออุอออออออออออออออสอออออออฯออออออออออออออออออออออสออออออฯออออออออออนฑฑ
ฑฑบDescricao   ณ Analise de Resultados e Calculo de Impostos.                   บฑฑ
ฑฑฬออออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso         ณ Especifico AVANT.                                              บฑฑ
ฑฑฬออออออออออออฯอออออัออออออออออัอออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAnalista Resp.    ณ   Data   ณ Manutencao Efetuada                           บฑฑ
ฑฑฬออออออออออออออออออุออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบFernando Nogueira ณ16/05/2016ณ Implementacao dos Impostos IPI, ICC e DIF; e  บฑฑ
ฑฑบ                  ณ          ณ do Desconto Suframa                           บฑฑ
ฑฑศออออออออออออออออออฯออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
WSSERVICE IMPAVANT DESCRIPTION "Anแlise de Resultados e Cแlculo de Impostos (Especifico AVANT)"
	WSDATA EmpCons		As String
	WSDATA FilCons		As String
	WSDATA Cliente		As String
	WSDATA Loja			As String
	WSDATA Operacao		As String
	WSDATA Produto		As String
	WSDATA Quantidade	As Float
	WSDATA Valor		As Float
	WSDATA aRetorno		As AVANIMPRET

	WSMETHOD Consulta DESCRIPTION "Anแlise de Resultados e Cแlculo de Impostos (Especifico AVANT)"
ENDWSSERVICE
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบ WSMETHOD ณ Consulta บ Autor ณ Amedeo D. P. Filho บ Data ณ  18/04/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Analise de Resultados e Cแlculo de Impostos.               บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico AVANT                                           บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
WSMETHOD Consulta WSRECEIVE EmpCons, FilCons, Cliente, Loja, Operacao, Produto, Quantidade, Valor WSSEND aRetorno WSSERVICE IMPAVANT
	Local aTabelas	:= {"SA1", "SC5", "SC6", "SC9", "SD2", "SF2", "SF4", "SF5", "SFM", "SB1", "SB2", "SB9"}
	Local lRetorno 	:= .T.
	Local cPicture	:= "@E 999,999,999,999.99"

	Local cEmpCons	:= EmpCons
	Local cFilCons	:= FilCons
	Local cCliente	:= Cliente
	Local cLojaCli	:= Loja
	Local cTpOper	:= Operacao
	Local cProduto	:= PadR(Produto,TamSx3("B1_COD")[1])
	Local cLocal	:= "01"
	Local nQtdProd	:= Quantidade
	Local nVlrProd	:= Valor
	Local cTesOper	:= ""
	Local nVlrTot	:= nQtdProd * nVlrProd
	Local nItem		:= 0
	Local aImpostos	:= {}
	Local nVlrIcm	:= 0
	Local nVlrIpi	:= 0
	Local nVlrIcc	:= 0
	Local nVlrDif	:= 0
	Local nVlrPis	:= 0
	Local nVlrCof	:= 0
	Local nVlrRet	:= 0
	Local nDescSuf	:= 0
	
	RpcClearEnv()
	RPCSetType(3)
	RpcSetEnv(cEmpCons, cFilCons, NIL, NIL, "FAT", NIL, aTabelas)

	DbSelectArea("SA1")
	DbSetOrder(1)
	
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

		::aRetorno:ICMS		:= nVlrIcm
		::aRetorno:IPI		:= nVlrIpi
		::aRetorno:ICC		:= nVlrIcc
		::aRetorno:DIF		:= nVlrDif
		::aRetorno:PIS		:= nVlrPis
		::aRetorno:COFINS	:= nVlrCof
		::aRetorno:ICMSRET	:= nVlrRet
		::aRetorno:DESCSUF	:= nDescSuf

		MaFisEnd()
	EndIf

Return lRetorno

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณEstrutura dos dados utilizados pelo WebService.ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
WSSTRUCT AVANIMPRET
	WSDATA ICMS			As Float
	WSDATA IPI			As Float
	WSDATA ICC			As Float
	WSDATA DIF			As Float
	WSDATA PIS			As Float
	WSDATA COFINS		As Float
	WSDATA ICMSRET		As Float
	WSDATA DESCSUF		As Float
ENDWSSTRUCT