#INCLUDE "Protheus.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ RFATR01  ³ Autor ³ Rodrigo Leite           ³ Data ³ 14/12/2011 ³±±
±±³          ³          ³       ³ 						  ³      ³            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Relatorio de Faturamento 							          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³ 										                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³                                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³             ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador   ³  Data  ³              Motivo da Alteracao                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³              ³        ³                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RFATR01()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Relacao de Faturamento"
Local cPict          := ""
Local titulo         := "Relacao de Faturamento "
Local nLin         	 := 80
Local Cabec1       	 := ""
Local Cabec2       	 := ""
Local imprime      	 := .T.

Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 220
Private tamanho      := "G"
Private nomeprog     := "RFATR01"
Private nTipo        := 18
Private aOrd         := {"Por Pedido"}
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "RFATR01"
Private cString 	 := "SF2"
Private cPerg   	 := "FATR01"
Private nOrdem
Private cVendedor    := ""
Private cGeren       := ""



//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

_aRegs := {}

AAdd(_aRegs,{cPerg,"01","Data de  ?      ","Data Inicial ?  ","Data Inicial ?  ","mv_ch0","D",08,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","",""})
AAdd(_aRegs,{cPerg,"02","Data ate ?      ","Data Final ?    ","Data Final ?    ","mv_ch0","D",08,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","",""})
AAdd(_aRegs,{cPerg,"05","Do Produto ?    ","Do Produto ?    ","Do Produto ?    ","mv_ch0","C",15,0,0,"G","","mv_par03","","","","","","","","","","","","","","SB1","","","","","","","","","","",""})
AAdd(_aRegs,{cPerg,"06","Ate o Produto ? ","Ate o Produto ? ","Ate o Produto ? ","mv_ch0","C",15,0,0,"G","","mv_par04","","","","","","","","","","","","","","SB1","","","","","","","","","","",""})
AAdd(_aRegs,{cPerg,"07","Cliente de ?    ","Cliente de ?    ","Cliente de?     ","mv_ch0","C",06,0,0,"G","","mv_par05","","","","","","","","","","","","","","SA1ESP","","","","","","","","","","",""})
AAdd(_aRegs,{cPerg,"08","Cliente Ate ?   ","Cliente Ate ?   ","Cliente Ate ?   ","mv_ch0","C",06,0,0,"G","","mv_par06","","","","","","","","","","","","","","SA1ESP","","","","","","","","","","",""})
AAdd(_aRegs,{cPerg,"09","Filial de ?     ","Filial de ?     ","Filial de ?     ","mv_ch0","C",06,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","",""})
AAdd(_aRegs,{cPerg,"10","Filial Ate ?    ","Filial Ate ?    ","Filial Ate ?    ","mv_ch0","C",06,0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","",""})

ValidPerg(_aRegs,cPerg)

Pergunte(cPerg,.F.)

dbSelectArea(cString)
dbSetOrder(1)

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

nTipo := If(aReturn[4]==1,15,18)
nOrdem:= aReturn[8]


//Cabec1       	 := "CLIENTE            PEDIDO           PROD        DESC.                 VALOR            VALOR              VALOR            VALOR            VALOR            VALOR               TOTAL  "
//Cabec2       	 := "                                                                      BRUTO            DEVOL              LIQUI            FRETE            SUBST            IPI"

Cabec1       	 := "CLIENTE        PEDIDO    NOTA       PROD                       DESC.                        QUANT      VALOR             VALOR            VALOR            VALOR             DEVOL              VALOR  "
Cabec2       	 := "                                                                                                       UNIT              FRETE            SUBST            IPI               EM $               TOTAL  "
                   //1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890



//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Processamento. RPTSTATUS monta janela com a regua de processamento. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³RUNREPORT º Autor ³ AP6 IDE            º Data ³  23/05/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

_tValBru     := 0
_tValDev     := 0
_tValLiq     := 0   
_tValFre     := 0   
_tValSt      := 0   
_tValIpi     := 0   
_tObjetiv    := 0   
_nObjetivo	 := 0
_ttValBru    := 0
_ttValDev    := 0
_ttValLiq    := 0   
_ttValFre    := 0   
_ttValSt     := 0   
_ttValIpi    := 0   
_cCliente   := " "
_cQuebra    := " "


geradados()	//----> query para busca dos dados de faturamento

dbSelectArea("QUERY")
SetRegua(RecCount())
dbGoTop()


Do While !Eof() 
	
		_cQuebra := QUERY->D2_PEDIDO 

	If lAbortPrint
		@nLin,000		 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif
	
	If nLin > 70
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 9
	Endif
	
	If !Empty(aReturn[7]) .And. !&(aReturn[7])
	dbSelectArea("QUERY")
		dbSkip()
		Loop
	EndIf

While !Eof() .AND. _cQuebra = QUERY->D2_PEDIDO 

nLin++

	@ nLin, 000			PSAY SUBSTR(QUERY->A1_NREDUZ,1,15)
	@ nLin, pCol()+001	PSAY QUERY->D2_PEDIDO
	@ nLin, pCol()+001	PSAY QUERY->D2_DOC
	@ nLin, pCol()+001	PSAY QUERY->D2_COD 
	@ nLin, pCol()+001	PSAY SUBSTR(QUERY->B1_DESC,1,20)
	@ nLin, pCol()+001	PSAY QUERY->D2_QUANT														 Picture "@E 9,999,999.99"  	
	@ nLin, pCol()+001	PSAY QUERY->D2_PRCVEN														 Picture "@E 9,999,999.99"  
    @ nLin, pCol()+005	PSAY QUERY->D2_VALFRETE														 Picture "@E 9,999,999.99"  
    @ nLin, pCol()+005	PSAY QUERY->D2_ICMSRET					                                     Picture "@E 9,999,999.99"  
    @ nLin, pCol()+005	PSAY QUERY->D2_VALIPI					                                     Picture "@E 9,999,999.99"  
    
	BuscaDev()	//----> query para busca dos dados de Devolução	dbSelectArea("DEVOL")
	@ nLin, pCol()+005	PSAY DEVOL->D1_TOTAL														Picture "@E 9,999,999.99"  
	@nLin, pCol()+010	PSAY QUERY->D2_TOTAL+QUERY->D2_ICMSRET+QUERY->D2_VALFRETE-DEVOL->D1_TOTAL					Picture "@E 9,999,999.99"
	
	_tValBru += QUERY->D2_PRCVEN
	_tValDev += DEVOL->D1_TOTAL
	_tValLiq += QUERY->D2_TOTAL+QUERY->D2_ICMSRET+QUERY->D2_VALFRETE-DEVOL->D1_TOTAL
	_tValFre += QUERY->D2_VALFRETE
	_tValSt	 += QUERY->D2_ICMSRET
	_tValIpi += QUERY->D2_VALIPI
	_ttValBru += QUERY->D2_PRCVEN
	_ttValDev += DEVOL->D1_TOTAL
	_ttValLiq += QUERY->D2_TOTAL+QUERY->D2_ICMSRET+QUERY->D2_VALFRETE-DEVOL->D1_TOTAL
	_ttValFre += QUERY->D2_VALFRETE
	_ttValSt  += QUERY->D2_ICMSRET
	_ttValIpi += QUERY->D2_VALIPI
	
	
	nLin++

	dbSelectArea("DEVOL")
	dbCloseArea("DEVOL")
	
	dbSelectArea("QUERY")


	
	dbSkip() 
EndDo

nLin++

If nLin > 70
	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	nLin := 9
Endif

		@ nLin, 000			PSAY (replicate("-",240))
		nLin ++
		@ nLin, 000			PSAY "Total: "
		@ nLin, pCol()+097	PSAY _tValBru			Picture "@E 9,999,999.99"  
		@ nLin, pCol()+005	PSAY _tValFre			Picture "@E 9,999,999.99"  
		@ nLin, pCol()+005	PSAY _tValSt			Picture "@E 9,999,999.99"  
		@ nLin, pCol()+005	PSAY _tValIpi			Picture "@E 9,999,999.99"  
		@ nLin, pCol()+005	PSAY _tValDev			Picture "@E 9,999,999.99"  
		@ nLin, pCol()+007	PSAY _tValLiq			Picture "@E 9,999,999.99"  

	   	nLin ++	

	_tValBru := 0
	_tValDev := 0
	_tValLiq := 0
	_tValFre := 0
	_tValSt	 := 0
	_tValIpi := 0


   //	dbSkip() 
EndDo
    
		@ nLin, 000			PSAY (replicate("-",240))
		nLin ++
		@ nLin, 000			PSAY "Total: "
		@ nLin, pCol()+097	PSAY _ttValBru			Picture "@E 9,999,999.99"  
		@ nLin, pCol()+005	PSAY _ttValFre			Picture "@E 9,999,999.99"  
		@ nLin, pCol()+005	PSAY _ttValSt			Picture "@E 9,999,999.99"  
		@ nLin, pCol()+005	PSAY _ttValIpi			Picture "@E 9,999,999.99"  
		@ nLin, pCol()+005	PSAY _ttValDev			Picture "@E 9,999,999.99"  
		@ nLin, pCol()+007	PSAY _ttValLiq			Picture "@E 9,999,999.99"  

	



dbSelectArea("QUERY")
dbCloseArea("QUERY")

SET DEVICE TO SCREEN

If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return


Static Function geradados()

Local _cQuery    := ""

	Dbselectarea("SA3")
	Dbsetorder(7)

	If DbSeek(xFilial("SA3") + __CUSERID)
		If !Empty(SA3->A3_GEREN)
			cVendedor	:= SA3->A3_COD
            else
   	    	cGeren      := SA3->A3_REGIAO
   		EndIF
	EndIf


_cQuery += "SELECT DISTINCT SA1010.A1_REGIAO,SA1010.A1_NREDUZ,SD2010.D2_DOC,SD2010.D2_COD,SD2010.D2_QUANT,SD2010.D2_PEDIDO,SB1010.B1_DESC,SD2010.D2_PRCVEN,SD2010.D2_TOTAL,SD2010.D2_SERIE ,SUM(SD2010.D2_VALFRE) AS D2_VALFRETE, "
_cQuery += "SUM(SD2010.D2_ICMSRET) AS D2_ICMSRET, SUM(SD2010.D2_VALIPI) AS D2_VALIPI "
_cQuery += "FROM SD2010 INNER JOIN "
_cQuery += "SB1010 ON SD2010.D2_COD = SB1010.B1_COD INNER JOIN "
_cQuery += "SF4010 ON SD2010.D2_TES = SF4010.F4_CODIGO INNER JOIN "
_cQuery += "SF2010 ON SD2010.D2_FILIAL = SF2010.F2_FILIAL AND SD2010.D2_CLIENTE = SF2010.F2_CLIENTE AND "
_cQuery += "SD2010.D2_LOJA = SF2010.F2_LOJA AND SD2010.D2_DOC = SF2010.F2_DOC AND "
_cQuery += "SD2010.D2_SERIE = SF2010.F2_SERIE INNER JOIN "
_cQuery += "SA1010 ON SA1010.A1_COD = SD2010.D2_CLIENTE AND SA1010.A1_LOJA = SD2010.D2_LOJA "
_cQuery += "WHERE(SD2010.D_E_L_E_T_ = '') AND (SB1010.D_E_L_E_T_ = '') AND (SA1010.D_E_L_E_T_ = '') AND (SF2010.D_E_L_E_T_ = '') AND "
_cQuery += "(SF4010.D_E_L_E_T_ = '') "
_cQuery += "AND (SD2010.D2_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"')"
_cQuery += "AND (SD2010.D2_COD BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"') "
_cQuery += "AND (SA1010.A1_COD BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"') "



	IF !Empty(cVendedor) 
_cQuery += "AND (SA1010.A1_VEND = '"+cVendedor+"') "  
  	  else
_cQuery += "AND (SA1010.A1_REGIAO = '"+cGeren+"') "  
    EndIf

_cQuery += "AND SF4010.F4_DUPLIC = 'S' AND SF2010.F2_TIPO = 'N' "
_cQuery += "GROUP BY SA1010.A1_REGIAO ,SA1010.A1_NREDUZ,SD2010.D2_COD,SD2010.D2_PEDIDO,SB1010.B1_DESC ,SD2010.D2_QUANT,SD2010.D2_PRCVEN,SD2010.D2_TOTAL,SD2010.D2_DOC,SD2010.D2_SERIE "
_cQuery += "ORDER BY SD2010.D2_DOC,SD2010.D2_SERIE "


	MemoWrit("RFATR011.sql",_cQuery)
	DbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),"QUERY",.T.,.T.)


TcSetField("QUERY","D2_TOTAL"  ,"N",TamSX3("D2_TOTAL"  )[1],TamSX3("D2_TOTAL"  )[2])
TcSetField("QUERY","D2_QUANT"  ,"N",TamSX3("D2_QUANT"  )[1],TamSX3("D2_QUANT"  )[2])

Return


Static Function BuscaDev()

Local _cQuery := ""

_cQuery += "SELECT SA1010.A1_REGIAO,SA1010.A1_VEND, SUM(SD1010.D1_TOTAL - SD1010.D1_VALDESC) AS D1_TOTAL "
_cQuery += "FROM SD1010 INNER JOIN "
_cQuery += "SD2010 ON SD1010.D1_NFORI = SD2010.D2_DOC AND SD1010.D1_SERIORI = SD2010.D2_SERIE AND " 
_cQuery += "SD1010.D1_FILIAL = SD2010.D2_FILIAL AND SD1010.D1_FORNECE = SD2010.D2_CLIENTE AND " 
_cQuery += "SD1010.D1_LOJA = SD2010.D2_LOJA AND "
_cQuery += "SD1010.D1_ITEMORI = SD2010.D2_ITEM INNER JOIN "

_cQuery += "SF4010 ON SD1010.D1_TES = SF4010.F4_CODIGO INNER JOIN "

_cQuery += "SF2010 ON SD2010.D2_FILIAL = SF2010.F2_FILIAL AND SD2010.D2_DOC = SF2010.F2_DOC AND "
_cQuery += "SD2010.D2_SERIE = SF2010.F2_SERIE INNER JOIN " 

_cQuery += "SB1010 ON SD1010.D1_COD = SB1010.B1_COD INNER JOIN "
_cQuery += "SA1010 ON SA1010.A1_COD = SD1010.D1_FORNECE AND SA1010.A1_LOJA = SD1010.D1_LOJA "
_cQuery += "WHERE (SD1010.D_E_L_E_T_ = '') AND (SD1010.D1_TIPO IN ('B', 'D')) AND (SD2010.D_E_L_E_T_ = '') AND (SF4010.D_E_L_E_T_ = '') AND "
_cQuery += "(SF2010.D_E_L_E_T_ = '') AND (SB1010.D_E_L_E_T_ = '') AND (SA1010.D_E_L_E_T_ = '') AND (SD1010.D1_DTDIGIT BETWEEN '"+DTOS(MV_PAR01)+"'"+" AND '"+DTOS(MV_PAR02)+"') "
_cQuery += " AND (SA1010.A1_COD BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"') "
	IF !Empty(cVendedor) 
_cQuery += "  AND (SA1010.A1_VEND = '"+cVendedor+"') "  
  	  else
_cQuery += "  AND (SA1010.A1_REGIAO = '"+cGeren+"') "  
    EndIf

_cQuery += "GROUP BY SA1010.A1_REGIAO,SA1010.A1_VEND "
_cQuery += "ORDER BY SA1010.A1_REGIAO,SA1010.A1_VEND "


	MemoWrit("RFATR012.sql",_cQuery)
	DbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),"DEVOL",.T.,.T.)



TcSetField("DEVOL","D1_TOTAL"  ,"N",TamSX3("D1_TOTAL"  )[1],TamSX3("D1_TOTAL"  )[2])


Return()