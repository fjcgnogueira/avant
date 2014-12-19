#INCLUDE "PROTHEUS.CH"
#INCLUDE "MATR282.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³MATR282	³ Autor ³ Microsiga S/A         ³ Data ³ 06/08/09 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Relatorio de conferencia de saldos em estoque para produtos³±±
±±³          ³ que controlam saldo por rastreabilidade/localizacao.       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function MATR282()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local cDesc1     := STR0001 //"Emite o relatorio de conferencia de saldos "
Local cDesc2     := STR0002 //"para produtos que utilizam o controle de  "
Local cDesc3     := STR0003 //"Lote/SubLote e/ou Localização fisica."
Local titulo	 := STR0004 //"CONFERENCIA DE SALDOS EM ESTOQUE"
Local wnrel      := "MATR282"
Local Tamanho    := "G"
Local cString    := "SB2"
#IFDEF TOP
	Local lExistProc := ExistProc(IIF(FindFunction("GetSPName"), GetSPName("MAT038","17"), "MAT038"),VerIDProc())
#ELSE
	Local lExistproc := .F.
#ENDIF	
Private aReturn  := {STR0005,1,STR0006, 1, 2, 1, "",1 }	//"Zebrado"###"Administracao"
Private aLinha   := { }
Private nLastKey := 0
Private cPerg    :="MTR282"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Ajusta Perguntas                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
AjustaSX1()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//| Checa versao dos fontes relacionados. NAO REMOVER !!!           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !(FindFunction("MATXFUNA_V")	.And. MATXFUNA_V() >= 20090915)
	Final(OemToAnsi(STR0007)) //"Atualizar MATXFUNA.PRX"
EndIf
If !(FindFunction("MATA280_V")	.And. MATA280_V() >= 20090915)
	Final(OemToAnsi(STR0008)) //"Atualizar MATA280.PRX"
EndIf
If lExistProc
	If !(FindFunction("CFGX051_V")	.And. CFGX051_V() >= 20090915)
		Final(OemToAnsi(STR0009)) //"Atualizar CFGX051.PRW"
	EndIf
EndIf	

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01  // Do  Produto ?                                   ³
//³ mv_par02  // Ate Produto ?                                   ³
//³ mv_par03  // Do Armazem ?                                    ³
//³ mv_par04  // Ate Armazem ?                                   ³
//³ mv_par05  // Saldo a Considerar ? 1 = Atual                  ³
//³                                   2 = Movimento              ³
//³                                   3 = Fechamento             ³
//³ mv_par06  // Data de Referencia ?                            ³
//³ mv_par07  // Lista Produtos ? 1 = Com Diferencas             |
//|                               2 = Sem Diferencas             |
//|                               3 = Ambos                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Pergunte("MTR282",.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel :=SetPrint(cString,wnrel,cPerg,titulo,cDesc1,cDesc2,cDesc3,.F.,,.F.,Tamanho)

If nLastKey = 27
	dbClearFilter()
	Return
EndIf

SetDefault(aReturn,cString)

If nLastKey = 27
	dbClearFilter()
	Return
EndIf

Processa({|lEnd| MTR282Imp(@lEnd,wnRel,tamanho,titulo,)},titulo)

Return NIL

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ MTR282Imp³ Autor ³ Microsiga S/A         ³ Data ³ 06/08/09 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Chamada do Relatorio                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ lEnd    - Controle de Execucao da rotina                   ³±±
±±³          ³ WnRel   - Nome arquivo a ser gerado na impressao           ³±±
±±³          ³ Tamanho - Tamanho do relatorio                             ³±±
±±³          ³ Titulo  - Titulo do relatorio                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR282			                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function MTR282Imp(lEnd,WnRel,tamanho,titulo)
Local cStatus    := ''
Local cQuery     := ''
Local cSeek      := ''
Local nQtdSBK    := 0
Local nQtdSBJ    := 0
Local nQtdSDA    := 0
Local nQtdSB2    := 0
Local nX         := 0
Local lRastro    := .F.
Local lLocaliza  := .F.
Local lQuery     := .F.
Local lQrySB2    := .F.
Local lContinua  := .T.
Local aTamSB2    := {}
Local aNewSBK    := {}
Local aNewSBJ    := {}
Local aResult    := {}
Local cAliasSB2  := {}
Local cAliasSB8  := 'SB8'
Local cAliasSBF  := 'SBF'
Local cAliasSDA  := 'SDA'
Local aAreaAnt   := GetArea()
Local cPictSB2   := PesqPict("SB2","B2_QFIM" , 18)
Local cPictSBK   := PesqPict("SBK","BK_QINI" , 18)
Local cPictSBJ   := PesqPict("SBJ","BJ_QINI" , 18)
Local cPictSDA   := PesqPict("SDA","DA_SALDO", 18)
Local nTipo      := IIf(aReturn[4] == 1, 15, 18)
Local aTamSBJ    := TamSX3("BJ_QINI")
Local aTamSBK    := TamSX3("BK_QINI")
#IFDEF TOP
	Local aTamSB8    := TamSX3('B8_SALDO')
	Local aTamSBF    := TamSX3('BF_QUANT')
	Local aTamSDA    := TamSX3('DA_SALDO')
#ENDIF	
Local dUlMes     := GetMV("MV_ULMES")
Local cRastro    := SuperGetMv("MV_RASTRO",.F.,'N')
Local l300SalNeg := SuperGetMV("MV_MT300NG",.F.,.F.) // Indica se permite saldo negativo
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ MV_MUDATRT - Parametro criado para adicionar a string "0_SP" nos nomes    ³
//³ das tabelas temporarias da classe "TR" devido a problemas com o parceiro  ³
//³ NG que utiliza a mesma classe de tabelas.                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local lMudaTRT  := GetMv("MV_MUDATRT",.F.,.F.)
Local cNomeTab  := IIf(lMudaTRT,"0_SP","0")
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica a existencia de Stored Procedures                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
#IFDEF TOP
	Local lExistProc := ExistProc(IIF(FindFunction("GetSPName"), GetSPName("MAT038","17"), "MAT038"),VerIDProc()) .And. TCCanOpen( "TRJ"+SM0->M0_CODIGO+cNomeTab ).And. TCCanOpen( "TRK"+SM0->M0_CODIGO+cNomeTab )
#ELSE
	Local lExistproc := .F.
#ENDIF	

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para Impressao do Cabecalho e Rodape    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PRIVATE cbtxt := Space(10)
PRIVATE cbcont:= 0
PRIVATE li    := 80
PRIVATE m_pag := 01

