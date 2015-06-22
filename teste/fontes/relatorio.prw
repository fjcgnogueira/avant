#Include "PROTHEUS.Ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±
±±³Fun‡…o	 ³ Ctbr510	³ Autor ³ Wagner Mobile Costa	 ³ Data ³ 15.10.01 ³±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±
±±³Descri‡…o ³ Demonstracao de Resultados                 			  	   ³±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±
±±³Retorno	 ³ Nenhum       											   ³±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±
±±³Parametros³ Nenhum													   ³±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function CtbR510()          

Private dFinalA
Private dFinal
Private nomeprog	:= "CTBR510"    
Private dPeriodo0
Private cRetSX5SL := ""

AjSX1Descric()

If FindFunction("TRepInUse") .And. TRepInUse() 
	U_CTBR510R4()
Else
	Return U_R510RF()
EndIf

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³ CTBR510R4 ³ Autor³ Daniel Sakavicius		³ Data ³ 17/08/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Demostrativo de balancos patrimoniais - R4		          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ CTBR115R4												  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ SIGACTB                                    				  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function CTBR510R4()                           

PRIVATE CPERG	   	:= "CTR510"        

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Interface de impressao                                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ            
CtAjustSx1('CTR510')
Pergunte( CPERG, .T. )

// faz a validação do livro
if ! VdSetOfBook( mv_par02 , .T. )
   return .F.
endif

oReport := ReportDef()      

If VALTYPE( oReport ) == "O"
	oReport :PrintDialog()      
EndIf

oReport := nil

Return                                

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ReportDef ³ Autor ³ Daniel Sakavicius		³ Data ³ 17/08/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Esta funcao tem como objetivo definir as secoes, celulas,   ³±±
±±³          ³totalizadores do relatorio que poderao ser configurados     ³±±
±±³          ³pelo relatorio.                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ SIGACTB                                    				  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß    
/*/          
Static Function ReportDef()     

Local aSetOfBook	:= CTBSetOf(mv_par02)
Local aCtbMoeda	:= {}
Local cDescMoeda 	:= ""
local aArea	   	:= GetArea()   
Local CREPORT		:= "CTBR510"
Local CTITULO		:= 'DEMONSTRACAO DE RESULTADOS'				// DEMONSTRACAO DE RESULTADOS
Local CDESC			:= "Este programa irá imprimir a Demonstração de Resultados "		//"de acordo com os parâmetros informados pelo usuário."
Local aTamDesc		:= TAMSX3("CTS_DESCCG")  
Local aTamVal		:= TAMSX3("CT2_VALOR")
                 
aCtbMoeda := CtbMoeda(mv_par03, aSetOfBook[9])
cDescMoeda 	:= AllTrim(aCtbMoeda[3])

If Empty(aCtbMoeda[1])                       
	Help(" ",1,"NOMOEDA")
    Return .F.
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se usa Set Of Books + Plano Gerencial (Se usar Plano³
//³ Gerencial -> montagem especifica para impressao)				  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !ct040Valid(mv_par02)
	Return
EndIf	
             
lMovPeriodo	:= (mv_par13 == 1)

If mv_par09 == 1												/// SE DEVE CONSIDERAR TODO O CALENDARIO
	CTG->(DbSeek(xFilial() + mv_par01))
	If Empty(mv_par08)
		While CTG->CTG_FILIAL = xFilial("CTG") .And. CTG->CTG_CALEND = mv_par01
			dFinal	:= CTG->CTG_DTFIM
			CTG->(DbSkip())
		EndDo
	Else
		dFinal	:= mv_par08
	EndIf
	dFinalA   	:= Ctod(Left(Dtoc(dFinal), 6) + Str(Year(dFinal) - 1, 4))
	If Empty ( dFinalA )
		If MONTH(dFinal) == 2
			If Day(dFinal) > 28 .and. Day(dFinal) == 29
				dFinalA := Ctod(Left( STRTRAN ( Dtoc(dFinal) , "29" , "28" ), 6) + Str(Year(dFinal) - 1, 4))
			EndIf
		EndIf
	EndIf	
	mv_par01    := dFinal
	If lMovPeriodo
		dPeriodo0 	:= Ctod(Left(Dtoc(dFinal), 6) + Str(Year(dFinal) - 2, 4)) + 1
	EndIf
Else															/// SE DEVE CONSIDERAR O PERIODO CONTABIL
	If Empty(mv_par08)
		MsgInfo("É necessário informar a data de referência !","Parametro Considera igual a Periodo.")//"É necessário informar a data de referência !"#"Parametro Considera igual a Periodo."
		Return
	Endif
    
	dFinal		:= mv_par08
	dFinalA		:= CTOD("  /  /  ")
	dbSelectArea("CTG")
	dbSetOrder(1)
	MsSeek(xFilial("CTG")+mv_par01,.T.)
	While CTG->CTG_FILIAL == xFilial("CTG") .And. CTG->CTG_CALEND == mv_par01
		If dFinal >= CTG->CTG_DTINI .and. dFinal <= CTG->CTG_DTFIM
			dFinalA		:= CTG->CTG_DTINI	
			If lMovPeriodo
				nMes			:= Month(dFinalA)
				nAno			:= Year(dFinalA)
				dPeriodo0	:= CtoD(	StrZero(Day(dFinalA),2)							+ "/" +;
											StrZero( If(nMes==1,12		,nMes-1	),2 )	+ "/" +;
											StrZero( If(nMes==1,nAno-1,nAno		),4 ) )
				dFinalA		:= dFinalA - 1
			EndIf
			Exit
		Endif
		CTG->(DbSkip())
	EndDo
    
	If Empty(dFinalA)
		MsgInfo("Data fora do calendário !","Data de referência.")//"Data fora do calendário !"#"Data de referência."
		Return
	Endif
Endif

CTITULO		:= If(! Empty(aSetOfBook[10]), aSetOfBook[10], CTITULO)		// Titulo definido SetOfBook
If Valtype(mv_par16)=="N" .And. (mv_par16 == 1)
	cTitulo := CTBNomeVis( aSetOfBook[5] )
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Criacao do componente de impressao                                      ³
//³                                                                        ³
//³TReport():New                                                           ³
//³ExpC1 : Nome do relatorio                                               ³
//³ExpC2 : Titulo                                                          ³
//³ExpC3 : Pergunte                                                        ³
//³ExpB4 : Bloco de codigo que sera executado na confirmacao da impressao  ³
//³ExpC5 : Descricao                                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oReport	:= TReport():New( CREPORT,CTITULO,CPERG, { |oReport| ReportPrint( oReport ) }, CDESC ) 
oReport:SetCustomText( {|| CtCGCCabTR(,,,,,dDataBase,ctitulo,,,,,oReport) } )                                        
oReport:ParamReadOnly()

IF GETNEWPAR("MV_CTBPOFF",.T.)
	oReport:SetEdit(.F.)
ENDIF	

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Criacao da secao utilizada pelo relatorio                               ³
//³                                                                        ³
//³TRSection():New                                                         ³
//³ExpO1 : Objeto TReport que a secao pertence                             ³
//³ExpC2 : Descricao da seçao                                              ³
//³ExpA3 : Array com as tabelas utilizadas pela secao. A primeira tabela   ³
//³        sera considerada como principal para a seção.                   ³
//³ExpA4 : Array com as Ordens do relatório                                ³
//³ExpL5 : Carrega campos do SX3 como celulas                              ³
//³        Default : False                                                 ³
//³ExpL6 : Carrega ordens do Sindex                                        ³
//³        Default : False                                                 ³
//³                                                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oSection1  := TRSection():New( oReport, "Contas/Saldos", {"cArqTmp"},, .F., .F. )        //"Contas/Saldos"

TRCell():New( oSection1, "ATIVO"	,"","(Em "+cDescMoeda+")"	/*Titulo*/,/*Picture*/,aTamDesc[1]	/*Tamanho*/,/*lPixel*/,/*CodeBlock*/)	//"(Em "
TRCell():New( oSection1, "SALDOATU"	,"",						/*Titulo*/,/*Picture*/,aTamVal[1]+2	/*Tamanho*/,/*lPixel*/,/*CodeBlock*/,"RIGHT",,"RIGHT")
TRCell():New( oSection1, "SALDOANT"	,"",						/*Titulo*/,/*Picture*/,aTamVal[1]+2	/*Tamanho*/,/*lPixel*/,/*CodeBlock*/,"RIGHT",,"RIGHT")

oSection1:SetTotalInLine(.F.) 

Return(oReport)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ReportPrint³ Autor ³ Daniel Sakavicius	³ Data ³ 17/08/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Imprime o relatorio definido pelo usuario de acordo com as  ³±±
±±³          ³secoes/celulas criadas na funcao ReportDef definida acima.  ³±±
±±³          ³Nesta funcao deve ser criada a query das secoes se SQL ou   ³±±
±±³          ³definido o relacionamento e filtros das tabelas em CodeBase.³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ ReportPrint(oReport)                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³EXPO1: Objeto do relatório                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ReportPrint( oReport )  

Local oSection1 	:= oReport:Section(1) 
Local aSetOfBook	:= CTBSetOf(mv_par02)
Local aCtbMoeda	:= {}
Local lin 			:= 3001
Local cArqTmp
Local cTpValor		:= GetMV("MV_TPVALOR")
Local cPicture
Local cDescMoeda
Local lFirstPage	:= .T.               
Local nTraco		:= 0
Local nSaldo
Local nTamLin		:= 2350
Local aPosCol		:= { 1740, 2045 }
Local nPosCol		:= 0
Local lImpTrmAux	:= Iif(mv_par10 == 1,.T.,.F.)
Local cArqTrm		:= ""
Local lVlrZerado	:= Iif(mv_par12==1,.T.,.F.)
Local lMovPeriodo
Local aTamVal		:= TAMSX3("CT2_VALOR")
Local cMoedaDesc	:= iif( empty( mv_par14 ) , mv_par03 , mv_par14 )
Local lPeriodoAnt 	:= (mv_par06 == 1)
Local cSaldos     	:= CT510TRTSL() 

aCtbMoeda := CtbMoeda(mv_par03, aSetOfBook[9])
If Empty(aCtbMoeda[1])                       
	Help(" ",1,"NOMOEDA")
    Return .F.
Endif

cDescMoeda 	:= AllTrim(aCtbMoeda[3])
nDecimais 	:= DecimalCTB(aSetOfBook,mv_par03)
cPicture 	:= aSetOfBook[4]

If ! Empty(cPicture) .And. Len(Trans(0, cPicture)) > 17
	cPicture := ""
Endif

lMovPeriodo	:= (mv_par13 == 1)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta Arquivo Temporario para Impressao					     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
MsgMeter({|	oMeter, oText, oDlg, lEnd | ;
			U_CTGerPlan(	oMeter, oText, oDlg, @lEnd, @cArqTmp, dFinalA+1, dFinal;
					  , "", "", "", Repl( "Z", Len( CT1->CT1_CONTA )), ""; 
					  , Repl( "Z", Len(CTT->CTT_CUSTO)), "", Repl("Z", Len(CTD->CTD_ITEM));
					  , "", Repl("Z", Len(CTH->CTH_CLVL)), mv_par03, /*MV_PAR15*/cSaldos, aSetOfBook, Space(2);
					  , Space(20), Repl("Z", 20), Space(30),,,,, mv_par04=1, mv_par05;
					  , ,lVlrZerado,,,,,,,,,,,,,,,,,,,,,,,,,cMoedaDesc,lMovPeriodo,,,.T.,MV_PAR17==1)};
			,"Criando Arquivo Temporario...", "Criando Arquivo Temporario...") //"Criando Arquivo Temporario..."

dbSelectArea("cArqTmp")           
dbGoTop()

oReport:SetPageNumber(mv_par07) //mv_par07 - Pagina Inicial

oSection1:Cell("SALDOATU" ):SetTitle(Dtoc(dFinal))
If lPeriodoAnt
	oSection1:Cell("SALDOANT" ):SetTitle(Dtoc(dFinalA))
Else
	oSection1:Cell("SALDOANT" ):Disable()
EndIf

oSection1:Cell("ATIVO"):SetBlock( { || Iif(cArqTmp->COLUNA<2,Iif(cArqTmp->TIPOCONTA="2",cArqTmp->DESCCTA,cArqTmp->DESCCTA),"") } )		

If cArqTmp->IDENTIFI < "5"
	oSection1:Cell("SALDOATU" ):SetBlock( { || ValorCTB( If(lMovPeriodo,cArqTmp->(SALDOATU-SALDOANT),cArqTmp->SALDOATU),,,aTamVal[1],nDecimais,.T.,cPicture,;
    	                                                 cArqTmp->NORMAL,cArqTmp->CONTA,,,cTpValor,,,.F. ) } )

	If lPeriodoAnt
		oSection1:Cell("SALDOANT" ):SetBlock( { || ValorCTB( If(lMovPeriodo,cArqTmp->MOVPERANT,cArqTmp->SALDOANT),,,aTamVal[1],nDecimais,.T.,cPicture,;
															 cArqTmp->NORMAL,cArqTmp->CONTA,,,cTpValor,,,.F. ) } )
	EndIf
EndIf

oSection1:Print()

If lImpTrmAux
	cArqTRM 	:= mv_par11
    aVariaveis  := {}
	
    // Buscando os parâmetros do relatorio (a partir do SX1) para serem impressaos do Termo (arquivos *.TRM)
	SX1->( dbSeek("CTR510"+"01") )
	SX1->( dbSeek( padr( "CTR510" , Len( X1_GRUPO ) , ' ' ) + "01" ) )
	While SX1->X1_GRUPO == padr( "CTR510" , Len( SX1->X1_GRUPO ) , ' ' )
		AADD(aVariaveis,{Rtrim(Upper(SX1->X1_VAR01)),&(SX1->X1_VAR01)})
		SX1->( dbSkip() )
	End

	If !File(cArqTRM)
		aSavSet:=__SetSets()
		cArqTRM := CFGX024(cArqTRM,"Responsáveis...") // "Responsáveis..."
		__SetSets(aSavSet)
		Set(24,Set(24),.t.)
	Endif

	If cArqTRM#NIL
		ImpTerm2(cArqTRM,aVariaveis,,,,oReport)
	Endif	 

Endif

DbSelectArea("cArqTmp")
Set Filter To
dbCloseArea()
 
If Select("cArqTmp") == 0
	FErase(cArqTmp+GetDBExtension())
	FErase(cArqTmp+OrdBagExt())
EndIF	

Return

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ CTR510SX5    ³ Autor ³ Elton da Cunha Santana³ Data ³ 13.10.09 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Cria lista de opcoes para escolha em parametro                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Siga                                                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function CTR510SX5(nModelo)

Local i := 0
Private nTam      := 0
Private aCat      := {}
Private MvRet     := Alltrim(ReadVar())
Private MvPar     := ""
Private cTitulo   := ""
Private MvParDef  := ""

#IFDEF WINDOWS
	oWnd := GetWndDefault()
#ENDIF

//Tratamento para carregar variaveis da lista de opcoes
Do Case 
	Case nModelo = 1
		nTam:=1
		cTitulo := "fernando"
		SX5->(DbSetOrder(1))
		SX5->(DbSeek(XFilial("SX5")+"SL"))
		While SX5->(!Eof()) .And. AllTrim(SX5->X5_TABELA) == "SL"
			MvParDef += AllTrim(SX5->X5_CHAVE)
			aAdd(aCat,AllTrim(SX5->X5_CHAVE)+" - "+AllTrim(SX5->X5_DESCRI))
			SX5->(DbSkip())
		End
		 MvPar:= PadR(AllTrim(StrTran(&MvRet,";","")),Len(aCat))
		&MvRet:= PadR(AllTrim(StrTran(&MvRet,";","")),Len(aCat))
EndCase

//Executa funcao que monta tela de opcoes
f_Opcoes(@MvPar,cTitulo,aCat,MvParDef,12,49,.F.,nTam)

//Tratamento para separar retorno com barra "/"
&MvRet := ""
For i:=1 to Len(MvPar)
	If !(SubStr(MvPar,i,1) $ " |*")
		&MvRet  += SubStr(MvPar,i,1) + ";"
	EndIf
Next	

//Trata para tirar o ultimo caracter
&MvRet := SubStr(&MvRet,1,Len(&MvRet)-1)

//Guarda numa variavel private o retorno da função
cRetSX5SL := &MvRet

Return(.T.)  

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³ fTrataSlds³ Autor ³Elton da Cunha Santana       ³ 13.10.09 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Tratamento do retorno do parametro                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ CT510TRTSL                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ SIGACTB                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function CT510TRTSL()

Local cRet := ""

If MV_PAR17 == 1
	cRet := MV_PAR18
Else
	cRet := MV_PAR15
EndIf

Return(cRet)

/*
-------------------------------------------------------- RELEASE 3 -------------------------------------------------------------
*/
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±
±±³Fun‡…o	 ³ Ctbr510	³ Autor ³ Wagner Mobile Costa	 ³ Data ³ 15.10.01 ³±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±
±±³Descri‡…o ³ Demonstracao de Resultados                 			  	   ³±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±
±±³Retorno	 ³ Nenhum       											   ³±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±
±±³Parametros³ Nenhum													   ³±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function R510RF()

Local titulo 		:= ""
Local nMes
Local nAno
Local lMovPeriodo
Local aSetOfBook	:= CTBSetOf(mv_par02)

PRIVATE nLastKey 	:= 0
PRIVATE cPerg	 	:= "CTR510"
PRIVATE nomeProg 	:= "CTBR510"
STATIC dFinal		:= Ctod("  /  /  ")

CtAjustSx1('CTR510')

If ! Pergunte("CTR510",.T.)
	Return
EndIf
	
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros					  		³
//³ mv_par01				// Exercicio contabil             		³
//³ mv_par02				// Configuracao de livros				³
//³ mv_par03				// Moeda?          			     	    ³
//³ mv_par04				// Posicao Ant. L/P? Sim / Nao         	³
//³ mv_par05				// Data Lucros/Perdas?                 	³
//³ mv_par06				// Dem. Periodo Anterior?               ³
//³ mv_par07				// Folha Inicial        ?             	³
//³ mv_par08				// Data de Referencia   ?             	³
//³ mv_par09				// Periodo ? (Calendario/Periodo) 		³
//³ mv_par10				// Imprime Arq. Termo Auxiliar?			³
//³ mv_par11				// Arq.Termo Auxiliar ?					³ 
//³ mv_par12				// Saldos Zerados ? Sim / Nao	   		³
//³ mv_par13				// Considerar ? Mov. Periodo / Saldo Acumulado		³
//³ mv_par14				// Descrição na moeda					³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se usa Set Of Books + Plano Gerencial (Se usar Plano³
//³ Gerencial -> montagem especifica para impressao)			 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

// faz a validação do livro
if ! VdSetOfBook( mv_par02 , .T. )
   return .F.
endif
             
lMovPeriodo	:= (mv_par13 == 1)

If mv_par09 == 1												/// SE DEVE CONSIDERAR TODO O CALENDARIO
	CTG->(DbSeek(xFilial() + mv_par01))

	If Empty(mv_par08)
		While CTG->CTG_FILIAL = xFilial("CTG") .And. CTG->CTG_CALEND = mv_par01
			dFinal	:= CTG->CTG_DTFIM
			CTG->(DbSkip())
		EndDo
	Else
		dFinal	:= mv_par08
	EndIf

	dFinalA   	:= Ctod(Left(Dtoc(dFinal), 6) + Str(Year(dFinal) - 1, 4))
	If Empty ( dFinalA )
		If MONTH(dFinal) == 2
			If Day(dFinal) > 28 .and. Day(dFinal) == 29
				dFinalA := Ctod(Left( STRTRAN ( Dtoc(dFinal) , "29" , "28" ), 6) + Str(Year(dFinal) - 1, 4))
			EndIf
		EndIf
	EndIf	
	mv_par01    := dFinal

	If lMovPeriodo
		dPeriodo0 	:= Ctod(Left(Dtoc(dFinal), 6) + Str(Year(dFinal) - 2, 4)) + 1
	EndIf
Else															/// SE DEVE CONSIDERAR O PERIODO CONTABIL
	If Empty(mv_par08)
		MsgInfo("É necessário informar a data de referência !","Parametro Considera igual a Periodo.")//"É necessário informar a data de referência !"#"Parametro Considera igual a Periodo."
		Return
	Endif
    
	dFinal		:= mv_par08
	dFinalA		:= CTOD("  /  /  ")

	dbSelectArea("CTG")
	dbSetOrder(1)

	MsSeek(xFilial("CTG")+mv_par01,.T.)

	While CTG->CTG_FILIAL == xFilial("CTG") .And. CTG->CTG_CALEND == mv_par01
		If dFinal >= CTG->CTG_DTINI .and. dFinal <= CTG->CTG_DTFIM
			dFinalA		:= CTG->CTG_DTINI	
			If lMovPeriodo
				nMes			:= Month(dFinalA)
				nAno			:= Year(dFinalA)
				dPeriodo0	:= CtoD(	StrZero(Day(dFinalA),2)							+ "/" +;
											StrZero( If(nMes==1,12		,nMes-1	),2 )	+ "/" +;
											StrZero( If(nMes==1,nAno-1,nAno		),4 ) )
				dFinalA		:= dFinalA - 1
			EndIf
			Exit
		Endif
		CTG->(DbSkip())
	EndDo
    
	If Empty(dFinalA)
		MsgInfo("Data fora do calendário !","Data de referência.")//"Data fora do calendário !"#"Data de referência."
		Return
	Endif
Endif

wnrel 		:= "CTBR510"            //Nome Default do relatorio em Disco
titulo 		:= "DEMONSTRACAO DE RESULTADOS" //"DEMONSTRACAO DE RESULTADOS"

MsgRun(	"Gerando relatorio, aguarde...","",; //"Gerando relatorio, aguarde..."
		{|| CursorWait(), Ctr500Cfg(@titulo, "U_Ctr510Det", "Demonstracao de resultados", .F.) ,CursorArrow()}) //"Demonstracao de resultados"

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³Ctr510Det ³ Autor ³ Simone Mie Sato       ³ Data ³ 28.06.01 ³±±
±±³ÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Detalhe do Relatorio                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³Ctr510Det(ExpO1,ExpN1)                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpO1 = Objeto oPrint                                      ³±±
±±³          ³ ExpN1 = Contador de paginas                                ³±±
±±³          ³ ParC1 = Titulo do relatorio                                ³±±
±±³          ³ ParC2 = Titulo da caixa do processo                        ³±±
±±³          ³ ParL1 = Indica se imprime em Paisagem (.T.) ou Retrato .F. ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGACTB                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function Ctr510Det(oPrint,i,titulo,cProcesso,lLandScape)

Local aSetOfBook	:= CTBSetOf(mv_par02)
Local aCtbMoeda		:= {}
Local lin 			:= 3001
Local cArqTmp
Local cTpValor		:= GetMV("MV_TPVALOR")
Local cPicture
Local cDescMoeda
Local lFirstPage	:= .T.               
Local nTraco		:= 0
Local nSaldo
Local nTamLin		:= 2350
Local aPosCol		:= { 1740, 2045 }
Local nPosCol		:= 0
Local lImpTrmAux	:= Iif(mv_par10 == 1,.T.,.F.)
Local cArqTrm		:= ""
Local lVlrZerado	:= Iif(mv_par12==1,.T.,.F.)
Local lMovPeriodo
Local cMoedaDesc	:= iif( empty( mv_par14 ) , mv_par03 , mv_par14 ) 
Local cSaldos     	:= CT510TRTSL() 

aCtbMoeda := CtbMoeda(mv_par03, aSetOfBook[9])
If Empty(aCtbMoeda[1])                       
	Help(" ",1,"NOMOEDA")
    Return .F.
Endif

Titulo		:= If(! Empty(aSetOfBook[10]), aSetOfBook[10], Titulo)		// Titulo definido SetOfBook
If (mv_par16 == 1)
	titulo := CTBNomeVis( aSetOfBook[5] )
EndIf
cDescMoeda 	:= AllTrim(aCtbMoeda[3])
nDecimais 	:= DecimalCTB(aSetOfBook,mv_par03)

cPicture 	:= aSetOfBook[4]
If ! Empty(cPicture) .And. Len(Trans(0, cPicture)) > 17
	cPicture := ""
Endif

lMovPeriodo	:= (mv_par13 == 1)

m_pag := mv_par07
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta Arquivo Temporario para Impressao					     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
MsgMeter({|	oMeter, oText, oDlg, lEnd | ;
			U_CTGerPlan(	oMeter, oText, oDlg, @lEnd, @cArqTmp, ;
						dFinalA+1, dFinal, "", "", "", Repl("Z", Len(CT1->CT1_CONTA)),;
						"", Repl("Z", Len(CTT->CTT_CUSTO)), "", Repl("Z", Len(CTD->CTD_ITEM)), ;
						"",Repl("Z", Len(CTH->CTH_CLVL)),mv_par03,;
						/*MV_PAR15*/cSaldos, aSetOfBook, Space(2), Space(20), Repl("Z", 20), Space(30) ,,,,,;
						mv_par04 = 1, mv_par05,,lVlrZerado,,,,,,,,,,,,,,,,,,,,,,,,,;
						cMoedaDesc,lMovPeriodo,,,.T.,MV_PAR17 == 1)};
			,"Criando Arquivo Temporario...", cProcesso) //"Criando Arquivo Temporario..."

dbSelectArea("cArqTmp")           
dbGoTop()

While ! Eof()

	If lin > 3000
		If !lFirstPage
			oPrint:Line( ntraco,150,ntraco,nTamLin )   	// horizontal
		EndIf	
		i++                                                
		oPrint:EndPage() 	 								// Finaliza a pagina
		CtbCbcDem(oPrint,titulo,lLandScape)					// Funcao que monta o cabecalho padrao 
		If mv_par06 == 2									// Demonstra periodo anterior = Nao
			U_Ctr510Atu(oPrint, cDescMoeda,aPosCol,nTamLin)	// Cabecalho de impressão do Saldo atual.
		Else
			U_Ctr510Esp(oPrint, cDescMoeda,aPosCol,nTamLin)
		EndIf
		lin := 304        
		lFirstPage := .F.		
	End
    
	If DESCCTA = "-"
		oPrint:Line(lin,150,lin,nTamLin)   	// horizontal
	Else

		oPrint:Line( lin,150,lin+50, 150 )   	// vertical

// Negrito caso Sub-Total/Total/Separador (caso tenha descricao) e Igual (Totalizador)

		oPrint:Say(lin+15,195,DESCCTA, If(IDENTIFI $ "3469", oCouNew08N, oFont08))

		
		For nPosCol := 1 To Len(aPosCol)
			If mv_par06 == 2 .And. nPosCol == 1
				aPosCol := {2045}
			Else
				aPosCol	:= { 1740, 2045 }	           
			EndIf
			oPrint:Line(lin,aPosCol[nPosCol],lin+50,aPosCol[nPosCol])	// Separador vertical 
    	  
    		If IDENTIFI < "5"
    			If mv_par06 == 1 .Or. (mv_par06 == 2 .And. nPosCol == 1)
					If !lMovPeriodo
						nSaldo := If(nPosCol = 1, SALDOATU, SALDOANT)
					Else
						nSaldo := If(nPosCol = 1, SALDOATU-SALDOANT,MOVPERANT)
					EndIf
				       
		            ValorCTB(nSaldo,lin+15,aPosCol[nPosCol],15,nDecimais,.T.,cPicture,;
					NORMAL,CONTA,.T.,oPrint,cTpValor,IIf(IDENTIFI $ "4","1",IDENTIFI))
				EndIf					 
			Endif 
			
		Next

		oPrint:Line(lin,nTamLin,lin+50,nTamLin)   	// Separador vertical
		lin +=47

	Endif

	nTraco := lin + 1
	DbSkip()
