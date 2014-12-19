#INCLUDE "TMKR039.CH"
#INCLUDE "REPORT.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ TMKR039  ³ Autor ³ Vendas Clientes       ³ Data ³ 20/03/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Ligacoes realizadas no atendimento de Televendas com o tipo³±±
±±³          ³ atendimento.                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Televendas (SUA)                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function CALLCENTER()
Local oReport					// Objeto Report
Local aArea := GetArea()		// Salva a area

If !FindFunction("TRepInUse") .OR. !TRepInUse()

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Executa versao anterior do fonte³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	U_TMKR039R3()
Else
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Variaveis utilizadas para parametros                          ³
	//³ Mv_Par01           // Do Operador                             ³
	//³ Mv_Par02           // Ate o Operador                          ³
	//³ Mv_Par03           // A Partir de                             ³
	//³ Mv_Par04           // Ate o dia                               ³
	//³ Mv_Par05           // Da Midia                                ³
	//³ Mv_Par06           // Ate a Midia                             ³
	//³ Mv_Par07           // Campanha         - Vazio entra tudo     ³
	//³ Mv_Par08           // Tipo da Entidade - SA1, SUS ou TODAS    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Pergunte("TMK039",.F.)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Interface de impressao³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ                       
	oReport := Tkr039RptDef()
	oReport:PrintDialog()
EndIf

RestArea( aArea )
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ TMKR039  ³ Autor ³ Vendas Clientes       ³ Data ³ 20/03/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Ligacoes realizadas no atendimento de Televendas com o tipo³±±
±±³          ³ atendimento.                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Televendas (SUA)                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function TMKR039R3()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local wnrel   	:= "TMKR039"  	 		// Nome do Arquivo utilizado no Spool
Local Titulo 	:= "Ligacoes Realizadas e Recebidas - Televendas"	// "Ligacoes Realizadas e Recebidas - Televendas"
Local cDesc1 	:= "Este programa ira emitir uma relacao das ligacoes realizadas pelo operador no atendimento Televendas."				// "Este programa ira emitir uma relacao das ligacoes realizadas pelo operador no atendimento Televendas."
Local cDesc2 	:= "Apenas as ligacoes registradas como ATENDIMENTO serao emitidas neste relatorio."				// "Apenas as ligacoes registradas como ATENDIMENTO serao emitidas neste relatorio."
Local cDesc3 	:= "Os dados serao emitidos conforme os parametros informados."				// "Os dados serao emitidos conforme os parametros informados."
Local nomeprog	:= "TMKR039.PRX"		// nome do programa
Local cString 	:= "SUA"				// Alias utilizado na Filtragem
Local lDic    	:= .F. 					// Habilita/Desabilita Dicionario
Local lComp   	:= .F. 					// Habilita/Desabilita o Formato Comprimido/Expandido
Local lFiltro 	:= .T. 					// Habilita/Desabilita o Filtro

Private Tamanho := "G" 					// P/M/G
Private Limite  := 220 					// 80/132/220
Private aReturn := { "Zebrado",;			// [1] Reservado para Formulario	//"Zebrado"
					 1,;				// [2] Reservado para N§ de Vias
					 "Administracao",;			// [3] Destinatario					//"Administracao"
					 2,;				// [4] Formato => 1-Comprimido 2-Normal	
					 2,;	    		// [5] Midia   => 1-Disco 2-Impressora
					 1,;				// [6] Porta ou Arquivo 1-LPT1... 4-COM1...
					 "",;				// [7] Expressao do Filtro
					 1 } 				// [8] Ordem a ser selecionada
					 					// [9]..[10]..[n] Campos a Processar (se houver)
Private m_pag   := 1  				 	// Contador de Paginas
Private nLastKey:= 0  				 	// Controla o cancelamento da SetPrint e SetDefault
Private cPerg   := "TMK039"  		 	// Pergunta do Relatorio
Private aOrdem  := {}  				 	// Ordem do Relatorio

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Pergunte(cPerg,.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                          ³
//³ Mv_Par01           // Do Operador                             ³
//³ Mv_Par02           // Ate o Operador                          ³
//³ Mv_Par03           // A Partir de                             ³
//³ Mv_Par04           // Ate o dia                               ³
//³ Mv_Par05           // Da Midia                                ³
//³ Mv_Par06           // Ate a Midia                             ³
//³ Mv_Par07           // Campanha         - Vazio entra tudo     ³
//³ Mv_Par08           // Tipo da Entidade - SA1, SUS ou TODAS    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel:=SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,lDic,aOrdem,lComp,Tamanho,lFiltro)

If (nLastKey == 27)
	DbSelectArea(cString)
	DbSetOrder(1)
	DbClearFilter()
	Return
Endif

SetDefault(aReturn,cString)

If (nLastKey == 27)
	DbSelectArea(cString)
	DbSetOrder(1)
	DbClearFilter()
	Return
Endif

RptStatus({|lEnd| TK039Imp(@lEnd,wnRel,cString,nomeprog,Titulo)},Titulo)

Return(.T.)


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ TK039Imp ³ Autor ³ Vendas Clientes       ³ Data ³ 20/03/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Atendimentos realizados no Televendas                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Televendas                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function TK039Imp(lEnd,wnrel,cString,nomeprog,Titulo)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para Impressao Do Cabecalho e Rodape    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local nLi		:= 0			// Linha a ser impressa
Local nMax		:= 58			// Maximo de linhas suportada pelo relatorio
Local cbCont	:= 0			// Numero de Registros Processados
Local cbText	:= SPACE(10)	// Mensagem do Rodape
Local cCabec1	:= "" 			// Label dos itens
Local cCabec2	:= "" 			// Label dos itens

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Declaracao de variaveis especificas para este relatorio³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cCodSUA		:= ""						// Controla a quebra do cabecalho do atendimento
Local nI			:= 0						// Controle
Local nPos			:= 0						// Ponteiro da pesquisa no array
Local cSUA			:= "SUA"					// Gerencia a troca do alias para top e dbf
Local cSUB			:= "SUB"					// Gerencia a troca do alias para top e dbf
Local cSB1			:= "SB1"					// Gerencia a troca do alias para top e dbf
Local aUA_Oper		:= TkSx3Box("UA_OPER")		// Pesquisa as opcoes do campo no DD SX3
Local aUA_TMK		:= TkSx3Box("UA_TMK")		// Pesquisa as opcoes do campo no DD SX3
Local aUA_TpFrete	:= TkSx3Box("UA_TPFRETE")	// Pesquisa as opcoes do campo no DD SX3
Local nTotGer		:= 0						// Total dos atendimentos
Local aTotItem		:= {0,0,0,0}				// Total dos itens por atendimento
Local aTotOper		:= {}					    // Total por tipo de Operacao
Local aTotCamp		:= {}						// Total geral das campanhas
Local aTotMid		:= {}						// Total geral das midias
Local aValOper		:= {}						// Total Orcados/Faturados por operador
Local aDatOper		:= {}						// Total por data e por operador
Local aDatMid		:= {}						// Total por data e por midia
Local aDatCamp		:= {}						// Total por data e por campanha
Local cData			:= ""						// Para quebra de relatorio
Local lAtend		:= .T.						// Variavel de auxilio que informa quando e um novo atendimento
Local lPula			:= .F.						// Variavel de auxilio
Local nLen			:= 0						// Variavel de auxilio

#IFDEF TOP
	Local aSetField		:= {}					// Parametros para SetField do alias principal
	Local cCampos		:= ""					// Campos do alias principal para select
	Local cQuery		:= "%%"					// Armazena a expressao da query para top
#ENDIF

DbSelectArea((cSUA))
DbSetOrder(4)
SetRegua(RecCount())

#IFDEF TOP
	
	TkSelect(cString, @cCampos, @aSetField)
	
	cQuery :=	" SELECT	" + cCampos                
	
	cQuery +=	" FROM " +	RetSqlName((cSUA)) + " SUA "

	cQuery +=	" WHERE	SUA.UA_FILIAL = '" + xFilial((cSUA)) + "' AND " +;
				" 		SUA.UA_EMISSAO BETWEEN '" + DtoS(Mv_Par03) + "' AND '" + DtoS(Mv_Par04) + "' AND" +;
				" 		SUA.UA_OPERADO BETWEEN '" + Mv_Par01 + "' AND '" + Mv_Par02 + "' AND" +;
				" 		SUA.UA_MIDIA BETWEEN '" + Mv_Par05 + "' AND '" + Mv_Par06 + "' AND" +;
				" 		SUA.UA_CANC = '' AND" +;
				" 		SUA.UA_OPER = '3' AND "	// Atendimento

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Seleciono somente a campanha informada nos parametros³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !Empty(Mv_Par07)
		cQuery +=	" 	SUA.UA_CODCAMP = '" + Mv_Par07 + "' AND"
	Endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Seleciono somente o tipo de entidade dos parametros³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If Mv_Par08 <> 3		// Ambos
		If Mv_Par08 == 1	// Clientes
			cQuery +=	" 	SUA.UA_PROSPEC = 'F' AND"
		Else				// Prospects
			cQuery +=	" 	SUA.UA_PROSPEC = 'T' AND"
		Endif
	Endif
	
	cQuery +=	"	SUA.D_E_L_E_T_ = ' '"
	
	cQuery +=	" ORDER BY " + SqlOrder(IndexKey())
	
	DbSelectArea((cSUA))
	DbCloseArea()
	cQuery	:= ChangeQuery(cQuery)
	// MemoWrite("TMKR039.SQL", cQuery)
	DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'SUA', .F., .T.)
	
	nLen := Len(aSetField)
	For nI := 1 To nLen	
		If aSetField[nI][2] $ "NDL"
			TCSetField(cString, aSetField[nI][1], aSetField[nI][2], aSetField[nI][3], aSetField[nI][4])
		Endif
	Next nI
	
