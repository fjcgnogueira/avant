#INCLUDE "rwmake.ch"

User Function RELARQTMS


Local cDesc1         := "Este programa tem como objetivo imprimir relatorio de Vendas"
Local cDesc2         := ""
Local cDesc3         := "RELATORIO DE VENDAS"
Local cPict          := ""
Local titulo         := "RELATORIO DE VENDAS"
Local nLin           := 80


Local Cabec1       := "FILIAL  EMISSÃO NOME 				ENDEREÇO 						BAIRRO 				  CEP 		  MUNICIPIO 		    UF"
Local Cabec2       := "123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890"
Local imprime      := .T.
Local aOrd := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite           := 220
Private tamanho          := "G"
Private nomeprog         := "RELARQTMS" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo            := 18
Private aReturn          := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey        := 0
Private cPerg			:= "VENDASA"
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "RELARQTMS" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cDtaDe
Private cDataAte
                                         

Private cString := "SF2"

dbSelectArea("SF2")
dbSetOrder(1)  

//CRIASX1(cPerg, .F.)


wnrel := SetPrint(cString,NomeProg,cPerg,titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

nTipo := If(aReturn[4]==1,15,18)

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return


Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

Local nOrdem

Pergunte(cPerg,.T.)

cDataDe := CVALTOCHAR(DTOS(MV_PAR03))
cDataAte := CVALTOCHAR(DTOS(MV_PAR04))

SetRegua(RecCount())

cQry := " SELECT "
cQry += " SD2.D2_FILIAL, "
cQry += " SF2.F2_EMISSAO, "
cQry += " SD2.D2_DOC, "
cQry += " SB1.B1_COD, "
cQry += " SB1.B1_DESC, "
cQry += " SB1.B1_X_DESCG, "
cQry += " SB1.B1_DESFAMA, "
cQry += " SD2.D2_QUANT "
/*cQry += " SD2.D2_PRCVEN, "
cQry += " SD2.D2_TOTAL, "
cQry += " SD2.D2_VALIPI, "
cQry += " SD2.D2_ICMSRET, "
cQry += " SD2.D2_VALICM, "
cQry += " SD2.D2_TOTAL + SD2.D2_VALIPI + SD2.D2_ICMSRET AS [TOTAL COM IMPOSTO], "
cQry += " SA3.A3_REGIAO, "
cQry += " SA3.A3_NOME, "
cQry += " SA3.A3_XNSUPER, "
cQry += " SA3.A3_XNGEREN "
*/		
cQry += " FROM SF2010 AS SF2 "

cQry += " INNER JOIN SD2010 AS SD2 ON "
cQry += " SD2.D2_FILIAL = SF2.F2_FILIAL AND "
cQry += " SD2.D2_DOC = SF2.F2_DOC AND "
cQry += " SD2.D2_SERIE=SF2.F2_SERIE AND "
cQry += " SD2.D2_CLIENTE = SF2.F2_CLIENTE AND "
cQry += " SD2.D2_LOJA = SF2.F2_LOJA AND " 
cQry += " SF2.D_E_L_E_T_ <> '*' "
    
cQry += " INNER JOIN SA1010 AS SA1 ON "
cQry += " SA1.A1_COD = SF2.F2_CLIENTE AND "
cQry += " SA1.A1_LOJA = SF2.F2_LOJA AND "
cQry += " SA1.D_E_L_E_T_ <> '*' "
	
cQry += " INNER JOIN SA3010 AS SA3 ON "
cQry += " SF2.F2_VEND1 = SA3.A3_COD AND "
cQry += " SA3.D_E_L_E_T_ <> '*' "

cQry += " INNER JOIN SB1010 AS SB1 ON "
cQry += " SB1.B1_COD = SD2.D2_COD AND "
cQry += " SB1.D_E_L_E_T_ <> '*' "

cQry += " INNER JOIN SF4010 AS SF4 ON "
cQry += " SD2.D2_FILIAL = SF4.F4_FILIAL AND "
cQry += " SD2.D2_TES = SF4.F4_CODIGO AND "
cQry += " SF4.D_E_L_E_T_ <> '*' "

cQry += " WHERE SD2.D2_FILIAL BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' AND SF4.F4_DUPLIC = 'S' AND "
cQry += " SF2.F2_EMISSAO BETWEEN '"+cDataDe+"' AND '"+cDataAte+"' AND SA3.A3_REGIAO BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' "

cQry += " ORDER BY SD2.D2_DOC "

/*
If SELECT((cqry)) > 1
	(cqry)->(DBCLOSEAREA())
Endif
*/

dbUseArea(.F.,"TOPCONN",TCGenQry(,,cQry),"TRB", .F., .T.)

DBSELECTAREA("TRB")
TRB->(DBGOTOP())

While TRB->(!EOF())

   If lAbortPrint
      @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
      Exit
   Endif

   If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
      nLin := 8
   Endif


   @nLin,00 PSAY TRB->D2_FILIAL
   @nLin,08 PSAY TRB->F2_EMISSAO
   @nLin,18 PSAY TRB->D2_DOC
   @nLin,26 PSAY TRB->B1_COD
   @nLin,37 PSAY TRB->B1_DESC
   @nLin,108 PSAY TRB->B1_X_DESCG
   @nLin,120 PSAY TRB->B1_DESFAMA
   @nLin,142 PSAY TRB->D2_QUANT
   
   nLin := nLin + 1 // Avanca a linha de impressao

   TRB->(dbSkip()) // Avanca o ponteiro do registro no arquivo
EndDo 

TRB->(DBCLOSEAREA())


SET DEVICE TO SCREEN

If aReturn[5]==1
   dbCommitAll()
   SET PRINTER TO
   OurSpool(wnrel)
Endif

MS_FLUSH()

Return

Static Function MontaSX1()

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
PutSx1(cPerg, '03', 'Data de?' , 'Data de?' , 'Data de?' , 'mv_ch3', 'D', 8, 0, 0, 'G', '', '', '', '', 'mv_par03', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', aHelpP, aHelpP, aHelpP)  

aHelpP	:= {}
aAdd(aHelpP, "")
aAdd(aHelpP, "")
PutSx1(cPerg, '04', 'Data ate?', 'Data ate?', 'Data ate?', 'mv_ch4', 'D', 8, 0, 0, 'G', '', '', '', '', 'mv_par04', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', aHelpP, aHelpP, aHelpP)

aHelpP	:= {}
aAdd(aHelpP, "Região do Representante") 
aAdd(aHelpP, "")                                                                              
PutSx1(cPerg, '05', 'Região de?' , 'Região de?' , 'Região de?' , 'mv_ch5', 'C', 2, 0, 0, 'G', '', '', '', '', 'mv_par05', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', aHelpP, aHelpP, aHelpP)  

aHelpP	:= {}
aAdd(aHelpP, "Região do Representante")
aAdd(aHelpP, "")
PutSx1(cPerg, '06', 'Região ate?', 'Região ate?', 'Região ate?', 'mv_ch6', 'C', 2, 0, 0, 'G', '', '', '', '', 'mv_par06', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', aHelpP, aHelpP, aHelpP)

Return  