EndDo
oPrint:Line(lin,150,lin,nTamLin)   	// horizontal

lin += 10             

If lImpTrmAux
	If lin > 3000
		If !lFirstPage
			oPrint:Line( ntraco,150,ntraco,nTamLin )   	// horizontal
		EndIf	
		i++                                                
		oPrint:EndPage() 	 								// Finaliza a pagina
		CtbCbcDem(oPrint,titulo,lLandScape)					// Funcao que monta o cabecalho padrao 
		If mv_par06 == 2									// Demonstra periodo anterior = Nao
			U_Ctr510Atu(oPrint, cDescMoeda,aPosCol,nTamLin)	// Cabecalho de impressão do Saldo atual.
		Else
			U_Ctr510Esp(oPrint, cDescMoeda,aPosCol,nTamLin)
		EndIf
		lin := 304        
		lFirstPage := .F.		
	Endif
	cArqTRM 	:= mv_par11
    aVariaveis  := {}
	
    // Buscando os parâmetros do relatorio (a partir do SX1) para serem impressaos do Termo (arquivos *.TRM)
	SX1->( dbSeek( padr( "CTR510" , Len( X1_GRUPO ) , ' ' ) + "01" ) )

	While SX1->X1_GRUPO == padr( "CTR510" , Len( SX1->X1_GRUPO ) , ' ' )
		AADD(aVariaveis,{Rtrim(Upper(SX1->X1_VAR01)),&(SX1->X1_VAR01)})
		SX1->( dbSkip() )
	End

	If !File(cArqTRM)
		aSavSet:=__SetSets()
		cArqTRM := CFGX024(cArqTRM,"Responsáveis...") // "Responsáveis..."
		__SetSets(aSavSet)
		Set(24,Set(24),.t.)
	Endif

	If cArqTRM#NIL
		ImpTerm(cArqTRM,aVariaveis,"",.T.,{oPrint,oFont08,Lin})
	Endif	 
Endif


DbSelectArea("cArqTmp")
Set Filter To
dbCloseArea() 
If Select("cArqTmp") == 0
	FErase(cArqTmp+GetDBExtension())
	FErase(cArqTmp+OrdBagExt())
EndIF	
dbselectArea("CT2")

Return lin


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³CTR500ESP ³ Autor ³ Simone Mie Sato       ³ Data ³ 27.06.01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Cabecalho Especifico do relatorio CTBR041.                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³CTR500ESP(ParO1,ParC1)			                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpO1 = Objeto oPrint                                      ³±±
±±³          ³ ExpC1 = Descricao da moeda sendo impressa                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGACTB                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function CTR510Esp(oPrint,cDescMoeda,aPosCol,nTamLin)

Local cColuna  		:= "(Em " + cDescMoeda + ")"
Local aCabecalho    := { Dtoc(dFinal, "ddmmyyyy"), Dtoc(dFinalA, "ddmmyyyy") }
Local nPosCol

oPrint:Line(250,150,300,150)   	// vertical

oPrint:Say(260,195,cColuna,oArial10)

For nPosCol := 1 To Len(aCabecalho)
	oPrint:Say(260,aPosCol[nPosCol] + 30,aCabecalho[nPosCol],oArial10)
Next

oPrint:Line(250,nTamLin,300,nTamLin)   	// vertical

oPrint:Line(300,150,300,nTamLin)   	// horizontal

Return Nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³CTR510ATU ³ Autor ³ Lucimara Soares       ³ Data ³ 03.02.03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Cabecalho para impressao apenas da coluna de Saldo Atual.   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³CTR510ESP(ParO1,ParC1)			                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpO1 = Objeto oPrint                                      ³±±
±±³          ³ ExpC1 = Descricao da moeda sendo impressa                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGACTB                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function CTR510ATU(oPrint,cDescMoeda,aPosCol,nTamLin)

Local cColuna  		:= "(Em " + cDescMoeda + ")"
Local aCabecalho    := { Dtoc(dFinal, "ddmmyyyy") }
Local nPosCol       := 1

oPrint:Line(250,150,300,150)   	// vertical

oPrint:Say(260,195,cColuna,oArial10)

oPrint:Say(260,aPosCol[nPosCol+1] + 30,aCabecalho[nPosCol],oArial10)


oPrint:Line(250,nTamLin,300,nTamLin)   	// vertical

oPrint:Line(300,150,300,nTamLin)   	// horizontal

Return Nil  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CTBR510   ºAutor  ³Microsiga           º Data ³  07/31/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function AjSX1Descric()

dbSelectArea("SX1")
dbSetOrder(1)

If dbSeek(PadR("CTR510", Len(SX1->X1_GRUPO))+"09")
	If ! ("Periodo" $ Alltrim(SX1->X1_PERGUNT) )
		RecLock("SX1", .F.)
		SX1->X1_PERGUNT :="Periodo ?"
		SX1->X1_PERSPA :="¨Periodo  ?"
		SX1->X1_PERENG :="Period     ?"
		SX1->X1_DEF01 :="Calendario"
		SX1->X1_DEFSPA1 :="Calendario"
		SX1->X1_DEFENG1  :="Calendar"
		SX1->X1_DEF02 :="Periodo"
		SX1->X1_DEFSPA2 :="Periodo"
		SX1->X1_DEFENG2 :="Period"
		MsUnlock()
	EndIf
EndIf

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Program   ³CtGerPlan ³ Autor ³ Simone Mie Sato       ³ Data ³ 25.08.01          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Gerar Arquivo Temporario para Balancetes.                            |±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ .T. / .F.                                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ 01-oMeter      = Controle da regua                                  ³±±
±±³          ³ 02-oText       = Controle da regua                                  ³±±
±±³          ³ 03-oDlg        = Janela                                             ³±±
±±³          ³ 04-lEnd        = Controle da regua -> finalizar                     ³±±
±±³          ³ 05-cArqTmp     = Arquivo temporario                                 ³±±
±±³          ³ 06-dDataIni    = Data Inicial de Processamento                      ³±±
±±³          ³ 07-dDataFim    = Data Final de Processamento                        ³±±
±±³          ³ 08-cAlias      = Alias do Arquivo                                   ³±±
±±³          ³ 09-cIdent      = Identificador do arquivo a ser processado          ³±±
±±³          ³ 10-cContaIni   = Conta Inicial                                      ³±±
±±³          ³ 11-cContaFim	= Conta Final                                          ³±±
±±³          ³ 12-cCCIni      = Centro de Custo Inicial                            ³±±
±±³          ³ 13-cCCFim      = Centro de Custo Final                              ³±±
±±³          ³ 14-cItemIni    = Item Inicial                                       ³±±
±±³          ³ 15-cItemFim    = Item Final                                         ³±±
±±³          ³ 16-cClvlIni    = Classe de Valor Inicial                            ³±±
±±³          ³ 17-cClvlFim    = Classe de Valor Final                              ³±±
±±³          ³ 18-cMoeda      = Moeda	                                            ³±±
±±³          ³ 19-cSaldos     = Tipos de Saldo a serem processados                 ³±±
±±³          ³ 20-aSetOfBook  = Matriz de configuracao de livros                   ³±±
±±³          ³ 21-cSegmento   = Indica qual o segmento sera filtrado               ³±±
±±³          ³ 22-cSegIni     = Conteudo Inicial do segmento                       ³±±
±±³          ³ 23-cSegFim     = Conteudo Final do segmento                         ³±±
±±³          ³ 24-cFiltSegm   = Filtra por Segmento   		                       ³±±
±±³          ³ 25-lNImpMov    = Se Imprime Entidade sem movimento                  ³±±
±±³          ³ 26-lImpConta   = Se Imprime Conta                                   ³±±
±±³          ³ 27-nGrupo      = Grupo                                              ³±±
±±³          ³ 28-cHeader     = Identifica qual a Entidade Principal               ³±±
±±³          ³ 29-lImpAntLP   = Se imprime lancamentos Lucros e Perdas             ³±±
±±³          ³ 30-dDataLP     = Data da ultima Apuracao de Lucros e Perdas         ³±±
±±³          ³ 31-nDivide     = Divide valores por (100,1000,1000000)              ³±±
±±³          ³ 32-lVlrZerado  = Grava ou nao valores zerados no arq temporario     ³±±
±±³          ³ 33-cFiltroEnt  = Entidade Gerencial que servira de filtro dentro    ³±±
±±³          ³                  de outra Entidade Gerencial. Ex.: Centro de Custo  ³±±
±±³          ³                  sendo filtrado por Item Contabil (CTH)             ³±±
±±³          ³ 34-cCodFilEnt  = Codigo da Entidade Gerencial utilizada como filtro ³±±
±±³          ³ 35-cSegmentoG  = Filtra por Segmento Gerencial (CC/Item ou ClVl)    ³±±
±±³          ³ 36-cSegIniG    = Segmento Gerencial Inicial                         ³±±
±±³          ³ 37-cSegFimG    = Segmento Gerencial Final                           ³±±
±±³          ³ 38-cFiltSegmG  = Segmento Gerencial Contido em                      ³±±
±±³          ³ 39-lUsGaap     = Se e Balancete de Conversao de moeda               ³±±
±±³          ³ 40-cMoedConv   = Moeda para a qual buscara o criterio de conversao  ³±±
±±³          ³                  no Pl.Contas                                       ³±±
±±³          ³ 41-cConsCrit   = Criterio de conversao utilizado: 1-Diario, 2-Medio,³±±
±±³          ³                  3-Mensal, 4-Informada, 5-Plano de Contas           ³±±
±±³          ³ 42-dDataConv   = Data de Conversao                                  ³±±
±±³          ³ 43-nTaxaConv   = Taxa de Conversao                                  ³±±
±±³          ³ 44-aGeren      = Matriz que armazena os compositores do Pl. Ger.    ³±±
±±³          ³ 			        para efetuar o filtro de relatorio.                ³±±
±±³          ³ 45-lImpMov     = Nao utilizado                                      ³±±
±±³          ³ 46-lImpSint    = Se atualiza sinteticas                             ³±±
±±³          ³ 47-cFilUSU     = Filtro informado pelo usuario                      ³±±
±±³          ³ 48-lRecDesp0   = Se imprime saldo anterior do periodo anterior      ³±±
±±³          ³                  zerado                                             ³±±
±±³          ³ 49-cRecDesp    = Grupo de receitas e despesas                       ³±±
±±³          ³ 50-dDtZeraRD   = Data de zeramento de receitas e despesas           ³±±
±±³          ³ 51-lImp3Ent    = Se e Balancete C.Custo / Conta / Item              ³±±
±±³          ³ 52-lImp4Ent    = Se e Balancete por CC x Cta x Item x Cl.Valor      ³±±
±±³          ³ 53-lImpEntGer  = Se e Balancete de Entidade (C.Custo/Item/Cl.Vlr    ³±±
±±³          ³                  por Entid. Gerencial)                              ³±±
±±³          ³ 54-lFiltraCC   = Se considera o filtro das perguntas para C.Custo   ³±±
±±³          ³ 55-lFiltraIt   = Se considera o filtro das perguntas para Item      ³±±
±±³          ³ 56-lFiltraCV   = Se considera o filtro das perguntas para Cl.Valor  ³±±
±±³          ³ 57-cMoedaDsc   = Codigo da moeda para descricao das entidades       ³±±
±±³          ³ 58-lMovPeriodo = Se imprime movimento do periodo anterior           ³±±
±±³          ³ 59-aSelFil     = Array de filiais                                   ³±±
±±³          ³ 60-dDtCorte    = Data de Corte para calculo do saldo anterior       ³±±
±±³          ³ 61-lPlGerSint  = Imprime visao gerencial sintetica? Padrao .F.      ³±±
±±³          ³ 62-lConsSaldo  = Consolida saldo ? Padrao .F.                       ³±±
±±³          ³ 63-lCompEnt    = Consolida saldo entre entidades? Padrao .F.        ³±±
±±³          ³ 64-cArqAux     = Arquivo auxiliar permitindo a recursividade        ³±±
±±³          ³ 65-lUsaNmVis   = Usa nome da visao gerencial ? Padrao .F.           ³±±
±±³          ³ 66-cNomeVis    = Nome da visao gerencial (retorno, passar por ref.) ³±±
±±³          ³ 67-lCttSint    = Indica se imprime ou não C.Custo Sintéticos	       ³±±
±±³          ³ 68-cQuadroCTB  = CODIGO DO QUADRO CONTABIL                          ³±±
±±³          ³ 69-aEntidades  = Array com as entidades de inicio e fim   	       ³±±
±±³          ³            Ex. {'Cta Ent. 05 Inicio','Cta. Ent. 05 Final'}  	       ³±±  
±±³          ³ 70-cCodEntidade= Codigo da Entidade                      	       ³±±  
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function CTGerPlan(	oMeter,oText,oDlg,lEnd,cArqtmp,dDataIni,dDataFim,cAlias,cIdent,cContaIni,cContaFim,;
					cCCIni,cCCFim,cItemIni,cItemFim,cClvlIni,cClVlFim,cMoeda,cSaldos,aSetOfBook,cSegmento,;
					cSegIni,cSegFim,cFiltSegm,lNImpMov,lImpConta,nGrupo,cHeader,lImpAntLP,dDataLP,;
					nDivide,lVlrZerado,cFiltroEnt,cCodFilEnt,cSegmentoG,cSegIniG,cSegFimG,cFiltSegmG,;
					lUsGaap,cMoedConv,cConsCrit,dDataConv,nTaxaConv,aGeren,lImpMov,lImpSint,cFilUSU,lRecDesp0,;
					cRecDesp,dDtZeraRD,lImp3Ent,lImp4Ent,lImpEntGer,lFiltraCC,lFiltraIt,lFiltraCV,cMoedaDsc,;
					lMovPeriodo,aSelFil,dDtCorte,lPlGerSint,lConsSaldo,lCompEnt,cArqAux,lUsaNmVis,cNomeVis,lCttSint,;
					lTodasFil,cQuadroCTB,aEntidades,cCodEntidade)

Local aTamConta		:= TAMSX3("CT1_CONTA")
Local aTamCtaRes	:= TAMSX3("CT1_RES")
Local aTamCC        := TAMSX3("CTT_CUSTO")
Local aTamCCRes 	:= TAMSX3("CTT_RES")
Local aTamItem  	:= TAMSX3("CTD_ITEM")
Local aTamItRes 	:= TAMSX3("CTD_RES")    
Local aTamClVl  	:= TAMSX3("CTH_CLVL")
Local aTamCvRes 	:= TAMSX3("CTH_RES")
Local aTamVal		:= TAMSX3("CT2_VALOR")

Local aCtbMoeda		:= {}
Local aSaveArea 	:= GetArea()
Local aCampos
Local cChave
Local nTamCta 		:= Len(CriaVar("CT1->CT1_DESC"+cMoeda))
Local nTamItem		:= Len(CriaVar("CTD->CTD_DESC"+cMoeda))
Local nTamCC  		:= Len(CriaVar("CTT->CTT_DESC"+cMoeda))
Local nTamClVl		:= Len(CriaVar("CTH->CTH_DESC"+cMoeda))
Local nTamGrupo		:= Len(CriaVar("CT1->CT1_GRUPO"))
Local nDecimais		:= 0
Local cCodigo		:= ""
Local cCodGer		:= ""
Local cEntidIni		:= ""
Local cEntidFim		:= ""           
Local cEntidIni1	:= ""
Local cEntidFim1	:= ""
Local cEntidIni2	:= ""
Local cEntidFim2	:= ""
Local cArqTmp1		:= ""
Local cMascaraG 	:= ""
Local lCusto		:= CtbMovSaldo("CTT")//Define se utiliza C.Custo
Local lItem 		:= CtbMovSaldo("CTD")//Define se utiliza Item
Local lClVl			:= CtbMovSaldo("CTH")//Define se utiliza Cl.Valor 
Local lAtSldBase	:= Iif(GetMV("MV_ATUSAL")== "S",.T.,.F.) 
Local lAtSldCmp		:= Iif(GetMV("MV_SLDCOMP")== "S",.T.,.F.)
Local nInicio		:= Val(cMoeda)
Local nFinal		:= Val(cMoeda)
Local nCampoLP		:= 0
Local cFilDe		:= xFilial(cAlias)
Local cFilAte		:= xFilial(cAlias), nOrdem := 1
Local cCodMasc		:= ""
Local cMensagem		:= "O plano gerencial ainda nao esta disponivel nesse relatorio."
Local nPos			:= 0
Local nCont			:= 0 
Local lTemQuery		:= .F.
Local nX
Local lCriaInd		:= .F.
Local nTamFilial 	:= TamSx3( "CT2_FILIAL" )[1]
Local lCT1EXDTFIM	:= CtbExDtFim("CT1")
Local lCTTEXDTFIM	:= CtbExDtFim("CTT")
Local lCTDEXDTFIM	:= CtbExDtFim("CTD")
Local lCTHEXDTFIM	:= CtbExDtFim("CTH")

Local nSlAntGap		:= 0	// Saldo Anterior
Local nSlAntGapD	:= 0	// Saldo anterior debito
Local nSlAntGapC	:= 0	// Saldo anterior credito	
Local nSlAtuGap		:= 0	// Saldo Atual           
Local nSlAtuGapD	:= 0	// Saldo Atual debito
Local nSlAtuGapC	:= 0	// Saldo Atual credito
Local nSlDebGap		:= 0	// Saldo Debito
Local nSlCrdGap		:= 0	// Saldo Credito

Local aEntidIni		:= {}
Local aEntidFim		:= {}

#IFDEF TOP
	Local aStruTmp		:= {}
	Local lTemQry		:= .F.
	Local nTrb			:= 0	                              
#ENDIF

Local nDigitos		:= 0
Local nMeter		:= 0
Local nPosG			:= 0
Local nDigitosG		:= 0 
Local aAreaAnt		:= Nil  

Local _lCtbIsCube	:= FindFunction( "CtbIsCube" ) .And. CtbIsCube()
Local aTmpFil		:= {}

//Variaveis para atualizar a regua desde as rotinas de geracao do arquivo temporario
Private oMeter1 		:= oMeter
Private oText1 		:= oText

DEFAULT lConsSaldo   := .F.
DEFAULT lPlGerSint   := .F.
DEFAULT cSegmentoG 	:= ""
DEFAULT lUsGaap		:=.F.
DEFAULT cMoedConv	:= ""
DEFAULT	cConsCrit	:= ""
DEFAULT dDataConv	:= CTOD("  /  /  ")
DEFAULT nTaxaConv	:= 0
DEFAULT lImpSint	:= .T.                                              
DEFAULT lImpMov		:= .T.
DEFAULT cSegmento	:= ""
DEFAULT cFilUsu		:= ".T."
DEFAULT lRecDesp0	:= .F.
DEFAULT cRecDesp 	:= ""                
DEFAULT dDtZeraRD	:= CTOD("  /  /  ")
DEFAULT lImp3Ent	:= .F.
DEFAULT lImp4Ent	:= .F.
DEFAULT lImpEntGer	:= .F.
DEFAULT lImpConta	:= .T.
DEFAULT lFiltraCC	:= .F.
DEFAULT lFiltraIt	:= .F.
DEFAULT lFiltraCV	:= .F.
DEFAULT cMoedaDsc	:= '01'
DEFAULT lMovPeriodo := .F.
DEFAULT aSelFil 	:= {}
DEFAULT dDtCorte 	:= CTOD("  /  /  ")
DEFAULT lCompEnt	:= .F.
DEFAULT cArqAux		:= "cArqTmp"
DEFAULT cArqTmp 	:= Nil
DEFAULT lUsaNmVis	:= .F. 
DEFAULT lCttSint	:= .F.
DEFAULT cQuadroCTB:= ""
DEFAULT lTodasFil   := .F.
DEFAULT aEntidades  := {}
DEFAULT cCodEntidade:= ""

__aTmpTCFil	:=	{}

If lRecDesp0 .And. ( Empty(cRecDesp) .Or. Empty(dDtZeraRD) )
	lRecDesp0 := .F.
EndIf

If FindFunction( "IsCtbJob" ) .And. IsCtbJob()
	DbSelectArea("CVO")
	CTBJobsStart()
	CheckCVO()
Endif

cIdent		:=	Iif(cIdent == Nil,'',cIdent)
nGrupo		:=	Iif(nGrupo == Nil,2,nGrupo)                                                 
cHeader		:= Iif(cHeader == Nil,'',cHeader)
cFiltroEnt	:= Iif(cFiltroEnt == Nil,"",cFiltroEnt)
cCodFilEnt	:= Iif(cCodFilEnt == Nil,"",cCodFilEnt)
Private nMin			:= 0
Private nMax			:= 0 

// Retorna Decimais
aCtbMoeda := CTbMoeda(cMoeda)
nDecimais := aCtbMoeda[5]
dMinData := CTOD("")

If ExistBlock("ESPGERPLAN")
	ExecBlock("ESPGERPLAN",.F.,.F.,{oMeter,oText,oDlg,lEnd,cArqtmp,dDataIni,dDataFim,cAlias,cIdent,cContaIni,cContaFim,;
									cCCIni,cCCFim,cItemIni,cItemFim,cClvlIni,cClVlFim,cMoeda,cSaldos,aSetOfBook,cSegmento,cSegIni,;
									cSegFim,cFiltSegm,lNImpMov,lImpConta,nGrupo,cHeader,lImpAntLP,dDataLP,nDivide,lVlrZerado,;
									cFiltroEnt,cCodFilEnt,cSegmentoG,cSegIniG,cSegFimG,cFiltSegmG,lUsGaap,cMoedConv,;
									cConsCrit,dDataConv,nTaxaConv,aGeren,lImpMov,lImpSint,cFilUSU,lRecDesp0,;
									cRecDesp,dDtZeraRD,lImp3Ent,lImp4Ent,lImpEntGer,lFiltraCC,lFiltraIt,lFiltraCV,aSelFil,dDtCorte,cQuadroCTB })

	Return(cArqTmp)
EndIf

If cAlias == 'CTY'	//Se for Balancete de 2 Entidades filtrando pela 3a Entidade.
	aCampos := {{ "ENTID1"		, "C", aTamConta[1], 0 },;  			// Codigo da Conta
				 { "ENTRES1"	, "C", aTamCtaRes[1],0 },;  			// Codigo Reduzido da Conta
				 { "DESCENT1"	, "C", nTamCta		, 0 },;  			// Descricao da Conta
	 			 { "TIPOENT1"  	, "C", 01			, 0 },;				// Centro de Custo Analitico / Sintetico				 
 				 { "ENTSUP1"	, "C", aTamCC[1]	, 0 },;				// Codigo do Centro de Custo Superior
	   	         { "ENTID2"		, "C", aTamCC[1]	, 0 },; 	 		// Codigo do Centro de Custo
				 { "ENTRES2"	, "C", aTamCCRes[1], 0 },;  			// Codigo Reduzido do Centro de Custo
				 { "DESCENT2"	, "C", nTamCC		, 0 },;  			// Descricao do Centro de Custo
				 { "TIPOENT2"	, "C", 01			, 0 },;				// Item Analitica / Sintetica			 
				 { "ENTSUP2"	, "C", aTamItem[1]	, 0 },; 			// Codigo do Item Superior
		 		 { "NORMAL"		, "C", 01			, 0 },;				// Situacao
				 { "SALDOANT"	, "N", aTamVal[1]+2, nDecimais},; 		// Saldo Anterior
	 		 	 { "SALDOANTDB"	, "N", aTamVal[1]+2	, nDecimais},; 		// Saldo Anterior Debito
			 	 { "SALDOANTCR"	, "N", aTamVal[1]+2	, nDecimais},; 		// Saldo Anterior Credito
			 	 { "SALDODEB"	, "N", aTamVal[1]+2	, nDecimais },;  	// Debito
				 { "SALDOCRD"	, "N", aTamVal[1]+2	, nDecimais },;  	// Credito
				 { "SALDOATU"	, "N", aTamVal[1]+2, nDecimais },;  	// Saldo Atual               
				 { "SALDOATUDB"	, "N", aTamVal[1]+2	, nDecimais },;  	// Saldo Atual Debito
			     { "SALDOATUCR"	, "N", aTamVal[1]+2	, nDecimais },;  	// Saldo Atual Credito
				 { "MOVIMENTO"	, "N", aTamVal[1]+2	, nDecimais },;  	// Movimento do Periodo
				 { "ORDEM"		, "C", 10			, 0 },;				// Ordem
				 { "GRUPO"		, "C", nTamGrupo	, 0 },;				// Grupo Contabil
		    	 { "IDENTIFI"	, "C", 01			, 0 },;			 
			     { "TOTVIS"		, "C", 01			, 0 },;			 
			     { "SLDENT"		, "C", 01			, 0 },;			 
			     { "FATSLD"		, "C", 01			, 0 },;			 
			     { "VISENT"		, "C", 01			, 0 },;			 
			  	 { "NIVEL1"		, "L", 01			, 0 }}				// Logico para identificar se eh de nivel 1 -> usado como totalizador do relatorio

ElseIf cAlias == 'CVY'	//Se for Balancete por cubo contabil

	aCampos := { { "ECX"		, "C", aTamConta[1], 0 },;  			// Codigo da Conta
				 { "ECXSUP"		, "C", aTamConta[1], 0 },;				// Conta Superior
		 		 { "ECXNORMAL"	, "C", 01			, 0 },;				// Situacao
				 { "ECXRES"		, "C", aTamCtaRes[1], 0 },;  			// Codigo Reduzido da Conta
				 { "ECXDESC"	, "C", nTamCta		, 0 },;  			// Descricao da Conta
				 { "ECY"		, "C", aTamCC[1]	, 0 },; 	 		// Codigo do Centro de Custo
				 { "ECYSUP"		, "C", aTamConta[1], 0 },;				// Conta Superior
		 		 { "ECYNORMAL"	, "C", 01			, 0 },;				// Situacao
				 { "ECYRES"		, "C", aTamCCRes[1], 0 },;  			// Codigo Reduzido do Centro de Custo
				 { "ECYDESC" 	, "C", nTamCC		, 0 },;  			// Descricao do Centro de Custo
				 { "SALDOANT"	, "N", aTamVal[1]+2	, nDecimais},; 		// Saldo Anterior
	   		 	 { "SALDOANTDB"	, "N", aTamVal[1]+2	, nDecimais},; 		// Saldo Anterior Debito
 				 { "SALDOANTCR"	, "N", aTamVal[1]+2	, nDecimais},; 		// Saldo Anterior Credito
				 { "SALDODEB"	, "N", aTamVal[1]+2	, nDecimais },;  	// Debito
				 { "SALDOCRD"	, "N", aTamVal[1]+2	, nDecimais },;  	// Credito
				 { "SALDOATU"	, "N", aTamVal[1]+1	, nDecimais },;  	// Saldo Atual               
				 { "SALDOATUDB"	, "N", aTamVal[1]+2	, nDecimais },;  	// Saldo Atual Debito
				 { "SALDOATUCR"	, "N", aTamVal[1]+2	, nDecimais },;  	// Saldo Atual Credito
				 { "MOVIMENTO"	, "N", aTamVal[1]+2	, nDecimais },;  	// Movimento do Periodo
				 { "TIPOECX"	, "C", 01			, 0 },;				// Conta Analitica / Sintetica           
 				 { "TIPOECY"  	, "C", 01			, 0 },;				// Centro de Custo Analitico / Sintetico
				 { "ORDEM"		, "C", 10			, 0 },;				// Ordem
				 { "GRUPO"		, "C", nTamGrupo	, 0 },;				// Grupo Contabil
			     { "IDENTIFI"	, "C", 01			, 0 },;			 
			     { "TOTVIS"		, "C", 01			, 0 },;			 
			     { "SLDENT"		, "C", 01			, 0 },;			 
			     { "FATSLD"		, "C", 01			, 0 },;			 
			     { "VISENT"		, "C", 01			, 0 },;			 
   			     { "ESTOUR" 	, "C", 01			, 0 },;			 	//Define se a conta esta estourada ou nao
				 { "NIVEL1"		, "L", 01			, 0 },; 
			 	 { "NATCTA"     , "C", 02           , 0 }}             //NATCTA -campo de natureza da conta para relatorio CTBR047					 

																		// totalizador do relatorio
