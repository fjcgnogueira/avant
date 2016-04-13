#INCLUDE "PROTHEUS.CH"           
#INCLUDE "Totvs.ch"
#INCLUDE "FILEIO.ch"
#INCLUDE "TbiConn.ch"
#INCLUDE "AP5MAIL.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ CONTEXTRATO ³ Autor ³ Rogerio Machado    ³ Data  ³ 15/03/16 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Contabilização de extrato                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function CONTEXTRATO()
	
	Local _cBanco   := ""
	Local _cAgencia := ""
	Local _cConta   := ""
	Local _cReturn  := ""
	Local _cPosicione := ""

	dbSelectArea("SA6")
	dbSetOrder(1)
	
	_cBanco   = LerStr(001,003)
	If _cBanco = "637" //SOFISA
		_cAgencia := "0001 "
		_cConta   = LerStr(066,006)
	ElseIf _cBanco = "341" //ITAU
		_cAgencia = "0237 "
		_cConta   = "036363"
	ElseIf LerStr(001,002) = "20" //BIB
		_cBanco   := "BANCO INDUSTRIAL CC"
		_cAgencia := " "
		_cConta   := " "
	ElseIf _cBanco = "246" //ABC
		_cAgencia := "00019"
		_cConta   := "0700221CC"
	ElseIf _cBanco = "422" //SAFRA
		_cAgencia := "018  "
		_cConta   := "026656"
	EndIf
	
	If _cBanco   = "BANCO INDUSTRIAL CC"
		SA6->(dbSetOrder(2))
		_cPosicione := _cBanco
	Else
		SA6->(dbSetOrder(1))
		_cPosicione := _cBanco+_cAgencia+_cConta
	EndIf
	
	Conout("Banco - agencia - conta")
	Conout(_cBanco+_cAgencia+_cConta)
	
		If SA6->(dbSeek(xFilial("SA6")+_cPosicione))
//========================================= DAYCOVAL =========================================		
			If _cBanco = "707"
				Conout("=== DAYCOVAL ===")
				If !(LerStr(169,004) $ ('C202.D120.C209.D117')) //NAO CONTABILIZAR
					If LerStr(009,005) >= '00001' .And. LerStr(014,001) = 'E' //A PARTIR DE 1 LINHA DE REGISTROS
						If LerStr(169,001) = "C" //Tipo "C" no extrato
							If PARAMIXB == "D" //CONTA DEBITO
								_cReturn := SA6->A6_CONTA
							ElseIf PARAMIXB == "C" //CONTA CREDITO
								If LerStr(169,004) $('C207') //LIB CONTRATO
									_cReturn := "220405010"
								Else
									_cReturn := "110107022"
								EndIf
							ElseIf PARAMIXB == "V" //VALOR
								Conout("Valor: "+ cValToChar(LerVal(153,016)))
								_cReturn := LerVal(153,016)
							ElseIf PARAMIXB == "H" //HISTORICO
								Conout("Historico: "+ LerStr(177,025))
								_cReturn := LerStr(177,025)
							EndIf
						ElseIf LerStr(169,001) = "D" //Tipo "D" no extrato
							If PARAMIXB == "D"
								If LerStr(173,004) $('0127.0330') .AND. LerStr(169,001) = "D" //LIQ. DE TITULOS - ABATIMENTO
									 _cReturn := "220405010"
								ElseIf LerStr(173,004) $('0027.0284') .AND. LerStr(169,001) = "D" //IOF
									_cReturn := "420511309"
								ElseIf LerStr(169,004) $('D102') //JUROS
									_cReturn := "420511306"
								ElseIf LerStr(173,004) $('0103') .AND. LerStr(169,001) = "D" //AMORT. DE CONTRATO
									_cReturn := "220402004"								
								Else
									_cReturn := "420511312"
								EndIf
							ElseIf PARAMIXB == "C"
								If LerStr(173,004) $('0127.0330') .AND. LerStr(169,001) = "D" //LIQ. DE TITULOS - ABATIMENTO
									 _cReturn := SA6->A6_CONTA
								ElseIf LerStr(173,004) $('0027.0284') .AND. LerStr(169,001) = "D" //IOF
									_cReturn := SA6->A6_CONTA
								ElseIf LerStr(169,004) $('D102') //JUROS
									_cReturn := SA6->A6_CONTA
								ElseIf LerStr(173,004) $('0103') .AND. LerStr(169,001) = "D" //AMORT. DE CONTRATO
									_cReturn := SA6->A6_CONTA							
								Else
									_cReturn := SA6->A6_CONTA
								EndIf		
							ElseIf PARAMIXB == "V"
								 Conout("Valor: "+ cValToChar(LerVal(153,016)))
								 _cReturn := LerVal(153,016)
							ElseIf PARAMIXB == "H"
								Conout("Historico: "+ LerStr(177,025))
								_cReturn := LerStr(177,025)
							EndIf
						EndIf
					EndIf
				Else
					Conout("Nada para contabilizar")
				EndIf
