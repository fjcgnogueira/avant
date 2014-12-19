#Include "PROTHEUS.CH"
#Include "Totvs.ch"
#Include "FILEIO.ch" 
//--------------------------------------------------------------
/*/{Protheus.doc} Avant - PROJETO EDI TRANSPORTE
DOCUMENTO DE COBRANวA
Description : rotina para importar o EDI

@param xParam Parameter Description
@return xRet Return Description
@author  - cristian_werneck@hotmail.com
@since 23/05/2011
/*/
//--------------------------------------------------------------

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAV_EDIIMP บAutor  ณCristian Werneck    บ Data ณ  12-20-11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRotina para a importacao do arquivo EDI                     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Avant                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function AV_EDIIMP()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local cTipo    := "Arquivos EDI (*.edi)    | *.EDI |"
Local cArqEDI  := ""
Local cMsg     := "Erro na abertura do arquivo EDI: "
Local cCaption := "importacao do arquivo EDI"    

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis utilizadas na leitura do arquivo EDI        ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local nHdl
Local cBuff	   	:= "" // variavel que recebe o conteudo da linha
Local cIdReg   	:= "" // IDENTIFICADOR DE REGISTRO
Local cIdInte  	:= "" // IDENTIFICACAO DO INTERCAM
Local cIdcSer  	:= "" // IDENTIFICACAO da serie do conhecimento
Local cIdcNum  	:= "" // IDENTIFICACAO do documento do conhecimento
Local aId000   	:= {} // Array com 2 dimens๕es. A primeira deve conter o nome do campo e o segundo o conteudo para o identificar 000
Local aId352   	:= {} // Array com 2 dimens๕es. A primeira deve conter o nome do campo e o segundo o conteudo para o identificar 352
Local aId353   	:= {} // Array com 2 dimens๕es. A primeira deve conter o nome do campo e o segundo o conteudo para o identificar 353
Local aId354   	:= {} // Array com 2 dimens๕es. A primeira deve conter o nome do campo e o segundo o conteudo para o identificar 354
Local nRecZZ4  	:= 0  // recno de posicionamento da tebala ZZ4. Serve para posicionar a tabela ZZ4 antes de chamar a funcao de exibicao de dados
Local cCGCTrs  	:= "" // CGC da transportadora
Local cCGCAtu	:= "" // CGC Avant
Local cCGCAux	:= ""
Local cCodForn 	:= Space(TamSx3('F1_FORNECE')[1]) // Codigo do Fornecedor para amarra็ใo entre o conhecimento de transporte e documento de cobran็a
Local cLojForn 	:= Space(TamSx3('F1_LOJA')[1]) // Codigo da loja do Fornecedor para amarra็ใo entre o conhecimento de transporte e documento de cobran็a
Local lExiste	:= .F.
Local cMenEnc	:= ""
Local cMenOut	:= ""

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis utilizadas no totalizador - usa na funcao AV_EDITOT     ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Private __nQtdTot1 := 0 //QTDE. TOTAL DOCTOS. DE COBRANวA
Private __nValTot1 := 0 //VALOR TOTAL DOCTOS. DE COBRANวA
Private __nQtdTot2 := 0 //QTDE. TOTAL DOCTOS. DE COBRANวA
Private __nValTot2 := 0 //VALOR TOTAL DOCTOS. DE COBRANวA

Private _aArrEmp := {} //Carregar um array com o codigo, filial, cgc e nome das empresas

// funcao usada para selecionar o arquivo EDI a ser importado
cPathIni   	:= Alltrim(GetPvProfString(GetEnvServer(),"rootpath","",GetADV97()))//"C:\"
cTargetDir 	:= cPathIni+GetSrvProfString("Startpath","")
cPathEDI 	:= GETNEWPAR("AV_DIRCNH", cTargetDir) // defini็ใo do diret๓rio onde se encontram os arquivos EDI para o conhecimento de transporte

cTipo   += "Todos os arquivos (*.*) | *.*    "
cArqEDI := cGetFile( cTipo, OemToAnsi( 'PROJETO EDI TRANSPORTE' ), 0,cPathEDI, .T. )

/*
Link da funcao cGetFile (http://tdn.totvs.com/kbm#9709)
Observa็๕es : No parโmetro <nOp็๕es>, ้ possํvel determinar as seguintes funcionalidades:

GETF_MULTISELECT - Compatibilidade.
GETF_NOCHANGEDIR - Nใo permite mudar o diret๓rio inicial.
GETF_LOCALFLOPPY - Apresenta a unidade do disquete da mแquina local.
GETF_LOCALHARD - Apresenta a unidade do disco local.
GETF_NETWORKDRIVE - Apresenta as unidades da rede (mapeamento).
GETF_SHAREWARE - Nใo implementado.
GETF_RETDIRECTORY  - Retorna/apresenta um diret๓rio.
*/

