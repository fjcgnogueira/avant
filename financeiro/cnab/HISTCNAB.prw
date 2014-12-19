#Include 'Protheus.ch'

User Function HISTCNAB()

Local oDlg      := Nil
Local oTSay1    := Nil
Local oTSay2    := Nil
Local oTSay3    := Nil
Local oTSay4    := Nil
Local oTSay5    := Nil
Local oTSay6    := Nil
Local oTSay7    := Nil
Local oTSay8    := Nil
Local oTSay9    := Nil
Local oTSay10   := Nil
Local oTSay11   := Nil
Local oTSay12   := Nil
Local oFonte1   := Nil
Local oFonte2   := Nil
Local oFolder   := Nil
Local oLayer    := Nil
Local oBrowse   := Nil
Local oMenuBa   := Nil
Local oMenuB1   := Nil
Local oOk       := Nil
Local oNo       := Nil
Local aCabec    := {}
Local aDados    := {}
Local aSpace    := {}

	oOk       := LoadBitmap(GetResources(), 'br_verde'    )
	oNo       := LoadBitmap(GetResources(), 'br_vermelho' )
	oFonte1   := TFont()  :New( , , -12, , .T., , , , , , )
	oFonte2   := TFont()  :New( , , -20, , .T., , , , , , )
	oLayer    := FWLayer():New()
	aCabec    := {'' , 'Titulo Bco', 'Data Ocorrência', 'Cod. Ocorrência', 'Ocorrência', 'Arq. Remessa', 'Arq. Retorno', 'Data Crédito'}
	aSpace    := {020, 030         , 060              , 060              , 120         , 060           , 060           , 060           }
	
	AADD(aDados, {.F., '17379794402507734', '27/08/2012', '004', 'TITULO REJEITADO'      , '2608.REM', '2708.RET', '  /  /    '})
	AADD(aDados, {.F., '17379794402507734', '28/08/2012', '004', 'TITULO REJEITADO'      , '2708.REM', '2808.RET', '  /  /    '})
	AADD(aDados, {.F., '17379794402507734', '29/08/2012', '004', 'TITULO REJEITADO'      , '2808.REM', '2908.RET', '  /  /    '})
	AADD(aDados, {.T., '17379794402507734', '30/08/2012', '002', 'CONFIRMACAO DE ENTRADA', '2908.REM', '3008.RET', '05/09/2012'})
		
	oDlg   := MSDialog():New(180, 180, 580, 700, 'Histórico Retorno Titulo', , , , , CLR_BLACK, CLR_WHITE, , , .T.)
	
		oMenuBa   := TBar():New(oDlg, 035, 040, .T., , , , .F.)
			oMenuB1 := TBtnBmp2():New(002, 002, 026, 026, 'critica', , , , {||oDlg:End()}, oMenuBa, , , .T., )
		
		//INICIALIZA O OBJETO LAYER COM O BOTAO DE FECHAR DESABILITADO.
		oLayer:Init(oDlg, .F.)
		//ADICIONA AS LINHAS DO OBEJETO LAYER.
		oLayer:AddLine('L1', 040, .F.)
		
		//ADICIONA AS COLUNAS DO OBEJETO LAYER.
		oLayer:AddCollumn('C1_L1', 100, .F., 'L1')
		
		//ADICIONA AS JANELAS DO OBJETO LAYER
		oLayer:AddWindow('C1_L1', 'W1_C1_L1', 'INFORMACOES REFERENTE AO TITULO', 100, .F., .F., , 'L1', )
		
		//INICIALIZA CADA JANELA NO SEU RESPECTIVO LUGAR.
		W1_C1_L1   := oLayer:GetWinPanel('C1_L1', 'W1_C1_L1', 'L1')
		
			oTSay1    := TSay():New(005, 005, {|| 'Nr Titulo'} , W1_C1_L1, /*[ cPicture]*/, oFonte1, , , , .T. , /*[ nClrText]*/, /*[ nClrBack]*/, /*[ nWidth]*/,;
								/*[ nHeight]*/, , , , , , .F.)
			oTSay2    := TSay():New(005, 100, {|| 'Parcela'}   , W1_C1_L1, /*[ cPicture]*/, oFonte1, , , , .T. , /*[ nClrText]*/, /*[ nClrBack]*/, /*[ nWidth]*/,;
								/*[ nHeight]*/, , , , , , .F.)
			oTSay3    := TSay():New(005, 180, {|| 'Valor R$'}  , W1_C1_L1, /*[ cPicture]*/, oFonte1, , , , .T. , /*[ nClrText]*/, /*[ nClrBack]*/, /*[ nWidth]*/,;
								/*[ nHeight]*/, , , , , , .F.)														
			oTSay4    := TSay():New(010, 005, {|| '00001423'}  , W1_C1_L1, /*[ cPicture]*/, oFonte2, , , , .T. , 3788455        , /*[ nClrBack]*/, /*[ nWidth]*/,;
								/*[ nHeight]*/, , , , , , .F.)
			oTSay5    := TSay():New(010, 100, {|| '01'}        , W1_C1_L1, /*[ cPicture]*/, oFonte2, , , , .T. , 3788455        , /*[ nClrBack]*/, /*[ nWidth]*/,;
								/*[ nHeight]*/, , , , , , .F.)							
			oTSay6    := TSay():New(010, 180, {|| 'R$ 763,35'} , W1_C1_L1, /*[ cPicture]*/, oFonte2, , , , .T. , 3788455        , /*[ nClrBack]*/, /*[ nWidth]*/,;
								/*[ nHeight]*/, , , , , , .F.)
			oTSay7    := TSay():New(030, 005, {|| 'BANCO'}     , W1_C1_L1, /*[ cPicture]*/, oFonte1, , , , .T. , /*[ nClrText]*/, /*[ nClrBack]*/, /*[ nWidth]*/,;
								/*[ nHeight]*/, , , , , , .F.)
			oTSay8    := TSay():New(030, 100, {|| 'AGENCIA'}   , W1_C1_L1, /*[ cPicture]*/, oFonte1, , , , .T. , /*[ nClrText]*/, /*[ nClrBack]*/, /*[ nWidth]*/,;
								/*[ nHeight]*/, , , , , , .F.)
			oTSay9    := TSay():New(030, 180, {|| 'CONTA'}     , W1_C1_L1, /*[ cPicture]*/, oFonte1, , , , .T. , /*[ nClrText]*/, /*[ nClrBack]*/, /*[ nWidth]*/,;
								/*[ nHeight]*/, , , , , , .F.)
			oTSay10   := TSay():New(035, 005, {|| '5256-ITAU'} , W1_C1_L1, /*[ cPicture]*/, oFonte2, , , , .T. , CLR_RED        , /*[ nClrBack]*/, /*[ nWidth]*/,;
								/*[ nHeight]*/, , , , , , .F.)																							
			oTSay11   := TSay():New(035, 100, {|| '7155'}      , W1_C1_L1, /*[ cPicture]*/, oFonte2, , , , .T. , CLR_RED        , /*[ nClrBack]*/, /*[ nWidth]*/,;
								/*[ nHeight]*/, , , , , , .F.)																							
			oTSay12   := TSay():New(035, 180, {|| '13599-4'}   , W1_C1_L1, /*[ cPicture]*/, oFonte2, , , , .T. , CLR_RED        , /*[ nClrBack]*/, /*[ nWidth]*/,;
								/*[ nHeight]*/, , , , , , .F.)																																																																							
																																						
		oFolder   := TFolder():New(095, 005, {'MOTIVOS CNAB'},, oDlg, , ,16777215 , .T., , 253, 100, , )
			oBrowse   := TWBrowse():New(005 , 005, 240, 077, , aCabec, aSpace, oFolder:aDialogs[1], , , , , {||}, , , , , , , .F. , , .T., , .F., , .T., .T.)
				oBrowse:SetArray(aDados)
				oBrowse:bLine   := {||{IIF(aDados[oBrowse:nAt][1], oOk, oNo), aDados[oBrowse:nAt][2], aDados[oBrowse:nAt][3], aDados[oBrowse:nAt][4],;
										aDados[oBrowse:nAt][5], aDados[oBrowse:nAt][6], aDados[oBrowse:nAt][7], aDados[oBrowse:nAt][8] } }
				// Troca a imagem no duplo click do mouse
				//oBrowse:bLDblClick   := {|| aDados[oBrowse:nAt][1] := !aDados[oBrowse:nAt][1], oBrowse:DrawSelect()}
				
	//DBSELECTAREA('SEB')

	oDlg:Activate()

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ FMAHEADER³ Autor ³ Thiago S. Joaquim     ³ Data ³ 25/06/2012 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Locacao   ³    DANNY         ³Contato ³ thiago.joaquim@totvs.com.br      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Monta o Cabecalho da Get Dados.                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ cAliasG.                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ aCab.                                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Aplicacao ³ Controle de Produtos em Poder de Terceiros.                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Generico.                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Analista Resp.³  Data  ³ Bops ³ Manutencao Efetuada                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³              ³  /  /  ³      ³                                          ³±±
±±³              ³  /  /  ³      ³                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function FMAHEADER(cAliasG)

