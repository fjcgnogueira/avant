#INCLUDE "PROTHEUS.CH"
#INCLUDE "FONT.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ ZERASLD  บAutor  ณ Reinaldo Dias      บ Data ณ  30/09/2009 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Programa para zerar o saldo por almoxarifado.              บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ WMS                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function ZERASLD()   
Local oDlg
Private nOpcao := 1

DEFINE MSDIALOG oDlg TITLE "Executa Rotinas" OF oMainWnd PIXEL FROM 120,170 TO 400,650
@ 010,010 RADIO  oOpcao VAR nOpcao 3D PROMPT "1. Zerar estoque sem o controle de endereco e lote" SIZE 220,20 PIXEL OF oDlg 
@ 110,110 BUTTON "&Executar" SIZE 36,16 PIXEL ACTION fRun()
@ 110,190 BUTTON "&Sair"     SIZE 36,16 PIXEL ACTION oDlg:End()
ACTIVATE MSDIALOG oDlg  CENTERED

Return


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function fRun()
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Do Case                                      
   Case nOpcao == 1; Processa( {|| fRun1()})
EndCase   
Return


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function fRun1()
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
IF GETMV("MV_LOCALIZ") = "S" .Or. GETMV("MV_RASTRO") = "S" 
   MsgStop("Os parametros MV_LOCALIZ e/ou MV_RASTRO devem estar igual 'N'ใo.")
   Return
Endif

aArea       := GetArea()
cLocal 		:= "01" 
cAliasSB2	:= "TMPSB2"

cQuery:= "SELECT DISTINCT(B2_LOCAL) "
cQuery+= "FROM "+RetSqlName("SB2")+" "
cQuery+= "WHERE B2_FILIAL = '"+xFilial("SB2")+"' " 
cQuery+= "  AND D_E_L_E_T_ <> '*'"
cQuery:= ChangeQuery(cQuery)                     

DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cAliasSB2, .F., .T.)
(cAliasSB2)->(DbGoTop()) 

while (cAliasSB2)->(!Eof())
	cLocal:= (cAliasSB2)->(B2_LOCAL)    
	
	SB2->(DBSetOrder(2)) //B2_FILIAL+B2_LOCAL+STR(B2_QACLASS,12,2)
	SB2->(DBGOTOP())
	SB2->(DBSeek(xFilial("SB2")+cLocal))
	
	ProcRegua(RecCount())
	
	While SB2->(!Eof()) .AND. xFilial("SB2")+cLocal == SB2->(B2_FILIAL+B2_LOCAL)
	  
	  IncProc("Executando Opcao 1 ==> "+SB2->B2_COD +" / Alm: "+SB2->B2_LOCAL)
	  
	  cTM := IF(SB2->B2_QATU > 0,"501","200")
	     
	  MOVTOINT("ZERAB2",SB2->B2_COD,SB2->B2_LOCAL,cTM,Space(15),SB2->B2_QATU)
	   
	  SB2->(DBSkip())
	End
	(cAliasSB2)->(DbSkip())
End	
MsgInfo("Processamento Concluido !!!")

DbCloseArea("TMPSB2")
RestArea(aArea)

Return
                 

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function MOVTOINT(cDoc,cProduto,cLocal,cTM,cLocaliz,nQtde,dDTVALI)
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Local aCusto    := {0,0,0,0,0}
Local aCM       :={}
Local lBaixaEmp :=.F.
Local lBxEmpB8  :=.F. 
Local aSB2Area  := SB2->(GetArea())
Local aSF5Area  := SF5->(GetArea())
Local aSB1Area  := SB1->(GetArea())
Local aSD3Area  := SD3->(GetArea())
Local lRet      := .F.
Local lQtdZero  := .F.

IF nQtde < 0
   nQtde := (nQtde * -1)
Endif

IF nQtde = 0
   Return
Endif

DBSelectArea("SF5")         
DBSetOrder(1)
IF !DBSeek(xFilial("SF5")+cTM)
   MsgStop("O Tipo de Movimento "+cTM+" nใo foi cadastrado !!!")
   Return
Endif

 Begin Transaction
  DBSelectArea("SB1")
  DBSetOrder(1)
  DBSeek(xFilial("SB1")+cProduto)
  If (SB1->B1_APROPRI == "I" .And. Empty(SD3->D3_OP)) .And. SF5->F5_APROPR != "S"
      cApropri := "3"
  Else
      cApropri := "0"
  EndIf
  If cApropri == "0" .And. SF5->F5_VAL == "S"
     cApropri := "6"
  Endif

  cNumSeq := ProxNum()
     
  DBSelectArea("SD3")
  RecLock("SD3",.T.)
  SD3->D3_FILIAL  := xFilial("SD3")
  SD3->D3_EMISSAO := dDatabase
  SD3->D3_TM      := cTM
  SD3->D3_DOC     := cDoc
  SD3->D3_COD     := cProduto
  SD3->D3_LOCAL   := cLocal
  SD3->D3_LOCALIZ := cLocaliz
  SD3->D3_QUANT   := nQtde
  SD3->D3_QTSEGUM := ConvUM(cProduto,nQtde,0,2) // 2UM
//SD3->D3_LOTECTL := ""
//SD3->D3_DTVALID := 
  SD3->D3_GRUPO   := SB1->B1_GRUPO
  SD3->D3_TIPO    := SB1->B1_TIPO
  SD3->D3_UM      := SB1->B1_UM
  SD3->D3_SEGUM   := SB1->B1_SEGUM
  SD3->D3_USUARIO := SubStr(cUsuario,7,15)
  SD3->D3_NUMSEQ  := cNumSeq
  If SD3->D3_TM <= "500"
     SD3->D3_CF := "DE"+cApropri
  Else
     SD3->D3_CF := "RE"+cApropri
  EndIf
  SD3->D3_CHAVE   := SubStr(SD3->D3_CF,2,1)+IIF(D3_CF=="DE4","9","0")
  MsUnlock()

  If cApropri != "6"
	 If cApropri == "3" .And. SD3->D3_TM <= "500"
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Pega os 5 custos medios atuais do almoxarifado de processo. ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		aCM := PegaCMAtu(SD3->D3_COD,GetMv("MV_LOCPROC"))
	 Else
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Pega os 5 custos medios atuais             ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		aCM := PegaCMAtu(SD3->D3_COD,SD3->D3_LOCAL)
	 EndIf
  Else
	 aCM := Array(05)
 	 For nI:=1 To 5
		aCM[nI] := IIf(&(Eval(bBloco,"SD3->D3_CUSTO",nI))=0,0,&(Eval(bBloco,"SD3->D3_CUSTO",nI))/If(lQtdZero,1,SD3->D3_QUANT))
	 Next
  Endif

  //ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
  //ณ Grava o custo da movimentacao              ณ
  //ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
  aCusto := GravaCusD3(aCM,NIL,NIL,NIL,lQtdZero)

  lRet := B2AtuComD3(aCusto,NIL,NIL,lBaixaEmp,NIL,.T.,lBxEmpB8)
  IF lRet       
     DisarmTransaction()
     Break   
  Endif
End Transaction

RestArea(aSD3Area)
RestArea(aSB1Area)
RestArea(aSF5Area)
RestArea(aSB2Area)

Return (lRet)