PRIVATE cabec1  := STR0010 	//"  FILIAL      | PRODUTO                        | AMZ    | CONTROLE | CONTROLE     |         QUANTIDADE |         QUANTIDADE |         QUANTIDADE |         QUANTIDADE | STATUS    "
PRIVATE cabec2  := STR0011 	//"              |                                |        | ENDERECO | LOTE/SUBLOTE |             FISICA |       POR ENDERECO |        A ENDERECAR |   POR LOTE/SUBLOTE |           "
							//  123456789012 | 123456789012345678901234567890 | 123456 | 12345678 | 1234567890   | 123456789012345678 | 123456789012345678 | 123456789012345678 | 123456789012345678 | 1234567890
							//  1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678
							//           1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Adiciona o tipo de saldo a considerar no titulo              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If mv_par05 == 1
	Titulo := Titulo + Space(1) + STR0012 // "( Saldo Atual )"
ElseIf mv_par05 == 2
	Titulo := Titulo + Space(1) + STR0013 + Space(1) + DTOC(mv_par06) + " ) " //"( Saldo por Movimento / Data DD/MM/AAAA )"
ElseIf mv_par05 == 3
	Titulo := Titulo + Space(1) + STR0014 + Space(1) + DTOC(mv_par06) + " ) " //"( Saldo de Fechamento / Data DD/MM/AAAA ) "
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Nao permitir que execute o relatorio na mesma filial         |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !MR282Lock()
	lContinua := .F.
EndIf

