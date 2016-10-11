#Include "PROTHEUS.CH"
//--------------------------------------------------------------
/*/{Protheus.doc} AV_EDICOB
Description

@param xParam Parameter Description
@return xRet Return Description
@author  -
@since 22-12-2011
/*/
//--------------------------------------------------------------
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ AV_EDICOB º Autor ³ Cristian Werneck   º Data ³ 24/12/2011 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao para trazer um MarkBrowse                           º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Avant                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function AV_EDICOB()

Local aButtons := {}
Local oFont1 := TFont():New("MS Serif",,016,,.F.,,,,,.F.,.F.)
Local oFont2 := TFont():New("MS Sans Serif",,022,,.F.,,,,,.F.,.F.)
Local oGroup1
Local _nOpc  := 0
Local cTitul := ''

// variaveis para a geração das notas fiscais de entrada
Local aCabec:= {} // Array que conterá os dados para o cabeçalho do documento de entrada
Local aItens:= {} // Array que conterá os itens da nota fiscal de entrada
Local cCodFis  := "" //CODIGO FISCAL DA NATUREZA DE OPERACAO
Local lFalha   := .f.
Local aAreaSF1 := SF1->(GetArea())
Local aAreaSD1 := SD1->(GetArea())
Local nRegZZ4  := 0

Local cErro    := ''

Static oDlgEDI

Private oMSNewGe2
Private oMSNewGe1
Private oMark
Private oFolder1
Private cMarca	:= GetMark()

Private __nMarked := 0
Private __nValue  := 0

Private cAliasZZ5  // Alias para o arquivo temporario da tabela ZZ5
Private cAliasZZ5T // Alias para o arquivo temporario da tabela ZZ5

Private lMsErroAuto := .F.
Private lMsHelpAuto := .T.

//posicionando os indices
SF1->(dbSetOrder(1)) // filila + DOC + SERIE + FORNECEDOR + LOJA + TIPO

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Definicao dos parametros inicias - utilizados no msexecauto(mata103)            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cCondPag  := GETNEWPAR("AV_CONDPAG", '001') // definicao da condicao de pagamento
cCodNatu  := Padr( GETNEWPAR("AV_CODNATU", '101'), TamSx3("E2_NATUREZ")[1] ) // definicao do codigo da natureza. Será utilizado no campo F1_NATUREZ
cCodTES   := GETNEWPAR("AV_CODTES" , '040') // definicao da TES - Tipo de Entrada e Saida. Serah utilizado no campo D1_TES
cTESCtr   := GETNEWPAR("AV_CTESCTR", '042') // definicao da TES - utilizado para gerar o conhecimento de transporte -  MATA116
cTESCtrIC := GETNEWPAR("AV_CTESCTI", '042') // definicao da TES - utilizado para gerar o conhecimento de transporte -  MATA116 que tenha credito de ICMS
cCodPrd   := Padr( GETNEWPAR("AV_CODPROD", '000001'), TamSx3("B1_COD")[1] ) // definicao do codigo do produto. Será utilizado no campo D1_COD

DEFINE MSDIALOG oDlgEDI TITLE "EDI TRANSPORTE" FROM 000, 000  TO 570, 1100 COLORS 0, 16777215 PIXEL

//Aadd(aButtons, {"", {||}, "Teste"})
If ZZ4->ZZ4_STATUS <> "G"
	EnchoiceBar(oDlgEDI, {||_nOpc  := 1, oDlgEDI:End()}, {||oDlgEDI:End()},,aButtons)
Else
	EnchoiceBar(oDlgEDI,  {||ApMsgInfo('Cobrança já gerada anteriormente.'), oDlgEDI:End()}, {||oDlgEDI:End()},,aButtons)
EndIf

@ 019, 003 GROUP oGroup1 TO 110, 545 PROMPT "U N B - CABEÇALHO DE INTERCÂMBIO" OF oDlgEDI COLOR 0, 16777215 PIXEL

nRegZZ4 := ZZ4->(Recno())
RegToMemory("ZZ4", .F., .F.)

fEnchoic1()

@ 114, 003 FOLDER oFolder1 SIZE 542, 156 OF oDlgEDI ITEMS "D C O - Documento de Cobrança" COLORS 0, 16777215 MESSAGE "D C O - Documento de Cobrança" PIXEL