//========================================= SOFISA =========================================			
			ElseIf _cBanco = "637"
				Conout("=== SOFISA ===")
				If !(LerStr(170,003) $ ('101.103.104.106.108.109.111.112.113.114.115.117.118.119.120.121.122.201.202.203.204.205.206.207.208.209.210.211.212.214.215.216.217.218.219')) //NAO CONTABILIZAR
					If LerStr(009,005) >= '00001' .And. LerStr(014,001) = 'E' //A PARTIR DA 1 LINHA DE REGISTROS
						If LerStr(169,001) = "C" //Tipo "C" no extrato
							If PARAMIXB == "D" //CONTA DEBITO
								_cReturn := SA6->A6_CONTA
							ElseIf PARAMIXB == "C" //CONTA CREDITO
								_cReturn := "110107023"
							ElseIf PARAMIXB == "V" //VALOR
								Conout("Valor: "+ cValToChar(LerVal(153,016)))
								_cReturn := LerVal(153,016)
							ElseIf PARAMIXB == "H" //HISTORICO
								Conout("Historico: "+ LerStr(177,025))
								_cReturn := LerStr(177,025)
							EndIf
						ElseIf LerStr(169,001) = "D" //Tipo "D" no extrato
							If PARAMIXB == "D"
								If  LerStr(169,004) $('D107') //EMPRESTIMOS
									 _cReturn := "220402004"
								ElseIf LerStr(169,004) $('D110') //IOF
									_cReturn := "420511309"
								ElseIf LerStr(169,004) $('D102') //JUROS
									_cReturn := "420511306"
								Else
									_cReturn := "420511312"
								EndIf
							ElseIf PARAMIXB == "C"
								_cReturn := SA6->A6_CONTA
							ElseIf PARAMIXB == "V"
								 Conout("Valor: "+ cValToChar(LerVal(153,016)))
								 _cReturn := LerVal(153,016)
							ElseIf PARAMIXB == "H"
								Conout("Historico: "+ LerStr(177,025))
								_cReturn := LerStr(177,025)
							EndIf
						EndIf
					EndIf
				Else
					Conout("Nada para contabilizar")
				EndIf
