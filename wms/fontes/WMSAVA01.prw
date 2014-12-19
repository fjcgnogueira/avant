#Include "rwmake.ch"

User Function WMSAVA01()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ                        
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³WMSAVA01  ºAutor  ³Alan S. R. Oliveira º Data ³  13/12/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Programa de Impressaão de Etiquetas de Lote			      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Protheus 11                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Private _cPerg  := Padr("WMSAVA01",10)

PutSx1(_cPerg ,"01","Nota / Avulsa"		,"" ,"","mv_ch01","N",01,0,0,"C","",""   ,"","","mv_par01","Nota","","","","Avulsa","","","","","","","","","","","","","","","")
PutSx1(_cPerg, "02","Dt. Emissão?"		,"" ,"","mv_ch02","D",08,0,0,"G","",""	 ,"","","mv_par02","","","","","","","","","","","","","","","","")
PutSx1(_cPerg, "03","Número da Nota?"	,"" ,"","mv_ch03","C",09,0,0,"G","","SF1","","","mv_par03","","","","","","","","","","","","","","","","")
PutSx1(_cPerg, "04","Série da Nota?"	,"" ,"","mv_ch04","C",03,0,0,"G","",""   ,"","","mv_par04","","","","","","","","","","","","","","","","")
PutSx1(_cPerg, "05","Codigo do Produto?","" ,"","mv_ch05","C",15,0,0,"G","","SB1","","","mv_par05","","","","","","","","","","","","","","","","")
PutSx1(_cPerg, "06","Quantidade?"		,"" ,"","mv_ch06","N",04,0,0,"G","",""	 ,"","","mv_par06","","","","","","","","","","","","","","","","")
PutSx1(_cPerg, "07","Lote Avulso?"		,"" ,"","mv_ch07","C",10,0,0,"G","",""	 ,"","","mv_par07","","","","","","","","","","","","","","","","")

Pergunte(_cPerg,.T.)


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Montagem da tela                                                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

@ 200,1 TO 380,380 DIALOG oDlg TITLE "Emissão de etiquetas - Lotes "
@ 02,05 TO 070,185
@ 16,018 Say " Este programa irá imprimir etiquetas de Lotes   			 " SIZE 160,7
@ 24,018 Say " 			                                       			 " SIZE 160,7
@ 32,018 Say "                                                           " SIZE 160,7
@ 40,018 Say "                                                           " SIZE 160,7

@ 75,098 BMPBUTTON TYPE 05 ACTION Pergunte(_cPerg,.T.)
@ 75,128 BMPBUTTON TYPE 01 ACTION Processa( {|| Start() } )
@ 75,158 BMPBUTTON TYPE 02 ACTION Close(oDlg)

ACTIVATE DIALOG oDlg CENTERED

Return

Static Function Start()

cDesc1		:="Emissão de Etiqueta - Lote."
cDesc2 		:=" "
cDesc3 		:=" "
cString		:=""
aRegistros	:= {}
ctitulo	    :="Emissão de Etiqueta - Lote."
ctamanho	:= "P"
aReturn   	:=  { "Zebrado", 1,"Administracao", 2, 2, 1, "",1 }
cnomprog	:= "WMSAVA01"
nLastKey	:= 0
wnrel       := "WMSAVA01"
nPg			:= 1
nUlPg		:= 1

Processa({|| ImpSF2()})

Return .T.

Static Function ImpSF2()
                                                                         
Local _cFili, _cQuery, _cLote := ""

// DECLARACAO DE TIPOS DE FONTES
oFont10	:= TFont():New( "Arial"       		,,10  ,,.f.,,,,,.f.)
oFont10n:= TFont():New( "Arial"       		,,10  ,,.T.,,,,,.f.)
oFont12	:= TFont():New( "Arial"       		,,12  ,,.f.,,,,,.f.)
oFont12n:= TFont():New( "Arial"       		,,12  ,,.T.,,,,,.f.)
oFont13n:= TFont():New( "Arial"       		,,13  ,,.T.,,,,,.F.)
oFont14n:= TFont():New( "Arial"       		,,14  ,,.T.,,,,,.F.)
oFont12	:= TFont():New( "Arial"       		,,12  ,,.f.,,,,,.f.)
oFont15	:= TFont():New( "Arial"       		,,15  ,,.f.,,,,,.f.)
oFont20n:= TFont():New( "Arial"       		,,20  ,,.T.,,,,,.f.)
oFont40n:= TFont():New( "Arial"       		,,40  ,,.T.,,,,,.f.)

//IDENTIFICA FILIAL
IF ALLTRIM(SM0->M0_CODFIL)  == "010101"
	_cFili := "LPS SP"               