Else
	aCampos := { { "CONTA"		, "C", aTamConta[1], 0 },;  			// Codigo da Conta
				 { "SUPERIOR"	, "C", aTamConta[1], 0 },;				// Conta Superior
		 		 { "NORMAL"		, "C", 01			, 0 },;				// Situacao
				 { "CTARES"		, "C", aTamCtaRes[1], 0 },;  			// Codigo Reduzido da Conta
				 { "DESCCTA"	, "C", nTamCta		, 0 },;  			// Descricao da Conta        
				 { "CUSTO"		, "C", aTamCC[1]	, 0 },; 	 		// Codigo do Centro de Custo
				 { "CCRES"		, "C", aTamCCRes[1], 0 },;  			// Codigo Reduzido do Centro de Custo
				 { "DESCCC" 	, "C", nTamCC		, 0 },;  			// Descricao do Centro de Custo
		         { "ITEM"		, "C", aTamItem[1]	, 0 },; 	 		// Codigo do Item          
				 { "ITEMRES" 	, "C", aTamItRes[1], 0 },;  			// Codigo Reduzido do Item
				 { "DESCITEM" 	, "C", nTamItem		, 0 },;  			// Descricao do Item
	             { "CLVL"		, "C", aTamClVl[1]	, 0 },; 	 		// Codigo da Classe de Valor
    	         { "CLVLRES"	, "C", aTamCVRes[1], 0 },; 		 	// Cod. Red. Classe de Valor
				 { "DESCCLVL"   , "C", nTamClVl		, 0 },;  			// Descricao da Classe de Valor
				 { "SALDOANT"	, "N", aTamVal[1]+2	, nDecimais},; 		// Saldo Anterior
	   		 	 { "SALDOANTDB"	, "N", aTamVal[1]+2	, nDecimais},; 		// Saldo Anterior Debito
 				 { "SALDOANTCR"	, "N", aTamVal[1]+2	, nDecimais},; 		// Saldo Anterior Credito
				 { "SALDODEB"	, "N", aTamVal[1]+2	, nDecimais },;  	// Debito
				 { "SALDOCRD"	, "N", aTamVal[1]+2	, nDecimais },;  	// Credito
				 { "SALDOATU"	, "N", aTamVal[1]+1	, nDecimais },;  	// Saldo Atual               
				 { "SALDOATUDB"	, "N", aTamVal[1]+2	, nDecimais },;  	// Saldo Atual Debito
				 { "SALDOATUCR"	, "N", aTamVal[1]+2	, nDecimais },;  	// Saldo Atual Credito
				 { "MOVIMENTO"	, "N", aTamVal[1]+2	, nDecimais },;  	// Movimento do Periodo
				 { "TIPOCONTA"	, "C", 01			, 0 },;				// Conta Analitica / Sintetica           
 				 { "TIPOCC"  	, "C", 01			, 0 },;				// Centro de Custo Analitico / Sintetico
	 			 { "TIPOITEM"	, "C", 01			, 0 },;				// Item Analitica / Sintetica			 
 				 { "TIPOCLVL"	, "C", 01			, 0 },;				// Classe de Valor Analitica / Sintetica			 
	 			 { "CCSUP"		, "C", aTamCC[1]	, 0 },;				// Codigo do Centro de Custo Superior
				 { "ITSUP"		, "C", aTamItem[1]	, 0 },;				// Codigo do Item Superior
	 			 { "CLSUP"	    , "C", aTamClVl[1] , 0 },;				// Codigo da Classe de Valor Superior
				 { "ORDEM"		, "C", 10			, 0 },;				// Ordem
				 { "GRUPO"		, "C", nTamGrupo	, 0 },;				// Grupo Contabil
			     { "IDENTIFI"	, "C", 01			, 0 },;			 
			     { "TOTVIS"		, "C", 01			, 0 },;			 
			     { "SLDENT"		, "C", 01			, 0 },;			 
			     { "FATSLD"		, "C", 01			, 0 },;			 
			     { "VISENT"		, "C", 01			, 0 },;			 
   			     { "ESTOUR" 	, "C", 01			, 0 },;			 	//Define se a conta esta estourada ou nao
				 { "NIVEL1"		, "L", 01			, 0 },; 
			 	 { "NATCTA"     , "C", 02           , 0 }}             //NATCTA -campo de natureza da conta para relatorio CTBR047					 
					                                                 	// Logico para identificar se 
																		// eh de nivel 1 -> usado como
	   		                                                           // totalizador do relatorio]
	   		                                                           
	If _lCtbIsCube	 
		aAreaAnt := GetArea() 
			DbSelectArea('CT0')
			DbSetOrder(1)
			If DbSeek( xFilial('CT0') + '05' )
				While CT0->(!Eof()) .And. CT0->CT0_FILIAL == xFilial('CT0') 
			   		                                                         
			      	AADD( aCampos,{ "CODENT"+CT0->CT0_ID	, "C", TamSx3(CT0->CT0_CPOCHV)[1]	, 0 } )
			      	AADD( aCampos,{ "DESCENT"+CT0->CT0_ID  	, "C", TamSx3(CT0->CT0_CPODSC)[1]	, 0 } )
			      	AADD( aCampos,{ "TIPOENT"+CT0->CT0_ID  	, "C", 01	, 0 } )    
			      	
					CT0->(DbSkip())			   		 	                                                        
				EndDo			   		                                                           
	   		EndIf                                                           
		RestArea(aAreaAnt)	   		      
	EndIf	   		                                                           

// Usado no mutacoes de patrimonio liquido inclui campo que alem da descricao da entidade
// Que esta no DESCCTA tem tambem a descricao da conta inicial CTS_CT1INI
	If 	Type("lTRegCts") # "U" .And. ValType(lTRegCts) = "L" .And. lTRegCts
		Aadd(aCampos, { "DESCORIG"	, "C", nTamCta		, 0 } )	// Descricao da Origem do Valor
	Endif
EndIf

Aadd(aCampos, { "FILIAL"	, "C", nTamFilial, 0 } )	// Cria Filial do Sistema
If CTS->(FieldPos("CTS_COLUNA")) > 0
	Aadd(aCampos, { "COLUNA"   	, "N", 01			, 0 })
Endif
If 	Type("dSemestre") # "U" .And. ValType(dSemestre) = "D"
	Aadd(aCampos, { "SALDOSEM"	, "N", 17		, nDecimais }) 	// Saldo semestre
Endif

If Type("dPeriodo0") # "U" .And. ValType(dPeriodo0) = "D"
	Aadd(aCampos, { "SALDOPER"	, "N", 17		, nDecimais }) 	// Saldo Periodo determinado
	Aadd(aCampos, { "MOVIMPER"	, "N", 17		, nDecimais }) 	// Saldo Periodo determinado
Endif

If Type("lComNivel") # "U" .And. ValType(lComNivel) = "L"
	Aadd(aCampos, { "NIVEL"   	, "N", 01			, 0 })		// Nivel hieraquirco - Quanto maior mais analitico
Endif	

If ( cAlias = "CT7" .And. SuperGetMv("MV_CTASUP") = "S" ) .Or. ;
	( cAlias = "CT3" .And. SuperGetMv("MV_CTASUP") = "S" ) .Or. ;
	(cAlias == "CTU" .And. cIdent == "CTT" .And. GetNewPar("MV_CCSUP","")  == "S")  .Or. ;
	(cAlias == "CTU" .And. cIdent == "CTD" .And. GetNewPar("MV_ITSUP","") == "S") .Or. ;
	(cAlias == "CTU" .And. cIdent == "CTH" .And. GetNewPar("MV_CLSUP","") == "S") 
	Aadd(aCampos, { "ORDEMPRN" 	, "N", 06			, 0 })		// Ordem para impressao
Endif

If lMovPeriodo
	Aadd(aCampos, { "MOVPERANT"		, "N" , 17			, nDecimais }) 	// Saldo Periodo Anterior
EndIf
     
///// TRATAMENTO PARA ATUALIZAÇÃO DE SALDO BASE
//Se os saldos basicos nao foram atualizados na dig. lancamentos
If !lAtSldBase
	dIniRep := ctod("")
  	If Need2Reproc(dDataFim,cMoeda,cSaldos,@dIniRep) 
		//Chama Rotina de Atualizacao de Saldos Basicos.
		oProcess := MsNewProcess():New({|lEnd|	CTBA190(.T.,dIniRep,dDataFim,cFilAnt,cFilAnt,cSaldos,.T.,cMoeda) },"","",.F.)
		oProcess:Activate()						
	EndIf
Endif	

//// TRATAMENTO PARA ATUALIZAÇÃO DE SALDOS COMPOSTOS ANTES DE EXECUTAR A QUERY DE FILTRAGEM
Do Case
Case cAlias == 'CTU'
	//Verificar se tem algum saldo a ser atualizado por entidade
	If cIdent == "CTT"
		cOrigem := 	'CT3'
	ElseIf cIdent == "CTD"
		cOrigem := 	'CT4'
	ElseIf cIdent == "CTH"
		cOrigem := 	'CTI'		
	Else
		cOrigem := 	'CTI'		
	Endif
Case cAlias == 'CTV'
	cOrigem := "CT4"
	//Verificar se tem algum saldo a ser atualizado
Case cAlias == 'CTW'			
	cOrigem		:= 'CTI'	/// HEADER POR CLASSE DE VALORES
	//Verificar se tem algum saldo a ser atualizado
Case cAlias == 'CTX'			
	cOrigem		:= 'CTI'		
EndCase	
              
IF cAlias$("CTU/CTV/CTW/CTX")
	Ct360Data(cOrigem,cAlias,@dMinData,lCusto,lItem,cFilDe,cFilAte,cSaldos,cMoeda,cMoeda,,,,,,,,,,cFilAnt,,aSelFil,lTodasFil)
	If lAtSldCmp .And. !Empty(dMinData)	//Se atualiza saldos compostos
		oProcess := MsNewProcess():New({|lEnd|	CtAtSldCmp(oProcess,cAlias,cSaldos,cMoeda,dDataIni,cOrigem,dMinData,cFilDe,cFilAte,lCusto,lItem,lClVl,lAtSldBase,,,cFilAnt,aSelFil,lTodasFil,aTmpFil)},"","",.F.)
		oProcess:Activate()	
	Else		//Se nao atualiza os saldos compostos, somente da mensagem
		If !Empty(dMinData)
			cMensagem	:= "Os saldos compostos estao desatualizados...Favor atualiza-los"
			cMensagem	+= "atraves da rotina de saldos compostos"		
			MsgAlert(OemToAnsi(cMensagem))	//Os saldos compostos estao desatualizados...Favor atualiza-los					
			Return							//atraves da rotina de saldos compostos	
		EndIf    
	EndIf	
Endif

Do Case
//************************************
// Consulta saldo pelo cubo contabil *
//************************************
Case cAlias  == "CVY"
	cEntidIni	:= cContaIni
	cEntidFim	:= cContaFim
	cCodMasc		:= aSetOfBook[2]
	cChave := "ECX+ECY"

	#IFDEF TOP   
		If TcSrvType() != "AS/400"                     			
			//Se nao tiver plano gerencial. 
			If Empty(aSetOfBook[5])
				/// EXECUTA QUERY RETORNANDO A ESTRUTURA E SALDOS NO ALIAS TRBTMP
				If cFilUsu == ".T."
					cFilUsu := ""
				EndIf
				CtbRunCube(dDataIni,dDataFim,cAlias,cEntidIni,cEntidFim,cCCIni,cCCFim,cMoeda,;
							cSaldos,aSetOfBook,lImpMov,lVlrZerado,lImpAntLp,dDataLP,cFilUsu,cMoedaDsc,aSelFil,dDtCorte,lTodasFil,aTmpFil)
							
				If Empty(cFilUSU)
					cFILUSU := ".T."
				Endif						
				lTemQuery := .T.
			Endif
		EndIf
	#ENDIF

Case cAlias  == "CT7"            
	cEntidIni	:= cContaIni
	cEntidFim	:= cContaFim
	cCodMasc		:= aSetOfBook[2]
	If nGrupo == 2
		cChave := "CONTA"
	Else									// Indice por Grupo -> Totaliza por grupo
		cChave := "CONTA+GRUPO"
	EndIf

	#IFDEF TOP   
		If TcSrvType() != "AS/400"                     			
			//Se nao tiver plano gerencial. 
			If Empty(aSetOfBook[5])
				/// EXECUTA QUERY RETORNANDO A ESTRUTURA E SALDOS NO ALIAS TRBTMP
				If cFilUsu == ".T."
					cFilUsu := ""
				EndIf
				CT7BlnQry(dDataIni,dDataFim,cAlias,cEntidIni,cEntidFim,cMoeda,;
							cSaldos,aSetOfBook,lImpMov,lVlrZerado,lImpAntLp,dDataLP,cFilUsu,cMoedaDsc,aSelFil,dDtCorte,lTodasFil,aTmpFil)
				If Empty(cFilUSU)
					cFILUSU := ".T."
				Endif						
				lTemQuery := .T.
			Endif
		EndIf
	#ENDIF

Case cAlias == 'CT3'    
	cEntidIni	:= cCCIni
	cEntidFim	:= cCCFim

	If lImpConta	
		If cHeader == "CT1"
			cChave		:= "CONTA+CUSTO"
			cCodMasc	:= aSetOfBook[2]				
		Else
			If nGrupo == 2
				cChave   := "CUSTO+CONTA"                      
			Else									// Indice por Grupo -> Totaliza por grupo
				cChave := "CUSTO+CONTA+GRUPO"
			EndIf	
			cCodMasc	:= aSetOfBook[2]					
			cMascaraG	:= aSetOfBook[6]			
		Endif
	Else		//Balancete de Centro de Custo (filtrando por conta) 
		cChave	:= "CUSTO"
		cCodMasc:= aSetOfBook[6]
	EndIf

	#IFDEF TOP
		If TcSrvType() != "AS/400" .and. Empty(aSetOfBook[5])
			If cFilUsu == ".T."
				cFilUsu := ""
			EndIf
			If lImpConta
				IF !lCompEnt
					/// EXECUTA QUERY RETORNANDO A ESTRUTURA E SALDOS NO ALIAS TRBTMP
					CT3BlnQry(dDataIni,dDataFim,cAlias,cContaIni,cContaFim,cCCIni,cCCFim,cMoeda,;
								cSaldos,aSetOfBook,lImpMov,lVlrZerado,lImpAntLp,dDataLP,cFilUSU,aSelFil,lTodasFil,aTmpFil)						
				Else
					/// EXECUTA QUERY RETORNANDO A ESTRUTURA E SALDOS NO ALIAS TRBTMP
					CT3BlnQryC(dDataIni,dDataFim,cAlias,cContaIni,cContaFim,cCCIni,cCCFim,cMoeda,;
								cSaldos,aSetOfBook,lImpMov,lVlrZerado,lImpAntLp,dDataLP,cFilUSU,aSelFil,,aTmpFil)
				Endif
			Else
				Ct3Bln1Ent(dDataIni,dDataFim,cAlias,cContaIni,cContaFim,cCCIni,cCCFim,cMoeda,;
					cSaldos,aSetOfBook,lImpMov,lVlrZerado,lImpAntLP,dDataLP,cFilUsu,;
							lRecDesp0,cRecDesp,dDtZeraRD,aSelFil,lTodasFil,aTmpFil)	
			EndIf						
			lTemQuery := .T.
			If Empty(cFilUSU)
				cFILUSU := ".T."
			Endif												
		EndIf
	#ENDIF		

Case cAlias =='CT4' 
	If lImp3Ent	//Balancete CC / Conta / Item
		If cHeader == "CTT"
			#IFDEF TOP
				If TcSrvType() != "AS/400" .and. Empty(aSetOfBook[5])
					If cFilUsu == ".T."
						cFilUsu := ""
					EndIf
					/// EXECUTA QUERY RETORNANDO A ESTRUTURA E SALDOS NO ALIAS TRBTMP
					CT4Bln3Ent(dDataIni,dDataFim,cAlias,cContaIni,cContaFim,cCCIni,cCCFim,cItemIni,cItemFim,cMoeda,;
								cSaldos,aSetOfBook,lImpMov,lVlrZerado,lImpAntLp,dDataLP,cFilUSU,aSelFil,lTodasFil,aTmpFil)
					lTemQuery := .T.
					If Empty(cFilUSU)
						cFILUSU := ".T."
					Endif	
				EndIf
			#ENDIF		
			cEntidIni	:= cCCIni
			cEntidFim	:= cCCFim
			cChave		:= "CUSTO+CONTA+ITEM"
			cCodMasc	:= aSetOfBook[2]
		EndIf	
	Else
		cEntidIni	:= cItemIni
		cEntidFim	:= cItemFim
		If lImpConta
			If cHeader == "CT1"	//Se for for Balancete Conta x Item
				cChave	:= "CONTA+ITEM"
				cCodMasc		:= aSetOfBook[4]			
			Else
				cChave   := "ITEM+CONTA"	
				cCodMasc		:= aSetOfBook[2]					
			EndIf	
		Else	//Balancete de Item filtrando por conta
			cChave		:= "ITEM"
			cCodMasc	:= aSetOfBook[7]
		EndIf
		#IFDEF TOP
			If TcSrvType() != "AS/400" .and. Empty(aSetOfBook[5])
			If cFilUsu == ".T."
				cFilUsu := ""
			EndIf
			If lImpConta
				/// EXECUTA QUERY RETORNANDO A ESTRUTURA E SALDOS NO ALIAS TRBTMP
				CT4BlnQry(dDataIni,dDataFim,cAlias,cContaIni,cContaFim,cItemIni,cItemFim,cMoeda,;
							cSaldos,aSetOfBook,lImpMov,lVlrZerado,lImpAntLp,dDataLP,cFilUSU,aSelFil,lTodasFil,aTmpFil)
			Else
				Ct4Bln1Ent(dDataIni,dDataFim,cAlias,cContaIni,cContaFim,cCCIni,cCCFim,cItemIni,cItemFim,;
							cMoeda,cSaldos,aSetOfBook,lImpMov,lVlrZerado,lImpAntLP,dDataLP,cFilUsu,;
							lRecDesp0,cRecDesp,dDtZeraRD,aSelFil,lTodasFil,aTmpFil)	
			EndIf
			lTemQuery := .T.
			If Empty(cFilUSU)
				cFILUSU := ".T."
			Endif												
			EndIf
		#ENDIF	
	EndIf
Case cAlias == 'CTI'     
	If lImp4Ent	//Balancete CC x Cta x Item x Cl.Valor
		If cHeader == "CTT"             
			#IFDEF TOP
				If TcSrvType() != "AS/400" .and. Empty(aSetOfBook[5]) .and. !lImpAntLP
					If cFilUsu == ".T."
						cFilUsu := ""
					EndIf
					/// EXECUTA QUERY RETORNANDO A ESTRUTURA E SALDOS NO ALIAS TRBTMP
					CTIBln4Ent(dDataIni,dDataFim,cAlias,cContaIni,cContaFim,cCCIni,cCCFim,cItemIni,cItemFim,;
								cClVlIni,cClVlFim,cMoeda,cSaldos,aSetOfBook,lImpMov,lVlrZerado,lImpAntLp,dDataLP,aSelFil,lTodasFil,aTmpFil)
					lTemQuery := .T.
					If Empty(cFilUSU)
						cFILUSU := ".T."
					Endif															
				EndIf
			#ENDIF				
			cChave		:= "CUSTO+CONTA+ITEM+CLVL"
			cEntidIni	:= cCCIni
			cEntidFim	:= cCCFim
			cCodMasc	:= aSetOfBook[2]			
		EndIf	
	Else
		cEntidIni	:= cClVlIni
		cEntidFim	:= cClvlFim
	
		If lImpConta
			If cHeader == "CT1"
				cChave		:= "CONTA+CLVL"
				cCodMasc	:= aSetOfBook[2]				
			Else		
				cChave   := "CLVL+CONTA"
			EndIf     
			#IFDEF TOP
				If TcSrvType() != "AS/400" .and. Empty(aSetOfBook[5])							
					If cFilUsu == ".T."
						cFilUsu := ""
					EndIf
					/// EXECUTA QUERY RETORNANDO A ESTRUTURA E SALDOS NO ALIAS TRBTMP
					CTIBlnQry(dDataIni,dDataFim,cAlias,cContaIni,cContaFim,cClVlIni,cClVlFim,cMoeda,;
								cSaldos,aSetOfBook,lImpMov,lVlrZerado,lImpAntLp,dDataLP,cFilUSU,aSelFil,lTodasFil,aTmpFil)
					lTemQuery := .T.
					If Empty(cFilUSU)
						cFILUSU := ".T."
					Endif															
				EndIf
			#ENDIF							
		Else	//Balancete de Cl.Valor filtrando por conta
			cChave   := "CLVL"
			cCodMasc := aSetOfBook[8]	
			#IFDEF TOP
				If TcSrvType() != "AS/400" .and. Empty(aSetOfBook[5])			
					If cFilUsu == ".T."
						cFilUsu := ""
					EndIf
					CtIBln1Ent(dDataIni,dDataFim,cAlias,cContaIni,cContaFim,cCCIni,cCCFim,cItemIni,cItemFim,;
								cClVlIni,cClVlFim,cMoeda,cSaldos,aSetOfBook,lImpMov,lVlrZerado,lImpAntLP,dDataLP,cFilUsu,;
								lRecDesp0,cRecDesp,dDtZeraRD,aSelFil,lTodasFil,aTmpFil)	
					lTemQuery := .T.
					If Empty(cFilUSU)
						cFILUSU := ".T."
					Endif															
				EndIf
			#ENDIF							
		EndIf
	EndIf
Case cAlias == 'CTU'
	If cIdent == 'CTT'
		cEntidIni	:= cCCIni
		cEntidFim	:= cCCFim	
		cChave		:= "CUSTO"
		cCodMasc		:= aSetOfBook[6]		
	ElseIf cIdent == 'CTD'
		cEntidIni	:= cItemIni
		cEntidFim	:= cItemFim		
		cChave   := "ITEM"
		cCodMasc		:= aSetOfBook[7]		
	ElseIf cIdent == 'CTH'
		cEntidIni	:= cClVlIni
		cEntidFim	:= cClvlFim		
		cChave   := "CLVL"
		cCodMasc		:= aSetOfBook[8]		
	Endif
	#IFDEF TOP  
		If TcSrvType() != "AS/400" .and. Empty(aSetOfBook[5])
			/// EXECUTA QUERY RETORNANDO A ESTRUTURA E SALDOS NO ALIAS TRBTMP
			If cFilUsu == ".T."
				cFilUsu := ""
			EndIf
			CTUBlnQry(dDataIni,dDataFim,cAlias,cIdent,cEntidIni,cEntidFim,cMoeda,cSaldos,aSetOfBook,lImpMov,lVlrZerado,lImpAntLP,dDataLP,cFilUsu,aSelFil,lTodasFil,aTmpFil)
			lTEmQuery := .T.
			If Empty(cFilUSU)
				cFILUSU := ".T."
			Endif								
		EndIf
	#ENDIF	
Case cAlias == 'CTV'           
	If cHeader == 'CTT'
		cChave   := "CUSTO+ITEM"	
		cEntidIni1	:= cCCIni
		cEntidFim1	:= cCCFim
		cEntidIni2	:= cItemIni
		cEntidFim2	:= cItemFim
	ElseIf cHeader == 'CTD'
		cChave   := "ITEM+CUSTO"	
		cEntidIni1	:= cItemIni
		cEntidFim1	:= cItemFim	
		cEntidIni2	:= cCCIni
		cEntidFim2	:= cCCFim
	EndIf
Case cAlias == 'CTW'
	If cHeader	== 'CTT'
		cChave   := "CUSTO+CLVL"			
		cEntidIni1	:=	cCCIni
		cEntidFim1	:=	cCCFim 	            		
		cEntidIni2	:=	cClVlIni
		cEntidFim2	:=	cClVlFim		
	ElseIf cHeader == 'CTH'                
		cChave   := "CLVL+CUSTO"			
		cEntidIni1	:=	cClVlIni
		cEntidFim1	:=	cClVlFim
		cEntidIni2	:=	cCCIni
		cEntidFim2	:=	cCCFim 	
	EndIf	
Case cAlias == 'CTX'
	If cHeader == 'CTD'
		cChave  	 := "ITEM+CLVL"			
		cEntidIni1	:= 	cItemIni
		cEntidFim1	:= 	cItemFim
		cEntidIni2	:= 	cClVlIni
		cEntidFim2	:= 	cClVlFim		
	ElseIf cHeader == 'CTH'
		cChave  	 := "CLVL+ITEM"			
		cEntidIni1	:= 	cClVlIni
		cEntidFim1	:= 	cClVlFim			
		cEntidIni2	:= 	cItemIni 	
		cEntidFim2	:= 	cItemFim 	
	EndIf                                
Case cAlias	== 'CTY'
	cChave			:="ENTID1+ENTID2"
	If cHeader == 'CTT' .And. cFiltroEnt == 'CTD'	
		cEntidIni1	:= cCCIni
		cEntidFim1	:= cCCFim
		cEntidIni2	:= cClVlIni
		cEntidFim2	:= cClvlFim
	ElseIf cHeader == 'CTT' .And. cFiltroEnt == 'CTH'
		cEntidIni1	:= cCCIni
		cEntidFim1	:= cCCFim
		cEntidIni2	:= cItemIni
		cEntidFim2	:= cItemFim
	ElseIf cHeader == 'CTD' .And. cFiltroEnt == 'CTT'
		cEntidIni1	:= cItemIni
		cEntidFim1	:= cItemFim	
		cEntidIni2	:= cClVlIni
		cEntidFim2	:= cClVlFim	
	ElseIf cHeader == 'CTD' .And. cFiltroEnt == 'CTH'
		cEntidIni1	:= cItemIni
		cEntidFim1	:= cItemFim	
		cEntidIni2	:= cCCIni
		cEntidFim2	:= cCCFim		
	ElseIf cHeader == 'CTH' .And. cFiltroEnt == 'CTT'
		cEntidIni1	:= cClVlIni
		cEntidFim1	:= cClVlFim	
		cEntidIni2	:= cItemIni
		cEntidFim2	:= cItemFim		
	ElseIf cHeader == 'CTH' .And. cFiltroEnt == 'CTD'
		cEntidIni1	:= cClVlIni
		cEntidFim1	:= cClVlFim	
		cEntidIni2	:= cCCIni
		cEntidFim2	:= cCCFim					
	EndIf		
EndCase