//========================================= ITAU =========================================
			ElseIf _cBanco = "341"
				Conout("=== ITAU ===")
				If LerStr(170,003) $ ('102.105.107.108.110.119.207.209') //CONTABILIZAR
					If LerStr(009,005) >= '00001' .And. LerStr(014,001) = 'E' //A PARTIR DA 1 LINHA DE REGISTROS
						If LerStr(169,001) = "C" 			 		//Tipo "C" no extrato
							If PARAMIXB == "D"				 		//CONTA DEBITO
								_cReturn := SA6->A6_CONTA
							ElseIf PARAMIXB == "C" 					//CONTA CREDITO
								If LerStr(169,004) $('C207')
									_cReturn := "220402004"
								ElseIf LerStr(169,004) $('C209') .AND. LerStr(181,003) = "246"
									_cReturn := "110104022"
								ElseIf LerStr(169,004) $('C209') .AND. LerStr(181,003) = "001"
									_cReturn := "110104008"
								ElseIf LerStr(169,004) $('C209') .AND. LerStr(181,003) = "104"
									_cReturn := "110104018"
								ElseIf LerStr(169,004) $('C209') .AND. LerStr(181,003) = "707"
									_cReturn := "110104019"
								ElseIf LerStr(169,004) $('C209') .AND. LerStr(181,003) = "604"
									_cReturn := "110104021"
								ElseIf LerStr(169,004) $('C209') .AND. LerStr(181,003) = "422"
									_cReturn := "110104017"
								ElseIf LerStr(169,004) $('C209') .AND. LerStr(181,003) = "637"
									_cReturn := "110104020"
								EndIf
							ElseIf PARAMIXB == "V" 					//VALOR
								Conout("Valor: "+ cValToChar(LerVal(153,016)))
								_cReturn := LerVal(153,016)
							ElseIf PARAMIXB == "H" 					//HISTORICO
								Conout("Historico: "+ LerStr(177,025))
								_cReturn := LerStr(177,025)
							EndIf
						
						ElseIf LerStr(169,001) = "D" .AND. PARAMIXB == "C" //Tipo "D" no extrato e Conta Credito no LP
							_cReturn := SA6->A6_CONTA
						ElseIf LerStr(169,004) = "D102" 			//ENCARGOS / JUROS
							If PARAMIXB == "D"				 		//CONTA DEBITO
								_cReturn := "420511306"
							ElseIf PARAMIXB == "V"
								 Conout("Valor: "+ cValToChar(LerVal(153,016)))
								 _cReturn := LerVal(153,016)
							ElseIf PARAMIXB == "H"
								Conout("Historico: "+ LerStr(177,025))
								_cReturn := LerStr(177,025)
							EndIF
						ElseIf LerStr(169,004) = "D105" 			//TARIFAS
							If PARAMIXB == "D"				 		//CONTA DEBITO
								_cReturn := "420511312"
							ElseIf PARAMIXB == "V"
								 Conout("Valor: "+ cValToChar(LerVal(153,016)))
								 _cReturn := LerVal(153,016)
							ElseIf PARAMIXB == "H"
								Conout("Historico: "+ LerStr(177,025))
								_cReturn := LerStr(177,025)
							EndIF
						ElseIf LerStr(169,004) = "D107" 			//EMPRESTIMO / FINANCIAMENTO
							If PARAMIXB == "D"				 		//CONTA DEBITO
								_cReturn := "220402004"
							ElseIf PARAMIXB == "V"
								 Conout("Valor: "+ cValToChar(LerVal(153,016)))
								 _cReturn := LerVal(153,016)
							ElseIf PARAMIXB == "H"
								Conout("Historico: "+ LerStr(177,025))
								_cReturn := LerStr(177,025)
							EndIF
						ElseIf LerStr(169,004) = "D108" 			//CAMBIO
							If PARAMIXB == "D"				 		//CONTA DEBITO
								_cReturn := "220202004"
							ElseIf PARAMIXB == "V"
								 Conout("Valor: "+ cValToChar(LerVal(153,016)))
								 _cReturn := LerVal(153,016)
							ElseIf PARAMIXB == "H"
								Conout("Historico: "+ LerStr(177,025))
								_cReturn := LerStr(177,025)
							EndIF
						ElseIf LerStr(169,004) = "D110" 			//IOF
							If PARAMIXB == "D"				 		//CONTA DEBITO
								_cReturn := "420511309"
							ElseIf PARAMIXB == "V"
								 Conout("Valor: "+ cValToChar(LerVal(153,016)))
								 _cReturn := LerVal(153,016)
							ElseIf PARAMIXB == "H"
								Conout("Historico: "+ LerStr(177,025))
								_cReturn := LerStr(177,025)
							EndIF
						EndIF
					EndIf
				Else
					Conout("Nada para contabilizar")
				EndIf