If lContinua
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Tratamento para utilizacao de Stored Procedures              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lExistProc
		// Realiza a limpeza na tabela temporaria TRJ
		TcSqlExec( "DELETE FROM "+"TRJ"+cEmpAnt+cNomeTab+" WHERE BJ_FILIAL = '"+xFilial("SBJ")+"' AND D_E_L_E_T_  = ' '")
		// Realiza a limpeza na tabela temporaria TRK
		TcSqlExec( "DELETE FROM "+"TRK"+cEmpAnt+cNomeTab+" WHERE BK_FILIAL = '"+xFilial("SBK")+"' AND D_E_L_E_T_  = ' '")
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Processamento do Relatorio                                   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SB2")
	dbSetOrder(1)
	#IFDEF TOP
		lQrySB2    := .T.
		cAliasSB2 := GetNextAlias()
		cQuery := "SELECT SB2.*,SB2.R_E_C_N_O_ RECNOSB2 "
		cQuery +=   "FROM " + RetSqlName("SB2")	+ " SB2 "
		cQuery +=  "WHERE SB2.B2_FILIAL = '"	+ xFilial('SB2')	+ "' AND "
		cQuery +=       " SB2.B2_COD >= '"		+ mv_par01		 	+ "' AND "
		cQuery +=       " SB2.B2_COD <= '"		+ mv_par02		 	+ "' AND "
		cQuery +=       " SB2.B2_LOCAL >= '"	+ mv_par03			+ "' AND "
		cQuery +=       " SB2.B2_LOCAL <= '"	+ mv_par04			+ "' AND "
		cQuery +=       " SB2.D_E_L_E_T_ = ' ' "	
		cQuery:=ChangeQuery(cQuery)
		dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQuery),cAliasSB2,.F.,.T.)
		aTamSB2 := TamSX3("B2_QATU")
		TcSetField( cAliasSB2, "B2_QATU","N", aTamSB2[1],aTamSB2[2] )
		aTamSB2 := TamSX3("B2_QFIM")
		TcSetField( cAliasSB2, "B2_QFIM","N", aTamSB2[1],aTamSB2[2] )
	#ELSE
		dbSeek(xFilial("SB2")+mv_par01+mv_par03,.T.)
	#ENDIF
	ProcRegua(SB2->(LastRec()))
	Do While !Eof()    
	
		IncProc()
		
		If lEnd
			@PROW()+1,001 PSAY STR0015 //"CANCELADO PELO OPERADOR"
			Exit
		EndIf
	    
		// Processa somente produtos dentro do filtro informado
		If (cAliasSB2)->B2_COD < mv_par01 .Or. (cAliasSB2)->B2_COD > mv_par02
			(cAliasSB2)->(dbSkip())
			Loop
		EndIf
	
		// Processa somente produtos nos locais informados
		If (cAliasSB2)->B2_LOCAL < mv_par03 .Or. (cAliasSB2)->B2_LOCAL > mv_par04
			(cAliasSB2)->(dbSkip())
			Loop
		EndIf
	
		// Verificar se utiliza Rastro ou Localizacao		
		lRastro   := Rastro((cAliasSB2)->B2_COD)
		lLocaliza := Localiza((cAliasSB2)->B2_COD)
	
	    // Processa somente se o produto possuir controle de endereco ou lote
		If !lLocaliza .And. !lRastro
			(cAliasSB2)->(dbSkip())
			Loop
		EndIf
	
		// Nao processar produto Mao-de-Obra
		If IsProdMod((cAliasSB2)->B2_COD)
			(cAliasSB2)->(dbSkip())
			Loop
		EndIf
	
		If li > 58
			cabec(titulo,cabec1,cabec2,wnrel,Tamanho,nTipo)
		EndIf          
	
		// Inicializa variaveis de controle
		cStatus := ''
		nQtdSB2 := 0
		nQtdSBK := 0
		nQtdSBJ := 0
		nQtdSDA := 0
		aNewSBK := {}
		aNewSBJ := {}
	
		// Impressao baseada no saldo atual
		If mv_par05 == 1
			nQtdSB2 :=  (cAliasSB2)->B2_QATU
			If lRastro
				dbSelectArea('SB8')
				dbSetOrder(3)
				#IFDEF TOP
					lQuery    := .T.
					cAliasSB8 := GetNextAlias()
					cQuery := "SELECT B8_SALDO "
					cQuery +=   "FROM " + RetSqlName("SB8") + " SB8 "
					cQuery +=  "WHERE SB8.B8_FILIAL = '"      + xFilial('SB8') 			+ "' AND "
					cQuery +=       " SB8.B8_PRODUTO = '"     + (cAliasSB2)->B2_COD		+ "' AND "
					cQuery +=       " SB8.B8_LOCAL = '"       + (cAliasSB2)->B2_LOCAL	+ "' AND "
					cQuery +=       " SB8.D_E_L_E_T_ = ' ' "	
					cQuery:=ChangeQuery(cQuery)
					dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQuery),cAliasSB8,.F.,.T.)
					TcSetField( cAliasSB8, "B8_SALDO","N", aTamSB8[1],aTamSB8[2] )
				#ELSE
					dbSeek(cSeek := xFilial("SB8") + (cAliasSB2)->B2_COD + (cAliasSB2)->B2_LOCAL, .F.)
				#ENDIF
				dbSelectArea(cAliasSB8)
				Do While !Eof() .And. IIf(lQuery,.T.,B8_FILIAL + B8_PRODUTO + B8_LOCAL == cSeek)
					nQtdSBJ += (cAliasSB8)->B8_SALDO
					dbSkip()
				EndDo
				If lQuery
					dbSelectArea(cAliasSB8)
					dbCloseArea()
				EndIf
		    EndIf
			If lLocaliza
				dbSelectArea('SBF')
				dbSetOrder(2)
				#IFDEF TOP
					lQuery    := .T.
					cAliasSBF := GetNextAlias()
					cQuery := "SELECT BF_QUANT "
					cQuery +=   "FROM " + RetSqlName("SBF") + " SBF "
					cQuery +=  "WHERE SBF.BF_FILIAL = '"      + xFilial('SBF') 			+ "' AND "
					cQuery +=       " SBF.BF_PRODUTO = '"     + (cAliasSB2)->B2_COD    + "' AND "
					cQuery +=       " SBF.BF_LOCAL = '"       + (cAliasSB2)->B2_LOCAL  + "' AND "
					cQuery +=       " SBF.D_E_L_E_T_ = ' ' "	
					cQuery:=ChangeQuery(cQuery)
					dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQuery),cAliasSBF,.F.,.T.)
					TcSetField( cAliasSBF, "BF_QUANT","N", aTamSBF[1],aTamSBF[2] )
				#ELSE
					dbSeek(cSeek := xFilial('SBF') + (cAliasSB2)->B2_COD + (cAliasSB2)->B2_LOCAL, .F.)
				#ENDIF
				dbSelectArea(cAliasSBF)
				Do While !Eof() .And. IIf(lQuery,.T.,BF_FILIAL + BF_PRODUTO + BF_LOCAL == cSeek)
					nQtdSBK += (cAliasSBF)->BF_QUANT
					dbSkip()
				EndDo
				If lQuery
					dbSelectArea(cAliasSBF)
					dbCloseArea()
				EndIf
				dbSelectArea('SDA')
				dbSetOrder(1)
				#IFDEF TOP
					lQuery    := .T.
					cAliasSDA := GetNextAlias()
					cQuery := "SELECT DA_SALDO "
					cQuery +=   "FROM " + RetSqlName("SDA") + " SDA "
					cQuery +=  "WHERE SDA.DA_FILIAL = '"      + xFilial('SDA')			+ "' AND "
					cQuery +=       " SDA.DA_PRODUTO = '"     + (cAliasSB2)->B2_COD		+ "' AND "
					cQuery +=       " SDA.DA_LOCAL = '"       + (cAliasSB2)->B2_LOCAL	+ "' AND "
					cQuery +=       " SDA.D_E_L_E_T_ = ' ' "	
					cQuery:=ChangeQuery(cQuery)
					dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQuery),cAliasSDA,.F.,.T.)
					TcSetField( cAliasSDA, "DA_SALDO","N", aTamSDA[1],aTamSDA[2] )
				#ELSE
					dbSeek(cSeek:=xFilial('SDA')+(cAliasSB2)->B2_COD+(cAliasSB2)->B2_LOCAL)
				#ENDIF
				dbSelectArea(cAliasSDA)
				Do While !Eof() .And. IIf(lQuery,.T.,SDA->DA_FILIAL + SDA->DA_PRODUTO + SDA->DA_LOCAL == cSeek)
					If QtdComp((cAliasSDA)->DA_SALDO) > QtdComp(0)
						nQtdSDA += (cAliasSDA)->DA_SALDO
					EndIf	
					dbSkip()
				EndDo
				If lQuery
					dbSelectArea(cAliasSDA)
					dbCloseArea()
				EndIf
			EndIf
	
		// Impressao baseada no saldo por movimento ou pelo saldo de fechamento
		ElseIf mv_par05 == 2 .Or. mv_par05 == 3
			// Analisa o tipo de saldos
			If mv_par05 == 2
				nQtdSB2 :=  CalcEst((cAliasSB2)->B2_COD,(cAliasSB2)->B2_LOCAL,mv_par06+1)[1]
			Else
				nQtdSB2 :=  (cAliasSB2)->B2_QFIM
			EndIf	
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Processa saldo por Endereco (Utiliza SB2 Posicionada)        |
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			dbSelectArea(cAliasSB2)
			If lLocaliza
				If lExistProc
					MR282SP2(cFilAnt,DTOS(mv_par06),(cAliasSB2)->B2_COD,(cAliasSB2)->B2_LOCAL,DTOS(dUlMes),If( l300SalNeg, '1', '0' ),'1',@aResult)
					// Realiza a abertura da tabela temporaria TRK
					cQuery := "SELECT * FROM TRK"+cEmpAnt+cNomeTab
					cQuery += " WHERE BK_FILIAL = '" + xFilial("SBK")			+ "' AND "
					cQuery +=       " BK_COD    = '" + (cAliasSB2)->B2_COD		+ "' AND "
					cQuery +=       " BK_LOCAL  = '" + (cAliasSB2)->B2_LOCAL	+ "' AND "
					cQuery +=       " D_E_L_E_T_ = ' ' "
					cQuery := ChangeQuery(cQuery)
					dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), "TRK", .F., .T.)
					TcSetField( "TRK", "BK_QINI","N", aTamSBK[1],aTamSBK[2] )
					Do While !TRK->(Eof())
						nQtdSBK += TRK->BK_QINI				
						dbSkip()
					EndDo
					TRK->(dbCloseArea())
				Else
					If lQrySB2
						MsGoto((cAliasSB2)->RECNOSB2)
					EndIf
					BKAtuComB2(mv_par06, .F., Nil, .T., @aNewSBK)
					For nX := 1 to Len(aNewSBK)
						nQtdSBK += aNewSBK[nX,9]
					Next nX
				EndIf			
				nQtdSDA := MR282SDA((cAliasSB2)->B2_COD,(cAliasSB2)->B2_LOCAL,mv_par06,dUlMes)
			EndIf	
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Processa saldo por Lote/SubLote (Utiliza SB2 Posicionada)    |
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			dbSelectArea('SB2')
			If lRastro
				If lExistProc
					MR282SP1(cFilAnt,DTOS(mv_par06),(cAliasSB2)->B2_COD,(cAliasSB2)->B2_LOCAL,cRastro,DTOS(dUlMes),If( l300SalNeg, '1', '0' ),'1',@aResult)
					// Realiza a abertura da tabela temporaria TRJ
					cQuery := "SELECT * FROM TRJ"+cEmpAnt+cNomeTab
					cQuery += " WHERE BJ_FILIAL = '" + xFilial("SBJ")			+ "' AND "
					cQuery +=       " BJ_COD    = '" + (cAliasSB2)->B2_COD		+ "' AND "
					cQuery +=       " BJ_LOCAL  = '" + (cAliasSB2)->B2_LOCAL	+ "' AND "
					cQuery +=       " D_E_L_E_T_ = ' ' "
					cQuery := ChangeQuery(cQuery)
					dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), "TRJ", .F., .T.)
					TcSetField( "TRJ", "BJ_QINI","N", aTamSBJ[1],aTamSBJ[2] )
					Do While !TRJ->(Eof())
						nQtdSBJ += TRJ->BJ_QINI				
						dbSkip()
					EndDo
					TRJ->(dbCloseArea())
				Else
					If lQrySB2
						MsGoto((cAliasSB2)->RECNOSB2)
					EndIf
					BJAtuComB2(mv_par06, .F., Nil, .T., @aNewSBJ)
					For nX := 1 to Len(aNewSBJ)
						nQtdSBJ += aNewSBJ[nX,7]
					Next nX
				EndIf	
		    EndIf
		EndIf
		
		// Posiciona na tabela SB1
		dbSelectArea('SB1')
		dbSetOrder(1)
		dbSeek(xFilial('SB1')+(cAliasSB2)->B2_COD)
		
		// Verifica o Status da Conferencia de Saldos
		If lLocaliza .And. lRastro
			If QtdComp(nQtdSB2)==QtdComp(nQtdSBK) .And. QtdComp(nQtdSB2)==QtdComp(nQtdSBJ) .And. QtdComp(nQtdSDA)==QtdComp(0)
				cStatus := 'OK'
			ElseIf QtdComp(nQtdSDA) > QtdComp(0)
				cStatus := STR0017 //'SDA=PENDENTE'
			ElseIf QtdComp(nQtdSB2)<>QtdComp(nQtdSBK) .And. QtdComp(nQtdSB2)<>QtdComp(nQtdSBJ)
				cStatus := 'SB2xSBFxSB8'
			ElseIf QtdComp(nQtdSB2)<>QtdComp(nQtdSBK)
				cStatus := 'SB2xSBF'
			ElseIf QtdComp(nQtdSB2)<>QtdComp(nQtdSBJ)
				cStatus := 'SB2xSB8'
			EndIf
		ElseIf lLocaliza
			If QtdComp(nQtdSB2)==QtdComp(nQtdSBK) .And. QtdComp(nQtdSDA)==QtdComp(0)
				cStatus := 'OK'
			ElseIf QtdComp(nQtdSDA) > 0
				cStatus := STR0017 //'SDA=PENDENTE'
			Else
				cStatus := 'SB2xSBF'
			EndIf
		ElseIf lRastro
			If nQtdSB2 == nQtdSBJ
				cStatus := 'OK'
			Else
				cStatus := 'SB2xSB8'
			EndIf	
		EndIf		
	
		If (mv_par07 == 1 .And. cStatus == 'OK') .Or.;
		   (mv_par07 == 2 .And. cStatus <> 'OK') .Or.;
		    mv_par07 == 3
	
		    // Impressao do item 
			@ li,001 PSAY (cAliasSB2)->B2_FILIAL
			@ li,008 PSAY (cAliasSB2)->B2_COD
			@ li,035 PSAY '|'
			@ li,037 PSAY (cAliasSB2)->B2_LOCAL
			@ li,044 PSAY '|'
			@ li,046 PSAY IIf(SB1->B1_LOCALIZ=='S',STR0018,STR0019) //"SIM"|"NAO"
			@ li,055 PSAY '|'
			@ li,057 PSAY IIf(SB1->B1_RASTRO=='L',STR0020,IIf(SB1->B1_RASTRO=='S',STR0021,STR0019)) //"LOTE"|"SUBLOTE"|"NAO"
			@ li,070 PSAY '|'
			@ li,072 PSAY nQtdSB2	PICTURE cPictSB2
			@ li,091 PSAY '|'
			@ li,093 PSAY nQtdSBK		PICTURE cPictSBK
			@ li,112 PSAY '|'
			@ li,114 PSAY nQtdSDA		PICTURE cPictSDA
			@ li,133 PSAY '|'
			@ li,135 PSAY nQtdSBJ		PICTURE cPictSBJ
			@ li,154 PSAY '|'
			@ li,156 PSAY cStatus
			Li++
		EndIf
		
		dbSelectArea(cAliasSB2)
		dbSkip()				
		
	EndDo
	
	If li != 80
		roda(cbcont,cbtxt,Tamanho)
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Apaga arquivo de trabalho                                    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	If aReturn[5] = 1
		Set Printer TO
		dbCommitAll()
		ourspool(wnrel)
	EndIf
	
	If lQrySB2
		(cAliasSB2)->(dbCloseArea())
	EndIf
	
	MS_FLUSH()

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Desbloqueia a execucao do relatorio                          |
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	MR2820UnLock()