fMSNewMark()

@ 030, 460 SAY oSay1 PROMPT "Qtde marcado" SIZE 065, 016 OF oDlgEDI FONT oFont2 COLORS 8388608, 16777215 PIXEL
@ 045, 460 MSGET __oMarked VAR __nMarked SIZE 064, 016 OF oDlgEDI PICTURE "@e 999,999" COLORS 8388608, 16777215 FONT oFont2 WHEN .F. PIXEL
@ 065, 460 SAY oSay2 PROMPT "Total marcado" SIZE 061, 017 OF oDlgEDI FONT oFont2 COLORS 8388608, 16777215 PIXEL
@ 080, 460 MSGET __oValue VAR __nValue SIZE 060, 016 OF oDlgEDI PICTURE "@e 999,999,999.99" COLORS 8388608, 16777215 FONT oFont2 WHEN .F. PIXEL

ACTIVATE MSDIALOG oDlgEDI CENTERED

If _nOpc <> 0 .And. __nValue <> 0 .And. ApMsgYesNo('Confirma geração dos titulos a pagar no valor total de R$ :'+Transform(__nValue,"@e 999,999,999.99" ))
	
	// guardar o nr do conhecimento na tabela ZZ5
	cSerCon := PadR(M->ZZ4_SERDOC,Tamsx3("E2_TIPO")[1]) //SERIE DO CONHECIMENTO
	cDocCon := PadR(M->ZZ4_NUMDOC,TamSx3("F1_DOC")[1] ) //NUMERO DO CONHECIMENTO
	
	// Realizar as devidas verificacoes se os parametros informados acima existem antes de continuar a importacao dos dados
	//AV_CONDPAG
	cMsg := ''
	aAreaSE4 := SE4->(GetArea())
	If Empty(Alltrim(Posicione('SE4', 1, xFilial('SE4')+cCondPag, 'E4_CODIGO')))
		lFalha   := .t.
		cMsg += 'Condição de pagamento = ' + cCondPag + '  não encontrada. ' + Chr(13)
	EndIf
	
	//AV_CODNATU
	aAreaSED := SED->(GetArea())
	If Empty(Alltrim(Posicione('SED',1, xFilial('SED')+cCodNatu, 'ED_CODIGO')))
		lFalha   := .t.
		cMsg += 'Natureza  = ' + cCodNatu + '  não encontrada. ' + Chr(13)
	EndIf
	
	//AV_CODTES
	aAreaSF4 := SF4->(GetArea())
	IF Empty(Alltrim(Posicione('SF4',1,xFilial('SF4')+cCodTES, 'F4_CODIGO')))
		lFalha   := .t.
		cMsg += 'Tipo de entrada e Saida  = ' + cCodTES + '  não encontrada. ' + Chr(13)
	Else // aproveitar que a tabela está posicionada e guardar algumas informações necessárias
		cCodFis := SF4->F4_CF //CÓDIGO FISCAL DA NATUREZA DE OPERAÇÃO
	EndIf
	
	//AV_CODPROD
	aAreaSB1 := SB1->(GetArea())
	If Empty(Alltrim(Posicione('SB1',1, xFilial('SB1')+cCodPrd, 'B1_COD')))
		lFalha   := .t.
		cMsg += 'Produto   = ' + cCodPrd + '  não encontrada. ' + Chr(13)
	EndIf
	
	If lFalha // algum dos parametros informados falhou, portanto abortar a importacao
		ApMsgStop(cMsg, 'EDI TRANSPORTE')
		Return(nil)
	EndIf
	
	// Gerando a nota fiscal de entrada para a nota fiscal do FRETE para gerar a cobrança da transportadora
	If !SF1->(dbSeek(ZZ4_FILIAL +cDocCon + cSerCon + M->ZZ4_CODFOR + M->ZZ4_LOJFOR + 'N')) //!NANFIsExist(aConhecim[nX,5],@nTotal)
		aCab := { 	{"F1_DOC"    , cDocCon			, Nil} ,; // Nota Fiscal
		{"F1_SERIE"  , cSerCon			, Nil} ,; // Serie
		{"F1_FORNECE", M->ZZ4_CODFOR	, Nil} ,; // Fornecedor
		{"F1_LOJA"   , M->ZZ4_LOJFOR	, Nil} ,; // Loja
		{"F1_EMISSAO", M->ZZ4_EMISSA	, Nil} ,; // Emissao
		{"F1_TIPO"   , "N"				, Nil} ,; // Tipo
		{"F1_ESPECIE", "CTR"			, Nil} ,; // Especie
		{"F1_FORMUL" , ""				, Nil} ,; // Formulario
		{"F1_COND"   , cCondPag			, Nil} }  // Condicao de Pagamento
		
		aItens	:= {}
		_cItem	:= "01"
		_cArm	:= SB1->B1_LOCPAD
		_cUM	:= SB1->B1_UM
		
		aLinha := {}
		aAdd(aLinha,{"D1_DOC"     , cDocCon			, Nil}) // Nota Fiscal
		aAdd(aLinha,{"D1_SERIE"   , cSerCon			, Nil}) // Serie
		aAdd(aLinha,{"D1_FORNECE" , M->ZZ4_CODFOR	, Nil}) // Fornecedor
		aAdd(aLinha,{"D1_LOJA"    , M->ZZ4_LOJFOR	, Nil}) // Loja
		aAdd(aLinha,{"D1_EMISSAO" , M->ZZ4_EMISSA 	, Nil}) // Emissao
		aAdd(aLinha,{"D1_FORMUL"  , ""			   	, Nil}) // Formulario
		aAdd(aLinha,{"D1_ITEM"    , _cItem			, Nil}) // Item
		aAdd(aLinha,{"D1_COD"     , cCodPrd												, Nil}) // Produto
		aAdd(aLinha,{"D1_UM"      , _cUM									 			, Nil}) // Unidade
		aAdd(aLinha,{"D1_TES"     , cCodTES									 			, Nil}) // Tipo de Entrada
		aAdd(aLinha,{"D1_LOCAL"   , _cArm												, Nil}) // Armazem
		aAdd(aLinha,{"D1_TIPO"    , "N"													, Nil}) // Tipo
		aAdd(aLinha,{"D1_QUANT"   , 1													, Nil}) // Quantidade
		aAdd(aLinha,{"D1_VUNIT"   , __nValue	, Nil}) // Valor Unitario
		aAdd(aLinha,{"D1_TOTAL"   , __nValue	, Nil}) // Total
		//					aAdd(aLinha,{"D1_NFORI"	  , Padr(aNotas[nY,2],Tamsx3("F2_DOC")[1])				, Nil}) // Nota Fiscal Origem
		//					aAdd(aLinha,{"D1_SERIORI" , Padr(aNotas[nY,1],Tamsx3("F2_SERIE")[1])			, Nil}) // Serie Origem
		
		aAdd( aItens, aLinha )
		
		If Len(aCab) > 0 .And. Len(aItens) > 0
			lMsErroAuto := .F.
			MsAguarde( { || MsExecAuto( { |x,y,z,a| Mata103(x,y,z,a) }, aCab, aItens, 3 )},"Aguarde...","Gerando Nota de Conhecimento de Frete")
		EndIf
		
		If lMsErroAuto
			cErro += "NF Conh. Frete: "+cDocCon+" e serie "+cSerCon+" nao foi gerada."+CRLF
			ApMsgStop(cErro, 'NF Conh. Frete')
			MostraErro()
			lFalha   := .T.
		EndIf
	Else
		// Fernando Nogueira - Chamado 004215 - Para Integrar CTRs faltantes em caso de cair a conexao
		lMsErroAuto := !MsgNoYes("Nota "+cDocCon+"/"+cSerCon+" já existe, continua assim mesmo?")		
	EndIf
	
	// Nao deu erro na criacao do MATA103 entao vamos gerar o mata116
	If !lMsErroAuto

		nRecSF1 := SF1->(Recno())
		(cAliasZZ5)->(dbGoTop())

		While (cAliasZZ5)->(!Eof())

			ZZ5->(dbGoTo((cAliasZZ5)->RECZZ5))

			If (cAliasZZ5)->ZZ5_OK == cMarca
				// RecLock('ZZ5', .F.)
				// criar um campo de flag para marcar os registros processados
				// ZZ5->ZZ5_NUMDOC := cDocCon
				// ZZ5->ZZ5_SERDOC := cSerCon
				// ZZ5->(MsUnlock())
				
				SF1->(dbGoTo(nRecSF1))
				
				aItens := {}
				aCabec := {}
				
				aAdd( aCabec, { "" 				, dDataBase-365		} )	// 01 - Data Inicial para Filtro das NF Originais
				aAdd( aCabec, { "" 				, dDataBase			} )	// 02 - Data Final para Filtro das NF originais
				aAdd( aCabec, { "" 				, 2					} )	// 03 - Define a Rotina : 2-Inclusao / 1-Exclusao
				aAdd( aCabec, { "" 				, ""				} )	// 04 - Cod. Fornecedor para Filtro das NF Originais
				aAdd( aCabec, { "" 				, ""				} )	// 05 - Loja Fornecedor para Fltro das NF Originais
				aAdd( aCabec, { "" 				, 1					} )	// 06 - Considerar Notas : 1 - Compra , 2 - Devolucao
				aAdd( aCabec, { "" 				, 2					} )	// 07 - Aglutina Produtos :
				aAdd( aCabec, { "F1_EST"		, ""				} )	// 08 - Estado de Origem do Frete
				aAdd( aCabec, { "" 				, ZZ5->ZZ5_VLRFRE	} )	// 09 - Valor total do Frete sem Impostos
				aAdd( aCabec, { "F1_FORMUL" 	, 1				    } )	// 10 - Utiliza Formulario proprio ? 2-Sim,1-Nao // Fernando Nogueira - Chamado 004199
				aAdd( aCabec, { "F1_DOC" 		, PadR(ZZ5->ZZ5_NUMCON,Tamsx3("F1_DOC")[1])	} )	// 11 - Num. da NF de Conhecimento de Frete
				aAdd( aCabec, { "F1_SERIE" 		, PadR(ZZ5->ZZ5_SERCON,Tamsx3("F1_SERIE")[1])	} )	// 12 - Serie da NF de COnhecimento de Frete
				aAdd( aCabec, { "F1_FORNECE" 	, ZZ5->ZZ5_CODFOR	} )	// 13 - Codigo do Fornecedor da NF de FRETE
				aAdd( aCabec, { "F1_LOJA" 		, ZZ5->ZZ5_LOJFOR	} )	// 14 - Loja do Fornecedor da NF de Frete

				If ZZ5->ZZ5_ICMS == 0
					aAdd( aCabec, { "" 				, cTESCtr			} )	// 15 - Tes utilizada na Classificacao da NF
					aAdd( aCabec, { "NF_BASEICM" 	, 0					} )	// 16 - Base do Icms Retido
					aAdd( aCabec, { "NF_VALICM" 	, 0					} )	// 17 - Valor do Icms Retido
				Else
					aAdd( aCabec, { "" 				, cTESCtrIC			} )	// 15 - Tes utilizada na Classificacao da NF
					// aAdd( aCabec, { "IT_ALIQICM" 	, ZZ5->ZZ5_ICMS		} )	// 17 - Valor do Icms Retido
					aAdd( aCabec, { "NF_BASEICM" 	, ZZ5->ZZ5_BASICM	} )	// 16 - Base do Icms Retido
					aAdd( aCabec, { "NF_VALICM" 	, ZZ5->ZZ5_VALICM	} )	// 17 - Valor do Icms Retido
				EndIf
				aadd( aCabec, { "F1_COND"		,cCondPag			} ) // 18 - Condicao de Pagamento
				aadd( aCabec, { "F1_EMISSAO"	,ZZ5->ZZ5_DTCONH	} ) // 19 - data da conhecimento
				//				aadd( aCabec, { "F1_BASERET"    ,0})
				//				aadd( aCabec, { "F1_ICMRET"     ,0})
				
				aAdd(aItens,{{"PRIMARYKEY",SF1->F1_DOC+SF1->F1_SERIE}})
				
				lMsErroAuto := .F.
				//				nRecSF1 := SF1->(Recno())
				//				nRecSA2 := SA2->(Recno())
				MsAguarde( { || MATA116(aCabec,aItens)},"Aguarde...","Gerando Nota de Conhecimento de Frete")
				//				SA2->(dbGoto(nRecSA2))
				//				SF1->(dbGoto(nRecSF1))
				If lMsErroAuto
					cErro+= "NF de Conhecimento de Frete "+PadR(ZZ5->ZZ5_NUMCON,Tamsx3("F1_DOC")[1])+" e Serie "+PadR(ZZ5->ZZ5_SERCON,Tamsx3("F1_SERIE")[1])+" não pode ser gerada."+CRLF
					ApMsgStop(cErro, 'NF Conh. Frete')
					MostraErro()
					lFalha   := .t.
				EndIf
				
				// o padrao do sistema esta gravando incorretamente a aliquota de ICMS, entao vou forcar a gravacao correta destes valores
				// regravar as tabelas: SD1, SF3, SFT
				
				//UPDATE ... SD1
				cUpd := "UPDATE "+RetSqlName("SD1")
				cUpd += " SET D1_PICM = '" + Str(ZZ5->ZZ5_ICMS) + "', D1_ICMSRET = 0, D1_BRICMS = 0"
				cUpd += " WHERE D1_FILIAL = '" + ZZ5->ZZ5_FILIAL + "'"
				cUpd += " AND D1_DOC = '" + PadR(ZZ5->ZZ5_NUMCON,Tamsx3("F1_DOC")[1]) + "'"
				cUpd += " AND D1_SERIE = '" + PadR(ZZ5->ZZ5_SERCON,Tamsx3("F1_SERIE")[1]) + "'"
				cUpd += " AND D1_FORNECE = '" + ZZ5->ZZ5_CODFOR + "'"
				cUpd += " AND D1_LOJA = '" + ZZ5->ZZ5_LOJFOR + "'"
				cUpd += " AND D_E_L_E_T_ <> '*'"
				_nResult := TcSqlExec(cUpd)
				
				//UPDATE ... SF3
				cUpd := "UPDATE "+RetSqlName("SF3")
				cUpd += " SET F3_ALIQICM = '" + Alltrim(Str(ZZ5->ZZ5_ICMS)) + "', F3_ICMSRET = 0, F3_BASERET = 0"
				cUpd += " WHERE F3_FILIAL = '" + ZZ5->ZZ5_FILIAL + "'"
				cUpd += " AND F3_NFISCAL = '" + PadR(ZZ5->ZZ5_NUMCON,Tamsx3("F1_DOC")[1]) + "'"
				cUpd += " AND F3_SERIE = '" + PadR(ZZ5->ZZ5_SERCON,Tamsx3("F1_SERIE")[1]) + "'"
				cUpd += " AND F3_CLIEFOR = '" + ZZ5->ZZ5_CODFOR + "'"
				cUpd += " AND F3_LOJA = '" + ZZ5->ZZ5_LOJFOR + "'"
				cUpd += " AND D_E_L_E_T_ <> '*'"
				_nResult := TcSqlExec(cUpd)
				
				//UPDATE ... SFT
				cUpd := "UPDATE "+RetSqlName("SFT")
				cUpd += " SET FT_ALIQICM = '" + Alltrim(Str(ZZ5->ZZ5_ICMS)) + "', FT_ICMSRET = 0, FT_BASERET = 0"
				cUpd += " WHERE FT_FILIAL = '" + ZZ5->ZZ5_FILIAL + "'"
				cUpd += " AND FT_NFISCAL = '" + PadR(ZZ5->ZZ5_NUMCON,Tamsx3("F1_DOC")[1]) + "'"
				cUpd += " AND FT_SERIE = '" + PadR(ZZ5->ZZ5_SERCON,Tamsx3("F1_SERIE")[1]) + "'"
				cUpd += " AND FT_CLIEFOR = '" + ZZ5->ZZ5_CODFOR + "'"
				cUpd += " AND FT_LOJA = '" + ZZ5->ZZ5_LOJFOR + "'"
				cUpd += " AND D_E_L_E_T_ <> '*'"
				_nResult := TcSqlExec(cUpd)
				
				//UPDATE ... CD2
				cUpd := "UPDATE "+RetSqlName("CD2")
				cUpd += " SET CD2_ALIQ = '" + Alltrim(Str(ZZ5->ZZ5_ICMS)) + "'"
				cUpd += " WHERE CD2_FILIAL = '" + ZZ5->ZZ5_FILIAL + "'"
				cUpd += " AND CD2_DOC    = '" + PadR(ZZ5->ZZ5_NUMCON,Tamsx3("F1_DOC")[1]) + "'"
				cUpd += " AND CD2_SERIE  = '" + PadR(ZZ5->ZZ5_SERCON,Tamsx3("F1_SERIE")[1]) + "'"
				cUpd += " AND CD2_CODFOR = '" + ZZ5->ZZ5_CODFOR + "'"
				cUpd += " AND CD2_LOJFOR = '" + ZZ5->ZZ5_LOJFOR + "'"
				cUpd += " AND CD2_IMP = 'ICM'"
				cUpd += " AND D_E_L_E_T_ <> '*'"
				_nResult := TcSqlExec(cUpd)
				
				//UPDATE ... CD2 ... eliminar o ICMS SOLIDARIO
				cUpd := "UPDATE "+RetSqlName("CD2")
				cUpd += " SET D_E_L_E_T_ = '*', R_E_C_D_E_L_ = R_E_C_N_O_"
				cUpd += " WHERE CD2_FILIAL = '" + ZZ5->ZZ5_FILIAL + "'"
				cUpd += " AND CD2_DOC    = '" + PadR(ZZ5->ZZ5_NUMCON,Tamsx3("F1_DOC")[1]) + "'"
				cUpd += " AND CD2_SERIE  = '" + PadR(ZZ5->ZZ5_SERCON,Tamsx3("F1_SERIE")[1]) + "'"
				cUpd += " AND CD2_CODFOR = '" + ZZ5->ZZ5_CODFOR + "'"
				cUpd += " AND CD2_LOJFOR = '" + ZZ5->ZZ5_LOJFOR + "'"
				cUpd += " AND CD2_IMP = 'SOL'"
				cUpd += " AND D_E_L_E_T_ <> '*'"
				_nResult := TcSqlExec(cUpd)
				
			Else
				//			RecLock('ZZ5', .f.)
				//				ZZ5->ZZ5_NUMDOC := ""
				//				ZZ5->ZZ5_SERDOC := ""
				//				ZZ5->(MsUnlock())
			EndIf
			
			(cAliasZZ5)->(dbSkip())
		EndDo
		
		ZZ4->(dbGoTo(nRegZZ4))

		If ZZ4->ZZ4_STATUS <> "G"
			RecLock("ZZ4", .F.)
			ZZ4->ZZ4_STATUS := 'G'
			ZZ4->(MsUnlock())
		EndIf
		
	EndIf
	
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ fEnchoic1 º Autor ³ Microsiga          º Data ³ 25/12/2011 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Avant                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fEnchoic1()