U_AV_EDIEMP(@_aArrEmp)	//Carregar um array com o codigo, filial, cgc e nome das empresas

If File(cArqEDI)
	
	nHdl := FOpen( cArqEDI, 2)
	if nHdl > -1
		
		while LeLinha( nHdl, @cBuff ) > 0
			
			cIdReg   := SubStr(cBuff, 1, 3) // IDENTIFICADOR DE REGISTRO
			do Case
				Case cIdReg == "000" // REGISTRO: U N B - CABEวALHO DE INTERCยMBIO
					/*
					DOCUMENTO DE COBRANวA (VERSรO 3.0A – ANO 2000–03/03/1999) PREENCHIMENTO: MANDATำRIO
					REGISTRO: U N B - CABEวALHO DE INTERCยMBIO TAMANHO DO REGISTRO: 170
					OCORRE = 1 (P/ CADA ARQUIVO GERADO)
					No CAMPO FORMATO POSIวรO STATUS NOTAS
					1. IDENTIFICADOR DE REGISTRO N 3 01 M "000"
					2. IDENTIFICAวรO DO REMETENTE A 35 04 M NOME DA CAIXA POSTAL DO REMETENTE
					3. IDENTIFICAวรO DO DESTINATมRIO A 35 39 M NOME DA CAIXA POSTAL DO DESTINATมRIO
					4. DATA N 6 74 M DDMMAA (ESTA DATA ษ DE USO DA APLICAวรO
					EDI, NรO SENDO NECESSมRIA ESTAR NO
					FORMATO DDMMAAAA).
					5. HORA N 4 80 M HHMM
					6. IDENTIFICAวรO DO INTERCยMBIO A 12 84 M SUGESTรO: "COBDDMMHHMMS"
					"COB" = CONSTANTE COBRANวA
					"DDMM"= DIA/MสS
					"HHMM"= HORA/MINUTO
					"S" = SEQUสNCIA DE 0 ภ 9
					7. FILLER A 75 96 C PREENCHER COM BRANCOS
					*/
					cChave := ''
					AADD( aId000, {'ZZ4_FILIAL' , xFilial('ZZ4')} )
					AADD( aId000, {'ZZ4_REMETE' , SubStr(cBuff, 4, 35)} ) //IDENTIFICAวรO DO REMETENTE
					AADD( aId000, {'ZZ4_DESTIN' , SubStr(cBuff, 39, 35)} ) //IDENTIFICAวรO DO DESTINATมRIO
					AADD( aId000, {'ZZ4_EMISSA'   , ctod( SubStr(cBuff, 74, 2)+'/'+SubStr(cBuff, 76, 2)+'/'+SubStr(cBuff, 78, 2) ) } ) //DATA, formato DDMMAA
					cIdInte := SubStr(cBuff, 84, 12) // IDENTIFICAวรO DO INTERCยMBIO - serแ utilizado para vincular as tabelas ZZ3 E ZZ4
					AADD( aId000, {'ZZ4_IDINTE' , cIdInte } ) //IDENTIFICAวรO DO INTERCยMBIO
					cChave  += cIdInte // serแ utilizado para a chave de indice de cada tabela
					
				Case cIdReg == "350" // REGISTRO: U N H - CABEวALHO DE DOCUMENTO
					/*
					No CAMPO FORMATO POSIวรO STATUS NOTAS
					1. IDENTIFICADOR DE REGISTRO N 3 01 M "350"
					2. IDENTIFICAวรO DO DOCUMENTO A 14 04 M SUGESTรO: "COBRADDMMHHMMS"
					"COBRA" = CONSTANTE COBRANวA
					"DDMM" = DIA/MสS
					"HHMM" = HORA/MINUTO
					"S" = SEQUสNCIA DE 0 ภ 9
					3. FILLER A 153 18 C PREENCHER COM BRANCOS
					*/
					// para este cIdReg, nใo ้ para importar nenhum campo
					
				Case cIdReg == "351" // REGISTRO: T R A - DADOS DA TRANSPORTADORA
					/*
					No CAMPO FORMATO POSIวรO STATUS NOTAS
					1. IDENTIFICADOR DE REGISTRO N 3 01 M "351"
					2. C.G.C. N 14 04 M SEM EDIวรO (PONTOS E HอFEN)
					3. RAZรO SOCIAL A 40 18 C
					4. FILLER A 113 58 C PREENCHER COM BRANCOS
					*/
					cCGCTrs  := SubStr(cBuff, 4, 14) //C.G.C.
					AADD( aId000, {'ZZ4_CGC' , cCGCTrs } ) //C.G.C.
					cCodForn := Posicione('SA2', 3, xFilial('SA2')+cCGCTrs, 'A2_COD') // codigo do fornecedor. Posicionado pelo indice do CGC
					cLojForn := SA2->A2_LOJA // codigo da loja
					If Empty(cCodForn) // nใo existe a transportadora cadastrado como fornecedor
						ApMsgInfo('Nใo existem nenhum fornecedor cadastrado no CGC '+cCGCTrs+' e por este motivo nao serแ possํvel gerar o titulo a pagar. Solu็ใo: cadastre um fornecedor com este CGC e execute novamente o processo.')
						Return(nil)
					EndIf
					
					cCodTrsp := Posicione('SA4', 3, xFilial('SA4')+cCGCTrs, 'A4_COD')
					
					If Empty(cCodForn) // nใo existe a transportadora cadastrado como fornecedor
						ApMsgInfo('Nใo existem nenhuma transportadora cadastrada no CGC '+cCGCTrs+' e por este motivo nao serแ possํvel gerar o titulo a pagar. Solu็ใo: cadastre uma transportadora com este CGC e execute novamente o processo.')
						Return(nil)
					EndIf
					AADD( aId000, {'ZZ4_CODFOR'   , cCodForn} )  //codigo do fornecedor, ou seja, a transportadora como codigo de fornecedor
					AADD( aId000, {'ZZ4_LOJFOR'   , cLojForn} ) // codigo da loja do fornecedor, ou seja, da transportadora registrado como fornecedor
					AADD( aId000, {'ZZ4_CODTRS'   , cCodTrsp} )  //codigo da transportadora, registrado na tabela SA4
					
				Case cIdReg == "352" // REGISTRO: D C O - DOCUMENTO DE COBRANวA
					/*
					No CAMPO FORMATO POSIวรO STATUS NOTAS
					1. IDENTIFICADOR DE REGISTRO N 3 001 M "352"
					2. FILIAL EMISSORA DO DOCUMENTO A 10 004 M IDENTIFICAวรO DA UNIDADE EMISSORA
					3. TIPO DO DOCUMENTO DE COBRANวA N 1 014 M 0 = NOTA FISCAL FATURA; 1 = ROMANEIO
					4. SษRIE DO DOCUMENTO DE COBRANวA A 3 015 C
					5. NฺMERO DO DOCUMENTO DE COBRANวA N 10 018 M
					6. DATA DE EMISSรO N 8 028 M DDMMAAAA
					7. DATA DE VENCIMENTO N 8 036 M DDMMAAAA
					8. VALOR DO DOCUMENTO DE COBRANวA N 13,2 044 M
					9. TIPO DE COBRANวA A 3 059 M BCO = Cobran็a Bancแria
					CAR = Carteira
					10. VALOR TOTAL DO ICMS N 13,2 062 M
					11. VALOR – JUROS POR DIA DE ATRASO N 13,2 077 C
					12. DATA LIMITE P/ PAGTO C/ DESCONTO N 8 092 C DDMMAAAA
					13. VALOR DO DESCONTO N 13,2 100 C
					14. IDENTIFICAวรO DO AGENTE DE COBRANวA A 35 115 M NOME DO BANCO
					15. NฺMERO DA AGสNCIA BANCมRIA N 4 150 C Ag๊ncia da C/C para cr้dito do valor
					16. DอGITO VERIFICADOR NUM. DA AGสNCIA A 1 154 C
					17. NฺMERO DA CONTA CORRENTE N 10 155 C C/C para cr้dito do valor
					18. DอGITO VERIFICADOR CONTA CORRENTE A 2 165 C
					19. AวรO DO DOCUMENTO A 1 167 C I = INCLUIR;
					E = EXCLUIR/CANCELAR
					20. FILLER A 3 168 C PREENCHER COM BRANCOS
					*/
					aId352 := {}
					cSerCon := RIGHT(SubStr(cBuff, 15, 03),TamSx3("F1_SERIE")[1] ) //SษRIE DO CONHECIMENTO
					cDocCon := StrZero(Val(SubStr(cBuff, 18, 10)),TamSx3("F1_DOC")[1] )   //NฺMERO DO CONHECIMENTO
					
					// Fernando Nogueira - Chamado 000104
					If Empty(cSerCon)
						cSerCon := '111'
					Endif

					AADD( aId000, {'ZZ4_SERDOC' , cSerCon } ) //SษRIE DO DOCUMENTO DE COBRANวA
					AADD( aId000, {'ZZ4_NUMDOC' , cDocCon } ) //NฺMERO DO DOCUMENTO DE COBRANวA
					AADD( aId000, {'ZZ4_STATUS' , 'A'     } ) //marcar o status inicial da tabela como EM ANALISE
					
				Case cIdReg == "353" // REGISTRO: C C O - CONHECIMENTOS EM COBRANวA
					/*
					No CAMPO FORMATO POSIวรO STATUS NOTAS
					1. IDENTIFICADOR DE REGISTRO N 3 01 M "353"
					2. FILIAL EMISSORA DO DOCUMENTO A 10 04 M IDENTIFICAวรO DA UNIDADE EMISSORA
					3. SษRIE DO CONHECIMENTO A 5 14 C
					4. NฺMERO DO CONHECIMENTO A 12 19 M
					5. VALOR DO FRETE N 13,2 31 C
					6. DATA DE EMISSรO DO CONHECIMENTO N 8 46 C DDMMAAAA
					7. CGC DO REMETENTE – EMISSOR DA NF N 14 54 C SEM EDIวรO (PONTOS E HอFEN)
					8. CGC DO DESTINATมRIO DA NF N 14 68 C SEM EDIวรO (PONTOS E HอFEN)
					9. CGC DO EMISSOR DO CONHECIMENTO N 14 82 C SEM EDIวรO (PONTOS E HอFEN)
					10. FILLER A 75 96 C PREENCHER COM BRANCOS
					*/
					aId353 	:= {}
					cChave 	:= ''
					cIdcSer	:= LEFT(SubStr(cBuff,14, 05),TamSx3("F1_SERIE")[1] )
					//cIdcSer	:= SubStr(cBuff, 14, 05) //SษRIE DO CONHECIMENTO
					cIdcNum	:= Alltrim(Str(Val(SubStr(cBuff, 19, 12))))
					//cIdcNum	:= SubStr(cBuff, 19, 12) //NฺMERO DO CONHECIMENTO
					cCGCTrs	:= SubStr(cBuff, 82, 14) //CGC DO REMETENTE – EMISSOR DA NF
					__nQtdTot1++
					__nValTot1 += Val(SubStr(cBuff, 31, 15))/100
				
				Case cIdReg == "354" // REGISTRO: C N F - NOTAS FISCAIS EM COBRANวA NO CONHECIMENTO
					/*
					No CAMPO FORMATO POSIวรO STATUS NOTAS
					1. IDENTIFICADOR DE REGISTRO N 3 01 M "354"
					2. SษRIE A 3 04 C
					3. NฺMERO DA NOTA FISCAL N 8 07 M
					4. DATA DE EMISSรO DA NOTA FISCAL N 8 15 M DDMMAAAA
					5. PESO DA NOTA FISCAL N 5,2 23 M
					6. VALOR DA MERCADORIA NA NOTA FISCAL N 13,2 30 M
					7. CGC DO EMISSOR DA NOTA FISCAL N 14 45 C
					8. FILLER A 112 59 C PREENCHER COM BRANCOS
					OBS.: REGISTRO OPCIONAL, PODE OU NรO SER UTILIZADO.
					*/
					
					cCGCAux	:= SubStr(cBuff, 45, 14)
					nPosCGC	:= Ascan(_aArrEmp,{|x| Alltrim(x[4]) == Alltrim(cCGCAux)})
					If nPosCGC > 0
						cCGCAtu	:= cCGCAux
					EndIf
					
					If Alltrim(cCGCAtu) == Alltrim(SM0->M0_CGC)
			
						DbSelectarea("ZZ5")
						ZZ5->(dbSetOrder(1)) // filial + serie + doc
						If ZZ5->(dbSeek(xFilial("ZZ5") + Padr(cIdcSer,TamSx3("ZZ5_SERCON")[1]) + cIdcNum ))
							lExiste := .T.
							RecLock('ZZ5', .F.)
							ZZ5->ZZ5_SERDOC := cSerCon
							ZZ5->ZZ5_NUMDOC := cDocCon
							ZZ5->ZZ5_USER   := RetCodUsr()
							ZZ5->(MsUnlock())
			
							U_AV_EDIGRV('ZZ4', aId000, cSerCon + cDocCon , 2) // rotina utilizada para gravar os dados na tabela
							nRecZZ4  := ZZ4->(Recno())
						Else
							cMenEnc += "S้rie: " + cIdcSer + " Nro.: " + cIdcNum + CRLF
						EndIf
			
					Else
						cMenOut += "S้rie: " + cIdcSer + " Nro.: " + cIdcNum + CRLF
					EndIf

				Case cIdReg == "355" // REGISTRO: T D C - TOTAL DE DOCUMENTOS DE COBRANวA
					/*
					No CAMPO FORMATO POSIวรO STATUS NOTAS
					1. IDENTIFICADOR DE REGISTRO N 3 01 M "355"
					2. QTDE. TOTAL DOCTOS. DE COBRANวA N 4 04 M
					3. VALOR TOTAL DOCTOS. DE COBRANวA N 13,2 08 M
					4. FILLER A 148 23 C PREENCHER COM BRANCOS
					*/
					__nQtdTot2 := Val(SubStr(cBuff, 04, 04))      //QTDE. TOTAL DOCTOS. DE COBRANวA
					__nValTot2 := Val(SubStr(cBuff, 08, 15))/100  //VALOR TOTAL DOCTOS. DE COBRANวA
			EndCase
		EndDo
		
		If lExiste
			fClose( nHdl ) // Fechando arquivo texto aos geracao.
			nPosExt	 := At(".EDI",Upper(cArqEDI))
			cArqNew	 := Substr(cArqEDI,1,nPosExt-1) + ".PRC"
			nStatus2 := frename(cArqEDI , cArqNew )
			IF nStatus2 == -1
				Alert("Erro ao Renomear o Arquivo: " + cArqEDI + " Para: " + cArqNew)
			Endif
		EndIf
		
	EndIf

	If lExiste
		If !Empty(cMenEnc)
			Aviso("Aviso","Algumas notas do conhecimento nใo foram encontradas" + CRLF + cMenEnc,{"Ok"},3,"Conhecimentos nใo serใo Importados")
		EndIf
		If !Empty(cMenOut)
			Aviso("Aviso","Algumas notas do conhecimento Atual estใo com o CNPJ diferente da Filial Atual" + CRLF + cMenOut,{"Ok"},3,"Conhecimentos nใo serใo Importados")
		EndIf
		U_AV_EDITOT() // Funcao que tras uma tela para exibir o total importado. Usa o ID 355
	Else
		Alert("Nใo encontrado nota fiscal para esse Documento de Cobran็a, Documento nใo serแ importado")
	EndIf