EndIf

RestArea(aAreaAnt)
Return NIL

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ AjustaSX1 ³ Autor ³ Microsiga S/A        ³ Data ³ 06/08/09 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Ajusta o grupo de perguntas                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR282			                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function AjustaSX1()
Local aArea := GetArea()
Local cPerg := "MTR282"

//------ PERGUNTA 01 ------
PutSx1(cPerg, ; 	                                //-- 01 - X1_GRUPO
	'01' , ;                                        //-- 02 - X1_ORDEM
	'Do produto ?', ;             					//-- 03 - X1_PERGUNT
	'¿De Producto ?', ; 				            //-- 04 - X1_PERSPA
	'From Product ?', ;    					        //-- 05 - X1_PERENG
	'mv_ch1', ;                                     //-- 06 - X1_VARIAVL
	'C', ;                                          //-- 07 - X1_TIPO
	TamSX3("B1_COD")[1], ;                          //-- 08 - X1_TAMANHO
	0, ;                                            //-- 09 - X1_DECIMAL
	0, ;                                            //-- 10 - X1_PRESEL
	'G', ;                                          //-- 11 - X1_GSC
	'', ;                                           //-- 12 - X1_VALID
	'SB1', ;                                        //-- 13 - X1_F3
	'', ;                                           //-- 14 - X1_GRPSXG
	'', ;                                           //-- 15 - X1_PYME
	'mv_par01', ;                                   //-- 16 - X1_VAR01
	'', ;		                                    //-- 17 - X1_DEF01
	'', ;		                                    //-- 18 - X1_DEFSPA1
	'', ;		                                    //-- 19 - X1_DEFENG1
	'', ;				                            //-- 20 - X1_CNT01
	'', ;                                      		//-- 21 - X1_DEF02
	'', ;                                      		//-- 22 - X1_DEFSPA2
	'', ;                                      		//-- 23 - X1_DEFENG2
	'', ;                                           //-- 24 - X1_DEF03
	'', ;                                           //-- 25 - X1_DEFSPA3
	'', ;                                           //-- 26 - X1_DEFENG3
	'', ;                                           //-- 27 - X1_DEF04
	'', ;                                           //-- 28 - X1_DEFSPA4
	'', ;                                           //-- 29 - X1_DEFENG4
	'', ;                                           //-- 30 - X1_DEF05
	'', ;                                           //-- 31 - X1_DEFSPA5
	'', ;                                           //-- 32 - X1_DEFENG5
	{'Informe o codigo do produto inicial.    ', ;  //-- 33 - HelpPor1#3
	 '                                        ', ;  //--      HelpPor2#3
	 '                                        '}, ; //--      HelpPor3#3
	{'Informar el código del producto inicial.' , ; //-- 34 - HelpEsp1#3
	 '                                        ', ;  //--      HelpEsp2#3
	 '                                        '}, ; //--      HelpEsp3#3
	{'Inform the code of the initial product. ', ;  //-- 35 - HelpEng1#3
	 '                                        ', ;  //--      HelpEng2#3
	 '                                        '}, ; //--      HelpEng3#3
	 '')                                            //-- 36 - X1_HELP