If !Empty(aSetOfBook[5])				// Indica qual o Plano Gerencial Anexado
	If cAlias $ "CT3/CT4/CTI"		//Se for Balancete Entidade/Entidade Gerencial
		Do Case
		Case cAlias == "CT3"
			cChave	:= "CUSTO+CONTA"			
		Case cAlias == "CT4"
			cChave	:= "ITEM+CONTA"						
		Case cAlias == "CTI"
			cChave	:= "CLVL+CONTA"						
		EndCase		
	ElseIf cAlias = 'CTU'
		Do Case
		Case cIdent = 'CTT'
			cChave	:= "CUSTO"		
		Case cIdent = 'CTD'
			cChave	:= "ITEM"		
		Case cIdent = 'CTH'
			cChave	:= "CLVL"		
		EndCase	
	Else 
		If _lCtbIsCube        
			If !Empty(cCodEntidade)
			   cChave	:= "CODENT"+cCodEntidade
			Else
			   cChave	:= "CONTA"			
			EndIf			   
		Else
		   cChave	:= "CONTA"		
		EndIF		   
	EndIf  
Endif


If Empty( aCampos )
	ConOut("Erro na criacao da tabela temporaria")
	Return .F.
EndIf

cArqTmp := CriaTrab(aCampos, .T.)
dbUseArea( .T.,, cArqTmp, cArqAux, .F., .F. )
lCriaInd := .T.

DbSelectarea(cArqAux)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria Indice Temporario do Arquivo de Trabalho 1.             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lCriaInd
	cArqInd	:= CriaTrab(Nil, .F.)
	IndRegua(cArqAux,cArqInd,cChave,,,OemToAnsi("Selecionando Registros..."))  //"Selecionando Registros..."

	If !Empty(aSetOfBook[5])				// Indica qual o Plano Gerencial Anexado
		cArqTmp1 := CriaTrab(, .F.)
		IndRegua(cArqAux,cArqTmp1,"ORDEM",,,OemToAnsi("Selecionando Registros..."))  //"Selecionando Registros..."
	Endif	
	
	dbSelectArea(cArqAux)
	DbClearIndex()
	dbSetIndex(cArqInd+OrdBagExt())
	
	If !Empty(aSetOfBook[5])				// Indica qual o Plano Gerencial Anexado
		dbSetIndex(cArqTmp1+OrdBagExt())
	Endif
Endif
#IFDEF TOP
	If FunName() <> "CTBR195" .or. (FunName() == "CTBR195" .and. !lImpAntLP)
		//// SE FOR DEFINIÇÃO TOP 
		If TcSrvType() != "AS/400" .and. lTemQuery .and. Select("TRBTMP") > 0 	/// E O ALIAS TRBTMP ESTIVER ABERTO (INDICANDO QUE A QUERY FOI EXECUTADA)							
			If !Empty(cSegmento)
				If Len(aSetOfBook) == 0 .or. Empty(aSetOfBook[1])
					Help("CTN_CODIGO")
					Return(cArqTmp)
				Endif
				dbSelectArea("CTM")
				dbSetOrder(1)
				If MsSeek(xFilial()+cCodMasc)
					While !Eof() .And. CTM->CTM_FILIAL == xFilial() .And. CTM->CTM_CODIGO == cCodMasc
						nPos += Val(CTM->CTM_DIGITO)
						If CTM->CTM_SEGMEN == strzero(val(cSegmento),2)
							nPos -= Val(CTM->CTM_DIGITO)
							nPos ++
							nDigitos := Val(CTM->CTM_DIGITO)      
							Exit
						EndIf	
						dbSkip()
					EndDo	
				Else
					Help("CTM_CODIGO")
					Return(cArqTmp)
				EndIf	
			EndIf	
			
			If cAlias == "CT3" .And. cHeader == "CTT" .And. !Empty(cMascaraG)
				If !Empty(cSegmentoG)
					dbSelectArea("CTM")
					dbSetOrder(1)
					If MsSeek(xFilial()+cMascaraG)
						While !Eof() .And. CTM->CTM_FILIAL == xFilial() .And. CTM->CTM_CODIGO == cMascaraG
							nPosG += Val(CTM->CTM_DIGITO)
							If CTM->CTM_SEGMEN == cSegmentoG
								nPosG -= Val(CTM->CTM_DIGITO)
								nPosG ++
								nDigitosG := Val(CTM->CTM_DIGITO)      
								Exit
							EndIf	
							dbSkip()
						EndDo	
					EndIf	
				EndIf		
			EndIf	
			
  			dbSelectArea("TRBTMP")
			aStruTMP := dbStruct()			/// OBTEM A ESTRUTURA DO TMP

			nCampoLP	 := Ascan(aStruTMP,{|x| x[1]=="SLDLPANTDB"})
			dbSelectArea("TRBTMP")
			If ValType(oMeter) == "O"				
				oMeter:SetTotal(TRBTMP->(RecCount()))
				oMeter:Set(0)
			EndIf

			dbGoTop()						/// POSICIONA NO 1º REGISTRO DO TMP
			While TRBTMP->(!Eof())			/// REPLICA OS DADOS DA QUERY (TRBTMP) PARA P/ O TEMPORARIO EM DISCO
		
				//Se nao considera apuracao de L/P sera verificado na propria query
				dbSelectArea("TRBTMP")								
				If !lVlrZerado .And. lImpAntLP
					If TRBTMP->((SALDOANTDB - SLDLPANTDB) - (SALDOANTCR - SLDLPANTCR)) == 0 .And. ;
						TRBTMP->(SALDODEB-MOVLPDEB) == 0 .And. TRBTMP->(SALDOCRD-MOVLPCRD) == 0					
						dbSkip()
						Loop  				
					EndIf				
				ElseIf !lVlrZerado
					If TRBTMP->(SALDOANTDB - SALDOANTCR) == 0 .And. TRBTMP->SALDODEB == 0 .And. TRBTMP->SALDOCRD == 0
						dbSkip()
						Loop				
					EndIf								
				EndIf					

				//Verificacao da  Data Final de Existencia da Entidade somente se imprime saldo zerado 
				// e se realemten nao tiver saldo e movimento para a entidade. Caso tenha algum movimento
				//ou saldo devera imprimir.  												
				If lVlrZerado 
					If lImpAntLP 					
						If ((SALDOANTDB - SLDLPANTDB) == 0 .And. (SALDOANTCR - SLDLPANTCR) == 0 .And. ;
							(SALDODEB-MOVLPDEB) == 0 .And. (SALDOCRD-MOVLPCRD) == 0)
							//Se a data de existencia final  da entidade estiver preenchida e a data inicial do
							//relatorio for maior, nao ira imprimir a entidade. 
							If  cAlias $ "CT7/CT3/CT4/CTI" 
								If lCT1EXDTFIM .AND. type( 'TRBTMP->CT1DTEXSF' ) # 'U'
									IF !Empty(TRBTMP->CT1DTEXSF) .And. (dDataIni > TRBTMP->CT1DTEXSF)  
										dbSelectArea("TRBTMP")
										dbSkip()
										Loop													
									EndIf
								EndIf
							Endif
							
							If cAlias == "CT3" .Or. ( cAlias == "CTU" .And. cIdent == "CTT")  .Or. ( cAlias == "CTI" .And. lImp4Ent)
								If lCTTEXDTFIM .and. type( 'TRBTMP->CTTDTEXSF' ) # 'U'
									If !Empty(TRBTMP->CTTDTEXSF) .And. (dDataIni > TRBTMP->CTTDTEXSF)  
										dbSelectArea("TRBTMP")
										dbSkip()
										Loop													
									EndIf                     
								Endif
							EndIf                               
					
							If cAlias == "CT4" .Or. ( cAlias == "CTU" .And. cIdent == "CTD") .Or. ( cAlias == "CTI" .And. lImp4Ent)
								If lCTDEXDTFIM .AND. type( 'TRBTMP->CTDDTEXSF' ) # 'U'
									IF !Empty(TRBTMP->CTDDTEXSF) .And. (dDataIni > TRBTMP->CTDDTEXSF)  
										dbSelectArea("TRBTMP")
										dbSkip()
										Loop													
									EndIf
			                    EndIf                           
			      			Endif

							If cAlias == "CTI"	.Or. ( cAlias == "CTU" .And. cIdent == "CTH")
								If lCTHEXDTFIM .AND. type( 'TRBTMP->CTHDTEXSF' ) # 'U'
									If !Empty(TRBTMP->CTHDTEXSF) .And. (dDataIni > TRBTMP->CTHDTEXSF)  
										dbSelectArea("TRBTMP")
										dbSkip()
										Loop													
									Endif
								EndIf
							EndIf 										
						EndIf
					Else                            
						If (SALDOANTDB  == 0 .And. SALDOANTCR  == 0 .And. SALDODEB == 0 .And. SALDOCRD == 0) 
							If cAlias $ "CT7/CT3/CT4/CTI" .AND. type( 'TRBTMP->CT1DTEXSF' ) # 'U'
				 				If lCT1EXDTFIM .AND. !Empty(TRBTMP->CT1DTEXSF) .And. (dDataIni > TRBTMP->CT1DTEXSF)  
									dbSelectArea("TRBTMP")
									dbSkip()
									Loop													
								EndIf																								
							EndIf                                                               																
							
							If cAlias == "CT3" .Or. ( cAlias == "CTU" .And. cIdent == "CTT") .Or. ( cAlias == "CTI" .And. lImp4Ent)
								If lCTTEXDTFIM .AND. type( 'TRBTMP->CTTDTEXSF' ) # 'U'
									IF !Empty(TRBTMP->CTTDTEXSF) .And. (dDataIni > TRBTMP->CTTDTEXSF)  
										dbSelectArea("TRBTMP")
										dbSkip()
										Loop													
									Endif
								EndIf							
							EndIf														
						
							If cAlias == "CT4" .Or. ( cAlias == "CTU" .And. cIdent == "CTD")  .Or. ( cAlias == "CTI" .And. lImp4Ent)
					 			If lCTDEXDTFIM .AND. type( 'TRBTMP->CTDDTEXSF' ) # 'U'
					 				IF !Empty(TRBTMP->CTDDTEXSF) .And. (dDataIni > TRBTMP->CTDDTEXSF)  
										dbSelectArea("TRBTMP")
										dbSkip()
										Loop
									EndIf   
								Endif
		                    EndIf                           
		
							If cAlias == "CTI"	.Or. ( cAlias == "CTU" .And. cIdent == "CTH")
					 			If lCTHEXDTFIM .AND. type( 'TRBTMP->CTHDTEXSF' ) # 'U' 
					 				IF !Empty(TRBTMP->CTHDTEXSF) .And. (dDataIni > TRBTMP->CTHDTEXSF)  
										dbSelectArea("TRBTMP")
										dbSkip()
										Loop													
									EndIf
								Endif
							EndIf	                    								
						EndIf
					EndIf
				EndIf
			
				If cAlias == "CTU"              
					Do Case
					Case cIdent	== "CTT"
						cCodigo	:= TRBTMP->CUSTO
					Case cIdent	== "CTD"
						cCodigo	:= TRBTMP->ITEM
					Case cIdent	== "CTH"
						cCodigo	:= TRBTMP->CLVL					
					EndCase                   
				Else
					If lImpConta .Or. cAlias == "CT7"
						cCodigo	:= TRBTMP->CONTA
					Else
						If cAlias == "CT3"
							cCodigo	:= TRBTMP->CUSTO							
						ElseIf cAlias == "CT4"
							cCodigo	:= TRBTMP->ITEM							
						ElseIf cAlias == "CTI"
							cCodigo	:= TRBTMP->CLVL												
						EndIf
					EndIf
					If cAlias == "CT3" .And. cHeader == "CTT"
						cCodGer	:= TRBTMP->CUSTO						
					EndIf
				EndIf
			
				If !Empty(cSegmento)
					If Empty(cSegIni) .And. Empty(cSegFim) .And. !Empty(cFiltSegm)
						If  !(Substr(cCodigo,nPos,nDigitos) $ (cFiltSegm) ) 
							dbSkip()
							Loop
						EndIf	
					Else
						If Substr(cCodigo,nPos,nDigitos) < Alltrim(cSegIni) .Or. ;
							Substr(cCodigo,nPos,nDigitos) > Alltrim(cSegFim)
							dbSkip()
							Loop
						EndIf	
					Endif
				EndIf		

				//Caso faca filtragem por segmento gerencial,verifico se esta dentro 
				//da solicitacao feita pelo usuario. 
				If cAlias == "CT3" .And. cHeader == "CTT"
					If !Empty(cSegmentoG)
						If Empty(cSegIniG) .And. Empty(cSegFimG) .And. !Empty(cFiltSegmG)
							If  !(Substr(cCodGer,nPosG,nDigitosG) $ (cFiltSegmG) ) 
								dbSkip()
								Loop
							EndIf	
						Else
		 					If Substr(cCodGer,nPosG,nDigitosG) < Alltrim(cSegIniG) .Or. ;
								Substr(cCodGer,nPosG,nDigitosG) > Alltrim(cSegFimG)
								dbSkip()
								Loop
							EndIf	
						Endif
					EndIf						
				EndIf
									
				If &("TRBTMP->("+cFILUSU+")")				
					RecLock(cArqAux,.T.)   
					
					For nTRB := 1 to Len(aStruTMP)
						Field->&(aStruTMP[nTRB,1]) := TRBTMP->&(aStruTMP[nTRB,1])			
						If Subs(aStruTmp[nTRB][1],1,6) $ "SALDODEB/SALDOCRD/SALDOANTDB/SALDOANTCR/SLDLPANTCR/SLDLPANTDB/MOVLPDEB/MOVLPCRD" .And. nDivide > 0 
							Field->&(aStruTMP[nTRB,1])	:=((TRBTMP->&(aStruTMP[nTRB,1])))/ndivide                   
						EndIf										
					Next                    
					(cArqAux)->FILIAL	:= cFilAnt 
			
					If cAlias	== "CTU"            
						Do Case
						Case cIdent	== "CTT"
						    If Empty(TRBTMP->DESCCC)
								(cArqAux)->DESCCC		:= TRBTMP->DESCCC01
						    EndIf						    
						Case cIdent == "CTD"
							If Empty(TRBTMP->DESCITEM)
								(cArqAux)->DESCITEM	:= TRBTMP->DESCIT01							
							EndIf						
						Case cIdent == "CTH"
							If Empty(TRBTMP->DESCCLVL)							
								(cArqAux)->DESCCLVL	:= TRBTMP->DESCCV01							
							EndIf						
						EndCase					
					Else
						If lImpConta .or. cAlias == "CT7"
							If Empty(TRBTMP->DESCCTA) .AND. TRBTMP->(FieldPos( "DESCCTA01" )) > 0 .AND. !Empty(TRBTMP->DESCCTA01)
								(cArqAux)->DESCCTA	:= TRBTMP->DESCCTA01
							EndIf
						EndIf
			             
						If cAlias == "CT4"            
							If !lImp3Ent 
								If cMoeda <> '01' .And. Empty(TRBTMP->DESCITEM)
									(cArqAux)->DESCITEM	:= TRBTMP->DESCIT01
								EndIf    
							EndIf    
								
							If lImp3Ent	//Balancete CC / Conta / Item								             
								If Empty(TRBTMP->DESCCC)
									(cArqAux)->DESCCC	:= TRBTMP->DESCCC01
								EndIf        								
								
								If TRBTMP->ALIAS == 'CT4'
									If Empty(TRBTMP->DESCITEM)
										(cArqAux)->DESCITEM	:= TRBTMP->DESCIT01																			
								    EndIf
								EndIf
							EndIf
						EndIf
						
						If cAlias == "CTI" .And. lImp4Ent
							If !Empty(CLVL)
								If Empty(TRBTMP->DESCCLVL)							
									(cArqAux)->DESCCLVL	:= TRBTMP->DESCCV01							
								EndIf						
							EndiF
							
						    If !Empty(ITEM)
								If Empty(TRBTMP->DESCITEM)
									(cArqAux)->DESCITEM	:= TRBTMP->DESCIT01
								EndIf
							Endif
							                           
							If !Empty(CUSTO)
							    If Empty(TRBTMP->DESCCC)
									(cArqAux)->DESCCC		:= TRBTMP->DESCCC01													    
							    EndIf						    
							EndIf					
						EndIf
					EndIf
					
							//Se for Relatorio US Gaap
					If lUsGaap
					
						nSlAntGap	:= TRBTMP->(SALDOANTDB - SALDOANTCR)	// Saldo Anterior
						nSlAntGapD	:= TRBTMP->(SALDOANTDB)					// Saldo anterior debito
						nSlAntGapC	:= TRBTMP->(SALDOANTCR)					// Saldo anterior credito	
						nSlAtuGap	:= TRBTMP->((SALDOANTDB+SALDODEB)- (SALDOANTCR+SALDOCRD))	// Saldo Atual           
						nSlAtuGapD	:= TRBTMP->(SALDOANTDB+SALDODEB)					// Saldo Atual debito
						nSlAtuGapC	:= TRBTMP->(SALDOANTCR+SALDOCRD)					// Saldo Atual credito
						
			            nSlDebGap	:= TRBTMP->((SALDOANTDB+SALDODEB) - SALDOANTDB)		// Saldo Debito
			            nSlCrdGap	:= TRBTMP->((SALDOANTCR+SALDOCRD) - SALDOANTCR)		// Saldo Credito
					
						If cConsCrit == "5"	//Se for Criterio do Plano de Contas
							cCritPlCta	:= Ctr045Med(cMoedConv)
						EndIf
			
						If cConsCrit $ "123" .Or. (cConsCrit == "5" .And. cCritPlCta $ "123")
							If cConsCrit == "5"					
								(cArqAux)->SALDOANT	:= CtbConv(cCritPlCta,dDataConv,cMoedConv,nSlAntGap)					
								(cArqAux)->SALDOANTDB	:= CtbConv(cCritPlCta,dDataConv,cMoedConv,nSlAntGapD)										
								(cArqAux)->SALDOANTCR	:= CtbConv(cCritPlCta,dDataConv,cMoedConv,nSlAntGapC)					
								(cArqAux)->SALDOATU	:= CtbConv(cCritPlCta,dDataConv,cMoedConv,nSlAtuGap)					
								(cArqAux)->SALDOATUDB	:= CtbConv(cCritPlCta,dDataConv,cMoedConv,nSlAtuGapD)					
								(cArqAux)->SALDOATUCR	:= CtbConv(cCritPlCta,dDataConv,cMoedConv,nSlAntGapC)									
								(cArqAux)->SALDODEB	:= CtbConv(cCritPlCta,dDataConv,cMoedConv,nSlDebGap)									
								(cArqAux)->SALDOCRD	:= CtbConv(cCritPlCta,dDataConv,cMoedConv,nSlCrdGap)														
							Else
								(cArqAux)->SALDOANT	:= CtbConv(cConsCrit,dDataConv,cMoedConv,nSlAntGap)					
								(cArqAux)->SALDOANTDB	:= CtbConv(cConsCrit,dDataConv,cMoedConv,nSlAntGapD)										
								(cArqAux)->SALDOANTCR	:= CtbConv(cConsCrit,dDataConv,cMoedConv,nSlAntGapC)					
								(cArqAux)->SALDOATU	:= CtbConv(cConsCrit,dDataConv,cMoedConv,nSlAtuGap)					
								(cArqAux)->SALDOATUDB	:= CtbConv(cConsCrit,dDataConv,cMoedConv,nSlAtuGapD)					
								(cArqAux)->SALDOATUCR	:= CtbConv(cConsCrit,dDataConv,cMoedConv,nSlAntGapC)									
								(cArqAux)->SALDODEB	:= CtbConv(cConsCrit,dDataConv,cMoedConv,nSlDebGap)									
								(cArqAux)->SALDOCRD	:= CtbConv(cConsCrit,dDataConv,cMoedConv,nSlCrdGap)													
							EndIf        
						ElseIf cConsCrit == "4" .Or. (cConsCrit == "5" .And. cCritPlCta == "4")	
							(cArqAux)->SALDOANT	:= nSlAntGap/nTaxaConv
							(cArqAux)->SALDOANTDB	:= nSlAntGapD/nTaxaConv 
							(cArqAux)->SALDOANTCR	:= nSlAntGapC/nTaxaConv 
							(cArqAux)->SALDOATU	:= nSlAtuGap/nTaxaConv 
							(cArqAux)->SALDOATUDB	:= nSlAtuGapD/nTaxaConv 
							(cArqAux)->SALDOATUCR	:= nSlAtuGapC/nTaxaConv  
							(cArqAux)->SALDODEB	:= nSlDebGap/nTaxaConv
							(cArqAux)->SALDOCRD	:= nSlCrdGap/nTaxaConv			
						EndIf			
					EndIf		        		
				
					If Empty( dDtCorte )
						If nCampoLP > 0 
							(cArqAux)->SALDOANTDB	:= SALDOANTDB - SLDLPANTDB
							(cArqAux)->SALDOANTCR	:= SALDOANTCR - SLDLPANTCR
							(cArqAux)->SALDODEB	:= SALDODEB - MOVLPDEB
							(cArqAux)->SALDOCRD	:= SALDOCRD - MOVLPCRD
						EndIf					
				 		
				 		(cArqAux)->SALDOANT	:= SALDOANTCR - SALDOANTDB
						(cArqAux)->SALDOATUDB	:= SALDOANTDB + SALDODEB
						(cArqAux)->SALDOATUCR	:= SALDOANTCR + SALDOCRD 				 	
						(cArqAux)->SALDOATU	:= SALDOATUCR - SALDOATUDB			
						(cArqAux)->MOVIMENTO	:= SALDOCRD   - SALDODEB			
					Else 
						nSaldoCrt := 0

						If lImpAntLP .And. nCampoLP > 0  
							IF Type( "(cArqAux)->SLLPATCTDB" ) # "U" .AND.Type( "(cArqAux)->SLLPATCTCR" ) # "U" 
								nSaldoCrt := ((cArqAux)->SLLPATCTDB - (cArqAux)->SLLPATCTCR)
							Endif

							(cArqAux)->SALDOANTDB	:= (SALDOANTDB - SLDLPANTDB ) + iif( nSaldoCrt > 0 , Abs( nSaldoCrt ) , 0 ) 
							(cArqAux)->SALDOANTCR	:= (SALDOANTCR - SLDLPANTCR ) + iif( nSaldoCrt < 0 , Abs( nSaldoCrt ) , 0 ) 
							(cArqAux)->SALDODEB	:= SALDODEB - MOVLPDEB
							(cArqAux)->SALDOCRD	:= SALDOCRD - MOVLPCRD
						Else
							IF Type( "(cArqAux)->SLDANTCTDB" ) # "U" .AND.Type( "(cArqAux)->SLDANTCTCR" ) # "U" 
								nSaldoCrt := ((cArqAux)->SLDANTCTDB - (cArqAux)->SLDANTCTCR)
							Endif

							(cArqAux)->SALDOANTDB	:= SALDOANTDB + iif( nSaldoCrt > 0 , Abs( nSaldoCrt ) , 0 ) 
							(cArqAux)->SALDOANTCR	:= SALDOANTCR + iif( nSaldoCrt < 0 , Abs( nSaldoCrt ) , 0 ) 
						EndIf					
				 		
				 		(cArqAux)->SALDOANT	:= SALDOANTCR - SALDOANTDB
						(cArqAux)->SALDOATUDB	:= SALDOANTDB + SALDODEB
						(cArqAux)->SALDOATUCR	:= SALDOANTCR + SALDOCRD 				 	
						(cArqAux)->SALDOATU	:= SALDOATUCR - SALDOATUDB			
						(cArqAux)->MOVIMENTO	:= SALDOCRD   - SALDODEB			    
					
					Endif
					
					
				    //Se imprime saldo anterior do periodo anterior zerado, verificar o saldo atual da data de zeramento.                
					If ( lImpConta .Or. cAlias == "CT7") .And. lRecDesp0 .And. Subs(TRBTMP->CONTA,1,1) $ cRecDesp		
					
						If cAlias == "CT7" .Or. ( cAlias == "CT3" .And. cHeader == "CT1" )
							aSldRecDes	:= SaldoCT7Fil(TRBTMP->CONTA,dDtZeraRD,cMoeda,cSaldos,'CTBXFUN',.F.,nil,aSelFil,nil,lTodasFil)		
						ElseIf cAlias == "CT3" .And. cHeader == "CTT"
							aSldRecDes	:= SaldoCT3Fil(TRBTMP->CONTA,TRBTMP->CUSTO,dDtZeraRD,cMoeda,cSaldos,'CTBXFUN',.F.,Nil,aSelFil,lTodasFil)									
						ElseIf cAlias == "CT4" .And. cHeader == "CTD"
							cCusIni		:= ""
							cCusFim		:= Repl("Z",aTamCC[1])
							aSldRecDes	:= SaldTotCT4(TRBTMP->ITEM,TRBTMP->ITEM,cCusIni,cCusFim,TRBTMP->CONTA,TRBTMP->CONTA,dDtZeraRD,cMoeda,cSaldos,aSelFil,,,,,,,,lTodasFil)
						Elseif cAlias == "CTI" .And. cHeader == "CTH"
							cCusIni		:= ""
							cCusFim		:= Repl("Z",aTamCC[1])
							
							cItIni  	:= ""
							cItFim   	:= Repl("z",aTamItem[1])
					
							aSldRecDes := SaldTotCTI(TRBTMP->CLVL,TRBTMP->CLVL,cItIni,cItFim,cCusIni,cCusFim,;
							TRBTMP->CONTA,TRBTMP->CONTA,dDtZeraRD,cMoeda,cSaldos,aSelFil,,,,,,,,lTodasFil)
						EndIf                        

						If nDivide > 1
							For nCont := 1 To Len(aSldRecDes)
								aSldRecDes[nCont] := Round(NoRound((aSldRecDes[nCont]/nDivide),3),2)
							Next nCont		
						EndIf								

						nSldRDAtuD	:=	aSldRecDes[4] 
						nSldRDAtuC	:=	aSldRecDes[5]
						nSldAtuRD	:= nSldRDAtuC - nSldRDAtuD			
                                                
						(cArqAux)->SALDOANT		-= nSldAtuRD
						(cArqAux)->SALDOANTDB	-= nSldRDAtuD
						(cArqAux)->SALDOANTCR	-= nSldRDAtuC 	
						(cArqAux)->SALDOATU		-= nSldAtuRD
						(cArqAux)->SALDOATUDB	-= nSldRDAtuD
						(cArqAux)->SALDOATUCR	-= nSldRdAtuC			
					EndIf                        

					IF (cArqAux)->( FieldPos( "NATCTA" ) ) > 0
						(cArqAux)->NATCTA := NATCTA   // Faz retorno do campo CT1_NATCTA
					Endif

					(cArqAux)->(MsUnlock())
				EndIf					
				TRBTMP->(dbSkip())     
				If ValType(oMeter) == "O"					
					nMeter++
			    	oMeter:Set(nMeter)				
			  	EndIf
			Enddo

			dbSelectArea("TRBTMP")
			dbCloseArea()					/// FECHA O TRBTMP (RETORNADO DA QUERY)
			lTemQry := .T.
		Endif
	EndIf
#ENDIF


dbSelectArea(cArqAux)
dbSetOrder(1)

