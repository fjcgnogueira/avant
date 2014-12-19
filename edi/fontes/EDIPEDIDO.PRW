#INCLUDE "Protheus.ch"
#Include "RwMake.Ch" 

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณEDIPEDIDO บ Autor ณ Rogerio Machado    บ Data ณ 14/07/2014  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Gerar arquivo EDI com notas de saida                       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico Avant                                           บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
User Function EDIPEDIDO 

	Private oDlg 
	PRIVATE cPerg :="EDIPEDIDO" 
	
	AjustaSX1(cPerg,.T.)
	Pergunte(cPerg,.T.)
	Processa({|| Exportacao() },"Processando...") 	
		
Return 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณExportacaoบ Autor ณ Rogerio Machado    บ Data ณ 14/07/2014  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFuncao que faz a exportacao do arquivo EDI                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function Exportacao() 

Local cLinha    := ""
Local _cFilial  := ""
Local cData1
Local cData2
Local nSeq      := 0
Local _nValBrut := 0
Local _nProc    := 0

Local _cArqTxt := "XX"
Private nHdl 
Private cPerg := "EDIPEDIDO"


BeginSql alias 'TRB'

		SELECT F2_FILIAL, F2_CLIENTE, F2_LOJA, F2_DOC, F2_SERIE, F2_TRANSP, F2_EMISSAO, F2_HORA, F2_EXPEDID, F2_TPFRETE, F2_CHVNFE, F2_VALMERC, F2_BASEICM, F2_VALICM, F2_BASEIPI, F2_VALIPI  
		FROM %table:SF2% SF2
		WHERE SF2.%notDel% AND F2_CLIENTE = (%exp:MV_PAR03%) 

EndSql

TRB->(DbGoTop())

// Alimenta contador para regua de processamento
While (TRB->(!Eof()))
	_nProc++
	TRB->(DbSkip())
EndDo


TRB->(DbGoTop())