//------ PERGUNTA 02 ------
PutSx1(cPerg, ; 	                                //-- 01 - X1_GRUPO
	'02' , ;                                        //-- 02 - X1_ORDEM
	'Até produto ?', ;             					//-- 03 - X1_PERGUNT
	'¿A Producto ?', ; 					            //-- 04 - X1_PERSPA
	'To Product ?', ;     					        //-- 05 - X1_PERENG
	'mv_ch2', ;                                     //-- 06 - X1_VARIAVL
	'C', ;                                          //-- 07 - X1_TIPO
	TamSX3("B1_COD")[1], ;                          //-- 08 - X1_TAMANHO
	0, ;                                            //-- 09 - X1_DECIMAL
	0, ;                                            //-- 10 - X1_PRESEL
	'G', ;                                          //-- 11 - X1_GSC
	'', ;                                           //-- 12 - X1_VALID
	'SB1', ;                                        //-- 13 - X1_F3
	'', ;                                           //-- 14 - X1_GRPSXG
	'', ;                                           //-- 15 - X1_PYME
	'mv_par02', ;                                   //-- 16 - X1_VAR01
	'', ;   					                    //-- 17 - X1_DEF01
	'', ;		                                    //-- 18 - X1_DEFSPA1
	'', ;		                                    //-- 19 - X1_DEFENG1
	'ZZZZZZZZZZZZZZZ', ;                            //-- 20 - X1_CNT01
	'', ;                                      		//-- 21 - X1_DEF02
	'', ;                                      		//-- 22 - X1_DEFSPA2
	'', ;                                      		//-- 23 - X1_DEFENG2
	'', ;                                           //-- 24 - X1_DEF03
	'', ;                                           //-- 25 - X1_DEFSPA3
	'', ;                                           //-- 26 - X1_DEFENG3
	'', ;                                           //-- 27 - X1_DEF04
	'', ;                                           //-- 28 - X1_DEFSPA4
	'', ;                                           //-- 29 - X1_DEFENG4
	'', ;                                           //-- 30 - X1_DEF05
	'', ;                                           //-- 31 - X1_DEFSPA5
	'', ;                                           //-- 32 - X1_DEFENG5
	{'Informe do codigo do produto final.     ', ;  //-- 33 - HelpPor1#3
	 '                                        ', ;  //--      HelpPor2#3
	 '                                        '}, ; //--      HelpPor3#3
	{'Informar el código del producto final.  ', ;  //-- 34 - HelpEsp1#3
	 '                                        ', ;  //--      HelpEsp2#3
	 '                                        '}, ; //--      HelpEsp3#3
	{'Inform the code of the final product.   ', ;  //-- 35 - HelpEng1#3
	 '                                        ', ;  //--      HelpEng2#3
	 '                                        '}, ; //--      HelpEng3#3
	 '')                                            //-- 36 - X1_HELP

//------ PERGUNTA 03 ------
PutSx1(cPerg, ; 	                                //-- 01 - X1_GRUPO
	'03' , ;                                        //-- 02 - X1_ORDEM
	'Do armazém ?', ;             					//-- 03 - X1_PERGUNT
	'¿De Deposito ?', ;					            //-- 04 - X1_PERSPA
	'From WareHouse ?', ;  					        //-- 05 - X1_PERENG
	'mv_ch3', ;                                     //-- 06 - X1_VARIAVL
	'C', ;                                          //-- 07 - X1_TIPO
	TamSX3("B1_LOCPAD")[1], ;                       //-- 08 - X1_TAMANHO
	0, ;                                            //-- 09 - X1_DECIMAL
	0, ;                                            //-- 10 - X1_PRESEL
	'G', ;                                          //-- 11 - X1_GSC
	'', ;                                           //-- 12 - X1_VALID
	'', ;                                           //-- 13 - X1_F3
	'', ;                                           //-- 14 - X1_GRPSXG
	'', ;                                           //-- 15 - X1_PYME
	'mv_par03', ;                                   //-- 16 - X1_VAR01
	'', ;		                                    //-- 17 - X1_DEF01
	'', ;		                                    //-- 18 - X1_DEFSPA1
	'', ;		                                    //-- 19 - X1_DEFENG1
	'', ;                                           //-- 20 - X1_CNT01
	'', ;                                      		//-- 21 - X1_DEF02
	'', ;                                      		//-- 22 - X1_DEFSPA2
	'', ;                                      		//-- 23 - X1_DEFENG2
	'', ;                                           //-- 24 - X1_DEF03
	'', ;                                           //-- 25 - X1_DEFSPA3
	'', ;                                           //-- 26 - X1_DEFENG3
	'', ;                                           //-- 27 - X1_DEF04
	'', ;                                           //-- 28 - X1_DEFSPA4
	'', ;                                           //-- 29 - X1_DEFENG4
	'', ;                                           //-- 30 - X1_DEF05
	'', ;                                           //-- 31 - X1_DEFSPA5
	'', ;                                           //-- 32 - X1_DEFENG5
	{'Informe o codigo do armazem inicial.    ', ;  //-- 33 - HelpPor1#3
	 '                                        ', ;  //--      HelpPor2#3
	 '                                        '}, ; //--      HelpPor3#3
	{'Informar el código del deposito inicial.', ;  //-- 34 - HelpEsp1#3
	 '                                        ', ;  //--      HelpEsp2#3
	 '                                        '}, ; //--      HelpEsp3#3
	{'Inform the code of the initial warehouse.', ; //-- 35 - HelpEng1#3
	 '                                        ', ;  //--      HelpEng2#3
	 '                                        '}, ; //--      HelpEng3#3
	 '')                                            //-- 36 - X1_HELP
          