If cAlias $ 'CT3/CT4/CTI' //Se imprime CONTA+ ENTIDADE
	If !Empty(aSetOfBook[5])
		If !lImpConta	//Se for balancete de 1 entidade filtrada por conta
			If cAlias == "CT3"
				cIdent	:= "CTT"
			ElseIf cAlias == "CT4"
				cIdent	:= "CTD"			
			ElseIf cAlias == "CTI"
				cIdent 	:= "CTH"
			EndIf
			// Monta Arquivo Lendo Plano Gerencial                                   
			// Neste caso a filtragem de entidades contabeis é desprezada!
			CtbPlGeren(	oMeter,oText,oDlg,lEnd,dDataIni,dDataFim,cMoeda,aSetOfBook,"CTU",;
						cIdent,lImpAntLP,dDataLP,lVlrZerado,cEntidIni,cEntidFim,aGeren,lImpSint,lRecDesp0,cRecDesp,dDtZeraRD,,cSaldos,lPlGerSint,lConsSaldo,,lUsaNmVis,@cNomeVis)
			dbSetOrder(2)
		Else	
			If lImpEntGer	//Se for balancete de Entidade (C.Custo/Item/Cl.Vlr por Entid. Gerencial)
			 	CtPlEntGer(	oMeter,oText,oDlg,lEnd,dDataIni,dDataFim,cMoeda,aSetOfBook,cAlias,cHeader,;
						lImpAntLP,dDataLP,lVlrZerado,cEntidIni,cEntidFim,cContaIni,cContaFim,;         
						cCCIni,cCCFim,cItemIni,cItemFim,cClVlIni,cClVlFim,lImpSint,;
						lRecDesp0,cRecDesp,dDtZeraRD,nDivide,lFiltraCC,lFiltraIt,lFiltraCV, cSaldos )
			Else		
				MsgAlert(cMensagem)	
				Return
			EndIf
		EndIf
	Else
		If cHeader == "CT1"	//Se for Balancete Conta/Entidade
			#IFNDEF TOP	//Se for top connect, atualiza sinteticas
				// Monta Arquivo Lendo Plano Padrao - especifico para conta/ENTIDADE
				CtEntConta(oMeter,oText,oDlg,lEnd,dDataIni,dDataFim,cContaIni,;
							cContaFim,cEntidIni,cEntidFim,cMoeda,cSaldos,aSetOfBook,;
							cAlias,lCusto,lItem,lClvl,lAtSldBase,nInicio,nFinal,lImpAntLP,dDataLP,;
							nDivide,lVlrZerado,lNImpMov)	                       
			#ELSE
				If TcSrvType() == "AS/400"                     					
					// Monta Arquivo Lendo Plano Padrao - especifico para conta/ENTIDADE
					CtEntConta(oMeter,oText,oDlg,lEnd,dDataIni,dDataFim,cContaIni,;
							cContaFim,cEntidIni,cEntidFim,cMoeda,cSaldos,aSetOfBook,;
							cAlias,lCusto,lItem,lClvl,lAtSldBase,nInicio,nFinal,lImpAntLP,dDataLP,;
							nDivide,lVlrZerado,lNImpMov)	                       
				
				EndIf
			#ENDIF
			//Atualizacao de sinteticas para codebase e topconnect			
			If lImpSint	//Se atualiza sinteticas
		 		CtCtEntSup(oMeter,oText,oDlg,cAlias,lNImpMov,cMoeda)							
		    EndIf			
		Else
			If !lImp3Ent	.And. !lImp4Ent //Se não for Balancete CC / Conta / Item
				If lImpConta
					#IFNDEF TOP			    
						// Monta Arquivo Lendo Plano Padrao - especifico para conta/ENTIDADE				
						CtContaEnt(oMeter,oText,oDlg,lEnd,dDataIni,dDataFim,cContaIni,;
									cContaFim,cEntidIni,cEntidFim,cMoeda,cSaldos,aSetOfBook,nTamCta,;
									cSegmento,cSegIni,cSegFim,cFiltSegm,lNImpMov,cAlias,lCusto,;
									lItem,lClvl,lAtSldBase,nInicio,nFinal,cFilDe,cFilAte,lImpAntLP,dDataLP,;
									nDivide,lVlrZerado,cSegmentoG,cSegIniG,cSegFimG,cFiltSegmG,cFilUSU,;
									lRecDesp0,cRecDesp,dDtZeraRD)     
					#ELSE														
						If TcSrvType() == "AS/400"
							CtContaEnt(oMeter,oText,oDlg,lEnd,dDataIni,dDataFim,cContaIni,;
									cContaFim,cEntidIni,cEntidFim,cMoeda,cSaldos,aSetOfBook,nTamCta,;
									cSegmento,cSegIni,cSegFim,cFiltSegm,lNImpMov,cAlias,lCusto,;
									lItem,lClvl,lAtSldBase,nInicio,nFinal,cFilDe,cFilAte,lImpAntLP,dDataLP,;
									nDivide,lVlrZerado,cSegmentoG,cSegIniG,cSegFimG,cFiltSegmG,cFilUSU,;
									lRecDesp0,cRecDesp,dDtZeraRD)     					
						EndIf
					#ENDIF					
					
					If lImpSint	//Se atualiza sinteticas
				 		CtEntCtSup(oMeter,oText,oDlg,cAlias,lNImpMov,cMoeda,,cEntidIni,cEntidFim,lCttSint)
				 	EndIf
					
				Else
					#IFNDEF TOP				
						CtbSo1Ent(oMeter,oText,oDlg,lEnd,dDataIni,dDataFim,cContaIni,;
								cContaFim,cCCIni,cCCFim,cItemIni,cItemFim,cEntidIni,;
								cEntidFim,cMoeda,cSaldos,aSetOfBook,nTamCta,;
								cSegmento,cSegIni,cSegFim,cFiltSegm,lNImpMov,cAlias,lCusto,;
								lItem,lClvl,lAtSldBase,nInicio,nFinal,cFilDe,cFilAte,lImpAntLP,dDataLP,;
								nDivide,lVlrZerado,cSegmentoG,cSegIniG,cSegFimG,cFiltSegmG,cFilUSU,;
								lRecDesp0,cRecDesp,dDtZeraRD)          							     										
					#ELSE
						If TcSrvType() == "AS/400"                     														
							CtbSo1Ent(oMeter,oText,oDlg,lEnd,dDataIni,dDataFim,cContaIni,;
									cContaFim,cCCIni,cCCFim,cItemIni,cItemFim,cEntidIni,;
									cEntidFim,cMoeda,cSaldos,aSetOfBook,nTamCta,;
									cSegmento,cSegIni,cSegFim,cFiltSegm,lNImpMov,cAlias,lCusto,;
									lItem,lClvl,lAtSldBase,nInicio,nFinal,cFilDe,cFilAte,lImpAntLP,dDataLP,;
									nDivide,lVlrZerado,cSegmentoG,cSegIniG,cSegFimG,cFiltSegmG,cFilUSU,;
									lRecDesp0,cRecDesp,dDtZeraRD)          							     																
						EndIf					
					#ENDIF		 
					
					If lImpSint                                               
						If cAlias == "CT3"
							cIdent := "CTT"
						ElseIf cAlias == "CT4"
							cIdent := "CTD"						
						ElseIf cAlias == "CTI"
							cIdent := "CTH"						
						EndIf					
						CtbCTUSup(oMeter,oText,oDlg,lNImpMov,cMoeda,cIdent)				
					EndIf						
							
				EndIf
			Else	//Se for Balancete CC / Conta / Item				
				If lImp3Ent
					#IFNDEF TOP
						CtbCta2Ent(oMeter,oText,oDlg,lEnd,dDataIni,dDataFim,cContaIni,;
									cContaFim,cCCIni,cCCFim,cItemIni,cItemFim,cClvlIni,cClVlFim,cMoeda,;
									cSaldos,aSetOfBook,nTamCta,cSegmento,cSegIni,cSegFim,cFiltSegm,lNImpMov,cAlias,cHeader,;
									lCusto,lItem,lClvl,lAtSldBase,nInicio,nFinal,cFilDe,cFilAte,lImpAntLP,dDataLP,;
									nDivide,lVlrZerado)				
					#ELSE
						If TcSrvType() == "AS/400"                     									
							CtbCta2Ent(oMeter,oText,oDlg,lEnd,dDataIni,dDataFim,cContaIni,;
										cContaFim,cCCIni,cCCFim,cItemIni,cItemFim,cClvlIni,cClVlFim,cMoeda,;
										cSaldos,aSetOfBook,nTamCta,cSegmento,cSegIni,cSegFim,cFiltSegm,lNImpMov,cAlias,cHeader,;
										lCusto,lItem,lClvl,lAtSldBase,nInicio,nFinal,cFilDe,cFilAte,lImpAntLP,dDataLP,;
										nDivide,lVlrZerado)
					    EndIf
					#ENDIF
					If lImpSint
				 		Ctb3CtaSup(oMeter,oText,oDlg,cAlias,lNImpMov,cMoeda,cHeader)							
				    Endif			
				 ElseIf cAlias == "CTI" .And. lImp4Ent .And. cHeader == "CTT"
					#IFNDEF TOP
						CtbCta3Ent(oMeter,oText,oDlg,lEnd,dDataIni,dDataFim,cContaIni,;
									cContaFim,cCCIni,cCCFim,cItemIni,cItemFim,cClvlIni,cClVlFim,cMoeda,;
									cSaldos,aSetOfBook,nTamCta,cSegmento,cSegIni,cSegFim,cFiltSegm,lNImpMov,cAlias,cHeader,;
									lCusto,lItem,lClvl,lAtSldBase,nInicio,nFinal,cFilDe,cFilAte,lImpAntLP,dDataLP,;
									nDivide,lVlrZerado)				
					#ELSE
						If TcSrvType() == "AS/400" .or. lImpAntLP
							CtbCta3Ent(oMeter,oText,oDlg,lEnd,dDataIni,dDataFim,cContaIni,;
										cContaFim,cCCIni,cCCFim,cItemIni,cItemFim,cClvlIni,cClVlFim,cMoeda,;
										cSaldos,aSetOfBook,nTamCta,cSegmento,cSegIni,cSegFim,cFiltSegm,lNImpMov,cAlias,cHeader,;
										lCusto,lItem,lClvl,lAtSldBase,nInicio,nFinal,cFilDe,cFilAte,lImpAntLP,dDataLP,;
										nDivide,lVlrZerado)
					    EndIf
					#ENDIF	
					If lImpSint
				 		Ctb4CtaSup(oMeter,oText,oDlg,cAlias,lNImpMov,cMoeda,cHeader)							
				    Endif						
				 EndIf				 
			EndIf
		EndIf
	EndIf
Else	
	If cAlias $ 'CTU/CT7' .Or. (!Empty(aSetOfBook[5]) .And. Empty(cAlias))		//So Imprime Entidade ou demonstrativos
		If !Empty(aSetOfBook[5])				// Indica qual o Plano Gerencial Anexado
			// Monta Arquivo Lendo Plano Gerencial                                   
			// Neste caso a filtragem de entidades contabeis é desprezada!
			U_CtbPlGeren(	oMeter,oText,oDlg,lEnd,dDataIni,dDataFim,cMoeda,aSetOfBook,cAlias,;
						cIdent,lImpAntLP,dDataLP,lVlrZerado,cEntidIni,cEntidFim,aGeren,lImpSint,lRecDesp0,cRecDesp,dDtZeraRD,;
						lMovPeriodo,cSaldos,lPlGerSint,lConsSaldo, cArqAux, lUsaNmVis,@cNomeVis,aSelfil,cQuadroCTB)
			dbSetOrder(2)
		Else
			//Se nao for for Top Connect
			#IFNDEF TOP 			
				CtSoEntid(oMeter,oText,oDlg,lEnd,dDataIni,dDataFim,cEntidIni,cEntidFim,cMoeda,;
					cSaldos,aSetOfBook,cSegmento,cSegIni,cSegFim,cFiltSegm,lNImpMov,cAlias,cIdent,;
					lCusto,lItem,lClVl,lAtSldBase,lAtSldCmp,nInicio,nFinal,cFilDe,cFilAte,lImpAntLP,;
					dDataLP,nDivide,lVlrZerado,lUsGaap,cMoedConv,cConsCrit,dDataConv,nTaxaConv,lRecDesp0,;
					cRecDesp,dDtZeraRD,cMoedaDsc,aSelFil,lTodasFil)					
			#ELSE
				If TcSrvType() == "AS/400"                     								
					CtSoEntid(oMeter,oText,oDlg,lEnd,dDataIni,dDataFim,cEntidIni,cEntidFim,cMoeda,;
						cSaldos,aSetOfBook,cSegmento,cSegIni,cSegFim,cFiltSegm,lNImpMov,cAlias,cIdent,;
						lCusto,lItem,lClVl,lAtSldBase,lAtSldCmp,nInicio,nFinal,cFilDe,cFilAte,lImpAntLP,;
						dDataLP,nDivide,lVlrZerado,lUsGaap,cMoedConv,cConsCrit,dDataConv,nTaxaConv,lRecDesp0,;
						cRecDesp,dDtZeraRD,cMoedaDsc,aSelFil,lTodasFil)
				EndIf				
			#ENDIF			  
			     
			If lImpSint	//Se atualiza sinteticas			
				Do Case
				Case cAlias =="CT7"
					//Atualizacao de sinteticas para codebase e topconnect			        	
			 		CtContaSup(oMeter,oText,oDlg,lNImpMov,cMoeda,cMoedaDsc)									 									
				Case cAlias == "CTU"			    		
					CtbCTUSup(oMeter,oText,oDlg,lNImpMov,cMoeda,cIdent)
				EndCase
			EndIf
		EndIf
	Else    	//Imprime Relatorios com 2 Entidades 
		If !Empty(aSetOfBook[5])
			MsgAlert(cMensagem)			
			Return
		Else
			If cAlias == 'CTY'		//Se for Relatorio de 2 Entidades filtrado pela 3a Entidade
				Ct2EntFil(oMeter,oText,oDlg,lEnd,dDataIni,dDataFim,cEntidIni1,cEntidFim1,cEntidIni2,;
					cEntidFim2,cHeader,cMoeda,cSaldos,aSetOfBook,cSegmento,cSegIni,cSegFim,cFiltSegm,;
					lNImpMov,cAlias,lCusto,lItem,lClVl,lAtSldBase,lAtSldCmp,nInicio,nFinal,;
					cFilDe,cFilAte,lImpAntLP,dDataLP,nDivide,lVlrZerado,cFiltroEnt,cCodFilEnt,aSelFil,lTodasFil)			
        	ElseIf  cAlias <> 'CVY'
				CtEntComp(oMeter,oText,oDlg,lEnd,dDataIni,dDataFim,cEntidIni1,cEntidFim1,cEntidIni2,;
					cEntidFim2,cHeader,cMoeda,cSaldos,aSetOfBook,cSegmento,cSegIni,cSegFim,cFiltSegm,;
					lNImpMov,cAlias,lCusto,lItem,lClVl,lAtSldBase,lAtSldCmp,nInicio,nFinal,;
					cFilDe,cFilAte,lImpAntLP,dDataLP,nDivide,lVlrZerado,cFiltroEnt,cCodFilEnt,cFilUsu,aSelFil,lTodasFil,aTmpFil)
			EndIf
		EndIf
	Endif
EndIf


dbSelectArea(cArqAux)

If FieldPos("ORDEMPRN") > 0
	If lCriaInd
		dbSelectArea(cArqAux)
		IndRegua(cArqAux,Left(cArqInd, 7) + "A","ORDEMPRN",,,"Selecionando Registros...")  //"Selecionando Registros..."
		If cAlias == "CT7" .OR. cAlias == "CT3"
			IndRegua(cArqAux,Left(cArqInd, 7) + "B","SUPERIOR+CONTA",,,"Selecionando Registros...")  //"Selecionando Registros..."
		ElseIf cAlias == "CTU"
			If cIdent == "CTT"
				IndRegua(cArqAux,Left(cArqInd, 7) + "B","CCSUP+CUSTO",,,"Selecionando Registros...")  //"Selecionando Registros..."					
			ElseIf cIdent == "CTD"
				IndRegua(cArqAux,Left(cArqInd, 7) + "B","ITSUP+ITEM",,,"Selecionando Registros...")  //"Selecionando Registros..."					
			ElseIf cIdent == "CTH"
				IndRegua(cArqAux,Left(cArqInd, 7) + "B","CLSUP+CLVL",,,"Selecionando Registros...")  //"Selecionando Registros..."					
			EndIf				
		EndIf
		DbClearIndex()
		dbSetIndex(cArqInd+OrdBagExt())
		dbSetIndex(Left(cArqInd,7)+"A"+OrdBagExt())
		dbSetIndex(Left(cArqInd,7)+"B"+OrdBagExt())
	Endif	
	
	DbSetOrder(1)
	DbGoTop()
	While ! Eof()
		If cAlias == "CT7" .OR. cAlias == "CT3"
			If Empty(SUPERIOR)					
				CtGerSup(CONTA, @nOrdem, cAlias)
			EndIf
		ElseIf cAlias == "CTU"						
			If cIdent == "CTT"
				If Empty(CCSUP)								
					CtGerSup(CUSTO, @nOrdem,"CTU","CTT")						
				EndIf
			ElseIf cIdent == "CTD"
				If Empty(ITSUP)
					CtGerSup(ITEM, @nOrdem,"CTU","CTD")						
				EndIf
			ElseIf cIdent == "CTH"
				If Empty(CLSUP)
					CtGerSup(CLVL, @nOrdem,"CTU","CTH")						
				Endif
			EndIf						
		EndIf
		DbSkip()
	Enddo
	DbSetOrder(2)
Endif

#IFDEF TOP                           
  	CTDelTmpFil()
  	For nX := 1 TO Len(aTmpFil)
		CtbTmpErase(aTmpFil[nX])
    Next
#ENDIF

RestArea(aSaveArea)

Return cArqTmp

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³CtbPlGeren ³ Autor ³ Pilar S Albaladejo    ³ Data ³ 15.12.99 		     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Retorna Array com o set of book                             			 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³CTBPlGeren(oMeter,oText,oDlg,lEnd,dDataIni,dDataFim,cMoeda,aSetOfBook) ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                  			 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpO1 = Objeto oMeter                     	                 		 ³±±
±±³          ³ ExpO2 = Objeto oText                      	                 		 ³±±
±±³          ³ ExpO3 = Objeto oDlg                       	                 		 ³±±
±±³          ³ ExpL1 = Acao do CodeBlock                 	                 		 ³±±
±±³          ³ ExpD1 = Data Inicial                      	                 		 ³±±
±±³          ³ ExpD2 = Data Final                        	                 		 ³±±
±±³          ³ ExpC1 = Moeda                              	                 		 ³±±
±±³          ³ ExpA1 = Array Set Of Book                  	                 		 ³±±
±±³          ³ lPlGerSint  = Imprime visao gerencial sintetica? Padrao .F.           ³±±
±±³          ³ lConsSaldo  = Consolida saldo ? Padrao .F.                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Analista  ³ Data/Bops/Ver ³Manutencao Efetuada                         			 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Marcelo K ³26/06/06³8.11  ³-Bops 101068: Alteracao do nome da funcao de           ³±±
±±³          ³        ³      ³ASCII para MsAscII.                         			 ³±±
±±³          ³        ³      ³solicitado pela Tecnologia para             			 ³±±
±±³          ³        ³      ³compatibilizar o Kernel do Protheus   			 	 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß

Function CtbPlGeren( oMeter,;     // 01
                     oText,;      // 02
                     oDlg,;       // 03
                     lEnd,;       // 04
                     dDataIni,;   // 05
                     dDataFim,;   // 06
                     cMoeda,;     // 07
                     aSetOfBook,; // 08 { 1-Codigo Set, 2-Mascara Conta, 3-Decimais, 4-Picture Valores, 5-Plano Gerencial, 6-Mascara C Custo, 7-Mascara Item, 8-Mascara CLVL} // aSetOfBook := {	CTN->CTN_CODIGO,CTN->CTN_MASC1,CTN->CTN_DECIM,CTN->CTN_PICTV,CTN->CTN_PLAGER,CTN->CTN_MASC2,CTN->CTN_MASC3,CTN->CTN_MASC4,1,AllTrim(CTN_DESC)}
                     cAlias,;     // 09
                     cIdent,;     // 10
                     lImpAntLP,;  // 11
                     dDataLP,;    // 12
                     lVlrZerado,; // 13
                     cEntFil1,;   // 14
                     cEntFil2,;   // 15
                     aGeren,;     // 16
                     lImpSint,;   // 17
                     lRecDesp0,;  // 18
                     cRecDesp,;   // 19
                     dDtZeraRD,;  // 20
                     lMovPeriodo,;// 21
                     cSaldos,;    // 22
                     lPlGerSint,; // 23
                     lConsSaldo,; // 24
                     cCTAlias,;   // 25
                     lUsaNmVis,;  // 26
                     cNomeVis,;   // 27
                     aSelfil,;    // 28
                     cQuadroCTB ; // 29
                    )

*/
User Function CtbPlGeren(oMeter,oText,oDlg,lEnd,dDataIni,dDataFim,cMoeda,aSetOfBook,;
					cAlias,cIdent,lImpAntLP,dDataLP,lVlrZerado,cEntFil1,cEntFil2,aGeren,lImpSint,;
					lRecDesp0,cRecDesp,dDtZeraRD,lMovPeriodo,cSaldos,lPlGerSint,lConsSaldo,cCTAlias,lUsaNmVis,cNomeVis,aSelfil,cQuadroCTB)


Local aSaveArea := GetArea()
Local aSaldoAnt	
Local aSaldoAtu
Local aSaldoSEM
Local aSaldoPER

Local cConta
Local cCodNor
Local cNormal
Local cContaSup
Local cDesc
Local cPlanGer := aSetOfBook[5]
Local cZZZCT1	:= Repl("Z",Len(Criavar("CT1_CONTA")))
Local cZZZCTT	:= Repl("Z",Len(Criavar("CTT_CUSTO")))
Local cZZZCTD	:= Repl("Z",Len(Criavar("CTD_ITEM")))
Local cZZZCTH	:= Repl("Z",Len(Criavar("CTH_CLVL")))   
Local cContaIni	:= Space(Len(Criavar("CT1_CONTA")))
Local cContaFim	:= cZZZCT1
Local cCustoIni	:= Space(Len(Criavar("CTT_CUSTO")))
Local cCustoFim	:= cZZZCTT
Local cItemIni	:= Space(Len(Criavar("CTD_ITEM")))
Local cItemFim	:= cZZZCTD
Local cClvlIni	:= Space(Len(Criavar("CTH_CLVL")))
Local cClVlFim	:= cZZZCTH
Local _lCtbIsCube	:= FindFunction( "CtbIsCube" ) .And. CtbIsCube()

Local cCtaFil1
Local cCtaFil2
Local cCCFil1
Local cCCFil2
Local cItemFil1
Local cItemFil2
Local cCLVLFil1
Local cCLVLFil2
Local lConta 	:= .F.
Local lCusto	:= .F.
Local lItem		:= .F.
Local lClasse	:= .F.

Local nReg
Local nFator	 := 1
Local nPos		:= 0	
Local nSaldoAnt := 0
Local nSaldoDeb := 0
Local nSaldoCrd := 0

Local nSaldoAtu := 0		// Saldo ate a data final
Local nSaldoSEM := 0		// Saldo ate a variavel dSemestre
Local nSaldoPER := 0		// Saldo ate a variavel dPeriodo0
Local nMOVIMPER	:= 0
Local nMovPerAnt	:= 0	//	Movimento do periodo anterior

Local nSaldoAntD:= 0
Local nSaldoAntC:= 0
Local nSaldoAtuD:= 0
Local nSaldoAtuC:= 0
Local lSemestre := FieldPos("SALDOSEM") > 0		// Saldo por semestre
Local lPeriodo0 := FieldPos("SALDOPER") > 0		// Saldo dois periodos anteriores

Local lComNivel := FieldPos("NIVEL") > 0		// Nivel hierarquico
Local lColuna	:= FieldPos("COLUNA") > 0
Local nNivel	:= 0
Local nContador	:= 0
Local cFilCTS	:= xFilial("CTS")
Local lMovCusto := CtbMovSaldo("CTT")
Local lMovItem	:= CtbMovSaldo("CTD")
Local lMovClass := CtbMovSaldo("CTH")
Local nA:=1 
Local aFator:={}
Local nFatorS:=1       
Local aAreaCTS:={}
Local cTpSaldo		:= ""
Local cMoedaDesc 	:= ""
Local cCodVis		:= ""
Local cEntidade		:= ""
Local nAt			:= 0
Local nAt2			:= 0
Local aSaldoAux		:= {}
Local xFator
Local aParamCVQ:= {}
Local cArqQuadro
Local aArqQuadro:= {}
Local xCVQ		:= ""
Local lT			:= .T.
Local aRegCT0

Local cZZZEnt05		
Local cEntid05Ini	
Local cEntid05Fim	
Local lMovEnt05	:= .F. 	
Local cEnt05Fil1					
Local cEnt05Fil2			

Local cZZZEnt06		
Local cEntid06Ini	
Local cEntid06Fim	
Local lMovEnt06 := .F.	
Local cEnt06Fil1					
Local cEnt06Fil2					        

Local cZZZEnt07		
Local cEntid07Ini	
Local cEntid07Fim	
Local lMovEnt07 := .F.
Local cEnt07Fil1					
Local cEnt07Fil2					

Local cZZZEnt08		
Local cEntid08Ini	
Local cEntid08Fim	
Local lMovEnt08 := .F.	
Local cEnt08Fil1					
Local cEnt08Fil2					
	                 
Local cZZZEnt09		
Local cEntid09Ini	
Local cEntid09Fim	
Local lMovEnt09 := .F. 	
Local cEnt09Fil1					
Local cEnt09Fil2  

Local lEnt05	:= .F.
Local lEnt06	:= .F.
Local lEnt07	:= .F.
Local lEnt08	:= .F.								
Local lEnt09	:= .F.

Local cCodigoEnt := "" 

Local aEntidIni	:= {} 
Local aEntidFim	:= {}

DEFAULT lConsSaldo:= .F.
DEFAULT lPlGerSint:= .F.
DEFAULT lImpSint	:= .T.
DEFAULT lRecDesp0	:= .F.
DEFAULT cRecDesp 	:= ""                
DEFAULT dDtZeraRD	:= CTOD("  /  /  ")
DEFAULT lMovPeriodo := .F.
DEFAULT cCTAlias	:= "cArqTmp"
DEFAULT lUsaNmVis	:= .F.
DEFAULT cSaldos		:= " "
DEFAULT aSelfil		:= {}
DEFAULT cQuadroCTB:= ""

//Disponibilizacao dos parametros da CtbPlGeren() como PARAMIXB para uso nas funções
//chamadas pelas sintaxes SALDO= e ROTINA=
//IMPORTANTE: Não incluir chamadas de ponto de entrada na CtbPlGeren(), pois a PARAMIXB será sobreposta
Private PARAMIXB := {}
Private PARAMIXC := {}
AADD(PARAMIXB,oMeter)
AADD(PARAMIXB,oText)
AADD(PARAMIXB,oDlg)
AADD(PARAMIXB,lEnd)
AADD(PARAMIXB,dDataIni)
AADD(PARAMIXB,dDataFim)
AADD(PARAMIXB,cMoeda)
AADD(PARAMIXB,aSetOfBook)
AADD(PARAMIXB,cAlias)
AADD(PARAMIXB,cIdent)
AADD(PARAMIXB,lImpAntLP)
AADD(PARAMIXB,dDataLP)
AADD(PARAMIXB,lVlrZerado)
AADD(PARAMIXB,cEntFil1)
AADD(PARAMIXB,cEntFil2)
AADD(PARAMIXB,aGeren)
AADD(PARAMIXB,lImpSint)
AADD(PARAMIXB,lRecDesp0)
AADD(PARAMIXB,cRecDesp)
AADD(PARAMIXB,dDtZeraRD)
AADD(PARAMIXB,lMovPeriodo)
AADD(PARAMIXB,cSaldos)
AADD(PARAMIXB,lPlGerSint)
AADD(PARAMIXB,lConsSaldo)
AADD(PARAMIXB,cCTAlias)
AADD(PARAMIXB,lUsaNmVis)
AADD(PARAMIXB,cNomeVis)
AADD(PARAMIXB,aSelfil)
AADD(PARAMIXB,cQuadroCTB)

