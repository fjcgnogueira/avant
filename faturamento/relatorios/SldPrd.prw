#INCLUDE "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ SLDPRD   บ Autor ณ Rogerio Machado    บ Data ณ  30/07/2013 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Programa para gerar relatorio de Saldo dos Produtos        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico Avant                                           บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function SLDPRD()                  

Local aDados := {}
Local aCabec := {'FILIAL','CODIGO','DESCRICAO','GRUPO','ARMAZEM','SALDO DISPONIVEL','SALDO ATUAL','ENDEREวAR','RESERVA','EMPENHO','SIT_PROD'}
Local cReserv 
Private cPerg		:= 'SLDPRD'
Private cQry

//Executar fun็ใo abaixo apenas uma vez
//MontaSx1()

Pergunte(cPerg,.T.)

cQry := "SELECT DISTINCT "
cQry += " SB2.B2_FILIAL, "
cQry += " SB2.B2_COD, "
cQry += " SB1.B1_DESC, "
cQry += " SBM.BM_DESC, "
cQry += " SB2.B2_LOCAL, "
cQry += " CASE WHEN SB2.B2_QACLASS <= '0' THEN "
cQry += " SB2.B2_QATU - SB2.B2_RESERVA "
cQry += " ELSE SB2.B2_QATU - SB2.B2_QACLASS - SB2.B2_RESERVA "
cQry += " END AS [SALDO DISPONIVEL], "
cQry += " SB2.B2_QATU, "
cQry += " SB2.B2_QACLASS, "
cQry += " SB2.B2_RESERVA, "
cQry += " SB2.B2_QEMP, "
cQry += " SB1.B1_MSBLQL "
cQry += " CASE " 
cQry += " 	WHEN SB1.B1_X_STPRD = '1' THEN 'Em Linha' "
cQry += " 	WHEN SB1.B1_X_STPRD = '2' THEN 'Fora de Linha' "
cQry += " 	WHEN SB1.B1_X_STPRD = '3' THEN 'Em Analise' "
cQry += " 	ELSE '' "
cQry += "  END AS 'STD_PROD' "
cQry += " FROM " + RetSqlName("SB2") + " AS SB2 "
cQry += " INNER JOIN " + RetSqlName("SB1") + " AS SB1 ON SB2.B2_COD = SB1.B1_COD AND SB1.D_E_L_E_T_ = '' "
cQry += " INNER JOIN " + RetSqlName("SBM") + " AS SBM ON SBM.BM_FILIAL BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' AND SB1.B1_GRUPO = SBM.BM_GRUPO AND SBM.D_E_L_E_T_ = '' "

IF MV_PAR09 == 2
	cQry += " WHERE SB1.B1_MSBLQL = '2' AND "
ELSE
	cQry += " WHERE SB1.B1_MSBLQL IN('2', '1', '') AND "
ENDIF	
	
cQry += " SB2.B2_FILIAL BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' AND "
cQry += " SB2.B2_COD BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' AND "
cQry += " B2_LOCAL BETWEEN '"+MV_PAR07+"' AND '"+MV_PAR08+"' AND "
cQry += " SB1.B1_GRUPO BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"'"
cQry += " AND SB2.D_E_L_E_T_ = ''"  // Fernando Nogueira - Chamado 000036
cQry += " ORDER BY SB1.B1_DESC "

                                  
dbUseArea(.F., "TOPCONN", TCGenQry(,,cQry), "TRB", .F., .T.) 

DBSELECTAREA("TRB")
TRB->(DBGOTOP())


WHILE TRB->(!EOF())
	cReserv := cvaltochar(TRB->B2_QACLASS)
	IF cReserv <= '0'
		aadd(aDados, {'=TEXTO( '+TRB->B2_FILIAL+';"000000")', '=TEXTO( '+TRB->B2_COD+';"000000000")', TRB->B1_DESC, TRB->BM_DESC, '=TEXTO( '+TRB->B2_LOCAL+';"00")', TRB->B2_QATU - TRB->B2_RESERVA, TRB->B2_QATU, TRB->B2_QACLASS, TRB->B2_RESERVA, TRB->B2_QEMP, TRB->B1_X_STPRD})
		TRB->(DBSKIP())
	ELSE               
	  	aadd(aDados, {'=TEXTO( '+TRB->B2_FILIAL+';"000000")', '=TEXTO( '+TRB->B2_COD+';"000000000")', TRB->B1_DESC, TRB->BM_DESC, '=TEXTO( '+TRB->B2_LOCAL+';"00")', TRB->B2_QATU - TRB->B2_QACLASS - TRB->B2_RESERVA, TRB->B2_QATU, TRB->B2_QACLASS, TRB->B2_RESERVA, TRB->B2_QEMP, TRB->B1_X_STPRD})
		TRB->(DBSKIP())
	ENDIF
Enddo

MsAguarde({||DLGTOEXCEL({{"ARRAY","SALDO DE PRODUTOS",aCabec,aDados}})},"Aguarde","Aguarde! Gerando dados para a Planilha...",.F.)

