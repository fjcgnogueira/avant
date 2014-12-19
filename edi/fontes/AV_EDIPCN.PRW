#Include 'Totvs.ch'    
#Include 'Protheus.ch'
#Include 'TbiConn.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AV_EDICNP ºAutor  ³Cristian Werneck    º Data ³  01-09-12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina usada para converter os dados da tabela ZZ3 em NFE   º±±
±±º          ³e também criar a tabela ZZ5                                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AVANT                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function AV_EDIPCN()
Local aLogs 	:= {}
Local aCab  	:= {} // Array que conterá os dados para o cabeçalho do documento de entrada
Local aItem 	:= {} // Array que conterá os itens da nota fiscal de entrada
Local cCodFis  	:= "" //CÓDIGO FISCAL DA NATUREZA DE OPERAÇÃO
Local aIdCnh   	:= {} // Array com 2 dimensões. A primeira deve conter o nome do campo e o segundo o conteudo para o identificar
Local aRegSM0  	:= 0  // Guardar o registro da empresa corrente
Local aRecnoSM0	:= {}
Local lFalha   	:= .F.
Local lProcess	:= .F.
Local lErro		:= .F.
Local _cMsg1	:= ""
Local _dDataBkp	:= ""
Local cArqTxt  	:= "log_" + CriaTrab( Nil, .F. ) + ".Log"

Local cPathIni   := ""
Local cTargetDir := ""
Local cPathEDI 	 := ""

OpenSM0()
dbSelectArea( "SM0" )
aRegSM0  := SM0->(Recno())
SM0->(dbGoTop())

ConOut(" === AV_EDIPCN.PRW ===")
ConOut( "Carregando Empresas / Filial para Processamento" )
While !SM0->( EOF() )
	// So adiciona no aRecnoSM0 se a empresa for diferente
	If aScan( aRecnoSM0, { |x| x[2]+x[3] == SM0->M0_CODIGO + Alltrim(SM0->M0_CODFIL) } ) == 0
		ConOut( "Adicionando Empresa: " + SM0->M0_CODIGO + " / Filial: " + Alltrim(SM0->M0_CODFIL) )
		aAdd( aRecnoSM0, { Recno(), SM0->M0_CODIGO, Alltrim(SM0->M0_CODFIL) } )
	EndIf
	SM0->( dbSkip() )
End