//If nQtdEntid == NIL
	nQtdEntid:= If(FindFunction("CtbQtdEntd"),CtbQtdEntd(),4) //sao 4 entidades padroes -> conta /centro custo /item contabil/ classe de valor
//EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Novas entidades³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If _lCtbIsCube .And. CtbIsCube() 

	//1-CT0->CT0_ALIAS ,2-CT0->CT0_ENTIDA,3-CT0->CT0_ID,4-CT0->CT0_CPOCHV,5-CT0->CT0_CPODSC,6-CT0->CT0_F3ENTI
	aRegCT0 := CtbRegCt0()	// Registros da tabela CT0
    
    If nQtdEntid >=	5
		cZZZEnt05	:= Repl("Z",Len(Criavar(aRegCT0[5][4])))   
		cEntid05Ini	:= Space(Len(Criavar(aRegCT0[5][4])))
		cEntid05Fim	:= cZZZEnt05 
		lMovEnt05 	:= CtbMovSaldo("CT0",,'05')	 
	EndIf
                     
    If nQtdEntid >=	6
		cZZZEnt06	:= Repl("Z",Len(Criavar(aRegCT0[6][4])))   	                              
		cEntid06Ini	:= Space(Len(Criavar(aRegCT0[6][4])))
		cEntid06Fim	:= cZZZEnt06                   
		lMovEnt06 	:= CtbMovSaldo("CT0",,'06')				
	EndIf	
                     
    If nQtdEntid >=	7
		cZZZEnt07	:= Repl("Z",Len(Criavar(aRegCT0[7][4])))   	
		cEntid07Ini	:= Space(Len(Criavar(aRegCT0[7][4])))
		cEntid07Fim	:= cZZZEnt07                   
		lMovEnt07 	:= CtbMovSaldo("CT0",,'07')				
	EndIf	
	                 
    If nQtdEntid >=	8	
		cZZZEnt08	:= Repl("Z",Len(Criavar(aRegCT0[8][4])))   
		cEntid08Ini	:= Space(Len(Criavar(aRegCT0[8][4])))
		cEntid08Fim	:= cZZZEnt08                   
		lMovEnt08 	:= CtbMovSaldo("CT0",,'08')				
	EndIf		        
	                 
    If nQtdEntid == 9	
		cZZZEnt09	:= Repl("Z",Len(Criavar(aRegCT0[9][4])))   
		cEntid09Ini	:= Space(Len(Criavar(aRegCT0[9][4])))
		cEntid09Fim	:= cZZZEnt09				    
		lMovEnt09 	:= CtbMovSaldo("CT0",,'09')	 
	EndIf	 
	
EndIf

dbSelectArea("CVQ")
dbsetorder(1)
xCVQ		:= xfilial("CVQ")

// tratativa para o tipo de saldo maior que 1, consolida saldo
IF !Empty( cSaldos )
	cSaldos := Alltrim( StrTran( cSaldos,";","','") )
Endif

lTRegCts	:= Type("lTRegCts") # "U" .And. ValType(lTRegCts) = "L" .And. lTRegCts
cAlias		:= Iif(cAlias == Nil,"",cAlias)
cIdent		:= Iif(cIdent == Nil,"",cIdent)
lVlrZerado	:= Iif(lVlrZerado == Nil,.T.,lVlrZerado)

If aGeren != Nil
	cCtaFil1  :=	If(MsAscii(aGeren[1])== 13,"",aGeren[1])
	cCtaFil2  :=	If(MsAscii(aGeren[2])== 13,"",aGeren[2])
	cCCFil1   :=	If(MsAscii(aGeren[3])== 13,"",aGeren[3])
	cCCFil2   :=	If(MsAscii(aGeren[4])== 13,"",aGeren[4])
	cItemFil1 :=	If(MsAscii(aGeren[5])== 13,"",aGeren[5])
	cItemFil2 :=	If(MsAscii(aGeren[6])== 13,"",aGeren[6])
	cCLVLFil1 :=	If(MsAscii(aGeren[7])== 13,"",aGeren[7])
	cCLVLFil2 :=	If(MsAscii(aGeren[8])== 13,"",aGeren[8])
EndIf	

lCT1Fil 	:= .F.
lCTTFil 	:= .F.
lCTDFil		:= .F.
lCTHFil		:= .F.
lEnt05Fil	:= .F.
lEnt06Fil	:= .F.
lEnt07Fil	:= .F.
lEnt08Fil	:= .F.
lEnt09Fil	:= .F.

// Filtragem da entidade compositora do Plano Gerencial (Centro de Custo da Getdados)		
If !Empty(cCtaFil1) .Or. !Empty(cCtaFil2)
	lCT1Fil := .T.
	If cCtaFil1 > cContaIni 
		cContaIni := cCtaFil1
	EndIf
	If cCtaFil2 < cContaFim	
		cContaFim := cCtaFil2
	EndIf	
EndIf	

// Filtragem da entidade compositora do Plano Gerencial (Centro de Custo da Getdados)		
If lMovCusto
	If !Empty(cCCFil1) .Or. !Empty(cCCFil2)
		lCTTFil := .T.
		If cCCFil1 > cCustoIni 
			cCustoIni := cCCFil1
		EndIf
		If cCCFil2 < cCustoFim	
			cCustoFim := cCcFil2
		EndIf	
	EndIf	
EndIf
/* Observacoes:
C.Custo do Plano Gerencial
001	002	003
			
C.Custo Informado no Filtro
000	001	002	003	004
			
O relatorio so podera imprimir: 001 002 003	*/

// Filtragem da entidade compositora do Plano Gerencial (Item Contabil da Getdados)
If lMovItem
	If !Empty(cItemFil1) .Or. !Empty(cItemFil2)
		lCTDFil := .T.
		If cItemFil1 > cItemIni 
			cItemIni := cItemFil1
		EndIf
		If cItemFil2 < cItemFim	
			cItemFim := cItemFil2
		EndIf	
	EndIf	
EndIf

// Filtragem da entidade compositora do Plano Gerencial (Classe de Valor da Getdados)
If lMovClass
	If !Empty(cCLVLFil1) .Or. !Empty(cCLVLFil2)
		lCTHFil := .T.
		If cCLVLFil1 > cClVlIni 
			cClVlIni := cClVlFil1
		EndIf
		If cCLVLFil2 < cClVlFim	
			cClVlFim := cClVlFil2
		EndIf	
	EndIf	
EndIf

// TRATAMENTOS NECESSARIOS PARA FUNCIONAR O "QUADROCTB=" na "formula" ( CTS->CTS_FORMUL ) da visao gerencial .
// NAO ESQUECER DE ADICIONAR O cQuadroCTB COMO PARAMETRO NA CTGERPLN() E COM DEFAULT cQuadroCTB := ""
// TRATAR NO .INI O PARAMETRO QUADRO CONTABIL E PASSA-LO PARA A CTGERPLN()

IF !EMPTY(cQuadroCTB)
   // copia do PARAMIXB
   PARAMIXC := aclone(PARAMIXB)

   aParamCVQ:= {}
   aadd(aParamCVQ , "")         // [01][C] := Código do Exercicio Contábil
   aadd(aParamCVQ , dDataFim )  // [02][D] := Data de referencia
   aadd(aParamCVQ , .T. )       // [03][L] := Demonstra período anteriord (S/N)  ?
   aadd(aParamCVQ , lImpAntLP ) // [04][L] := Posicao anterior a LP (S/N)
   aadd(aParamCVQ , dDataLP )   // [05][D] := Data de lucros e perdas
   aadd(aParamCVQ , cMoeda )    // [06][C] := Moeda
   aadd(aParamCVQ , cSaldos)    // [07][C] := Tipo de saldo
   aadd(aParamCVQ , lConsSaldo) // [08][L] := Consolidar Saldo (S/N)
   aadd(aParamCVQ , cSaldos )   // [09][C] := Saldos a Consolidar
   aadd(aParamCVQ , dDataIni )  // [10][D] := dDataIni
   aadd(aParamCVQ , dDataFim )  // [11][D] := dDataFin

	CTBGERQDO(cQuadroCTB,aParamCVQ,@cArqQuadro,oMeter,oText,oDlg,aSetOfBook, @lEnd) 
			dbSelectArea(cArqQuadro)
         (cArqQuadro)->(dbgotop())
			IF Select("F101Q") > 0
			   DbSelectArea("F101Q")
			   dbCloseArea()   
			Endif
			IF FILE("F101Q.DBF")
			   FErase("F101Q.DBF")
			ENDIF
			COPY TO F101Q.DBF

   PARAMIXB := aclone(PARAMIXC)
	
ENDIF

dbSelectArea("CTS")
If ValType(oMeter) == "O"
	oMeter:nTotal := CTS->(RecCount())
EndIf
dbSetOrder(1)

MsSeek(cFilCTS+cPlanGer,.T.)

If lUsaNmVis
	cNomeVis := CTS->CTS_NOME
EndIf

