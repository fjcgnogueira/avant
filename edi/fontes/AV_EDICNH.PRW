#Include "PROTHEUS.CH"
#Include "Totvs.ch"
#Include "FILEIO.ch"     

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AV_EDICON ºAutor  ³Cristian Werneck    º Data ³  12-26-11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³rotina para importar o arquivo EDI e gerar os documentos de º±±
±±º          ³entrada                                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function  AV_EDIPRC(cArqEDI, lExibe)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis utilizadas na leitura do arquivo EDI        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local cMsg     	:= "Erro na abertura do arquivo EDI: "
Local nHdl
Local cBuff	   	:= "" 	// variavel que recebe o conteudo da linha
Local cIdReg   	:= "" 	// IDENTIFICADOR DE REGISTRO
Local cIdInte  	:= "" 	// IDENTIFICACAO DO INTERCAM
Local cCGCTrs  	:= "" 	// CGC da transportadora
Local cCodForn 	:= "" 	// Codigo do fornecedor
Local cLojaForn	:= ""	// Loja do Fornecedor
Local cCodTrsp 	:= "" 	// Codigo da transportadora
Local cNomTrs  	:= "" 	// Nome da transportadora
Local cSerCon  	:= "" 	// Serie de conhecimento
Local cNumCon  	:= "" 	// Numero do conhecimento
Local cArqNew	:= ""	//Arquivo a Ser renomeado
Local aIdCnh   	:= {} 	// Array com 2 dimensões. A primeira deve conter o nome do campo e o segundo o conteudo para o identificar
Local aId322   := {} // Array com 2 dimensões. A primeira deve conter o nome do campo e o segundo o conteudo para o identificar para os CM
Local aIdZZ5   := {} // Array com 2 dimensões. A primeira deve conter o nome do campo e o segundo o conteudo para o identificar a gravacao da tabela ZZ5
Local nQtdPrc  	:= 0  	// quantidade de linhas importadas para o arquivo temporário
Local lProces  	:= .F.	//saber se o arquivo *.edi foi processado
Local lRetorno	:= .T.

Default lExibe 	:= .T.