#ELSE
	DbSeek(xFilial((cSUA)) + DtoS(Mv_Par03), .T.)
#ENDIF

While	(!Eof())							.AND.;
		SUA->UA_FILIAL == xFilial((cSUA))	.AND.;
		SUA->UA_EMISSAO >=	Mv_Par03		.AND.;
		SUA->UA_EMISSAO <=	Mv_Par04
	
	IncRegua()
	
	If lEnd
		@Prow()+1,001 PSay "CANCELADO PELO OPERADOR" //"CANCELADO PELO OPERADOR"
		Exit
	Endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Considera filtro do usuario                                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If (!Empty(aReturn[7])) .AND. (!&(aReturn[7]))
		DbSkip()
		Loop
	Endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Avalia os parametros para DBF³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	#IFNDEF TOP
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Valida o intervalo de operadores informado nos parametros³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If (cSUA)->UA_OPERADO < Mv_Par01 .OR. (cSUA)->UA_OPERADO > Mv_Par02
			DbSkip()
			Loop
		Endif
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Valida o intervalo de midias informado nos parametros³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If (cSUA)->UA_MIDIA < Mv_Par05 .OR. (cSUA)->UA_MIDIA > Mv_Par06
			DbSkip()
			Loop
		Endif
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Seleciono somente a campanha informada nos parametros³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !Empty(Mv_Par07) .AND. (cSUA)->UA_CODCAMP <> Mv_Par07
			DbSkip()
			Loop
		Endif
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Seleciono somente o tipo de entidade dos parametros³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		Do Case
			// Se o parametro = cliente e atendimento = prospect  <<pula>>
			Case Mv_Par08 == 1 .AND. (cSUA)->UA_PROSPEC
				DbSkip()
				Loop
			// Se o parametro = prospect e atendimento <> prospect  <<pula>>
			Case Mv_Par08 == 2 .AND. !(cSUA)->UA_PROSPEC
				DbSkip()
				Loop
		EndCase

		If (cSUA)->UA_CANC == "S"
			DbSkip()
			Loop
		Endif
		
		If VAL(SUA->UA_OPER) <> ATENDIMENTO
			DbSkip()
			Loop
		Endif
		
	#ENDIF
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Se mudou o registro de atendimento , totaliza os contadores e imprime o novo cabecalho³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If (cSUA)->UA_NUM <> cCodSUA
		cCodSUA := (cSUA)->UA_NUM

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Imprime o Cabecalho padrao e retorna a posicao da linha.   ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        aCampos	:= {"UA_EMISSAO"	,"UA_CODCONT"	,"UA_NUM"		,;
        			"U5_FCOM1"		,"UA_OPERADO"   ,"U5_EMAIL"		,;
        			"UA_VEND"		,"AC8_ENTIDA"	,"UA_MIDIA"		,;
        			"A1_TEL"		,"UA_CODCAMP"	,"A1_END"		,;
        			"UA_CODLIG" 	,"A1_BAIRRO"	,"UA_TABELA"	,;
					"A1_MUN"		,"UA_OPER"		,"A1_EST"		,;
					"UA_TMK"		,"UA_TPFRETE"	,"UC_PENDENT"	,;
					"UA_OBS"										}

        aDescCab:= TkTitX3(aCampos)
        
		nLi		:= TkCabecPad(	"SUA"		,aDescCab		,nLi		,;
								nMax		,titulo			,cCabec1	,;
								cCabec2		,nomeprog	 	,tamanho	,;
								Nil			,Nil			,Nil		,;  // Caracteristicas especificas para o TMK
								aUA_Oper	,aUA_TMK		,aUA_TpFrete)	// Caracteristicas especificas para o TLV						 	

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Linha com os titulos das colunas.								   ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		TkIncLine(@nLi,1,nMax,titulo,cCabec1,cCabec2,nomeprog,tamanho)
		@ nLi,000 PSay PadR("Item", 4) //"Item"
		@ nLi,PCol()+1	PSay PadR("Produto",TamSX3("UB_PRODUTO")[1]) //"Produto"
		@ nLi,PCol()+1	PSay PadR("Descricao",TamSX3("B1_DESC")[1])//"Descricao"
		@ nLi,PCol()+1	PSay PadR("St",TamSX3("UB_SITPROD")[1])//"St"
		@ nLi,PCol()+1	PSay PadR("Qtdade",8)//"Qtdade"
		@ nLi,PCol()+1	PSay PadR("Vl.Unitario",14)//"Vl.Unitario"
		@ nLi,PCol()+1	PSay PadR("Vl.Item",14)//"Vl.Item"
		@ nLi,PCol()+1	PSay PadR("%Desc",6)//"%Desc"
		@ nLi,PCol()+1	PSay PadR("Vl.Desconto",14)//"Vl.Desconto"
		@ nLi,PCol()+1	PSay PadR("%Acres",6)//"%Acres"
		@ nLi,PCol()+1	PSay PadR("Vl.Acrescimo",14)//"Vl.Acrescimo"
		@ nLi,PCol()+1	PSay PadR("TES",TamSX3("UB_TES")[1])//"TES"
		@ nLi,PCol()+1	PSay PadR("CFOP",TamSX3("UB_CF")[1])//"CFOP"
		@ nLi,PCol()+1	PSay PadR("Tabela",10)//"Tabela"
		@ nLi,PCol()+1	PSay PadR("Base ICMS",14)//"Base ICMS"
		@ nLi,PCol()+1	PSay PadR("LP",TamSX3("UB_LOCAL")[1])//"LP"
		@ nLi,PCol()+1	PSay PadR("UM",TamSX3("UB_UM")[1])//"UM"
		@ nLi,PCol()+1	PSay PadR("Entrega",TamSX3("UB_DTENTRE")[1])//"Entrega"
		@ nLi,U_TKR039VerifPos(@nLi, "UB_LOTE")	PSay PadR("Lote",TamSX3("UB_LOTE")[1])//"Lote"
		@ nLi,U_TKR039VerifPos(@nLi, "UB_SUBLOTE")	PSay PadR("Sub-Lt",TamSX3("UB_SUBLOTE")[1])//"Sub-Lt"
		@ nLi,U_TKR039VerifPos(@nLi, "UB_DTVALID")	PSay PadR("Validade",TamSX3("UB_DTVALID")[1])//"Validade"
		
		TkIncLine(@nLi,1,nMax,titulo,cCabec1,cCabec2,nomeprog,tamanho)
		@ nLi,000 PSay __PrtThinLine()
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Total geral dos atendimentos.                                       ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nTotGer++

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Total dos atendimentos por Campanha.  							   ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nPos := aScan(aTotCamp, {|x| x[1]==(cSUA)->UA_CODCAMP} )
		If nPos == 0
			aAdd(aTotCamp,{ (cSUA)->UA_CODCAMP												,;	// Codigo da campanha
							Posicione("SUO",1,xFilial("SUO")+(cSUA)->UA_CODCAMP,"UO_DESC")	,;	// Descricao da campanha
			 				1																})	// Totalizador
		Else
			aTotCamp[nPos][3]++
		Endif

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Total dos atendimentos por Midia.  							       ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nPos := aScan(aTotMid, {|x| x[1]==(cSUA)->UA_MIDIA} )
		If nPos == 0
			aAdd(aTotMid, {(cSUA)->UA_MIDIA													,;	// Tipo da midia	
							Posicione("SUH",1,xFilial("SUH")+(cSUA)->UA_MIDIA,"UH_DESC")	,;	// Descricao da midia			
			 				1																})	// Totalizador				
		Else
			aTotMid[nPos][3]++
		Endif
		
	Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Impressao dos itens do atendimento do Televendas.				   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	lAtend := .T. // Informa quando e um novo atendimento
	    
	DbSelectArea((cSUB))
	DbSetOrder(1)
	DbSeek(xFilial(cSUB) + (cSUA)->UA_NUM)
	While	(!Eof())								.AND.;
			(cSUB)->UB_FILIAL	==	xFilial((cSUB))	.AND.;
			(cSUB)->UB_NUM		==	(cSUA)->UA_NUM
	
		TkIncLine(@nLi,1,nMax,titulo,cCabec1,cCabec2,nomeprog,tamanho)
		@ nLi,000		PSay PadR((cSUB)->UB_ITEM,4)
		@ nLi,PCol()+1	PSay PadR((cSUB)->UB_PRODUTO,TamSX3("UB_PRODUTO")[1])
		@ nLi,PCol()+1	PSay PadR(Posicione("SB1",1,xFilial("SB1")+(cSUB)->UB_PRODUTO,"B1_DESC"),30)  
		@ nLi,PCol()+1	PSay PadR((cSUB)->UB_SITPROD,TamSX3("UB_SITPROD")[1])
		@ nLi,PCol()+1	PSay PadR(AllTrim(Transform((cSUB)->UB_QUANT, '@E 99999.99')),8)
		@ nLi,PCol()+1	PSay PadR(AllTrim(Transform((cSUB)->UB_VRUNIT, '@E 999,999,999.99')),14)
		@ nLi,PCol()+1	PSay PadR(AllTrim(Transform((cSUB)->UB_VLRITEM, '@E 999,999,999.99')),14)
		@ nLi,PCol()+1	PSay PadR(AllTrim(Transform((cSUB)->UB_DESC, '@E 999.99')),6)
		@ nLi,PCol()+1	PSay PadR(AllTrim(Transform((cSUB)->UB_VALDESC, '@E 999,999,999.99')),14)
		@ nLi,PCol()+1	PSay PadR(AllTrim(Transform((cSUB)->UB_ACRE, '@E 999.99')),6)
		@ nLi,PCol()+1	PSay PadR(AllTrim(Transform((cSUB)->UB_VALACRE, '@E 999,999,999.99')),14)
		@ nLi,PCol()+1	PSay PadR((cSUB)->UB_TES,TamSX3("UB_TES")[1])
		@ nLi,PCol()+1	PSay PadR((cSUB)->UB_CF,TamSX3("UB_CF")[1])
		@ nLi,PCol()+1	PSay PadR(AllTrim(Transform((cSUB)->UB_PRCTAB, '@E 999,999.99')),10)
		@ nLi,PCol()+1	PSay PadR(AllTrim(Transform((cSUB)->UB_BASEICM, '@E 999,999,999.99')),14)
		@ nLi,PCol()+1	PSay PadR((cSUB)->UB_LOCAL,TamSX3("UB_LOCAL")[1])
		@ nLi,PCol()+1	PSay PadR((cSUB)->UB_UM,TamSX3("UB_UM")[1])
		@ nLi,PCol()+1	PSay PadR((cSUB)->UB_DTENTRE,TamSX3("UB_DTENTRE")[1])
		@ nLi,U_TKR039VerifPos(@nLi, "UB_LOTE")	PSay PadR((cSUB)->UB_LOTE,TamSX3("UB_LOTE")[1])
		@ nLi,U_TKR039VerifPos(@nLi, "UB_SUBLOTE")	PSay PadR((cSUB)->UB_SUBLOTE,TamSX3("UB_SUBLOTE")[1])
		@ nLi,U_TKR039VerifPos(@nLi, "UB_DTVALID")	PSay PadR((cSUB)->UB_DTVALID,TamSX3("UB_DTVALID")[1])

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Totalizacao dos itens por atendimento.                              ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		aAdd(aTotItem, {aTotItem[1]	+=(cSUB)->UB_QUANT			,;	// Quantidade
						aTotItem[2]	+=(cSUB)->UB_VLRITEM		,;	// Valor por Item					
						aTotItem[3]	+=(cSUB)->UB_VALDESC		,;	// Valor do Desconto					
						aTotItem[4]	+=(cSUB)->UB_VALACRE		})	// Valor do Acrescimo

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Total em dinheiro por Atendimento.                                  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nPos := aScan(aTotOper, {|x| x[1]==(cSUA)->UA_OPER} )
		If nPos == 0                                  
			If	(cSUA)->UA_OPER == "3"	// Atendimento   
				aAdd(aTotOper,	 {(cSUA)->UA_OPER		,;	// Tipo de Operacao     
								 1						,;	// Total de Atendimentos
								 (cSUB)->UB_VLRITEM		}) 	// Total por Operacao
			Endif								 
		Else
			If lAtend
				aTotOper[nPos][2]++
			Endif	
			aTotOper[nPos][3]+= (cSUB)->UB_VLRITEM
		Endif

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Total em dinheiro por Operador e por Tipo de Operacao.              ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nPos := aScan(aValOper, {|x| x[1]==(cSUA)->UA_OPERADO} )
		If nPos == 0
			If	(cSUA)->UA_OPER == "3"	// Atendimento
				aAdd(aValOper, 	{(cSUA)->UA_OPERADO												,;	// Codigo do Operador
								Posicione("SU7",1,xFilial("SU7")+(cSUA)->UA_OPERADO	,"U7_NOME")	,;	// Descricao do operador
								1																})	// Total de Atendimentos
			Endif
		Else
			If lAtend
				aValOper[nPos][3]++
			Endif	
		Endif
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Total de orcamento e faturamento por data e por operador.           ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nPos := aScan(aDatOper, {|x,y| x[1]==DtoS((cSUA)->UA_EMISSAO) .AND. x[2]==(cSUA)->UA_OPERADO} )
		If nPos == 0
			If	(cSUA)->UA_OPER == "3"	// Atendimento
				aAdd(aDatOper,	{DtoS((cSUA)->UA_EMISSAO)										,;	// Data do Atendimento
                   	    		(cSUA)->UA_OPERADO												,;	// Codigo do operador
								Posicione("SU7",1,xFilial("SU7")+(cSUA)->UA_OPERADO	,"U7_NOME")	,;	// Descricao do operador
								1																})	// Total de Atendimentos
			Endif					
		Else
			If lAtend
				aDatOper[nPos][4]++
			Endif	
		Endif
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Total de orcamento e faturamento por data e por midia.              ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nPos := aScan(aDatMid, {|x,y| x[1]==DtoS((cSUA)->UA_EMISSAO) .AND. x[2]==(cSUA)->UA_MIDIA} )
		If nPos == 0
			If	(cSUA)->UA_OPER == "3"	// Atendimento
				aAdd(aDatMid,	{DtoS((cSUA)->UA_EMISSAO)										,;	// Data do Atendimento
                   	    		(cSUA)->UA_MIDIA												,;	// Codigo da midia
								Posicione("SUH",1,xFilial("SUH")+(cSUA)->UA_MIDIA,"UH_DESC")	,;	// Descricao da midia			
								1																})	// Total de Atendimentos
			Endif					
		Else
			If lAtend
				aDatMid[nPos][4]++
			Endif	
		Endif

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Total de orcamento e faturamento por data e por campanha.           ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nPos := aScan(aDatCamp, {|x,y| x[1]==DtoS((cSUA)->UA_EMISSAO) .AND. x[2]==(cSUA)->UA_CODCAMP} )
		If nPos == 0
			If	(cSUA)->UA_OPER == "3"	// Atendimento
				aAdd(aDatCamp,	{DtoS((cSUA)->UA_EMISSAO)										,;	// Data do Atendimento
								(cSUA)->UA_CODCAMP												,;	// Codigo da campanha
								Posicione("SUO",1,xFilial("SUO")+(cSUA)->UA_CODCAMP,"UO_DESC")	,;	// Descricao da campanha
								1																})	// Total de Atendimentos
			Endif					
		Else
			If lAtend
				aDatCamp[nPos][4]++
			Endif					
		Endif
		
		DbSelectArea(cSUB)
		DbSkip()
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Imprime os totais dos Itens por Atendimento.                        ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ			
		If (cSUB)->UB_NUM <> (cSUA)->UA_NUM
			TkIncLine(@nLi,2,nMax,titulo,cCabec1,cCabec2,nomeprog,tamanho)
			@ nLi,000		PSay PadR("TOTAL",51) // "TOTAL"
			@ nLi,55		PSay PadR(Transform(aTotItem[1], '@E 99999.99'),8)
			@ nLi,79   		PSay PadR(Transform(aTotItem[2], '@E 999,999,999.99'),14)
			@ nLi,101		PSay PadR(Transform(aTotItem[3], '@E 999,999,999.99'),14)
			@ nLi,124		PSay PadR(Transform(aTotItem[4], '@E 999,999,999.99'),14)
			aTotItem := {0,0,0,0}
		Endif

		lAtend := .F.
		
	End
	
	DbSelectArea(cSUA)
	DbSkip()
