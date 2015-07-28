#Include "Protheus.Ch"           
#Include "TopConn.Ch"              
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ Laudo_Troca º Autor ³ Fernando Nogueira  º Data ³16/05/2014º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Monta Laudo_Troca.dot para o SOTA        				  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Avant                   	                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÏÍÍÍÑÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAnalista Resp.³  Data  ³ Manutencao Efetuada                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º              ³  /  /  ³                                               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function Laudo_Troca()

Local _oProcess := Nil
Local lEnd      := .F.

Private cPerg   := PadR("MTA103",Len(SX1->X1_GRUPO))

SZH->(dbSetOrder(1))

If SZH->(dbSeek(xFilial()+SF1->F1_NUMTRC))
	Pergunte(cPerg,.F.)
	
	_oProcess := MsNewProcess():New({|lEnd| ProcLaudo(lEnd,_oProcess)},"Processando...","Gerando Laudo...",.T.)
	_oProcess:Activate()
Else
	ApMsgInfo("Essa nota não é de Troca!")
Endif	

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ProcLaudo ºAutor  ³ Fernando Nogueira  º Data ³ 22/07/2015  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Processa a geracao do laudo de trocas                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ProcLaudo(lEnd,_oProcess)

	Local cPathDot  := '\samples\Laudo_Troca.dot'
	Local cPathEst  := 'c:\modelos\'
	Local cPathDoc  := 'c:\modelos\Troca_'+SF1->F1_NUMTRC+'.doc'
	Local cPathGrv  := '\web\ws\trocas\'+SF1->F1_NUMTRC+'\'
	Local _cChave   := xFilial("SF1")+SF1->F1_NUMTRC
	Local _cA1Cep   := PesqPict("SA1","A1_CEP")
	Local _cD1Qtd   := PesqPict("SD1","D1_QUANT")
	Local oWord
	Local cArquivo  := ""
		
	Private _li       := 0	
	Private nNumItens := 0
	Private nLinhas   := 0
	Private nLast     := 0
	Private _nFoto    := 0
	Private _lian     := 0
	Private nRegua    := 8
	
	_oProcess:SetRegua1(nRegua)
	
	//Cria o diretorio local para copiar o documento Word
	MontaDir(cPathEst)
	
	//Copia do Server para o Remote, eh necessario
	//para que o wordview e o proprio word possam preparar o arquivo para impressao e/ou 
	//visualizacao .... copia o DOT que esta no ROOTPATH Protheus para o PATH da estacao
	CpyS2T(cPathDot,cPathEst,.T.)
	
	_oProcess:IncRegua1()
	
	OLE_CloseLink(oWord)
	
	oWord	:= OLE_CreateLink()
	OLE_NewFile(oWord,cPathEst+'Laudo_Troca.dot')
	
	Sleep(5000)
	
	If MV_PAR23 == 2
		ApMsgInfo("Fechar a Janela de Ativação do Office.")
	Endif
	
	_oProcess:IncRegua1()
	
	// Dados do Cabecalho
	OLE_SetDocumentVar(oWord,'DOT_DATA'  ,SF1->F1_EMISSAO)
	OLE_SetDocumentVar(oWord,'DOT_TROCA' ,SF1->F1_NUMTRC)
	OLE_SetDocumentVar(oWord,'DOT_NFDEV' ,SF1->F1_DOC+"/"+SF1->F1_SERIE)
	OLE_SetDocumentVar(oWord,'DOT_NOME'  ,Posicione("SA1",1,xFilial("SA1")+SF1->F1_FORNECE+SF1->F1_LOJA,"A1_NOME"))
	OLE_SetDocumentVar(oWord,'DOT_LOJA'  ,SA1->A1_LOJA)
	OLE_SetDocumentVar(oWord,'DOT_CEP'   ,Transform(SA1->A1_CEP, _cA1Cep))
	OLE_SetDocumentVar(oWord,'DOT_ENDER' ,SA1->A1_END)
	OLE_SetDocumentVar(oWord,'DOT_BAIRRO',SA1->A1_BAIRRO)
	OLE_SetDocumentVar(oWord,'DOT_UF'    ,SA1->A1_EST)
	OLE_SetDocumentVar(oWord,'DOT_MUN'   ,SA1->A1_MUN)
	OLE_SetDocumentVar(oWord,'DOT_VEND'  ,Posicione("SA3",1,xFilial("SA3")+SA1->A1_VEND,"A3_NOME"))
	OLE_SetDocumentVar(oWord,'DOT_TEL'   ,"("+SA3->A3_DDDTEL+") "+SA3->A3_TEL)
	
	// Quantidade de Itens da Troca
	SZI->(dbSetOrder(1))
	SZI->(dbGoTop())
	If SZI->(msSeek(_cChave))
	
		While SZI->(!EoF()) .And. SZI->ZI_FILIAL+SZI->ZI_NUMTRC == _cChave
			nNumItens++
			nLinhas += 4
			
			If SZI->ZI_QTDFOTO > 0
				nLinhas++
				nLinhas += ((NoRound(SZI->ZI_QTDFOTO/3 * 100,0) - NoRound(Mod(SZI->ZI_QTDFOTO/3 * 100,100),0)) /100) 
				nLast := Mod(SZI->ZI_QTDFOTO,3)
				If nLast > 0
					nLinhas++
				Endif
			Endif
			
			OLE_SetDocumentVar(oWord,'IT_QTDFOTOS_'+cValtoChar(nNumItens),SZI->ZI_QTDFOTO)
			
			_nFoto := 0
			For _n := 1 To SZI->ZI_QTDFOTO
				_nFoto++
				If File("\WEB\WS\TROCAS\"+SZI->ZI_NUMTRC+"\"+SZI->ZI_NUMTRC+"_"+SZI->ZI_ITEM+"_"+STRZERO(_nFoto,2)+".JPG")
					OLE_SetDocumentVar(oWord,'IT_FOTO_'+cValtoChar(Val(SZI->ZI_ITEM))+'_'+cValtoChar(_n),SZI->ZI_NUMTRC+"/"+SZI->ZI_NUMTRC+"_"+SZI->ZI_ITEM+"_"+STRZERO(_nFoto,2)+".JPG")
				Else
					While !File("\WEB\WS\TROCAS\"+SZI->ZI_NUMTRC+"\"+SZI->ZI_NUMTRC+"_"+SZI->ZI_ITEM+"_"+STRZERO(_nFoto,2)+".JPG") .And. _nFoto < 50
						_nFoto++
					End
					If File("\WEB\WS\TROCAS\"+SZI->ZI_NUMTRC+"\"+SZI->ZI_NUMTRC+"_"+SZI->ZI_ITEM+"_"+STRZERO(_nFoto,2)+".JPG")
						OLE_SetDocumentVar(oWord,'IT_FOTO_'+cValtoChar(Val(SZI->ZI_ITEM))+'_'+cValtoChar(_n),SZI->ZI_NUMTRC+"/"+SZI->ZI_NUMTRC+"_"+SZI->ZI_ITEM+"_"+STRZERO(_nFoto,2)+".JPG")
					Else
						Exit
					Endif
				Endif
			Next _n

			SZO->(dbSetOrder(1))
			SZO->(dbGoTop())
			SZO->(dbSeek(xFilial("SZO")+SZI->ZI_NUMTRC+SZI->ZI_ITEM))
			
			While SZO->(!EoF()) .And. SZO->ZO_FILIAL+SZO->ZO_NUMTRC+SZO->ZO_ITEMTRC = xFilial("SZO")+SZI->ZI_NUMTRC+SZI->ZI_ITEM			
				nLinhas++
				SZO->(dbSkip())
			End
			
			If !Empty(SZI->ZI_OBSERVA)
				nLinhas += 2
			Endif
			
			SZI->(dbSkip())
		End
	Endif
	
	OLE_SetDocumentVar(oWord,'dot_nroitens',nNumItens)
	OLE_SetDocumentVar(oWord,'dot_nlinhas' ,nLinhas-1)
	SZI->(dbGoTop())	

	// Dados dos Itens da Troca
	SZI->(dbSetOrder(1))
	If SZI->(msSeek(_cChave))
		While SZI->(!EoF()) .And. SZI->ZI_FILIAL+SZI->ZI_NUMTRC == _cChave
			
			_li++
			
			OLE_SetDocumentVar(oWord,'IT_NFORI'  +AllTrim(Str(_li)),If(!Empty(SZI->ZI_NFORI),SZI->ZI_NFORI+"/"+SZI->ZI_SERIORI,"")) //NF/Serie Original
			OLE_SetDocumentVar(oWord,'IT_PRODUTO'+AllTrim(Str(_li)),SZI->ZI_PRODUTO)                                                //Produto
			OLE_SetDocumentVar(oWord,'IT_DESC'   +AllTrim(Str(_li)),Posicione("SB1",1,xFilial("SB1")+SZI->ZI_PRODUTO,"B1_DESC"))    //Desc. Produto
			OLE_SetDocumentVar(oWord,'IT_QUANT'  +AllTrim(Str(_li)),Transform(SZI->ZI_QUANT , _cD1Qtd))                             //Qtd Original
			OLE_SetDocumentVar(oWord,'IT_QTDFIS' +AllTrim(Str(_li)),Transform(SZI->ZI_QTDFIS, _cD1Qtd))                             //Qtd Fisica
			OLE_SetDocumentVar(oWord,'IT_QTDSEM' +AllTrim(Str(_li)),Transform(SZI->ZI_QTDSEM, _cD1Qtd))                             //Qtd Sem Troca
			OLE_SetDocumentVar(oWord,'IT_QTDDVL' +AllTrim(Str(_li)),Transform(SZI->ZI_QTDDVL, _cD1Qtd))                             //Qtd Devolucao
			OLE_SetDocumentVar(oWord,'IT_QTDTRC' +AllTrim(Str(_li)),Transform(SZI->ZI_QTDTRC, _cD1Qtd))                             //Qtd de Troca
			OLE_SetDocumentVar(oWord,'IT_OBSERVA'+AllTrim(Str(_li)),SZI->ZI_OBSERVA)                                                //Observacao
			
			SZO->(dbSetOrder(1))
			SZO->(dbGoTop())
			SZO->(dbSeek(xFilial("SZO")+SZI->ZI_NUMTRC+SZI->ZI_ITEM))
			
			_lian := 0
			
			While SZO->(!EoF()) .And. SZO->ZO_FILIAL+SZO->ZO_NUMTRC+SZO->ZO_ITEMTRC = xFilial("SZO")+SZI->ZI_NUMTRC+SZI->ZI_ITEM
			
				_lian++
				
				OLE_SetDocumentVar(oWord,'IT_ANALISE'    +AllTrim(Str(_li))+'_'+AllTrim(Str(_lian)),Posicione("SX5",1,xFilial("SX5")+'TQ'+Left(SZO->ZO_ANALISE,2),"X5_DESCRI"))
				OLE_SetDocumentVar(oWord,'IT_QUANT'      +AllTrim(Str(_li))+'_'+AllTrim(Str(_lian)),Transform(SZO->ZO_QUANT , _cD1Qtd))
				OLE_SetDocumentVar(oWord,'IT_CODANALISE' +AllTrim(Str(_li))+'_'+AllTrim(Str(_lian)),SZO->ZO_ANALISE)
				OLE_SetDocumentVar(oWord,'IT_DESCANALISE'+AllTrim(Str(_li))+'_'+AllTrim(Str(_lian)),Posicione("SX5",1,xFilial("SX5")+'TR'+SZO->ZO_ANALISE,"X5_DESCRI"))
				
				SZO->(dbSkip())
			End
			
			OLE_SetDocumentVar(oWord,'dot_nlinan'+AllTrim(Str(_li)) ,_lian)
			
			SZI->(dbSkip())
		End
	Endif
	
	_oProcess:IncRegua1()
	
	OLE_ExecuteMacro(oWord,"Laudo_Troca")
	
	OLE_ExecuteMacro(oWord,"Fotos")
	
	// Dados do Rodape
	OLE_SetDocumentVar(oWord,'DOT_DATA_LAUDO',Date())
	
	_oProcess:IncRegua1()
	
	Sleep(5000)
	
	_oProcess:IncRegua1()
	
	OLE_UpdateFields(oWord)
	
	_oProcess:IncRegua1()
	
	Sleep(5000)
	
	_oProcess:IncRegua1()
	
	OLE_ExecuteMacro(oWord,"Salva_Doc")
	
	Sleep(3000)
	
	_oProcess:IncRegua1()
	
	If CpyT2S(cPathDoc,cPathGrv,.T.)
		ApMsgInfo("Laudo Gerado")
	Else
		ApMsgInfo("Falha na Geração do Laudo")
	Endif

Return