Else
	cMsg += cArqEDI
	ApMsgStop(cMsg, cCaption)
EndIf

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณUPLOCPTG  บAutor  ณMicrosiga           บ Data ณ  07/31/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function LeLinha( nHdl, cRet )
Local cBuff := " "
cRet  := ""

while FRead( nHdl, @cBuff, 1 ) > 0 .and. cBuff <> Chr(13)
	cRet += cBuff
end

// O chr(13) ja foi ignorado. agora ignora o Chr(10)
FRead( nHdl, @cBuff, 1 )

Return len(cRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAV_EDIIMP บAutor  ณCristian Werneck    บ Data ณ  12-21-11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao para os dados do Array na tabela                    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametro ณ cAlias                                                     บฑฑ
ฑฑบ          ณ aArrays(campo, conteudo)                                   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function AV_EDIGRV(__cAlias, __aDados, cChave, nIndx, cFilEmp )
Local aArea 	:= GetArea()
Local nPosFil	:= 0
Local nRegLock  := 0

Default cFilEmp	:= ""
Default nIndx 	:= 1

dbSelectArea(__cAlias)
(__cAlias)->(dbSetOrder(nIndx))
Begin Transaction

If Empty(cFilEmp)
	cFilEmp := xFilial(__cAlias)
Else
	cFilEmp := Alltrim(cFilEmp)
EndIf

If !(__cAlias)->(dbSeek(cFilEmp + cChave))  // nใo duplicar a inclusao de registros
	RecLock(__cAlias,.T.)
Else
	RecLock(__cAlias,.F.)
EndIf

For nB := 1 to Len(__aDados)
	(__cAlias)->( FieldPut( FieldPos( __aDados[nB][01] ) , __aDados[nB][02] ) )
Next

(__cAlias)->(MsUnLock())

nRegLock := (__cAlias)->(Recno())
End Transaction

RestArea(aArea)
Return(nRegLock)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAV_EDIIMP บAutor  ณCristian Werneck    บ Data ณ  12-25-11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณTela para apresentar o total de registros importados.       บฑฑ
ฑฑบ          ณUsa como base o IdRegistro = 355                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function AV_EDITOT()

Static oDlgTotCob

DEFINE MSDIALOG oDlgTotCob TITLE "T D C - TOTAL DE DOCUMENTOS DE COBRANวA" FROM 000, 000  TO 280, 490 COLORS 0, 16777215 PIXEL


@ 002, 002 GROUP oGroup1 TO 045, 190 PROMPT "Totais de Arquivos" 	OF oDlgTotCob COLOR 0, 16777215 PIXEL
@ 047, 002 GROUP oGroup3 TO 090, 190 PROMPT "Pelo arquivo" 			OF oDlgTotCob COLOR 0, 16777215 PIXEL
@ 092, 002 GROUP oGroup2 TO 135, 190 PROMPT "Pela importa็ใo" 		OF oDlgTotCob COLOR 0, 16777215 PIXEL

@ 011, 007 SAY oSay PROMPT "Quantidade de Arquivos na Pasta" 	SIZE 109, 007 OF oDlgTotCob COLORS 0, 16777215 PIXEL
@ 026, 007 SAY oSay PROMPT "Quantidade de Arquivos Processados"	SIZE 110, 007 OF oDlgTotCob COLORS 0, 16777215 PIXEL
@ 056, 007 SAY oSay PROMPT "Qtde. total Conhec Transporte" 		SIZE 109, 007 OF oDlgTotCob COLORS 0, 16777215 PIXEL
@ 071, 007 SAY oSay PROMPT "Valor total Conhec Transporte" 		SIZE 110, 007 OF oDlgTotCob COLORS 0, 16777215 PIXEL
@ 101, 007 SAY oSay PROMPT "Qtde. total doctos. de cobran็a" 	SIZE 109, 007 OF oDlgTotCob COLORS 0, 16777215 PIXEL
@ 116, 007 SAY oSay PROMPT "Valor total doctos de cobran็a" 	SIZE 110, 007 OF oDlgTotCob COLORS 0, 16777215 PIXEL

@ 010, 120 MSGET oGet VAR __nQtdLido SIZE 060, 010 OF oDlgTotCob PICTURE "@E 999999" 			COLORS 0, 16777215 WHEN .F. PIXEL
@ 024, 120 MSGET oGet VAR __nQtdProc SIZE 060, 010 OF oDlgTotCob PICTURE "@E 999999" 			COLORS 0, 16777215 WHEN .F. PIXEL
@ 056, 120 MSGET oGet VAR __nQtdTot1 SIZE 060, 010 OF oDlgTotCob PICTURE "@E 999,999" 			COLORS 0, 16777215 WHEN .F. PIXEL
@ 069, 120 MSGET oGet VAR __nValTot1 SIZE 060, 010 OF oDlgTotCob PICTURE "@E 999,999,999.99" 	COLORS 0, 16777215 WHEN .F. PIXEL
@ 101, 121 MSGET oGet VAR __nQtdTot2 SIZE 060, 010 OF oDlgTotCob PICTURE "@E 999,999" 			COLORS 0, 16777215 WHEN .F. PIXEL
@ 114, 121 MSGET oGet VAR __nValTot1 SIZE 060, 010 OF oDlgTotCob PICTURE "@E 999,999,999.99" 	COLORS 0, 16777215 WHEN .F. PIXEL

@ 055, 195 BUTTON oButton1 PROMPT "Ok" SIZE 045, 027 OF oDlgTotCob ACTION oDlgTotCob:End() PIXEL

ACTIVATE MSDIALOG oDlgTotCob CENTERED

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAV_EDIIMP บAutor  ณCristian Werneck    บ Data ณ  01-08-12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณCarregar um array com o codigo, filial, cgc e nome das      บฑฑ
ฑฑบ          ณempresas                                                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function AV_EDIEMP(_aArrEmp)
Local aAreaSM0 := SM0->(GetArea())

SM0->(dbSetOrder(1))
SM0->(dbGoTop())
While SM0->( !Eof() )
	SM0->(AADD(_aArrEmp, {M0_CODIGO, M0_CODFIL, M0_NOME, M0_CGC}))
	SM0->(dbSkip())
EndDo

SM0->(RestArea(aAreaSM0))
Return(_aArrEmp)