End

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Imprime as totalizacoes do periodo. 								   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If nTotGer > 0

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Total dos atendimentos. 								           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	TkIncLine(@nLi,nMax+1,nMax,titulo,cCabec1,cCabec2,nomeprog,tamanho)
	@ nLi,00		PSay "Total de atendimentos computados para o periodo de " + DtoC(Mv_Par03) + " a " + DtoC(Mv_Par04)	// "Total de atendimentos computados para o periodo de ",  " a "
	@ nLi,PCol()+3	PSay Transform(nTotGer,'@E 999,999')

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Total por operacao.											   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aSort(aTotOper,,, {|x,y| x[3] > y[3]} )		// Coloca em ordem decrescente
	
	TkIncLine(@nLi,3,nMax,titulo,cCabec1,cCabec2,nomeprog,tamanho)
	@ nLi,00		PSay "OPERACAO"   // "OPERACAO"                                          ATENDIMENTOS   VALOR NEGOCIADO"
	TkIncLine(@nLi,1,nMax,titulo,cCabec1,cCabec2,nomeprog,tamanho)      
	@ nLi,00		PSay __PrtThinLine()                           
	
	nLen := Len(aTotOper)
	For nI := 1 To nLen
	
		// Trata quebra de pagina
		If @nLi >= 56
			TkIncLine(@nLi,nMax+1,nMax,titulo,cCabec1,cCabec2,nomeprog,tamanho)			
			TkIncLine(@nLi,3,nMax,titulo,cCabec1,cCabec2,nomeprog,tamanho)								
			@ nLi,00			PSay "OPERECAO" // "OPERECAO                                          ATENDIMENTOS    VALOR NEGOCIADO"
		    TkIncLine(@nLi,1,nMax,titulo,cCabec1,cCabec2,nomeprog,tamanho)
			@ nLi,00			PSay __PrtThinLine()
		Endif		
	
		TkIncLine(@nLi,1,nMax,titulo,cCabec1,cCabec2,nomeprog,tamanho)
		@ nLi,000      		PSay PadR(aUA_Oper[Val(aTotOper[nI][1])],49) 			// Tipo de Operacao
		@ nLi,Pcol()+6		PSay Transform(aTotOper[nI][2],'@E 999,999')			// Total de Atendimentos
		@ nLi,PCol()+4		PSay Transform(aTotOper[nI][3],'@E 999,999,999.99')		// Total por Operacao

    Next nI

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Total por Operador e por Tipo de Operacao.                      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ			
	aSort(aValOper,,, {|x,y| x[3] > y[3]} )		// Coloca em ordem decrescente  
	
	TkIncLine(@nLi,3,nMax,titulo,cCabec1,cCabec2,nomeprog,tamanho)
	@ nLi,00		PSay "OPERADOR                                          ATENDIMENTOS" // "OPERADOR                                          ATENDIMENTOS"
	TkIncLine(@nLi,1,nMax,titulo,cCabec1,cCabec2,nomeprog,tamanho)
	@ nLi,00		PSay __PrtThinLine()                           

	nLen :=	Len(aValOper)
	For nI := 1 To nLen
	
		// Trata quebra de pagina
		If @nLi >= 56
			TkIncLine(@nLi,nMax+1,nMax,titulo,cCabec1,cCabec2,nomeprog,tamanho)			
			TkIncLine(@nLi,3,nMax,titulo,cCabec1,cCabec2,nomeprog,tamanho)								
			@ nLi,00			PSay  "OPERADOR                                          ATENDIMENTOS" // "OPERADOR                                          ATENDIMENTOS"
		    TkIncLine(@nLi,1,nMax,titulo,cCabec1,cCabec2,nomeprog,tamanho)
			@ nLi,00			PSay __PrtThinLine()
		Endif		
	
		TkIncLine(@nLi,1,nMax,titulo,cCabec1,cCabec2,nomeprog,tamanho)
		@ nLi,000			PSay PadR(aValOper[nI][1],6)+ " - " + PadR(aValOper[nI][2],40) 	// Descricao do operador
		@ nLi,PCol()+6		PSay Transform(aValOper[nI][3],'@E 999,999')						// Total de Atendimentos		

	Next nI

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Total por midia.  											   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ			
	aSort(aTotMid,,, {|x,y| x[3] > y[3]} )		// Coloca em ordem decrescente  
	
	TkIncLine(@nLi,3,nMax,titulo,cCabec1,cCabec2,nomeprog,tamanho)
	@ nLi,00		PSay "MIDIA                                             ATENDIMENTOS                 %" // "MIDIA                                             ATENDIMENTOS                 %"
	TkIncLine(@nLi,1,nMax,titulo,cCabec1,cCabec2,nomeprog,tamanho)      
	@ nLi,00		PSay __PrtThinLine()                           

	nLen := Len(aTotMid)
	For nI := 1 To nLen
	
		// Trata quebra de pagina
		If @nLi >= 56
			TkIncLine(@nLi,nMax+1,nMax,titulo,cCabec1,cCabec2,nomeprog,tamanho)			
			TkIncLine(@nLi,3,nMax,titulo,cCabec1,cCabec2,nomeprog,tamanho)								
			@ nLi,00			PSay  "MIDIA                                             ATENDIMENTOS                 %" // "MIDIA                                             ATENDIMENTOS                 %"
		    TkIncLine(@nLi,1,nMax,titulo,cCabec1,cCabec2,nomeprog,tamanho)
			@ nLi,00			PSay __PrtThinLine()
		Endif
	
		TkIncLine(@nLi,1,nMax,titulo,cCabec1,cCabec2,nomeprog,tamanho)
		@ nLi,000			PSay PadR(aTotMid[nI][1],6)+ " - " + PadR(aTotMid[nI][2],40) 	// Descricao da campanha
		@ nLi,PCol()+6		PSay Transform(aTotMid[nI][3],'@E 999,999')						// Total de Atendimentos
		@ nLi,PCol()+12		PSay Transform((aTotMid[nI][3]/nTotGer)*100, '@E 999.99') 		// Porcentagem

	Next nI

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Total por campanha.											   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ			
	aSort(aTotCamp,,, {|x,y| x[3] > y[3]} )		// Coloca em ordem decrescente  
	
	TkIncLine(@nLi,3,nMax,titulo,cCabec1,cCabec2,nomeprog,tamanho)
	@ nLi,00		PSay "CAMPANHA                                          ATENDIMENTOS                 %" // "CAMPANHA                                          ATENDIMENTOS                 %"
	TkIncLine(@nLi,1,nMax,titulo,cCabec1,cCabec2,nomeprog,tamanho)      
	@ nLi,00		PSay __PrtThinLine()                           

	nLen := Len(aTotCamp)
	For nI := 1 To nLen
	
		// Trata quebra de pagina
		If @nLi >= 56
			TkIncLine(@nLi,nMax+1,nMax,titulo,cCabec1,cCabec2,nomeprog,tamanho)			
			TkIncLine(@nLi,3,nMax,titulo,cCabec1,cCabec2,nomeprog,tamanho)								
			@ nLi,00			PSay "CAMPANHA                                          ATENDIMENTOS                 %" // "CAMPANHA                                          ATENDIMENTOS                 %"
		    TkIncLine(@nLi,1,nMax,titulo,cCabec1,cCabec2,nomeprog,tamanho)
			@ nLi,00			PSay __PrtThinLine()
		Endif		
	
		TkIncLine(@nLi,1,nMax,titulo,cCabec1,cCabec2,nomeprog,tamanho)
		@ nLi,000			PSay PadR(aTotCamp[nI][1],6)+ " - " + PadR(aTotCamp[nI][2],40) 										// Descricao da campanha
		@ nLi,PCol()+6		PSay Transform(aTotCamp[nI][3],'@E 999,999')				// Total de Atendimentos
		@ nLi,PCol()+12		PSay Transform((aTotCamp[nI][3]/nTotGer)*100, '@E 999.99') // Porcentagem

	Next nI                  

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Imprime o total dos atendimentos por Data e Operador.     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aSort(aDatOper,,, {|x,y| x[1] < y[1] } )		// Coloca em ordem crescente por dia

	TkIncLine(@nLi,nMax+1,nMax,titulo,cCabec1,cCabec2,nomeprog,tamanho)
	TkIncLine(@nLi,3,nMax,titulo,cCabec1,cCabec2,nomeprog,tamanho)
	@ nLi,00		PSay "DATA      OPERADOR                                           ATENDIMENTOS" // "DATA      OPERADOR                                           ATENDIMENTOS"
	TkIncLine(@nLi,1,nMax,titulo,cCabec1,cCabec2,nomeprog,tamanho)
	@ nLi,00		PSay __PrtThinLine()                           
		  
	nLen := Len(aDatOper)
	For nI := 1 To nLen
	
		// Trata quebra de pagina
		If @nLi >= 56
			TkIncLine(@nLi,nMax+1,nMax,titulo,cCabec1,cCabec2,nomeprog,tamanho)			
			TkIncLine(@nLi,3,nMax,titulo,cCabec1,cCabec2,nomeprog,tamanho)								
			@ nLi,00		PSay "DATA      OPERADOR                                           ATENDIMENTOS" // "DATA      OPERADOR                                           ATENDIMENTOS"
		    TkIncLine(@nLi,1,nMax,titulo,cCabec1,cCabec2,nomeprog,tamanho)
			@ nLi,00		PSay __PrtThinLine()
		Endif
	
		If cData <> aDatOper[nI][1]
			If  !lPula
				TkIncLine(@nLi,1,nMax,titulo,cCabec1,cCabec2,nomeprog,tamanho)
				lPula := .T.
			Else
			    If @nLi <= 56                                                          
					TkIncLine(@nLi,2,nMax,titulo,cCabec1,cCabec2,nomeprog,tamanho)
				Else 
					TkIncLine(@nLi,1,nMax,titulo,cCabec1,cCabec2,nomeprog,tamanho)					
				Endif 	
			Endif	
			@ nLi,00		PSay StoD(aDatOper[nI][1])
		Else
			TkIncLine(@nLi,1,nMax,titulo,cCabec1,cCabec2,nomeprog,tamanho)
			lPula := .T.				
		Endif
		
		@ nLi,10	PSay PadR(aDatOper[nI][2],6)+ " - " + PadR(aDatOper[nI][3],40) // Descricao do operador
		@ nLi,65	PSay Transform(aDatOper[nI][4],'@E 999,999') 					// Total de Atendimentos	
		
		cData := aDatOper[nI][1]
		
	Next nI
	
	lPula := .F.
	cData := ""

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Imprime o total dos atendimentos por Data e Midia.        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aSort(aDatMid,,, {|x,y| x[1] < y[1] } )		// Coloca em ordem crescente por dia

	TkIncLine(@nLi,3,nMax,titulo,cCabec1,cCabec2,nomeprog,tamanho)
	@ nLi,00		PSay "DATA      MIDIA                                              ATENDIMENTOS" // "DATA      MIDIA                                              ATENDIMENTOS"
	TkIncLine(@nLi,1,nMax,titulo,cCabec1,cCabec2,nomeprog,tamanho)
	@ nLi,00		PSay __PrtThinLine()                           

	nLen := Len(aDatMid)
	For nI := 1 To nLen

		// Trata quebra de pagina
		If @nLi >= 56
			TkIncLine(@nLi,nMax+1,nMax,titulo,cCabec1,cCabec2,nomeprog,tamanho)			
			TkIncLine(@nLi,3,nMax,titulo,cCabec1,cCabec2,nomeprog,tamanho)								
			@ nLi,00		PSay "DATA      MIDIA                                              ATENDIMENTOS" // "DATA      MIDIA                                              ATENDIMENTOS"
		    TkIncLine(@nLi,1,nMax,titulo,cCabec1,cCabec2,nomeprog,tamanho)
			@ nLi,00		PSay __PrtThinLine()
		Endif
	
		If cData <> aDatMid[nI][1]
			If  !lPula
				TkIncLine(@nLi,1,nMax,titulo,cCabec1,cCabec2,nomeprog,tamanho)
				lPula := .T.
			Else
			    If @nLi <= 56                                                          
					TkIncLine(@nLi,2,nMax,titulo,cCabec1,cCabec2,nomeprog,tamanho)
				Else 
					TkIncLine(@nLi,1,nMax,titulo,cCabec1,cCabec2,nomeprog,tamanho)					
				Endif 	
			Endif	
			@ nLi,00		PSay StoD(aDatMid[nI][1])
		Else
			TkIncLine(@nLi,1,nMax,titulo,cCabec1,cCabec2,nomeprog,tamanho)
			lPula := .T.				
		Endif
		
		@ nLi,10	PSay PadR(aDatMid[nI][2],6)+ " - " + PadR(aDatMid[nI][3],40) 	// Descricao do operador
		@ nLi,65	PSay Transform(aDatMid[nI][4],'@E 999,999') 					// Total de Atendimentos	
		
		cData := aDatMid[nI][1]
		
	Next nI
		
	lPula := .F.
	cData := ""
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Imprime o total dos atendimentos por Data e Campanha.     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aSort(aDatCamp,,, {|x,y| x[1] < y[1] } )		// Coloca em ordem crescente por dia

	TkIncLine(@nLi,3,nMax,titulo,cCabec1,cCabec2,nomeprog,tamanho)
	@ nLi,00		PSay "DATA      CAMPANHA                                           ATENDIMENTOS" // "DATA      CAMPANHA                                           ATENDIMENTOS"
	TkIncLine(@nLi,1,nMax,titulo,cCabec1,cCabec2,nomeprog,tamanho)
	@ nLi,00		PSay __PrtThinLine()                           

	nLen := Len(aDatCamp)		
	For nI := 1 To nLen

		// Trata quebra de pagina
		If @nLi >= 56
			TkIncLine(@nLi,nMax+1,nMax,titulo,cCabec1,cCabec2,nomeprog,tamanho)			
			TkIncLine(@nLi,3,nMax,titulo,cCabec1,cCabec2,nomeprog,tamanho)								
			@ nLi,00		PSay "DATA      CAMPANHA                                           ATENDIMENTOS" // "DATA      CAMPANHA                                           ATENDIMENTOS"
		    TkIncLine(@nLi,1,nMax,titulo,cCabec1,cCabec2,nomeprog,tamanho)
			@ nLi,00		PSay __PrtThinLine()
		Endif
	
		If cData <> aDatCamp[nI][1]
			If  !lPula
				TkIncLine(@nLi,1,nMax,titulo,cCabec1,cCabec2,nomeprog,tamanho)
				lPula := .T.
			Else
			    If @nLi <= 56                                                          
					TkIncLine(@nLi,2,nMax,titulo,cCabec1,cCabec2,nomeprog,tamanho)
				Else 
					TkIncLine(@nLi,1,nMax,titulo,cCabec1,cCabec2,nomeprog,tamanho)					
				Endif 	
			Endif	
			@ nLi,00		PSay StoD(aDatCamp[nI][1])
		Else
			TkIncLine(@nLi,1,nMax,titulo,cCabec1,cCabec2,nomeprog,tamanho)
			lPula := .T.				
		Endif
		
		@ nLi,10	PSay PadR(aDatCamp[nI][2],6)+ " - " + PadR(aDatCamp[nI][3],40) // Descricao do operador
		@ nLi,65	PSay Transform(aDatCamp[nI][4],'@E 999,999') 					// Total de Atendimentos	
		
		cData := aDatCamp[nI][1]
		
	Next nI
		
	lPula := .F.
	cData := ""