While !Eof() .And. 	CTS->CTS_FILIAL == cFilCTS .And.;
					CTS->CTS_CODPLA == cPlanGer

	// SOMENTE PODERÃO SER IMPRESSAS ENTIDADES SINTETICAS CUJO OS IDENTIFICADORES SEJAM
	// 5- LINHA SEM VALOR
	// 6- LINHA SEM VALOR EM NEGRITO
	// 7- TRACO / SEPARADOR
	// MOTIVO: ESTAS ENTIDADES SINTETICAS NAO SERAO FORMADAS PELAS ROTINA POIS NENHUMA ENTIDADE
	// A UTILIZARA COMO SUPERIORA.
	If CTS->CTS_CLASSE == "1" .And. IIf( lPlGerSint , !(CTS->CTS_IDENT $ "567" ) , .T. )
		dbSkip()
		Loop
	EndIf

	//Efetua o filtro dos parametros considerando o plano gerencial.
	If !Empty(cEntFil1) .Or. !Empty(cEntFil2)
		If CTS->CTS_CONTAG < cEntFil1 .Or. CTS->CTS_CONTAG > cEntFil2
			dbSkip()
			Loop
		EndIf	
	EndIf	                                   
	// Recarrega variáveis
	lConta 	:= .F.
	lCusto	:= .F.
	lItem	:= .F.
	lClasse	:= .F.
 	lEnt05	:= .F.	
 	lEnt06	:= .F.	
 	lEnt07	:= .F.	                    
 	lEnt08	:= .F.	
 	lEnt09	:= .F.	 	 	

	// Grava conta analitica
	cConta 	:= CTS->CTS_CONTAG
	cDesc	:= CTS->CTS_DESCCG
	cOrdem	:= CTS->CTS_ORDEM

	nSaldoAnt 	:= 0	// Zero as variaveis para acumular
	nSaldoDeb 	:= 0
	nSaldoCrd 	:= 0

	nSaldoAtu 	:= 0
	nSaldoSEM 	:= 0
	nSaldoPer	:= 0

	nSaldoAntD	:= 0
	nSaldoAntC	:= 0
	nSaldoAtuD	:= 0
	nSaldoAtuC	:= 0
	nMOVIMPER	:= 0
	nMovPerAnt	:= 0
	dbSelectArea("CTS")
	dbSetOrder(1)

	While !Eof() .And. CTS->CTS_FILIAL == cFilCTS .And.;
						CTS->CTS_CODPLA == cPlanGer  .And. CTS->CTS_ORDEM	== cOrdem
		aSaldoAnt	:= { 0, 0, 0, 0, 0, 0, 0, 0 }
		aSaldoAtu	:= { 0, 0, 0, 0, 0, 0, 0, 0 }
		aSaldoSEM	:= { 0, 0, 0, 0, 0, 0, 0, 0 }
		aSaldoPER	:= { 0, 0, 0, 0, 0, 0, 0, 0 }

		lClasse := .F.
		lItem	:= .F.
		lCusto	:= .F.
		lConta	:= .F.
		/*
		ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		³ TRATATIVA DE TIPO DE SALDO NOS RELATORIOS DE DEMONSTRA-³
		³ TIVOS (CTBR5XX)                                        ³
		ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		*/
		// Tipo de saldo configurado na visão gerencial
		cTpSaldo := Alltrim( CTS->CTS_TPSALD )

    // Caso o Tipo de saldo estiver configurado na visão gerencial com asterisco
    // ou a rotina chamadora consolida os tipos de saldos, considero os parametros da tela (SX1)
    If ( cTpSaldo == "*" .And. cSaldos <> "*" ) .OR. lConsSaldo
        cTpSaldo := cSaldos
    ElseIf ( cTpSaldo <> "*" .And. cSaldos <> "*" ) .And.  cTpSaldo <> cSaldos
        nReg := Recno()
        dbSkip()
        Loop
    EndIf
		
		//Entidade 09			
		If !lEnt09Fil .And. nQtdEntid >= 9
			If ( CTS->( FieldPos( "CTS_E09INI" ) ) > 0  .And. !Empty(CTS->CTS_E09INI) ) .Or. ;
			   ( CTS->( FieldPos( "CTS_E09FIM" ) ) > 0  .And. !Empty(CTS->CTS_E09FIM)	)	// Saldo a partir da entidade 09
				cEntid09Ini	:= CTS->CTS_E09INI
				cEntid09Fim	:= CTS->CTS_E09FIM
				lEnt09 := .T.
			Else
				cEntid09Ini	:= ""
				cEntid09Fim	:= cZZZEnt09
			EndIf
		Else
			lEnt09 := .T.
		Endif	   
		
		//Entidade 08			
		If !lEnt08Fil .And. nQtdEntid >= 8
			If ( CTS->( FieldPos( "CTS_E08INI" ) ) > 0  .And. !Empty(CTS->CTS_E08INI) ) .Or. ;
			   ( CTS->( FieldPos( "CTS_E08FIM" ) ) > 0  .And. !Empty(CTS->CTS_E08FIM)	)	// Saldo a partir da entidade 08
				cEntid08Ini	:= CTS->CTS_E08INI
				cEntid08Fim	:= CTS->CTS_E08FIM
				lEnt08 := .T.
			Else
				cEntid08Ini	:= ""
				cEntid08Fim	:= cZZZEnt08
			EndIf
		Else
			lEnt08 := .T.
		Endif						
		        
		//Entidade 07			
		If !lEnt07Fil .And. nQtdEntid >= 7
			If ( CTS->( FieldPos( "CTS_E07INI" ) ) > 0  .And. !Empty(CTS->CTS_E07INI) ) .Or. ;
			   ( CTS->( FieldPos( "CTS_E07FIM" ) ) > 0  .And. !Empty(CTS->CTS_E07FIM)	)	// Saldo a partir da entidade 07
				cEntid07Ini	:= CTS->CTS_E07INI
				cEntid07Fim	:= CTS->CTS_E07FIM
				lEnt07 := .T.
			Else
				cEntid07Ini	:= ""
				cEntid07Fim	:= cZZZEnt07
			EndIf 
		Else
			lEnt07 := .T.
		Endif				

		//Entidade 06			
		If !lEnt06Fil .And. nQtdEntid >= 6
			If ( CTS->( FieldPos( "CTS_E06INI" ) ) > 0  .And. !Empty(CTS->CTS_E06INI) ) .Or. ;
			   ( CTS->( FieldPos( "CTS_E06FIM" ) ) > 0  .And. !Empty(CTS->CTS_E06FIM)	)	// Saldo a partir da entidade 06
				cEntid06Ini	:= CTS->CTS_E06INI
				cEntid06Fim	:= CTS->CTS_E06FIM
				lEnt06 := .T.
			Else
				cEntid06Ini	:= ""
				cEntid06Fim	:= cZZZEnt06
			EndIf
		Else
			lEnt06 := .T.
		Endif				

		//Entidade 05			
		If !lEnt05Fil .And. nQtdEntid >= 5
			If ( CTS->( FieldPos( "CTS_E05INI" ) ) > 0  .And. !Empty(CTS->CTS_E05INI) ) .Or. ;
			   ( CTS->( FieldPos( "CTS_E05FIM" ) ) > 0  .And. !Empty(CTS->CTS_E05FIM)	)	// Saldo a partir da entidade 05
				cEntid05Ini	:= CTS->CTS_E05INI
				cEntid05Fim	:= CTS->CTS_E05FIM
				lEnt05 := .T.
			Else
				cEntid05Ini	:= ""
				cEntid05Fim	:= cZZZEnt05
			EndIf
		Else
			lEnt05 := .T.
		Endif		

		If !lCTHFil
			If !Empty(CTS->CTS_CTHINI) .Or. !Empty(CTS->CTS_CTHFIM)		// Saldo a partir da classe
				cClVlIni	:= CTS->CTS_CTHINI
				cClVlFim	:= CTS->CTS_CTHFIM
				lClasse := .T.
			Else
				cCLVLIni	:= ""
				cCLVLFim	:= cZZZCTH
			EndIf
		Else
			lClasse := .T.
		Endif

		If !lCTDFil
			If !Empty(CTS->CTS_CTDINI) .Or. !Empty(CTS->CTS_CTDFIM)	// Saldo a partir do Item
				cItemIni	:= CTS->CTS_CTDINI
				cItemFim	:= CTS->CTS_CTDFIM			
				lItem := .T.
			Else
				cItemIni	:= ""
				cItemFim	:= cZZZCTD        		
			EndIf
		Else
			lItem	:= .T.
		Endif
		
		If !lCTTFil
			If !Empty(CTS->CTS_CTTINI) .Or. !Empty(CTS->CTS_CTTFIM)	// Saldo a partir do C.Custo
				cCustoIni	:= CTS->CTS_CTTINI
				cCustoFim	:= CTS->CTS_CTTFIM
				lCusto := .T.
			Else
				cCustoIni	:= ""
				cCustoFim	:= cZZZCTT        
			EndIf
		Else
			lCusto	:= .T.
		Endif

		If !lCT1Fil
			If !Empty(CTS->CTS_CT1INI) .Or. !Empty(CTS->CTS_CT1FIM)	// Saldo a partir da Conta
				cContaIni	:= CTS->CTS_CT1INI
				cContaFim	:= CTS->CTS_CT1FIM
				lConta := .T.
			Else
				cContaIni	:= ""
				cContaFim	:= cZZZCT1
			EndIf
		Else
			lConta	:= .T.		
		EndIf

		If lEnt09 .and. lMovEnt09  

			cCodigoEnt	:= '09' 
			aEntidIni	:= {} 
			aEntidFim	:= {}			
		
			AADD( aEntidIni	,cContaIni )
			AADD( aEntidIni	,cCustoIni )
			AADD( aEntidIni	,cItemIni ) 
			AADD( aEntidIni	,cClVlIni )
			AADD( aEntidIni	,cEntid05Ini)			                             
			AADD( aEntidIni	,cEntid06Ini)			                             
			AADD( aEntidIni	,cEntid07Ini)			
			AADD( aEntidIni	,cEntid08Ini) 
			AADD( aEntidIni	,cEntid09Ini)			
			                            
			AADD( aEntidFim	,cContaFim )			
			AADD( aEntidFim	,cCustoFim) 
			AADD( aEntidFim	,cItemFim)
			AADD( aEntidFim	,cClVlFim)
			AADD( aEntidFim	,cEntid05Fim) 
			AADD( aEntidFim	,cEntid06Fim)
			AADD( aEntidFim	,cEntid07Fim)
			AADD( aEntidFim	,cEntid08Fim)
			AADD( aEntidFim	,cEntid09Fim)		 
			
			aSaldoAnt := CtbSldCubo(aEntidIni,aEntidFim,Ctod("//"),dDataIni-1,cMoeda,cTpSaldo,aSelFil)							 
			aSaldoAtu := CtbSldCubo(aEntidIni,aEntidFim,dDataIni,dDataFim,cMoeda,cTpSaldo,aSelFil)													
			If lSemestre
				aSaldoSem := CtbSldCubo(aEntidIni,aEntidFim,StoD(Left(DtoS(dSemestre),4)+"0101"),dSemestre,cMoeda,cTpSaldo,aSelFil)
			Endif
			If lPeriodo0
				aSaldoPer := CtbSldCubo(aEntidIni,aEntidFim,NIL,dPeriodo0,cMoeda,cTpSaldo,aSelFil)
			Endif			
			
		ElseIf lEnt08 .and. lMovEnt08        
		
			cCodigoEnt	:= '08'		
			aEntidIni	:= {} 
			aEntidFim	:= {}			
		
			AADD( aEntidIni	,cContaIni )
			AADD( aEntidIni	,cCustoIni )
			AADD( aEntidIni	,cItemIni ) 
			AADD( aEntidIni	,cClVlIni )
			AADD( aEntidIni	,cEntid05Ini)			                             
			AADD( aEntidIni	,cEntid06Ini)			                             
			AADD( aEntidIni	,cEntid07Ini)			
			AADD( aEntidIni	,cEntid08Ini) 
			                            
			AADD( aEntidFim	,cContaFim )			
			AADD( aEntidFim	,cCustoFim) 
			AADD( aEntidFim	,cItemFim)
			AADD( aEntidFim	,cClVlFim)
			AADD( aEntidFim	,cEntid05Fim) 
			AADD( aEntidFim	,cEntid06Fim)
			AADD( aEntidFim	,cEntid07Fim)
			AADD( aEntidFim	,cEntid08Fim)       
			
			aSaldoAnt := CtbSldCubo(aEntidIni,aEntidFim,Ctod("//"),dDataIni-1,cMoeda,cTpSaldo,aSelFil)							 
			aSaldoAtu := CtbSldCubo(aEntidIni,aEntidFim,dDataIni,dDataFim,cMoeda,cTpSaldo,aSelFil)													
			If lSemestre
				aSaldoSem := CtbSldCubo(aEntidIni,aEntidFim,StoD(Left(DtoS(dSemestre),4)+"0101"),dSemestre,cMoeda,cTpSaldo,aSelFil)
			Endif
			If lPeriodo0
				aSaldoPer := CtbSldCubo(aEntidIni,aEntidFim,NIL,dPeriodo0,cMoeda,cTpSaldo,aSelFil)
			Endif			
		
		ElseIf lEnt07 .and. lMovEnt07
		
			cCodigoEnt	:= '07'		
			aEntidIni	:= {} 
			aEntidFim	:= {}			
		
			AADD( aEntidIni	,cContaIni )
			AADD( aEntidIni	,cCustoIni )
			AADD( aEntidIni	,cItemIni ) 
			AADD( aEntidIni	,cClVlIni )
			AADD( aEntidIni	,cEntid05Ini)			                             
			AADD( aEntidIni	,cEntid06Ini)			                             
			AADD( aEntidIni	,cEntid07Ini)			
			                            
			AADD( aEntidFim	,cContaFim )			
			AADD( aEntidFim	,cCustoFim) 
			AADD( aEntidFim	,cItemFim)
			AADD( aEntidFim	,cClVlFim)
			AADD( aEntidFim	,cEntid05Fim) 
			AADD( aEntidFim	,cEntid06Fim)
			AADD( aEntidFim	,cEntid07Fim)
		                                      
			aSaldoAnt := CtbSldCubo(aEntidIni,aEntidFim,Ctod("//"),dDataIni-1,cMoeda,cTpSaldo,aSelFil)							 
			aSaldoAtu := CtbSldCubo(aEntidIni,aEntidFim,dDataIni,dDataFim,cMoeda,cTpSaldo,aSelFil)													
			If lSemestre
				aSaldoSem := CtbSldCubo(aEntidIni,aEntidFim,StoD(Left(DtoS(dSemestre),4)+"0101"),dSemestre,cMoeda,cTpSaldo,aSelFil)
			Endif
			If lPeriodo0
				aSaldoPer := CtbSldCubo(aEntidIni,aEntidFim,NIL,dPeriodo0,cMoeda,cTpSaldo,aSelFil)
			Endif			
		
		ElseIf lEnt06 .and. lMovEnt06
		
			cCodigoEnt	:= '06'
			aEntidIni	:= {} 
			aEntidFim	:= {}			
		
			AADD( aEntidIni	,cContaIni )
			AADD( aEntidIni	,cCustoIni )
			AADD( aEntidIni	,cItemIni ) 
			AADD( aEntidIni	,cClVlIni )
			AADD( aEntidIni	,cEntid05Ini)			                             
			AADD( aEntidIni	,cEntid06Ini)			                             
			                            
			AADD( aEntidFim	,cContaFim )			
			AADD( aEntidFim	,cCustoFim) 
			AADD( aEntidFim	,cItemFim)
			AADD( aEntidFim	,cClVlFim)
			AADD( aEntidFim	,cEntid05Fim) 
			AADD( aEntidFim	,cEntid06Fim)  
			
			aSaldoAnt := CtbSldCubo(aEntidIni,aEntidFim,Ctod("//"),dDataIni-1,cMoeda,cTpSaldo,aSelFil)							 
			aSaldoAtu := CtbSldCubo(aEntidIni,aEntidFim,dDataIni,dDataFim,cMoeda,cTpSaldo,aSelFil)													
			If lSemestre
				aSaldoSem := CtbSldCubo(aEntidIni,aEntidFim,StoD(Left(DtoS(dSemestre),4)+"0101"),dSemestre,cMoeda,cTpSaldo,aSelFil)
			Endif
			If lPeriodo0
				aSaldoPer := CtbSldCubo(aEntidIni,aEntidFim,NIL,dPeriodo0,cMoeda,cTpSaldo,aSelFil)
			Endif			
		
		ElseIf lEnt05 .and. lMovEnt05
		
			cCodigoEnt	:= '05'		
			aEntidIni	:= {} 
			aEntidFim	:= {}			
		
			AADD( aEntidIni	,cContaIni )
			AADD( aEntidIni	,cCustoIni )
			AADD( aEntidIni	,cItemIni ) 
			AADD( aEntidIni	,cClVlIni )
			AADD( aEntidIni	,cEntid05Ini)			                             
			                            
			AADD( aEntidFim	,cContaFim )			
			AADD( aEntidFim	,cCustoFim) 
			AADD( aEntidFim	,cItemFim)
			AADD( aEntidFim	,cClVlFim)
			AADD( aEntidFim	,cEntid05Fim)      
			
			aSaldoAnt := CtbSldCubo(aEntidIni,aEntidFim,Ctod("//"),dDataIni-1,cMoeda,cTpSaldo,aSelFil)							 
			aSaldoAtu := CtbSldCubo(aEntidIni,aEntidFim,dDataIni,dDataFim,cMoeda,cTpSaldo,aSelFil)													
			If lSemestre
				aSaldoSem := CtbSldCubo(aEntidIni,aEntidFim,StoD(Left(DtoS(dSemestre),4)+"0101"),dSemestre,cMoeda,cTpSaldo,aSelFil)
			Endif
			If lPeriodo0
				aSaldoPer := CtbSldCubo(aEntidIni,aEntidFim,NIL,dPeriodo0,cMoeda,cTpSaldo,aSelFil)
			Endif			
		
		ElseIf lClasse .and. lMovClass

			aSaldoAnt := SaldTotCTI(cClVlIni,cClVlFim,cItemIni,;
									cItemFim,cCustoIni,cCustoFim,cContaIni,;
									cContaFim,dDataIni,cMoeda,cTpSaldo,aSelFil,lRecDesp0,cRecDesp,dDtZeraRD,lImpAntLP,dDataLP,,lConsSaldo)
								
			aSaldoAtu := SaldTotCTI(cClVlIni,cClVlFim,cItemIni,;
									cItemFim,cCustoIni,cCustoFim,cContaIni,;
									cContaFim,dDataFim,cMoeda,cTpSaldo,aSelFil,lRecDesp0,cRecDesp,dDtZeraRD,lImpAntLP,dDataLP,,lConsSaldo)
			If lSemestre
				aSaldoSem := SaldTotCTI(cClVlIni,cClVlFim,cItemIni,;
										cItemFim,cCustoIni,cCustoFim,cContaIni,;
										cContaFim,dSemestre,cMoeda,cTpSaldo,aSelFil,,,,lImpAntLP,dDataLP,,lConsSaldo)
			Endif
			If lPeriodo0
				aSaldoPer := SaldTotCTI(cClVlIni,cClVlFim,cItemIni,;
										cItemFim,cCustoIni,cCustoFim,cContaIni,;
										cContaFim,dPeriodo0,cMoeda,cTpSaldo,aSelFil,,,,lImpAntLP,dDataLP,,lConsSaldo)
			Endif
		
		ElseIf lItem .and. lMovItem		
		
			aSaldoAnt := SaldTotCT4(cItemIni,cItemFim,cCustoIni,;
									cCustoFim,cContaIni,cContaFim,;
									dDataIni,cMoeda,cTpSaldo,aSelFil,lRecDesp0,cRecDesp,dDtZeraRD,lImpAntLP,dDataLP,,lConsSaldo)
								
			aSaldoAtu := SaldTotCT4(cItemIni,cItemFim,cCustoIni,;
									cCustoFim,cContaIni,cContaFim,;
									dDataFim,cMoeda,cTpSaldo,aSelFil,lRecDesp0,cRecDesp,dDtZeraRD,lImpAntLP,dDataLP,,lConsSaldo)
			If lSemestre
				aSaldoSem := SaldTotCT4(cItemIni,cItemFim,cCustoIni,;
										cCustoFim,cContaIni,cContaFim,;
										dSemestre,cMoeda,cTpSaldo,aSelFil,,,,lImpAntLP,dDataLP,,lConsSaldo)
			Endif
			If lPeriodo0
				aSaldoPEr := SaldTotCT4(cItemIni,cItemFim,cCustoIni,;
										cCustoFim,cContaIni,cContaFim,;
										dPeriodo0,cMoeda,cTpSaldo,aSelFil,,,,lImpAntLP,dDataLP,,lConsSaldo)
			Endif
		
		ElseIf lCusto .and. lMovCusto
		
			aSaldoAnt := SaldTotCT3(cCustoIni,cCustoFim,cContaIni,;
									cContaFim,dDataIni,cMoeda,cTpSaldo,aSelFil,lRecDesp0,cRecDesp,dDtZeraRD,lImpAntLP,dDataLP,,lConsSaldo)
			aSaldoAtu := SaldTotCT3(cCustoIni,cCustoFim,cContaIni,;
									cContaFim,dDataFim,cMoeda,cTpSaldo,aSelFil,lRecDesp0,cRecDesp,dDtZeraRD,lImpAntLP,dDataLP,,lConsSaldo)

			If lSemestre
				aSaldoSem := SaldTotCT3(cCustoIni,cCustoFim,cContaIni,;
										cContaFim,dSemestre,cMoeda,cTpSaldo,aSelFil,,,,lImpAntLP,dDataLP,,lConsSaldo)
			Endif
			If lPeriodo0
				aSaldoPer := SaldTotCT3(cCustoIni,cCustoFim,cContaIni,;
										cContaFim,dPeriodo0,cMoeda,cTpSaldo,aSelFil,,,,lImpAntLP,dDataLP,,lConsSaldo)
			Endif
		
		ElseIf lConta
		
			aSaldoAnt := U_SaldTotCT7(cContaIni,cContaFim,dDataIni,cMoeda,cTpSaldo,lImpAntLP,dDataLP,aSelFil,lRecDesp0,cRecDesp,dDtZeraRD,,lConsSaldo)
			aSaldoAtu := SaldTotCT7(cContaIni,cContaFim,dDataFim,cMoeda,cTpSaldo,lImpAntLP,dDataLP,aSelFil,lRecDesp0,cRecDesp,dDtZeraRD,,lConsSaldo)
			If lSemestre
				aSaldoSem := SaldTotCT7(cContaIni,cContaFim,dSemestre,cMoeda,cTpSaldo,lImpAntLP,dDataLP,aSelFil,,,,,lConsSaldo)
			Endif
			If lPeriodo0
				aSaldoPer := SaldTotCT7(cContaIni,cContaFim,dPeriodo0,cMoeda,cTpSaldo,lImpAntLP,dDataLP,aSelFil,,,,,lConsSaldo)
			Endif
		EndIf		

		If aSetOfBook[9] > 1	// Divisao por fator
			nLSldAnt := Len(aSaldoAnt)
			nLSldAtu := Len(aSaldoAtu)
			nLSldSem := Len(aSaldoSem)
			nLSldPer := Len(aSaldoPer)
			For nPos := 1 To nLSldAnt
				aSaldoAnt[nPos] := Round(NoRound((aSaldoAnt[nPos]/aSetOfBook[9]),3),2)
			Next
			For nPos := 1 To nLSldAtu
				aSaldoAtu[nPos] := Round(NoRound((aSaldoAtu[nPos]/aSetOfBook[9]),3),2)
			Next
			If lSemestre
				For nPos := 1 To nLSldSem
					aSaldoSem[nPos] := Round(NoRound((aSaldoSem[nPos]/aSetOfBook[9]),3),2)
				Next
			Endif
			If lPeriodo0
				For nPos := 1 To nLSldPer
					aSaldoPer[nPos] := Round(NoRound((aSaldoPer[nPos]/aSetOfBook[9]),3),2)
				Next
			Endif
		Endif

		If Left(CTS->CTS_FORMUL, 7) == "ROTINA="
			nLSldAnt := Len(aSaldoAnt)
			nLSldAtu := Len(aSaldoAtu)
			nLSldSem := Len(aSaldoSem)
			nLSldPer := Len(aSaldoPer)
			nFator := &(Subs(CTS->CTS_FORMUL, 8))
			For nPos := 1 To nLSldAnt
				aSaldoAnt[nPos] *= nFator
			Next
			For nPos := 1 To nLSldAtu
				aSaldoAtu[nPos] *= nFator
			Next
			If lSemestre
				For nPos := 1 To nLSldSem
					aSaldoSem[nPos] *= nFator
				Next
			Endif
			If lPeriodo0
				For nPos := 1 To nLSldPer
					aSaldoPer[nPos] *= nFator
				Next
			Endif
		ElseIf Left(CTS->CTS_FORMUL, 6) == "FATOR="
			nLSldAnt := Len(aSaldoAnt)
			nLSldAtu := Len(aSaldoAtu)
			nLSldSem := Len(aSaldoSem)
			nLSldPer := Len(aSaldoPer)
			nFator := &(Subs(CTS->CTS_FORMUL, 7))
			For nPos := 1 To nLSldAnt
				aSaldoAnt[nPos] *= nFator
			Next
			For nPos := 1 To nLSldAtu
				aSaldoAtu[nPos] *= nFator
			Next
			If lSemestre
				For nPos := 1 To nLSldSem
					aSaldoSem[nPos] *= nFator
				Next
			Endif
			If lPeriodo0
				For nPos := 1 To nLSldPer
					aSaldoPer[nPos] *= nFator
				Next
			Endif
		Elseif Left(CTS->CTS_FORMUL,6 ) == "SALDO="
			nLSldAnt := Len(aSaldoAnt)
			nLSldAtu := Len(aSaldoAtu)
			nLSldSem := Len(aSaldoSem)
			nLSldPer := Len(aSaldoPer)
			
			xFator := &(Subs(CTS->CTS_FORMUL, 7))			

			IF ValType(xFator) == "N"

				For nPos := 1 To nLSldAnt
					aSaldoAnt[nPos] := xFator
				Next
				For nPos := 1 To nLSldAtu
					aSaldoAtu[nPos] := xFator
				Next
				If lSemestre
					For nPos := 1 To nLSldSem
						aSaldoSem[nPos] := xFator
					Next
				Endif
				If lPeriodo0
					For nPos := 1 To nLSldPer
						aSaldoPer[nPos] := xFator
					Next
				Endif  		

			ELSEIF ValType(xFator) == "A" .AND. Len(xFator) >= 8
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Conteúdo padrao do array de saldos                   ³
			//³ [1] Saldo Atual (com sinal)                          ³
			//³ [2] Debito na Data                                   ³
			//³ [3] Credito na Data                                  ³
			//³ [4] Saldo Atual Devedor                              ³
			//³ [5] Saldo Atual Credor                               ³
			//³ [6] Saldo Anterior (com sinal)                       ³
			//³ [7] Saldo Anterior Devedor                           ³
			//³ [8] Saldo Anterior Credor                            ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

				For nPos := 1 To nLSldAnt
					aSaldoAnt[nPos] := xFator[nPos]
				Next
				For nPos := 1 To nLSldAtu
					aSaldoAtu[nPos] := xFator[nPos]
				Next
				If lSemestre
					For nPos := 1 To nLSldSem
						aSaldoSem[nPos] := xFator[nPos]
					Next
				Endif
				If lPeriodo0
					For nPos := 1 To nLSldPer
						aSaldoPer[nPos] := xFator[nPos]
					Next
				Endif  		
            ENDIF


		ElseIf Left(CTS->CTS_FORMUL,6 ) == "VISAO="
			nLSldAnt 	:= Len(aSaldoAnt)
			nLSldAtu 	:= Len(aSaldoAtu)
			nLSldSem 	:= Len(aSaldoSem)
			nLSldPer 	:= Len(aSaldoPer)
			cMoedaDesc 	:= IIf( Empty(mv_par14),mv_par03,mv_par14)
			nAt			:= At( ",", CTS->CTS_FORMUL )
			nAt2		:= At( "=", CTS->CTS_FORMUL )
			IF nAt > 0
				cCodVis		:= AllTrim( substr( CTS->CTS_FORMUL, 7, nAt - nAt2 - 1 ) )
				cEntidade	:= AllTrim( substr( CTS->CTS_FORMUL, nAt + 1 ) )
			ELSE
	            cCodVis		:= AllTrim( substr( CTS->CTS_FORMUL,07) )
				cEntidade	:= ""
			ENDIF			

			aSaldos  	:= GetSldVis( 	cCodVis, 0, oMeter, oText, oDlg, ;
										lEnd, dDataIni,dDataFim, cSaldos, lVlrZerado, ;
										cMoedaDesc, lMovPeriodo, aSetOfBook, cMoeda, ;
										lImpAntLP, dDataLP, lConsSaldo, cEntidade,aSelFil )

			If Len( aSaldos ) > 0
				For nPos := 1 To nLSldAnt
					aSaldoAnt[nPos] := aSaldos[nPos]
				Next
				For nPos := 1 To nLSldAtu
					aSaldoAtu[nPos] := aSaldos[nPos]
				Next
				If lSemestre
					For nPos := 1 To nLSldSem
						aSaldoSem[nPos] := aSaldos[nPos]
					Next
				Endif
				If lPeriodo0
					For nPos := 1 To nLSldPer
						aSaldoPer[nPos] := aSaldos[nPos]
					Next
				Endif  		
			EndIf

		ElseIf Left(CTS->CTS_FORMUL, 9) = "ENTIDADE="
			nLSldAnt 	:= Len(aSaldoAnt)
			nLSldAtu 	:= Len(aSaldoAtu)
			nLSldSem 	:= Len(aSaldoSem)
			nLSldPer 	:= Len(aSaldoPer)
			aSaldos	:= GetSldEnt( substr( CTS->CTS_FORMUL, 10 ) /*cEntidade*/,;
			                       /* cCodVis */,;
			                       /*cOrdVis*/,;
			                       0 /*nTpSaldo 0->RETORNA ARRAY*/ ,;
			                       cCTAlias /*cArqTmp*/;
			                     )
	
			If Len( aSaldos ) > 0
				For nPos := 1 To nLSldAnt
					aSaldoAnt[nPos] := aSaldos[nPos]
				Next
				For nPos := 1 To nLSldAtu
					aSaldoAtu[nPos] := aSaldos[nPos]
				Next
				If lSemestre
					For nPos := 1 To nLSldSem
						aSaldoSem[nPos] := aSaldos[nPos]
					Next
				Endif
				If lPeriodo0
					For nPos := 1 To nLSldPer
						aSaldoPer[nPos] := aSaldos[nPos]
					Next
				Endif  		
			EndIf

		ElseIf Left(CTS->CTS_FORMUL, 11) = "FTENTIDADE="
			nLSldAnt 	:= Len(aSaldoAnt)
			nLSldAtu 	:= Len(aSaldoAtu)
			nLSldSem 	:= Len(aSaldoSem)
			nLSldPer 	:= Len(aSaldoPer)
			nAt			:= At( ",", CTS->CTS_FORMUL )
			
			IF nAt > 0
	            cEntidade	:= AllTrim( substr( CTS->CTS_FORMUL,12,nAt-12) )
				nFator		:= VAL(AllTrim( substr( CTS->CTS_FORMUL, nAt + 1 ) ) )
			ELSE
	            cEntidade	:= AllTrim( substr( CTS->CTS_FORMUL,12) )
				nFator		:= 1
			ENDIF			

			aSaldos 	:= GetSldEnt( cEntidade, /* cCodVis */, /*cOrdVis*/, 0 /* nTpSaldo 0->RETORNA ARRAY */, cCTAlias /*cArqTmp*/)
	
			If Len( aSaldos ) > 0
				For nPos := 1 To nLSldAnt
					aSaldoAnt[nPos] := aSaldos[nPos] * nFator
				Next
				For nPos := 1 To nLSldAtu
					aSaldoAtu[nPos] := aSaldos[nPos] * nFator
				Next
				If lSemestre
					For nPos := 1 To nLSldSem
						aSaldoSem[nPos] := aSaldos[nPos]  * nFator
					Next
				Endif
				If lPeriodo0
					For nPos := 1 To nLSldPer
						aSaldoPer[nPos] := aSaldos[nPos]  * nFator
					Next
				Endif  		
			EndIf

		ElseIf Left(CTS->CTS_FORMUL, 9) = "VARIACAO="
		
			nLSldAnt 	:= Len(aSaldoAnt)
			nLSldAtu 	:= Len(aSaldoAtu)
			nLSldSem 	:= Len(aSaldoSem)
			nLSldPer 	:= Len(aSaldoPer)
			aSaldos	:= GetSldEnt( substr( CTS->CTS_FORMUL, 10 ) /*cEntidade*/,;
			                       /* cCodVis */,;
			                       /*cOrdVis*/,;
			                       0 /*nTpSaldo 0->RETORNA ARRAY*/ ,;
			                       cCTAlias /*cArqTmp*/;
			                     )

			If Len( aSaldos ) > 0
				For nPos := 1 To nLSldAnt
					aSaldoAnt[nPos] := 0.00 // Não é realizado tratamento de valor de variação anterior
				Next
				For nPos := 1 To nLSldAtu
					aSaldoAtu[nPos] := aSaldos[9] // Variação
				Next
				If lSemestre
					For nPos := 1 To nLSldSem
						aSaldoSem[nPos] := aSaldos[nPos]
					Next
				Endif
				If lPeriodo0
					For nPos := 1 To nLSldPer
						aSaldoPer[nPos] := aSaldos[nPos]
					Next
				Endif  		
			EndIf

		ElseIf Left(CTS->CTS_FORMUL, 10) = "MOVIMENTO="
			nLSldAnt 	:= Len(aSaldoAnt)
			nLSldAtu 	:= Len(aSaldoAtu)
			nLSldSem 	:= Len(aSaldoSem)
			nLSldPer 	:= Len(aSaldoPer)
			aSaldoAux 	:= GetSldMov( substr( CTS->CTS_FORMUL, 11 ), dDataIni, dDataFim, cMoeda ,aSelFil )

			For nPos := 1 To nLSldAnt
				aSaldoAnt[nPos] += aSaldoAux[1]
			Next
			For nPos := 1 To nLSldAtu
				aSaldoAtu[nPos] += aSaldoAux[2]
			Next
			If lSemestre
				For nPos := 1 To nLSldSem
					aSaldoSem[nPos] += aSaldoAux[2]
				Next
			EndIf
			If lPeriodo0
				For nPos := 1 To nLSldPer
					aSaldoPer[nPos] += aSaldoAux[2]
				Next
			EndIf

		ElseIf Left(CTS->CTS_FORMUL, 10) = "QUADROCTB="
			nLSldAnt 	:= Len(aSaldoAnt)
			nLSldAtu 	:= Len(aSaldoAtu)
			nLSldSem 	:= Len(aSaldoSem)
			nLSldPer 	:= Len(aSaldoPer)
			// cItemQdro	:= SUBS(ALLTRIM(substr( CTS->CTS_FORMUL, 11 )) + SPACE(3), 1 , 3)
			cItemQdro	:= alltrim(substr( CTS->CTS_FORMUL, 11 ))
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Conteúdo padrao do array de saldos                   ³
			//³ [1] Saldo Atual (com sinal)                          ³
			//³ [2] Debito na Data                                   ³
			//³ [3] Credito na Data                                  ³
			//³ [4] Saldo Atual Devedor                              ³
			//³ [5] Saldo Atual Credor                               ³
			//³ [6] Saldo Anterior (com sinal)                       ³
			//³ [7] Saldo Anterior Devedor                           ³
			//³ [8] Saldo Anterior Credor                            ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			aSaldos 	:= {0,0,0,0,0,0,0,0}
			dbSelectArea(cArqQuadro)
         (cArqQuadro)->(dbgotop())
			Do while ! (cArqQuadro)->(eof())
				if ( (cArqQuadro)->FILIAL == xCVQ ) .and. ( cItemQdro $ (cArqQuadro)->DESCRICAO )
				   nPos := 0
				   DO WHILE .T. .AND. nPos < 1000
						if Reclock((cArqQuadro), .F.)
		   				aSaldos[1] += (cArqQuadro)->SALDOATU
							aSaldos[6] += (cArqQuadro)->SALDOANT
							(cArqQuadro)->(msunlock())
							exit
			   		endif
					   nPos++
					EndDo
					if nPos >= 1000
				      // ERRO!
				      __Quit()
					endif
				endif  
				(cArqQuadro)->(dbskip())
         Enddo
         
			If Len( aSaldos ) > 0
				For nPos := 1 To nLSldAnt
					aSaldoAnt[nPos] := aSaldos[nPos]
				Next
				For nPos := 1 To nLSldAtu
					aSaldoAtu[nPos] := aSaldos[nPos]
				Next
				If lSemestre
					For nPos := 1 To nLSldSem
						aSaldoSem[nPos] := aSaldos[nPos]
					Next
				Endif
				If lPeriodo0
					For nPos := 1 To nLSldPer
						aSaldoPer[nPos] := aSaldos[nPos]
					Next
				Endif  		
			EndIf
			dbSelectArea("CTS")
		Endif
			
		// Calculos com os Fatores
		If CTS->CTS_IDENT = "1"				// Somo os saldos
			nSaldoAnt 	+= aSaldoAnt[6]		// Saldo Anterior
			nSaldoAtu 	+= aSaldoAtu[1]		// Saldo Atual
			If lSemestre
				nSaldoSem += aSaldoSEM[1]	// Saldo Semestre
			Endif
			If lPeriodo0
				nSaldoPer += aSaldoPER[1]	// Saldo variavel dPeriodo0
			Endif
			// Calculando o Movimento do periodo anterior
			If lMovPeriodo
				nMovPerAnt += ( (aSaldoAnt[8] - aSaldoAnt[7]) - (aSaldoPer[8] - aSaldoPer[7]) )
			EndIf
				
			nSaldoAntD 	+= aSaldoAnt[7]
			nSaldoAntC 	+= aSaldoAnt[8]

			nSaldoAtuD 	+= aSaldoAtu[4]
			nSaldoAtuC 	+= aSaldoAtu[5] 
		
			nSaldoDeb  	:= (nSaldoAtuD - nSaldoAntD)
			nSaldoCrd  	:= (nSaldoAtuC - nSaldoAntC)
				
		ElseIf CTS->CTS_IDENT = "2"			// Subtraio os saldos
			nSaldoAnt 	-= aSaldoAnt[6]		// Saldo Anterior
			nSaldoAtu 	-= aSaldoAtu[1]		// Saldo Atual
			If lSemestre
				nSaldoSem -= aSaldoSEM[1]	// Saldo Semestre
			Endif
			If lPeriodo0
				nSaldoPer -= aSaldoPER[1]	// Saldo Periodo determinado
			Endif
			// Calculando o Movimento do periodo anterior
			If lMovPeriodo
				nMovPerAnt -= ( (aSaldoAnt[8] - aSaldoAnt[7]) - (aSaldoPer[8] - aSaldoPer[7]) )
			EndIf
				
			nSaldoAntD 	-= aSaldoAnt[7]
			nSaldoAntC 	-= aSaldoAnt[8]
		
			nSaldoAtuD 	-= aSaldoAtu[4]
			nSaldoAtuC 	-= aSaldoAtu[5] 
		
			nSaldoDeb  	:= (nSaldoAtuD - nSaldoAntD)
			nSaldoCrd  	:= (nSaldoAtuC - nSaldoAntC)
		
		EndIf
       
		nMOVIMPER += (aSaldoAnt[5] - aSaldoPer[8]) - (aSaldoAnt[4] - aSaldoPer[7])

		dbSelectArea("CTS")
		dbSetOrder(1)  
		nReg := Recno()
		dbSkip()
		
		If lTRegCts .And. CTS_COLUNA > 0	// A coluna 0 nao respeita desmembramento
			Exit
		Endif		
	EnddO

	dbSelectArea("CTS")
	dbSetOrder(2)
	dbGoTo(nReg)
	cCodNor := CTS->CTS_NORMAL

	If !lVlrZerado .And. (nSaldoCrd-nSaldoDeb = 0 .And. nSaldoAnt == 0 .And. nSaldoAtu == 0) .And. ;
		(nSaldoDeb = 0 .And. nSaldoCRD = 0) 
		///DbDelete()			/// RETIRADO DELETE 
		
		dbSelectArea("CTS")	
		dbSetOrder(1)
		dbGoTo(nReg)
		dbSkip()
   		Loop					/// SÓ INCLUI NO TMP SE O SALDO NÃO ESTIVER ZERADO (NAO PRECISA ATUALIZAR SUPERIORES)
    EndIf	
    
	dbSelectArea(cCTAlias)
	dbSetOrder(1)	
	If !MsSeek(cConta)
		dbAppend()                    
		If cAlias = 'CTU'
			Do Case
			Case cIdent	= 'CTT'
				Replace CUSTO 	With  cConta
				Replace DESCCC	With cDesc						
				Replace TIPOCC 	With CTS->CTS_CLASSE				
			Case cIdent = 'CTD'
				Replace ITEM 		With cConta
				Replace DESCITEM    With cDesc			
				Replace TIPOITEM	With CTS->CTS_CLASSE
			Case cIdent = 'CTH'
				Replace CLVL		With cConta
				Replace DESCCLVL	With cDesc			
				Replace TIPOCLVL	With CTS->CTS_CLASSE							
			EndCase                          
		Else
			Replace CONTA 		With cConta
			Replace DESCCTA    	With cDesc
			If !Empty(cCodigoEnt)
				Replace &("CODENT"+cCodigoEnt) With cConta
				Replace &("DESCENT"+cCodigoEnt)    	With cDesc 
			EndIF
		EndIf
		Replace SUPERIOR  	With CTS->CTS_CTASUP
		Replace TIPOCONTA 	With CTS->CTS_CLASSE
		Replace NORMAL    	With CTS->CTS_NORMAL
		Replace ORDEM		With CTS->CTS_ORDEM
		Replace IDENTIFI	With CTS->CTS_IDENT
		Replace FILIAL		With xFilial( cCTAlias )

		If CTS->( FieldPos( "CTS_TOTVIS" ) ) > 0
			Replace TOTVIS 		With CTS->CTS_TOTVIS
		EndIf

		If CTS->( FieldPos( "CTS_VISENT" ) ) > 0
			Replace VISENT 		With CTS->CTS_VISENT
		EndIf

		If CTS->( FieldPos( "CTS_SLDENT" ) ) > 0
			Replace SLDENT 		With CTS->CTS_SLDENT
		EndIf

		If CTS->( FieldPos( "CTS_FATSLD" ) ) > 0
			Replace FATSLD 		With CTS->CTS_FATSLD
		EndIf

		If lColuna
			Replace COLUNA  With CTS->CTS_COLUNA
		Endif

		If lTRegCts
			CT1->(DbSeek(xFilial("CT1") + CTS->CTS_CT1INI))
			Replace DESCORIG 	With &("CT1->CT1_DESC" + cMoeda),;
					TIPOCONTA 	With CT1->CT1_CLASSE,;
					NORMAL    	With CT1->CT1_NORMAL
		Endif		
	EndIf

	If Left(CTS->CTS_FORMUL, 6) = "TEXTO="		// Adiciona texto a descricao
		Replace (cCTAlias)->DESCCTA With 	AllTrim( (cCTAlias)->DESCCTA) + Space(1) +;
												&(Subs(CTS->CTS_FORMUL, 7))
	Elseif Left(CTS->CTS_FORMUL, 9) = "TEXTOVAR="		// Substitui a descricao pelo retornado pela macro-execucao
		Replace (cCTAlias)->DESCCTA With 	&(Subs(CTS->CTS_FORMUL, 10))
		
	Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Inverte o saldo se assim a entidade estiver configurada ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If cArqTmp->FATSLD == "2"
		nSaldoAnt	*= -1
		nSaldoAtu	*= -1
		nSaldoAtuD	*= -1
		nSaldoAtuC	*= -1
		nSaldoDeb	*= -1
		nSaldoCrd	*= -1
	EndIf

	dbSelectArea(cCTAlias)
	Replace	SALDOANT With SALDOANT+nSaldoAnt			// Saldo Anterior
	Replace SALDOATU With SALDOATU+nSaldoAtu			// Saldo Atual

	Replace SALDOATUDB With SALDOATUDB+nSaldoAtuD		//Saldo Atual Devedor
	Replace SALDOATUCR With SALDOATUCR+nSaldoAtuC		//Saldo Atual Credor
	
	If lSemestre
		Replace SALDOSEM With SALDOSEM+nSaldoSEM		// Saldo Semestre
	Endif
	
	If lPeriodo0	// Saldo periodo determinado
		Replace SALDOPER 	With SALDOPER+nSaldoPER
		Replace MOVIMPER  	With MOVIMPER+nMOVIMPER 
	Endif

	If nSaldoDeb < 0 //.And. cCodNor == "1"
		Replace SALDOCRD	With SALDOCRD+nSaldoDeb
	ElseIf nSaldoDeb >= 0 //.And. cCodNor == "1"
		Replace SALDODEB	With SALDODEB+nSaldoDeb
	EndIf
	If nSaldoCrd < 0// .And. cCodNor == "2"
		Replace SALDODEB	With SALDODEB+nSaldoCrd
	ElseIf nSaldoCrd >= 0 //.And. cCodNor == "2"
		Replace SALDOCRD	With SALDOCRD+nSaldoCrd
	EndIf
	
	Replace MOVIMENTO With MOVIMENTO+(nSaldoCrd-nSaldoDeb)
    	
	If lMovPeriodo
		Replace MOVPERANT With MOVPERANT+nMovPerAnt
	EndIf
	If lComNivel
		aNivel := {}
		Aadd(aNivel, Recno())
	Endif
 
	If lImpSint
		dbSelectArea("CTS")
		dbSetOrder(2)
		// Grava contas sinteticas
		If !Empty(CTS->CTS_CTASUP)
			While !Eof() .And. 	CTS->CTS_FILIAL == cFilCTS .And. ;
									CTS->CTS_CODPLAN == cPlanGer
		
				cContaSup 	:= CTS->CTS_CTASUP
				
				dbSelectArea("CTS")
				dbSetOrder(2)
				If MsSeek(cFilCTS+cPlanGer+cContaSup)
					cDesc 	:= CTS->CTS_DESCCG
					cNormal := CTS->CTS_NORMAL
				Else
					cNormal	:= cCodNor	
				EndIf
   	
				dbSelectArea(cCTAlias)
				dbSetOrder(1)
				If !MsSeek(cContaSup)
					dbAppend() 
					If cAlias = 'CTU'	                     
						Do Case
						Case cIdent = 'CTT'
							Replace CUSTO 		With cContaSup			
							Replace DESCCC		With cDesc								
							Replace TIPOCC		With CTS->CTS_CLASSE
						Case cIdent	= 'CTD'
							Replace ITEM 		With cContaSup
							Replace DESCITEM	With cDesc          
							Replace TIPOITEM	With CTS->CTS_CLASSE
						Case cIdent = 'CTH'
							Replace CLVL 		With cContaSup
							Replace DESCCLVL	With cDesc          
						Replace TIPOCLVL	With CTS->CTS_CLASSE
						EndCase
					Else	
						Replace CONTA	With cContaSup
						Replace DESCCTA With cDesc		
					EndIf
					Replace SUPERIOR  	With CTS->CTS_CTASUP
					Replace TIPOCONTA	With CTS->CTS_CLASSE
					Replace NORMAL   	With CTS->CTS_NORMAL
					Replace ORDEM		With CTS->CTS_ORDEM
					Replace IDENTIFI	With CTS->CTS_IDENT
					Replace FILIAL		With xFilial( cCTAlias )

					If CTS->( FieldPos( "CTS_TOTVIS" ) ) > 0
						Replace TOTVIS 		With CTS->CTS_TOTVIS
					EndIf
			
					If CTS->( FieldPos( "CTS_VISENT" ) ) > 0
						Replace VISENT 		With CTS->CTS_VISENT
					EndIf
			
					If CTS->( FieldPos( "CTS_SLDENT" ) ) > 0
						Replace SLDENT 		With CTS->CTS_SLDENT
					EndIf
			
					If CTS->( FieldPos( "CTS_FATSLD" ) ) > 0
						Replace FATSLD 		With CTS->CTS_FATSLD
					EndIf

					If lColuna
						Replace COLUNA  With CTS->CTS_COLUNA
					Endif
					If lTRegCts
						CT1->(DbSeek(xFilial("CT1") + CTS->CTS_CT1INI))
						Replace DESCORIG 	With &("CT1->CT1_DESC" + cMoeda),;
								TIPOCONTA 	With CT1->CT1_CLASSE,;
								NORMAL    	With CT1->CT1_NORMAL
					Endif
					aAreaCTS:=CTS->(GetArea())
					While CTS->(!EOF()) .AND. cFilCTS+cPlanGer+cContaSup ==  xFilial("CTS")+CTS->CTS_CODPLAN +CTS->CTS_CONTAG
					
						If Left(CTS->CTS_FORMUL, 7) == "ROTINA="
							nFatorS := &(Subs(CTS->CTS_FORMUL, 8))
							Aadd(aFator,{Recno(),nFatorS," ",.F.,0,.F.})
					    ElseIf Left(CTS->CTS_FORMUL, 6) = "TEXTO="		// Adiciona texto a descricao
							Aadd(aFator,{Recno(),1,Alltrim(&(Subs(CTS->CTS_FORMUL, 7))),.F.,0,.F.})
					    ElseIf Left(CTS->CTS_FORMUL, 9) = "TEXTOVAR="		// Adiciona texto a descricao
							Aadd(aFator,{Recno(),1,Alltrim(&(Subs(CTS->CTS_FORMUL, 10))),.F.,0,.T. })
						ElseIf Left(CTS->CTS_FORMUL,6 ) == "SALDO="
							nFatorS := &(Subs(CTS->CTS_FORMUL, 7))
							Aadd(aFator,{Recno(),1," ",.T.,nFatorS,.F.})
						EndIf

						CTS->(Dbskip())
					EndDo							
					CTS->(RestArea(aAreaCTS))
				EndIf    
		
				Replace	SALDOANT With SALDOANT + nSaldoAnt			// Saldo Anterior
				Replace SALDOATU With SALDOATU + nSaldoAtu			// Saldo Atual
				
				Replace SALDOATUDB With SALDOATUDB + nSaldoAtuD		//Saldo Atual Devedor
				Replace SALDOATUCR With SALDOATUCR + nSaldoAtuC		//Saldo Atual Credor
				
				If nSaldoDeb < 0 //.And. cNormal == "1"
					Replace SALDOCRD	With SALDOCRD + nSaldoDeb
				ElseIf nSaldoDeb >= 0 //.And. cNormal == "1"
					Replace SALDODEB	With SALDODEB + nSaldoDeb
				EndIf
				If nSaldoCrd < 0 //.And. cNormal == "2"
					Replace SALDODEB	With SALDODEB + nSaldoCrd
				ElseIf nSaldoCrd >= 0 //.And. cNormal == "2"
					Replace SALDOCRD	With SALDOCRD + nSaldoCrd
				EndIf
   	