Local aFields := {}
Local aAlterFields := {}
Static oEnchoic1

oEnchoic1 := MsMGet():New("ZZ4",0,1,,,,aFields,{28,8,104,450},aAlterFields,,,,,oDlgEDI,,.T.)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ fMSNewMarkº Autor ³ Microsiga          º Data ³ 25/12/2011 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Avant                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fMSNewMark()

Local aPosGroup2:= {010, 010, 010, 010} //{010, 002, 130, 537}
LOCAL aCampos 	:= {}

Local cQuery
Local aStru	:= ZZ5->(DbStruct())
Local nCt := 0

PRIVATE lInverte := .F.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Gravar a marca para já vir marcado no MarkBrowse             ³
//³                               								 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
// Chamado 004215 - Ajuste do Update para marcar somente o que nao gerou CTR
cUpd := "UPDATE "+RetSqlName("ZZ5")
cUpd += " SET ZZ5_OK = '" + cMarca + "'"
cUpd += " FROM "+RetSqlName("ZZ5")+" ZZ5"
cUpd += " LEFT JOIN "+RetSqlName("SF1")+" SF1 ON ZZ5_FILIAL = F1_FILIAL AND ZZ5_NUMCON = F1_DOC AND ZZ5_SERCON = F1_SERIE AND ZZ5_CODFOR = F1_FORNECE AND ZZ5_LOJFOR = F1_LOJA AND SF1.D_E_L_E_T_ = ' '"
cUpd += " WHERE "
cUpd += " ZZ5_FILIAL='"	+ M->ZZ4_FILIAL + "'"
cUpd += " AND ZZ5_SERDOC = '" + LEFT(M->ZZ4_SERDOC,TamSx3("F1_SERIE")[1] )+ "'"
cUpd += " AND ZZ5_NUMDOC = '" + LEFT(M->ZZ4_NUMDOC,TamSx3("F1_DOC")[1] ) + "'"
cUpd += " AND ZZ5.D_E_L_E_T_ <> '*'"
cUpd += " AND SF1.R_E_C_N_O_ IS NULL"
_nResult := TcSqlExec(cUpd)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Saber a quantidade e valor acumulado os registros marcados   ³
//³                               								 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cAliasZZ5T := "QRYZZ5"
cQuery := ""
cQuery := "SELECT COUNT(*) as nMarked, SUM(ZZ5_VLRFRE) as nValues"
cQuery += " FROM "+RetSqlName("ZZ5")+ " ZZ5 "
cQuery += " WHERE "
cQuery += " ZZ5_FILIAL='"	+ M->ZZ4_FILIAL + "'"
cQuery += " AND ZZ5_OK = '" + cMarca + "'"
cQuery += " AND D_E_L_E_T_ <> '*'"