Endif            

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Caso nada tenha sido impresso, entao imprime uma menssagem de aviso³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nLi == 0
	TkIncLine(@nLi,nMax+1,nMax,titulo,cCabec1,cCabec2,nomeprog,tamanho)
	@ nLi,000 PSay "Nao existem dados a serem impressos para este relatorio com os parametros informados" // "Nao existem dados a serem impressos para este relatorio com os parametros informados"
Endif


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Imprime o rodape do relatorio³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Roda(cbCont,cbText,Tamanho)

#IFDEF TOP
	DbSelectArea((cSUA))
	DbCloseArea()
	ChkFile((cSUA))
#ENDIF

Set Device To Screen
If ( aReturn[5] = 1 )
	Set Printer To
	dbCommitAll()
	OurSpool(wnrel)
Endif
MS_FLUSH()

Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Tkr039RptDef ºAutor  ³Vendas Clientes     º Data ³  28/08/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Funcao para informar as celulas que serao utilizadas no rela-  º±±
±±º          ³latorio                                                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ TMKR039                                                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Tkr039RptDef()
Local oReport				// Objeto do relatorio
Local oSection1				// Objeto da secao 1
Local oSection2				// Objeto da secao 2
Local oSection3				// Objeto da secao 3
Local oCollMidia			// Objeto do Collection da Midia
Local oCollCampa			// Objeto do Collection da Campanha
Local oPerMidia				// Objeto do Percentual do Collection da Midia
Local oPerCamp				// Objeto do Percentual do Collection da Campanha
Local cAlias1	:= "SUA"	// Define o cAlias1 como SUA
Local cAlias2	:= "SU5"	// Define o cAlias2 como SU5
Local cAlias3	:= "SA1"	// Define o cAlias3 como SA1

