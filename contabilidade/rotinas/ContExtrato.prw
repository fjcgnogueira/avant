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
	_cAgencia = LerStr(054,005)
	_cConta   = LerStr(065,007)
	
	
		If SA6->(dbSeek(xFilial("SA6")+_cBanco+_cAgencia+_cConta))
		
			If _cBanco = "707" //DAYCOVAL
				Conout("=== DAYCOVAL ===")
				If !(LerStr(173,004) $ ('0118.0184.0242'))
					If LerStr(009,005) >= '00001' .And. LerStr(014,001) = 'E' 
						If LerStr(169,001) = "C" //Tipo "C" no extrato
							If PARAMIXB == "D"
								_cReturn := SA6->A6_CONTA
							ElseIf PARAMIXB == "C"
								_cReturn := "110107022"
							ElseIf PARAMIXB == "V"
								Conout("Valor: "+ cValToChar(LerVal(153,016)))
								_cReturn := LerVal(153,016)
							ElseIf PARAMIXB == "H"
								Conout("Historico: "+ LerStr(177,025))
								_cReturn := LerStr(177,025)
							EndIf
						ElseIf LerStr(169,001) = "D" //Tipo "D" no extrato
							If PARAMIXB == "D"
								If LerStr(173,004) $('0127.0330') .AND. LerStr(169,001) = "D" //LIQ. DE TITULOS - ABATIMENTO
									 _cReturn := "220405010"
								ElseIf LerStr(173,004) $('0027.0284') .AND. LerStr(169,001) = "D" //IOF
									_cReturn := "420511309"
								ElseIf LerStr(173,004) $('0022') .AND. LerStr(169,001) = "D" //JUROS
									_cReturn := "420511306"
								Else
									_cReturn := "420511312"
								EndIf
							ElseIf PARAMIXB == "C"
								If LerStr(173,004) $('0127.0330') .AND. LerStr(169,001) = "D" //LIQ. DE TITULOS - ABATIMENTO
									 _cReturn := SA6->A6_CONTA
								ElseIf LerStr(173,004) $('0027.0284') .AND. LerStr(169,001) = "D" //IOF
									_cReturn := SA6->A6_CONTA
								ElseIf LerStr(173,004) $('0022.0181') .AND. LerStr(169,001) = "D" //JUROS
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
			EndIf
		EndIf

Return _cReturn