If Select(cAliasZZ5T) > 0           // Verificar se o Alias ja esta aberto.
	DbSelectArea(cAliasZZ5T)        // Se estiver, devera ser fechado.
	DbCloseArea(cAliasZZ5T)
EndIf

DbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), cAliasZZ5T, .T., .F. )
DbSelectArea(cAliasZZ5T)
(cAliasZZ5T)->(DbGoTop())

__nMarked := (cAliasZZ5T)->nMarked
__nValue  := (cAliasZZ5T)->nValues

DbCloseArea(cAliasZZ5T)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Filtro dos movimentos de D C O - DOCUMENTO DE COBRANÇA       ³
//³                               								 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cAliasZZ5 := "QRYZZ5"
cQuery := ""

If Select(cAliasZZ5) > 0
	(cAliasZZ5)->(dbCloseArea())
EndIf

FOR nCt= 1 To Len(aStru)
	If aStru[nCt,2] <> "M"
		cQuery+= ","+Alltrim(aStru[nCt,1])
	Endif
Next nCt
cQuery := "SELECT "+SubStr(cQuery,2)
cQuery +=         ","+"ZZ5.R_E_C_N_O_ as RECZZ5 "
cQuery += "FROM "+RetSqlName("ZZ5")+ " ZZ5 "
cQuery += "WHERE "
cQuery += "ZZ5_FILIAL='"	+ M->ZZ4_FILIAL + "'"
cQuery += " AND ZZ5_SERDOC = '" + LEFT(M->ZZ4_SERDOC,TamSx3("F1_SERIE")[1] )+ "'"
cQuery += " AND ZZ5_NUMDOC = '" + LEFT(M->ZZ4_NUMDOC,TamSx3("F1_DOC")[1] )+ "'"
cQuery += " AND D_E_L_E_T_ <> '*'"
cQuery += " ORDER BY " + SqlOrder(ZZ5->(IndexKey(1)))