ELSEIF ALLTRIM(SM0->M0_CODFIL)  == "010102"
	_cFili := "LPS PR"
ELSEIF ALLTRIM(SM0->M0_CODFIL)  == "010103"
	_cFili := "LPS BA"
ELSEIF ALLTRIM(SM0->M0_CODFIL)  == "010104"
	_cFili := "LPS SC"
ELSE 
	_cFili := "NAO INFORMADO"
ENDIF	
//

IF mv_par01 == 1
	//BUSCA INFORMAÇÕES DO LOTE DA NOTA
	_cQuery := "SELECT "+Char(13)
	_cQuery += "	SD1.D1_LOTECTL, SD1.D1_COD, SD1.D1_FORNECE, SD1.D1_LOJA, SD1.D1_DOC, SD1.D1_SERIE, SB1.B1_DESC "+Char(13)
	_cQuery += "FROM "+Char(13)
	_cQuery += "	"+RetSqlName("SD1")+" SD1 "+Char(13)
	_cQuery += "JOIN "+RetSqlName("SB1")+" SB1 ON B1_COD = D1_COD AND SB1.D_E_L_E_T_ = '' "+Char(13)
	_cQuery += "WHERE "+Char(13)
	_cQuery += "	SD1.D1_FILIAL  = '"+CFILANT+"' "+Char(13)
	_cQuery += "AND SD1.D1_DOC     = '"+MV_PAR03+"' "+Char(13)
	_cQuery += "AND SD1.D1_SERIE   = '"+MV_PAR04+"' "+Char(13)
	_cQuery += "AND SD1.D1_COD     = '"+MV_PAR05+"' "+Char(13)
	_cQuery += "AND SD1.D1_EMISSAO = '"+DTOS(MV_PAR02)+"' "+Char(13)
	_cQuery += "AND SD1.D_E_L_E_T_ = '' "+Char(13)
	_cQuery := ChangeQuery(_cQuery)
	dbUseArea( .T., "TOPCONN", TcGenQry( ,, _cQuery ), "TRB", .F., .T. )
	
	DbSelectArea("TRB")
	DbGotop()
	
	If !Eof() 
	
		_cLote := ALLTRIM(TRB->D1_LOTECTL)
		
	Else
	
		Msginfo("Nao existem informações de Lote para este Produto..!")
	Endif
		
Else
    _cLote := mv_par07
   
Endif
	
//
If !Empty(_cLote)

	oPrn := TMSPrinter():New()
	oPrn:Setup()
	oPrn:EndPage()
	
	oPrn := tAvPrinter():New( "Protheus" )
	oPrn:StartPage()
	oPrn:Say(0, 0, " ",oFont12, 100) // startando a impressora
	
	For _nx:=1 To mv_par06
			If mv_par01 == 1
			   	oPrn:Say( 0060, 0070, _cFili+" - Id. Lote" ,oFont20n ,100)
			Else
				oPrn:Say( 0060, 0070, _cFili ,oFont20n ,100)
			Endif
		   	OPrn:Line(0130,0070,0130,1500)
		   	
		   	MSBAR("CODE3_9",1.4,2.0,Alltrim(_cLote),oPrn,.F.,Nil,Nil,0.042,1.55,Nil,Nil,"A",.F.)
		   	oPrn:Say( 0370, 0300, Alltrim(_cLote),oFont40n ,100)
		    
			OPrn:Line(0530, 0070,0530,1500)                        
			If MV_PAR01 == 1
				oPrn:Say( 0550, 0070, "FOR.: "+TRB->D1_FORNECE+"-"+TRB->D1_LOJA+" / NF.:"+TRB->D1_DOC+"-"+TRB->D1_SERIE,oFont12n ,100) 			
				oPrn:Say( 0620, 0070, "Prod: "+Alltrim(TRB->B1_DESC),oFont12n ,100) 
			Else
				oPrn:Say( 0550, 0070, "IDENTIFICACAO DE LOTE",oFont12n ,100) 
			Endif

			If _nx <> mv_par06 .AND. mv_par06 > 1 
				oPrn:EndPage()
				oPrn:StartPage()
			Endif

	Next _nx
	
	oPrn:EndPage()
	oPrn:Preview()
	
	//Set Filter To
	//dbSetOrder(1)
	
	Set device to Screen
	If aReturn[5] == 1
		Set Printer To
		dbCommitAll()
		OurSpool(wnrel)
	Endif       
	
	
	MS_FLUSH()

Endif        

If mv_par01 == 1
	DbSelectArea("TRB")
	DbCloseArea()
Endif

Close(Odlg)

Return .T.