//========================================= SAFRA =========================================
			ElseIf _cBanco = "422"
				Conout("=== SAFRA ===")
				If LerStr(169,004) $ ('D102.D105.D107.D108.D110.D117.C207.C213') //CONTABILIZAR
					If LerStr(009,005) >= '00001' .And. LerStr(014,001) = 'E' //A PARTIR DA 1 LINHA DE REGISTROS
						If LerStr(170,003) $ ('102.105') //ENCARGOS /TARIFAS
							If PARAMIXB == "D" //CONTA DEBITO
								_cReturn := "420511312"
							ElseIf PARAMIXB == "C" //CONTA CREDITO
								_cReturn := SA6->A6_CONTA 
							ElseIf PARAMIXB == "V" //VALOR
								Conout("Valor: "+ cValToChar(LerVal(153,016)))
								_cReturn := LerVal(153,016)
							ElseIf PARAMIXB == "H" //HISTORICO
								Conout("Historico: "+ LerStr(177,025))
								_cReturn := LerStr(177,025)
							EndIf
						ElseIf LerStr(170,003) = "107" //EMPRESTIMO
							If PARAMIXB == "D" //CONTA DEBITO
								_cReturn := "220402004"
							ElseIf PARAMIXB == "C" //CONTA CREDITO
								_cReturn := SA6->A6_CONTA 
							ElseIf PARAMIXB == "V" //VALOR
								Conout("Valor: "+ cValToChar(LerVal(153,016)))
								_cReturn := LerVal(153,016)
							ElseIf PARAMIXB == "H" //HISTORICO
								Conout("Historico: "+ LerStr(177,025))
								_cReturn := LerStr(177,025)
							EndIf
						ElseIf LerStr(170,003) = "108" //CAMBIO
							If PARAMIXB == "D" //CONTA DEBITO
								_cReturn := "220202004"
							ElseIf PARAMIXB == "C" //CONTA CREDITO
								_cReturn := SA6->A6_CONTA 
							ElseIf PARAMIXB == "V" //VALOR
								Conout("Valor: "+ cValToChar(LerVal(153,016)))
								_cReturn := LerVal(153,016)
							ElseIf PARAMIXB == "H" //HISTORICO
								Conout("Historico: "+ LerStr(177,025))
								_cReturn := LerStr(177,025)
							EndIf
						ElseIf LerStr(170,003) = "110" //IOF
							If PARAMIXB == "D" //CONTA DEBITO
								_cReturn := "420511309"
							ElseIf PARAMIXB == "C" //CONTA CREDITO
								_cReturn := SA6->A6_CONTA 
							ElseIf PARAMIXB == "V" //VALOR
								Conout("Valor: "+ cValToChar(LerVal(153,016)))
								_cReturn := LerVal(153,016)
							ElseIf PARAMIXB == "H" //HISTORICO
								Conout("Historico: "+ LerStr(177,025))
								_cReturn := LerStr(177,025)
							EndIf
						ElseIf LerStr(170,003) = "117" //TRANSFERENCIAS ENTRE CONTAS
							If PARAMIXB == "D" //CONTA DEBITO
								_cReturn := "110107017"
							ElseIf PARAMIXB == "C" //CONTA CREDITO
								_cReturn := SA6->A6_CONTA 
							ElseIf PARAMIXB == "V" //VALOR
								Conout("Valor: "+ cValToChar(LerVal(153,016)))
								_cReturn := LerVal(153,016)
							ElseIf PARAMIXB == "H" //HISTORICO
								Conout("Historico: "+ LerStr(177,025))
								_cReturn := LerStr(177,025)
							EndIf
						ElseIf LerStr(170,003) = "207" //EMPRESTIMO FINANCIAMENTO
							If PARAMIXB == "D" //CONTA DEBITO
								_cReturn := SA6->A6_CONTA 
							ElseIf PARAMIXB == "C" //CONTA CREDITO
								_cReturn := "110107017"
							ElseIf PARAMIXB == "V" //VALOR
								Conout("Valor: "+ cValToChar(LerVal(153,016)))
								_cReturn := LerVal(153,016)
							ElseIf PARAMIXB == "H" //HISTORICO
								Conout("Historico: "+ LerStr(177,025))
								_cReturn := LerStr(177,025)
							EndIf
						ElseIf LerStr(170,003) = "213" //TRANSFERENCIA ENTRE CONTAS
							If PARAMIXB == "D" //CONTA DEBITO
								_cReturn := SA6->A6_CONTA 
							ElseIf PARAMIXB == "C" //CONTA CREDITO
								_cReturn := "110107017"
							ElseIf PARAMIXB == "V" //VALOR
								Conout("Valor: "+ cValToChar(LerVal(153,016)))
								_cReturn := LerVal(153,016)
							ElseIf PARAMIXB == "H" //HISTORICO
								Conout("Historico: "+ LerStr(177,025))
								_cReturn := LerStr(177,025)
							EndIf
						Else
							Conout("Nada para contabilizar")	
						EndIf
					EndIf
				EndIf