#IFDEF TOP
	cAlias1		:= GetNextAlias()						// Pega o proximo Alias Disponivel
 	cAlias2		:= cAlias1								// Deixa o cAlias2 igual ao cAlias1
 	cAlias3		:= cAlias1								// Deixa o cAlias3 igual ao cAlias1
#ENDIF	
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Gera a tela com os dados para a confirmação da geracao do relatorio³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//"Atendimentos Realizados - Televendas"
// "Este programa irá emitir uma relação das ligações realizadas pelo operador no atendimento Televendas."
// "Apenas as ligações registradas como ATENDIMENTO serão emitidas neste relatório." # "Os dados serão emitidos conforme os parâmetros informados."
DEFINE REPORT oReport NAME "TMKR039" TITLE "Nome" PARAMETER "TMK039" ACTION {|oReport| TKR039PrtRpt( oReport, cAlias1 )} DESCRIPTION "DESCRICAO" + "DESCRICAO1" + "DESCRICAO2"
oReport:SetLandscape()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Define a secao1 do relatorio, com quebra por filial ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DEFINE SECTION oSection1 OF oReport TITLE "Orcamentos Televendas"  TABLES "SUA","SU5","SUC" 	////"Orcamentos Televendas" 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Define as celulas que irao aparecer na secao1³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DEFINE CELL NAME "UA_EMISSAO"	OF oSection1 ALIAS "SUA"
DEFINE CELL NAME "UA_CODCONT"	OF oSection1 ALIAS "SUA" SIZE 35 BLOCK {|| (cAlias1)->UA_CODCONT + " - " + ALLTRIM(Posicione("SU5",1,xFilial("SU5") + (cAlias1)->UA_CODCONT,"U5_CONTAT")) }
DEFINE CELL NAME "UA_NUM"		OF oSection1 ALIAS "SUA" SIZE 9
DEFINE CELL NAME "A1_DDD"		OF oSection1 ALIAS "SA1" TITLE "DDD"
DEFINE CELL NAME "A1_TEL"		OF oSection1 ALIAS "SA1" TITLE "Tel."
DEFINE CELL NAME "UA_OPERADO"	OF oSection1 ALIAS "SUA" SIZE 35 BLOCK {|| (cAlias1)->UA_OPERADO + " - " + ALLTRIM(Posicione("SU7",1,xFilial("SU7") + (cAlias1)->UA_OPERADO,"U7_NOME")) }
DEFINE CELL NAME "U5_EMAIL"		OF oSection1 ALIAS "SU5"
DEFINE CELL NAME "UA_VEND"		OF oSection1 ALIAS "SUA" TITLE "Representante" SIZE 35 BLOCK {|| (cAlias1)->UA_VEND + " - " + Posicione("SA3",1,xFilial("SA3") + (cAlias1)->UA_VEND,"A3_NOME") }
DEFINE CELL NAME "UA_CLIENTE"	OF oSection1 ALIAS "SUA" TITLE "Cliente" SIZE 100 BLOCK {|| IIF((cAlias1)->UA_PROSPEC,"PROPEC"," ") + ; //+ " - " + ;   		//"Entidade"
																						(cAlias1)->UA_CLIENTE + " - " + IIF((cAlias1)->UA_PROSPEC,;     //"PROSPECT"#"CLIENTE"
																						ALLTRIM(POSICIONE("SUS",1,XFILIAL("SUS")+(cAlias1)->UA_CLIENTE+(cAlias1)->UA_LOJA,"US_NOME")),;
																						ALLTRIM(POSICIONE("SA1",1,XFILIAL("SA1")+(cAlias1)->UA_CLIENTE+(cAlias1)->UA_LOJA,'A1_NOME'))+ "/ REGIONAL- " +;
																						ALLTRIM(POSICIONE("SA1",1,XFILIAL("SA1")+(cAlias1)->UA_CLIENTE+(cAlias1)->UA_LOJA,'A1_REGIAO')))}

																						