//------ PERGUNTA 04 ------
PutSx1(cPerg, ; 	                                //-- 01 - X1_GRUPO
	'04' , ;                                        //-- 02 - X1_ORDEM
	'Até armazém ?', ;             					//-- 03 - X1_PERGUNT
	'¿A Deposito ?', ; 					            //-- 04 - X1_PERSPA
	'To WareHouse ?', ;   					        //-- 05 - X1_PERENG
	'mv_ch3', ;                                     //-- 06 - X1_VARIAVL
	'C', ;                                          //-- 07 - X1_TIPO
	TamSX3("B1_LOCPAD")[1], ;                       //-- 08 - X1_TAMANHO
	0, ;                                            //-- 09 - X1_DECIMAL
	0, ;                                            //-- 10 - X1_PRESEL
	'G', ;                                          //-- 11 - X1_GSC
	'', ;                                           //-- 12 - X1_VALID
	'', ;                                           //-- 13 - X1_F3
	'', ;                                           //-- 14 - X1_GRPSXG
	'', ;                                           //-- 15 - X1_PYME
	'mv_par04', ;                                   //-- 16 - X1_VAR01
	'', ;		                                    //-- 17 - X1_DEF01
	'', ;		                                    //-- 18 - X1_DEFSPA1
	'', ;		                                    //-- 19 - X1_DEFENG1
	'ZZ', ;                                         //-- 20 - X1_CNT01
	'', ;                                      		//-- 21 - X1_DEF02
	'', ;                                      		//-- 22 - X1_DEFSPA2
	'', ;                                      		//-- 23 - X1_DEFENG2
	'', ;                                           //-- 24 - X1_DEF03
	'', ;                                           //-- 25 - X1_DEFSPA3
	'', ;                                           //-- 26 - X1_DEFENG3
	'', ;                                           //-- 27 - X1_DEF04
	'', ;                                           //-- 28 - X1_DEFSPA4
	'', ;                                           //-- 29 - X1_DEFENG4
	'', ;                                           //-- 30 - X1_DEF05
	'', ;                                           //-- 31 - X1_DEFSPA5
	'', ;                                           //-- 32 - X1_DEFENG5
	{'Informe o codigo do armazem final.      ', ;  //-- 33 - HelpPor1#3
	 '                                        ', ;  //--      HelpPor2#3
	 '                                        '}, ; //--      HelpPor3#3
	{'Informar el código del deposito final.  ', ;  //-- 34 - HelpEsp1#3
	 '                                        ', ;  //--      HelpEsp2#3
	 '                                        '}, ; //--      HelpEsp3#3
	{'Inform the code of the final warehouse. ', ;  //-- 35 - HelpEng1#3
	 '                                        ', ;  //--      HelpEng2#3
	 '                                        '}, ; //--      HelpEng3#3
	 '')                                            //-- 36 - X1_HELP

//------ PERGUNTA 05 ------
PutSx1(cPerg, ; 	                                //-- 01 - X1_GRUPO
	'05' , ;                                        //-- 02 - X1_ORDEM
	'Saldo a Considerar ?', ;	   					//-- 03 - X1_PERGUNT
	'¿Saldo a Considerar ?', ;		            	//-- 04 - X1_PERSPA
	'Balance to Considered ?', ;		        	//-- 05 - X1_PERENG
	'mv_ch5', ;                                     //-- 06 - X1_VARIAVL
	'N', ;                                          //-- 07 - X1_TIPO
	1, ;					                        //-- 08 - X1_TAMANHO
	0, ;                                            //-- 09 - X1_DECIMAL
	1, ;                                            //-- 10 - X1_PRESEL
	'C', ;                                          //-- 11 - X1_GSC
	'', ;                                           //-- 12 - X1_VALID
	'', ;                                           //-- 13 - X1_F3
	'', ;                                           //-- 14 - X1_GRPSXG
	'', ;                                           //-- 15 - X1_PYME
	'mv_par05', ;                                   //-- 16 - X1_VAR01
	'Atual', ; 			                            //-- 17 - X1_DEF01
	'Actual', ;          			                //-- 18 - X1_DEFSPA1
	'Current', ;		                            //-- 19 - X1_DEFENG1
	'', ;                                           //-- 20 - X1_CNT01
	'Movimento', ;		                       		//-- 21 - X1_DEF02
	'Movimiento', ;                      		    //-- 22 - X1_DEFSPA2
	'Movement', ;                       		    //-- 23 - X1_DEFENG2
	'Fechamento', ;                                 //-- 24 - X1_DEF03
	'Cierre', ;		                                //-- 25 - X1_DEFSPA3
	'Closing', ; 	                                //-- 26 - X1_DEFENG3
	'', ;                                           //-- 27 - X1_DEF04
	'', ;                                           //-- 28 - X1_DEFSPA4
	'', ;                                           //-- 29 - X1_DEFENG4
	'', ;                                           //-- 30 - X1_DEF05
	'', ;                                           //-- 31 - X1_DEFSPA5
	'', ;                                           //-- 32 - X1_DEFENG5
	{'Selecione o tipo de saldo a ser         ' , ;	//-- 33 - HelpPor1#3
	 'considerado na impressao.               '	, ;	//--      HelpPor2#3
	 '                                        '}, ;	//--      HelpPor3#3
	{'Seleccione el tipo de saldo que debe    '	, ;	//-- 34 - HelpEsp1#3
	 'considerarse en la impresión.           '	, ;	//--      HelpEsp2#3
	 '                                        '}, ;	//--      HelpEsp3#3
	{'Select the type of balance to be        '	, ;	//-- 35 - HelpEng1#3
	 'considered in printing.                 '	, ;	//--      HelpEng2#3
	 '                                        '}, ;	//--      HelpEng3#3
	 '')                                            //-- 36 - X1_HELP