//				Replace MOVIMENTO With nSaldoCrd-nSaldoDeb
				Replace MOVIMENTO With SALDOCRD-SALDODEB
				
				If lSemestre		// Saldo por semestre
					Replace SALDOSEM With SALDOSEM + nSaldoSEM
				Endif
				If lPeriodo0		// Saldo periodo determinado
					Replace SALDOPER With SALDOPER + nSaldoPER
				Endif
   	
				If lMovPeriodo		// Movimento periodo anterior
					Replace MOVPERANT With MOVPERANT + nMovPerAnt					
				EndIf
  	            If lComNivel
					Aadd(aNivel, Recno())
				Endif
				
				dbSelectArea("CTS")
				If !Eof() .And. Empty(CTS->CTS_CTASUP)
					dbSelectArea(cCTAlias)
					Replace NIVEL1 With .T.
					dbSelectArea("CTS")
					Exit
				EndIf
			EndDo
		
			If lComNivel
				dbSelectArea(cCTAlias)
				nContador 	:= 1
				For nNivel 	:= Len(aNivel) To 1 Step -1
					DbGoto(aNivel[nNivel])
					Replace NIVEL With nContador ++
				Next		
			Endif
		
		EndIf
	Endif

	dbSelectArea("CTS")
	dbSetOrder(1)
	dbGoTo(nReg)
	dbSkip()

EndDo
dbSelectArea(cCTAlias)
If Len(aFator) >0
	For nA:=1 To Len(aFator)
		Dbgoto(aFator[Na][1])
		RecLock( cCTAlias, .f. )
		Replace	SALDOANT 	With SALDOANT * aFator[Na][2]
		Replace SALDOATU 	With SALDOATU * aFator[Na][2]
		Replace SALDOATUDB 	With SALDOATUDB * aFator[Na][2]
		Replace SALDOATUCR 	With SALDOATUCR * aFator[Na][2]
		Replace SALDOCRD	With SALDOCRD * aFator[Na][2]
		Replace SALDODEB	With SALDODEB * aFator[Na][2]
		Replace SALDOCRD	With SALDOCRD * aFator[Na][2]
		Replace MOVIMENTO 	With MOVIMENTO * aFator[Na][2]
		If lSemestre
			Replace SALDOSEM 	With SALDOSEM * aFator[Na][2]
	    EndIf
		If lPeriodo0
			Replace SALDOPER 	With SALDOPER * aFator[Na][2]
			Replace MOVPERANT 	With MOVPERANT * aFator[Na][2]				
        EndIf
        If aFator[Na][4]
	        Replace	SALDOANT 	With aFator[Na][5]
			Replace SALDOATU 	With aFator[Na][5]
			Replace SALDOATUDB 	With aFator[Na][5]
			Replace SALDOATUCR 	With aFator[Na][5]
			Replace SALDOCRD	With aFator[Na][5]
			Replace SALDODEB	With aFator[Na][5]
			Replace SALDOCRD	With aFator[Na][5]
			Replace MOVIMENTO 	With aFator[Na][5]
	        If lSemestre
				Replace SALDOSEM 	With aFator[Na][5]
		    EndIf
			If lPeriodo0
				Replace SALDOPER 	With aFator[Na][5]
				Replace MOVPERANT 	With aFator[Na][5]
	        EndIf
        EndIf
        
        If aFator[Na][6]
	        Replace DESCCTA With 	Alltrim(aFator[Na][3])
        Else
	        Replace DESCCTA With 	Alltrim(DESCCTA)+" "+Alltrim(aFator[Na][3])
	  	EndIf
        MsUnlock()      
	Next
EndIf		

RestArea(aSaveArea)

Return

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³SaldtotCT7 ³ Autor ³ Pilar S. Albaladejo 			   ³ Data ³ 27/11/00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Retorna os saldos do intervalo da conta ate a conta 			         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³SaldtotCT7(cContaIni,cContaFim,dData,cMoeda,cTpSald)		 			 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno	 ³nSaldoAtu,nDebito,nCredito,nAtuDeb,nAtuCrd,nSaldoAnt,nAntDeb,nAntCrd   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Generico 												 			 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 = Conta Inicial                    				 			 ³±±
±±³          ³ ExpC2 = Conta Final                      				 			 ³±±
±±³          ³ ExpD1 = Data                              			 				 ³±±
±±³          ³ ExpC3 = Moeda                            				 			 ³±±
±±³          ³ ExpC4 = Tipo de Saldo                       				 			 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function SaldTotCT7(cContaIni,cContaFim,dData,cMoeda,cTpSald,lImpAntLP,dDataLP,aSelFil,lRecDesp0,cRecDesp,dDtZeraRD,cArqCt7,lConsSaldo)
Local aSaveArea	:= CT7->(GetArea())
Local aSaveAnt	:= GetArea()
Local lNaoAchei	:= .F.
Local nDebito	:= 0					// Valor Debito na Data
Local nCredito 	:= 0					// Valor Credito na Data
Local nAtuDeb  	:= 0					// Saldo Atual Devedor
Local nAtuCrd	:= 0					// Saldo Atual Credor
Local nVlDebAtu := 0					// Valor do Debito Atual
Local nVlCrdAtu := 0                    // Valor do Credito Atual
Local nVlDebAnt := 0					// Valor do Debito Anterior
Local nVlCrdAnt := 0                    // Valor do Credito Anterior
Local nAntDeb	:= 0					// Saldo Anterior Devedor
Local nAntCrd	:= 0					// Saldo Anterior Credor
Local nSaldoAnt	:= 0					// Saldo Anterior (com sinal)
Local nSaldoAtu	:= 0					// Saldo Atual (com sinal)
Local cChave, cChaveTot, bCondicao
Local cConta	:= ""
Local cQuery	:= ""                    
Local nCont		:= 0 
Local nTamRecDes:= Len(Alltrim(cRecDesp))
Local aSldRecDes:= {}
Local nSldRDAtuD:=	0
Local nSldRDAtuC:=	0
Local nSldAtuRD	:= 0
Local cQryFil	:= ''
Local cTipoSaldo:= ""
Local lDefTop 		:= IfDefTopCTB() // verificar se pode executar query (TOPCONN)
Local cCT7TmpFil

DEFAULT cTpSald    := Iif(Empty(cTpSald),"1",cTpSald)
DEFAULT lConsSaldo := .F.
DEFAULT lImpAntLp  := .F.
DEFAULT dDataLp    := CTOD("  /  /  ")
DEFAULT lRecDesp0  := .F.
DEFAULT cRecDesp   := ""                
DEFAULT dDtZeraRD  := CTOD("  /  /  ")
DEFAULT cArqCt7    := Nil
DEFAULT aSelFil    := {}

cTipoSaldo := StrTran(StrTran(cTpSald,"','",""),";","")

If lRecDesp0 .And. ( Empty(cRecDesp) .Or. Empty(dDtZeraRD) )
	lRecDesp0 := .F.
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Tratativa para o filtro de filiais           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cQryFil := GetRngFil( aSelFil,"CT7", .T., @cCT7TmpFil)

If lDefTop

		IF cArqCt7 == nil
			cArqCt7 := RetSqlName("CT7")
		Endif
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Query do Saldo Anterior³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cQuery := " SELECT SUM(CT7_DEBITO) SLDANTDB, SUM(CT7_CREDIT) SLDANTCR "
		cQuery += " FROM " + cArqCt7
		cQuery += " WHERE CT7_FILIAL " + cQryFil 
		cQuery += " AND CT7_CONTA >= '"+cContaIni+"' "
		cQuery += " AND CT7_CONTA <= '"+cContaFim+"' "
		
		If !lImpAntLP .And. lRecDesp0
			For nCont	:= 1 to nTamRecDes
				If nCont == 1
					cQuery += "	 			AND ( (CT7_CONTA NOT LIKE '"+Substr(cRecDesp,nCont,1)+"%')"				
				Else
					cQuery += "	 			AND  (CT7_CONTA NOT LIKE '"+Substr(cRecDesp,nCont,1)+"%')"						
				EndIf
			Next	                                                                                
			cQuery += " OR "                                                                           	
			cQuery += " ( "
			For nCont	:= 1 to nTamRecDes
				If nTamRecDes == 1
					cQuery += " ( CT7_CONTA LIKE '"+Substr(cRecDesp,nCont,1)+"%')  AND "										
				Else	
					If nCont == 1
						cQuery += " ( CT7_CONTA LIKE '"+Substr(cRecDesp,nCont,1)+"%' OR "										
					ElseIf nCont < nTamRecDes
						cQuery += "  CT7_CONTA LIKE '"+Substr(cRecDesp,nCont,1)+"%' OR "						
					ElseIf nCont == nTamRecDes
						cQuery += " CT7_CONTA LIKE '"+Substr(cRecDesp,nCont,1)+"%') AND "										
					EndIf
				EndIf
			Next	                                                                        
			cQuery += " CT7_DATA > '" +DTOS(dDtZeraRD)+"') "        	
			cQuery += " ) "			
		EndIf						
		cQuery += " AND CT7_MOEDA = '"+cMoeda+"' "
		cQuery += " AND CT7_TPSALD IN ('"+cTpSald+"') "
		cQuery += " AND CT7_DATA < '"+DTOS(dData)+"' "
		If lImpAntLP
			cQuery += "  AND (CT7_LP <> 'Z' OR (CT7_LP = 'Z' AND CT7_DTLP <> ' ' AND CT7_DTLP <> '' AND CT7_DTLP < '"+DTOS(dDataLP)+"')) "
		Endif
		cQuery += " AND D_E_L_E_T_ <> '*' "

		cQuery := ChangeQuery(cQuery)				
		If Select("SLDTOTCT7") > 0
			dbSelectArea("SLDTOTCT7")
			SldTotCt7->(dbCloseArea())
		Endif
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"SLDTOTCT7",.T.,.F.)		

		TcSetField("SLDTOTCT7","SLDANTDB","N",TamSX3("CT7_CREDIT")[1],TamSX3("CT7_CREDIT")[1])	
		TcSetField("SLDTOTCT7","SLDANTCR","N",TamSX3("CT7_CREDIT")[1],TamSX3("CT7_CREDIT")[1])			        
		
		nAntDeb 	:= SLDTOTCT7->SLDANTDB
		nAntCrd 	:= SLDTOTCT7->SLDANTCR

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Query do Mov. no Dia   ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
		cQuery := "SELECT SUM(CT7_DEBITO) DEBITO, SUM(CT7_CREDIT) CREDIT  "
		cQuery += " FROM " + cArqCt7
		cQuery += " WHERE CT7_FILIAL " + cQryFil 
		cQuery += " AND CT7_CONTA >= '"+cContaIni+"' "
		cQuery += " AND CT7_CONTA <= '"+cContaFim+"' "
		cQuery += " AND CT7_MOEDA = '"+cMoeda+"' "
		cQuery += " AND CT7_TPSALD IN ('"+cTpSald+"') "
		cQuery += " AND CT7_DATA = '"+DTOS(dData)+"' "
		If lImpAntLP
			cQuery += "  AND (CT7_LP <> 'Z' OR (CT7_LP = 'Z' AND CT7_DTLP <> ' ' AND CT7_DTLP <> '' AND CT7_DTLP < '"+DTOS(dDataLP)+"')) "
		Endif
		cQuery += " AND D_E_L_E_T_ <> '*' "

		cQuery := ChangeQuery(cQuery)				
		If Select("SLDTOTCT7") > 0
			dbSelectArea("SLDTOTCT7")
			SldTotCt7->(dbCloseArea())
		Endif
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"SLDTOTCT7",.T.,.F.)		
		
		TcSetField("SLDTOTCT7","DEBITO"  ,"N",__aTamVlr[1],__aTamVlr[2])	
		TcSetField("SLDTOTCT7","CREDIT"  ,"N",__aTamVlr[1],__aTamVlr[2])			
		
		dbSelectArea("SLDTOTCT7")
		dbGoTop()
		// Movimentacao da data
		nDebito		:= SLDTOTCT7->DEBITO
		nCredito	:= SLDTOTCT7->CREDIT
	
		nAtuDeb := nAntDeb + nDebito
		nAtuCrd := nAntCrd + nCredito
			
		nSaldoAtu := nAtuCrd - nAtuDeb
		nSaldoAnt := nAntCrd - nAntDeb		
		If Select("SLDTOTCT7") > 0
			dbSelectArea("SLDTOTCT7")
			SldTotCt7->(dbCloseArea())
			CtbTmpErase(cCT7TmpFil)
		Endif

Else

	For nCont:=1 To Len(cTipoSaldo)
		cTpSald := SubStr(cTipoSaldo,nCont,1)
		
		dbSelectArea("CT7")
		dbSetOrder(1)
		MsSeek(xFilial("CT7")+cMoeda+cTpSald+cContaIni,.T.) // Posiciona na primeira conta

		// Processa todas as contas do intervalo
		While CT7->CT7_FILIAL == xFilial("CT7") 	  .And.;
			CT7->CT7_MOEDA  == cMoeda    .And.;
			CT7->CT7_TPSALD == cTpSald   .And.;
			CT7->CT7_CONTA  <= cContaFim .And. CT7->(!Eof()) 
			
			// Armazena a conta atual para ir para a proxima conta
			cChaveTot := CT7_FILIAL+CT7->CT7_MOEDA+CT7->CT7_TpSald+CT7->CT7_CONTA
			cChave    := CT7_FILIAL+CT7->CT7_CONTA+CT7->CT7_MOEDA+CT7->CT7_TpSald
			cConta	  := CT7_CONTA
		
			CT7->(DbSetOrder(2))
			
			// Dentro da mesma conta, pesquisa o primeiro saldo anterior ou igual
			// a data solicitada
		 	If CT7->(MsSeek(cChave+DTOS(dData),.T.))
				/// SE ENCONTROU REGISTRO DE SALDO NA DATA
				nAntDeb		+= CT7->CT7_ANTDEB
				nAntCrd		+= CT7->CT7_ANTCRD
				nVLDebAnt 	:= CT7->CT7_ANTDEB
				nVLCrdAnt  	:= CT7->CT7_ANTCRD						
				
				nDebito		+= CT7->CT7_DEBITO
				nCredito	+= CT7->CT7_CREDIT	
				
				/// VERIFICA SE HÁ REGISTRO DE APURACAO NA DATA
				lTeveAPLP	:= .F.
				nRecOri		:= CT7->(Recno())
				CT7->(dbSkip())
				If CT7->CT7_LP == "Z" .and. CT7->(CT7_FILIAL+CT7_CONTA+CT7_MOEDA+CT7_TpSald) == cChave .And. CT7->CT7_DATA  <= dData
					/// SE HOUVER REGISTRO DE APURACAO NA DATA SOMA A COLUNA DE MOVIMENTO
					nDebito		+= CT7->CT7_DEBITO
					nCredito	+= CT7->CT7_CREDIT
					/// CONSIDERA O SALDO ACUMULADO DO REGISTRO DE APURACAO
					nAtuDeb	  	+= CT7->CT7_ATUDEB
					nAtuCrd   	+= CT7->CT7_ATUCRD
					nVlDebAtu 	:= CT7->CT7_ATUDEB
					nVlCrdAtu 	:= CT7->CT7_ATUCRD
					lTeveAPLP := .T.
				EndIf
				CT7->(dbGoTo(nRecOri))
		
				If !lTeveAPLP
					/// SE NAO HA REGISTRO DE APURACAO NA DATA
					/// CONSIDERA O SALDO ACUMULADO DO REGISTRO NORMAL
					nAtuDeb	  	+= CT7->CT7_ATUDEB
					nAtuCrd   	+= CT7->CT7_ATUCRD
					nVlDebAtu 	:= CT7->CT7_ATUDEB
					nVlCrdAtu 	:= CT7->CT7_ATUCRD
				EndIf
	
				If lImpAntLP .and. dDataLP <= CT7->CT7_DATA
					// SE IMPRIME POSICAO ANTERIOR A LP E O SALDO FOR POSTERIOR À APURACAO INDICADA
					If CT7->CT7_LP == "Z"
						// SE O REGISTRO ATUAL É DE APURACAO (SÓ REGISTRO "Z" NA DATA)
						nDebito		-= CT7->CT7_DEBITO
						nCredito	-= CT7->CT7_CREDIT
		
						nAtuDeb		-= CT7->CT7_DEBITO
						nAtuCrd		-= CT7->CT7_CREDIT
						nVlDebAtu 	-= CT7->CT7_DEBITO
						nVlCrdAtu 	-= CT7->CT7_CREDIT
					Else
						// SE O REGISTRO ATUAL NAO É DE APURACAO (TEM REGISTRO DE LANCAMENTO NA DATA)
						CT7->(dbSkip())
						If CT7->CT7_LP == "Z" .and. CT7->(CT7_FILIAL+CT7_CONTA+CT7_MOEDA+CT7_TpSald) == cChave .And. CT7->CT7_DATA  <= dData
							// SE O PROXIMO REGISTRO FOR DE APURACAO E FOR DA MESMA CHAVE
							// ABATE OS VALORES DA APURACAO NO VALOR DO SALDO
				  			nDebito		-= CT7->CT7_DEBITO
							nCredito	-= CT7->CT7_CREDIT
		
							nAtuDeb		-= CT7_DEBITO
							nAtuCrd		-= CT7_CREDIT
							nVlDebAtu 	-= CT7_DEBITO
							nVlCrdAtu 	-= CT7_CREDIT
						EndIf
					EndIf
				EndIf
		
				nSaldoAtu	+= (nVlCrdAtu - nVlDebAtu)
				nSaldoAnt	+= (nVLCrdAnt - nVlDebAnt)
			Else
				/// SE NÃO ENCONTROU REGISTRO NA DATA
				CT7->(dbSkip(-1))
				/// VERIFICA O REGISTRO ANTERIOR
				If CT7->(CT7_FILIAL+CT7_CONTA+CT7_MOEDA+CT7_TpSald) == cChave .And. CT7->CT7_DATA <= dData
					nAntDeb		+= CT7->CT7_ATUDEB
					nAntCrd		+= CT7->CT7_ATUCRD
					nVLDebAnt	:= CT7->CT7_ATUDEB
					nVLCrdAnt	:= CT7->CT7_ATUCRD
					
					nAtuDeb		+= CT7->CT7_ATUDEB
					nAtuCrd		+= CT7->CT7_ATUCRD
					nVlDebAtu	:= CT7->CT7_ATUDEB
					nVlCrdAtu	:= CT7->CT7_ATUCRD
					
					If lImpAntLP .and. dDataLP <= CT7->CT7_DATA
						If CT7->CT7_LP == "Z" .and. CT7->CT7_DATA == dDataLP
							nAntDeb		-= CT7->CT7_ATUDEB
							nAntCrd		-= CT7->CT7_ATUCRD
							nAntDeb		+= CT7->CT7_ANTDEB
							nAntCrd		+= CT7->CT7_ANTCRD
							nVLDebAnt	:= CT7->CT7_ANTDEB
							nVLCrdAnt	:= CT7->CT7_ANTCRD
							
							nAtuDeb		-= CT7->CT7_ATUDEB
							nAtuCrd		-= CT7->CT7_ATUCRD
							nAtuDeb		+= CT7->CT7_ANTDEB
							nAtuCrd		+= CT7->CT7_ANTCRD
							nVlDebAtu	:= CT7->CT7_ANTDEB
							nVlCrdAtu	:= CT7->CT7_ANTCRD
						Else
							/// E FOR POSICAO ANTERIOR A LP
							bCondLP  	:= { || (CT7->CT7_FILIAL == xFilial() .And.;
							CT7->CT7_CONTA == cConta .And. CT7->CT7_MOEDA == cMoeda .And.;
							CT7->CT7_TPSALD == cTpSald .And. CT7->CT7_LP == "Z" .And.;
							dDataLp <= dData) }
							CT7->(dbSetOrder(5))
							CT7->(dbSeek(xFilial("CT7")+"Z"+cConta+cMoeda+cTpSald+DTOS(dDataLP),.T.))
							aSldLP		:= CtbSldLP("CT7",dDataLP,bCondLP,dData)
							nAtuDeb		-= aSldLP[1]
							nAtuCrd		-= aSldLP[2]
							nVLDebAnt  	-= aSldLP[1]
							nVLCrdAnt  	-= aSldLP[2]
		  	  	
							nAntDeb		-= aSldLP[1]
							nAntCrd		-= aSldLP[2]
							nVlDebAtu 	-= aSldLP[1]
							nVlCrdAtu 	-= aSldLP[2]
						EndIf
					EndIf
					
					nSaldoAtu	+= (nVlCrdAtu - nVlDebAtu)
					nSaldoAnt	+= (nVLCrdAnt - nVlDebAnt)
				EndIf
			EndIf
			
			CT7->(DbSetOrder(1))
			// Vai para a proxima conta
			CT7->(MsSeek(IncLast(cChaveTot),.T.))
			
		Enddo
		
	Next nCont

Endif

CT7->(RestArea(aSaveArea))
RestARea(aSaveAnt)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Retorno:                                             ³
//³ [1] Saldo Atual (com sinal)                          ³
//³ [2] Debito na Data                                   ³
//³ [3] Credito na Data                                  ³
//³ [4] Saldo Atual Devedor                              ³
//³ [5] Saldo Atual Credor                               ³
//³ [6] Saldo Anterior (com sinal)                       ³
//³ [7] Saldo Anterior Devedor                           ³
//³ [8] Saldo Anterior Credor                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//      [1]       [2]     [3]      [4]     [5]     [6]       [7]     [8]
Return {nSaldoAtu,nDebito,nCredito,nAtuDeb,nAtuCrd,nSaldoAnt,nAntDeb,nAntCrd}