DEFINE CELL NAME "UA_MIDIA"		OF oSection1 ALIAS "SUA" //SIZE 35 BLOCK {|| (cAlias1)->UA_MIDIA + " - " + Posicione("SUH",1,xFilial("SUH") + (cAlias1)->UA_MIDIA,"UH_DESC") }
DEFINE CELL NAME "UA_CODCAMP"	OF oSection1 ALIAS "SUA"
DEFINE CELL NAME "UA_CODLIG"	OF oSection1 ALIAS "SUA"
DEFINE CELL NAME "UA_TABELA"	OF oSection1 ALIAS "SUA"
DEFINE CELL NAME "UA_OPER"		OF oSection1 ALIAS "SUA"
DEFINE CELL NAME "UA_TMK"		OF oSection1 ALIAS "SUA"
DEFINE CELL NAME "UA_TPFRETE"	OF oSection1 ALIAS "SUA"
DEFINE CELL NAME "UC_PENDENT"	OF oSection1 ALIAS "SUC" SIZE 100
DEFINE CELL NAME "Observacao"	OF oSection1 ALIAS "SUA" PICTURE "@!" SIZE 200 BLOCK {|| ALLTRIM(MSMM((cAlias1)->UA_CODOBS,43,1));
 + " " + ALLTRIM(MSMM((cAlias1)->UA_CODOBS,43,2))+ " " + ALLTRIM(MSMM((cAlias1)->UA_CODOBS,43,3))+" " + ALLTRIM(MSMM((cAlias1)->UA_CODOBS,43,4));
 + " " + ALLTRIM(MSMM((cAlias1)->UA_CODOBS,43,5)) }
 DEFINE CELL NAME " "	OF oSection1 ALIAS "SUA" PICTURE "@!" SIZE 200 BLOCK {|| ALLTRIM(MSMM((cAlias1)->UA_CODOBS,43,6));
 + " " + ALLTRIM(MSMM((cAlias1)->UA_CODOBS,43,7))+ " " + ALLTRIM(MSMM((cAlias1)->UA_CODOBS,43,8))+" " + ALLTRIM(MSMM((cAlias1)->UA_CODOBS,43,9));
 + " " + ALLTRIM(MSMM((cAlias1)->UA_CODOBS,43,10)) }

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Define a secao2 do relatorio, informando que o arquivo principal utlizado eh o SL3 e o complementar o SB1³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DEFINE SECTION oSection2 OF oSection1 TITLE "Itens do Orcamento Televendas"  TABLES "SUB","SB1" 	//"Itens do Orcamento Televendas" 
//DEFINE SECTION oSection2 OF oSection1 TITLE "Itens do orçamento" TABLES "SUB","SB1" 	//"Itens do Orcamento Televendas"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Define as celulas que irao aparecer na secao2³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DEFINE CELL NAME "UB_ITEM"		OF oSection2 ALIAS "SUB" TITLE "It"	//"It"
DEFINE CELL NAME "UB_PRODUTO"	OF oSection2 ALIAS "SUB"
DEFINE CELL NAME "B1_DESC"		OF oSection2 ALIAS "SB1"
DEFINE CELL NAME "UB_SITPROD"	OF oSection2 ALIAS "SUB"
DEFINE CELL NAME "UB_QUANT"		OF oSection2 ALIAS "SUB" TITLE "Qtdade"	//"Qtdade"
DEFINE CELL NAME "UB_VRUNIT"	OF oSection2 ALIAS "SUB"
DEFINE CELL NAME "UB_VLRITEM"	OF oSection2 ALIAS "SUB"
DEFINE CELL NAME "UB_DESC"		OF oSection2 ALIAS "SUB" TITLE "%Desc"	//"%Desc"
DEFINE CELL NAME "UB_VALDESC"	OF oSection2 ALIAS "SUB"
DEFINE CELL NAME "UB_ACRE"		OF oSection2 ALIAS "SUB" TITLE "%Acre"	//"%Acre"
DEFINE CELL NAME "UB_VALACRE"	OF oSection2 ALIAS "SUB"
DEFINE CELL NAME "UB_TES"		OF oSection2 ALIAS "SUB" TITLE "TES"	//"TES"
DEFINE CELL NAME "UB_CF"		OF oSection2 ALIAS "SUB" TITLE "CFOP"	//"CFOP"
DEFINE CELL NAME "UB_PRCTAB"	OF oSection2 ALIAS "SUB"
DEFINE CELL NAME "UB_BASEICM"	OF oSection2 ALIAS "SUB"
DEFINE CELL NAME "UB_LOCAL"		OF oSection2 ALIAS "SUB" TITLE "LP"	//"LP"
DEFINE CELL NAME "UB_UM"		OF oSection2 ALIAS "SUB" TITLE "UM"	//"UM"
DEFINE CELL NAME "UB_DTENTRE"	OF oSection2 ALIAS "SUB" TITLE "Entrega"	//"Entrega"
DEFINE CELL NAME "UB_LOTE"		OF oSection2 ALIAS "SUB"
DEFINE CELL NAME "UB_SUBLOTE"	OF oSection2 ALIAS "SUB"
DEFINE CELL NAME "UB_DTVALID"	OF oSection2 ALIAS "SUB" TITLE "Validade"	//"Validade"