//Add no Array aStru o campo onde contem o nr do recno da tabela ZZ5
AADD( aStru, {'RECZZ5', 'N',10,0} )

MemoWrite('AV_EDICOB.sql', cQuery)

//Aadd(aStru, {"RECNO","N",10,0})
cArqTrab := CriaTrab(aStru,.T.) // Nome do arquivo temporario
dbUseArea(.T.,__LocalDriver,cArqTrab,cAliasZZ5,.F.)
Processa({||SqlToTrb(cQuery, aStru, cAliasZZ5)}) // Cria arquivo temporario
IndRegua (cAliasZZ5,cArqTrab,SqlOrder(ZZ5->(IndexKey(1))),,,"Selecionando Registros...")
DbSetOrder(0) // Fica na ordem da query

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta array com capos a serem mostrados na marcacao de titulos ³
//³ Utiliza os capos em uso do SE1 mais o E1_SALDO que apesar de   ³
//³ nao estar em uso deve ser mostrado na tela.                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
AADD(aCampos,{"ZZ5_OK","","  ",""})
dbSelectArea("SX3")
SX3->(dbSetOrder(1))
SX3->(MsSeek('ZZ5'))
While SX3->(!EOF()) .And. (SX3->X3_ARQUIVO == 'ZZ5')
	IF (X3USO(SX3->X3_USADO) .or. SX3->X3_CAMPO == "ZZ5_FILIAL  ") .AND. cNivel >= SX3->X3_NIVEL .AND. SX3->X3_CONTEXT != "V"
		AADD(aCampos,{SX3->X3_CAMPO,"",X3Titulo(),SX3->X3_PICTURE})
	Endif
	SX3->(dbSkip())
