#Include "Protheus.Ch"           
#Include "TopConn.Ch"  
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ NotaDebito  º Autor ³ Fernando Nogueira  º Data ³10/05/2017º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Impressao da Nota de Debito em Word                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Avant                   	                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function NotaDebito()

	Local cPathDot := '\samples\Nota_Debito.dotx'
	Local cPathEst := 'c:\modelos\'
	Local cPathDoc := 'c:\modelos\Nota_'+SE2->E2_NUM+'.docx'
	Local oWord
	
	dbSelectArea("SF2")
	dbSetOrder(01)
	dbSeek(xFilial("SF2")+AllTrim(SE2->E2_X_NRTEC))
	
	dbSelectArea("SA1")
	dbSetOrder(01)
	dbSeek(xFilial("SA1")+SF2->(F2_CLIENTE+F2_LOJA))
	
		
	//Cria o diretorio local para copiar o documento Word
	MontaDir(cPathEst)
	
	//Copia do Server para o Remote, eh necessario
	//para que o wordview e o proprio word possam preparar o arquivo para impressao e/ou 
	//visualizacao .... copia o DOT que esta no ROOTPATH Protheus para o PATH da estacao
	CpyS2T(cPathDot,cPathEst,.T.)
	
	OLE_CloseLink(oWord)
	
	oWord := OLE_CreateLink()
	OLE_NewFile(oWord,cPathEst+'Nota_Debito.dotx')
	
	// Dados do Arquivo
	OLE_SetDocumentVar(oWord,'DOT_RAZAO'  , SM0->M0_NOMECOM)
	OLE_SetDocumentVar(oWord,'DOT_CGC_AV' , TransForm(SM0->M0_CGC, PesqPict("SA2","A2_CGC")))
	OLE_SetDocumentVar(oWord,'DOT_IE_AV'  , SM0->M0_INSC)
	OLE_SetDocumentVar(oWord,'DOT_NOTA'   , SE2->E2_NUM)
	OLE_SetDocumentVar(oWord,'DOT_TRANSP' , Posicione("SA2",01,xFilial("SA2")+SE2->(E2_FORNECE+E2_LOJA),"A2_NOME"))
	OLE_SetDocumentVar(oWord,'DOT_CNPJ'   , TransForm(SA2->A2_CGC, PesqPict("SA2","A2_CGC")))
	OLE_SetDocumentVar(oWord,'DOT_CONTATO', SA2->A2_CONTATO)
	OLE_SetDocumentVar(oWord,'DOT_TEL'    , SA2->A2_TEL)
	OLE_SetDocumentVar(oWord,'DOT_EMAIL'  , SA2->A2_EMAIL)
	OLE_SetDocumentVar(oWord,'DOT_CLIENTE', AllTrim(SA1->A1_NOME))
	OLE_SetDocumentVar(oWord,'DOT_NFORIG' , AllTrim(SE2->E2_X_NRTEC))
	OLE_SetDocumentVar(oWord,'DOT_CTE'    , SE2->E2_X_CTE)
	OLE_SetDocumentVar(oWord,'DOT_NFORIG2', AllTrim(SE2->E2_X_NRTEC))
	OLE_SetDocumentVar(oWord,'DOT_CTE2'   , SE2->E2_X_CTE)
	OLE_SetDocumentVar(oWord,'DOT_VENCTO' , SE2->E2_VENCTO)
	OLE_SetDocumentVar(oWord,'DOT_VALOR'  , AllTrim(TransForm(SE2->E2_VALOR, PesqPict("SE2","E2_VALOR"))))
	OLE_SetDocumentVar(oWord,'DOT_BOLETO' , "")
	OLE_SetDocumentVar(oWord,'DOT_DATAEXT', cValToChar(Day(dDataBase))+" de "+MesExtenso(Month(dDataBase))+" de "+cValToChar(Year(dDataBase)))

	OLE_UpdateFields(oWord)
	
Return