//------ PERGUNTA 06 ------
PutSx1(cPerg, ; 	                                //-- 01 - X1_GRUPO
	'06' , ;                                        //-- 02 - X1_ORDEM
	'Data de Referencia ?', ;   					//-- 03 - X1_PERGUNT
	'¿Fecha de Referencia ?', ;		            	//-- 04 - X1_PERSPA
	'Reference date ?', ;				        	//-- 05 - X1_PERENG
	'mv_ch5', ;                                     //-- 06 - X1_VARIAVL
	'D', ;                                          //-- 07 - X1_TIPO
	8, ;					                        //-- 08 - X1_TAMANHO
	0, ;                                            //-- 09 - X1_DECIMAL
	0, ;                                            //-- 10 - X1_PRESEL
	'G', ;                                          //-- 11 - X1_GSC
	'', ;                                           //-- 12 - X1_VALID
	'', ;                                           //-- 13 - X1_F3
	'', ;                                           //-- 14 - X1_GRPSXG
	'', ;                                           //-- 15 - X1_PYME
	'mv_par06', ;                                   //-- 16 - X1_VAR01
	'', ;		                                    //-- 17 - X1_DEF01
	'', ;		                                    //-- 18 - X1_DEFSPA1
	'', ;		                                    //-- 19 - X1_DEFENG1
	'', ;                                           //-- 20 - X1_CNT01
	'', ;                                      		//-- 21 - X1_DEF02
	'', ;                                      		//-- 22 - X1_DEFSPA2
	'', ;                                      		//-- 23 - X1_DEFENG2
	'', ;                                           //-- 24 - X1_DEF03
	'', ;                                           //-- 25 - X1_DEFSPA3
	'', ;                                           //-- 26 - X1_DEFENG3
	'', ;                                           //-- 27 - X1_DEF04
	'', ;                                           //-- 28 - X1_DEFSPA4
	'', ;                                           //-- 29 - X1_DEFENG4
	'', ;                                           //-- 30 - X1_DEF05
	'', ;                                           //-- 31 - X1_DEFSPA5
	'', ;                                           //-- 32 - X1_DEFENG5
	{'Informe a data de referencia para o     '	, ;	//-- 33 - HelpPor1#3
	 'processamento do saldo por movimento    '	, ;	//--      HelpPor2#3
	 'ou saldo por fechamento.                '}, ;	//--      HelpPor3#3
	{'Introduzca la fecha de referencia para  '	, ;	//-- 34 - HelpEsp1#3
	 'la elaboración de la balanza por el     '	, ;	//--      HelpEsp2#3
	 'movimiento el cierre de saldo.          '}, ;	//--      HelpEsp3#3
	{'Enter the date of reference for the     '	, ;	//-- 35 - HelpEng1#3
	 'processing of the balance by moving or  '	, ;	//--      HelpEng2#3
	 'by closing balance.                     '}, ;	//--      HelpEng3#3
	 '')                                            //-- 36 - X1_HELP

//------ PERGUNTA 07 ------
PutSx1(cPerg, ; 	                                //-- 01 - X1_GRUPO
	'07' , ;                                        //-- 02 - X1_ORDEM
	'Listar Produtos ?', ;		   					//-- 03 - X1_PERGUNT
	'¿Lista de Productos ?', ;		            	//-- 04 - X1_PERSPA
	'Products List ?', ;				        	//-- 05 - X1_PERENG
	'mv_ch7', ;                                     //-- 06 - X1_VARIAVL
	'N', ;                                          //-- 07 - X1_TIPO
	1, ;					                        //-- 08 - X1_TAMANHO
	0, ;                                            //-- 09 - X1_DECIMAL
	3, ;                                            //-- 10 - X1_PRESEL
	'C', ;                                          //-- 11 - X1_GSC
	'', ;                                           //-- 12 - X1_VALID
	'', ;                                           //-- 13 - X1_F3
	'', ;                                           //-- 14 - X1_GRPSXG
	'', ;                                           //-- 15 - X1_PYME
	'mv_par07', ;                                   //-- 16 - X1_VAR01
	'Sem Diferenças', ;                             //-- 17 - X1_DEF01
	'No diferencias', ;                             //-- 18 - X1_DEFSPA1
	'No differences', ;                             //-- 19 - X1_DEFENG1
	'', ;                                           //-- 20 - X1_CNT01
	'Com Diferenças', ;                       		//-- 21 - X1_DEF02
	'Con diferencias', ;                      		//-- 22 - X1_DEFSPA2
	'With Differences', ;                      		//-- 23 - X1_DEFENG2
	'Ambas', ;                                      //-- 24 - X1_DEF03
	'Ambos', ;                                      //-- 25 - X1_DEFSPA3
	'Both', ;	                                    //-- 26 - X1_DEFENG3
	'', ;                                           //-- 27 - X1_DEF04
	'', ;                                           //-- 28 - X1_DEFSPA4
	'', ;                                           //-- 29 - X1_DEFENG4
	'', ;                                           //-- 30 - X1_DEF05
	'', ;                                           //-- 31 - X1_DEFSPA5
	'', ;                                           //-- 32 - X1_DEFENG5
	{'Selecione o tipo de listagem a ser      ' , ;	//-- 33 - HelpPor1#3
	 'Impressa.                               '	, ;	//--      HelpPor2#3
	 '                                        '}, ;	//--      HelpPor3#3
	{'Seleccione el tipo de información       '	, ;	//-- 34 - HelpEsp1#3
	 'que se imprime.                         '	, ;	//--      HelpEsp2#3
	 '                                        '}, ;	//--      HelpEsp3#3
	{'Select the listing type to be printed.  '	, ;	//-- 35 - HelpEng1#3
	 '                                        '	, ;	//--      HelpEng2#3
	 '                                        '}, ;	//--      HelpEng3#3
	 '')                                            //-- 36 - X1_HELP
         
RestArea(aArea)
Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³MR282SP1    ³ Autor ³ Microsiga S/A         ³ Data ³14/09/09³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Processa a stored procedure MAT036 referente ao saldo por  ³±±
±±³          ³ lote/sublote a ser gerado no fechamento (SBJ)              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³cCodFil    - Codigo da Filial                               ³±±
±±³          ³cDataFec   - Data do proximo Fechamento                     ³±±
±±³          ³cProduto   - Codigo do Produto                              ³±±
±±³          ³cLocal     - Codigo do Armazem                              ³±±
±±³          ³cRastro    - Conteudo do parametro MV_RASTRO                ³±±
±±³          ³cUlMes     - Data do parametro MV_ULMES                     ³±±
±±³          ³c300SalNeg - Considera saldo negativo                       ³±±
±±³          ³cConsulta  - Indica se executa a procedure de consulta      ³±±
±±³          ³aResult    - Array utilizado para o retorno da procedures   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR282                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function MR282SP1(cCodFil,cDataFec,cProduto,cLocal,cRastro,cUlMes,c300SalNeg,cConsulta,aResult)
Local cSPMAT036 := IIF(FindFunction("GetSPName"), GetSPName("MAT036","17"), "MAT036")

aResult:= TCSPEXEC( xProcedures( cSPMAT036 ),cCodFil,cDataFec,cProduto,cLocal,cRastro,cUlMes,c300SalNeg,0,0,cConsulta,IIf(FindFunction("A330FilNum"),A330FilNum(cCodFil),0) )
If Empty(aResult)
	Final(STR0022) //"Erro na chamada do Processo"
