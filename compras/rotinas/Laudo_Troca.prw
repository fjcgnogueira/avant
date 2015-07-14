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

	Local cPathDot  := '\samples\Laudo_Troca.dot'
	Local cPathEst  := 'c:\modelos\'
	Local _cChave   := xFilial("SF1")+SF1->F1_NUMTRC
	Local _cA1Cep   := PesqPict("SA1","A1_CEP")
	Local _cD1Qtd   := PesqPict("SD1","D1_QUANT")
	Local hWord
	Local cArquivo  := ""
		
	Private _li       := 0	
	Private nNumItens := 0
	Private nLinhas   := 0
	Private _nFoto    := 0
	
	//Cria o diretorio local para copiar o documento Word
	MontaDir(cPathEst)
	
	//Copia do Server para o Remote, eh necessario
	//para que o wordview e o proprio word possam preparar o arquivo para impressao e/ou 
	//visualizacao .... copia o DOT que esta no ROOTPATH Protheus para o PATH da estacao
	CpyS2T(cPathDot,cPathEst,.T.)
	
	OLE_CloseLink(hWord)
	
	hWord	:= OLE_CreateLink()
	OLE_NewFile(hWord,cPathEst+'Laudo_Troca.dot')
	
	Sleep(5000)
	
	// Dados do Cabecalho
	OLE_SetDocumentVar(hWord,'DOT_DATA'  ,SF1->F1_EMISSAO)
	OLE_SetDocumentVar(hWord,'DOT_TROCA' ,SF1->F1_NUMTRC)
	OLE_SetDocumentVar(hWord,'DOT_NFDEV' ,SF1->F1_DOC+"/"+SF1->F1_SERIE)
	OLE_SetDocumentVar(hWord,'DOT_NOME'  ,Posicione("SA1",1,xFilial("SA1")+SF1->F1_FORNECE+SF1->F1_LOJA,"A1_NOME"))
	OLE_SetDocumentVar(hWord,'DOT_LOJA'  ,SA1->A1_LOJA)
	OLE_SetDocumentVar(hWord,'DOT_CEP'   ,Transform(SA1->A1_CEP, _cA1Cep))
	OLE_SetDocumentVar(hWord,'DOT_ENDER' ,SA1->A1_END)
	OLE_SetDocumentVar(hWord,'DOT_BAIRRO',SA1->A1_BAIRRO)
	OLE_SetDocumentVar(hWord,'DOT_UF'    ,SA1->A1_EST)
	OLE_SetDocumentVar(hWord,'DOT_MUN'   ,SA1->A1_MUN)
	OLE_SetDocumentVar(hWord,'DOT_VEND'  ,Posicione("SA3",1,xFilial("SA3")+SA1->A1_VEND,"A3_NOME"))
	OLE_SetDocumentVar(hWord,'DOT_TEL'   ,"("+SA3->A3_DDDTEL+") "+SA3->A3_TEL)
	
	// Quantidade de Itens da Troca
	SZI->(dbSetOrder(1))
	SZI->(dbGoTop())
	If SZI->(msSeek(_cChave))
	
		While SZI->(!EoF()) .And. SZI->ZI_FILIAL+SZI->ZI_NUMTRC == _cChave
			nNumItens++
			nLinhas++
			
			If SZI->ZI_QTDFOTO > 0
				nLinhas += 2 + NoRound(SZI->ZI_QTDFOTO/2,0)
			Endif
			
			OLE_SetDocumentVar(hWord,'IT_QTDFOTOS_'+cValtoChar(nNumItens),SZI->ZI_QTDFOTO)
			
			_nFoto := 0
			For _n := 1 To SZI->ZI_QTDFOTO
				_nFoto++
				If File("\WEB\WS\TROCAS\"+SZI->ZI_NUMTRC+"\"+SZI->ZI_NUMTRC+"_"+SZI->ZI_ITEM+"_"+STRZERO(_nFoto,2)+".JPG")
					OLE_SetDocumentVar(hWord,'IT_FOTO_'+cValtoChar(Val(SZI->ZI_ITEM))+'_'+cValtoChar(_n),SZI->ZI_NUMTRC+"/"+SZI->ZI_NUMTRC+"_"+SZI->ZI_ITEM+"_"+STRZERO(_nFoto,2)+".JPG")
				Else
					While !File("\WEB\WS\TROCAS\"+SZI->ZI_NUMTRC+"\"+SZI->ZI_NUMTRC+"_"+SZI->ZI_ITEM+"_"+STRZERO(_nFoto,2)+".JPG") .And. _nFoto < 50
						_nFoto++
					End
					If File("\WEB\WS\TROCAS\"+SZI->ZI_NUMTRC+"\"+SZI->ZI_NUMTRC+"_"+SZI->ZI_ITEM+"_"+STRZERO(_nFoto,2)+".JPG")
						OLE_SetDocumentVar(hWord,'IT_FOTO_'+cValtoChar(Val(SZI->ZI_ITEM))+'_'+cValtoChar(_n),SZI->ZI_NUMTRC+"/"+SZI->ZI_NUMTRC+"_"+SZI->ZI_ITEM+"_"+STRZERO(_nFoto,2)+".JPG")
					Else
						Exit
					Endif
				Endif
			Next _n
			
			SZI->(dbSkip())
		End
	Endif
	
	OLE_SetDocumentVar(hWord,'dot_nroitens',nNumItens)
	OLE_SetDocumentVar(hWord,'dot_nlinhas' ,nLinhas)
	SZI->(dbGoTop())	

	// Dados dos Itens da Troca
	SZI->(dbSetOrder(1))
	If SZI->(msSeek(_cChave))
		While SZI->(!EoF()) .And. SZI->ZI_FILIAL+SZI->ZI_NUMTRC == _cChave
			
			_li++
			
			OLE_SetDocumentVar(hWord,'IT_NFORI'  +AllTrim(Str(_li)),If(!Empty(SZI->ZI_NFORI),SZI->ZI_NFORI+"/"+SZI->ZI_SERIORI,"")) //NF/Serie Original
			OLE_SetDocumentVar(hWord,'IT_PRODUTO'+AllTrim(Str(_li)),SZI->ZI_PRODUTO)                                                //Produto
			OLE_SetDocumentVar(hWord,'IT_DESC'   +AllTrim(Str(_li)),Posicione("SB1",1,xFilial("SB1")+SZI->ZI_PRODUTO,"B1_DESC"))    //Desc. Produto
			OLE_SetDocumentVar(hWord,'IT_QUANT'  +AllTrim(Str(_li)),Transform(SZI->ZI_QUANT, _cD1Qtd))                              //Qtd Original
			OLE_SetDocumentVar(hWord,'IT_QTDFIS' +AllTrim(Str(_li)),Transform(SZI->ZI_QTDFIS, _cD1Qtd))                             //Qtd Fisica
			OLE_SetDocumentVar(hWord,'IT_QTDSEM' +AllTrim(Str(_li)),Transform(SZI->ZI_QTDSEM, _cD1Qtd))                             //Qtd Sem Troca
			OLE_SetDocumentVar(hWord,'IT_QTDDVL' +AllTrim(Str(_li)),Transform(SZI->ZI_QTDDVL, _cD1Qtd))                             //Qtd Devolucao
			OLE_SetDocumentVar(hWord,'IT_QTDTRC' +AllTrim(Str(_li)),Transform(SZI->ZI_QTDTRC, _cD1Qtd))                             //Qtd de Troca
			SZI->(dbSkip())
		End
	Endif
	
	OLE_ExecuteMacro(hWord,"Laudo_Troca")
	
	OLE_ExecuteMacro(hWord,"Fotos")
	
	// Dados do Rodape
	OLE_SetDocumentVar(hWord,'DOT_DATA_LAUDO',Date())
	
	Sleep(5000)
	
	OLE_UpdateFields(hWord)

Return