Enddo

oMark :=MsSelect():New(cAliasZZ5,"ZZ5_OK","!ZZ5_IDINTE",aCampos,@lInverte,@cMarca,{aPosGroup2[1]+10,aPosGroup2[2]+5,aPosGroup2[3]-5,aPosGroup2[4]-5},,,oFolder1:aDialogs[1])
oMark:bMark :=  {||FaEDIExibe(cAliasZZ5,cMarca,__oValue,__oMarked)}
//oMark:bAval	:= {||Fa280bAval(cAliasZZ5,cMarca,oValor,oQtdTit,oMark,@nValor,,,aChaveLbn), Fi070Cond(aPosGroup3)}

oMark:oBrowse:lhasMark := .T.
oMark:oBrowse:lCanAllmark := .T.
//oMark:oBrowse:bAllMark := { || FA280Inverte(cAliasZZ5,cMarca,oValor,oQtdTit,.T.,oMark,@nValor,,,,aChaveLbn)}
oMark:oBrowse:bAllMark :=  {|| FaEDIMkAll(cAliasZZ5,cMarca,.T.,__oValue,__oMarked,.t.) }
oMark:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT

CursorArrow()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ FaEDIExibeº Autor ³ Microsiga          º Data ³ 25/12/2011 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Avant                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function FaEDIExibe(cAliasZZ5,cMarca,oValor,oQtdTit)