If File(cArqEDI)
	
	nHdl := FOpen( cArqEDI, 2 )
	
	If nHdl > -1
		ConOut("Abertura do arquivo = OKAY ")
		AADD( aLogs, "Abertura do arquivo = OKAY " )
		
		While LeLinha( nHdl, @cBuff ) > 0
			cIdReg   := SubStr(cBuff, 1, 3) // IDENTIFICADOR DE REGISTRO
			do Case
				Case cIdReg == "000" // U N B - CABEÇALHO DE INTERCÂMBIO
					/*
					No CAMPO FORMATO POSIÇÃO STATUS NOTAS
					1. IDENTIFICADOR DE REGISTRO N 3 01 M "000"
					2. IDENTIFICAÇÃO DO REMETENTE A 35 04 M NOME DA CAIXA POSTAL DO REMETENTE
					3. IDENTIFICAÇÃO DO DESTINATÁRIO A 35 39 M NOME DA CAIXA POSTAL DO DESTINATÁRIO
					4. DATA N 6 74 M DDMMAA (ESTA DATA É DE USO DA APLICAÇÃO EDI,
					NÃO SENDO NECESSÁRIA ESTAR NO FORMATO
					DDMMAAAA).
					5. HORA N 4 80 M HHMM
					6. IDENTIFICAÇÃO DO INTERCÂMBIO A 12 84 M SUGESTÃO: "CONDDMMHHMMS"
					"CON" = CONSTANTE CONHECIMENTO
					"DDMM"= DIA/MÊS
					"HHMM"= HORA/MINUTO
					"S" = SEQUÊNCIA DE 0 À 9
					7. FILLER A 585 96 M PREENCHER COM BRANCOS
					*/
					
					AADD( aIdCnh, {'ZZ3_DATA'   , ctod( SubStr(cBuff, 74, 2)+'/'+SubStr(cBuff, 76, 2)+'/'+SubStr(cBuff, 78, 2) ) } ) //DATA, formato DDMMAA
					AADD( aIdCnh, {'ZZ3_HORA'   , SubStr(cBuff, 80, 4) } ) //HORA, formato HHMM
					cIdInte := SubStr(cBuff, 84, 12) // IDENTIFICAÇÃO DO INTERCÂMBIO - será utilizado para vincular as tabelas ZZ3 E ZZ4
					AADD( aIdCnh, {'ZZ3_IDINTE' , cIdInte } ) //IDENTIFICAÇÃO DO INTERCÂMBIO
					
				Case cIdReg == "320" // REGISTRO: U N H - CABEÇALHO DE DOCUMENTO
					/*
					1. IDENTIFICADOR DE REGISTRO N 3 01 M "320"
					2. IDENTIFICAÇÃO DO DOCUMENTO A 14 04 M SUGESTÃO: "CONHEDDMMHHMMS"
					"CONHE" = CONSTANTE CONHECIMENTO
					"DDMM" = DIA/MÊS
					"HHMM" = HORA/MINUTO
					"S" = SEQUÊNCIA DE 0 À 9
					3. FILLER A 663 18 M PREENCHER COM BRANCOS
					
					Não será preciso importar esta linha
					*/
					
				Case cIdReg == "321" // REGISTRO: T R A - DADOS DA TRANSPORTADORA
					/*
					No CAMPO FORMATO POSIÇÃO STATUS NOTAS
					1. IDENTIFICADOR DE REGISTRO N 3 01 M "321"
					2. C.G.C. N 14 04 M Recomenda-se gravar o CNPJ principal
					(Matriz) da Transportadora.
					3. RAZÃO SOCIAL A 40 18 C
					4. FILLER A 623 58 M PREENCHER COM BRANCOS
					
					Não será preciso importar esta linha
					*/
					cCGCTrs  := SubStr(cBuff, 4, 14) //C.G.C. da transportadora
					cCodForn := Posicione('SA2', 3, xFilial('SA2')+cCGCTrs, 'A2_COD')
					
					If Empty(cCodForn) // não existe a transportadora cadastrado como fornecedor
						If !lExibe
							ApMsgInfo('Não existem nenhum fornecedor cadastrado no CGC '+cCGCTrs+' e por este motivo nao será possível gerar os documentos de entrada. Solução: cadastre um fornecedor com este CGC e execute novamente o processo.')
						Else
							AADD( aLogs, 'Não existem nenhum fornecedor cadastrado no CGC '+cCGCTrs+' e por este motivo nao será possível gerar os documentos de entrada. Solução: cadastre um fornecedor com este CGC e execute novamente o processo.' )
							ConOut('Não existem nenhum fornecedor cadastrado no CGC '+cCGCTrs+' e por este motivo nao será possível gerar os documentos de entrada. Solução: cadastre um fornecedor com este CGC e execute novamente o processo.')
						endIf
						Return(nil)
					EndIf
					
					cCodTrsp := Posicione('SA4', 3, xFilial('SA4')+cCGCTrs, 'A4_COD')
					
					If Empty(cCodForn) // não existe a transportadora cadastrado como fornecedor
						If !lExibe
							ApMsgInfo('Não existem nenhuma transportadora cadastrada no CGC '+cCGCTrs+' e por este motivo nao será possível gerar os documentos de entrada. Solução: cadastre uma transportadora com este CGC e execute novamente o processo.')
						Else
							AADD( aLogs, 'Não existem nenhum transportadora cadastrada no CGC '+cCGCTrs+' e por este motivo nao será possível gerar os documentos de entrada. Solução: cadastre uma transportadora com este CGC e execute novamente o processo.' )
							ConOut('Não existem nenhum transportadora cadastrada no CGC '+cCGCTrs+' e por este motivo nao será possível gerar os documentos de entrada. Solução: cadastre uma transportadora com este CGC e execute novamente o processo.')
						endIf
						Return(nil)
					EndIf
					AADD( aIdCnh, {'ZZ3_CODFOR'   , cCodForn} )  //codigo do fornecedor, ou seja, a transportadora como codigo de fornecedor
					AADD( aIdCnh, {'ZZ3_LOJFOR'   , SA2->A2_LOJA} ) // codigo da loja do fornecedor, ou seja, da transportadora registrado como fornecedor
					AADD( aIdCnh, {'ZZ3_CODTRS'   , cCodTrsp} )  //codigo da transportadora, registrado na tabela SA4
					AADD( aIdCnh, {'ZZ3_CGCTRS'   , cCGCTrs} )  //CGC da transportadora
					
				Case cIdReg == "322" // C E M - CONHECIMENTOS EMBARCADOS
					/*
					1. IDENTIFICADOR DE REGISTRO N 3 001 M "322"
					2. FILIAL EMISSORA DO CONHECIMENTO A 10 004 C
					3. SÉRIE DO CONHECIMENTO A 5 014 C
					4. NÚMERO DO CONHECIMENTO A 12 019 M
					5. DATA DE EMISSÃO N 8 031 M DDMMAAAA
					6. CONDIÇÃO DE FRETE A 1 039 M C = CIF; F = FOB
					7. PESO TRANSPORTADO N 5,2 040 M
					8. VALOR TOTAL DO FRETE N 13,2 047 M
					9. BASE DE CÁLCULO PARA APURAÇÃO ICMS N 13,2 062 C
					10. % DE TAXA DO ICMS N 2,2 077 C
					11. VALOR DO ICMS N 13,2 081 C
					12. VALOR DO FRETE POR PESO/VOLUME N 13,2 096 M
					13. FRETE VALOR N 13,2 111 M
					14. VALOR SEC - CAT N 13,2 126 C
					15. VALOR ITR N 13,2 141 C
					16. VALOR DO DESPACHO N 13,2 156 C
					17. VALOR DO PEDÁGIO N 13,2 171 C
					18. VALOR ADEME N 13,2 186 C
					19. SUBSTITUIÇÃO TRIBUTÁRIA? N 1 201 M 1 = SIM; 2 = NÃO
					20. FILLER A 3 202 C Espaços – Antigo campo de CFOP
					21. CNPJ DO LOCAL/FILIAL EMISSORA DO CONHECIMENTO N 14 205 M SEM PONTOS E BARRA.
					22. CNPJ DO EMISSOR DAS NOTAS DO CONHECIMENTO N 14 219 M SEM PONTOS E BARRA. Gravar o CNPJ do
					emissor das notas relacionadas a seguir.
					23. SÉRIE DA NOTA FISCAL – 1 A 3 233 C
					24. NÚMERO DA NOTA FISCAL – 1 N 8 236 M
					25.
					...
					SÉRIE DA NOTA FISCAL – 2
					...
					A 3
					...
					244
					...
					C
					...
					99. SÉRIE DA NOTA FISCAL – 39 A 3 651 C
					100. NÚMERO DA NOTA FISCAL – 39 N 8 654 C
					101. SÉRIE DA NOTA FISCAL – 40 A 3 662 C
					102. NÚMERO DA NOTA FISCAL – 40 N 8 665 C
					103. AÇÃO DO DOCUMENTO A 1 673 C I = INCLUIR;
					C = COMPLEMENTAR e
					E = EXCLUIR
					No CAMPO FORMATO POSIÇÃO STATUS NOTAS
					NOTAS COMPONENTES DO CONHECIMENTO - ATÉ 40 OCORRÊNCIAS DE DADOS DE NOTAS
					104. TIPO DO CONHECIMENTO A 1 674 C A = AJUDANTES
					B = TRANSBORDO DA CARGA
					C = COMPLEMENTAR
					D = CONHECIMENTO DE DEVOLUÇÃO
					E = NORMAL DE ENTRADA
					F = FRETE DE COLETA
					H = COBRANÇA DE STRETCH FILM
					I = ESTADIAS
					M = DESPESAS COM MANUSEIO DA CARGA
					N = NORMAL
					O = NORNAL DE RETORNO
					P = TRANSPORTE DE PALLETS
					R = CONHECIMENTO DE REENTREGA
					S = NORMAL DE SAÍDA
					T = NORMAL DE TRANSFERÊNCIA INTERNA
					U = CUSTO DE COMUNICAÇÃO
					W = COMPLEMENTAR DE RETORNO
					X = COMPLEMENTAR DE ENTRADA
					Y = COMPLEMENTAR DE SAÍDA E
					Z = COMPLEMENTAR DE TRANSF. INTERNA
					105. CÓDIGO FISCAL DA NATUREZA DE OPERAÇÃO A 4 675 M Novo código em vigor em 01/01/03
					106. FILLER A 2 679 M BRANCOS
					*/
					// para este cIdReg, não é para importar nenhum campo
					
					cSerCon  := LEFT(SubStr(cBuff,14, 05),TamSx3("F1_SERIE")[1] )