//========================================= BIB =========================================				 
			ElseIf _cBanco = "BANCO INDUSTRIAL CC"
				Conout("=== BIB ===")
				If LerStr(001,002) = "20"
					If LerStr(043,003) $ ('104.205') //CONTABILIZAR
						If LerStr(043,003) = "205" //LANCAMENTO AVISADO
							If PARAMIXB == "D" //CONTA DEBITO
								_cReturn := SA6->A6_CONTA
							ElseIf PARAMIXB == "C" //CONTA CREDITO
									_cReturn := "110107025"
							ElseIf PARAMIXB == "V" //VALOR
								Conout("Valor: "+ cValToChar(LerVal(087,016)))
								_cReturn := LerVal(087,016)
							ElseIf PARAMIXB == "H" //HISTORICO
								Conout("Historico: "+ LerStr(050,025))
								_cReturn := LerStr(050,025)
							EndIf
						ElseIf LerStr(043,003) = "104" //LANCAMENTO AVISADO / TODAS OPERACOES
							If PARAMIXB == "D" //CONTA DEBITO
								_cReturn := "420511312"
							ElseIf PARAMIXB == "C" //CONTA CREDITO
								_cReturn := SA6->A6_CONTA 
							ElseIf PARAMIXB == "V" //VALOR
								Conout("Valor: "+ cValToChar(LerVal(087,016)))
								_cReturn := LerVal(087,016)
							ElseIf PARAMIXB == "H" //HISTORICO
								Conout("Historico: "+ LerStr(050,025))
								_cReturn := LerStr(050,025)
							EndIf
						EndIf
					Else
						Conout("Nada para contabilizar")	
					EndIf
				EndIf	
//========================================= ABC =========================================				 
			ElseIf _cBanco = "246"
				Conout("=== ABC ===")
				If LerStr(009,005) >= '00001' .And. LerStr(014,001) = 'E' //A PARTIR DA 1 LINHA DE REGISTROS
					If LerStr(169,004) $ ('D102.D104.D105.D110.C213') //CONTABILIZAR
						If LerStr(169,004) $('C213') //TRANSFERENCIA ENTRE CONTAS
							If PARAMIXB == "D" //CONTA DEBITO
								_cReturn := SA6->A6_CONTA
							ElseIf PARAMIXB == "C" //CONTA CREDITO
									_cReturn := "110107026"
							ElseIf PARAMIXB == "V" //VALOR
								Conout("Valor: "+ cValToChar(LerVal(153,016)))
								_cReturn := LerVal(153,016)
							ElseIf PARAMIXB == "H" //HISTORICO
								Conout("Historico: "+ LerStr(177,025))
								_cReturn := LerStr(177,025)
							EndIf
						ElseIf LerStr(169,004) = "D102" //ENCARGOS E JUROS
							If PARAMIXB == "D" //CONTA DEBITO
								_cReturn := "420511306"
							ElseIf PARAMIXB == "C" //CONTA CREDITO
								_cReturn := SA6->A6_CONTA 
							ElseIf PARAMIXB == "V" //VALOR
								Conout("Valor: "+ cValToChar(LerVal(153,016)))
								_cReturn := LerVal(153,016)
							ElseIf PARAMIXB == "H" //HISTORICO
								Conout("Historico: "+ LerStr(177,025))
								_cReturn :=LerStr(177,025)
							EndIf
						ElseIf LerStr(169,004) $ ('D104.D105') //LANCAMENTO AVISADO / TODAS OPERACOES / TARIFAS
							If PARAMIXB == "D" //CONTA DEBITO
								_cReturn := "420511312"
							ElseIf PARAMIXB == "C" //CONTA CREDITO
								_cReturn := SA6->A6_CONTA 
							ElseIf PARAMIXB == "V" //VALOR
								Conout("Valor: "+ cValToChar(LerVal(153,016)))
								_cReturn := LerVal(153,016)
							ElseIf PARAMIXB == "H" //HISTORICO
								Conout("Historico: "+ LerStr(177,025))
								_cReturn := LerStr(177,025)
							EndIf
						ElseIf LerStr(169,004) = "D110" //IOF
							If PARAMIXB == "D" //CONTA DEBITO
								_cReturn := "420511309"
							ElseIf PARAMIXB == "C" //CONTA CREDITO
								_cReturn := SA6->A6_CONTA 
							ElseIf PARAMIXB == "V" //VALOR
								Conout("Valor: "+ cValToChar(LerVal(153,016)))
								_cReturn := LerVal(153,016)
							ElseIf PARAMIXB == "H" //HISTORICO
								Conout("Historico: "+ LerStr(177,025))
								_cReturn := LerStr(177,025)
							EndIf
						EndIf
					Else
						Conout("Nada para contabilizar")
					EndIf
				EndIf
			EndIf
		EndIf

Return _cReturn