EndIf
Return aResult

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³MR282SP2    ³ Autor ³ Microsiga S/A         ³ Data ³14/09/09³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Processa a stored procedure MAT037 referente ao saldo por  ³±±
±±³          ³ endereco a ser gerado no fechamento (SBK)                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³cCodFil    - Codigo da Filial                               ³±±
±±³          ³cDataFec   - Data do proximo Fechamento                     ³±±
±±³          ³cProduto   - Codigo do Produto                              ³±±
±±³          ³cLocal     - Codigo do Armazem                              ³±±
±±³          ³cUlMes     - Data do parametro MV_ULMES                     ³±±
±±³          ³c300SalNeg - Considera saldo negativo                       ³±±
±±³          ³cConsulta  - Indica se executa a procedure de consulta      ³±±
±±³          ³aResult    - Array utilizado para o retorno da procedures   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR282                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function MR282SP2(cCodFil,cDataFec,cProduto,cLocal,cUlMes,c300SalNeg,cConsulta,aResult)
Local cSPMAT037 := IIF(FindFunction("GetSPName"), GetSPName("MAT037","17"), "MAT037")

aResult:= TCSPEXEC( xProcedures(cSPMAT037),cCodFil,cDataFec,cProduto,cLocal,cUlMes,c300SalNeg,0,cConsulta,IIf(FindFunction("A330FilNum"),A330FilNum(cCodFil),0) )

If Empty(aResult)
	Final(STR0022) //"Erro na chamada do Processo"
EndIf

Return aResult  

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³VerIDProc ³ Autor ³ Microsiga S/A         ³ Data ³19/09/2009³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Identifica a sequencia de controle do fonte ADVPL com a     ³±±
±±³          ³stored procedure, qualquer alteracao que envolva diretamente³±±
±±³          ³a stored procedure a variavel sera incrementada.            ³±±
±±³          ³Procedure MAT038                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao Efetuada                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/         
#IFDEF TOP
	Static Function VerIDProc()
	Return '011'
#ENDIF	

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³MR282SDA  ³ Autor ³ Microsiga S/A         ³ Data ³15/09/2009³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Identifica a sequencia de controle do fonte ADVPL com a     ³±±
±±³          ³stored procedure, qualquer alteracao que envolva diretamente³±±
±±³          ³a stored procedure a variavel sera incrementada.            ³±±
±±³          ³Procedure MAT038                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³cProduto - Codigo do Produto                                ³±±
±±³          ³cLocal   - Codigo do Armazem                                ³±±
±±³          ³cDtFech  - Data do proximo fechamento de estoque            ³±±
±±³          ³cUlMes   - Data do parametro MV_ULMES                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao Efetuada                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/         
Static Function MR282SDA(cProduto,cLocal,cDtFech,dUlMes)
Local aAreaAnt  := GetArea()
Local aAreaSDA  := SDA->(GetArea())
Local nQuantSDA := 0
Local cAliasSDA := 'SDA'
Local cSeek     := ''
#IFDEF TOP
	Local cQuery    := ''
	Local aTamSDA   := TamSX3("DA_SALDO")
#ENDIF	

//-- Analisa saldo a enderecar
dbSelectArea('SDA')
dbSetOrder(1)
#IFDEF TOP
	lQuery    := .T.
	cAliasSDA := GetNextAlias()
	cQuery := "SELECT DA_SALDO, DA_DATA "
	cQuery +=   "FROM " + RetSqlName("SDA") + " SDA "
	cQuery +=  "WHERE SDA.DA_FILIAL = '"      + xFilial('SDA') + "' AND "
	cQuery +=       " SDA.DA_PRODUTO = '"     + cProduto       + "' AND "
	cQuery +=       " SDA.DA_LOCAL = '"       + cLocal         + "' AND "
	cQuery +=       " SDA.DA_DATA > '"        + DTOS(dUlMes)   + "' AND "
	cQuery +=       " SDA.DA_DATA <= '"       + DTOS(cDtFech)  + "' AND "
	cQuery +=       " SDA.DA_SALDO > 0 AND " 
	cQuery +=       " SDA.D_E_L_E_T_ = ' ' "	
	cQuery:=ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQuery),cAliasSDA,.F.,.T.)
	TcSetField( cAliasSDA, "DA_SALDO","N", aTamSDA[1],aTamSDA[2] )
	TcSetField( cAliasSDA, "DA_DATA" ,"D", 8 ,0 )
	dbSelectArea(cAliasSDA)
#ELSE
	dbSeek(cSeek := xFilial("SDA")+cProduto+cLocal, .F.)
#ENDIF

Do While !Eof() .And. IIf(lQuery,.T.,DA_FILIAL+DA_PRODUTO+DA_LOCAL == cSeek)

	//-- Desconsidera Produtos fora do periodo ou ja distribuidos
	If  ((cAliasSDA)->DA_SALDO==0) .Or. (cAliasSDA)->DA_DATA <= dUlMes .Or. (cAliasSDA)->DA_DATA > cDtFech
		dbSkip()
		Loop
	EndIf

	nQuantSDA += (cAliasSDA)->DA_SALDO
	dbSkip()
EndDo

If lQuery
	dbSelectArea(cAliasSDA)
	dbCloseArea()
EndIf

RestArea(aAreaSDA)
RestArea(aAreaAnt)
Return nQuantSDA

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³MR282Lock   ³ Autor ³ Totvs S/A           ³ Data ³ 22.07.11 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Bloqueio de Filial para processamento do relatorio         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nil                                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR282                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function MR282Lock()
Local lRet       := .T.
Local nTentativa := 0
Local cFilProb   := ""

// Variavel de controle de tentativas
nTentativa := 0
// Trava arquivo para somente este usuario utilizar rotina
While !LockByName("MR282"+cEmpAnt+cFilAnt,.T.,.F.,.T.) .And. nTentativa <= 50
	nTentativa++
	Sleep(100)
End
// Tenta travar somente 50 vezes, e se nao conseguir coloca na lista de filiais com concorrencia
If nTentativa > 50
	If Empty(cFilProb)
		cFilProb:=cFilAnt
	Else
		cFilProb+=","+cFilAnt
	EndIf
EndIf

// Nao permite processamento concorrente
If !Empty(cFilProb)
	lRet := .F. 
	Aviso(STR0023,STR0024+" "+cFilProb+" "+STR0025,{"Ok"},2) // ##"Concorrência"##"A filial ## da empresa corrente já esta sendo utilizada na impressão do relatorio."
	Final(STR0023+" - MATR282") // "Concorrencia"
EndIf
Return lRet 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³MR282Lock   ³ Autor ³ Totvs S/A           ³ Data ³ 22.07.11 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Desbloqueio de Filial para processamento do relatorio      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nil                                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR282                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function MR2820UnLock()
// Destrava o bloqueio de filiais
UnLockByName("MR282"+cEmpAnt+cFilAnt,.T.,.F.,.T.)
Return