//					cNumCon  := LEFT(SubStr(cBuff, 19, 12),TamSx3("F1_DOC")[1] )
					cNumCon  := StrZero(Val(SubStr(cBuff, 19, 12)),TamSx3("F1_DOC")[1] )
					aId322   := aClone(aIdCnh)
					AADD( aId322, {'ZZ3_IDEMIS' , SubStr(cBuff, 04, 10) } ) //FILIAL EMIS DOCUMENTO
					AADD( aId322, {'ZZ3_SERCON' , cSerCon } ) //SÉRIE DO CONHECIMENTO
					AADD( aId322, {'ZZ3_NUMCON' , cNumCon } ) //NÚMERO DO CONHECIMENTO
					AADD( aId322, {'ZZ3_DTCONH' , ctod(SubStr(cBuff, 31, 2)+'/'+SubStr(cBuff, 33, 2)+'/'+SubStr(cBuff, 35, 4)) })//DATA DE EMISSÃO DO CONHECIMENTO
					AADD( aId322, {'ZZ3_PESO'   , Val(SubStr(cBuff, 40, 07)) / 100 } ) //PESO TRANSPORTADO
					AADD( aId322, {'ZZ3_VLRFRE' , Val(SubStr(cBuff, 47, 15))/ 100 } ) //VALOR TOTAL DO FRETE
					AADD( aId322, {'ZZ3_BASICM' , Val(SubStr(cBuff, 62, 15))/ 100 } ) //BASE DE CÁLCULO PARA APURAÇÃO ICMS
					AADD( aId322, {'ZZ3_ICMS'   , Val(SubStr(cBuff, 77, 04))/ 100 } ) //% DE TAXA DO ICMS
					AADD( aId322, {'ZZ3_VALICM' , Val(SubStr(cBuff, 81, 15))/ 100 } ) //VALOR DO ICMS
					AADD( aId322, {'ZZ3_FRTPES' , Val(SubStr(cBuff, 96, 15))/ 100 } ) //VALOR DO FRETE POR PESO/VOLUME
					AADD( aId322, {'ZZ3_VALOR'  , Val(SubStr(cBuff, 111, 15))/ 100 } ) //VALOR DO FRETE
					AADD( aId322, {'ZZ3_CGCREM' , SubStr(cBuff, 205, 14) } ) //CNPJ DO LOCAL/FILIAL EMISSORA DO CONHECIMENTO
					AADD( aId322, {'ZZ3_CGCCON' , SubStr(cBuff, 219, 14) } ) //CGC DO EMISSOR DO CONHECIMENTO
					AADD( aId322, {'ZZ3_NFSAID' , SubStr(cBuff, 233, 440) } ) //SÉRIE DA NOTA FISCAL + NÚMERO DA NOTA FISCAl separado com 3carac para serie e 8 para o nr da nota
					AADD( aId322, {'ZZ3_TIPCNT' , SubStr(cBuff, 674, 1  ) } ) //TIPO DO CONHECIMENTO
					AADD( aId322, {'ZZ3_PROCES' , 'N' } ) //Flag de processado igual a NAO.
					
					//Definindo a filial a ser importada
					nPos := Ascan(_aArrEmp, {|x| x[4] == SubStr(cBuff, 219, 14)})
					If nPos <> 0 .And. _aArrEmp[nPos][01] == SM0->M0_CODIGO
						AADD( aId322, {'ZZ3_FILIAL' , _aArrEmp[nPos][02]} )
						cChave := Padr(cSerCon, TamSx3("ZZ3_SERCON")[1]) + cNumCon // indice por serie + documento do conhecimento de transporte
						nRegLock := u_AV_EDIGRV('ZZ3', aId322, cChave, 3, _aArrEmp[nPos][02] ) // rotina utilizada para gravar os dados na tabela
						AADD( aLogs, 'Processado conhecimento: ' + cChave )
						nQtdPrc++
						lProces  := .T. // arquivo processado
						
						If nRegLock <> 0 // gerou alguma coisa no ZZ3
							aIdZZ5 := {}
							ZZ3->(dbGoto(nRegLock))
							// se criou a NFEntrada entao vamos criar o o ZZ5
							AADD( aIdZZ5, {'ZZ5_FILIAL' , ZZ3->ZZ3_FILIAL } )
							AADD( aIdZZ5, {'ZZ5_DATA'   , ZZ3->ZZ3_DATA } ) //DATA, formato DDMMAA
							AADD( aIdZZ5, {'ZZ5_HORA'   , ZZ3->ZZ3_HORA } ) //HORA, formato HHMM
							AADD( aIdZZ5, {'ZZ5_IDINTE' , ZZ3->ZZ3_IDINTE} ) //IDENTIFICAÇÃO DO INTERCÂMBIO
							AADD( aIdZZ5, {'ZZ5_CODFOR' , ZZ3->ZZ3_CODFOR} )  //codigo do fornecedor, ou seja, a transportadora como codigo de fornecedor
							AADD( aIdZZ5, {'ZZ5_LOJFOR' , ZZ3->ZZ3_LOJFOR} ) // codigo da loja do fornecedor, ou seja, da transportadora registrado como fornecedor
							AADD( aIdZZ5, {'ZZ5_CODTRS' , ZZ3->ZZ3_CODTRS} )  //codigo da transportadora, registrado na tabela SA4
							AADD( aIdZZ5, {'ZZ5_IDEMIS' , ZZ3->ZZ3_IDEMIS } ) //FILIAL EMIS DOCUMENTO
							AADD( aIdZZ5, {'ZZ5_SERCON' , ZZ3->ZZ3_SERCON } ) //SÉRIE DO CONHECIMENTO
							AADD( aIdZZ5, {'ZZ5_NUMCON' , ZZ3->ZZ3_NUMCON } ) //NÚMERO DO CONHECIMENTO
							AADD( aIdZZ5, {'ZZ5_DTCONH' , ZZ3->ZZ3_DTCONH })//DATA DE EMISSÃO DO CONHECIMENTO
							AADD( aIdZZ5, {'ZZ5_PESO'   , ZZ3->ZZ3_PESO } ) //PESO TRANSPORTADO
							AADD( aIdZZ5, {'ZZ5_VLRFRE' , ZZ3->ZZ3_VLRFRE } ) //VALOR TOTAL DO FRETE
							AADD( aIdZZ5, {'ZZ5_BASICM' , ZZ3->ZZ3_BASICM } ) //BASE DE CÁLCULO PARA APURAÇÃO ICMS
							AADD( aIdZZ5, {'ZZ5_ICMS'   , ZZ3->ZZ3_ICMS } ) //% DE TAXA DO ICMS
							AADD( aIdZZ5, {'ZZ5_VALICM' , ZZ3->ZZ3_VALICM } ) //VALOR DO ICMS
							AADD( aIdZZ5, {'ZZ5_FRTPES' , ZZ3->ZZ3_FRTPES } ) //VALOR DO FRETE POR PESO/VOLUME
							AADD( aIdZZ5, {'ZZ5_VALOR'  , ZZ3->ZZ3_VALOR } ) //VALOR DO FRETE
							AADD( aIdZZ5, {'ZZ5_CGCREM' , ZZ3->ZZ3_CGCREM } ) //CNPJ DO LOCAL/FILIAL EMISSORA DO CONHECIMENTO
							AADD( aIdZZ5, {'ZZ5_CGCCON' , ZZ3->ZZ3_CGCCON } ) //CGC DO EMISSOR DO CONHECIMENTO
							AADD( aIdZZ5, {'ZZ5_CGCTRS' , ZZ3->ZZ3_CGCTRS} )  //CGC da transportadora
							AADD( aIdZZ5, {'ZZ5_NFSAID' , ZZ3->ZZ3_NFSAID } ) //SÉRIE DA NOTA FISCAL + NÚMERO DA NOTA FISCAl separado com 3carac para serie e 8 para o nr da nota
							AADD( aIdZZ5, {'ZZ5_TIPCNT' , ZZ3->ZZ3_TIPCNT } ) //TIPO DO CONHECIMENTO
							//						AADD( aIdZZ5, {'ZZ5_PROCES' , 'N' } ) //Flag de processado igual a NAO.
							
							cChave := cSerCon + cNumCon // indice por serie + documento do conhecimento de transporte
							u_AV_EDIGRV('ZZ5', aIdZZ5, cChave, 1, _aArrEmp[nPos][02] ) // rotina utilizada para gravar os dados na tabela
							AADD( aLogs, 'Inclusão do conhecimento na tabela ZZ5: ' + cChave )
							
							// Marcando o registro já processado
							RecLock('ZZ3', .f.)
							ZZ3->ZZ3_PROCES := 'S'
							ZZ3->ZZ3_HRPROC := Time()
							ZZ3->ZZ3_DTPROC := Date()
							ZZ3->(MsUnlock())
						EndIf
					ElseIf SubStr(cBuff, 674, 1) == "D"
						cChave := Padr(cSerCon, TamSx3("ZZ3_SERCON")[1]) + cNumCon
						AADD( aLogs, 'Registro Ignorado ' + cChave + ' Conhecimento de Devolucao' )
						lProces  := .T. // arquivo processado
					Else
						cChave := Padr(cSerCon, TamSx3("ZZ3_SERCON")[1]) + cNumCon
						AADD( aLogs, 'NÃO Processado conhecimento: ' + cChave + ' pois nao pertence a esta empresa ou o CGC do remetente ('+SubStr(cBuff, 219, 14)+') nao exite' )
						lProces  := .T. // arquivo processado (Nao mandar email nesses casos)
						//lRetorno := .F.
					EndIf
					
				Case cIdReg == "323" //T C E - TOTAL DE CONHECIMENTOS EMBARCADOS
					/*
					No CAMPO FORMATO POSIÇÃO STATUS NOTAS
					1. IDENTIFICADOR DE REGISTRO N 3 01 M "323"
					2. QUANTIDADE TOTAL DE CONHECIMENTOS N 4 04 M
					3. VALOR TOTAL DOS CONHECIMENTOS N 13,2 08 M
					4. FILLER A 658 23 M PREENCHER COM BRANCOS
					
					nao será importado estes dados
					*/
					
			endCase
		EndDo
		fClose( nHdl ) // Fechando arquivo texto aos geracao.
		AADD( aLogs, 'Processado conhecimento: ' + StrZero(nQtdPrc,6) )
		AADD( aLogs, 'Fechando arquivo texto aos geracao.' )
		AADD( aLogs, Replicate('-', 160) )
		
		// Renomeando um arquivo no servidor, na pasta sigaadv, de error.log para error.old
		If lProces
			nPosExt	:= At(".EDI",Upper(cArqEDI))
			cArqNew := Substr(cArqEDI,1,nPosExt-1) + ".PRC"
			nStatus2 := frename(cArqEDI , cArqNew )
			IF nStatus2 == -1
				ConOut('Falha na operação 2 : FError '+str(ferror(),4))
				AADD( aLogs, 'Falha na operação 2 : FError '+str(ferror(),4) )
			Else
				ConOut('Renomeado arquivo: '+ cArqEDI + ' para ' + cArqNew)
				AADD( aLogs, 'Renomeado arquivo: '+ cArqEDI + ' para ' + cArqNew )
			Endif
		EndIf
		
	Else
		ConOut("Abertura do arquivo Com Erro ")
		lRetorno := .F.
	EndIf
Else
	If lExibe
		// erro na abertura do arquivo EDI
		cMsg += cArqEDI
		AADD( aLogs, 'ERRO : ' + cMsg )
		ApMsgStop(cMsg, cCaption)
	Else
		AADD( aLogs, 'ERRO : ' + cMsg )
	EndIf
	ConOut('ERRO : ' + cMsg)
EndIf

Return lRetorno

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³UPLOCPTG  ºAutor  ³Microsiga           º Data ³  07/31/10   º±±
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
Local cBuff := " "
cRet  := ""

while FRead( nHdl, @cBuff, 1 ) > 0 .and. cBuff <> Chr(13)
	cRet += cBuff
end

// O chr(13) ja foi ignorado. agora ignora o Chr(10)
FRead( nHdl, @cBuff, 1 )

Return len(cRet)