For nI := 1 To Len( aRecnoSM0 )
	
	PREPARE ENVIRONMENT EMPRESA ( aRecnoSM0[nI][02] ) FILIAL ( aRecnoSM0[nI][03] ) MODULO "FAT"

	aLogs := {}

	ConOut( 'Empresa Aberta....:' + SM0->M0_CODIGO	)
	ConOut( 'Filial Aberta.....:' + SM0->M0_CODFIL	)

	AADD( aLogs, "Processando a empresa: " + SM0->( M0_CODIGO + M0_CODFIL + '-' + M0_NOME )  )
	ChkFile('ZZ3') // tabela temporária de importação do CTR
	ChkFile('ZZ5') // conhecimento de transporte
	ChkFile('FIV')
	
	SF1->(dbSetOrder(1))
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Definição dos parametros inicias - utilizados no msexecauto(mata103)            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cPathIni   	:= Alltrim(GetPvProfString(GetEnvServer(),"rootpath","",GetADV97()))
	cTargetDir	:= cPathIni+GetSrvProfString("Startpath","")
	cPathEDI 	:= GETNEWPAR("AV_DIRCNH", cTargetDir)

	cCondPag 	:= GETNEWPAR("AV_CONDPAG", '001') // definição da condicao de pagamento
	cCodNatu 	:= Padr( GETNEWPAR("AV_CODNATU", '101'), TamSx3("E2_NATUREZ")[1] ) // definição do codigo da natureza. Será utilizado no campo F1_NATUREZ
	cCodTES  	:= GETNEWPAR("AV_CODTES", '001') // definição da TES - Tipo de Entrada e Saída. Será utilizado no campo D1_TES
	cOperICM	:= GETNEWPAR("AV_CODOPI", '23')
	cOperSICM	:= GETNEWPAR("AV_CODOPS", '22')
	cCodOper	:= GETNEWPAR("AV_CODOPER", '22')  // tipo de operacao na inclusao do EDI
	cCodPrd  	:= Padr( GETNEWPAR("AV_CODPROD", '000001'), TamSx3("B1_COD")[1] ) // definição do codigo do produto. Será utilizado no campo D1_COD
	
	AADD( aLogs, "Definição dos parametros inicias - utilizados no MsExecauto(MATA103)" )
	AADD( aLogs, "Parametro AV_CONDPAG 	= " + cCondPag 	)
	AADD( aLogs, "Parametro AV_CODNATU 	= " + cCodNatu 	)
	AADD( aLogs, "Parametro AV_CODTES  	= " + cCodTES 	)
	AADD( aLogs, "Parametro AV_CODOPER 	= " + cCodOper 	)
	AADD( aLogs, "Parametro AV_CODPROD 	= " + cCodPrd 	)
	AADD( aLogs, Replicate('-', 80) )
	
	ConOut("Parametro AV_CONDPAG 	= " + cCondPag 	)
	ConOut("Parametro AV_CODNATU 	= " + cCodNatu 	)
	ConOut("Parametro AV_CODTES  	= " + cCodTES 	)
	ConOut("Parametro AV_CODOPER 	= " + cCodOper 	)
	ConOut("Parametro AV_CODPROD 	= " + cCodPrd 	)

	// Realizar as devidas verificações se os parametros informados acima existem antes de continuar a importação dos dados
	AADD( aLogs, "Realizar as devidas verificações se os parametros informados acima existem antes de continuar a importação dos dados" )

	//AV_CONDPAG
	aAreaSE4 := SE4->(GetArea())
	If Empty(Alltrim(Posicione('SE4', 1, xFilial('SE4')+cCondPag, 'E4_CODIGO')))
		lFalha 	:= .T.
		AADD( aLogs, "Condição de pagamento = " + cCondPag + '  não encontrada. ' )
		ConOut("Condição de pagamento = " + cCondPag + '  não encontrada. ' )
	EndIf
	
	//AV_CODNATU
	aAreaSED := SED->(GetArea())
	If Empty(Alltrim(Posicione('SED',1, xFilial('SED')+cCodNatu, 'ED_CODIGO')))
		lFalha 	:= .T.
		AADD( aLogs, "Natureza  = " + cCodNatu + '  não encontrada. ' )
		ConOut("Natureza  = " + cCodNatu + '  não encontrada. ' )
	EndIf
	
	//AV_CODTES
	aAreaSF4 := SF4->(GetArea())
	IF Empty(Alltrim(Posicione('SF4',1,xFilial('SF4')+cCodTES, 'F4_CODIGO')))
		lFalha 	:= .T.
		AADD( aLogs, "Tipo de entrada e Saida  = " + cCodTES + '  não encontrada. ' )
		ConOut("Tipo de entrada e Saida  = " + cCodTES + '  não encontrada. ' )
		
	Else // aproveitar que a tabela está posicionada e guardar algumas informações necessárias
		cCodFis := SF4->F4_CF //CÓDIGO FISCAL DA NATUREZA DE OPERAÇÃO
	EndIf
	
	//AV_CODPROD
	aAreaSB1 := SB1->(GetArea())
	If Empty(Alltrim(Posicione('SB1',1, xFilial('SB1')+cCodPrd, 'B1_COD')))
		lFalha	:= .T.
		AADD( aLogs, "Produto   = " + cCodPrd + '  não encontrada. ' )
		ConOut("Produto   = " + cCodPrd + '  não encontrada. ' )
	EndIf
	
	If lFalha // algum dos parametros informados falhou, portanto abortar a importação
		lErro := .T.
		AADD( aLogs, 'Favor corrigir as inconsistencias apontadas. Importação do conhecimento de transporte abortado.' )
		ConOut('Favor corrigir as inconsistencias apontadas. Importação do conhecimento de transporte abortado.' )
		Return Nil
	Else
		DbSelectArea("ZZ3")
		ZZ3->(DbGotop())
		ZZ3->(dbSetOrder(2)) // Filial + processado?
		If ZZ3->(dbSeek(xFilial('ZZ3') + 'N'))
		
			While ZZ3->(!Eof() .And. ZZ3_FILIAL == xFilial('ZZ3') .And. ZZ3_PROCES == 'N' )
		
				lProcess := .F.
				ConOut("Processando Registro: " + ZZ3->ZZ3_IDINTE)
		
				nRegAtu := ZZ3->(Recno()) // guardar o registro actual pq depois que regravar o campo ZZ3_PROCES  a tabela vai ficar deposicionada
				ZZ3->(dbSkip())
				nRegPos := ZZ3->(Recno()) // guardar o proximo registro antes de gravar .. este registro vai ser reposicionado após a gravacao do ZZ3_PROCES
				
				ZZ3->(dbGoTo(nRegAtu))
				
				cSerCon := LEFT(ZZ3->ZZ3_SERCON,TamSx3("F1_SERIE")[1] ) //SÉRIE DO CONHECIMENTO
				cDocCon := LEFT(ZZ3->ZZ3_NUMCON,TamSx3("F1_DOC")[1] )   //NÚMERO DO CONHECIMENTO
				
				If SF1->(!dbSeek(xFilial('SF1') + cDocCon +  cSerCon + ZZ3->ZZ3_CODFOR + ZZ3->ZZ3_LOJFOR))
					_dDataBkp := dDataBase
					
					dDataBase := ZZ3->ZZ3_DATA				
					
					If ZZ3->ZZ3_ICMS > 0
						cCodOper	:= cOperICM
					Else
						cCodOper	:= cOperSICM
					EndIf

					aCAB  := {}
					aadd( aCab, { "F1_TIPO"      ,"C"      			})
					aadd( aCab, { "F1_FORMUL"    ,"N"      			})
					aadd( aCab, { "F1_DOC"       ,cDocCon  			})
					aadd( aCab, { "F1_SERIE"     ,cSerCon  			})
					aadd( aCab, { "F1_EMISSAO"   ,ZZ3->ZZ3_DTCONH 	})
					aadd( aCab, { "F1_FORNECE"   ,ZZ3->ZZ3_CODFOR 	})
					aadd( aCab, { "F1_LOJA"      ,ZZ3->ZZ3_LOJFOR	})
					aadd( aCab, { "F1_ESPECIE"   ,"CTE"     		})
					aadd( aCab, { "F1_COND"      ,cCondPag 			})
					aadd( aCab, { "F1_DTDIGIT"   ,dDatabase			})
					aadd( aCab, { "E2_NATUREZ"   ,cCodNatu 			})
					
					aItem := {}
					Aadd( aItem, {	{ "D1_ITEM"   ,"0001"          	,Nil }, ;
									{ "D1_COD"    ,cCodPrd         	,Nil }, ;
									{ "D1_UM"     ,'UN'            	,NIL }, ;
									{ "D1_QUANT"  ,1               	,Nil }, ;
									{ "D1_VUNIT"  ,ZZ3->ZZ3_VALOR  	,Nil }, ;
									{ "D1_TOTAL"  ,ZZ3->ZZ3_VALOR  	,Nil }, ;
									{ "D1_OPER"   ,cCodOper  		,Nil }, ;
									{ "D1_RATEIO" ,"2"             	,NIL }, ;
									{ "D1_LOCAL"  ,"01"            	,NIL }, ;
									{ "D1_FORNECE",ZZ3->ZZ3_CODFOR 	,NIL }, ;
									{ "D1_LOJA"   ,ZZ3->ZZ3_LOJFOR 	,NIL }, ;
									{ "D1_VALICM" ,ZZ3->ZZ3_VALICM 	,NIL }, ;
									{ "D1_PICM"   ,ZZ3->ZZ3_ICMS 	,NIL }, ;
									{ "D1_BASEICM",ZZ3->ZZ3_BASICM 	,NIL }, ;
									{ "D1_DTDIGIT",dDatabase 		,NIL }, ;
									{ "D1_NATUREZ",cCodNatu        	,NIL } } )
					
					If ZZ3->ZZ3_VALOR # 0
						nOpc 		:= 3
						_cMsg1  	:= "Id documento conhecimento = "  + cDocCon + cSerCon
						lInclui 	:= Inclui := .T.
						lAltera 	:= Altera := .F.
						lMsErroAuto := .F.
						
						MSExecAuto( { | x, y, z | MATA103( x, y, z ) }, aCab, aItem, nOpc )
						If lMsErroAuto
							lProcess	:= .F.
							lErro		:= .T.
							_cMsg1  	+= " [F A L H O U] - Erro: " + CRLF
							_cMsg1 		+= MostraErro(cPathEDI + "LOGS\" , "MATA103.LOG")
							_cMsg1 		+= CRLF + CRLF
							
							ConOut("Erro na Inclusao da NF")
							DisarmTransaction()
						Else
							lProcess	:= .T.
							ConOut("Inclusao da NF com Sucesso")
							_cMsg1  += " [G E R O U] "
						EndIf
					Else
						lErro	:= .T.
						_cMsg1  := "Id documento conhecimento = "  + cDocCon + cSerCon + 'N A O  P R O C E S S O U ... valor está a ZEROS '
					EndIf
					
					dDataBase := _dDataBkp
				Else
					lErro 	:= .T.
					_cMsg1 	:= "Nota fiscal " + cDocCon + " Sr " + cSerCon + " Já cadastrada"
					ConOut("Nota fiscal " + cDocCon + " Sr " + cSerCon + " Já cadastrada")
				EndIf
				
				aIdCnh := {}
	
				If lProcess
					// se criou a NFEntrada entao vamos criar o o ZZ5
					AADD( aIdCnh, {'ZZ5_FILIAL' , ZZ3->ZZ3_FILIAL } )
					AADD( aIdCnh, {'ZZ5_DATA'   , ZZ3->ZZ3_DATA } ) //DATA, formato DDMMAA
					AADD( aIdCnh, {'ZZ5_HORA'   , ZZ3->ZZ3_HORA } ) //HORA, formato HHMM
					AADD( aIdCnh, {'ZZ5_IDINTE' , ZZ3->ZZ3_IDINTE} ) //IDENTIFICAÇÃO DO INTERCÂMBIO
					AADD( aIdCnh, {'ZZ5_CODFOR' , ZZ3->ZZ3_CODFOR} )  //codigo do fornecedor, ou seja, a transportadora como codigo de fornecedor
					AADD( aIdCnh, {'ZZ5_LOJFOR' , ZZ3->ZZ3_LOJFOR} ) // codigo da loja do fornecedor, ou seja, da transportadora registrado como fornecedor
					AADD( aIdCnh, {'ZZ5_CODTRS' , ZZ3->ZZ3_CODTRS} )  //codigo da transportadora, registrado na tabela SA4
					AADD( aIdCnh, {'ZZ5_IDEMIS' , ZZ3->ZZ3_IDEMIS } ) //FILIAL EMIS DOCUMENTO
					AADD( aIdCnh, {'ZZ5_SERCON' , ZZ3->ZZ3_SERCON } ) //SÉRIE DO CONHECIMENTO
					AADD( aIdCnh, {'ZZ5_NUMCON' , ZZ3->ZZ3_NUMCON } ) //NÚMERO DO CONHECIMENTO
					AADD( aIdCnh, {'ZZ5_DTCONH' , ZZ3->ZZ3_DTCONH })//DATA DE EMISSÃO DO CONHECIMENTO
					AADD( aIdCnh, {'ZZ5_PESO'   , ZZ3->ZZ3_PESO } ) //PESO TRANSPORTADO
					AADD( aIdCnh, {'ZZ5_VLRFRE' , ZZ3->ZZ3_VLRFRE } ) //VALOR TOTAL DO FRETE
					AADD( aIdCnh, {'ZZ5_BASICM' , ZZ3->ZZ3_BASICM } ) //BASE DE CÁLCULO PARA APURAÇÃO ICMS
					AADD( aIdCnh, {'ZZ5_ICMS'   , ZZ3->ZZ3_ICMS } ) //% DE TAXA DO ICMS
					AADD( aIdCnh, {'ZZ5_VALICM' , ZZ3->ZZ3_VALICM } ) //VALOR DO ICMS
					AADD( aIdCnh, {'ZZ5_FRTPES' , ZZ3->ZZ3_FRTPES } ) //VALOR DO FRETE POR PESO/VOLUME
					AADD( aIdCnh, {'ZZ5_VALOR'  , ZZ3->ZZ3_VALOR } ) //VALOR DO FRETE
					AADD( aIdCnh, {'ZZ5_CGCREM' , ZZ3->ZZ3_CGCREM } ) //CNPJ DO LOCAL/FILIAL EMISSORA DO CONHECIMENTO
					AADD( aIdCnh, {'ZZ5_CGCCON' , ZZ3->ZZ3_CGCCON } ) //CGC DO EMISSOR DO CONHECIMENTO
					AADD( aIdCnh, {'ZZ5_CGCTRS' , ZZ3->ZZ3_CGCTRS} )  //CGC da transportadora
					AADD( aIdCnh, {'ZZ5_NFSAID' , ZZ3->ZZ3_NFSAID } ) //SÉRIE DA NOTA FISCAL + NÚMERO DA NOTA FISCAl separado com 3carac para serie e 8 para o nr da nota
					AADD( aIdCnh, {'ZZ5_TIPCNT' , ZZ3->ZZ3_TIPCNT } ) //TIPO DO CONHECIMENTO
					//AADD( aIdCnh, {'ZZ5_PROCES' , 'N' } ) //Flag de processado igual a NAO.
					
					cChave	:= Padr(cSerCon, TamSx3("ZZ5_SERCON")[1]) + cDocCon
					U_AV_EDIGRV('ZZ5', aIdCnh, cChave, 1, ZZ3->ZZ3_FILIAL )
					AADD( aLogs, 'Inclusão do conhecimento na tabela ZZ5: ' + cChave )
					
					// Marcando o registro já processado
					RecLock('ZZ3', .F.)
						ZZ3->ZZ3_PROCES := 'S'
						ZZ3->ZZ3_HRPROC := Time()
						ZZ3->ZZ3_DTPROC := Date()
					ZZ3->(MsUnlock())
				EndIf
	
				AADD( aLogs, _cMsg1 )
				
				ZZ3->(dbGoTo(nRegPos))
				
			Enddo
		
		Else
			ConOut( "Nenhum registro encontrado para Filial: " + xFilial("ZZ3") )
		EndIf

    EndIf
	
	//Envia Log por Email
	If Len(aLogs) > 0
	    
		ConOut("Gerando arquivo de Log Empresa: " + SM0->( M0_CODIGO + M0_CODFIL + '-' + M0_NOME ))
		
		nHdl := fCreate( cArqTxt )
		If ( nHdl <> -1 )
			For _x := 1 to Len(aLogs)
				cLin := aLogs[_x] + CRLF
				fWrite( nHdl, cLin, Len( cLin ) )
			Next
			fClose( nHdl )
		EndIf
	
		If lErro
			U_SENDMAEDI(GetSrvProfString("Startpath","") + cArqTxt, "Inclusão de Notas de Transporte")
		EndIf
	
	EndIf

	RESET ENVIRONMENT

Next nI

Return Nil