DEFINE FUNCTION FROM oSection2:Cell("UB_QUANT")		FUNCTION SUM NO END REPORT
DEFINE FUNCTION FROM oSection2:Cell("UB_VLRITEM")	FUNCTION SUM NO END REPORT
DEFINE FUNCTION FROM oSection2:Cell("UB_VALDESC")	FUNCTION SUM NO END REPORT
DEFINE FUNCTION FROM oSection2:Cell("UB_VALACRE")	FUNCTION SUM NO END REPORT

DEFINE COLLECTION OF oSection1 FUNCTION COUNT FORMULA oSection1:Cell('UA_OPER')		CONTENT oSection1:Cell('UA_OPER')		TITLE "OPERACAO" NO END SECTION	// "OPERACAO"
DEFINE COLLECTION OF oSection2 FUNCTION SUM FORMULA   oSection1:Cell('UA_OPER')		CONTENT oSection2:Cell('UB_VLRITEM')	TITLE "" NO END SECTION
DEFINE COLLECTION OF oSection1 FUNCTION COUNT FORMULA oSection1:Cell('UA_OPERADO')	CONTENT oSection1:Cell('UA_OPERADO')	TITLE "OPERADOR" NO END SECTION	// "OPERADOR"

DEFINE FUNCTION oPerMidia FROM oSection1:Cell('UA_MIDIA') FUNCTION COUNT
oPerMidia:Hide()

DEFINE FUNCTION oPerCamp FROM oSection1:Cell('UA_CODCAMP') FUNCTION COUNT
oPerCamp:Hide()

DEFINE COLLECTION oCollMidia OF oSection1 FUNCTION COUNT FORMULA oSection1:Cell('UA_MIDIA')	CONTENT oSection1:Cell('UA_MIDIA')		TITLE "NOMEMIDIA" NO END SECTION
DEFINE COLLECTION OF oSection1 FUNCTION ONPRINT FORMULA oSection1:Cell('UA_MIDIA') CONTENT	{|a1,a2,a3,a4| (oCollMidia:GetFunction(a4:name()):GetLastValue()*100)/oPerMidia:GetLastValue()} TITLE "% "+"MIDIA" PICTURE "@E 999.99 %"  NO END SECTION	//"MIDIA"
DEFINE COLLECTION oCollCampa OF oSection1 FUNCTION COUNT FORMULA oSection1:Cell('UA_CODCAMP')	CONTENT oSection1:Cell('UA_CODCAMP')	TITLE "NOMECOMPANHA" NO END SECTION
DEFINE COLLECTION OF oSection1 FUNCTION ONPRINT FORMULA oSection1:Cell('UA_CODCAMP') CONTENT	{|a1,a2,a3,a4| (oCollCampa:GetFunction(a4:name()):GetLastValue()*100)/oPerCamp:GetLastValue()} TITLE "% "+"CAMPANHA" PICTURE "@E 999.99 %"  NO END SECTION	// "CAMPANHA"


