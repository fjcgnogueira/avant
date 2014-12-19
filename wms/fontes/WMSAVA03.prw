#Include "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ WMSAVA03 º Autor ³ Fernando Nogueira  º Data ³ 02/12/2014  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Programa de Impressao de Etiquetas de Transportadora do    º±±
±±º          ³ Pedido de Vendas                                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Avant                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function WMSAVA03()

Private cPerg := Padr("WMSAVA03",10)

PutSx1(cPerg,"01","Pedido de Venda?"   	,""	,""	,"mv_ch1"	,"C"	,6	,0	,0	,"G"	,""	,"SC5","","","MV_PAR01","","","","","","","","","","","","","","","","")
PutSx1(cPerg,"02","Inicia Etiqueta?"	,""	,""	,"mv_ch2"	,"N"	,4	,0	,0	,"G"	,""	,""   ,"","","MV_PAR02","","","","","","","","","","","","","","","","")

Pergunte(cPerg,.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Montagem da tela                                                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

@ 200,001 TO 380,380 DIALOG oDlg TITLE "Emissão de etiquetas do Pedido - Transportes"
@ 002,005 TO 070,185
@ 016,018 Say " Este programa irá imprimir etiquetas com os dados do      " SIZE 160,7
@ 024,018 Say " Pedido de Vendas para a transportadora                    " SIZE 160,7
@ 032,018 Say "                                                           " SIZE 160,7
@ 040,018 Say "                                                           " SIZE 160,7

@ 075,098 BMPBUTTON TYPE 05 ACTION Pergunte(cPerg,.T.)
@ 075,128 BMPBUTTON TYPE 01 ACTION Processa( {|| Impressao() } )
@ 075,158 BMPBUTTON TYPE 02 ACTION Close(oDlg)

ACTIVATE DIALOG oDlg CENTERED

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ Impressao ³ Autor ³ Fernando Nogueira  ³ Data  ³ 02/12/14 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Impressao da Etiqueta                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Impressao()

cDesc1		:= "Emissão dfer Etiqueta do Pedido - Transportes."
cDesc2 		:= " "
cDesc3 		:= " "
cString		:= "SC5"
aRegistros	:= {}
cTitulo	    := "Emissão de Etiqueta do Pedido - Transportes."
cTamanho	:= "P"
aReturn   	:= { "Zebrado", 1,"Administracao", 2, 2, 1, "",1 }
cNomprog	:= "WMSAVA03"
nLastKey	:= 0
wnrel       := "WMSAVA03"
nPg			:= 1
nUlPg		:= 1

Processa({|| ImpPed()})

Return .T.

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ ImpPed    ³ Autor ³ Fernando Nogueira  ³ Data  ³ 02/12/14 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Impressao da Etiqueta do Pedido                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ImpPed()

Local _cNome, _cMun, _cEst, _cBairro := ""
Local aPedidos := {}

// Posicao das etiquetas.
nLin    := 0   
nEtq    := 0
_nImp   := 0

nCol1	:= 0070
nCol2 	:= 1250

nLin01	:= 0140
nLin02 	:= 0440
nLin03 	:= 0740
nLin04 	:= 1040
nLin05 	:= 1340
nLin06 	:= 1640
nLin07 	:= 1940
nLin08 	:= 2240
nLin09	:= 2540
nLin10 	:= 2840

aLin 	:= { nLin01, nLin02, nLin03, nLin04, nLin05, nLin06, nLin07, nLin08, nLin09, nLin10}

// DECLARACAO DE TIPOS DE FONTES
oFont10	 := TFont():New( "Arial"       		,,10  ,,.f.,,,,,.f.)
oFont10n := TFont():New( "Arial"       		,,10  ,,.T.,,,,,.f.)
oFont12	 := TFont():New( "Arial"       		,,12  ,,.f.,,,,,.f.)
oFont12n := TFont():New( "Arial"       		,,12  ,,.T.,,,,,.f.)
oFont13n := TFont():New( "Arial"       		,,13  ,,.T.,,,,,.F.)
oFont14n := TFont():New( "Arial"       		,,14  ,,.T.,,,,,.F.)
oFont12	 := TFont():New( "Arial"       		,,12  ,,.f.,,,,,.f.)
oFont15	 := TFont():New( "Arial"       		,,15  ,,.f.,,,,,.f.)
oFont20	 := TFont():New( "Arial"       		,,20  ,,.f.,,,,,.f.)

oPrn := TMSPrinter():New()
oPrn:Setup()
oPrn:EndPage()

oPrn := tAvPrinter():New( "Protheus" )
oPrn:StartPage()
oPrn:Say(0, 0, " ",oFont12, 100) // startando a impressora

nCountLin := 1
nCountCol := 1

//Posiciona em Pedido de Venda
dbSelectarea("SC5")
SC5->(dbSetorder(1))
SC5->(dbGoTop())
If SC5->(dbSeek(xFilial("SC5") + MV_PAR01))
	While !SC5->(Eof()) .And. 	SC5->C5_FILIAL == xFilial("SC5") .And.;
								SC5->C5_NUM    == MV_PAR01

			If Ascan(aPedidos, {|x| x == SC5->C5_NUM }) == 0
				Aadd(aPedidos,	SC5->C5_NUM)
			EndIf
			
		SC5->(DbSkip())
	End
Else
	Alert("Não encontrado o Pedido: " + MV_PAR01, "Verifique")
EndIf

If Len(aPedidos) > 0

	For nX := 1 To Len(aPedidos)
		
		//Busca Informacoes do Pedido
		DbSelectArea("SC5")
		DbSetOrder(1)
		DbSeek(xFilial("SC5") + aPedidos[nX])

		nEtq := SC5->C5_VOLUME1
		
		IF !SC5->(EOF())               
			If SC5->C5_TIPO $ ("N/C/I/P")
			   	DbSelectArea("SA1")
			   	DbSetOrder(1)
			   	DbSeek(xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI)
		  	
			   	_cNome   := ALLTRIM(SA1->A1_NOME)
			   	_cMun    := ALLTRIM(SA1->A1_MUN)
			   	_cEst    := ALLTRIM(SA1->A1_EST)
			   	_cBairro := ALLTRIM(SA1->A1_BAIRRO)
			Else
		    	DbSelectArea("SA2")
			   	DbSetOrder(1)
			   	DbSeek(xFilial("SA2")+SC5->C5_CLIENTE+SC5->C5_LOJACLI)
			   	
			   	_cNome   := ALLTRIM(SA2->A2_NOME)
			   	_cMun    := ALLTRIM(SA2->A2_MUN)
			   	_cEst    := ALLTRIM(SA2->A2_EST)
			   	_cBairro := ALLTRIM(SA2->A2_BAIRRO)
		
			Endif
			
			// Fernando Nogueira - Chamado 
			If nCountLin > 10
				nCountLin := 1
			Endif
			    
			nLin  := aLin[nCountLin]    
			_nImp := IIF(MV_PAR02 == 0, 1, MV_PAR02)                 
			
			//IMPRESSAO DE ITENS RECURSO UTILIZADO PARA IMPRESSÃO DE APENAS UMA FOLHA
			//EM REGIME PARCIAL.
			
		 	If _nImp >=1 .and. _nImp <= 2
			   nLin := aLin[1]		
		  	   nCountLin := 1
			Elseif _nImp >=3 .and. _nImp <= 4                                                         
				nLin := aLin[2]		
		  	   nCountLin := 2		
			Elseif _nImp >=5 .and. _nImp <= 6                                                         
				nLin := aLin[3]		
		  	   nCountLin := 3		
			Elseif _nImp >=7 .and. _nImp <= 8                                                         
				nLin := aLin[4]		
		  	   nCountLin := 4		
			Elseif _nImp >=9 .and. _nImp <= 10
				nLin := aLin[5]		
		  	   nCountLin := 5		
			Elseif _nImp >=11 .and. _nImp <= 12
				nLin := aLin[6]		
		  	   nCountLin := 6		
			Elseif _nImp >=13 .and. _nImp <= 14
				nLin := aLin[7]		
		  	   nCountLin := 7		
			Elseif _nImp >=15 .and. _nImp <= 16
				nLin := aLin[8]		
		  	   nCountLin := 8		
			Elseif _nImp >=17 .and. _nImp <= 18
				nLin := aLin[9]		
		  	   nCountLin := 9		
			Elseif _nImp >=19 .and. _nImp <= 20                                                         
				nLin := aLin[10]
		  	    nCountLin := 10		
			Endif		
			                                                         
			For _nx := _nImp To nEtq
		
				If nCountLin > 10
			    	oPrn:EndPage()
					oPrn:StartPage()
					nCountLin := 1 
					nLin := aLin[nCountLin]		
				EndIf

			    //VERIFICA A COLUNA QUE SERÁ IMPRESSA
				If Mod(_nx, 2) == 0
					nCol := nCol2
				Else	   	
					nCol := nCol1
				EndIf
			    
			    nLin := nLin + 10       
			
			   	oPrn:Say( nLin, nCol, ALLTRIM(_cNome),oFont12n ,100)
			   	nLin := nLin + 52
			
				oPrn:Say( nLin, nCol, _cMun+" - "+_cEst+Space(20)+ALLTRIM(_cBairro),oFont12 ,100)
				nLin := nLin + 52
					
				oPrn:Say( nLin, nCol, "Pedido:"+SC5->C5_NUM,oFont12 ,100)           
				
				oPrn:Say( nLin, nCol+403, Space(10)+ "Volume:" + Strzero(_nx,2) + " / " + Alltrim(Str(nEtq)),oFont12 ,100)
				nLin := nLin + 52                                  	
			
				oPrn:Say( nLin, nCol, "Transportadora:"+Substr(Posicione("SA4",1,xFilial("SA4")+SC5->C5_TRANSP,"A4_NREDUZ"),1,18)+ " - "+Alltrim(Str(_nx)),oFont12n ,100) 
			    nLin := nLin + 52               
			    
			    If Mod(_nx, 2) == 0
			    	nCountLin ++
			    	If nCountLin <= 10
						nLin := aLin[nCountLin]  
					Endif
				Else
					nLin := aLin[nCountLin]		
				Endif
			
			Next _nx  
			
		Endif

	Next nX		
	
	oPrn:EndPage()
	oPrn:Preview()

EndIf

Set Filter To
dbSetOrder(1)

Set device to Screen
If aReturn[5] == 1
	Set Printer To
	dbCommitAll()
	OurSpool(wnrel)
Endif

MS_FLUSH()

Close(Odlg)

Return .T.