If (cAliasZZ5)->ZZ5_OK == cMarca
	__nMarked++
	__nValue += (cAliasZZ5)->ZZ5_VLRFRE
Else
	__nMarked--
	__nValue -= (cAliasZZ5)->ZZ5_VLRFRE
EndIf

__nMarked := Iif(__nMarked<0,0,__nMarked)
__nValue  := Iif(__nValue<0,0,__nValue)

oValor:Refresh()
oQtdTit:Refresh()

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ FaEDIMkAllº Autor ³ Microsiga          º Data ³ 25/12/2011 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Avant                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
STATIC Function FaEDIMkAll(cAlias, cMarca, lInverte, oValor, oQtdTit, lTodos)

LOCAL lSavTTS
LOCAL nRec
LOCAL cAliasAnt := Alias()

DEFAULT lInverte := .F.
DEFAULT lTodos := .T.

lSavTTS := __TTSInUse
__TTSInUse := .F.

__nMarked := 0
__nValue  := 0

dbSelectArea(cAlias)
nRec := Recno()

If lTodos
	(cAlias)->(dbGoTop())
Endif

While (cAlias)->(!Eof())
	
	RecLock(cAlias)
	If lInverte
		If (cAlias)->ZZ5_OK == cMarca
			(cAlias)->ZZ5_OK := Space(Len(cMarca))
		Else
			(cAlias)->ZZ5_OK := cMarca
			__nMarked++
			__nValue += (cAlias)->ZZ5_VLRFRE
		EndIf
	Else
		(cAlias)->ZZ5_OK := cMarca
		__nMarked++
		__nValue += (cAlias)->ZZ5_VLRFRE
	EndIf
	MsUnLock()
	
	If !lTodos
		Exit
	Endif
	(cAlias)->(dbSkip())
EndDo

dbGoto(nRec)

oValor:Refresh()
oQtdTit:Refresh()

__TTSInUse := lSavTTS
dbSelectArea(cAliasAnt)

Return
