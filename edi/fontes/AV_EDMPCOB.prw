#Include "PROTHEUS.CH"
#Include "Totvs.ch"
#Include "FILEIO.ch"
                       
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AV_EDMPCOBºAutor  ³ Amedeo D. P. Filho º Data ³  02/04/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina para a importacao do arquivo EDI                     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Avant                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function AV_EDMPCOB()

Local cPathIni 	:= Alltrim(GetPvProfString(GetEnvServer(),"Rootpath","",GetADV97()))
Local cTargDir	:= cPathIni+GetSrvProfString("Startpath","")
Local cPathEDI 	:= GetNewPar("AV_DIRCNH", cTargDir)
Local aFiles	:= {}
Local lRetorno	:= .T.
Local lCritico	:= .F.
Local cDirEdi	:= ""
Local cFileLog	:= ""

Private __nQtdTot1 	:= 0
Private __nValTot1 	:= 0
Private __nQtdTot2 	:= 0
Private __nValTot2 	:= 0
Private __nQtdLido	:= 0
Private __nQtdProc	:= 0

Private lRead		:= .F.

cDirEdi := cGetFile('Arquivos (DOCCOB*.EDI)|DOCCOB*.EDI' , 'Selecione o diretório que contém os arquivos',1,cPathEDI,.T.,GETF_RETDIRECTORY)

If !Empty(cDirEdi)
	ADir(cDirEdi + "DOCCOB*.EDI", aFiles)
	
	If Len(aFiles) > 0
		__nQtdLido 	:= Len(aFiles)
		For nX := 1 To Len(aFiles)
			Processa({|| lRetorno := u_AV_IMPCB(cDirEdi + aFiles[nX], @cFileLog, @lCritico, nX, .t.), "Processando arquivo "})
			If !lRetorno .And. lCritico
				Return Nil
			EndIf
		Next nX
		
		If lRead
			U_AV_EDITOT()
		EndIf
		
		cFileLog := NomeAutoLog()
		MostraErro()
		
	Else
		Aviso("Aviso","Nenhum arquivo encontrado na pasta, Verifique",{"Abandona"})
	EndIf
EndIf

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ IMPCOB   ºAutor  ³ Amedeo D. P. Filho º Data ³  02/04/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina para a importacao do arquivo EDI                     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Avant                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function AV_IMPCB(cArqEDI, cFileLog, lCritico, nArq, lExibe)
Local lRetorno	:= .T.
Local cMsg     	:= "Erro na abertura do arquivo EDI: "
Local cCaption 	:= "importacao do arquivo EDI"
Local cBuff	   	:= ""
Local cIdReg   	:= ""
Local cIdInte  	:= ""
Local cIdcSer  	:= ""
Local cIdcNum  	:= ""
Local aIdDocCb 	:= {}
Local nRecZZ4  	:= 0
Local cCGCTrs  	:= ""
Local cCGCAux	:= ""
Local cCodForn 	:= Space(TamSx3('F1_FORNECE')[1])
Local cLojForn 	:= Space(TamSx3('F1_LOJA')[1])
Local lExiste	:= .F.
Local cMenAux	:= ""
Local cMenNota	:= ""
Local cMenCGC	:= ""
Local cFilial	:= ""
Local cFilBkp	:= ""
Local nTamLin	:= 93
Local nTamArq	:= 0
Local nHdl
Local aArrEmp 	:= {}

Default lExibe 	:= .T.

AV_EDIEMP(@aArrEmp)