Local aArea    := {} //ARRAY QUE VAI RECEBER O ESTADO ATUAL DAS TABELAS UTILIZADAS.
Local aCab     := {} //ARRAY DO CABECALHO DE ITENS. [Cod][Descricao][Tipo][Preco Unitario][...]

	//GARANTE QUE AS TABELAS UTILIZADAS RETORNEM AO SEU ESTADO IMEDIATAMENTE ANTERIOR AO TERMINO DE SUA UTILIZACAO.
	aArea := GetArea()

	DBSelectArea("SX3") //SELECIONAMOS A TABELA DESEJADA.
		SX3->(DBSetOrder(1)) //ORDENAMOS PELO INDICE DESEJADO.
		SX3->(DBGoTop()) //MOVEMOS O PONTEIRO PARA O PRIMERIO REGISTRO DA TABELA.
		SX3->(DBSeek(cAliasG)) //PROCURAMOS PELO REGISTRO DESEJADO.
	
	//ENQUANTO NAO FOR O FINAL DO ARQUIVO 'E' O CAMPO PERTENCER A TABELA DESEJADA...
	While (SX3->(!EOF()) .AND. SX3->X3_ARQUIVO == cAliasG)

		//SE O CAMPO E UTILIZADO E O NIVEL DE ACESSO DO USUARIO E MAIOR QUE O NIVEL DE ACESSO DO CAMPO...
		If X3USO(SX3->X3_USADO) .AND. (cNivel >= SX3->X3_NIVEL)
		
       		//ADICIONAMOS AO ARRAY DO CABECALHO OS CAMPOS DESEJADOS.
			AADD(aCab, {TRIM(SX3->X3_TITULO),; //--- TITULO DO CAMPO.
						SX3->X3_CAMPO,; //---------------------- NOME DO CAMPO.
						SX3->X3_PICTURE,; //-------------------- MASCARA DO CAMPO.
						SX3->X3_TAMANHO,; //-------------------- TAMANHO DO CAMPO.
						SX3->X3_DECIMAL,; //-------------------- DECIMAL DO CAMPO.
						SX3->X3_VALID,; //---------------------- VALIDACAO DO CAMPO.
				 		SX3->X3_USADO,; //---------------------- SE O CAMPO E USADO OU NAO.
						SX3->X3_TIPO,; //----------------------- TIPO DE DADOS DO CAMPO.
						SX3->X3_ARQUIVO,; //-------------------- TABELA A QUE PERTENCE O CAMPO.
						SX3->X3_CONTEXT}) //-------------------- SE O CAMPO E VIRTUAL OU NAO.

		EndIf

		//PULAMOS PARA O PROXIMO REGISTRO.
		SX3->(DBSKIP()) 

	EndDo

	//AO TERMINO DA UTILIZACAO DA TABELA LIBERAMOS SUA AREA DE TRABALHO.
	SX3->(DBCloseArea())

	//RETORNA AS TABELAS UTILIZADAS AO SEU ESTADO IMEDIATAMENTE ANTERIOR AO TERMINO DE SUA UTILIZACAO.
	RestArea(aArea)

Return aCab //RETORNA O ARRAY COM OS ITENS DO CABECALHO.