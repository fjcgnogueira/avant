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

	dbSelectArea("SA6")
	dbSetOrder(1)
	
	_cBanco   = LerStr(001,003)
	If _cBanco = "637"
		_cAgencia := "0001 "
		_cConta   = LerStr(066,006)
	Else
		_cAgencia = LerStr(054,005)
		_cConta   = LerStr(065,007)
	EndIf

	
		If SA6->(dbSeek(xFilial("SA6")+_cBanco+_cAgencia+_cConta))
//========================================= DAYCOVAL =========================================		
			If _cBanco = "707"
				Conout("=== DAYCOVAL ===")
				If !(LerStr(169,004) $ ('C202.D120.C209.D117.C213')) //NAO CONTABILIZAR
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
				EndIf
//========================================= SOFISA =========================================			
			ElseIf _cBanco = "637"
				Conout("=== SOFISA ===")
				If !(LerStr(170,003) $ ('101.103.104.106.108.109.111.112.113.114.115.117.118.119.120.121.122.201.202.203.204.205.206.207.208.209.210.211.212.214.215.216.217.218.219')) //NAO CONTABILIZAR
					If LerStr(009,005) >= '00001' .And. LerStr(014,001) = 'E' //A PARTIR DE 1 LINHA DE REGISTROS
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
				EndIf
			EndIf
		EndIf

Return _cReturn