ProcRegua(_nProc)
While (TRB->(!Eof()))
	
	_cArqTxt := "\Neogrid_Mercantil\Makro\NF\NF-"+ALLTRIM(TRB->F2_DOC)+ "-" + ALLTRIM(TRB->F2_SERIE)+".TXT"  
	nHdl      := fCreate(_cArqTxt,,,.F.)
	cLinha    := ""
	_nValBrut := 0 

	IncProc("Processando...") 
	
   	SD2->(DBSetOrder(3))
    SD2->(DbGoTop())
	SD2->(DBSeek(xFilial("SD2")+TRB->F2_DOC+TRB->F2_SERIE))	

   	SA1->(DBSetOrder(1))
    SA1->(DbGoTop())
	SA1->(DBSeek(xFilial("SA1")+TRB->F2_CLIENTE+TRB->F2_LOJA))

	SA4->(DBSetOrder(1))
    SA4->(DbGoTop())
	SA4->(DBSeek(xFilial("SA4")+TRB->F2_TRANSP))
	
	SE1->(DBSetOrder(1))
    SE1->(DbGoTop())
	SE1->(DBSeek(xFilial("SE1")+"1  "+TRB->F2_DOC))
	
	SB1->(DBSetOrder(1))
    SB1->(DbGoTop())
	SB1->(DBSeek(xFilial("SB1")+SD2->D2_COD))
	
	
	// Informacoes do Registro 01	
	cLinha += "01" 												//01
	cLinha += "9  " 												//02	
    cLinha += "325" 												//03
    cLinha += PADR(ALLTRIM(TRB->F2_DOC),9," ")					//04
    cLinha += PADR(ALLTRIM(TRB->F2_SERIE),3," ")				//05
    cLinha += PADR(" ",2," ")							//06
 	cLinha += PADL(ALLTRIM(TRB->F2_EMISSAO),8,"0")+STUFF(TRB->F2_HORA,3,1,"") 	//07
 	cLinha += PADL(ALLTRIM(RIGHT(TRB->F2_EXPEDID,4)+SUBSTR(TRB->F2_EXPEDID,3,2)+LEFT(TRB->F2_EXPEDID,2)),8,"0")+"0000" //08
	cLinha += PADL(ALLTRIM(RIGHT(TRB->F2_EXPEDID,4)+SUBSTR(TRB->F2_EXPEDID,3,2)+LEFT(TRB->F2_EXPEDID,2)),8,"0")+"0000" //9   	
   	cLinha += PADR(ALLTRIM(SD2->D2_CF),5," ")					//10
   	cLinha += PADR(ALLTRIM(SZJ->ZJ_PEDCLI),20," ") 			//11
   	cLinha += PADR(ALLTRIM(SD2->D2_PEDIDO),20," ")			//12
   	cLinha += Space(15)											//13
   	cLinha += Space(15)		 									//14
   	cLinha += Space(13)		 									//15
   	cLinha += Space(13)		 									//16
   	cLinha += Space(13)		 									//17
   	cLinha += "7898238930014" 									//18
   	cLinha += "7898238930014" 									//19
	cLinha += PADR(ALLTRIM(SA1->A1_CGC),14," ") 				//20
	cLinha += PADR(ALLTRIM(SA1->A1_CGC),14," ") 				//21
	cLinha += PADR(ALLTRIM(SA1->A1_CGC),14," ") 				//22
	cLinha += ALLTRIM(SM0->M0_CGC) 								//23
	cLinha += PADR(ALLTRIM(SM0->M0_CGC),14," ") 				//24
	cLinha += PADR(ALLTRIM(SM0->M0_ESTENT),2," ") 		    //25
	cLinha += PADR(ALLTRIM(SM0->M0_INSC),20," ") 				//26		
	cLinha += "251" 												//27
	cLinha += PADR(ALLTRIM(SA4->A4_CGC),14," ") 				//28
	cLinha += Space(30)							 				//29

	IF TRB->F2_TPFRETE == "C"
		cLinha += "CIF" 											//30
	ELSE
		cLinha += "FOB" 											//30
	ENDIF
	
	cLinha += PADL(ALLTRIM(TRB->F2_CHVNFE),44,"0") 			//31   	       	    
	cLinha += CHR(13)+CHR(10)

	// Informacoes do Registro 02
	cLinha += PADR("02"   ,02," ") 	//01		
	cLinha += PADR("1"    ,03," ")	//02
	cLinha += PADR("66"   ,03," ") 	//03				
	cLinha += PADR(""     ,03," ")	//04
	cLinha += PADR("CD"   ,03," ") 	//05
	cLinha += PADL("02"   ,03,"0") 	//06
	cLinha += PADL(ALLTRIM(DTOS(SE1->E1_VENCREA)),08,"0")	//07 verificar
	cLinha += PADR("12E"  ,03," ") 	//08
	cLinha += PADL(""     ,05,"0")	//09
	cLinha += PADR("262"  ,03,"0") 	//10 verificar		
	cLinha += PADL(""     ,15,"0") 	//11 verificar
	cLinha += CHR(13)+CHR(10)
	
	// Informacoes do Registro 03
	cLinha += PADR("03",2,"0") 		//01
	cLinha += PADR("",5,"0")  		//02		
	cLinha += PADR("",15,"0") 		//03		
	cLinha += PADR("",5,"0")		    //04			
	cLinha += PADR("",15,"0") 		//05				
	cLinha += PADR("",5,"0")			//06		
	cLinha += PADR("",15,"0") 		//07				
	cLinha += PADR("",5,"0")			//08
	cLinha += PADR("",15,"0") 		//09
	cLinha += PADR("",5,"0")			//10
	cLinha += PADR("",15,"0")		//11
	cLinha += PADR("",5,"0")			//12
	cLinha += PADR("",15,"0") 		//13
	cLinha += CHR(13)+CHR(10)												
			    

	// Informacoes do Registro 04
	nSeq := 1 
	
	While (!SD2->(Eof()) .AND. SD2->D2_FILIAL+SD2->D2_DOC+SD2->D2_SERIE == xFilial("SD2")+TRB->F2_DOC+TRB->F2_SERIE)
	
		SB1->(DBSetOrder(1))
    	SB1->(DbGoTop())
		SB1->(DBSeek(xFilial("SB1")+SD2->D2_COD))	

	
		cLinha += PADR("04",2,"0") 						//01
		cLinha += PADL(nSeq,4,"0") 						//02
		nSeq := nSeq + 1
		cLinha += PADL(SD2->D2_ITEM,5,"0") 				//03
		cLinha += PADR("EN",03," ") 						//04
		cLinha += PADR(SB1->B1_CODBAR,14," ")			//05 verificar ************
		cLinha += PADR("",20," ") 						//06
		cLinha += PADR("EA",3," ")		 				//07
		cLinha += PADR("0",5,"0") 						//08												
		cLinha += PADL(SD2->D2_QUANT*100,15,"0")	//09
		cLinha += PADR("",3," ") 						//10
		cLinha += PADL(SD2->D2_VALBRUT*100,15,"0") 	//11
		cLinha += PADL(SD2->D2_TOTAL*100,15,"0") 		//12
		cLinha += PADL(SD2->D2_PRUNIT*100,15,"0") 		//13
		cLinha += PADL(SD2->D2_PRCVEN*100,15,"0") 		//14
		cLinha += PADL("",20," ") 						//15
		cLinha += PADL("",20," ") 						//16
		cLinha += PADL("",15,"0") 						//17
		cLinha += PADL("",15,"0") 						//18
		cLinha += PADL("",14," ") 						//19
		cLinha += PADL("",5," ") 						//20
		cLinha += PADR(SD2->D2_CF,5," ")				//21
		cLinha += PADL("",5,"0") 						//22
		cLinha += PADL("",15,"0") 						//23
		cLinha += PADL("",5,"0") 						//24
		cLinha += PADL("",15,"0") 						//26
		cLinha += PADL("",5,"0") 						//27
		cLinha += PADL("",15,"0") 						//28
		cLinha += PADL("",5,"0") 						//29
		cLinha += PADL("",15,"0") 						//30
		cLinha += PADL(SD2->D2_IPI*100,5,"0")			//31
		cLinha += PADL(SD2->D2_VALIPI*100,15,"0") 		//32			
		cLinha += PADL("",5,"0") 						//33
		cLinha += PADL("",15,"0") 						//34
		cLinha += PADL("",5,"0") 						//35
		cLinha += PADL("",15,"0") 						//36
		cLinha += PADL("",5,"0") 						//37															
		cLinha += PADL("",15,"0") 						//38
		cLinha += PADL("",5,"0") 						//39																														
		cLinha += PADL("",15,"0") 						//40
		cLinha += PADL("",2,"0") 						//41
		cLinha += PADL("",5,"0") 						//42
		cLinha += PADL("",5,"0") 						//43
		cLinha += PADL("",5,"0") 						//44
		cLinha += PADL("",5,"0") 						//45
		cLinha += PADL("",5,"0") 						//46
		cLinha += PADL("",5,"0") 						//47
		cLinha += CHR(13)+CHR(10)
		//_nValBrut += SD2->D2_VALBRUT
	
		SD2->(DbSkip())
	EndDo
	
	// Informacoes do Registro 09
	cLinha += PADR("09",2,"0") 					//01
	cLinha += PADR("",4,"0") 					//02
	cLinha += PADR("0",15,"0") 					//03
	cLinha += PADL("",15,"0")					//04
	cLinha += PADL("",15,"0") 					//05
	cLinha += PADL("",15,"0") 					//06
	cLinha += PADL(SF2->F2_VALMERC*100,15,"0") 		//07
	cLinha += PADL("",15,"0") 					//08
	cLinha += PADL("",15,"0") 					//09
	cLinha += PADL("",15,"0") 					//10
	cLinha += PADL("",15,"0") 					//11
	cLinha += PADL("",15,"0") 					//12
	cLinha += PADL("",15,"0") 					//13
	cLinha += PADL(TRB->F2_BASEICM*100,15,"0") 	//14
	cLinha += PADL(TRB->F2_VALICM*100,15,"0") 	//15
	cLinha += PADL("",15,"0") 					//16
	cLinha += PADL("",15,"0") 					//17
	cLinha += PADL("",15,"0") 					//18
	cLinha += PADL("",15,"0") 					//19
	cLinha += PADL(TRB->F2_BASEIPI*100,15,"0") 	//20
	cLinha += PADL(TRB->F2_VALIPI*100,15,"0")	 	//21
	cLinha += PADL(TRB->F2_VALMERC*100,15,"0") 	//22
			       
    // Gravacao do Arquivo
    fWrite(nHdl,cLinha,Len(cLinha))
	    
	TRB->(DbSkip())