oSection1:SetTotalText("")
oSection1:SetLineStyle()
oSection2:SetTotalText("")
oSection2:SetTotalInLine(.F.)
Return oReport
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TKR039PrtRptºAutor  ³Vendas Clientes     º Data ³  28/08/06   º±±                                  		
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Funcao para impressao do relatorio personalizavel             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ TMKR039                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function TKR039PrtRpt( oReport, cAlias1, oCollMidia)
Local oSection1 := oReport:Section(1)				// Define a secao 1 do relatorio
Local oSection2 := oSection1:Section(1)				// Define que a secao 2 serah filha da secao 1
Local cFiltro	:= ""								// Variavel utilizada para o filtro
Local cQuery1	:= "%"    						//	Armazena valores para a query
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Abre o arquivo de telecobranca pelo indice do cliente³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DbSelectArea("SUA")
DbSetOrder(1)

#IFDEF TOP
	MakeSqlExpr("TMK039")

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Seleciono somente a campanha informada nos parametros³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !Empty(MV_PAR07)
		cQuery1 +=	"	AND SUA.UA_CODCAMP = '" + MV_PAR07 +	"'  "
	Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Seleciono somente o tipo de entidade dos parametros³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ       
 	If MV_PAR08 <> 3		// Ambos
 		If MV_PAR08 == 1	// Clientes
			cQuery1 +=	"	AND	SUA.UA_PROSPEC	=	'F'	"    
			TRPosition():New(oSection1,"SA1",1,{|| xFilial("SA1")+(cAlias1)->UA_CLIENTE +(cAlias1)->UA_LOJA})
		Else				// Prospects
			cQuery1 +=	"	AND	SUA.UA_PROSPEC = 'T'	"
		Endif                                   
	
	Endif   
   	cQuery1 += "%"
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Inicializa a secao 1³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	BEGIN REPORT QUERY oSection1

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Query utilizada para filtrar todos os dados necessarios ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	BeginSql alias cAlias1
		SELECT	UA_EMISSAO,	UA_NUM,		UA_OPERADO,	UA_CODCONT, 
				UA_VEND,	UA_MIDIA,	UA_CODCAMP,	UA_CODLIG,	
				UA_TABELA,	UA_OPER,	UA_TMK,		UA_TPFRETE,	
				UA_CODOBS,	UA_CLIENTE,	UA_LOJA, 	UA_FILIAL, 
				UA_PROSPEC, UB_ITEM,	UB_PRODUTO,	B1_DESC,	
				B1_COD, 	UB_SITPROD,	UB_QUANT,	UB_VRUNIT,	
				UB_VLRITEM,	UB_DESC,	UB_VALDESC,	UB_ACRE,	
				UB_VALACRE,	UB_TES,		UB_CF,		UB_PRCTAB,	
				UB_BASEICM,	UB_LOCAL,	UB_UM,		UB_DTENTRE,	
				UB_LOTE,	UB_SUBLOTE,	UB_DTVALID,	UB_NUM,
				A1_VEND, A1_REGIAO 


		FROM %table:SUA% SUA

		LEFT JOIN %table:SUB% SUB ON
			SUB.UB_FILIAL = %xfilial:SUB% AND SUB.UB_NUM = SUA.UA_NUM AND SUB.%notDel%

		LEFT JOIN %table:SB1% SB1 ON
			B1_FILIAL = %xfilial:SB1% AND SB1.B1_COD = SUB.UB_PRODUTO AND SB1.%notDel%
		
		INNER JOIN %table:SA1% SA1 ON UA_CLIENTE = A1_COD AND UA_LOJA = A1_LOJA AND SA1.%notDel%

		WHERE	UA_FILIAL	=	%xfilial:SUA%			AND 
				UA_OPERADO	>=	%exp:mv_par01%			AND
				UA_OPERADO	<=	%exp:mv_par02%			AND
				UA_EMISSAO	>=	%exp:DtoS(mv_par03)%	AND
				UA_EMISSAO	<=	%exp:DtoS(mv_par04)%	AND
				UA_MIDIA	>=	%exp:mv_par05%			AND
				UA_MIDIA	<=	%exp:mv_par06%			AND
				A1_VEND BETWEEN %exp:mv_par09% AND %exp:mv_par10% AND
				A1_REGIAO BETWEEN %exp:mv_par11% AND %exp:mv_par12% AND				
				UA_CANC		=	' '						AND
				UA_OPER		=	'3'						AND
				SUA.%notDel%
				%exp:cQuery1%							
		ORDER BY %Order:SUA%
	EndSql
	
	
	conout('teste')
	
	
	END REPORT QUERY oSection1

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Baseada na query da secao1, utiliza filtro para saber quando deve sair do laco de impressao³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oSection2:SetParentQuery()

	oSection2:SetParentFilter( { | cParam | (cAlias1)->UA_NUM == cParam},{|| (cAlias1)->UB_NUM } ) 
	TRPosition():New(oSection1,"SU5",1,{|| xFilial("SU5")+ (cAlias1)->UA_CODCONT})  
	TRPosition():New(oSection1,"SUH",1,{|| xFilial("SUH")+ (cAlias1)->UA_MIDIA}) 
	TRPosition():New(oSection1,"SA3",1,{|| xFilial("SA3")+ (cAlias1)->UA_VEND}) 
	TRPosition():New(oSection1,"SU7",1,{|| xFilial("SU7")+ (cAlias1)->UA_OPERADO}) 

#ELSE
	MakeAdvplExpr("TMK039")

	cFiltro := "UA_FILIAL = '" + xFilial("SUA") + "'"
	cFiltro += " .AND. UA_OPERADO >= '" + Ø + "' .AND. UA_OPERADO <= '" + MV_PAR02 + "'"
	cFiltro += " .AND. DTOS(UA_EMISSAO) >= '" + DTOS(MV_PAR03) + "' .AND. DTOS(UA_EMISSAO) <= '" + DTOS(MV_PAR04) + "'"
	cFiltro += " .AND. UA_MIDIA >= '" + MV_PAR05 + "' .AND. UA_MIDIA <= '" + MV_PAR06 + "'"
	cFiltro += " .AND. Empty(UA_CANC) "
	cFiltro += " .AND. UA_OPER = '3'"

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Seleciono somente a campanha informada nos parametros³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !Empty(MV_PAR07)
		cFiltro += ".AND. UA_CODCAMP = '" + MV_PAR07 + "'"
	Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Seleciono somente o tipo de entidade dos parametros³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If MV_PAR08 <> 3		// Ambos
		If MV_PAR08 == 1	// Clientes
			cFiltro +=	".AND. UA_PROSPEC = 'F'"
		Else				// Prospects
			cFiltro +=	".AND. UA_PROSPEC = 'T'"
		Endif
	Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Efetua o filtro de acordo com a expressao (somente do SL3), pois o SB1 nao esta sendo utilizado ainda ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oSection1:SetFilter( cFiltro )
	
	oSection2:SetRelation({|| xFilial("SUB") + SUA->UA_NUM },"SUB",1,.T. )
	oSection2:SetParentFilter( { | cParam | SUB->UB_NUM == cParam},{|| SUA->UA_NUM } )

	TRPosition():New(oSection1,"SU5",1,{|| xFilial("SU5") + SUA->UA_CODCONT } )
    TRPosition():New(oSection1,"SA1",1,{|| xFilial("SA1") + SUA->UA_CLIENTE + SUA->UA_LOJA} )                         

	TRPosition():New(oSection2,"SB1",1,{|| xFilial("SB1") + SUB->UB_PRODUTO } )
#ENDIF
oSection1:Print()
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TMKR039VerifPosºAutor  ³CRM - VENDAS        º Data ³  05/03/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Funcao para controlar a coluna do campo para ver se pula linha.  º±±
±±º          |OBS: Passar o parâmetro 1 (nLi) como referência.				   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Call Center                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function TKR039VerifPos(nLi, cCampo)
	Local nLocalPCol	:= 000							// Controla a coluna da impressão do relatório para saber se precisa pular linha
	nLocalPCol := PCol()+1
	If(nLocalPCol+(TamSX3(cCampo)[1]) > Limite)
		nLi += 1
		nLocalPCol := 000
	End IF
return nLocalPCol