If File(cArqEDI)
	
	nHdl 	:= FOpen( cArqEDI, 2)
	cMenAux	:= "Leitura do Arquivo: " + cArqEDI
	
	If nHdl > -1
		
		nTamArq	:= FSeek(nHdl, 0,2)
		ProcRegua(nTamArq)
		Fseek(nHdl,0,0)
		
		While LeLinha( nHdl, @cBuff ) > 0
			If lExibe
				IncProc( "Processando arquivo "+Alltrim(Str(nArq))+" de "+Alltrim(Str(__nQtdLido)) )
			EndIf
			cIdReg   := SubStr(cBuff, 1, 3)
			
			do Case
				Case cIdReg == "000"
					AADD( aIdDocCb, {'ZZ4_REMETE' , SubStr(cBuff, 4, 35)} )
					AADD( aIdDocCb, {'ZZ4_DESTIN' , SubStr(cBuff, 39, 35)} )
					AADD( aIdDocCb, {'ZZ4_EMISSA'   , ctod( SubStr(cBuff, 74, 2)+'/'+SubStr(cBuff, 76, 2)+'/'+SubStr(cBuff, 78, 2) ) } )
					cIdInte := SubStr(cBuff, 84, 12)
					
					If SubStr(cIdInte,1,3) <> "COB"
						AutoGrLog(cMenAux)
						AutoGrLog("Este arquivo não é um arquivo de cobrança")
						AutoGrLog(Replicate("-",nTamLin))
						Return(.F.)
					EndIf
					
					AADD( aIdDocCb, {'ZZ4_IDINTE' , cIdInte } )
					
				Case cIdReg == "350"
					//Campos nao utilizados neste registro
					
				Case cIdReg == "351"
					cCGCTrs  := SubStr(cBuff, 4, 14) //C.G.C.
					//Campos nao utilizados neste registro
					
				Case cIdReg == "352" // REGISTRO: D C O - DOCUMENTO DE COBRANÇA
					cSerCon	:= RIGHT(SubStr(cBuff, 15, 03),TamSx3("F1_SERIE")[1] ) //SÉRIE DO CONHECIMENTO
					cDocCon	:= StrZero(Val(SubStr(cBuff, 18, 10)),TamSx3("F1_DOC")[1] )   //NÚMERO DO CONHECIMENTO
					
					AADD( aIdDocCb, {'ZZ4_SERDOC' , cSerCon } ) //SÉRIE DO DOCUMENTO DE COBRANÇA
					AADD( aIdDocCb, {'ZZ4_NUMDOC' , cDocCon } ) //NÚMERO DO DOCUMENTO DE COBRANÇA
					AADD( aIdDocCb, {'ZZ4_STATUS' , 'A'     } ) //marcar o status inicial da tabela como EM ANALISE
					
				Case cIdReg == "353" // REGISTRO: C C O - CONHECIMENTOS EM COBRANÇA
					If lExibe
						__nQtdTot1 ++
						__nValTot1 += Val(SubStr(cBuff, 31, 15))/100
					EndIf
					cIdcSer	:= LEFT(SubStr(cBuff,14, 05),TamSx3("F1_SERIE")[1] )
					cIdcNum	:= StrZero(Val(SubStr(cBuff, 19, 12)),TamSx3("F1_DOC")[1] )
					//					cCGCTrs	:= SubStr(cBuff, 82, 14) //CGC DO REMETENTE EMISSOR DA NF
					
				Case cIdReg == "354" // REGISTRO: C N F - NOTAS FISCAIS EM COBRANÇA NO CONHECIMENTO
					cCGCAux	:= SubStr(cBuff, 45, 14)
					nPosCGC	:= Ascan(aArrEmp,{|x| Alltrim(x[4]) == Alltrim(cCGCAux)})
					
					If nPosCGC > 0
						
						//Troca a Filial
						cFilBkp	:= cFilAnt
						cFilAnt	:= aArrEmp[nPosCGC][2]
						
						//Verifica se existe Fornecedor Cadastrado
						DbSelectarea("SA2")
						SA2->(DbSetorder(3))
						If SA2->(DbSeek(xFilial("SA2") + cCGCTrs))
							cCodForn := SA2->A2_COD
							cLojForn := SA2->A2_LOJA
						Else
							AutoGrLog(cMenAux)
							AutoGrLog('Não existem nenhum fornecedor cadastrado no CGC ' + cCGCTrs + ' e por este motivo nao será possível gerar o titulo a pagar. Solução: cadastre um fornecedor com este CGC e execute novamente o processo.')
							AutoGrLog(Replicate("-",nTamLin))
							Return(.F.)
						EndIf
						
						//Verifica se existe Transportadora Cadastrada
						DbSelectarea("SA4")
						SA4->(DbSetorder(3))
						If SA4->(DbSeek(xFilial("SA4") + cCGCTrs))
							cCodTrsp := SA4->A4_COD
						Else
							AutoGrLog(cMenAux)
							AutoGrLog('Não existem nenhuma transportadora cadastrada no CGC ' + cCGCTrs + ' e por este motivo nao será possível gerar o titulo a pagar. Solução: cadastre uma transportadora com este CGC e execute novamente o processo.')
							AutoGrLog(Replicate("-",nTamLin))
							Return(.F.)
						EndIf
						
						AADD( aIdDocCb, {'ZZ4_FILIAL'	, xFilial('ZZ4')})
						AADD( aIdDocCb, {'ZZ4_CGCTRS' 	, cCGCTrs 	 	} )	//C.G.C.
						AADD( aIdDocCb, {'ZZ4_CODFOR' 	, cCodForn		} )	//codigo do fornecedor, ou seja, a transportadora como codigo de fornecedor
						AADD( aIdDocCb, {'ZZ4_LOJFOR' 	, cLojForn		} )	//codigo da loja do fornecedor, ou seja, da transportadora registrado como fornecedor
						AADD( aIdDocCb, {'ZZ4_CODTRS' 	, cCodTrsp		} )	//codigo da transportadora, registrado na tabela SA4
						
						DbSelectarea("ZZ5")
						ZZ5->(dbSetOrder(1)) // filial + serie + doc
						If ZZ5->(dbSeek( cFilAnt + Padr(cIdcSer,TamSx3("ZZ5_SERCON")[1]) + cIdcNum ))
							lExiste := .T.
							RecLock('ZZ5', .F.)
							ZZ5->ZZ5_SERDOC := cSerCon
							ZZ5->ZZ5_NUMDOC := cDocCon
							ZZ5->ZZ5_USER   := RetCodUsr()
							ZZ5->(MsUnlock())
							
							nRecZZ4  := U_AV_EDIGRV('ZZ4', aIdDocCb, cSerCon + cDocCon , 2, cFilAnt)
						Else
							If !"- Notas Não Encontradas para Importação" + CRLF $ cMenNota
								cMenNota += "- Notas Não Encontradas para Importação" + CRLF
							EndIf
							cMenNota += "Série: " + cIdcSer + " Nro.: " + cIdcNum + CRLF
						EndIf
						
						//Restaura a Filial
						cFilAnt	:= cFilBkp
						
					Else
						If !"CNPJ do Destinatário não pertence a nenhuma Filial do Grupo" + CRLF $ cMenCGC
							cMenCGC += "CNPJ do Destinatário não pertence a nenhuma Filial do Grupo" + CRLF
						EndIf
						cMenCGC	+= "Série: " + cIdcSer + " Nro.: " + cIdcNum + "CNPJ: " + cCGCAux + CRLF
					EndIf
					
				Case cIdReg == "355" // REGISTRO: T D C - TOTAL DE DOCUMENTOS DE COBRANÇA
					If lExibe
						__nQtdTot2 += Val(SubStr(cBuff, 04, 04))      //QTDE. TOTAL DOCTOS. DE COBRANÇA
						__nValTot2 += Val(SubStr(cBuff, 08, 15))/100  //VALOR TOTAL DOCTOS. DE COBRANÇA
					EndIf
			EndCase
		EndDo
		
		If lExiste
			fClose( nHdl )
			nPosExt	 := At(".EDI",Upper(cArqEDI))
			cArqNew	 := Substr(cArqEDI,1,nPosExt-1) + ".PRC"
			nStatus2 := frename(cArqEDI , cArqNew )
			IF nStatus2 == -1
				If lExibe
					Alert("Erro ao Renomear o Arquivo: " + cArqEDI + " Para: " + cArqNew)
				Endif
			Endif
		EndIf
		
	EndIf
	
	If lExiste
		lRead := .T.
		If lExibe
			__nQtdProc	++
		EndIf
		AutoGrLog(cMenAux)
		If !Empty(cMenNota)
			AutoGrLog(cMenNota)
		EndIf
		If !Empty(cMenCGC)
			AutoGrLog(cMenCGC)
		EndIf
		AutoGrLog(Replicate("-",nTamLin))
	Else
		lRetorno := .F.
		AutoGrLog(cMenAux)
		AutoGrLog("Nenhuma nota Encontrada para esse arquivo")
		AutoGrLog(Replicate("-",nTamLin))
	EndIf
Else
	lRetorno := .F.
	lCritico := .T.
	cMsg += cArqEDI
	If lExibe
		ApMsgStop(cMsg, cCaption)
	EndIf
EndIf

Return lRetorno

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ LeLinha  ºAutor  ³Microsiga           º Data ³  07/31/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function LeLinha( nHdl, cRet )
Local cBuff	:= " "
cRet  		:= ""

While FRead( nHdl, @cBuff, 1 ) > 0 .and. cBuff <> Chr(13)
	cRet += cBuff
Enddo

FRead( nHdl, @cBuff, 1 )

Return Len(cRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AV_EDIIMP º Autor ³ Amedeo D. P. Filho º Data ³  04/04/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AVANT                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function AV_EDIEMP(aArrEmp)

Local aAreaSM0	:= SM0->(GetArea())

SM0->(dbSetOrder(1))
SM0->(dbGoTop())
While SM0->( !Eof() )
	If cEmpAnt == SM0->M0_CODIGO
		SM0->(AADD(aArrEmp, {M0_CODIGO, M0_CODFIL, M0_NOME, M0_CGC}))
	EndIf
	SM0->(dbSkip())
EndDo

SM0->(RestArea(aAreaSM0))

Return(aArrEmp)