EndDo
 
MsgInfo("Arquivos gerados com sucesso! " + CHR(13)+CHR(10) + LEFT(ALLTRIM(_cArqTxt),28))

 
Return 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAjustaSX1 บ Autor ณ Rogerio Machado    บ Data ณ 14/07/2014  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFuncao auxiliar                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function AjustaSX1(cPerg)

	Local aAreaAnt := GetArea()
	
	aHelpPor := {"Escolha a filial inicial"}
	PutSX1(cPerg,"01","Filial de?","Filial de?","Filial de?","mv_ch1","C",6,0,0,"G","",'XM0',"","","mv_par01","","","","","","","","","","","","","","","","",aHelpPor,"","")

	aHelpPor := {"Escolha a filial final"}
	PutSX1(cPerg,"02","Filial ate?","Filial ate?","Filial ate?","mv_ch2","C",6,0,0,"G","",'XM0',"","","mv_par02","","","","","","","","","","","","","","","","",aHelpPor,"","")
	
	aHelpPor := {"Escolha o cliente"}
	PutSX1(cPerg,"03","Cliente ?","Cliente ?","Cliente ?","mv_ch3","C",6,0,0,"G","",'SA1',"","","mv_par03","","","","","","","","","","","","","","","","",aHelpPor,"","")

	RestArea(aAreaAnt)      

Return Nil