TRB->(DBCLOSEAREA())                

//DlgToExcel({{"ARRAY","SALDO DE PRODUTOS",aCabec,aDados}})
	
Return   

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออปฑฑ
ฑฑบPrograma  ณ MontaSX1    บ Autor ณ Rogerio Machado    บ Data ณ30/07/2013บฑฑ
ฑฑฬออออออออออุอออออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao auxiliar										         	  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function MontaSX1()

Local aAreaAnt := GetArea()
Local aHelpP := {}

aHelpP	:= {}
aAdd(aHelpP, "") 
aAdd(aHelpP, "")                                                                                   // Consulta Padrao 
PutSx1(cPerg, '01', 'Filial de?' , 'Filial de?' , 'Filial de?' , 'mv_ch1', 'C', 6, 0, 0, 'G', '', 'XM0', '', '', 'mv_par01', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', aHelpP, aHelpP, aHelpP)  

aHelpP	:= {}
aAdd(aHelpP, "")
aAdd(aHelpP, "")
PutSx1(cPerg, '02', 'Filial ate?', 'Filial ate?', 'Filial ate?', 'mv_ch2', 'C', 6, 0, 0, 'G', '', 'XM0', '', '', 'mv_par02', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', aHelpP, aHelpP, aHelpP)

aHelpP	:= {}
aAdd(aHelpP, "")
aAdd(aHelpP, "")
PutSx1(cPerg, '03', 'Produto de?', 'Produto de?', 'Produto de?', 'mv_ch3', 'C', 9, 0, 0, 'G', '', 'SB1', '', '', 'mv_par03', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', aHelpP, aHelpP, aHelpP)

aHelpP	:= {}
aAdd(aHelpP, "")
aAdd(aHelpP, "")
PutSx1(cPerg, '04', 'Produto ate?', 'Produto ate?', 'Produto ate?', 'mv_ch4', 'C', 9, 0, 0, 'G', '', 'SB1', '', '', 'mv_par04', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', aHelpP, aHelpP, aHelpP)

aHelpP	:= {}
aAdd(aHelpP, "")
aAdd(aHelpP, "")
PutSx1(cPerg, '05', 'Grupo Prod. de?', 'Grupo Prod. de?', 'Grupo Prod. de?', 'mv_ch5', 'C', 30, 0, 0, 'G', '', 'SBM', '', '', 'mv_par05', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', aHelpP, aHelpP, aHelpP)

aHelpP	:= {}
aAdd(aHelpP, "")
aAdd(aHelpP, "")
PutSx1(cPerg, '06', 'Grupo Prod. ate?', 'Grupo Prod. ate?', 'Grupo Prod. ate?', 'mv_ch6', 'C', 30, 0, 0, 'G', '', 'SBM', '', '', 'mv_par06', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', aHelpP, aHelpP, aHelpP)

aHelpP	:= {}
aAdd(aHelpP, "")
aAdd(aHelpP, "")
PutSx1(cPerg, '07', 'Armazem de?', 'Armazem de?', 'Armazem de?', 'mv_ch7', 'C', 2, 0, 0, 'G', '', '', '', '', 'mv_par07', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', aHelpP, aHelpP, aHelpP)

aHelpP	:= {}
aAdd(aHelpP, "")
aAdd(aHelpP, "")
PutSx1(cPerg, '08', 'Armazem ate?', 'Armazem ate?', 'Armazem ate?', 'mv_ch08', 'C', 2, 0, 0, 'G', '', '', '', '', 'mv_par08', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', aHelpP, aHelpP, aHelpP)

aHelpP	:= {}
aAdd(aHelpP, "")
aAdd(aHelpP, "")
PutSx1(cPerg, '09', 'Exibe bloqueados?', 'Exibe bloqueados?', 'Exibe bloqueados??', 'mv_ch09', 'C', 1, 0, 0, 'G', '', '', 'C', '', 'mv_par09', '1-SIM', '1-SIM', '1-SIM', '2-NAO', '2-NAO', '2-NAO', '', '', '', '', '', '', '', '', '', '', aHelpP, aHelpP, aHelpP)

/*
aHelpP	:= {}
aAdd(aHelpP, "")
aAdd(aHelpP, "")
PutSx1(cPerg, '07', 'Familia Prod. de?', 'Familia Prod. de?', 'Familia Prod. de?', 'mv_ch7', 'C', 30, 0, 0, 'G', '', 'SBP', '', '', 'mv_par07', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', aHelpP, aHelpP, aHelpP)
             
aHelpP	:= {}
aAdd(aHelpP, "")
aAdd(aHelpP, "")
PutSx1(cPerg, '08', 'Familia Prod. ate?', 'Familia Prod. ate?', 'Familia Prod. ate?', 'mv_ch8', 'C', 30, 0, 0, 'G', '', 'SBP', '', '', 'mv_par08', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', aHelpP, aHelpP, aHelpP)
*/

RestArea(aAreaAnt)

Return  