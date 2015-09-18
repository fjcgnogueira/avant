#INCLUDE "FileIO.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "DBINFO.CH"

STATIC __cExt	:= GetDbExtension()
STATIC lBlind	:= IsBlind()
Static lFWCodFil := FindFunction("FWCodFil")

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ FINA370	³ Autor ³ Wagner Xavier 		³ Data ³ 24/08/94 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Programa de Lan‡amentos Cont beis Off-Line				  ³±±
±±³          ³ Programa alterado, porque o da Totvs estah com problema    ³±±
±±³          ³ Fernando Nogueira                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ FINA370()												  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso		 ³ Especifico Avant											  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function FinA370(lDireto)

Local lPanelFin := If (FindFunction("IsPanelFin"),IsPanelFin(),.F.)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Vari veis 											 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
LOCAL nOpca := 0
Local aSays:={}, aButtons:={}

Local cPerg			:= "FIN370"
Local cFunction:= "FINA370"
Local cTitle:= "Contabilizacao Off-Line"
Local bProcess:= {|oSelf|F370Process(oSelf)}
Local cDescription:= "Contabilizacao Financeiro"

DEFAULT lDireto		:= .F.
PRIVATE cCadastro 	:= "Contabilização Off Line"  //"Contabiliza‡„o Off Line"
PRIVATE LanceiCtb 	:= .F.


// Obs: este array aRotina foi inserido apenas para permitir o
// funcionamento das rotinas internas do advanced.
PRIVATE aRotina := MenuDef()
PRIVATE lCabecalho
PRIVATE VALOR     := 0
PRIVATE VALOR6		:= 0
PRIVATE VALOR7		:= 0

Private lGerouTxt		:= .F.
// Variaveis utilizadas na contabilizacao do modulo SigaFin
// declarada neste ponto, caso o acesso seja feito via SigaAdv

Debito  	:= ""
Credito 	:= ""
CustoD		:= ""
CustoC		:= ""
ItemD 		:= ""
ItemC 		:= ""
CLVLD		:= ""
CLVLC		:= ""

Conta		:= ""
Custo 		:= ""
Historico 	:= ""
ITEM		:= ""
CLVL		:= ""

Abatimento  := 0
REGVALOR    := 0
STRLCTPAD 	:= ""		//para contabilizar o historico do cheque
NUMCHEQUE 	:= ""		//para contabilizar o numero do cheque
ORIGCHEQ  	:= ""		//para contabilizar o Origem do cheque
cHist190La 	:= ""
Variacao	:= 0
dDataUser	:= MsDate()
CODFORCP  	:= ""	//para contabilizar o Codigo do Fornecedor da Compensacao
LOJFORCP 	:= ""	//para contabilizar a Loja do Fornecedor da Compensacao

AjustaSX1()

If IsBlind() .Or. lDireto
	BatchProcess( 	cCadastro, 	"FIN370" + Chr(13) + Chr(10) +;
	"FIN370", "FIN370",;
	{ || FA370Processa(.T.) }, { || .F. })
	Return .T.
Endif

If AdmGetRpo( "R1.1" )
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Utilizacao da funcao ProcLogIni para permitir a gravacao ³
	//³do log no CV8 quando do uso da classe tNewProcess que    ³
	//³grava o LOG no SXU (FNC 00000028259/2009)                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	ProcLogIni(aButtons)
	tNewProcess():New( cFunction, cTitle, bProcess, cDescription, cPerg )
Else
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Variaveis utilizadas para parametros						        ³
	//³ mv_par01 // Mostra Lan‡amentos Cont beis 					     ³
	//³ mv_par02 // Aglutina Lan‡amentos Cont beis					     ³
	//³ mv_par03 // Emissao / Data Base 							        ³
	//³ mv_par04 // Data Inicio										        ³
	//³ mv_par05 // Data Fim								         		  ³
	//³ mv_par06 // Carteira : Receber / Pagar /Cheque / Ambas 		  ³
	//³ mv_par07 // Baixas por Data de Emiss„o ou Digita‡„o			  ³
	//³ mv_par08 // Considera filiais abaixo                         ³
	//³ mv_par09 // Da Filial                                        ³
	//³ mv_par10 // Ate a Filial                                     ³
	//³ mv_par11 // Atualiza Sinteticas                              ³
	//³ mv_par12 // Separa por ? (Periodo,Documento,Processo)        ³
	//³ mv_par13 // Ctb Bordero - Total/Por Bordero                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	pergunte("FIN370",.F.)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Inicializa o log de processamento                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	ProcLogIni( aButtons )
	
	
	AADD(aSays,"  Este programa tem como objetivo gerar Lan‡amentos Cont beis Off para t¡tulos") //"  Este programa tem como objetivo gerar Lan‡amentos Cont beis Off para t¡tulos"
	AADD(aSays,"emitidos e/ou baixas efetuadas.") //"emitidos e/ou baixas efetuadas."
	
	If lPanelFin  //Chamado pelo Painel Financeiro			
		aButtonTxt := {}			
		If Len(aButtons) > 0
			AADD(aButtonTxt,{"Visualizar","Visualizar",aButtons[1][3]}) // Visualizar			
		Endif
		AADD(aButtonTxt,{"Parametros","Parametros", {||Pergunte("FIN370",.T. )}}) // Parametros						
		FaMyFormBatch(aSays,aButtonTxt,{||nOpca :=1},{||nOpca:=0})	
	Else    
		AADD(aButtons, { 5,.T.,{|| Pergunte("FIN370",.T. ) } } )
		AADD(aButtons, { 1,.T.,{|o| nOpca:= 1,o:oWnd:End()}} )
		AADD(aButtons, { 2,.T.,{|o| o:oWnd:End() }} )
		FormBatch( cCadastro, aSays, aButtons )
	Endif
			
	If nOpcA == 1
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Atualiza o log de processamento   ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		ProcLogAtu("INICIO")
                            
		If mv_par08 == 1
			If A370CanProc(mv_par06, mv_par04, mv_par05,mv_par09,mv_par10)
				Processa({|lEnd| FA370Processa()})  // Chamada da funcao de Contabilizacao Off-Line
			EndIf
		Else
			If A370CanProc(mv_par06, mv_par04, mv_par05)
				Processa({|lEnd| FA370Processa()})  // Chamada da funcao de Contabilizacao Off-Line
			EndIf	
		EndIf
	
		A370FreeProc()
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Atualiza o log de processamento   ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		ProcLogAtu("FIM")
	
	Endif
EndIf	

Return
	
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³FA370Proc ³ Autor ³ Wagner Xavier 		  ³ Data ³ 24/08/94 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Programa de Lan‡amentos Cont beis Off-Line					  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ FINA370()																  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso		 ³ SIGAFIN																	  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function FA370Processa(lBat,oSelf)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Vari veis 														  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
LOCAL lPadrao,lAglut
LOCAL nTotal  :=0
LOCAL nHdlPrv :=0
LOCAL cArquivo:= ""
LOCAL cPadrao
LOCAL nValLiq	:=0
LOCAL nDescont	:=0
LOCAL nJuros	:=0
LOCAL nMulta	:=0
LOCAL nCorrec	:=0
LOCAL nVl
LOCAL nDc
LOCAL nJr
LOCAL nMt
LOCAL nCm
LOCAL lTitulo := .F.
LOCAL dDataAnt:= dDataBase
LOCAL dDataini:= dDataBase
LOCAL nPeriodo:= 0
LOCAL nLaco   := 0
LOCAL cIndex, cIndSE2
LOCAL cChave
LOCAL cFor
LOCAL nIndex, nIndSE2
LOCAL nReg
LOCAL nRegSE5 := 0
LOCAL nRegOrigSE5 := 0
LOCAL lX := .f.
LOCAL lAdiant := .F.
LOCAL nProxReg := 0
LOCAL nRegEmp  := SM0->(Recno())
LOCAL lLerSE1  := .T.
LOCAL lLerSEL  := .T.
LOCAL lLerSE2  := .T.
LOCAL lLerSE5  := .T.
LOCAL lLerSEF  := .T.
LOCAL lLerSEU  := .T.
LOCAL lEstorno := .F.
LOCAL lEstRaNcc := .F.
LOCAL lEstPaNdf := .F.
LOCAL lEstCart2 := .F.
LOCAL cCtBaixa := Getmv("MV_CTBAIXA")
LOCAL nLacoTrf := 0
LOCAL aTrf	:= {}
LOCAL nValorTotal := 0
LOCAL l370E5R := Existblock("F370E5R")
LOCAL l370E5P := Existblock("F370E5P")
LOCAL l370E5T := Existblock("F370E5T")
LOCAL l370E1FIL := Existblock("F370E1F")   // Criado Ponto de Entrada
LOCAL l370E2FIL := Existblock("F370E2F")   // Criado Ponto de Entrada
LOCAL l370E5FIL := Existblock("F370E5F")   // Criado Ponto de Entrada
LOCAL l370EFFIL := Existblock("F370EFF")   // Criado Ponto de Entrada
LOCAL l370EUFIL := Existblock("F370EUF")   // Criado Ponto de Entrada
LOCAL lF370NATP := Existblock("F370NATP")   // Criado Ponto de Entrada
LOCAL lF370E1WH := Existblock("F370E1W")   // Criado Ponto de Entrada para o While do SE1
LOCAL l370E5KEY := Existblock("F370E5K")   // Criado Ponto de Entrada
LOCAL l370EFKEY := Existblock("F370EFK")   // Criado Ponto de Entrada
Local l370E5CON := Existblock("F370E5CT")	 // Ponto de entrada para filtro do SE5 na contabilização
Local cCondWhile:= " "
LOCAL nRegAnt
Local bCampo, nOrderSEU
Local cChaveSev
Local cChaveSeZ
Local nRecSe1
Local nRecSe2
Local cNumBor, cProxBor, nBordero, nTotBord, nBordDc, nBordJr, nBordMt, nBordCm
Local nTotDoc 	:= 0
Local nTotProc 	:= 0
LOCAL lPadraoCC
LOCAL lSkipLct := .F.
LOCAL cSitOri := " "
lOCAL cSitCob := " "
Local cSeqSE5 := ""
Local lPadraoCCE
Local cPadraoCC
Local lMultNat := .F.
Local nTamTot
Local nRecSev
Local nRecSez
Local cCarteira := GetMV("MV_CARTEIR")
Local aFlagCTB := {}
Local lUsaFlag := GetNewPar("MV_CTBFLAG",.F.)
Local lPCCBaixa := SuperGetMv("MV_BX10925",.T.,"2") == "1"  .and. (!Empty( SE5->( FieldPos( "E5_VRETPIS" ) ) ) .And. !Empty( SE5->( FieldPos( "E5_VRETCOF" ) ) ) .And. ;
				 !Empty( SE5->( FieldPos( "E5_VRETCSL" ) ) ) .And. !Empty( SE5->( FieldPos( "E5_PRETPIS" ) ) ) .And. ;
				 !Empty( SE5->( FieldPos( "E5_PRETCOF" ) ) ) .And. !Empty( SE5->( FieldPos( "E5_PRETCSL" ) ) ) .And. ;
				 !Empty( SE2->( FieldPos( "E2_SEQBX"   ) ) ) .And. !Empty( SFQ->( FieldPos( "FQ_SEQDES"  ) ) ) )

Local nPis		:= 0
Local	nCofins	:= 0
Local nCsll		:= 0
Local nVretPis := 0
Local nVretCof := 0
Local nVretCsl := 0
Local aRecsSE5 := {}
Local aRecsSEI	:= {}
Local nX := 0

Local lCtbPls := .F.
Local lCtPlsICR := SE1->(FieldPos("E1_ANOBASE")) > 0 .And. ;  
                   FindFunction("PLSCTBSE1")          .And. ;
                   PlsLp("ICR")
Local lCtPlsICP := SE2->(FieldPos("E2_CODRDA")) > 0 .And. ;
                   FindFunction("PLSCTBSE2")          .And. ;
                   PlsLp("ICP")
Local lCtPlsBCR := SE1->(FieldPos("E1_ANOBASE")) > 0 .And. ;
                   FindFunction("PLSCTBSE1")          .And. ;
                   PlsLp("BCR")
Local lCtPlsCBCR := SE1->(FieldPos("E1_ANOBASE")) > 0 .And. ;
                   FindFunction("PLSCTBSE1")          .And. ;
                   PlsLp("CBCR")
Local lCtPlsBCP := SE2->(FieldPos("E2_CODRDA")) > 0 .And. ;
                   FindFunction("PLSCTBSE2")          .And. ;
                   PlsLp("BCP")
Local lCtPlsCBCP := SE2->(FieldPos("E2_CODRDA")) > 0 .And. ;
                   FindFunction("PLSCTBSE2")          .And. ;
                   PlsLp("CBCP")
Local cTipoLP                   
Local aRegBFQ

Local lMulNatSE2 := .F.
Local cProxChq	:= ""
Local cChequeAtual := ""
Local lEstCompens := .F.
Local lAchouSE5:=.F.
Local cFilialPesq
Local cSELSerie		:= ""
Local cSELRecibo	:= ""

Local lFindITF := FindFunction("FinProcITF")
//Variaveis para gravação do código de correlativo
Local aDiario	:= {}
Local lSeqCorr	:= FindFunction( "UsaSeqCor" ) .And. UsaSeqCor("SE1/SE2/SE5/SEH/SEK/SEL/SET/SEU")

Local nz		:= 0
Local cAliasEF	:= "TRBSEF"
Local lArqSEF	:= .F.
Local aLstSEF	:= {}  
Local aStru		:= SEF->(dbStruct())
Local cEF_T01	:= aStru[SEF->(FieldPos("EF_DATA")),2]
Local bCond		:= Nil
Local cQuery	:= ""
Local cIndSEF	:= ""  
Local nPosReg  := 0
Local cPathLog := GetMv("MV_DIRDOC")
Local cLogArq 	:= "Fina370Log.TXT"
Local cCaminho := cPathLog + cLogArq
Local cTRCondWhile := " "
Local cFiltro:= ""
Local	cCodNat := Upper("Sangria"+"|"+"Troco")
Local lBrasil := cPaisLoc == "BRA"
Local nMove	:= 1   

DEFAULT lBat	:= .F.

Private cCampo
Private Inclui := .T.
Private cLote	:= Space( 4)
Private nSaveSx8Len := GetSx8Len()
Private cSeqCv4		:= ""

If Funname() == "FINA370" .And. AdmGetRpo("R1.1")
	oSelf:Savelog("INICIO")
EndIf	

// Garantir que a pergunta "Contab.Tit.Provisor ?" receba conteudo se as perguntas mv_par14, mv_par15 e mv_par16 
// criadas pela rotina CTBAFIN nao existem no dicionario.
cPerg   := PadR("FIN370",Len(SX1->X1_GRUPO))
nRecSX1 := SX1->(Recno())                                
If !SX1->(MsSeek(cPerg+"14")) .And. SX1->(MsSeek(cPerg+"17"))
	mv_par17 := mv_par14
EndIf	
SX1->(DbGoTo(nRecSX1))

cSeqCv4 := GetSx8Num("CV4", "CV4_SEQUEN")

If ! CtbInUse() .And.;
	(!(mv_par04 >= GetMv("MV_DATADE") .And. mv_par04 <= GetMv("MV_DATAATE")) .Or.;
	!(mv_par05 >= GetMv("MV_DATADE") .And. mv_par05 <= GetMv("MV_DATAATE")))
	HELP(" ",1,"DATACOMPET")

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Atualiza o log de processamento com o erro  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If Funname() == "FINA370" .And. AdmGetRpo("R1.1")
		oSelf:Savelog("ERRO","DATACOMPET",Ap5GetHelp("DATACOMPET"))
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Utilizacao da funcao ProcLogAtu para permitir a gravacao ³
		//³do log no CV8 quando do uso da classe tNewProcess que    ³
		//³grava o LOG no SXU (FNC 00000028259/2009)                ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		ProcLogAtu("ERRO","DATACOMPET",Ap5GetHelp("DATACOMPET"))			
	ELse	
		ProcLogAtu("ERRO","DATACOMPET",Ap5GetHelp("DATACOMPET"))
	EndIf	

	Return .F.
Endif


cFilDe := cFilAnt
cFilAte:= cFilAnt
//Para usuarios do SigaCon
If !CtbInUse()
	lUsaFlag := .F.
Endif

If mv_par08 == 1
	cFilDe := mv_par09
	cFilAte:= mv_par10
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros								  ³
//³ mv_par01 // Mostra Lan‡amentos Cont beis 						  ³
//³ mv_par02 // Aglutina Lan‡amentos Cont beis						  ³
//³ mv_par03 // Emissao / Data Base 									  ³
//³ mv_par04 // Data Inicio												  ³
//³ mv_par05 // Data Fim													  ³
//³ mv_par06 // Carteira : Receber / Pagar /Cheque / Ambas 		  ³
//³ mv_par07 // Baixas por Data de Emiss„o ou Digita‡„o			  ³
//³ mv_par07 // Baixas por Data de Emiss„o ou Digita‡„o			  ³
//³ mv_par08 // Considera filiais abaixo                         ³
//³ mv_par09 // Da Filial                                        ³
//³ mv_par10 // Ate a Filial                                     ³
//³ mv_par11 // Atualiza Sinteticas                              ³
//³ mv_par12 // Separa por ? (Periodo,Documento,Processo)        ³
//³ mv_par13 // Ctb Bordero - Total/Por Bordero                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ    

dbSelectArea("SM0")
dbSeek(cEmpAnt+cFilDe,.T.)

While !Eof() .and. M0_CODIGO == cEmpAnt .and. IIf( lFWCodFil, FWGETCODFILIAL, SM0->M0_CODFIL ) <= cFilAte
	cFilAnt := IIf( lFWCodFil, FWGETCODFILIAL, SM0->M0_CODFIL )		// Mudar filial atual temporariamente

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Chama a SumAbatRec para abrir alias auxiliar __SE1 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If Select("__SE1") == 0
		SumAbatRec("","","",1,"")
	Endif	
	
	If lLerSe5
		If Select("__SE5") == 0
			ChkFile("SE5",.F.,"__SE5")
		Else
			dbSelectArea("__SE5")
		Endif

		dbSelectArea("SE5")
		cIndex := CriaTrab(,.f.)
		aRecsSE5 := {}
		IF  mv_par07 == 1
			cChave := "E5_FILIAL+E5_RECPAG+Dtos(E5_DATA )+E5_NUMCHEQ+E5_DOCUMEN+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA+E5_SEQ"
				cFor := 'dtos(E5_DATA) >= "'+dtos(mv_par04)+'" .and. dtos(E5_DATA) <= "'+dtos(mv_par05)+'" .and. '
				cFor += '(E5_LA < "S " .or. (!empty(E5_ORDREC + E5_SERREC) .and. E5_RECPAG == "R" .and. E5_TIPODOC == "BA"))'  // Filtra registros de Recebimentos Diversos p/Contabilizacao
				cFor += ' .and. (E5_SITUACA <> "C") .and. E5_TIPODOC $ "PA/RA/BA/VL/V2/DC/D2/JR/J2/MT/M2/CM/C2/AP/EP/PE/RF/IF/CP/TL/ES/TR/DB/OD/LJ/E2/TE/PE  "'				
		ElseIf mv_par07 == 2
			cChave := "E5_FILIAL+E5_RECPAG+Dtos(E5_DTDIGIT )+E5_NUMCHEQ+E5_DOCUMEN+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA+E5_SEQ"
				cFor := 'dtos(E5_DTDIGIT) >= "'+dtos(mv_par04)+'" .and. dtos(E5_DTDIGIT) <= "'+dtos(mv_par05)+'" .and. '
				cFor += '(E5_LA < "S " .or. (!empty(E5_ORDREC + E5_SERREC) .and. E5_RECPAG == "R" .and. E5_TIPODOC == "BA"))'  // Filtra registros de Recebimentos Diversos p/Contabilizacao
				cFor += ' .and. (E5_SITUACA <> "C") .and. E5_TIPODOC $ "PA/RA/BA/VL/V2/DC/D2/JR/J2/MT/M2/CM/C2/AP/EP/PE/RF/IF/CP/TL/ES/TR/DB/OD/LJ/E2/TE/PE  "'
		Else
			cChave := "E5_FILIAL+E5_RECPAG+Dtos(E5_DTDISPO)+E5_NUMCHEQ+E5_DOCUMEN+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA+E5_SEQ"
				cFor := 'dtos(E5_DTDISPO) >= "'+dtos(mv_par04)+'" .and. dtos(E5_DTDISPO) <= "'+dtos(mv_par05)+'" .and. '
				cFor += '(E5_LA < "S " .or. (!empty(E5_ORDREC + E5_SERREC) .and. E5_RECPAG == "R" .and. E5_TIPODOC == "BA"))'  // Filtra registros de Recebimentos Diversos p/Contabilizacao
				cFor += ' .and. (E5_SITUACA <> "C") .and. E5_TIPODOC $ "PA/RA/BA/VL/V2/DC/D2/JR/J2/MT/M2/CM/C2/AP/EP/PE/RF/IF/CP/TL/ES/TR/DB/OD/LJ/E2/TE/PE  "'
		Endif
		
		If mv_par14 == 1 .and. !Empty( SE5->( FieldPos( "E5_MSFIL"   ) ) )
			cFor += ' .and. E5_MSFIL >= "'+ mv_par15 +'"'
			cFor += ' .and. E5_MSFIL <= "'+ mv_par16 +'"'
		Else
			cFor += ' .and. E5_FILIAL == "'+xFilial("SE5")+'"'
		EndIf		
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Ponto de Entrada para filtrar registros do SE5. ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If l370E5FIL
			cFor := Execblock("F370E5F",.F.,.F.,cFor)
		EndIf
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Ponto de Entrada para alterar ordenacao do SE5  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If l370E5KEY
			cChave := Execblock("F370E5K",.F.,.F.,cChave)
		EndIf
		cFiltro := cChave

		dbSelectArea("SE5")
		IndRegua("SE5",cIndex,cChave,,cFor,"Selecionando Registros...")  //"Selecionando Registros..."
		nIndex := RetIndex("SE5")
		#IFNDEF TOP
			dbSetIndex(cIndex+OrdBagExt())
		#ENDIF
		dbSetOrder(nIndex+1)
		dbGoTop()
	Endif
		
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Contabiliza pelo E2_EMIS1 - CONTAS PAGAR   			  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If (mv_par06 = 2 .Or. mv_par06 = 4) .and. lLerSe2
		cIndSE2 := CriaTrab(,.f.)
		dbSelectArea("SE2")
		cChave := "E2_FILIAL+DTOS(E2_EMIS1)+E2_NUMBOR+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA"
		cFor := 'dtos(E2_EMIS1) >= "'+dtos(mv_par04)+'" .and. dtos(E2_EMIS1) <= "'+dtos(mv_par05)+'" .and. '
		cFor += 'E2_LA <> "S"'
		
		If mv_par14 == 1 .and. !Empty( SE2->( FieldPos( "E2_MSFIL"   ) ) )
			cFor += ' .and. E2_MSFIL >= "'+ mv_par15 +'"'
			cFor += ' .and. E2_MSFIL <= "'+ mv_par16 +'"'
		Else
			cFor += ' .and. E2_FILIAL == "'+xFilial("SE2")+'"'
		EndIf		
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Ponto de Entrada para filtrar registros do SE2. ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If l370E2FIL
			cFor := Execblock("F370E2F",.F.,.F.,cFor)
		EndIf
		
		dbSelectArea("SE2")
		#IFDEF TOP
			ChkFile("SE2",.f.,"TRBSE2")
			IndRegua("TRBSE2",cIndSE2,cChave,,cFor,"Selecionando Registros...")
			nIndSE2 := -1
			dbSelectArea("TRBSE2")
		#ELSE
			IndRegua("SE2",cIndSE2,cChave,,cFor,"Selecionando Registros...")
			nIndSE2 := RetIndex("SE2")
			dbSelectArea("SE2")
			dbSetIndex(cIndSE2+OrdBagExt())
		#ENDIF
		dbSetOrder(nIndSE2+1)
		dbSeek(xFilial("SE2"))
	Endif
	
	If (mv_par06 = 3 .Or. mv_par06 = 4 ) .and. lLerSef
		//--Arquivo de Cheque SEF
		#IFDEF TOP
			dbSelectArea("SEF")
			cChave := "EF_FILIAL+EF_BANCO+EF_AGENCIA+DTOS(EF_DATA)"
			cQuery := ""
			aEval(DbStruct(),{|e| cQuery += ","+AllTrim(e[1])})
			// Obtem os registros a serem processados
			cQuery := "SELECT " + SubStr(cQuery,2)
			cQuery += ",SEF.R_E_C_N_O_ SEFRECNO "
			cQuery += "FROM " + RetSqlName("SEF") + " SEF "
		
			If mv_par14 == 1 .and. !Empty( SEF->( FieldPos( "EF_MSFIL"   ) ) )
				cQuery += "WHERE EF_MSFIL BETWEEN '" + mv_par15 + "' AND '" + mv_par16 + "' AND "
			Else
				cQuery += "WHERE EF_FILIAL = '" + xFilial("SEF") + "' AND "
			EndIf		
		
			cQuery += "EF_DATA BETWEEN '" + DTOS(mv_par04) + "' AND '" + DTOS(mv_par05) + "' AND "
			cQuery += "EF_LA <> 'S ' AND "
			cQuery += "D_E_L_E_T_ = ' ' "

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Ponto de Entrada para filtrar registros do SE2. ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If l370EFFIL
				cQuery += Execblock("F370EFF",.F.,.F.,cQuery)
			EndIf
                     
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Ponto de Entrada para alterar ordenacao do SEF  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If l370EFKEY
				cChave := Execblock("F370EFK",.F.,.F.,cChave)
			EndIf

			// seta a ordem de acordo com a opcao do usuario
			cQuery += "ORDER BY " + SqlOrder(cChave)
			cQuery := ChangeQuery(cQuery)
			dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cAliasEF, .F., .T.)
			For nz := 1 TO LEN(aStru)
				If aStru[nz][2] != "C"
					TCSetField(cAliasEF, aStru[nz][1], aStru[nz][2], aStru[nz][3], aStru[nz][4])
				EndIf
			Next
			DbGoTop()
		#ELSE
			cIndSEF := CriaTrab(,.f.)
			cChave := "EF_FILIAL+EF_BANCO+EF_AGENCIA+DTOS(EF_DATA)"

			cFor := 'dtos(EF_DATA) >= "'+dtos(mv_par04)+'" .and. dtos(EF_DATA) <= "'+dtos(mv_par05)+'" .and. '
			cFor += 'EF_LA <> "S"'

			If mv_par14 == 1 .and. !Empty( SEF->( FieldPos( "EF_MSFIL"   ) ) )
				cFor += ' .and. EF_MSFIL >= "'+ mv_par15 +'"'
				cFor += ' .and. EF_MSFIL <= "'+ mv_par16 +'"'
			Else
				cFor += ' .and. EF_FILIAL == "'+xFilial("SEF")+'"'
			EndIf		
		
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Ponto de Entrada para filtrar registros do SEF. ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If l370EFFIL
				cFor := Execblock("F370EFF",.F.,.F.,cFor)
			EndIf
		             
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Ponto de Entrada para alterar ordenacao do SEF  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If l370EFKEY
				cChave := Execblock("F370EFK",.F.,.F.,cChave)
			EndIf
		
			dbSelectArea("SEF")
			IndRegua("SEF",cIndSEF,cChave,,cFor,"Selecionando Registros...")  //"Selecionando Registros..."
			nIndSEF := RetIndex("SEF")
			dbSetIndex(cIndSEF+OrdBagExt())
			dbSetOrder(nIndSEF+1)
			dbGoTop()
		#ENDIF
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ La‡o da contabiliza‡„o dia a dia, pela emiss„o (mv_par03 = 1)³
	//³ ou pela database.														  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If mv_par03 == 1
		nPeriodo := mv_par05 - mv_par04 + 1 // Data Final - Data inicial
		nPeriodo := Iif( nPeriodo == 0, 1, nPeriodo )
	Else
		nPeriodo := 1
	Endif
	
	dDataIni := mv_par04

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Carrego a tabela BFQ (Lancamentos do Faturamento) que sera ³
	//³ utilizada pela funcao "PlsCtbSe1".                         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If  GetNewPar("MV_PLSATIV", .F.)
	    aRegBFQ := {}	
		BFQ->(DbSetOrder(1))
		BFQ->(DbGoTop())
		Do While ! BFQ->(Eof())
		   aAdd(aRegBFQ, { BFQ->BFQ_FILIAL, BFQ->BFQ_CODINT, BFQ->BFQ_PROPRI, BFQ->BFQ_CODLAN, BFQ->BFQ_CONTAB })
		   BFQ->(DbSkip())
		EndDo
	EndIf

	BEGIN SEQUENCE
	
	If ! lBat
		If Funname() == "FINA370" .And. AdmGetRpo("R1.1")
			oSelf:SetRegua1(nPeriodo)
		Else	
			ProcRegua(nPeriodo)
		EndIf	
	Endif
	For nLaco := 1 to nPeriodo
		
		If ! lBat
			If Funname() == "FINA370" .And. AdmGetRpo("R1.1")
				oSelf:IncRegua1()
			Else
				IncProc()
			EndIf	
		Endif
		dbSelectArea( "SE1" )
		
		nTotal:=0
		nHdlPrv:=0
		lCabecalho:=.F.
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Se a contabiliza‡„o for pela data de emiss„o, altera o valor ³
		//³ da data-base e dos parƒmetros, para efetuar a contabiliza‡„o ³
		//³ e a sele‡„o dos registros respectivamente.						  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If mv_par03 == 1
			dDataBase := dDataIni + nLaco - 1
			mv_par04 := dDataBase
			mv_par05 := dDataBase
		Endif
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica o N£mero do Lote 											  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		LoteCont("FIN")
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica se ‚ um EXECBLOCK e caso sendo, executa-o							³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If At(UPPER("EXEC"),X5Descri()) > 0
			cLote := &(X5Descri())
		Endif
		
		If (mv_par06 == 1 .or. mv_par06 == 4) .and. lLerSe1
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Contas a Receber - SE1990 										     ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			dbSelectArea( "SE1" )
			dbSetOrder( 6 )
			cFilial := xFilial("SE1")
			If mv_par14 == 1 .and. !Empty( SE1->( FieldPos( "E1_MSFIL"   ) ) )
				DbGotop()
			Else
				dbSeek( cFilial+Dtos(mv_par04),.T. )
			EndIf
			
			If lF370E1WH
				cCondWhile:= Execblock("F370E1W",.F.,.F.)
			Else
				If mv_par14 == 1 .and. !Empty( SE1->( FieldPos( "E1_MSFIL"   ) ) )
					cCondWhile:= ".T."
					cFor := 'E1_MSFIL >= mv_par15 .and. E1_MSFIL <= mv_par16 .And. ( SE1->E1_EMISSAO >= mv_par04	.And. SE1->E1_EMISSAO <= mv_par05 )'
				Else
					cCondWhile:= "'"+cFilial+"' == SE1->E1_FILIAL .And. ( SE1->E1_EMISSAO >= mv_par04	.And. SE1->E1_EMISSAO <= mv_par05 )"
					cFor := ".T."
				EndIf
			EndIf
			
			While !Eof() .And. &cCondWhile
				
				If !(&cFor)
					dbSkip()
					Loop				
				EndIf
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Ponto de Entrada para filtrar registros do SE1. ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If l370E1FIL
					If !Execblock("F370E1F",.F.,.F.)
						dbSkip()
						Loop
					EndIf
				EndIf
				
				cPadrao := "500"
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Verifica se ser  gerado Lan‡amento Cont bil			  ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If SE1->E1_LA == "S" .Or. (SE1->E1_TIPO $ MVPROVIS .And. mv_par17 <> 1)
					SE1->( dbSkip())
					Loop
				Endif
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Posiciona no cliente.										  ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				dbSelectArea( "SA1" )
				dbSeek( xFilial("SA1")+SE1->E1_CLIENTE+SE1->E1_LOJA )
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Posiciona na natureza.										  ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				dbSelectArea( "SED" )
				dbSeek( cFilial+SE1->E1_NATUREZ )
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Posiciona na SE5,se RA										  ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If SE1->E1_TIPO $ MVRECANT
					dbSelectArea("SE5")
					dbSetOrder(2)
					dbSeek( xFilial()+"RA"+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+SE1->E1_TIPO+DtoS(SE1->E1_EMISSAO)+SE1->E1_CLIENTE+SE1->E1_LOJA)
					dbSetOrder(1)
				Endif
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Posiciona no banco.											  ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				dbSelectArea( "SA6" )
				dbSetOrder(1)
				dbSeek( cFilial+SE1->E1_PORTADO+SE1->E1_AGEDEP+SE1->E1_CONTA )
				// Se for um recebimento antecipado e nao encontrou o banco
				// pelo SE1, pesquisa pelo SE5.
				IF SE1->E1_TIPO $ MVRECANT
					If SA6->(Eof())
						dbSeek( cFilial+SE5->E5_BANCO+SE5->E5_AGENCIA+SE5->E5_CONTA )
					Endif
					cPadrao:="501"
				Endif
				
				dbSelectArea("SE1")
				
				lPadrao:=VerPadrao(cPadrao)
    			lCtbPls:=lCtPlsICR .and. substr(SE1->E1_ORIGEM,1,3) == "PLS"
				lPadraoCc := VerPadrao("506") //Rateio por C.Custo de MultiNat C.Receber
				IF lPadrao .or. lCtbPls
					If !lCabecalho
						a370Cabecalho(@nHdlPrv,@cArquivo)
					Endif
					cChaveSev := RetChaveSev("SE1")
					cChaveSez := RetChaveSev("SE1",,"SEZ")
					dbSelectArea("SE1")
					nRecSe1 := Recno()
					DbSelectArea("SEV")
					// Se utiliza multiplas naturezas, contabiliza pelo SEV
					If ! lCtbPls .And. SE1->E1_MULTNAT=="1" .And. MsSeek(cChaveSev)

						dbSelectArea("SE1")
						nRecSe1 := Recno()
						DbGoBottom()
						DbSkip()
						DbSelectArea("SEV")
						dbSetOrder(2)
						While xFilial("SEV")+SEV->(EV_PREFIXO+EV_NUM+EV_PARCELA+EV_TIPO+EV_CLIFOR+;
							EV_LOJA+EV_IDENT) == cChaveSev+"1" .And. !Eof()

							If SEV->EV_LA != "S"
								dbSelectArea( "SED" )
								MsSeek( xFilial("SED")+SEV->EV_NATUREZ ) // Posiciona na natureza, pois a conta pode estar la.
								dbSelectArea("SEV")
								
								If SEV->EV_RATEICC == "1" .and. lPadraoCC .and. lPadrao// Rateou multinat por c.custo
									dbSelectArea("SEZ")
									dbSetOrder(4)
									MsSeek(cChaveSeZ+SEV->EV_NATUREZ) // Posiciona no arquivo de Rateio C.Custo da MultiNat
								
									While !Eof() .and. xFilial("SEZ")+SEZ->(EZ_PREFIXO+EZ_NUM+;
										EZ_PARCELA+EZ_TIPO+EZ_CLIFOR+EZ_LOJA+EZ_NATUREZ+EZ_IDENT) == cChaveSeZ+SEV->EV_NATUREZ+"1"
										
										If SEZ->EZ_LA != "S"

											If lUsaFlag
												aAdd(aFlagCTB,{"EZ_LA","S","SEZ",SEZ->(Recno()),0,0,0})
											EndIf

											nTotDoc	+=	DetProva(nHdlPrv,"506","FINA370",cLote,,,,,,,,@aFlagCTB)

											If LanceiCtb // Vem do DetProva																								
												If !lUsaFlag
													RecLock("SEZ")
													SEZ->EZ_LA    := "S"
													MsUnlock( )
												EndIf 
											ElseIf lUsaFlag
												If (nPosReg  := aScan(aFlagCTB,{ |x| x[4] == SEZ->(Recno()) }))>0
													aFlagCTB := Adel(aFlagCTB,nPosReg)
													aFlagCTB := aSize(aFlagCTB,Len(aFlagCTB)-1)
												Endif
											EndIf												
										Endif
										dbSkip()
									Enddo
									DbSelectArea("SEV")
								Else
									If lUsaFlag
										aAdd(aFlagCTB,{"EV_LA","S","SEV",SEV->(Recno()),0,0,0})
									EndIf
									nTotDoc	:= DetProva(nHdlPrv,cPadrao,"FINA370",cLote,,,,,,,,@aFlagCTB)
								Endif
								
								If LanceiCtb // Vem do DetProva
									If !lUsaFlag	
										RecLock("SEV")
										SEV->EV_LA    := "S"
										MsUnlock( )
									EndIf
								ElseIf lUsaFlag
									If (nPosReg  := aScan(aFlagCTB,{ |x| x[4] == SEV->(Recno()) }))>0
										aFlagCTB := Adel(aFlagCTB,nPosReg)
										aFlagCTB := aSize(aFlagCTB,Len(aFlagCTB)-1)
									Endif
								Endif
								
							Endif

							DbSelectArea("SEV")
							DbSkip()
						Enddo
						nTotal  	+=	nTotDoc
						nTotProc	+=	nTotDoc // Totaliza por processo

						If !lCabecalho
							a370Cabecalho(@nHdlPrv,@cArquivo)
						Endif
						nRecSev := SEV->(Recno())
						nRecSez := SEZ->(Recno())
						dbSelectArea("SEV")
						dbGobottom()
						dbSkip()
						DbSelectArea("SEZ")
						dbGobottom()
						dbSkip()
						nTotDoc	+=	DetProva(nHdlPrv,"506","FINA370",cLote,,,,,,,,@aFlagCTB)
						If mv_par12 == 2 
							If nTotDoc > 0 // Por documento
								Ca370Incl(cArquivo,@nHdlPrv,cLote,nTotal,@aFlagCTB)
								nTotDoc := 0
							Endif
							aFlagCTB := {}
						Endif
						
						dbSelectArea("SE1")
						DbGoto(nRecSe1)
					Endif

					dbSelectArea("SEV")
					DbGoBottom()
					DbSkip()
					
					DbSelectArea("SE1")
					dbGoto(nRecSe1)
					If lUsaFlag
						aAdd(aFlagCTB,{"E1_LA","S","SE1",SE1->(Recno()),0,0,0})
					EndIf
					If !lCabecalho							/// Se não houver cabeçalho aberto, abre.
						a370Cabecalho(@nHdlPrv,@cArquivo)
					EndIf
					
					If lCtbPls
					    nTotDoc	:= PlsCtbSe1(@nHdlPrv,cPadrao,"FINA370",cLote,,,,,,,,@aFlagCTB,"ICR",aRegBFQ)
					Else
						nTotDoc	:= DetProva(nHdlPrv,cPadrao,"FINA370",cLote,,,,,,,,@aFlagCTB)
					Endif
					nTotal	+= nTotDoc
					nTotProc	+= nTotDoc //Totaliza por processo
					If mv_par12 == 2 
						If nTotDoc > 0 // Por documento
							If lSeqCorr
								aDiario := {{"SE1",SE1->(recno()),SE1->E1_DIACTB,"E1_NODIA","E1_DIACTB"}}
							EndIf
							Ca370Incl(cArquivo,@nHdlPrv,cLote,nTotal,@aFlagCTB,@aDiario)
						Endif
						aFlagCTB := {}
					Endif
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Atualiza Flag de Lan‡amento Cont bil		  ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If LanceiCtb
						If !lUsaFlag
							Reclock("SE1")
							REPLACE E1_LA With "S"
							MsUnlock( )
						EndIf
					ElseIf lUsaFlag
						If (nPosReg  := aScan(aFlagCTB,{ |x| x[4] == SE1->(Recno()) }))>0
							aFlagCTB := Adel(aFlagCTB,nPosReg)
							aFlagCTB := aSize(aFlagCTB,Len(aFlagCTB)-1)
						Endif
					EndIf
				Endif
				DbSelectArea("SE1")
				dbSkip()
			Enddo
			
			If mv_par12 == 3 
				If nTotProc > 0 // Por processo
					Ca370Incl(cArquivo,@nHdlPrv,cLote,nTotal,@aFlagCTB)
					nTotProc := 0
				Endif
				aFlagCTB := {}
			Endif
			If lLerSE5
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Movimenta‡„o Banc ria a Receber - SE5990 						  ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				dbSelectArea( "SE5" )
				dbSetOrder( 1 )
				dbSeek( cFilial+Dtos(mv_par04),.T. )
				aRecsSE5 := {}

				If l370E5CON
					cCondWhile:= Execblock("F370E5CT",.F.,.F.)
				Else
					cCondWhile:= "'"+cFilial+"' == SE5->E5_FILIAL .And. ( SE5->E5_DATA >= mv_par04 .And. SE5->E5_DATA <= mv_par05 )"
				EndIf

				While !Eof() .And. &cCondWhile
					
					cPadrao 	:=Iif(SE5->E5_SITUACA <> "E", "563", "564")
					lX			:= .F.
					SEH->(dbSetOrder(1))
					
					If SE5->E5_TIPODOC $ "AP/RF/PE/EP" .And. SEH->(MsSeek(xFilial("SEH")+SubStr(SE5->E5_DOCUMEN,1,8)))
						lX		:= .T.
						If SE5->E5_TIPODOC $ "AP/EP"
							If ( SE5->E5_TIPODOC=="AP" .And. SE5->E5_RECPAG=="P" ) .Or.;
								( SE5->E5_TIPODOC=="EP" .And. SE5->E5_RECPAG=="R" )
								cPadrao := "580"
							Else
								cPadrao := "581"
							EndIf
						Else
							If ( SE5->E5_TIPODOC=="RF" .And. SE5->E5_RECPAG=="R" ) .Or.;
								( SE5->E5_TIPODOC=="PE" .And. SE5->E5_RECPAG=="P" )
								cPadrao := "585"
							Else
								cPadrao := "586"
							EndIf
						EndIf
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ SEH ja esta posicionado  ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						RecLock("SEH")
						SEH->EH_VALREG := 0
						SEH->EH_VALREG2:= 0
						SEH->EH_VALIRF := 0
						// Soh zera valor do IOF para buscar o movimento de IOF (EI_TIPODOC igual a "I2") nos casos de aplicacoes.
						If SEH->EH_APLEMP == "APL"
							SEH->EH_VALIOF := 0
						EndIf
						SEH->EH_VALSWAP:= 0
						SEH->EH_VALISWP:= 0
						SEH->EH_VALOUTR:= 0
						SEH->EH_VALGAP := 0
						SEH->EH_VALCRED:= 0
						SEH->EH_VALJUR := 0
						SEH->EH_VALJUR2:= 0
						SEH->EH_VALVCLP:= 0
						SEH->EH_VALVCCP:= 0
						SEH->EH_VALVCJR:= 0
						SEH->EH_VALREG := 0
						SEH->EH_VALREG2:= 0
						MsUnlock()
						
						dbSelectArea("SEI")
						dbSetOrder(1)
						dbSeek(xFilial("SEI")+SEH->EH_APLEMP+SubStr(SE5->E5_DOCUMEN,1,10))
						
						If ( !VerPadrao("581") .And. cPadrao$"581#580" .And. SEI->EI_STATUS=="C" )
							dbSelectArea("SE5")
							SE5->(dbSkip())
							Loop
						EndIf
						If ( !VerPadrao("586") .And. cPadrao$"586#585" .And. SEI->EI_STATUS=="C" )
							dbSelectArea("SE5")
							SE5->(dbSkip())
							Loop
						EndIf

						// Inicializa array com recnos para gravacao de flag de contabilizacao
						aRecsSEI := {}
						Do While ( SEI->EI_FILIAL+SEI->EI_APLEMP+SEI->EI_NUMERO+SEI->EI_REVISAO+SEI->EI_SEQ==;
							xFilial("SEI")+SEH->EH_APLEMP+SubStr(SE5->E5_DOCUMEN,1,10) )
							If SEI->EI_MOTBX == "APR"
								RecLock("SEH")
								If SEI->EI_TIPODOC == "I1"
									SEH->EH_VALIRF := Abs(SEI->EI_VALOR)
								EndIf
								If SEI->EI_TIPODOC == "I2"
									SEH->EH_VALIOF := Abs(SEI->EI_VALOR)
								EndIf
								If SEI->EI_TIPODOC == "I3"   
									SEH->EH_VALISWP:= Abs(SEI->EI_VALOR)
								EndIf
								If SEI->EI_TIPODOC == "I4"
									SEH->EH_VALOUTR:= Abs(SEI->EI_VALOR)
								EndIf
								If SEI->EI_TIPODOC == "I5"
									SEH->EH_VALGAP := Abs(SEI->EI_VALOR)
								EndIf
								If SEI->EI_TIPODOC == "JR"
									SEH->EH_VALJUR  := Abs(SEI->EI_VALOR)
									SEH->EH_VALJUR2 := Abs(SEI->EI_VLMOED2)
								EndIf
								If SEI->EI_TIPODOC == "V1"
									SEH->EH_VALVCLP := Abs(SEI->EI_VALOR)
								EndIf
								If SEI->EI_TIPODOC == "V2"
									SEH->EH_VALVCCP := Abs(SEI->EI_VALOR)
								EndIf
								If SEI->EI_TIPODOC == "V3"   
									SEH->EH_VALVCJR := Abs(SEI->EI_VALOR)
								EndIf
								SEH->( MsUnLock() )
								If SEI->EI_TIPODOC $ "I1/I2/I3/I4/I5/JR/V1/V2/V3"
									If lUsaFlag
										AAdd( aFlagCTB, {"EI_LA","S","SEI",SEI->(Recno()),0,0,0} )
									Else
										AAdd( aRecsSEI, SEI->(Recno()) )
									EndIf
								EndIf
							EndIf
							SEI->(dbSkip())
						EndDo
						SEI->(DbGoBottom())
						SEI->(DbSkip())
						If ( VerPadrao("582") )
							If !lCabecalho
								a370Cabecalho(@nHdlPrv,@cArquivo)
							EndIf
							If lUsaFlag 
								AAdd( aFlagCTB, {"E5_LA","S","SE5",SE5->(Recno()),0,0,0} )
							EndIf
							nTotDoc	:= DetProva(nHdlPrv,"582","FINA370",cLote,,,,,,,,@aFlagCTB)
							If LanceiCtb // Vem do DetProva
								AAdd( aRecsSE5, SE5->(Recno()) )
								For nX := 1 To Len( aRecsSEI )
									SEI->( dbGoTo( aRecsSEI[nX] ) )
									RecLock("SEI")
									SEI->EI_LA := "S"
									SEI->( MsUnlock() )
								Next nX	
							EndIf
							nTotal	+=	nTotDoc
							nTotProc += nTotDoc
							If mv_par12 == 2 
								If nTotDoc > 0 // Por documento
									If lSeqCorr
										aDiario := {{"SE5",SE5->(recno()),SE5->E5_DIACTB,"E5_NODIA","E5_DIACTB"}}
									EndIf
									Ca370Incl(cArquivo,@nHdlPrv,cLote,nTotal,@aFlagCTB,@aDiario)
								Endif
								aFlagCTB := {}
							Endif
						EndIf
						
						dbSelectArea("SEH")
						dbSetOrder(1)
						MsSeek(xFilial("SEH")+SubStr(SE5->E5_DOCUMEN,1,8))
						RecLock("SEH")
						SEH->EH_VALREG := 0
						SEH->EH_VALREG2:= 0
						SEH->EH_VALIRF := 0
						// Soh zera valor do IOF para buscar o movimento de IOF (EI_TIPODOC igual a "I2") nos casos de aplicacoes.
						If SEH->EH_APLEMP == "APL"
							SEH->EH_VALIOF := 0
						EndIf	
						SEH->EH_VALSWAP:= 0
						SEH->EH_VALISWP:= 0
						SEH->EH_VALOUTR:= 0
						SEH->EH_VALGAP := 0
						SEH->EH_VALCRED:= 0
						SEH->EH_VALJUR := 0
						SEH->EH_VALJUR2:= 0
						SEH->EH_VALVCLP:= 0
						SEH->EH_VALVCCP:= 0
						SEH->EH_VALVCJR:= 0
						SEH->EH_VALREG := 0
						SEH->EH_VALREG2:= 0
						MsUnlock()
						
						dbSelectArea("SEI")
						dbSetOrder(1)
						dbSeek(xFilial("SEI")+SEH->EH_APLEMP+SubStr(SE5->E5_DOCUMEN,1,10))
						Do While ( SEI->EI_FILIAL+SEI->EI_APLEMP+SEI->EI_NUMERO+SEI->EI_REVISAO+SEI->EI_SEQ==;
							xFilial("SEI")+SEH->EH_APLEMP+SubStr(SE5->E5_DOCUMEN,1,10) )
							If SEI->EI_MOTBX == "NOR"
								RecLock("SEH")
								If SEI->EI_TIPODOC == "RG" 
									SEH->EH_VALREG := Abs(SEI->EI_VALOR)
									SEH->EH_VALREG2:= Abs(SEI->EI_VALOR)
								EndIf
								If SEI->EI_TIPODOC == "I1"
									SEH->EH_VALIRF := Abs(SEI->EI_VALOR)
								EndIf
								If SEI->EI_TIPODOC == "I2" 
									SEH->EH_VALIOF := Abs(SEI->EI_VALOR)
								EndIf
								If SEI->EI_TIPODOC == "SW" 
									SEH->EH_VALSWAP:= Abs(SEI->EI_VALOR)
								EndIf
								If SEI->EI_TIPODOC == "I3" 
									SEH->EH_VALISWP:= Abs(SEI->EI_VALOR)
								EndIf
								If SEI->EI_TIPODOC == "I4" 
									SEH->EH_VALOUTR:= Abs(SEI->EI_VALOR)
								EndIf
								If SEI->EI_TIPODOC == "I5" 
									SEH->EH_VALGAP := Abs(SEI->EI_VALOR)
								EndIf
								If SEI->EI_TIPODOC == "VL" 
									SEH->EH_VALCRED:= Abs(SEI->EI_VALOR)
								EndIf
								If SEI->EI_TIPODOC == "JR" 
									SEH->EH_VALJUR := Abs(SEI->EI_VALOR)
									SEH->EH_VALJUR2:= Abs(SEI->EI_VLMOED2)
								EndIf
								If SEI->EI_TIPODOC == "V1" 
									SEH->EH_VALVCLP := Abs(SEI->EI_VALOR)
								EndIf
								If SEI->EI_TIPODOC == "V2" 
									SEH->EH_VALVCCP := Abs(SEI->EI_VALOR)
								EndIf
								If SEI->EI_TIPODOC == "V3" 
									SEH->EH_VALVCJR := Abs(SEI->EI_VALOR)
								EndIf
								If SEI->EI_TIPODOC == "BL" 
									SEH->EH_VALREG := Abs(SEI->EI_VALOR)
									SEH->EH_VALREG2:= Abs(SEI->EI_VLMOED2)
								EndIf
								If SEI->EI_TIPODOC == "BC" 
									SEH->EH_VALREG := Abs(SEI->EI_VALOR)
									SEH->EH_VALREG2:= Abs(SEI->EI_VLMOED2)
								EndIf
								If SEI->EI_TIPODOC == "BJ" 
									SEH->EH_VALJUR := Abs(SEI->EI_VALOR)
									SEH->EH_VALJUR2:= Abs(SEI->EI_VLMOED2)
								EndIf
								If SEI->EI_TIPODOC == "BP"
									VALOR := Abs(SEI->EI_VALOR)
								EndIf
								SEH->( MsUnLock() )
							EndIf	
							SEI->( dbSkip() )
						EndDo
					EndIf
					
					dbSelectArea("SE5")
					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Caracteriza-se lancamento os registros com :		  ³
					//³ E5_TIPODOC = brancos                         		  ³
					//³ E5_TIPODOC = "DB" // Receita Bancaria - FINA200     ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If ( !lX )
						If !(SE5->E5_TIPODOC $ "DB")
							If !Empty(SE5->E5_TIPODOC) .OR. SE5->E5_RECPAG == "P"
								SE5->(dbSkip())
								Loop
							Endif
						EndIf
					EndIf
					
					If SE5->E5_SITUACA == "C" .or. SubStr(SE5->E5_LA,1,1) == "S" ;
						.or. SE5->E5_RECPAG == "P"
						SE5->(dbSkip())
						Loop
					Endif
					
					If SE5->E5_RATEIO == "S" .And. CtbInUse()
						cPadrao := "517"
					EndIf
					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Posiciona na natureza.										  ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					dbSelectArea( "SED" )
					dbSeek(xFilial()+SE5->E5_NATUREZ)
					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Posiciona no banco.											  ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					dbSelectArea("SA6")
					dbSetOrder(1)
					dbSeek(xFilial()+SE5->E5_BANCO+SE5->E5_AGENCIA+SE5->E5_CONTA)
					
					dbSelectArea("SE5")
					lPadrao:=VerPadrao(cPadrao)
					
					If l370E5R
						Execblock("F370E5R",.F.,.F.)
					Endif
					
					IF lPadrao
						If SE5->E5_RATEIO != "S"
							If !lCabecalho
								a370Cabecalho(@nHdlPrv,@cArquivo)
							Endif
							If lUsaFlag
								aAdd(aFlagCTB,{"E5_LA","S","SE5",SE5->(Recno()),0,0,0})
							EndiF
							nTotDoc	:= DetProva(nHdlPrv,cPadrao,"FINA370",cLote,,,,,,,,@aFlagCTB)
							nTotProc	+= nTotDoc
							nTotal	+=	nTotDoc
							If mv_par12 == 2 
								If nTotDoc > 0 // Por documento
									If lSeqCorr
										aDiario := {{"SE5",SE5->(recno()),SE5->E5_DIACTB,"E5_NODIA","E5_DIACTB"}}
									EndIf
									Ca370Incl(cArquivo,@nHdlPrv,cLote,nTotal,@aFlagCTB,@aDiario)
								Endif
								aFlagCTB := {}
							Endif
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Atualiza Flag de Lan‡amento Cont bil		  ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							If LanceiCtb
								AADD(aRecsSE5,SE5->(RECNO()))
							EndIf
						Else
							If CtbInUse()				// Somente para SIGACTB
								If nHdlPrv <= 0
									a370Cabecalho(@nHdlPrv,@cArquivo)
								EndIf
								RegToMemory("SE5",.F.,.F.)
								If lUsaFlag
									aAdd(aFlagCTB,{"E5_LA","S","SE5",SE5->(Recno()),0,0,0})
								EndIf
								// Devido a estrutura do programa, o rateio ja eh "quebrado"
								// por documento.
								F370RatFin(cPadrao,"FINA370",cLote,4," ",4,,,,@nHdlPrv,@nTotDoc,@aFlagCTB)
								lCabecalho := If(nHdlPrv <= 0, lCabecalho, .T.)
								nTotProc	+= nTotDoc
								nTotal	+=	nTotDoc
								If mv_par12 == 2 
									If nTotDoc > 0 // Por documento
										If lSeqCorr
											aDiario := {{"SE5",SE5->(recno()),SE5->E5_DIACTB,"E5_NODIA","E5_DIACTB"}}
										EndIf
										Ca370Incl(cArquivo,@nHdlPrv,cLote,nTotal,@aFlagCTB,@aDiario)
									Endif
									aFlagCTB := {}
								Endif
								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//³ Atualiza Flag de Lan‡amento Cont bil	   ³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
								If LanceiCtb
									AADD(aRecsSE5,SE5->(RECNO()))
								EndIf
								// Verifica o arquivo de rateio, e apaga o arquivo temporario
								// para que no proximo rateio seja criado novamente
								If Select("TMP1") > 0
									DbSelectArea( "TMP1" )
									cArq := DbInfo(DBI_FULLPATH)
									cArq := AllTrim(SubStr(cArq,Rat("\",cArq)+1))
									DbCloseArea()
									FErase(cArq)
								EndIf
							EndIf
						Endif
					EndIf
					dbSelectArea("SE5")
					dbSkip()
				End
				
				If mv_par12 == 3 
					If nTotProc > 0 // Por processo
						Ca370Incl(cArquivo,@nHdlPrv,cLote,nTotal,@aFlagCTB)
						nTotProc := 0
					Endif
					aFlagCTB := {}
				Endif
			Endif
		Endif
		
		If (mv_par06 == 2 .or. mv_par06 == 4) .and. lLerSE2
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Contas a Pagar - SE2990												  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			#IFDEF TOP
				dbSelectArea( "TRBSE2" )
			#ELSE
				dbSelectArea("SE2")
			#ENDIF
			dbSetOrder(nIndSe2+1)
			dbSeek(xFilial("SE2")+DtoS(mv_par04),.T.)
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Contabiliza pelo E2_EMIS1                  			  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			While !Eof() .And. xFilial("SE2") == E2_FILIAL .And. E2_EMIS1 >= mv_par04 ;
				.And. E2_EMIS1 <= mv_par05
				#IFDEF TOP
					SE2->(dbGoto(TRBSE2->(Recno())))
				#ENDIF
				lMulNatSE2 := .F.
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Verifica se ser  gerado Lan‡amento Cont bil			  ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If	SE2->E2_LA = "S" .Or. (SE2->E2_TIPO $ MVPROVIS .And. mv_par17 <> 1)
					#IFDEF TOP
						TRBSE2->(dbSkip())
					#ELSE
						SE2->(dbSkip())
					#ENDIF
					Loop
				Endif
				
				If	SE2->E2_TIPO $ MVTAXA+"/"+MVISS+"/"+MVINSS .And.;
					( AllTrim(SE2->E2_FORNECE) $ GetMv( "MV_UNIAO" ) .Or.;
					AllTrim(SE2->E2_FORNECE) $ GetMv( "MV_MUNIC" ))
					// Contabiliza rateio de impostos em multiplas naturezas e multiplos
					// centros de custos.
					lPadrao:=VerPadrao("510")
					lPadraoCC := VerPadrao("508")  // Rateio C.Custo de MultiNat Pagar
					If lPadrao
						If SE2->E2_RATEIO != "S"
							If !lCabecalho
								a370Cabecalho(@nHdlPrv,@cArquivo)
							Endif
							cChaveSev := RetChaveSev("SE2")
							cChaveSeZ := RetChaveSev("SE2",,"SEZ")
							DbSelectArea("SEV")
							// Se utiliza multiplas naturezas, contabiliza pelo SEV
							If SE2->E2_MULTNAT=="1" .And. MsSeek(cChaveSev)
								lMulNatSE2 := .F.
								dbSelectArea("SE2")
								nRecSe2 := Recno()
								DbGoBottom()
								DbSkip()

								DbSelectArea("SEV")
								dbSetOrder(2)
								While xFilial("SEV")+SEV->(EV_PREFIXO+EV_NUM+EV_PARCELA+EV_TIPO+EV_CLIFOR+;
									EV_LOJA+EV_IDENT) == cChaveSev+"1" .And. !Eof()
									If SEV->EV_LA != "S"
										dbSelectArea( "SED" )
										MsSeek( xFilial("SED")+SEV->EV_NATUREZ ) // Posiciona na natureza, pois a conta pode estar la.
										dbSelectArea("SEV")
										If SEV->EV_RATEICC == "1" .and. lPadrao .and. lPadraoCC // Rateou multinat por c.custo
											dbSelectArea("SEZ")
											dbSetOrder(4)
											MsSeek(cChaveSeZ+SEV->EV_NATUREZ) // Posiciona no arquivo de Rateio C.Custo da MultiNat
											While !Eof() .and. xFilial("SEZ")+SEZ->(EZ_PREFIXO+EZ_NUM+;
												EZ_PARCELA+EZ_TIPO+EZ_CLIFOR+EZ_LOJA+EZ_NATUREZ+EZ_IDENT) == cChaveSeZ+SEV->EV_NATUREZ+"1"

												If SEZ->EZ_LA != "S"

													If lUsaFlag
														aAdd(aFlagCTB,{"EZ_LA","S","SEZ",SEZ->(Recno()),0,0,0})
													EndIf

													VALOR := 0
													VALOR2 := 0
													VALOR3 := 0
													VALOR4 := 0
													Do Case
														Case SEZ->EZ_TIPO $ MVTAXA
															VALOR2 := SEZ->EZ_VALOR
														Case SEZ->EZ_TIPO $ MVISS
															VALOR3 := SEZ->EZ_VALOR
														Case SEZ->EZ_TIPO $ MVINSS
															VALOR4 := SEZ->EZ_VALOR
													EndCase
													nTotDoc	+=	DetProva(nHdlPrv,"508","FINA370",cLote,,,,,,,,@aFlagCTB)
													If LanceiCtb // Vem do DetProva
														If !lUsaFlag
															RecLock("SEZ")
															SEZ->EZ_LA    := "S"
															MsUnlock( )
														EndIf
													ElseIf lUsaFlag
														If (nPosReg  := aScan(aFlagCTB,{ |x| x[4] == SEZ->(Recno()) }))>0
															aFlagCTB := Adel(aFlagCTB,nPosReg)
															aFlagCTB := aSize(aFlagCTB,Len(aFlagCTB)-1)
														Endif											
													Endif
												Endif
												dbSkip()
											Enddo
										Else
											VALOR := 0
											VALOR2 := 0
											VALOR3 := 0
											VALOR4 := 0
											Do Case
												Case SEV->EV_TIPO $ MVTAXA
													VALOR2 := SEV->EV_VALOR
												Case SEV->EV_TIPO $ MVISS
													VALOR3 := SEV->EV_VALOR
												Case SEV->EV_TIPO $ MVINSS
													VALOR4 := SEV->EV_VALOR
											EndCase

											If lUsaFlag
												aAdd(aFlagCTB,{"EV_LA","S","SEV",SEV->(Recno()),0,0,0})
											EndIf

											nTotDoc	+=	DetProva(nHdlPrv,"510","FINA370",cLote,,,,,,,,@aFlagCTB)

										Endif
										If LanceiCtb // Vem do DetProva
											If !lUsaFlag
												RecLock("SEV")
												SEV->EV_LA    := "S"
												MsUnlock( )
											EndIf    
										ElseIf lUsaFlag
											If (nPosReg  := aScan(aFlagCTB,{ |x| x[4] == SEV->(Recno()) }))>0
												aFlagCTB := Adel(aFlagCTB,nPosReg)
												aFlagCTB := aSize(aFlagCTB,Len(aFlagCTB)-1)
											Endif											
										Endif
									Endif
									dbSelectArea("SEV")
									DbSkip()
								Enddo
								nTotal  	+=	nTotDoc
								nTotProc	+=	nTotDoc // Totaliza por processo
								nRecSev := SEV->(Recno())
								nRecSez := SEZ->(Recno())
								dbSelectArea("SEV")
								dbGobottom()
								dbSkip()
								dbSelectArea("SEV")
								dbGobottom()
								dbSkip()
								dbSelectArea("SE2")			// permite contabilizar os impostos pelo SE2
								dbGoto(nRecSe2)
								If lUsaFlag
									aAdd(aFlagCTB,{"E2_LA","S","SE2",SE2->(Recno()),0,0,0})
								EndiF
								If !lCabecalho
									a370Cabecalho(@nHdlPrv,@cArquivo)
								Endif
								nTotDoc	+=	DetProva(nHdlPrv,"508","FINA370",cLote,,,,,,,,@aFlagCTB)
								SEV->(dbGoto(nRecSev))
								SEZ->(dbGoto(nRecSez))
								dbSelectArea("SE2")
								DbGoto(nRecSe2)
								If mv_par12 == 2 
									If nTotDoc > 0 // Por documento
										If lF370NatP
											ExecBlock("F370NATP",.F.,.F.,{nHdlPrv,cLote})
										Endif
										Ca370Incl(cArquivo,@nHdlPrv,cLote,nTotal,@aFlagCTB)
										nTotDoc := 0
									Endif
									aFlagCTB := {}
								Endif
								
								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//³ Atualiza Flag de Lan‡amento Cont bil 	   ³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
								If LanceiCtb
									If !lUsaFlag
										Reclock("SE2")
										Replace E2_LA With "S"
										SE2->(MsUnlock())
									EndIF
								ElseIf lUsaFlag
									If (nPosReg  := aScan(aFlagCTB,{ |x| x[4] == SE2->(Recno()) }))>0
										aFlagCTB := Adel(aFlagCTB,nPosReg)
										aFlagCTB := aSize(aFlagCTB,Len(aFlagCTB)-1)
									Endif
								EndIf
							Endif
						Endif
					Endif
					// Fim da contabilizacao de titulos de impostos por multiplas natureza
					// e multiplos centros de custos
					#IFDEF TOP
						dbSelectArea( "TRBSE2" )
					#ELSE
						dbSelectArea("SE2")
					#ENDIF
					If lMulNatSE2
						dbSkip()
						Loop
					Endif
				Endif
				
				nRegAnt := Recno()
				dbSkip()
				nProxReg := Recno()
				DbGoto(nRegAnt)
				
				cPadrao := "510"
				
				IF	SE2->E2_TIPO $ MVPAGANT
					cPadrao:="513"
				EndIF
				
				If	SE2->E2_RATEIO == "S"
					cPadrao := "511"
				EndIf
				
				If	SE2->E2_DESDOBR == "S"
					cPadrao := "577"
				EndIf
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Posiciona no fornecedor.									  ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				dbSelectArea( "SA2" )
				dbSeek( xFilial("SA2")+SE2->E2_FORNECE+SE2->E2_LOJA )
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Posiciona na natureza.										  ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				dbSelectArea( "SED" )
				dbSeek( xFilial("SED")+SE2->E2_NATUREZ )
				dbSelectArea("SE2")
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Posiciona na SE5 e no Banco,se PA e SEF para Cheque ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If SE2->E2_TIPO $ MVPAGANT
					dbSelectArea("SE5")
					dbSetOrder(2)
					dbSeek( xFilial()+"PA"+SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA+SE2->E2_TIPO+DtoS(SE2->E2_EMISSAO)+SE2->E2_FORNECE+SE2->E2_LOJA)
					dbSetOrder(1)

					dbSelectArea("SEF")
					dbSetOrder(3)
					dbSeek(xFilial()+SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA+SE2->E2_TIPO+SE2->E2_NUMBCO)
					
					dbSelectArea( "SA6" )
					dbSetOrder(1)
					If SE5->(Found())
						dbSeek( xFilial()+SE5->E5_BANCO+SE5->E5_AGENCIA+SE5->E5_CONTA)
					Else
						dbSeek( xFilial()+SEF->EF_BANCO+SEF->EF_AGENCIA+SEF->EF_CONTA)
					Endif
					dbSelectArea( "SE2" )
				Endif
				lPadrao:=VerPadrao(cPadrao)
                lCtbPls:=lCtPlsICP .and. substr(SE2->E2_ORIGEM,1,3) == "PLS"
				lPadraoCC := VerPadrao("508")  // Rateio C.Custo de MultiNat Pagar
				If lPadrao .or. lCtbPls
					If SE2->E2_RATEIO != "S"
						If !lCabecalho
							a370Cabecalho(@nHdlPrv,@cArquivo)
						Endif
						cChaveSev := RetChaveSev("SE2")
						cChaveSeZ := RetChaveSev("SE2",,"SEZ")
						DbSelectArea("SEV")
						// Se utiliza multiplas naturezas, contabiliza pelo SEV
						If ! lCtbPls .And. SE2->E2_MULTNAT=="1" .And. MsSeek(cChaveSev)
							dbSelectArea("SE2")
							nRecSe2 := Recno()
							DbGoBottom()
							DbSkip()
							DbSelectArea("SEV")
							dbSetOrder(2)
							While xFilial("SEV")+SEV->(EV_PREFIXO+EV_NUM+EV_PARCELA+EV_TIPO+EV_CLIFOR+;
								EV_LOJA+EV_IDENT) == cChaveSev+"1" .And. !Eof()
								If SEV->EV_LA != "S"

									dbSelectArea( "SED" )
									MsSeek( xFilial("SED")+SEV->EV_NATUREZ ) // Posiciona na natureza, pois a conta pode estar la.
									dbSelectArea("SEV")
									If SEV->EV_RATEICC == "1" .and. lPadrao .and. lPadraoCC // Rateou multinat por c.custo

										dbSelectArea("SEZ")
										dbSetOrder(4)
										MsSeek(cChaveSeZ+SEV->EV_NATUREZ) // Posiciona no arquivo de Rateio C.Custo da MultiNat
										While !Eof() .and. xFilial("SEZ")+SEZ->(EZ_PREFIXO+EZ_NUM+;
												EZ_PARCELA+EZ_TIPO+EZ_CLIFOR+EZ_LOJA+EZ_NATUREZ+EZ_IDENT) == cChaveSeZ+SEV->EV_NATUREZ+"1"

											If SEZ->EZ_LA != "S"
												If lUsaFlag
													aAdd(aFlagCTB,{"EZ_LA","S","SEZ",SEZ->(Recno()),0,0,0})
												EndiF
	
												VALOR2	:= 0
												VALOR3	:= 0
												VALOR4	:= 0
												VALOR  	:= 0
												Do Case
													Case SEZ->EZ_TIPO $ MVTAXA
														VALOR2 := SEZ->EZ_VALOR
													Case SEZ->EZ_TIPO $ MVISS
														VALOR3 := SEZ->EZ_VALOR
													Case SEZ->EZ_TIPO $ MVINSS
														VALOR4 := SEZ->EZ_VALOR
													Otherwise
														VALOR  := SEZ->EZ_VALOR
												EndCase
												nTotDoc	+=	DetProva(nHdlPrv,"508","FINA370",cLote,,,,,,,,@aFlagCTB)
												If LanceiCtb // Vem do DetProva
													If !lUsaFlag
														RecLock("SEZ")
														SEZ->EZ_LA    := "S"
														MsUnlock( )
													EndIf    
												ElseIf lUsaFlag
													If (nPosReg  := aScan(aFlagCTB,{ |x| x[4] == SEZ->(Recno()) }))>0
														aFlagCTB := Adel(aFlagCTB,nPosReg)
														aFlagCTB := aSize(aFlagCTB,Len(aFlagCTB)-1)
													Endif													
												Endif
											Endif

											dbSkip()
										Enddo
										DbSelectArea("SEV")
									Else
										VALOR := 0
										VALOR2 := 0
										VALOR3 := 0
										VALOR4 := 0
										Do Case
											Case SEV->EV_TIPO $ MVTAXA
												VALOR2 := SEV->EV_VALOR
											Case SEV->EV_TIPO $ MVISS
												VALOR3 := SEV->EV_VALOR
											Case SEV->EV_TIPO $ MVINSS
												VALOR4 := SEV->EV_VALOR
										EndCase
										If lUsaFlag
											aAdd(aFlagCTB,{"EV_LA","S","SEV",SEV->(Recno()),0,0,0})
										EndIf
										nTotDoc	+= DetProva(nHdlPrv,cPadrao,"FINA370",cLote,,,,,,,,@aFlagCTB)
									Endif
									If LanceiCtb // Vem do DetProva
										If !lUsaFlag
											RecLock("SEV")
											SEV->EV_LA    := "S"
											MsUnlock( )
										EndIf    
									ElseIf lUsaFlag
										If (nPosReg  := aScan(aFlagCTB,{ |x| x[4] == SEV->(Recno()) }))>0
											aFlagCTB := Adel(aFlagCTB,nPosReg)
											aFlagCTB := aSize(aFlagCTB,Len(aFlagCTB)-1)
										Endif										
									Endif
								Endif
								dbSelectArea("SEV")
								DbSkip()
							Enddo
							nTotal  	+=	nTotDoc
							nTotProc	+=	nTotDoc // Totaliza por processo
							dbSelectArea("SE2")
							DbGoto(nRecSe2)
							//Se contabiliza por processo, contabilizo o titulo do SE2 referente as multiplas naturezas.
							If mv_par12 == 3
						   		SEV->( DbGoBottom() )
								SEV->( DbSkip() )
								If lUsaFlag
									aAdd(aFlagCTB,{"E2_LA","S","SE2",SE2->(Recno()),0,0,0})
								EndIf
								nTotDoc	+= DetProva(nHdlPrv,cPadrao,"FINA370",cLote,,,,,,,,@aFlagCTB)							
								If LanceiCtb // Vem do DetProva
									If !lUsaFlag
										RecLock("SE2")
										Replace E2_LA With "S"
										MsUnlock( )
									EndIf  
								ElseIf lUsaFlag
									If (nPosReg  := aScan(aFlagCTB,{ |x| x[4] == SE2->(Recno()) }))>0
										aFlagCTB := Adel(aFlagCTB,nPosReg)
										aFlagCTB := aSize(aFlagCTB,Len(aFlagCTB)-1)
									Endif										
								Endif
							EndIf
							If mv_par12 == 3 
								If nTotProc > 0 // Por processo
									If lF370NatP
										ExecBlock("F370NATP",.F.,.F.,{nHdlPrv,cLote})
									Endif
									Ca370Incl(cArquivo,@nHdlPrv,cLote,nTotProc,@aFlagCTB)
									nTotProc := 0
								Endif
								aFlagCTB := {}
							Endif
						Endif
						dbSelectArea("SEV")
						DbGoBottom()
						DbSkip()
						dbSelectArea( "SE2" )
						
						If !SE2->E2_LA == "S"
							If !lCabecalho
								a370Cabecalho(@nHdlPrv,@cArquivo)
							Endif
							
							If lUsaFlag
								aAdd(aFlagCTB,{"E2_LA","S","SE2",SE2->(Recno()),0,0,0})
							EndIf
							
							If lCtbPls
								nTotDoc	:= PlsCtbSe2(nHdlPrv,cPadrao,"FINA370",cLote,,,,,,,,@aFlagCTB,"ICP")
							Else
								nTotDoc	+=	DetProva(nHdlPrv,cPadrao,"FINA370",cLote,,,,,,,,@aFlagCTB)
							Endif
							nTotProc	+= nTotDoc
							nTotal	+=	nTotDoc
							If mv_par12 == 2 
								If nTotDoc > 0 // Por documento
									If lSeqCorr
										aDiario := {{"SE2",SE2->(recno()),SE2->E2_DIACTB,"E2_NODIA","E2_DIACTB"}}
									EndIf
									Ca370Incl(cArquivo,@nHdlPrv,cLote,nTotal,@aFlagCTB,@aDiario)
									nTotDoc := 0
								Endif
								aFlagCTB := {}
							Endif
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Atualiza Flag de Lan‡amento Cont bil 		  ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							If LanceiCtb
								If !lUsaFlag
									Reclock("SE2")
									Replace E2_LA With "S"
									SE2->(MsUnlock())
								EndIf  
							ElseIf lUsaFlag
								If (nPosReg  := aScan(aFlagCTB,{ |x| x[4] == SE2->(Recno()) }))>0
									aFlagCTB := Adel(aFlagCTB,nPosReg)
									aFlagCTB := aSize(aFlagCTB,Len(aFlagCTB)-1)
								Endif								
							EndIf
						EndIf
					Else
						If !CtbInUse()
							/// Fa370Rat já cria cabecalho contab. caso não esteja aberto
							If lUsaFlag
								aAdd(aFlagCTB,{"E2_LA","S","SE2",SE2->(Recno()),0,0,0})
							EndIf
							nTotDoc	:=	Fa370Rat(AllTrim(SE2->E2_ARQRAT),@nHdlPrv,@cArquivo)
							nTotProc	+= nTotDoc
							nTotal	+=	nTotDoc
							If mv_par12 == 2 
								If nTotDoc > 0 // Por documento
									Ca370Incl(cArquivo,@nHdlPrv,cLote,nTotal,@aFlagCTB)
								Endif
								aFlagCTB := {}
							Endif
							
							If nTotal != 0
								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//³ Atualiza Flag de Lan‡amento Cont bil		  ³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
								dbSelectArea("SE2")
								If !lUsaFlag
									Reclock("SE2")
									Replace E2_LA With "S"
									SE2->(MsUnlock())
								EndIf
							Endif
						Else
							// Devido a estrutura do programa, o rateio ja eh "quebrado"
							// por documento.
							If !lCabecalho							/// Se não houver cabeçalho aberto, abre.
								a370Cabecalho(@nHdlPrv,@cArquivo)
							EndIf
							RegToMemory("SE2",.F.,.F.)
							If lUsaFlag
								aAdd(aFlagCTB,{"E2_LA","S","SE2",SE2->(Recno()),0,0,0})
							EndIf
							F370RatFin(cPadrao,"FINA370",cLote,4," ",4,,,,@nHdlPrv,@nTotDoc,@aFlagCTB)
							lCabecalho := If(nHdlPrv <= 0, lCabecalho, .T.)
							nTotProc	+= nTotDoc
							nTotal	+=	nTotDoc
							If mv_par12 == 2 
								If nTotDoc > 0 // Por documento
									If lSeqCorr
										aDiario := {{"SE2",SE2->(recno()),SE2->E2_DIACTB,"E2_NODIA","E2_DIACTB"}}
									EndIf
									Ca370Incl(cArquivo,@nHdlPrv,cLote,nTotal,@aFlagCTB,@aDiario)
								Endif
								aFlagCTB := {}
							Endif
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Atualiza Flag de Lan‡amento Cont bil		  ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							If LanceiCtb
								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//³ Atualiza Flag de Lan‡amento Cont bil		  ³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
								dbSelectArea("SE2")
								If !lUsaFlag
									Reclock("SE2")
									Replace E2_LA With "S"
									SE2->(MsUnlock())
								EndIf  
							ElseIf lUsaFlag
								If (nPosReg  := aScan(aFlagCTB,{ |x| x[4] == SE2->(Recno()) }))>0
									aFlagCTB := Adel(aFlagCTB,nPosReg)
									aFlagCTB := aSize(aFlagCTB,Len(aFlagCTB)-1)
								Endif								
							EndIf
							// Verifica o arquivo de rateio, e apaga o arquivo temporario
							// para que no proximo rateio seja criado novamente
							If Select("TMP1") > 0
								DbSelectArea( "TMP1" )
								cArq := DbInfo(DBI_FULLPATH)
								cArq := AllTrim(SubStr(cArq,Rat("\",cArq)+1))
								DbCloseArea()
								FErase(cArq)
							EndIf
						EndIf
					Endif
				Endif
				#IFDEF TOP
					dbSelectArea("TRBSE2")
				#ELSE
					dbSelectArea("SE2")
				#ENDIF
				dbGoto(nProxReg)
				LanceiCtb := .F.
			Enddo
			If mv_par12 == 3 
				If nTotProc > 0 // Por processo
					Ca370Incl(cArquivo,@nHdlPrv,cLote,nTotal,@aFlagCTB)
					nTotProc := 0
				Endif
				aFlagCTB := {}
			Endif
			
			#IFDEF TOP
				dbSelectArea( "TRBSE2" )
			#ENDIF
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Movimenta‡„o Banc ria a Pagar - SE5990							  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			dbSelectArea( "SE5" )
			dbSetOrder( 1 )
			dbSeek( cFilial+Dtos(mv_par04),.T. )

			If l370E5CON
				cCondWhile:= Execblock("F370E5CT",.F.,.F.)
			Else
				cCondWhile:= "'"+cFilial+"' == SE5->E5_FILIAL .And. ( SE5->E5_DATA >= mv_par04 .And. SE5->E5_DATA <= mv_par05 )"
			EndIf

			While !Eof() .And. &cCondWhile .and. lLerSE5

				If SE5->E5_SITUACA == "C" .or. SubStr(SE5->E5_LA,1,1) == "S" .or. SE5->E5_RECPAG == "R"
					SE5->(dbSkip())
					Loop
				Endif
				
				// Nao contabiliza movimentacao bancaria de adiantamento
				If SE5->E5_RECPAG == "P" .And. SE5->E5_TIPO	== MVPAGANT
					SE5->(dbSkip())      
					Loop
				Endif
				
				// Nao contabiliza movimento bancario totalizador da baixa CNAB ou automatica
				// Este sera feito pela Baixa do titulo (LP530 ou LP532)
				If Empty(SE5->E5_TIPODOC) .and. !Empty(SE5->E5_LOTE)
					SE5->(dbSkip())
					Loop
				Endif
				cPadrao := Iif( SE5->E5_SITUACA <> "E", "562", "565" )
				//cPadrao do ITF - Peru
				//se for ITF utiliza lancamento especifico
				If lFindITF .And. FinProcITF( SE5->( Recno() ),2 )
					If SE5->E5_SITUACA == 'E' .Or. SE5->E5_SITUACA == 'C'
						cPadrao := "56B"
					Else
						cPadrao := "56A"
					EndIf
				EndIf
				lX := .f.
				SEH->(DbSetOrder(1))
				If SE5->E5_TIPODOC $ "AP/RF/PE/EP" .And. SEH->(MsSeek(xFilial("SEH")+SubStr(SE5->E5_DOCUMEN,1,8)))
					If SE5->E5_TIPODOC $ "AP/EP"
						If ( SE5->E5_TIPODOC=="AP" .And. SE5->E5_RECPAG=="P" ) .Or.;
							( SE5->E5_TIPODOC=="EP" .And. SE5->E5_RECPAG=="R" )
							cPadrao := "580"
						Else
							cPadrao := "581"
						EndIf
					Else
						If ( SE5->E5_TIPODOC=="RF" .And. SE5->E5_RECPAG=="R" ) .Or.;
							( SE5->E5_TIPODOC=="PE" .And. SE5->E5_RECPAG=="P" )
							cPadrao := "585"
						Else
							cPadrao := "586"
						EndIf
					EndIf
					lX := .T.
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ SEH ja estah posicionado	³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					RecLock("SEH")
					SEH->EH_VALREG := 0
					SEH->EH_VALREG2:= 0
					SEH->EH_VALIRF := 0
					// Soh zera valor do IOF para buscar o movimento de IOF (EI_TIPODOC igual a "I2") nos casos de aplicacoes.
					If SEH->EH_APLEMP == "APL"
						SEH->EH_VALIOF := 0
					EndIf	
					SEH->EH_VALSWAP:= 0
					SEH->EH_VALISWP:= 0
					SEH->EH_VALOUTR:= 0
					SEH->EH_VALGAP := 0
					SEH->EH_VALCRED:= 0
					SEH->EH_VALJUR := 0
					SEH->EH_VALJUR2:= 0
					SEH->EH_VALVCLP:= 0
					SEH->EH_VALVCCP:= 0
					SEH->EH_VALVCJR:= 0
					SEH->EH_VALREG := 0
					SEH->EH_VALREG2:= 0
					MsUnlock()
					
					dbSelectArea("SEI")
					dbSetOrder(1)
					dbSeek(xFilial("SEI")+SEH->EH_APLEMP+SubStr(SE5->E5_DOCUMEN,1,10))
					
					If ( !VerPadrao("581") .And. cPadrao$"581#580" .And. SEI->EI_STATUS=="C" )
						dbSelectArea("SE5")
						dbSkip()
						Loop
					EndIf
					If ( !VerPadrao("586") .And. cPadrao$"586#585" .And. SEI->EI_STATUS=="C" )
						dbSelectArea("SE5")
						dbSkip()
						Loop
					EndIf
					
					While ( SEI->EI_FILIAL+SEI->EI_APLEMP+SEI->EI_NUMERO+SEI->EI_REVISAO+SEI->EI_SEQ==;
						xFilial("SEI")+SEH->EH_APLEMP+SubStr(SE5->E5_DOCUMEN,1,10) )
						RecLock("SEH")
						If SEI->EI_MOTBX == "APR"
							If SEI->EI_TIPODOC == "I1"
								SEH->EH_VALIRF := Abs(SEI->EI_VALOR)
							EndIf
							If SEI->EI_TIPODOC == "I2"
								SEH->EH_VALIOF := Abs(SEI->EI_VALOR)
							EndIf
							If SEI->EI_TIPODOC == "I3"
								SEH->EH_VALISWP:= Abs(SEI->EI_VALOR)
							EndIf
							If SEI->EI_TIPODOC == "I4" 
								SEH->EH_VALOUTR:= Abs(SEI->EI_VALOR)
							EndIf
							If SEI->EI_TIPODOC == "I5" 
								SEH->EH_VALGAP := Abs(SEI->EI_VALOR)
							EndIf
							If SEI->EI_TIPODOC == "JR"
								SEH->EH_VALJUR := Abs(SEI->EI_VALOR)
								SEH->EH_VALJUR2:= Abs(SEI->EI_VLMOED2)
							EndIf
							If SEI->EI_TIPODOC == "V1"
								SEH->EH_VALVCLP := Abs(SEI->EI_VALOR)
							EndIf
							If SEI->EI_TIPODOC == "V2"
								SEH->EH_VALVCCP := Abs(SEI->EI_VALOR)
							EndIf
							If SEI->EI_TIPODOC == "V3" 
								SEH->EH_VALVCJR := Abs(SEI->EI_VALOR)
							EndIf                      
						EndIf
						MsUnLock()
						dbSelectArea("SEI")
						dbSkip()
					EndDo
					SEI->(DbGoBottom())
					SEI->(DbSkip())
					If ( VerPadrao("582") )
						// Garante que uma apropriacao ou resgate de emprestimo jah contabilizado no LP 582 acima, em 
						// movimentacoes a bancarias a receber, nao serah contabilizada novamente.
						If ( aScan( aRecsSE5, SE5->(Recno()) ) == 0 )
							If !lCabecalho
								a370Cabecalho(@nHdlPrv,@cArquivo)
							EndIf
							nTotDoc	:=	DetProva(nHdlPrv,"582","FINA370",cLote,,,,,,,,@aFlagCTB)
							nTotProc	+= nTotDoc
							nTotal	+=	nTotDoc
							If mv_par12 == 2 
								If nTotDoc > 0 // Por documento
									If lSeqCorr
										aDiario := {{"SE5",SE5->(recno()),SE5->E5_DIACTB,"E5_NODIA","E5_DIACTB"}}
									EndIf
									Ca370Incl(cArquivo,@nHdlPrv,cLote,nTotal,@aFlagCTB,@aDiario)
								Endif
								aFlagCTB := {}
							Endif
						EndIf	
					EndIf
					
					dbSelectArea("SEH")
					dbSetOrder(1)
					MsSeek(xFilial("SEH")+SubStr(SE5->E5_DOCUMEN,1,8))
					RecLock("SEH")
					SEH->EH_VALREG := 0
					SEH->EH_VALREG2:= 0
					SEH->EH_VALIRF := 0
					// Soh zera valor do IOF para buscar o movimento de IOF (EI_TIPODOC igual a "I2") nos casos de aplicacoes.
					If SEH->EH_APLEMP == "APL"
						SEH->EH_VALIOF := 0
					EndIf	
					SEH->EH_VALSWAP:= 0
					SEH->EH_VALISWP:= 0
					SEH->EH_VALOUTR:= 0
					SEH->EH_VALGAP := 0
					SEH->EH_VALCRED:= 0
					SEH->EH_VALJUR := 0
					SEH->EH_VALJUR2:= 0
					SEH->EH_VALVCLP:= 0
					SEH->EH_VALVCCP:= 0
					SEH->EH_VALVCJR:= 0
					SEH->EH_VALREG := 0
					SEH->EH_VALREG2:= 0
					MsUnLock()
					
					dbSelectArea("SEI")
					dbSetOrder(1)
					dbSeek(xFilial("SEI")+SEH->EH_APLEMP+SubStr(SE5->E5_DOCUMEN,1,10))
					
					While ( SEI->EI_FILIAL+SEI->EI_APLEMP+SEI->EI_NUMERO+SEI->EI_REVISAO+SEI->EI_SEQ==;
						xFilial("SEI")+SEH->EH_APLEMP+SubStr(SE5->E5_DOCUMEN,1,10) )
						RecLock("SEH")
						If SEI->EI_MOTBX == "NOR" 
							If SEI->EI_TIPODOC == "RG"
								SEH->EH_VALREG := Abs(SEI->EI_VALOR)
								SEH->EH_VALREG2:= Abs(SEI->EI_VALOR)
							EndIf
							If SEI->EI_TIPODOC == "I1"
								SEH->EH_VALIRF := Abs(SEI->EI_VALOR)
							EndIf
							If SEI->EI_TIPODOC == "I2" 
								SEH->EH_VALIOF := Abs(SEI->EI_VALOR)
							EndIf
							If SEI->EI_TIPODOC == "SW"
								SEH->EH_VALSWAP:= Abs(SEI->EI_VALOR)
							EndIf
							If SEI->EI_TIPODOC == "I3" 
								SEH->EH_VALISWP:= Abs(SEI->EI_VALOR)
							EndIf
							If SEI->EI_TIPODOC == "I4" 
								SEH->EH_VALOUTR:= Abs(SEI->EI_VALOR)
							EndIf
							If SEI->EI_TIPODOC == "I5" 
								SEH->EH_VALGAP := Abs(SEI->EI_VALOR)
							EndIf
							If SEI->EI_TIPODOC == "VL" 
								SEH->EH_VALCRED:= Abs(SEI->EI_VALOR)
							EndIf
							If SEI->EI_TIPODOC == "JR" 
								SEH->EH_VALJUR := Abs(SEI->EI_VALOR)
								SEH->EH_VALJUR2:= Abs(SEI->EI_VLMOED2)
							EndIf
							If SEI->EI_TIPODOC == "V1" 
								SEH->EH_VALVCLP := Abs(SEI->EI_VALOR)
							EndIf
							If SEI->EI_TIPODOC == "V2" 
								SEH->EH_VALVCCP := Abs(SEI->EI_VALOR)
							EndIf
							If SEI->EI_TIPODOC == "V3" 
								SEH->EH_VALVCJR := Abs(SEI->EI_VALOR)
							EndIf
							If SEI->EI_TIPODOC == "BL" 
								SEH->EH_VALREG  := Abs(SEI->EI_VALOR)
								SEH->EH_VALREG2 := Abs(SEI->EI_VLMOED2)
							EndIf
							If SEI->EI_TIPODOC == "BC" 
								SEH->EH_VALREG := Abs(SEI->EI_VALOR)
								SEH->EH_VALREG2:= Abs(SEI->EI_VLMOED2)
							EndIf
							If SEI->EI_TIPODOC == "BJ" 
								SEH->EH_VALJUR := Abs(SEI->EI_VALOR)
								SEH->EH_VALJUR2:= Abs(SEI->EI_VLMOED2)
							EndIf
							If SEI->EI_TIPODOC == "BP"
								VALOR := Abs(SEI->EI_VALOR)
							EndIf
						EndIf
						MsUnLock()
						dbSelectArea("SEI")
						dbSkip()
					EndDo
					SEI->(DbGoBottom())
					SEI->(DbSkip())
				EndIf
				dbSelectArea("SE5")
				If !lX
					If !Empty(SE5->E5_TIPODOC) .Or.;
						Empty(SE5->E5_NATUREZ)	// Para nao contabilizar totalizar do bordero
						// como movimentacao bancaria a pagar.
						If !(SE5->E5_TIPODOC $ "DB/OD")
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Caracteriza-se lancamento os registros com :		  ³
							//³ E5_TIPODOC = brancos                         		  ³
							//³ E5_TIPODOC = "DB" // Desp Bancaria gerada no FINA200³
							//³ E5_TIPODOC = "OD" // Outras Despesas gerada FINA200 ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							SE5->( dbSkip())
							Loop
						EndIF
					Endif
				Endif
				
				If SE5->E5_RATEIO == "S" .And. CtbInUse()
					cPadrao := "516"
				EndIf
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Posiciona na natureza.										  ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				dbSelectArea( "SED" )
				dbSeek( cFilial+SE5->E5_NATUREZ )
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Posiciona no banco.											  ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				dbSelectArea( "SA6" )
				dbSetOrder(1)
				dbSeek( cFilial+SE5->E5_BANCO+SE5->E5_AGENCIA+SE5->E5_CONTA )
				
				If l370E5P
					Execblock("F370E5P",.F.,.F.)
				Endif
				
				lPadrao:=VerPadrao(cPadrao)
				IF lPadrao
					If SE5->E5_RATEIO != "S"
						If nHdlPrv <= 0
							a370Cabecalho(@nHdlPrv,@cArquivo)
						Endif
						If lUsaFlag
							aAdd(aFlagCTB,{"E5_LA","S","SE5",SE5->(Recno()),0,0,0})
						EndIf
						nTotDoc	:=	DetProva(nHdlPrv,cPadrao,"FINA370",cLote,,,,,,,,@aFlagCTB)
						nTotProc	+= nTotDoc
						nTotal	+=	nTotDoc
						If mv_par12 == 2 
							If nTotDoc > 0 // Por documento
								If lSeqCorr
									aDiario := {{"SE5",SE5->(recno()),SE5->E5_DIACTB,"E5_NODIA","E5_DIACTB"}}
								EndIf
								Ca370Incl(cArquivo,@nHdlPrv,cLote,nTotal,@aFlagCTB,@aDiario)
							Endif
							aFlagCTB := {}
						Endif
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Atualiza Flag de Lan‡amento Cont bil		  ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						If LanceiCtb
							AADD(aRecsSE5,SE5->(RECNO()))
						EndIf
					Else			// Rateio 516 -> somente sigactb!
						If CtbInUse()
							// Devido a estrutura do programa, o rateio ja eh "quebrado"
							// por documento.
							If nHdlPrv <= 0
								a370Cabecalho(@nHdlPrv,@cArquivo)
							EndIf
							RegToMemory("SE5",.F.,.F.)
							If lUsaFlag
								aAdd(aFlagCTB,{"E5_LA","S","SE5",SE5->(Recno()),0,0,0})
							EndIf
							F370RatFin(cPadrao,"FINA370",cLote,4," ",4,,,,@nHdlPrv,@nTotDoc,@aFlagCTB)
							lCabecalho := If(nHdlPrv <= 0, lCabecalho, .T.)
							nTotProc	+= nTotDoc
							nTotal	+=	nTotDoc
							If mv_par12 == 2 
								If nTotDoc > 0 // Por documento
									If lSeqCorr
										aDiario := {{"SE5",SE5->(recno()),SE5->E5_DIACTB,"E5_NODIA","E5_DIACTB"}}
									EndIf
									Ca370Incl(cArquivo,@nHdlPrv,cLote,nTotal,@aFlagCTB,@aDiario)
								Endif
								aFlagCTB := {}
							Endif
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Atualiza Flag de Lan‡amento Cont bil		  ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							If LanceiCtb
								AADD(aRecsSE5,SE5->(RECNO()))
							EndIf
							// Verifica o arquivo de rateio, e apaga o arquivo temporario
							// para que no proximo rateio seja criado novamente
							If Select("TMP1") > 0
								DbSelectArea( "TMP1" )
								cArq := DbInfo(DBI_FULLPATH)
								cArq := AllTrim(SubStr(cArq,Rat("\",cArq)+1))
								DbCloseArea()
								FErase(cArq)
							EndIf
						EndIf
					EndIf
				End
				dbSelectArea("SE5")
				dbSkip()
			End
			
			If mv_par12 == 3 
				If nTotProc > 0 // Por processo
					Ca370Incl(cArquivo,@nHdlPrv,cLote,nTotal,@aFlagCTB)
					nTotProc := 0
				Endif
				aflagCTB := {}
			Endif
		End
		
		If (mv_par06 == 1 .or. mv_par06 == 4) .and. lLerSE5
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Baixas a Receber 														  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			dbSelectArea( "SE5" )
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Variaveis para suporte a Recebimentos Diversos³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				cSELSerie	:= ""
				cSELRecibo	:= ""
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica qual a data a ser utilizada para baixa				  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			cCampo:=IIF(mv_par07 == 1,"SE5->E5_DATA",Iif(mv_par07 == 2,"SE5->E5_DTDIGIT","SE5->E5_DTDISPO"))
			dbSetOrder( nIndex+1 )
			
			dbSeek( cFilial+"R"+dtos(mv_par04),.t.)
			
			While ! SE5->(Eof()) .and. SE5->E5_RECPAG == "R" .and. &cCampo <= mv_par05
							
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ A Data da Contabilizacao de Baixa sera efetuada com base na  ³
				//³ escolha do parametro mv_par07. A variavel dDataBaseAux       ³
				//³ serve para restaurar o valor da variavel dDataBase           ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					dDatabase := &cCampo

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Contabilizacao de Recebimentos Diversos - Tabela SEL³
				//³Executada atraves das movimentacoes no SE5          ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If	!Empty( SE5->(E5_ORDREC + E5_SERREC) ) .And. cPaisLoc == "BRA"
						
						If	( SE5->E5_SERREC + SE5->E5_ORDREC ) <> ( cSELSerie + cSELRecibo )

							cSELSerie	:= SE5->E5_SERREC
							cSELRecibo	:= SE5->E5_ORDREC
						
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³Controle de contabilizacao.              ³
							//³Percorre e contabiliza todos os registros³
							//³de um recibo.                            ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
								F370CTBSEL(	cSELSerie,;
												cSELRecibo,;
												@nTotDoc,;
												cLote,;
												@nHdlPrv,;
												@cArquivo,;
												lUsaFlag,;
												@aFlagCTB;
								)
		

							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³Separa por ?                                      ³
							//³Acumuladores para a geracao do Documento Contabil.³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
								If mv_par12 == 1 .and. nTotDoc > 0		// Por Periodo
									nTotal += nTotDoc
								ElseIf mv_par12 == 2 
									If nTotDoc > 0	// Por Documento
										If lSeqCorr
											aDiario := {{"SE5",SE5->(recno()),SE5->E5_DIACTB,"E5_NODIA","E5_DIACTB"}}
										EndIf
										Ca370Incl(cArquivo,@nHdlPrv,cLote,nTotal,@aFlagCTB,@aDiario)
										nTotDoc := 0 // Inicializa Variavel
									Endif
									aFlagCTB := {}
								ElseIf mv_par12 == 3					// Por Processo
									nTotProc += nTotDoc
								Endif
						EndIf
					    
					   	If AllTrim(SE5->E5_LA) == "S"
							SE5->( DBSkip() ) // Nestes casos a movimentacao nao eh contabilizada pelo SE5
							Loop
						EndIf	
					Endif				
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Nao serao contabilizadas Mov. Fin. Manuais e Transf.Bancaria neste ponto  ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				// Nem aplicacoes, emprestimos, estornos de aplicacoes e estornos de emprestimos
				If Empty(SE5->E5_TIPODOC) .OR. SE5->E5_TIPODOC $ "TR/TE/DB/OD/AP/RF/PE/EP" .Or. SubStr(SE5->E5_LA,1,1) == "S"
					SE5->(dbSkip())
					Loop
				Endif
				
				lAdiant 	:= .f.
				lEstorno 	:= .F.
				lEstRaNcc 	:= .F.
				lCompens 	:= .F.  
				lEstCompens := .F.

				If SE5->E5_TIPODOC == "ES"
					lEstorno := .T.
				Endif
				If SE5->E5_TIPODOC == "ES" .and. SE5->E5_TIPO $ MVRECANT+"/"+MV_CRNEG
					lEstRaNcc := .T.
				Endif

				If SE5->E5_TIPO $ MVPAGANT+"/"+MV_CPNEG
					lAdiant := .T.
				Endif
				
				If  SE5->E5_TIPODOC == "BA" .and. SE5->E5_MOTBX == "CMP"
					lCompens := .T.
				Endif
				
				If SE5->E5_TIPODOC == "ES" .and. SE5->E5_MOTBX == "CMP"
					lEstCompens := .T.
				Endif

				// Despreza inclusao de RA que sera contabilizado pelo SE1
				If SE5->E5_TIPODOC == "RA" .and. SE5->E5_TIPO $ MVRECANT
					AADD(aRecsSE5,SE5->(RECNO()))
					SE5->(dbSkip())
					Loop
				Endif
				
				// Despreza baixas do titulo principal, para nao duplicar.
				If SE5->E5_TIPODOC == "CP" .and. SE5->E5_MOTBX == "CMP"
					AADD(aRecsSE5,SE5->(RECNO()))
					SE5->(dbSkip())
					Loop
				Endif
				
				// Despreza estorno de compensacao do titulo principal, para nao duplicar.
				If SE5->E5_TIPODOC == "ES" .and. SE5->E5_MOTBX == "CMP" .and. !(SE5->E5_TIPO $ MVPAGANT+"/"+MV_CPNEG)
					AADD(aRecsSE5,SE5->(RECNO()))
					SE5->(dbSkip())
					Loop
				Endif

				If (lAdiant .or. lEstorno) .and. !lEstRaNcc
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Ponto de entrada que permite a informacao manual da Filial ³
					//³ para pesquisa na SE2 na contabilizacao off-line            ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ			
					cFilialPesq := xFilial("SE2")
					If ExistBlock("F370INFI")
						cFilialPesq := ExecBlock("F370INFI",.F.,.F.,{cFilialPesq})	               
					Endif										
					
					dbSelectArea("SE2")
					dbSetOrder(1)
					
					If lAdiant
						cFilorig := xFilial("SE2")
					Else
						cFilorig := xFilial("SE5")
					EndIf               
										
					If !(MsSeek(cFilorig+SE5->E5_PREFIXO+SE5->E5_NUMERO+SE5->E5_PARCELA+SE5->E5_TIPO+SE5->E5_CLIFOR+SE5->E5_LOJA))
						If SE5->E5_MOTBX == "CMP" .and. !(MsSeek(SE5->E5_FILORIG+SE5->E5_PREFIXO+SE5->E5_NUMERO+SE5->E5_PARCELA+SE5->E5_TIPO+SE5->E5_CLIFOR+SE5->E5_LOJA))
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Localizada inconsistˆncia no arquivo SE5. A fun‡„o fa370conc	 ³
							//³ pergunta se o usu rio quer continuar ou abandonar.				 ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							If !FA370CONC()
								Break
							Endif
							dbSelectArea("SE5")
							SE5->(dbSkip())
							Loop
						EndIf
					Endif
				Else
					dbSelectArea( "SE1" )
					dbSetOrder( 2 )

					cFilorig := xFilial("SE1")

					If !(MsSeek(cFilOrig+SE5->E5_CLIFOR+SE5->E5_LOJA+SE5->E5_PREFIXO+SE5->E5_NUMERO+SE5->E5_PARCELA+SE5->E5_TIPO ))
						If !Empty(SE5->E5_FILORIG)
							cFilOrig := SE5->E5_FILORIG
						EndIf   
						
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³Caso não encontre o título pelo campo E5_FILORIG, busca pelo campo E5_MSFIL (sigaloja)³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						If  !(MsSeek( cFilOrig +SE5->E5_CLIFOR+SE5->E5_LOJA+SE5->E5_PREFIXO+SE5->E5_NUMERO+SE5->E5_PARCELA+SE5->E5_TIPO )) 
							If mv_par14 == 1 .And. SE5->(FieldPos("E5_MSFIL")) > 0 .and. Substr(SE5->E5_HISTOR,1,4) = "LOJ-"
								cFilOrig := SE5->E5_MSFIL
							EndIf
						EndIf 
						
					Endif  

					
					If !(MsSeek( cFilOrig +SE5->E5_CLIFOR+SE5->E5_LOJA+SE5->E5_PREFIXO+SE5->E5_NUMERO+SE5->E5_PARCELA+SE5->E5_TIPO ))
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Localizada inconsistˆncia no arquivo SE5. A fun‡„o fa370conc	 ³
						//³ pergunta se o usu rio quer continuar ou abandonar.				 ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						If !FA370CONC()
							Break
						Endif
						dbSelectArea("SE5")
						SE5->(dbSkip())
						Loop
					Else
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Carrega variavies para contabilizacao dos    ³
						//³ abatimentos (impostos da lei 10925).         ³			
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					 	dbSelectArea("__SE1")
				 		dbSetOrder( 1 )
						__SE1->(MsSeek(cFilOrig +SE5->(E5_PREFIXO+E5_NUMERO+E5_PARCELA)))
						While __SE1->(!EOF()) .And.;
						      __SE1->(E1_FILIAL + E1_PREFIXO + E1_NUM + E1_PARCELA) ==;
						      (cFilOrig + SE5->(E5_PREFIXO + E5_NUMERO + E5_PARCELA))
							If __SE1->E1_TIPO == MVPIABT
								VALOR5 := __SE1->E1_VALOR			
							ElseIf __SE1->E1_TIPO == MVCFABT
								VALOR6 := __SE1->E1_VALOR
							ElseIf __SE1->E1_TIPO == MVCSABT
								VALOR7 := __SE1->E1_VALOR						
							Endif			
							__SE1->(dbSkip())
						Enddo
					Endif
				Endif
				
				nPis:=0
				nCofins:=0
				nCsll:=0
				nVretPis:=0
				nVretCof:=0
				nVretCsl:=0

				If (lAdiant .or. lEstorno) .and. !lEstRaNcc
					nValLiq	:= SE2->E2_VALLIQ
					nDescont := SE2->E2_DESCONT
					nJuros	:= SE2->E2_JUROS
					nMulta	:= SE2->E2_MULTA
					nCorrec	:= SE2->E2_CORREC
					If lPccBaixa
						nPis		:= SE2->E2_PIS
						nCofins	:= SE2->E2_COFINS
						nCsll		:= SE2->E2_CSLL
						nVretPis := SE2->E2_VRETPIS
						nVretCof := SE2->E2_VRETCOF
						nVretCsl := SE2->E2_VRETCSL
					Endif
				Else
					nValLiq	:= SE1->E1_VALLIQ
					nDescont := SE1->E1_DESCONT
					nJuros	:= SE1->E1_JUROS
					nMulta	:= SE1->E1_MULTA
					nCorrec	:= SE1->E1_CORREC
					cSitOri  := SE1->E1_SITUACA
				Endif
				
				dbSelectArea( "SE5" )
				nVl:=nDc:=nJr:=nMt:=nCm:=0
				lTitulo := .F.
				cSeq	  :=	SE5->E5_SEQ
				cBanco  := " "
				nRegSE5 := 0
				nRegOrigSE5 := 0
				
				If (lAdiant .or. lEstorno) .and. !lEstRaNcc
					cChaveSe5 := "xFilial()==SE5->E5_FILIAL.And.SE2->E2_PREFIXO==SE5->E5_PREFIXO.And.SE2->E2_NUM==SE5->E5_NUMERO.And.SE2->E2_PARCELA==SE5->E5_PARCELA.And.SE2->E2_TIPO==SE5->E5_TIPO.And.cSeq==SE5->E5_SEQ .And. SE5->E5_CLIFOR+SE5->E5_LOJA == SE2->E2_FORNECE+SE2->E2_LOJA"
				Else
					cChaveSe5 := "xFilial()==SE5->E5_FILIAL.And.SE1->E1_PREFIXO==SE5->E5_PREFIXO.And.SE1->E1_NUM==SE5->E5_NUMERO.And.SE1->E1_PARCELA==SE5->E5_PARCELA.And.SE1->E1_TIPO==SE5->E5_TIPO.And.cSeq==SE5->E5_SEQ .And.SE5->E5_CLIFOR+SE5->E5_LOJA==SE1->E1_CLIENTE+SE1->E1_LOJA"
				Endif
				lAchouSE5:=.F.
				While !SE5->(Eof()) .And. &cChaveSE5 
					lAchouSE5:=.T.
					If !(SE5->E5_RECPAG == "R" .and. &cCampo <= mv_par05)
						Exit
					Endif
					
					If &cCampo > mv_par05
						Exit
					Endif

					nPisBx := 0
					nCofBx := 0
					nCslBx := 0
				
					dbSelectArea("SE5")
					
					If  SE5->E5_TIPODOC $ "BAüVLüV2üES/LJ"
						nVl	  := E5_VALOR
						cBanco  := SE5->E5_BANCO+SE5->E5_AGENCIA+SE5->E5_CONTA
						nRegSE5 := SE5->(Recno())
						cSitCob := " "
						If !Empty(SE5->E5_SITCOB)
							cSitCob := SE5->E5_SITCOB
						Endif
						lMultnat := SE5->E5_MULTNAT == "1"
						cSeqSE5	:= SE5->E5_SEQ
						If lPccBaixa
							IF Empty(SE5->E5_PRETPIS)
								nPisBx := SE5->E5_VRETPIS
								nCofBx := SE5->E5_VRETCOF
								nCslBx := SE5->E5_VRETCSL
							Endif
						Endif
					ElseIf SE5->E5_TIPODOC $ "DCüD2"
						nDc	  := E5_VALOR
						If nRegSE5 == 0; nRegSE5 := SE5->(Recno()); Endif
					ElseIf SE5->E5_TIPODOC $ "JRüJ2üTL"
						nJr	  := E5_VALOR
						If nRegSE5 == 0; nRegSE5 := SE5->(Recno()); Endif
					ElseIf SE5->E5_TIPODOC $ "MTüM2"
						nMt := E5_VALOR
						If nRegSE5 == 0; nRegSE5 := SE5->(Recno()); Endif
					ElseIf SE5->E5_TIPODOC $ "CMüC2"
						nCm := E5_VALOR
						If nRegSE5 == 0; nRegSE5 := SE5->(Recno()); Endif
					Endif

					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Atualiza Flag de Lan‡amento Cont bil		  ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					lTitulo := .T.
					nRegAnt := SE5->(RecNo())
					/// proteção existente por falha do DB2 AS400 não executar corretamente o dbSkip()
					If (aScan(aRecsSE5,{|x| x==nRegAnt}) == 0)
						AADD(aRecsSE5,SE5->(RECNO()))
					Endif
					SE5->(dbSkip())
					WHILE SE5->(!EOF()) .AND. (aScan(aRecsSE5,{|x| x==(SE5->(Recno())) }) > 0)
						SE5->(dbSkip())
						LOOP
					ENDDO
					nReg := SE5->(Recno())
					SE5->(DbGoto(nRegAnt))
					If lUsaFlag
						aAdd(aFlagCTB,{"E5_LA","S"+SubStr(E5_LA,2,1),"SE5",SE5->(Recno()),0,0,0})
					EndIf
					SE5->(dbGoto(nReg))
					dbSelectArea("SE5")
				Enddo
				
				If !lAchouSE5
					If nRegSE5 == 0; nRegSE5 := SE5->(Recno()); Endif
					SE5->(DbSkip())
				EndIf
				If lTitulo
					If (lAdiant .or. lEstorno) .and. !lEstRaNcc
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Protecao provisoria: lTitulo .T. sem SE2   ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
   	                	IF SE2->(!EOF()) .AND. SE2->(!BOF())
							Reclock( "SE2" )
							Replace E2_VALLIQ  With nVl
							Replace E2_DESCONT With nDc
							Replace E2_JUROS	 With nJr
							Replace E2_MULTA	 With nMt
							Replace E2_CORREC  With nCm
							If lPccBaixa
								Replace E2_PIS		With nPisBx
								Replace E2_COFINS	With nCofBx
								Replace E2_CSLL	With nCslBx
								Replace E2_VRETPIS	With nPisBx
								Replace E2_VRETCOF	With nCofBx
								Replace E2_VRETCSL	With nCslBx
							Endif
							SE2->(MsUnlock())
						Endif
					Else

						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Protecao provisoria: lTitulo .T. sem SE1   ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
                    	IF SE1->(!EOF()) .AND. SE1->(!BOF())
							Reclock( "SE1" )
							Replace E1_VALLIQ  With nVl
							Replace E1_DESCONT With nDc
							Replace E1_JUROS   With nJr
							Replace E1_MULTA   With nMt
							Replace E1_CORREC  With nCm
							If !Empty(cSitCob)
								Replace E1_SITUACA With cSitCob
							Endif
							SE1->( MsUnlock())
						Endif
					Endif
				Endif
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Posiciona no cliente/fornecedor 						  ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If lTitulo
					If (lAdiant .or. lEstorno) .and. !lEstRaNcc
						dbSelectArea("SA2")
						dbSeek(xFilial()+SE2->E2_FORNECE+SE2->E2_LOJA)
						dbSelectArea( "SED" )
						dbSeek( xFilial()+SE2->E2_NATUREZ )
					Else
						dbSelectArea( "SA1" )
						dbSeek( cFilial+SE1->E1_CLIENTE+SE1->E1_LOJA )
						dbSelectArea( "SED" )
						dbSeek( cFilial+SE1->E1_NATUREZ )
					Endif
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Posiciona no banco. 										  ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					dbSelectArea( "SA6" )
					dbSetOrder(1)
					dbSeek( xFilial("SA6")+cBanco)
				Endif
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Posiciona o arquivo SE5 para que os lan‡amentos  ³
				//³ cont beis possam localizar o motivo da baixa.	  ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				nRegOrigSE5 := 0
				if  nRegSE5 > 0
					nRegOrigSE5 := SE5->(Recno())
					SE5->(dbGoTo(nRegSE5))
				Endif
				If lAdiant .and. !lEstCompens
					cPadrao := "530"
				ElseIf lEstCompens  //Estorno Compensacao Pagar
					cPadrao := "589"				
				Elseif lEstorno
					cPadrao := "531"
				ElseIf lCompens
					cPadrao := "596"
				Else
					dbSelectArea( "SE1" )
					If cPaisLoc == "CHI" .And. SE5->E5_MOTBX == "DEV"
						cPadrao := "574"
					Else
						cPadrao := fa070Pad()
					EndIf
				Endif
				lPadrao := VerPadrao(cPadrao)
	            lCtbPls := (lCtPlsCBCP .or. lCtPlsBCR) .and. substr(SE1->E1_ORIGEM,1,3) == "PLS"
				lPadraoCc := VerPadrao("536") //Rateio por C.Custo de MultiNat C.Receber
				lPadraoCcE := VerPadrao("539") //Estorno do rateio C.Custo de MultiMat CR
				IF lAchouSE5
					IF lPadrao .or. lCtbPls
						If !lCabecalho
							a370Cabecalho(@nHdlPrv,@cArquivo)
						Endif
						//Contabilizando estorno de C.Pagar
						If lEstorno
							cChaveSev := RetChaveSev("SE2")+"2"+cSeqSE5
							cChaveSez := RetChaveSev("SE2",,"SEZ")
						Else
							cChaveSev := RetChaveSev("SE1")+"2"+cSeqSE5
							cChaveSez := RetChaveSev("SE1",,"SEZ")
						Endif
						
						DbSelectArea("SEV")
						dbSetOrder(2)
						// Se utiliza multiplas naturezas, contabiliza pelo SEV
						If ! lCtbPls .And. lMultNat .And. MsSeek(cChaveSev)
							dbSelectArea("SE1")
							nRecSe1 := Recno()
							DbGoBottom()
							DbSkip()
							dbSelectArea("SE2")
							nRecSe2 := Recno()
							DbGoBottom()
							DbSkip()
							
							DbSelectArea("SEV")
							
							While xFilial("SEV")+SEV->(EV_PREFIXO+EV_NUM+EV_PARCELA+EV_TIPO+EV_CLIFOR+;
								EV_LOJA+EV_IDENT+EV_SEQ) == cChaveSev .And. !Eof()
								
								//Se estou contabilizando um estorno, trata-se de um C. Pagar,
								//So vou contabilizar os EV_SITUACA == E
								If (lEstorno .and. !(SEV->EV_SITUACA == "E")) .or. ;
									(!lEstorno .and. (SEV->EV_SITUACA == "E"))
									//Se nao for um estorno, nao devo contabilizar o registro se
									//EV_SITUACA == E
									dbSkip()
									Loop
								ElseIf lEstorno
									//O lancamento a ser considerado passa a ser o do estorno
									lPadraoCC := lPadraoCCE
								Endif
								
								If SEV->EV_LA != "S"
									dbSelectArea( "SED" )
									MsSeek( xFilial("SED")+SEV->EV_NATUREZ ) // Posiciona na natureza, pois a conta pode estar la.
									dbSelectArea("SEV")
									If SEV->EV_RATEICC == "1" .and. lPadraoCC .and. lPadrao // Rateou multinat por c.custo
										dbSelectArea("SEZ")
										dbSetOrder(4)
										MsSeek(cChaveSeZ+SEV->EV_NATUREZ+"2"+cSeqSE5) // Posiciona no arquivo de Rateio C.Custo da MultiNat
										While !Eof() .and. xFilial("SEZ")+SEZ->(EZ_PREFIXO+EZ_NUM+;
											EZ_PARCELA+EZ_TIPO+EZ_CLIFOR+EZ_LOJA+EZ_NATUREZ+EZ_IDENT+EZ_SEQ) == cChaveSeZ+SEV->EV_NATUREZ+"2"+cSeqSE5
											
											//Se estou contabilizando um estorno, trata-se de um C. Pagar,
											//So vou contabilizar os EZ_SITUACA == E
											//Se nao for um estorno, nao devo contabilizar o registro se
											//EZ_SITUACA == E
											If (lEstorno .and. !(SEZ->EZ_SITUACA == "E")) .or. ;
												(!lEstorno .and. (SEZ->EZ_SITUACA == "E"))
												dbSkip()
												Loop
											Endif
											If SEZ->EZ_LA != "S"
	
												aAdd(aFlagCTB,{"EZ_LA","S","SEZ",SEZ->(Recno()),0,0,0})
												//O lacto padrao fica:
												//536 - Rateio multinat com c.custo C.Receber
												//539 - Estorno de Rat. Multinat C.Custo C.Pagar
												cPadraoCC := If(SEZ->EZ_SITUACA == "E","539","536")
												VALOR := SEZ->EZ_VALOR
												nTotDoc	+=	DetProva(nHdlPrv,cPadraoCC,"FINA370",cLote,,,,,,,,@aFlagCTB)
												If LanceiCtb // Vem do DetProva
													If !lUsaFlag
														RecLock("SEZ")
														SEZ->EZ_LA    := "S"
														MsUnlock( )
													EndIf 
												ElseIf lUsaFlag
													If (nPosReg  := aScan(aFlagCTB,{ |x| x[4] == SEZ->(Recno()) }))>0
														aFlagCTB := Adel(aFlagCTB,nPosReg)
														aFlagCTB := aSize(aFlagCTB,Len(aFlagCTB)-1)
													Endif													
												Endif
											Endif
											dbSkip()
										Enddo
										DbSelectArea("SEV")
									Else
										If lUsaFlag
											aAdd(aFlagCTB,{"EV_LA","S","SEV",SEV->(Recno()),0,0,0})
										EndIf
										nTotDoc	:=	DetProva(nHdlPrv,cPadrao,"FINA370",cLote,,,,,,,,@aFlagCTB)
									Endif
									If LanceiCtb // Vem do DetProva
										If !lUsaFlag
											RecLock("SEV")
											SEV->EV_LA    := "S"
											MsUnlock( )
										EndIf  
									ElseIf lUsaFlag
										If (nPosReg  := aScan(aFlagCTB,{ |x| x[4] == SEV->(Recno()) }))>0
											aFlagCTB := Adel(aFlagCTB,nPosReg)
											aFlagCTB := aSize(aFlagCTB,Len(aFlagCTB)-1)
										Endif										
									Endif
								Endif
								DbSelectArea("SEV")
								DbSkip()
								VALOR := 0
							Enddo
							nTotal  	+=	nTotDoc
							nTotProc	+=	nTotDoc // Totaliza por processo
							
							If mv_par12 == 2 
								If nTotDoc > 0 // Por documento
									Ca370Incl(cArquivo,@nHdlPrv,cLote,nTotal,@aFlagCTB)
									nTotDoc := 0
								Endif
								aFlagCTB := {}
							Endif
							
							dbSelectArea("SE2")
							DbGoto(nRecSe2)
							
							dbSelectArea("SE1")
							DbGoto(nRecSe1)
						Else
							dbSelectArea("SEV")
							DbGoBottom()
							DbSkip()
							DbSelectArea("SE1")
							If SE1->E1_TIPO == MVPIABT
								VALOR5 := SE1->E1_VALOR			
							ElseIf SE1->E1_TIPO == MVCFABT
								VALOR6 := SE1->E1_VALOR
							ElseIf SE1->E1_TIPO == MVCSABT
								VALOR7 := SE1->E1_VALOR			
							Endif	
							If lCompens
								STRLCTPAD := SE5->E5_DOCUMEN
							EndIf
	                        If  lEstorno
	                            lCtbPls := lCtPlsCBCP .and. substr(SE2->E2_ORIGEM,1,3) == "PLS"
	                            cTipoLP := "CBCP"
	                        Else
	                            lCtbPls := lCtPlsBCR  .and. substr(SE1->E1_ORIGEM,1,3) == "PLS"
	                            cTipoLP := "BCR"
	                        Endif
	                        If  lCtbPls          
	                            If   cTipoLP == "BCR"
	                                 nTotDoc := PlsCtbSe1(nHdlPrv,cPadrao,"FINA370",cLote,,,,,,,,@aFlagCTB,cTipoLP,aRegBFQ)
	                             Else
	   							     nTotDoc := PlsCtbSe2(nHdlPrv,cPadrao,"FINA370",cLote,,,,,,,,@aFlagCTB,cTipoLP)
	                            EndIf 
	                        Else
						    	nTotDoc	:=	DetProva(nHdlPrv,cPadrao,"FINA370",cLote,,,,,,,,@aFlagCTB)
						    EndIf
							nTotProc	+= nTotDoc
							nTotal	+=	nTotDoc
							If mv_par12 == 2 
								If nTotDoc > 0 // Por documento
									Ca370Incl(cArquivo,@nHdlPrv,cLote,nTotal,@aFlagCTB)
								Endif
								aFlagCTB := {}
							Endif
						Endif
					Endif
				Endif	
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Devolve a posi‡„o original do arquivo  ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If nRegOrigSE5 > 0
					SE5->(dbGoTo(nRegOrigSE5))
				Endif
				If !lAdiant .and. !lEstorno
					dbSelectArea("SE1")
					If !Eof() .And. !Bof()
						Reclock( "SE1" )
						Replace E1_VALLIQ  With nValliq
						Replace E1_DESCONT With nDescont
						Replace E1_JUROS	 With nJuros
						Replace E1_MULTA	 With nMulta
						Replace E1_CORREC  With nCorrec
						Replace E1_SITUACA With cSitOri
						SE1->( MsUnlock( ) )
					EndIF
				Else
					dbSelectArea("SE2")
					If !Eof() .And. !Bof()
						Reclock( "SE2" )
						Replace E2_VALLIQ  With nValliq
						Replace E2_DESCONT With nDescont
						Replace E2_JUROS	 With nJuros
						Replace E2_MULTA	 With nMulta
						Replace E2_CORREC  With nCorrec
						If lPccBaixa
							Replace E2_PIS		With nPis
							Replace E2_COFINS	With nCofins
							Replace E2_CSLL	With nCsll
							Replace E2_VRETPIS	With nVretPis
							Replace E2_VRETCOF	With nVretCof
							Replace E2_VRETCSL	With nVretCsl
						Endif
						SE2->( MsUnlock())
					EndIf
				Endif
				dbSelectArea("SE5")                       	
			Enddo
			
			If mv_par12 == 3 
				If nTotProc > 0 // Por processo
					Ca370Incl(cArquivo,@nHdlPrv,cLote,nTotal,@aFlagCTB)
					nTotProc := 0
				Endif
				aflagCTB := {}
			Endif
			dbSelectArea( "SE5" )
		Endif
		
		If (mv_par06 == 2 .or. mv_par06 == 4) .and. lLerSE5
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Baixas a Pagar															  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			dbSelectArea( "SE5" )
			VALOR 		:= 0
			VALOR2		:= 0
			VALOR3		:= 0
			VALOR4		:= 0
			VALOR5		:= 0
			
			nValorTotal := 0
			nBordero	:= 0
			nTotBord	:= 0
			nBordDc		:= 0
			nBordJr		:= 0
			nBordMt		:= 0
			nBordCm		:= 0
			                                        	
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica qual a data a ser utilizada para baixa				  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			cCampo:=IIF(mv_par07 == 1,"SE5->E5_DATA",Iif(mv_par07 == 2,"SE5->E5_DTDIGIT","SE5->E5_DTDISPO"))
			dbSetOrder( nIndex+1 )
			dbSeek( cFilial +"P"+dTos(mv_par04),.T.)
			cNumBor := ""
			While !SE5->(Eof()) .And. SE5->E5_RECPAG == "P" .and. &cCampo <= mv_par05
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Nao serao contabilizadas Mov. Fin. Manuais e Transf.Bancaria neste ponto  ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				// Nem aplicacoes, emprestimos, estornos de aplicacoes e estornos de emprestimos
				If Empty(SE5->E5_TIPODOC) .OR. SE5->E5_TIPODOC $ "TR/TE/DB/OD/LJ/AP/RF/PE/EP" .Or. SubStr(SE5->E5_LA,1,1) == "S"
					SE5->(dbSkip())                                                    
					Loop
				Endif
				
				lAdiant := .F.
				lEstorno := .F.
				lEstPaNdf := .F.
				lEstCart2 := .F.
				lCompens  := .F.
				lEstCompens := .F.
				
				IF SE5->E5_TIPODOC == "ES"
					lEstorno := .T.
				Endif
				
				IF SE5->E5_TIPODOC == "E2"
					lEstCart2 := .T.
				Endif
				
				IF SE5->E5_TIPO $ MVPAGANT+"/"+MV_CPNEG .and. SE5->E5_TIPODOC == "ES"
					lEstPaNdf := .T.
				Endif
				
				If SE5->E5_TIPODOC == "ES" .and. SE5->E5_MOTBX == "CMP"
					lEstCompens := .T.
				Endif

				IF SE5->E5_TIPO $ MVRECANT+"/"+MV_CRNEG
					lAdiant := .T.
				Endif
				
				If SE5->E5_TIPODOC == "BA" .and. SE5->E5_MOTBX == "CMP"
					lCompens := .T.
				Endif

				// Despreza inclusao de PA que sera contabilizado pelo SE2
				If SE5->E5_TIPODOC == "PA" .and. SE5->E5_TIPO $ MVPAGANT
					SE5->(dbSkip())
					Loop
				Endif

				// Despreza baixas do titulo principal, para nao duplicar.
				If SE5->E5_TIPODOC == "CP" .and. SE5->E5_MOTBX == "CMP"
					AADD(aRecsSE5,SE5->(RECNO()))
					SE5->(dbSkip())
					Loop
				Endif
				
				// Despreza estorno de compensacao do titulo principal, para nao duplicar.
				If SE5->E5_TIPODOC == "ES" .and. SE5->E5_MOTBX == "CMP" .and. !(SE5->E5_TIPO $ MVRECANT+"/"+MV_CRNEG)
					AADD(aRecsSE5,SE5->(RECNO()))
					SE5->(dbSkip())
					Loop
				Endif

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Apenas contabilza se :                                       ³
				//³ For realmente uma baixa de contas a PAGAR                    ³
				//³ mv_ctbaixa diferente de "C" - Cheque                         |
				//³ Ou se for igual a C e for uma baixa no banco caixa			  |
				//³______________________________________________________________|
				If !lAdiant .and. !lEstorno .and. !lEstCart2
					If cCtBaixa == "C" .And. SE5->E5_MOTBX == "NOR"  .And.;
						!(Substr(SE5->E5_BANCO,1,2)=="CX" .or. SE5->E5_BANCO$cCarteira)
						SE5->(dbSkip())
						Loop
					Endif
				Endif
				
				// A baixa de adiantamento ou estorno de baixa a receber gera registro a pagar
				If (lAdiant .or. lEstorno .or. lEstCart2) .and. !lEstPaNdf
					dbSelectArea("SE1")
					dbSetOrder(2)
					If !(MsSeek(xFilial("SE1")+SE5->E5_CLIFOR+SE5->E5_LOJA+SE5->E5_PREFIXO+SE5->E5_NUMERO+SE5->E5_PARCELA+SE5->E5_TIPO))
						If SE5->E5_MOTBX == "CMP" .and. !(MsSeek(SE5->E5_FILORIG+SE5->E5_CLIFOR+SE5->E5_LOJA+SE5->E5_PREFIXO+SE5->E5_NUMERO+SE5->E5_PARCELA+SE5->E5_TIPO))
						   If !(mv_par14 == 1 .and. SE5->(FieldPos("E5_MSFIL")) > 0 .and. (MsSeek(SE5->E5_MSFIL+SE5->E5_CLIFOR+SE5->E5_LOJA+SE5->E5_PREFIXO+SE5->E5_NUMERO+SE5->E5_PARCELA+SE5->E5_TIPO)) .And. Substr(SE1->E1_ORIGEM,1,4) == "LOJA")
						   
								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//³ Localizada inconsistˆncia no arquivo SE5. A fun‡„o fa370conc	 ³
								//³ pergunta se o usu rio quer continuar ou abandonar.				 ³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
								If !FA370CONC()
									Break
								Endif
								dbSelectArea("SE5")
								SE5->(dbSkip())
								Loop 
						   EndIf
						EndIf
					Endif
				Else
					dbSelectArea( "SE2" )
					dbSetOrder( 1 )
					cFilorig := xFilial("SE2")
					
					If !(MsSeek( cFilOrig +SE5->E5_PREFIXO+SE5->E5_NUMERO+SE5->E5_PARCELA+SE5->E5_TIPO+SE5->E5_CLIFOR+SE5->E5_LOJA))
						If !Empty(SE5->E5_FILORIG)
							cFilOrig := SE5->E5_FILORIG
						Endif
					Endif
					
					If !(MsSeek( cFilOrig +SE5->E5_PREFIXO+SE5->E5_NUMERO+SE5->E5_PARCELA+SE5->E5_TIPO+SE5->E5_CLIFOR+SE5->E5_LOJA))
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Localizada inconsistˆncia no arquivo SE5. A fun‡„o fa370conc	 ³
						//³ pergunta se o usu rio quer continuar ou abandonar.				 ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						If !FA370CONC()
							Break
						Endif
						dbSelectArea("SE5")
						SE5->(dbSkip())
						Loop
					Endif
				Endif
				
				nPis:=0
				nCofins:=0
				nCsll:=0
				nVretPis:=0
				nVretCof:=0
				nVretCsl:=0
				
				If (lAdiant .or. lEstorno .or. lEstCart2) .and. !lEstPaNdf
					nValLiq	:= SE1->E1_VALLIQ
					nDescont := SE1->E1_DESCONT
					nJuros	:= SE1->E1_JUROS
					nMulta	:= SE1->E1_MULTA
					nCorrec	:= SE1->E1_CORREC
				Else
					nValLiq	:= SE2->E2_VALLIQ
					nDescont := SE2->E2_DESCONT
					nJuros	:= SE2->E2_JUROS
					nMulta	:= SE2->E2_MULTA
					nCorrec	:= SE2->E2_CORREC
					If lPccBaixa
						nPis		:= SE2->E2_PIS
						nCofins	:= SE2->E2_COFINS
						nCsll		:= SE2->E2_CSLL
						nVretPis := SE2->E2_VRETPIS
						nVretCof := SE2->E2_VRETCOF
						nVretCsl := SE2->E2_VRETCSL
					Endif
				Endif
				
				dbSelectArea( "SE5" )
				nVl:=nDc:=nJr:=nMt:=nCm:=0
				lTitulo := .F.
				cSeq	  :=	SE5->E5_SEQ
				cBanco  := " "
				nRegSE5 := 0
				nRegOrigSE5 := 0
				
				If (lAdiant .or. lEstorno .or. lEstCart2) .and. !lEstPaNdf
					cChaveSe5 := "xFilial()==SE5->E5_FILIAL.And.SE1->E1_PREFIXO==SE5->E5_PREFIXO.And.SE1->E1_NUM==SE5->E5_NUMERO.And.SE1->E1_PARCELA==SE5->E5_PARCELA.And.SE1->E1_TIPO==SE5->E5_TIPO.And.cSeq==SE5->E5_SEQ .And.SE5->E5_CLIFOR+SE5->E5_LOJA==SE1->E1_CLIENTE+SE1->E1_LOJA"
				Else
					cChaveSe5 := "xFilial()==SE5->E5_FILIAL.And.SE2->E2_PREFIXO==SE5->E5_PREFIXO.And.SE2->E2_NUM==SE5->E5_NUMERO.And.SE2->E2_PARCELA==SE5->E5_PARCELA.And.SE2->E2_TIPO==SE5->E5_TIPO.And.cSeq==SE5->E5_SEQ .And. SE5->E5_CLIFOR+SE5->E5_LOJA == SE2->E2_FORNECE+SE2->E2_LOJA"
				Endif
				
				cNumBor := SE5->E5_DOCUMEN
				STRLCTPAD := SE5->E5_DOCUMEN
				If SE5->(FieldPos("E5_FORNADT")) > 0
					CODFORCP := SE5->E5_FORNADT
					LOJFORCP := SE5->E5_LOJAADT
				EndIf
				lAchouSE5:=.F.
				While  !SE5->(Eof()) .And. &cChaveSE5 
					lAchouSE5:=.T.
					dbSelectArea("SE5")
					
					// Se nao satisfizer a primeira condicao, Despreza o registro
					If !(SE5->E5_RECPAG == "P" .and. &cCampo <= mv_par05)
						Exit
					Endif
					
					If &cCampo > mv_par05
						Exit
					Endif

					nPisBx := 0
					nCofBx := 0
					nCslBx := 0
					
					If	SE5->E5_TIPODOC $ "BAüVLüV2üES/LJ/E2"
						cBanco  := SE5->E5_BANCO+SE5->E5_AGENCIA+SE5->E5_CONTA
						cCheque := SE5->E5_NUMCHEQ
						nVl	  := SE5->E5_VALOR
						nRegSE5 := SE5->(Recno())
						lMultnat := SE5->E5_MULTNAT == "1"
						cSeqSE5	:= SE5->E5_SEQ
						If lPccBaixa
							//"" - Retido na baixa ou 4 - Retido no Bordero(Fina241)
							IF Empty(SE5->E5_PRETPIS) .Or. SE5->E5_PRETPIS == "4" 
								nPisBx := SE5->E5_VRETPIS
								nCofBx := SE5->E5_VRETCOF
								nCslBx := SE5->E5_VRETCSL
							Endif
						Endif
					ElseIf SE5->E5_TIPODOC $ "DCüD2"
						nDc	  := SE5->E5_VALOR
						If nRegSE5 == 0; nRegSE5 := SE5->(Recno()); Endif
					ElseIf SE5->E5_TIPODOC $ "JRüJ2/TL"
						nJr	  := SE5->E5_VALOR
						If nRegSE5 == 0; nRegSE5 := SE5->(Recno()); Endif
					ElseIf SE5->E5_TIPODOC $ "MTüM2"
						nMt := SE5->E5_VALOR
						If nRegSE5 == 0; nRegSE5 := SE5->(Recno()); Endif
					ElseIf SE5->E5_TIPODOC $ "CMüC2"
						nCm := SE5->E5_VALOR
						If nRegSE5 == 0; nRegSE5 := SE5->(Recno()); Endif
					Endif
					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Atualiza Flag de Lan‡amento Cont bil		  ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					nRegAnt := SE5->(Recno())         
					/// proteção existente por falha do DB2 AS400 não executar corretamente o dbSkip()
					If (aScan(aRecsSE5,{|x| x==nRegAnt}) == 0)
						AADD(aRecsSE5,SE5->(RECNO()))
					Endif
					SE5->(dbSkip())
					WHILE SE5->(!EOF()) .AND. (aScan(aRecsSE5,{|x| x==(SE5->(Recno())) }) > 0)
						SE5->(dbSkip())
						LOOP
					ENDDO
					///////////// Proteção AS 400 - Fim //////////////
					cProxBor := SE5->E5_DOCUMEN
					nReg := Recno()
					SE5->(DbGoto(nRegAnt))
					If lUsaFlag
						aAdd(aFlagCTB,{"E5_LA","S"+SubStr(SE5->E5_LA,2,1),"SE5",SE5->(Recno()),0,0,0})
					EndIf
					lTitulo := .T.
					dbGoto(nReg)
				EndDO
				
				If !lAchouSE5
					If nRegSE5 == 0
						nRegSE5 := SE5->(Recno())
					Endif
					SE5->(DbSkip())
				EndIf
				If lTitulo
					If (lAdiant .or. lEstorno .or. lEstCart2) .and. !lEstPaNdf
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Protecao provisoria: lTitulo .T. sem SE1   ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
                    	IF SE1->(!EOF()) .AND. SE1->(!BOF())
							Reclock( "SE1" )
							Replace E1_VALLIQ  With nVl
							Replace E1_DESCONT With nDc
							Replace E1_JUROS	 With nJr
							Replace E1_MULTA	 With nMt
							Replace E1_CORREC  With nCm
							SE1->( MsUnlock())
						Endif
					Else
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Protecao provisoria: lTitulo .T. sem SE2   ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
                    	IF SE2->(!EOF()) .AND. SE2->(!BOF())
							Reclock( "SE2" )
							Replace E2_VALLIQ  With nVl
							Replace E2_DESCONT With nDc
							Replace E2_JUROS	 With nJr
							Replace E2_MULTA	 With nMt
							Replace E2_CORREC  With nCm
							If lPccBaixa
								Replace E2_PIS		With nPisBx
								Replace E2_COFINS	With nCofBx
								Replace E2_CSLL	With nCslBx
								Replace E2_VRETPIS	With nPisBx
								Replace E2_VRETCOF	With nCofBx
								Replace E2_VRETCSL	With nCslBx
							Endif
							SE2->(MsUnlock())
						Endif
					Endif
				Endif
				
				If lTitulo
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Posiciona no fornecedor. 									  ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If (lAdiant .or. lEstorno .or. lEstCart2) .and. !lEstPaNdf
						dbSelectArea( "SA1" )
						dbSeek( cFilial+SE1->E1_CLIENTE+SE1->E1_LOJA )
						dbSelectArea( "SED" )
						dbSeek( cFilial+SE1->E1_NATUREZ )
					Else
						dbSelectArea("SA2")
						dbSeek(xFilial()+SE2->E2_FORNECE+SE2->E2_LOJA)
						dbSelectArea( "SED" )
						dbSeek( xFilial()+SE2->E2_NATUREZ )
						if !Empty( SE2->E2_NUMBOR )
							nValorTotal += SE2->E2_VALLIQ
						endif
					Endif
					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Posiciona no banco.											  ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					dbSelectArea( "SA6" )
					dbSetOrder(1)
					dbSeek( cFilial+cBanco)
					dbSelectArea( "SE5" )
				Endif
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Posiciona o arquivo SE5 para que os lan‡amentos  ³
				//³ cont beis possam localizar o motivo da baixa. 	  ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				nRegOrigSE5 := 0
				If nRegSE5 > 0
					nRegOrigSE5 := SE5->(Recno())
					SE5->(dbGoTo(nRegSE5))
				Endif
				
				If lEstorno .and. lEstPaNdf .and. !lEstCompens
					cPadrao := "531"
				ElseIf lEstCompens  //Estorno Compensacao Receber
					cPadrao := "588"									
				ElseIf lEstorno
					cPadrao := "527"
				Elseif lEstCart2
					cPadrao := "540"
				ElseIf lAdiant
					dbSelectArea( "SE1" )
					cPadrao := fa070Pad()
				Elseif lCompens
					cPadrao := "597"
				Else
					cPadrao := Iif(Empty(SE5->E5_DOCUMEN) .Or. SE5->E5_MOTBX=="PCC","530","532")
					
					// Totalizo por Bordero
					
					If cPadrao = "532" .And. mv_par13 = 2
						nBordero 	+= SE2->E2_VALLIQ
						nTotBord 	+= SE2->E2_VALLIQ
						nBordDc		+= SE2->E2_DESCONT
						nBordJr		+= SE2->E2_JUROS
						nBordMt		+= SE2->E2_MULTA
						nBordCm		+= SE2->E2_CORREC
					Endif
					
					// Disponibilizo a Variavel VALOR com o total dos borderos aglutinados
					
					If cPadrao = "532" .And. cProxBor <> cNumBor
						VALOR 		:= nBordero
						VALOR2		:= nBordDc
						VALOR3		:= nBordJr
						VALOR4		:= nBordMt
						VALOR5		:= nBordCm
						
						nBordero 	:= 0.00
						nBordDc		:= 0
						nBordJr		:= 0
						nBordMt		:= 0
						nBordCm		:= 0
					Else
						VALOR 		:= 0.00
						VALOR2		:= 0.00
						VALOR3		:= 0.00
						VALOR4		:= 0.00
						VALOR5		:= 0.00
					Endif
				Endif
				lPadrao := VerPadrao(cPadrao)
            lCtbPls := (lCtPlsCBCR .or. lCtPlsBCP) .and. substr(SE2->E2_ORIGEM,1,3) == "PLS"
				lPadraoCc := VerPadrao("537") //Rateio por C.Custo de MultiNat C.Pagar
				lPadraoCcE := VerPadrao("538") //Estorno do rateio C.Custo de MultiMat CR
				IF lAchouSE5
					IF  lPadrao .or. lCtbPls
						If !lCabecalho
							a370Cabecalho(@nHdlPrv,@cArquivo)
						Endif
	
						// Se utiliza multiplas naturezas, contabiliza pelo SEV
						If ! lCtbPls .And. lMultNat 						
							//Contabilizando estorno de C.Receber
							If lEstorno
								cChaveSev := RetChaveSev("SE1")+"2"+cSeqSE5
								cChaveSez := RetChaveSev("SE1",,"SEZ")
							Else
								cChaveSev := RetChaveSev("SE2")+"2"+cSeqSE5
								cChaveSez := RetChaveSev("SE2",,"SEZ")
							Endif
					
							DbSelectArea("SEV")
							dbSetOrder(2)
							If MsSeek(cChaveSev)
	
								dbSelectArea("SE2")
								nValorTotal -= SE2->E2_VALLIQ							
	
								nRecSe2 := Recno()
								DbGoBottom()
								DbSkip()
								
								dbSelectArea("SE1")
								nRecSe1 := Recno()
								DbGoBottom()
								DbSkip()
								
								DbSelectArea("SEV")
		
								While xFilial("SEV")+SEV->(EV_PREFIXO+EV_NUM+EV_PARCELA+EV_TIPO+EV_CLIFOR+;
									EV_LOJA+EV_IDENT+EV_SEQ) == cChaveSev .And. !Eof()
									
									//Se estou contabilizando um estorno, trata-se de um C. Pagar,
									//So vou contabilizar os EV_SITUACA == E
									//Se nao for um estorno, nao devo contabilizar o registro se
									//EV_SITUACA == E
									If (lEstorno .and. !(SEV->EV_SITUACA == "E")) .or. ;
										(!lEstorno .and. (SEV->EV_SITUACA == "E"))
										dbSkip()
										Loop
									ElseIf lEstorno
										//O lancamento a ser considerado passa a ser o do estorno
										lPadraoCC := lPadraoCCE
									Endif
									
									If SEV->EV_LA != "S"
										dbSelectArea( "SED" )
										MsSeek( xFilial("SED")+SEV->EV_NATUREZ ) // Posiciona na natureza, pois a conta pode estar la.
										dbSelectArea("SEV")
										If SEV->EV_RATEICC == "1" .and. lPadraoCC .and. lPadrao // Rateou multinat por c.custo
											dbSelectArea("SEZ")
											dbSetOrder(4)
											MsSeek(cChaveSeZ+SEV->EV_NATUREZ+"2"+cSeqSE5) // Posiciona no arquivo de Rateio C.Custo da MultiNat
											While !Eof() .and. xFilial("SEZ")+SEZ->(EZ_PREFIXO+EZ_NUM+;
												EZ_PARCELA+EZ_TIPO+EZ_CLIFOR+EZ_LOJA+EZ_NATUREZ+EZ_IDENT+EZ_SEQ) == cChaveSeZ+SEV->EV_NATUREZ+"2"+cSeqSE5
												
												//Se estou contabilizando um estorno, trata-se de um C. Pagar,
												//So vou contabilizar os EZ_SITUACA == E
												//Se nao for um estorno, nao devo contabilizar o registro se
												//EZ_SITUACA == E
												If (lEstorno .and. !(SEZ->EZ_SITUACA == "E")) .or. ;
													(!lEstorno .and. (SEZ->EZ_SITUACA == "E"))
													dbSkip()
													Loop
												Endif
												If SEZ->EZ_LA != "S"
													If lUsaFlag
														aAdd(aFlagCTB,{"EZ_LA","S","SEZ",SEZ->(Recno()),0,0,0})
													EndIf
													//O lacto padrao fica:
													//537 - Rateio multinat com c.custo C.Pagar
													//538 - Estorno de Rat. Multinat C.Custo C.Receber
													cPadraoCC := If(SEZ->EZ_SITUACA == "E","538","537")
													VALOR := SEZ->EZ_VALOR
													nTotDoc	+=	DetProva(nHdlPrv,cPadraoCC,"FINA370",cLote,,,,,,,,@aFlagCTB)
													If LanceiCtb // Vem do DetProva
														If !lUsaFlag
															RecLock("SEZ")
															SEZ->EZ_LA    := "S"
															MsUnlock( )
														EndIf 
													ElseIf lUsaFlag
														If (nPosReg  := aScan(aFlagCTB,{ |x| x[4] == SEZ->(Recno()) }))>0
															aFlagCTB := Adel(aFlagCTB,nPosReg)
															aFlagCTB := aSize(aFlagCTB,Len(aFlagCTB)-1)
														Endif														
													Endif
												Endif
												dbSkip()
											Enddo
											DbSelectArea("SEV")
										Else
											If lUsaFlag
												aAdd(aFlagCTB,{"EZ_LA","S","SEZ",SEZ->(Recno()),0,0,0})
											EndIf
											nTotDoc	:=	DetProva(nHdlPrv,cPadrao,"FINA370",cLote,,,,,,,,@aFlagCTB)
										Endif
										If LanceiCtb // Vem do DetProva
											If !lUsaFlag
												RecLock("SEV")
												SEV->EV_LA    := "S"
												MsUnlock( )   
											EndIf  
										ElseIf lUsaFlag
											If (nPosReg  := aScan(aFlagCTB,{ |x| x[4] == SEV->(Recno()) }))>0
												aFlagCTB := Adel(aFlagCTB,nPosReg)
												aFlagCTB := aSize(aFlagCTB,Len(aFlagCTB)-1)
											Endif											
										Endif
									Endif
									DbSelectArea("SEV")
									DbSkip()
									VALOR := 0
								Enddo
								nTotal  	+=	nTotDoc
								nTotProc	+=	nTotDoc // Totaliza por processo
								
								If mv_par12 == 2 
									If nTotDoc > 0 // Por documento
										Ca370Incl(cArquivo,@nHdlPrv,cLote,nTotal,@aFlagCTB)
										nTotDoc := 0
									Endif
									aFlagCTB := {}
								Endif
								dbSelectArea("SE1")
								DbGoto(nRecSe1)
								dbSelectArea("SE2")
								DbGoto(nRecSe2)
							EndIf
						Else
							dbSelectArea("SEV")
							DbGoBottom()
							DbSkip()
							DbSelectArea("SE2")
	                        If  lEstorno
	                            lCtbPls := lCtPlsCBCR .and. substr(SE1->E1_ORIGEM,1,3) == "PLS"
	                            cTipoLP := "CBCR"
	                        Else
	                            lCtbPls := lCtPlsBCP  .and. substr(SE2->E2_ORIGEM,1,3) == "PLS"
	                            cTipoLP := "BCP"
	                        Endif
							If  lCtbPls
							    If  cTipoLP == "BCP"
	   							    nTotDoc := PlsCtbSe2(nHdlPrv,cPadrao,"FINA370",cLote,,,,,,,,@aFlagCTB,cTipoLP)
	   						    Else
	                                nTotDoc := PlsCtbSe1(nHdlPrv,cPadrao,"FINA370",cLote,,,,,,,,@aFlagCTB,cTipoLP,aRegBFQ)
	   						    EndIf
							Else
								nTotDoc	:=	DetProva(nHdlPrv,cPadrao,"FINA370",cLote,,,,,,,,@aFlagCTB)
							EndIf
							nTotProc	+= nTotDoc
							nTotal	+=	nTotDoc
							
							// Se possuir vinculo com Bordero, gera lancamento por Bordero
							if mv_par12 == 2 .and. nTotDoc > 0	// Por Documento
								lChkBordero := .t.
								if !Empty( cProxBor )	.and.	!Empty( cNumBor  ) .and.;	
									(cProxBor == cNumBor)
									lChkBordero := .f.
								endif
								if lChkBordero 
									Ca370Incl(cArquivo,@nHdlPrv,cLote,nTotal,@aFlagCTB)
									nTotDoc := 0
									aFlagCTB := {}
								endif	
							endif								
						Endif
					EndIF   
				Endif	
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Devolve a posi‡„o original do arquivo  ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If nRegOrigSE5 > 0
					SE5->(dbGoTo(nRegOrigSE5))
				Endif
				If (lAdiant .or. lEstorno .or. lEstCart2) .and. !lEstPaNdf
					dbSelectArea("SE1")
					If !SE1->(Eof()) .And. !Bof()
						Reclock( "SE1" )
						Replace E1_VALLIQ  With nValliq
						Replace E1_DESCONT With nDescont
						Replace E1_JUROS	 With nJuros
						Replace E1_MULTA	 With nMulta
						Replace E1_CORREC  With nCorrec
						SE1->( MsUnlock( ) )
					EndIF
				Else
					dbSelectArea("SE2")
					If !Eof() .And. !Bof()
						Reclock( "SE2" )
						Replace E2_VALLIQ  With nValliq
						Replace E2_DESCONT With nDescont
						Replace E2_JUROS	 With nJuros
						Replace E2_MULTA	 With nMulta
						Replace E2_CORREC  With nCorrec
						If lPccBaixa
							Replace E2_PIS		With nPis
							Replace E2_COFINS	With nCofins
							Replace E2_CSLL	With nCsll
							Replace E2_VRETPIS	With nVretPis
							Replace E2_VRETCOF	With nVretCof
							Replace E2_VRETCSL	With nVretCsl
						Endif
						SE2->( MsUnlock())
					EndIf
				Endif
			EndDO
			
			If nValorTotal > 0
				If !lCabecalho
					a370Cabecalho(@nHdlPrv,@cArquivo)
				EndIF
				VALOR 	:= If(mv_par13 = 1, nValorTotal, 0.00)
				VALOR2	:= VALOR3	:= VALOR4	:= VALOR5	:= 0.00
				dbSelectArea("SE2")
				dbGobottom()
				dbSkip()
				// Se estiver contabilizando carteira a Pagar apenas,
				// desposiciona E1 tambem, pois no LP podera conter
				// E1_VALLIQ e este campo retornara um valor, duplicando
				// o LP 527. Ex. Criar um LP 527 contabilizando pelo E1_VALLIQ
				// Fazer uma Baixa e um cancelamento, contabilizar off-line
				// escolhendo apenas a carteira a Pagar
				If mv_par06 == 2 .Or. mv_par06 == 4
					dbSelectArea("SE1")
					dbGobottom()
					dbSkip()
					dbSelectArea("SE5")
					dbGobottom()
					dbSkip()
				Endif
				nTotDoc	:=	DetProva(nHdlPrv,cPadrao,"FINA370",cLote,,,,,,,,@aFlagCTB)
				nTotProc	+= nTotDoc
				nTotal	+=	nTotDoc
				If mv_par12 == 2 
					If nTotDoc > 0 // Por documento
						Ca370Incl(cArquivo,@nHdlPrv,cLote,nTotal,@aFlagCTB)
					Endif
					aflagCTB := {}
				Endif
			EndIF
		EndIF
		
		If mv_par12 == 3 
			If nTotProc > 0 // Por processo
				Ca370Incl(cArquivo,@nHdlPrv,cLote,nTotal,@aFlagCTB)
				nTotProc := 0
			Endif
			aFlagCTB := {}
		Endif
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Contabiliza‡ao de Cheques  											  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

		If (mv_par06 = 3  .Or. mv_par06 = 4) .and. lLerSEF
		
  			#IFDEF TOP
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³       *** Alteracao para ganho de performance ***            ³
				//³Caso o banco seja relacional, pesquisar apenas os titulos     ³
				//³da data que esta sendo processada. Alteracao faz com que      ³
				//³a varredura de registros na SEF limite-se ao total de titulos ³
				//³encontrados na data e nao todos os registros da tabela.       ³
				//³                                                              ³
				//³APENAS a forma de varredura foi alterado, nada foi mudado     ³
				//³nas regras de gravacoes contabeis.                            ³
				//³                                                              ³
				//³ESTUDO DE CASO :                                              ³								
				//³Cliente processa 7564 dias (nPeriodo) X 113056 registros SEF  ³
				//³Totalizando : 855.155.584 varreduras de registros no SEF      ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
   				lArqSEF := .T.
   				aLstSEF := {}
   				nz := 0
   				nTotREGSEF := 0
				If Select(cAliasEF) # 0
					dbSelectArea(cAliasEF)
					dbCloseArea()
					fErase(cAliasEF + OrdBagExt())
					fErase(cAliasEF + GetDbExtension())
				Endif   				
				dbSelectArea("SEF")
				SEF->(dbSetOrder(1))
				cQuery := "SELECT EF_FILIAL, EF_BANCO, EF_AGENCIA, EF_CONTA, EF_NUM, EF_DATA, SEF.R_E_C_N_O_ SEFRECNO "
				cQuery += "FROM " + RetSqlName("SEF") + " SEF "
				If mv_par14 == 1 .AND. !Empty(SEF->(FieldPos( "EF_MSFIL")))
  					cQuery += "WHERE EF_MSFIL BETWEEN '" + mv_par15 + "' AND '" + mv_par16 + "' AND "
				Else
					cQuery += "WHERE EF_FILIAL = '" + xFilial("SEF") + "' AND "
				EndIf				
				cQuery += "EF_DATA BETWEEN '" + DTOS(mv_par04) + "' AND '" + DTOS(mv_par05) + "' AND "
				cQuery += "EF_LA <> 'S ' AND D_E_L_E_T_ = ' ' "
				If l370EFFIL
					cQuery += Execblock("F370EFF",.F.,.F.,cQuery)
				EndIf                           
				cQuery += "ORDER BY " + SqlOrder("EF_FILIAL+EF_BANCO+EF_AGENCIA+EF_CONTA+EF_NUM+DTOS(EF_DATA)") 
				ChangeQuery(cQuery)
				dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cAliasEF, .F., .T.)
				(cAliasEF)->(dbGoTop())
				Do While !(cAliasEF)->(Eof())
					aAdd(aLstSEF,(cAliasEF)->SEFRECNO)
					nTotREGSEF++
					(cAliasEF)->(dbSkip())						
				EndDo
   			#ELSE
	   			lArqSEF := .F.
   			#ENDIF
			dbSelectArea("SEF")
			SEF->(dbSetOrder(1))
			SEF->(dbSeek(xFilial("SEF"),.T.))
			If !lArqSEF
				bCond := {|| !SEF->(Eof()) .And. xFilial("SEF") == SEF->EF_FILIAL}
			Else
				bCond := {|| ++nz <= nTotREGSEF}
			EndIf
			While Eval(bCond)
				If lArqSEF
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Guarda o pr¢ximo registro para IndRegua					  ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					SEF->(dbGoTo(aLstSEF[nz]))
					nRegAnt := SEF->(Recno())
					If nz < nTotREGSEF
						SEF->(dbGoTo(aLstSEF[nz + 1]))
						nProxReg := SEF->(Recno())
						cProxChq := SEF->(EF_BANCO+EF_AGENCIA+EF_CONTA+EF_NUM)  //Utilizado para quebra por documento
						SEF->(dbGoTo(aLstSEF[nz]))
					Else
						nProxReg := 0
						cProxChq := ""
					Endif
				Else
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Guarda o pr¢ximo registro para IndRegua					  ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					nRegAnt := Recno()
					dbSkip()
					nProxReg := RecNo()
					cProxChq := SEF->(EF_BANCO+EF_AGENCIA+EF_CONTA+EF_NUM)  //Utilizado para quebra por documento
					dbGoto(nRegAnt)				
				Endif

				If IIf(cEF_T01 == "D" .Or. ValType(SEF->EF_DATA) == "D",SEF->EF_DATA,StoD(SEF->EF_DATA)) >= mv_par04 .AND.;
					IIf(cEF_T01 == "D" .Or. ValType(SEF->EF_DATA) == "D",SEF->EF_DATA,StoD(SEF->EF_DATA)) <= mv_par05 .AND. ;
					!Empty(SEF->EF_NUM) .AND. ;
					SubStr(SEF->EF_LA,1,1) != "S" .AND. ;
					(Alltrim(SEF->EF_ORIGEM) $ "FINA050#FINA080#FINA070#FINA190#FINA090#FINA390TIT#FINA390AVU" .OR. ;
					Empty(SEF->EF_ORIGEM))
	
					cPadrao := "590"
					lChqSTit := .F.
					IF SEF->EF_ORIGEM == "FINA390TIT"
						cPadrao := "566"
					Endif
					IF SEF->EF_ORIGEM == "FINA390AVU"
						cPadrao := "567"
					Endif
					If !GetMv("MV_CTBAIXA") $ "AC" .and. Alltrim(SEF->EF_ORIGEM) $ "FINA050#FINA080#FINA190#FINA090#FINA390TIT"
						dbSelectArea("SEF")
						dbGoto(nProxReg)
						Loop
					Endif
					
					// Nao contabilizo cancelados em off-line
					If SEF->EF_IMPRESS == "C"
						dbSelectArea("SEF")
						dbGoto(nProxReg)
						Loop
					Endif
					
					// Nao contabilizo cheques de PA nao aglutinados
					If SEF->EF_IMPRESS != "A" .and. Alltrim(SEF->EF_ORIGEM) == "FINA050"
						dbSelectArea("SEF")
						dbGoto(nProxReg)
						Loop
					Endif

					If SEF->EF_IMPRESS $ "SN "	// Cheque impresso ou n„o
						VALOR     := SEF->EF_VALOR		// para lan‡amento padr„o
						STRLCTPAD := SEF->EF_HIST
						NUMCHEQUE := SEF->EF_NUM
						ORIGCHEQ  := SEF->EF_ORIGEM
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Desposiciona propositalmente o SEF para que APENAS a³
						//³ variavel VALOR esteja com conteudo. O reposicionamen³
						//³ to ‚ feito na volta do Looping.                     ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						If Alltrim(SEF->EF_ORIGEM) == "FINA190"  // Juncao de cheques 
							dbSelectArea("SEF")
							cChequeAtual := SEF->(EF_BANCO+EF_AGENCIA+EF_CONTA+EF_NUM)
							dbGoBottom()
							dbSkip()
							dbSelectArea("SE1")
							dbGoBottom()
							dbSkip()
							dbSelectArea("SE2")
							dbGoBottom()
							dbSkip()
							dbSelectArea("SE5")
							dbGoBottom()
							dbSkip()
						Endif
						If Alltrim(SEF->EF_ORIGEM) == "FINA080"  // Baixas a Pagar
							// Se o cheque nao foi impresso, desposiciona as tabelas para contabilizar somente com as variaveis
							If SEF->EF_IMPRESS $ "N "
								dbSelectArea("SEF")
								dbGoBottom()
								dbSkip()
								dbSelectArea("SE1")
								dbGoBottom()
								dbSkip()
								dbSelectArea("SE2")
								dbGoBottom()
								dbSkip()
								dbSelectArea("SE5")
								dbGoBottom()
								dbSkip()
							Else	// Cheque impresso
								// Posiciona SE5 na movimentação de baixa do titulo do cheque e mantem as outras tabelas posicionadas
								SE5->(dbSetOrder(2))                                                                                                                      
								If ! SE5->(MsSeek(xFilial("SE5")+"VL"+SEF->(EF_PREFIXO+EF_TITULO+EF_PARCELA+EF_TIPO+IIf(cEF_T01="D",DtoS(EF_DATA),EF_DATA)+EF_FORNECE+EF_LOJA+SEF->EF_SEQUENC)))
									SE5->(MsSeek(xFilial("SE5")+"BA"+SEF->(EF_PREFIXO+EF_TITULO+EF_PARCELA+EF_TIPO+IIf(cEF_T01="D",DtoS(EF_DATA),EF_DATA)+EF_FORNECE+EF_LOJA+SEF->EF_SEQUENC)))
								EndIf
								SE5->(dbSetOrder(1))
							EndIf
						Endif
						If Alltrim(SEF->EF_ORIGEM) == "FINA390TIT"  // Chq s/ Titulo
							dbSelectArea("SE1")
							dbGoBottom()
							dbSkip()
							dbSelectArea("SE2")
							dbGoBottom()
							dbSkip()
							VALOR     := 0
							lChqStit	:= .T.
							__SE5->(dbSetOrder(1))	
							__SE5->(MsSeek(xFilial("SE5")+IIf(cEF_T01="D",DTOS(SEF->EF_DATA),SEF->EF_DATA)+SEF->(EF_BANCO+EF_AGENCIA+EF_CONTA+EF_NUM)))
							SED->(DbSetOrder(1))
							SED->(MsSeek(xFilial("SED")+__SE5->E5_NATUREZ))											
						Endif
						If Alltrim(SEF->EF_ORIGEM) == "FINA390AVU"  // Cheque Avulso
							VALOR     := 0
							STRLCTPAD := ""
							NUMCHEQUE := ""
							ORIGCHEQ  := ""
							lChqStit	:= .T.
							__SE5->(dbSetOrder(1))	
							__SE5->(MsSeek(xFilial("SE5")+IIf(cEF_T01="D",DTOS(SEF->EF_DATA),SEF->EF_DATA)+SEF->(EF_BANCO+EF_AGENCIA+EF_CONTA+EF_NUM)))
							SED->(DbSetOrder(1))
							SED->(MsSeek(xFilial("SED")+__SE5->E5_NATUREZ))											
						Endif
					Elseif SEF->EF_IMPRESS == "A"	// Cheque Aglutinado  
						VALOR     := 0
						STRLCTPAD := ""
						NUMCHEQUE := ""
						ORIGCHEQ  := ""
						cChequeAtual := SEF->(EF_BANCO+EF_AGENCIA+EF_CONTA+EF_NUM)
						dbSelectArea("SE5")
						dbSetOrder(2)		//posiciona no SE5
						If !(dbSeek(xFilial("SE5")+"VL"+SEF->EF_PREFIXO+SEF->EF_TITULO+SEF->EF_PARCELA+SEF->EF_TIPO+IIf(cEF_T01="D",DtoS(SEF->EF_DATA),SEF->EF_DATA)+SEF->EF_FORNECE+SEF->EF_LOJA+SEF->EF_SEQUENC))
							dbSeek(xFilial("SE5")+"BA"+SEF->EF_PREFIXO+SEF->EF_TITULO+SEF->EF_PARCELA+SEF->EF_TIPO+IIf(cEF_T01="D",DtoS(SEF->EF_DATA),SEF->EF_DATA)+SEF->EF_FORNECE+SEF->EF_LOJA+SEF->EF_SEQUENC)
						Endif
						dbSetOrder(1)
					Endif
					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Posiciona Registros                                 ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If !SEF->(EOF())
						dbSelectArea( "SA6" )
						dbSetOrder(1)
						dbSeek(xFilial("SA6")+SEF->EF_BANCO+SEF->EF_AGENCIA+SEF->EF_CONTA)

						If !lChqSTit
							If SEF->EF_TIPO $ MVRECANT + "/" + MV_CRNEG
								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//³ Neste caso o titulo veio de um Contas³
								//³ a Receber (SE1)                      ³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
								dbSelectArea("SE1")
								DbSetOrder(1)
								If dbSeek(xFilial("SE1")+SEF->EF_PREFIXO+SEF->EF_TITULO+SEF->EF_PARCELA+SEF->EF_TIPO+SEF->EF_FORNECE+SEF->EF_LOJA)
									dbSelectArea("SED")
									dbSeek(xFilial("SED")+SE1->E1_NATUREZ)
									dbSelectArea("SA1")
									dbSeek(xFilial("SA1")+SEF->EF_FORNECE+SEF->EF_LOJA)
								Endif
							Else
								dbSelectArea( "SE2" )
								dbSetOrder(1)
								If dbSeek(xFilial("SE2")+SEF->EF_PREFIXO+SEF->EF_TITULO+;
									SEF->EF_PARCELA+SEF->EF_TIPO+;
									SEF->EF_FORNECE+SEF->EF_LOJA,.F.)
									dbSelectArea("SED")
									dbSetOrder(1)
									dbSeek(xFilial("SED")+SE2->E2_NATUREZ)
									dbSelectArea("SA2")
									dbSetOrder(1)
									dbSeek(xFilial("SA2")+SE2->E2_FORNECE+SE2->E2_LOJA)
								EndIf
							Endif
							If Alltrim(SEF->EF_ORIGEM) == "FINA390TIT"  // Chq s/ Titulo
								dbSelectArea("SEF")
								dbGoBottom()
								dbSkip()
							Endif
						Endif
					EndIf
					dbSelectArea( "SEF" )
					
					lPadrao:=VerPadrao(cPadrao)
					IF lPadrao
						If !lCabecalho
							a370Cabecalho(@nHdlPrv,@cArquivo)
						EndIF
						If lUsaFlag
							aAdd(aFlagCTB,{"EF_LA","S","SEF",nRegAnt,0,0,0})
						EndIf                                                                                   
						
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Deve passar a tabela de cheques (SEF) e Recno posicionado para gravar na CTK/CV3    ³
						//³ Assim, no momento da exclusao do lancto. pelo CTB, limpa o flag da SEF corretamente ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						nTotDoc  += DetProva(nHdlPrv,cPadrao,"FINA370",cLote,,,,,,,,@aFlagCTB,{"SEF",nRegAnt})
						nTotProc += nTotDoc
						nTotal   += nTotDoc
						
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Atualiza Flag de Lan‡amento Cont bil do cheque contabilizado  ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						dbSelectArea("SEF")
						dbGoto(nRegAnt)
						If LanceiCtb .And. !(SEF->(Eof()))
							If !lUsaFlag
								Reclock("SEF")
								SEF->EF_LA := "S"
								MsUnlock()
							EndIf    
						ElseIf lUsaFlag
							If (nPosReg  := aScan(aFlagCTB,{ |x| x[4] == SEF->(Recno()) }))>0
								aFlagCTB := Adel(aFlagCTB,nPosReg)
								aFlagCTB := aSize(aFlagCTB,Len(aFlagCTB)-1)
							Endif							
						EndIf
						// Por documento
						If mv_par12 == 2 
							If nTotDoc > 0 .and. cChequeAtual != cProxChq
								Ca370Incl(cArquivo,@nHdlPrv,cLote,nTotal,@aFlagCTB)
								nTotDoc := 0							
								aFlagCTB := {}
							Endif
						Endif
					Endif
				Endif
				dbSelectArea("SEF")
				dbGoto(nProxReg)
			Enddo
			If mv_par12 == 3 
				If nTotProc > 0 // Por processo
					Ca370Incl(cArquivo,@nHdlPrv,cLote,nTotal,@aFlagCTB)
				Endif
				aFlagCTB := {}
			Endif
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Movimenta‡„o Banc ria - Transferencia & Estorno da Transf.   ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			aTrf := {"TR","TE"}
			nTamTot	:= Len(SE5->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO))
			For nMove:=1 to 2 
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			 	//³ Dividimos agora em 2 partes: 								³
			 	//³	1 - Mov. bancario padrao de inclusao manual (FINA100); 		³
			 	//³ 2 - Alteração do SIGALOJA contabilização LOCALIZADO.		³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				
				For nLacoTrf := 1 to Len(aTrf)

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Muda a forma de busca e ordenacao para quando localizacao for direrente de Brasil pois para		³
					//³ estes casos sao gravadas informacoes em E5_TIPO, e sendo assim a busca e ordenacao feitas para  ³
					//³ o Brasil faz com que a funcao nao siga o resultado desejado por ordem de emissao.				³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
					dbSelectArea("SE5")
					
					If nMove == 1 
						// Procedimento antigo de contabilização de mov. bancario manual	
						SE5->(dbSetOrder(2)) // E5_FILIAL+E5_TIPODOC+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+DtoS(E5_DATA)+E5_CLIFOR+E5_LOJA+E5_SEQ
						SE5->(dbSeek(cFilial+aTrf[nLacoTrf]+Space(nTamTot)+Dtos(mv_par04),.T.))

						cTRCondWhile := "'" + cFilial + "' == SE5->E5_FILIAL .AND. (SE5->E5_DATA >= mv_par04 .AND. SE5->E5_DATA <= mv_par05) .AND. SE5->E5_TIPODOC == '" + aTrf[nLacoTrf] + "'"
					
					ElseIf !lBrasil
	
						SE5->(dbSetOrder(1)) // E5_FILIAL+DTOS(E5_DATA)+E5_BANCO+E5_AGENCIA+E5_CONTA+E5_NUMCHEQ
						SE5->(dbSeek(cFilial+Dtos(mv_par04)), .T.)

						cTRCondWhile := "'" + cFilial + "' == SE5->E5_FILIAL .AND. (SE5->E5_DATA >= mv_par04 .AND. SE5->E5_DATA <= mv_par05) .AND. SE5->E5_TIPODOC == '" + aTrf[nLacoTrf] + "'"
					
					Endif

					While !SE5->(Eof()) .AND. &cTRCondWhile
						If SE5->E5_RECPAG == "P"
							cPadrao := "560"
						Elseif SE5->E5_RECPAG == "R"
							cPadrao := "561"
						EndIf

						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Verifica se ser  gerado Lan‡amento Cont bil			  ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						If SubStr(SE5->E5_LA,1,1) == "S"
							SE5->( dbSkip( ) )
							Loop
						End
						// Neste momento não considera 
						If nMove==1 .and. SE5->E5_NATUREZ $ cCodNat .and. !lBrasil 
							SE5->( dbSkip( ) )
							Loop
						End

						If nMove==2 .and. !(SE5->E5_NATUREZ $ cCodNat .AND. SE5->E5_TIPODOC $ "TR#TE")
							SE5->( dbSkip( ) )
							Loop
						End

						If SE5->E5_SITUACA == "C"
							SE5->( dbSkip() )
							Loop
						End

						//Transferencia ou estorno de transferencia carteira descontada
						If SE5->E5_TIPODOC $ "TR#TE" .AND. !Empty(SE5->E5_NUMERO)
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³Por conta de uma integracao com a RM, os campos E5_PREFIXO e        ³
							//³E5_NUMERO sao utilizados pelo SIGALOJA na gravacao de               ³
							//³movimentos bancarios, valores estes que em nada tem a ver com       ³
							//³titulos do financeiro, sendo assim a regra de que o campo E5_NUMERO ³
							//³deve estar vazio para contabilizar mov. do tipo TR/TE.              ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					  		If !(Upper(AllTrim(SE5->E5_NATUREZ)) $ Upper("Sangria"+"|"+"Troco" )) //"Sangria","Troco" 
					        	SE5->(dbSkip())
                             	Loop
							Endif

						Endif
						
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Posiciona na natureza.										  ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						dbSelectArea( "SED" )
						SED->( dbSeek( cFilial+SE5->E5_NATUREZ ) )
						
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Posiciona no banco.											  ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						dbSelectArea( "SA6" )
						dbSetOrder(1)
						SA6->( dbSeek( cFilial+SE5->E5_BANCO+SE5->E5_AGENCIA+SE5->E5_CONTA ) )
						
						If l370E5T
							Execblock("F370E5T",.F.,.F.)
						Endif
						
						dbSelectArea( "SE5" )
						
						lPadrao:=VerPadrao(cPadrao)
						IF lPadrao
							If !lCabecalho
								a370Cabecalho(@nHdlPrv,@cArquivo)
							Endif
							If lUsaFlag
								aAdd(aFlagCTB,{"E5_LA","S","SE5",SE5->(Recno()),0,0,0})
							EndIf
							nTotDoc	:=	DetProva(nHdlPrv,cPadrao,"FINA370",cLote,,,,,,,,@aFlagCTB)
							nTotProc	+= nTotDoc
							nTotal	+=	nTotDoc
							If mv_par12 == 2 
								If nTotDoc > 0 // Por documento
									If lSeqCorr
										aDiario := {{"SE5",SE5->(recno()),SE5->E5_DIACTB,"E5_NODIA","E5_DIACTB"}}
									EndIf
									Ca370Incl(cArquivo,@nHdlPrv,cLote,nTotal,@aFlagCTB,@aDiario)
								Endif
								aflagCTB := {}
							Endif
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Atualiza Flag de Lan‡amento Cont bil		  ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							If LanceiCtb
								AADD(aRecsSE5,SE5->(RECNO()))
							EndIf
						Endif
						SE5->( dbSkip() )
					EndDo
	
					If mv_par12 == 3 
						If nTotProc > 0 // Por processo
							Ca370Incl(cArquivo,@nHdlPrv,cLote,nTotal,@aFlagCTB)
							nTotProc := 0
						Endif
						aFlagCTB := {}
					Endif
				Next nLacoTrf
			Next nMove			
		Endif
		
		//Seto o flag de contabilizacao - SE5
		If Len(aRecsSE5) > 0 .and. !lUsaFlag
			dbSelectArea("SE5")
			For nX := 1 to Len(aRecsSE5)
				dbGoto(aRecsSE5[nX])
				Reclock("SE5")
				REPLACE E5_LA With "S"
				MsUnlock()
			Next
			aRecsSE5 := {}
		Endif
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Caixinha   SEU990             				     ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If mv_par06 != 3 .and. lLerSEU
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Caixinha   SEU990             				  						  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			dbSelectArea( "SET" )
			dbSetOrder( 1 )
			dbSeek( cFilial)
			nOrderSEU	:=	IIf(mv_par07<>1,2,4)
			bCampo		:=	IIf(mv_par07<>1,{|| EU_BAIXA },{|| EU_DTDIGIT })
			While !Eof() .And. cFilial == SET->ET_FILIAL
				dbSelectArea( "SEU" )
				dbSetOrder( nOrderSEU )
				dbSeek( cFilial + SET->ET_CODIGO + DTOS(MV_PAR04) , .T. )
				While !Eof() .And. cFilial == SEU->EU_FILIAL .And. EU_CAIXA == SET->ET_CODIGO .And. Eval(bCampo) <= mv_par05
					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Ponto de Entrada para filtrar registros do SEU. ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If l370EUFIL
						If !Execblock("F370EUF",.F.,.F.)
							dbSkip()
							Loop
						EndIf
					EndIf
					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Verifica se ser  gerado Lan‡amento Cont bil			  ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If SEU->EU_LA == "S"
						SEU->( dbSkip())
						Loop
					Endif
					
					// Tipo 00 sem Nro de adiantamento = Despesa (P)
					// Tipo 00 com Nro de adiantamento = Prestação de contas (R)
					// Tipo 01 - Adiantamento (P)
					// Tipo 02 - Devolucao de adiantamento (R)
					// Tipo 10 - Movimento Banco -> Caixinha  (R)
					// Tipo 11 - Movimento Caixinha -> Banco (P)
					
					lSkipLct := .F.
					
					//Receber
					//Verifico se eh Despesa. Se for, ignoro
					If mv_par06 == 1 .and. SEU->EU_TIPO $ "00" .AND. EMPTY(SEU->EU_NROADIA)
						lSkipLct := .T.
					Endif
					//Verifico se eh um Adiantamento ou Devolucao para o banco. Se for Ignoro
					If mv_par06 == 1 .and. SEU->EU_TIPO $ "01/11"
						lSkipLct := .T.
					Endif
					
					//Pagar
					//Verifico se eh Prestacao de contas de adiantamento para o caixinha.
					//Se for, ignoro pois eh movimento de entrada
					If mv_par06 == 2 .and. SEU->EU_TIPO $ "00" .and. !EMPTY(SEU->EU_NROADIA)
						lSkipLct := .T.
					Endif
					//Verifico se eh uma devolucao de dinheiro de adiantamento para o caixinha ou
					// se eh uma reposicao (Banco -> Caixinha).
					// Se for Ignoro pois eh movimento de entrada!!
					If mv_par06 == 2 .and. SEU->EU_TIPO $ "02/10"
						lSkipLct := .T.
					Endif
					
					If lSkipLct
						SEU->( dbSkip())
						Loop
					Endif
					
					
					//Reposicao = 10 - Devolucao de reposicao = 11
					If SEU->EU_TIPO $ "10/11"
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Posiciona no banco.											  ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						dbSelectArea( "SA6" )
						dbSetOrder(1)
						dbSeek( cFilial+SET->ET_BANCO+SET->ET_AGEBCO+SET->ET_CTABCO )
						cPadrao:="573"
					Else
						If SEU->EU_TIPO == '02'
							cPadrao:="579"
						Else
							cPadrao:="572"
						EndIf
					Endif
					
					dbSelectArea("SEU")
					lPadrao:=VerPadrao(cPadrao)
					IF lPadrao
						If !lCabecalho
							a370Cabecalho(@nHdlPrv,@cArquivo)
						Endif
						If lUsaFlag
							aAdd(aFlagCTB,{"EU_LA","S","SEU",SEU->(Recno()),0,0,0})
						EndIf
						nTotDoc	:=	DetProva(nHdlPrv,cPadrao,"FINA370",cLote,,,,,,,,@aFlagCTB)
						nTotProc	+= nTotDoc
						nTotal	+=	nTotDoc
						If mv_par12 == 2 
							If nTotDoc > 0 // Por documento
								If lSeqCorr
									aDiario := {{"SEU",SEU->(recno()),SEU->EU_DIACTB,"EU_NODIA","EU_DIACTB"}}
								EndIf
								Ca370Incl(cArquivo,@nHdlPrv,cLote,nTotal,@aFlagCTB,@aDiario)
							Endif
							aFlagCTB := {}
						Endif
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Atualiza Flag de Lan‡amento Cont bil		  ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						If LanceiCtb
							If !lUsaFlag
								Reclock("SEU")
								REPLACE EU_LA With "S"
								MsUnlock( )
							EndIf    
						ElseIf lUsaFlag
							If (nPosReg  := aScan(aFlagCTB,{ |x| x[4] == SEU->(Recno()) }))>0
								aFlagCTB := Adel(aFlagCTB,nPosReg)
								aFlagCTB := aSize(aFlagCTB,Len(aFlagCTB)-1)
							Endif							
						EndIf
					Endif
					dbSkip()
				Enddo
				DbSelectArea("SET")
				DbSkip()
			Enddo
			If mv_par12 == 3 
				If nTotProc > 0 // Por processo
					Ca370Incl(cArquivo,@nHdlPrv,cLote,nTotal,@aFlagCTB)
					nTotProc := 0
				Endif
				aFlagCTB := {}
			Endif
		Endif
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Grava Rodap‚ 													  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If lCabecalho .And. mv_par12 == 1 // Por periodo
			If nTotal > 0
				RodaProva(nHdlPrv,nTotal)
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Envia para Lan‡amento Cont bil 							  ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				lDigita:=IIF(mv_par01==1,.T.,.F.)
				lAglut :=IIF(mv_par02==1,.T.,.F.)
				cA100Incl(cArquivo,nHdlPrv,3,cLote,lDigita,lAglut,,,,@aFlagCTB)
			Endif
			aFlagCTB := {}
		Endif
		
	Next 	  // final do la‡o dos dias
	
	END SEQUENCE
	
	dbSelectArea("SE5")
	RetIndex("SE5")
	fErase(cIndex+OrdBagExt())
	
	If mv_par06 = 2 .Or. mv_par06 = 4
		#IFDEF TOP
			IF Select("TRBSE2") > 0
				dbSelectArea( "TRBSE2" )
				dbCloseArea()
			Endif
		#ELSE
			dbSelectArea("SE2")
			RetIndex("SE2")
			Ferase(cIndSE2+OrdBagExt())
		#ENDIF
	ElseIf mv_par06 = 3 .Or. mv_par06 = 4
		dbSelectArea("SEF")
		RetIndex("SEF")
		Ferase(cIndSEF+OrdBagExt())
	EndIf

	If Select(cAliasEF) > 0
		dbSelectArea(cAliasEF)
		dbCloseArea()
		fErase(cAliasEF + OrdBagExt())
		fErase(cAliasEF + GetDbExtension())
	Endif
	
	If Empty(xFilial("SE1"))
		lLerSE1 := .F.
	Endif
	
	If Empty(xFilial("SE2"))
		lLerSE2 := .F.
	Endif
	
	If Empty(xFilial("SE5"))
		lLerSE5 := .F.
	Endif
	
	If Empty(xFilial("SEF"))
		lLerSEF := .F.
	Endif
	
	If Empty(xFilial("SEU"))
		lLerSEU := .F.
	Endif
	
	If !lLerSE1 .and. !lLerSE2 .and. !lLerSE5 .and. !lLerSEF .And. !lLerSEU
		Exit
	Endif
	
	dbSelectArea("SM0")
	dbSkip()
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Data inicial precisa ser "resetada"                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	mv_par04 := mv_par04 - nLaco + 2
	
Enddo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Recupera o valor real da data base por seguranca	  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dDataBase := dDataAnt

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Recupera a filial original                      	  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SM0->(dbGoto(nRegEmp))
cFilAnt := IIf( lFWCodFil, FWGETCODFILIAL, SM0->M0_CODFIL )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Recupera a Integridade dos Dados									  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
MsUnlockAll()

dbSelectArea( "SE1" )
dbSetOrder( 1 )
dbSeek(xFilial())
dbSelectArea( "SE2" )
dbSetOrder( 1 )
dbSeek(xFilial())
dbSelectArea("SEF")
dbSetOrder(1)
dbSeek(xFilial())
dbSelectArea( "SE5" )
Retindex("SE5")
dbClearFilter()

If !CtbInUse()
	If mv_par11 == 1			// Atualiza‡„o de Sint‚ticas
		aDataIni := DataInicio()
		aDataFim := DataFinal()
		aTabela22:= DataTabela()
		If mv_par08 == 1 		// Considera filiais De/Ate
			Cona070(.T., mv_par09, mv_par10, mv_par04, mv_par05)
		Else						// Desconsidera Filiais
			Cona070(.T., NIL , NIL , mv_par04, mv_par05)
		EndIf
	EndIf
EndIf

If Funname() == "FINA370" .And. AdmGetRpo("R1.1")
	oSelf:Savelog("FIM")
EndIf

If lGerouTxt .and. !IsBlind()
	Aviso("Caminho","Foram gravados registros de inconsistências na tabela SE5 nesta contabilização. Favor verificar os registros no arquivo 'Fina370Log.TXT', existente na pasta '"+cCaminho+"'.",{'OK'},2) //"Foram gravados registros de inconsistências na tabela SE5 nesta contabilização. Favor verificar os registros no arquivo 'Fina370Log.TXT', existente na pasta '"
Endif

Return NIL

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ FA370CONC³ Autor ³ Vinicius Barreira	  ³ Data ³ 24/08/95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Tela de Aviso de Falha na consistˆncia do SE5				  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ FA370CONC() 															  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso		 ³ SIGAFIN																	  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function FA370CONC()
Local cCadast	:= "Contabiliza‡„o" //"Contabiliza‡„o"
Local lRet 		:= .F.
Local lUsaLog	:= SuperGetMv("MV_FINLOG",.T.,.F.)
Local cTexto	:= ""
Local cDate		:= DtoC(date())
Local cHour		:= substr(time(),1,5)
Local cPathLog := GetMv("MV_DIRDOC")
Local cLogArq 	:= "Fina370Log.TXT"
Local cCaminho := cPathLog + cLogArq

If !IsBlind()

	IF lUsaLog
   
	   cTexto += "*** "+cDate+" "+cHour+"--> "+ "Dados do título:" + "PREF. + NUM + PARC + TIP"+chr(13)+chr(10) // "Dados do título:"
	   cTexto += SE5->E5_PREFIXO+"-"+SE5->E5_NUMERO+"-"+SE5->E5_PARCELA+"-"+SE5->E5_TIPO + chr(13)+chr(10)
	   cTexto += "Registro SE5 ->" + ": " + ALLTRIM(STR(SE5->(RECNO()))) +chr(13)+chr(10)    //"Registro SE5 ->"
	   cTexto += "*** ---------------------- ***"

		AcaLog( cCaminho, cTexto ) // função no fonte Acaxfuna (Gestao educacional)

		lGerouTxt := .T.

	Else
	   lRet := MsgYesNo ("Sim ou Nao"+chr(13)+chr(10)+"Sim ou Nao"+;
						   chr(13)+chr(10)+ "Sim ou Nao" + Iif(SE5->E5_RECPAG=="R","Sim ou Nao","Sim ou Nao")+;
   						chr(13)+chr(10)+ "Sim ou Nao" + SE5->E5_PREFIXO+"-"+SE5->E5_NUMERO+"-"+SE5->E5_PARCELA+"-"+SE5->E5_TIPO +;
							chr(13)+chr(10)+ "Sim ou Nao" + STR(SE5->(RECNO())),cCadast)
	Endif

Endif
	
Return lRet
	
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ Fa370Rat ³ Autor ³ Pilar S. Albaladejo   ³ Data ³ 25/08/95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Grava linha de rateio no arquivo de contra-prova			  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ Fa370Rat()																  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso		 ³ SIGAFIN																	  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function Fa370Rat(cArqRat,nHdlPrv,cArquivo)

Local nBytes := 0
Local nHdlRateio
Local nTotal := 0
Local nTamArq
Local xBuffer, cArqOrig, cArqDest

// Abre arquivo de rateio
cArqRat		:= GetMv("MV_PROVA") + cArqRat + ".LAN"
IF !FILE(cArqRat)
	Help(" ",1,"Fa370NOARQ",,cArqRat,3,1)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Atualiza o log de processamento com o erro  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If Funname() == "FINA370" .And. AdmGetRpo("R1.1")
		oSelf:Savelog("ERRO","Fa370NOARQ",Ap5GetHelp("Fa370NOARQ")+cArqRat)
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Utilizacao da funcao ProcLogAtu para permitir a gravacao ³
		//³do log no CV8 quando do uso da classe tNewProcess que    ³
		//³grava o LOG no SXU (FNC 00000028259/2009)                ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		ProcLogAtu("ERRO","Fa370NOARQ",Ap5GetHelp("Fa370NOARQ")+cArqRat)	
	Else	
		ProcLogAtu("ERRO","Fa370NOARQ",Ap5GetHelp("Fa370NOARQ")+cArqRat)
	EndIf
	Return 0
EndIF

If nHdlPRv == 0 .or. (nHdlPrv == 65536 .and. GetHProva() < 0 )
	a370Cabecalho(@nHdlPrv,@cArquivo,.T.)
	lCabecalho := .T.
Endif
nHdlPrv  := GetHProva()
cArquivo := GetHFile()

nHdlRateio	:= Fopen(cArqRat)
nTamArq		:= FSEEK(nHdlRateio,0,2)
xBuffer		:= Space( 312 )
FSEEK(nHdlRateio,0,0)
FREAD(nHdlRateio,@xBuffer,312)

While .T.
	If nBytes < nTamArq
		xBuffer:=Space(312)
		FREAD(nHdlRateio,@xBuffer,312)
		IF  Substr(xBuffer,309,2) = "FF"     // Fim de Arquivo
			Exit
		Endif
		nTotal += Val(Substr(xBuffer,42,16))
		// Escreve no arquivo de contra-prova
		FWRITE(nHdlPrv,xBuffer,312)
		dbCommit()
		nBytes+=312
	Else
		Exit
	Endif
End

// Renomeia arquivo de rateio
Fclose(nHdlRateio)
cArqOrig:=Trim(cArqRat)
cArqDest:=Substr(cArqRat,1,Len(cArqRat)-4)+".#LA"
fRename(cArqOrig,cArqDest)
Return nTotal

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³a370Cabeca³ Autor ³ Wagner Xavier 		  ³ Data ³ 24/08/94 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Monta o arquivo de Contra Prova (Lancamentos off line) 	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³a370Cabeca																  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso		 ³SIGAFIN																	  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function a370Cabecalho(nHdlPrv,cArquivo,lCriar)
lCriar:=if(lCriar=NIL,.f.,lCriar)
nHdlPrv:=HeadProva(cLote,"FINA370",Substr(cUsuario,7,6),@cArquivo,lCriar)
lCabecalho:=.T.
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³Ca370Incl ³ Autor ³ Claudio D. de Souza	  ³ Data ³ 12/08/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Envia lancamentos para contabilizade.                  	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³Ca370Incl 																  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso		 ³FINA370																	  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Ca370Incl(cArquivo,nHdlPrv,cLote,nTotal,aFlagCTB,aDiario)
Local lDigita,;
		lAglut 
Default aDiario := {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Grava Rodap‚ 													  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nHdlPrv > 0
	RodaProva(nHdlPrv,nTotal)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Envia para Lan‡amento Cont bil 							  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	lDigita:=IIF(mv_par01==1,.T.,.F.)
	lAglut :=IIF(mv_par02==1,.T.,.F.)
	cA100Incl(cArquivo,nHdlPrv,3,cLote,lDigita,lAglut,,,,@aFlagCTB,,aDiario)
	lCabecalho := .F.
	nHdlPrv := 0
Endif

aFlagCTB := {}
aDiario	:= {}

Return Nil


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³AjustaSX1 ³ Autor ³ Gustavo Henrique      ³ Data ³ 26/09/08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Atualiza perguntas no SX1                              	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³AjustaSX1 												  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso		 ³FINA370													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function AjustaSX1()
Local aArea		:= GetArea()
Local aHelpPor	:= {}
Local aHelpSpa	:= {}
Local aHelpEng	:= {}

// Cria pergunta Contab.Tit.Provisor? (MV_PAR17)
dbSelectArea("SX1")
dbSetOrder(1)

If !DbSeek(PadR("FIN370",Len(SX1->X1_GRUPO))+"17")

	Aadd( aHelpPor, "Indica se devem ser contabilizados os  " )
	Aadd( aHelpPor, "títulos provisórios.                   " )
	Aadd( aHelpSpa, "Informe si se deben contabilizar los   " )
	Aadd( aHelpSpa, "titulos provisionales                  " )
	Aadd( aHelpEng, "Indicate if the temporary bills will be" )
	Aadd( aHelpEng, "accounted                              " )
	
	PutSx1( "FIN370","17","Contab.Tit.Provisorio?","¿Contabiliza Titulo Provisor?","Record Temp.Bill ?","mv_chh",;
	"N",1,0,2,"C","","","","","mv_par17","Sim","Si","Yes","","Nao","No","No","","","","","","","","","",;
	aHelpPor,aHelpEng,aHelpSpa,".FIN37017.")

EndIf

RestArea(aArea)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³A370CanProºAutor  ³Marcos S. Lobo      º Data ³  06/26/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Cria Semaforo de processamento e verifica concorrencia com  º±±
±±º          ³base nos intervalos de parametros                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP - Contabilizacao Off-Line Financeiro                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function A370CanProc(nCart, dDtVldDe, dDtVldAte, cFilDe, cFilAte,oSelf)
Local lRet		:= .F.
Local nX		:= 1
Local aInfos	:= {}
Local nEr		:= 0 
Local cFile		:= ""
Local cBuffer	:= ""
Local cUserLck	:= ""
Local dDTDe
Local dDTAte
Local nHandle 	:= -1
Local lCreate	:= .F.
Local lOK
Local cUserCTB	:= PADR('SCHED',15)

DEFAULT cFilDe := cFilAnt
DEFAULT cFilAte:= cFilAnt

If !lBlind
	cUserCTB := cUserName
EndIf
 
While !LockByName("FINA370LOCKPROC"+cEmpAnt,.T.,.T.,.T.)
    nER++
	If !lBlind
		MsAguarde({|| Sleep(1000) }, "Semaforo de processamento... tentativa "+ALLTRIM(STR(nER)), "Aguarde, arquivo sendo criado por outro usuário.") //"Semaforo de processamento... tentativa "#"Aguarde, arquivo sendo criado por outro usuário."
	Else
		Sleep(5000)		
	EndIf
	If nER > 5	/// A PARTIR DA QUINTA TENTATIVA
		If !lBlind
			If Aviso("Criação de Semaforo de processamento.","Não foi possivel acesso exclusivo para criar o semaforo de processamento.",{"Repetir","Fechar"},2) == 2//"Criação de Semaforo de processamento."#"Não foi possivel acesso exclusivo para criar o semaforo de processamento."#"Repetir"#"Fechar"
				If Funname() == "FINA370" .And. AdmGetRpo("R1.1")
					oSelf:Savelog("ERRO","ERRO","ERRO"+"ERRO")	
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Utilizacao da funcao ProcLogAtu para permitir a gravacao ³
					//³do log no CV8 quando do uso da classe tNewProcess que    ³
					//³grava o LOG no SXU (FNC 00000028259/2009)                ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					ProcLogAtu("ERRO","ERRO","ERRO"+"ERRO")						
				Else	
					ProcLogAtu("ERRO","ERRO","ERRO"+"ERRO")	
				EndIf	
				Return lRet
			Else
				nER := 0
			EndIf		
		ElseIf nER >= 30
			If Funname() == "FINA370" .And. AdmGetRpo("R1.1")
				oSelf:Savelog("ERRO","ERRO","ERRO"+"ERRO")	
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Utilizacao da funcao ProcLogAtu para permitir a gravacao ³
				//³do log no CV8 quando do uso da classe tNewProcess que    ³
				//³grava o LOG no SXU (FNC 00000028259/2009)                ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				ProcLogAtu("ERRO","ERRO","ERRO"+"ERRO")		
			Else	
				ProcLogAtu("ERRO","ERRO","ERRO"+"ERRO")	
			EndIf	
			Return lRet
		EndIf
    EndIf
EndDo

//MakeDir("\SEMAFORO\")
cFile := "CTB370"+AllTrim(cEmpAnt)

If !File(cFile+__cExt) 
	aStruct  := {}
	AAdd( aStruct, { "FILDE"	, "C", Len( cFilAnt )	, 0 } )
	AAdd( aStruct, { "FILATE"	, "C", Len( cFilAnt )	, 0 } )
	AAdd( aStruct, { "DTDE"		, "D", 8 				, 0 } )
	AAdd( aStruct, { "DTATE"	, "D", 8 				, 0 } )
	AAdd( aStruct, { "CCART"	, "C", 1				, 0 } )
	AAdd( aStruct, { "CUSER"	, "C", Len( cUserCTB )	, 0 } )
	AAdd( aStruct, { "HORAI"	, "C", Len(Time())		, 0 } )
	AAdd( aStruct, { "DATAI"	, "D", 8				, 0 } )
	AAdd( aStruct, { "HORAF"	, "C", Len(Time())		, 0 } )
	AAdd( aStruct, { "DATAF"	, "D", 8				, 0 } )

	MsCreate( cFile , aStruct , __LOCALDRIVER )
	
	cArqTrab := cFile
Else
	cArqTrab := cFile
EndIf

If Select("SEM370") <= 0
	dbUseArea(.T.,,cArqTrab,"SEM370",.T.,.F.)
EndIf

dbSelectArea("SEM370")			
dbGoTop()

lSai		:= .F.
lRet1		:= .T.
lRet2		:= .T.
lRet3		:= .T.	

While !lSai .and. SEM370->(!Eof())
	        
	IF cFilDe <= SEM370->FILDE .and. cFilAte >= SEM370->FILATE
		lRet1 := .F.
	ElseIF cFilDe >= SEM370->FILDE .and. cFilDe <= SEM370->FILATE
		lRet1 := .F.
	ElseIf cFilAte >= SEM370->FILDE .and. cFilAte <= SEM370->FILATE
		lRet1 := .F.
	ElseIf cFilDe > cFilAte
		lRet1 := .F.		
	Endif	    

	IF dDtVldDe <= SEM370->DTDE .and. dDtVldAte >= SEM370->DTATE
		lRet2 := .F.
	ElseIF dDtVldDe >= SEM370->DTDE .and. dDtVldDe <= SEM370->DTATE
		lRet2 := .F.
	ElseIf dDtVldAte >= SEM370->DTDE .and. dDtVldAte <= SEM370->DTATE
		lRet2 := .F.
	ElseIf dDtVldDe > dDtVldAte
		lRet2 := .F.		
	Endif
	
	IF nCart == 4 .or. SEM370->CCART == "4"
		lRet3 := .F.
	ElseIf Str(nCart,1) == SEM370->CCART	
		lRet3 := .F.	
	EndIf
	
	If !lRet1 .and. !lRet2 .and. !lRet3
		/// SE LOCALIZOU NO MESMO PERIODO E NAS MESMAS FILIAIS E MESMA CARTEIRA

		If SEM370->(RLock())			/// SE CONSEGUIR ALOCAR 	
			SEM370->(dbDelete())		/// NAO TEM CONCORRENCIA
			SEM370->(MsUnlock())
		Else		
			If !lBlind
				Aviso("Atenção!","Este processo esta sendo utilizado com parametros conflitantes ( mesmo periodo ou carteiras ) por outro usuário ( "+Alltrim(SEM370->CUSER)+" "+SEM370->HORAI+" "+" ) no momento. Verifique o período e os parametros selecionados para o processamento ou tente novamente mais tarde.",{"Fechar"},2) //"Atenção!"###"Este processo esta sendo utilizado com parametros conflitantes ( mesmo periodo ou carteiras ) por outro usuário ( "###" ) no momento. Verifique o período e os parametros selecionados para o processamento ou tente novamente mais tarde."###"Fechar"
			EndIf
		
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Atualiza o log de processamento com o erro  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If Funname() == "FINA370" .And. AdmGetRpo("R1.1")
					oSelf:Savelog("ERRO","ERRO","ERRO"+Alltrim(SEM370->CUSER)+"ERRO")
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Utilizacao da funcao ProcLogAtu para permitir a gravacao ³
					//³do log no CV8 quando do uso da classe tNewProcess que    ³
					//³grava o LOG no SXU (FNC 00000028259/2009)                ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					ProcLogAtu("ERRO","ERRO","ERRO"+AllTrim(SEM370->CUSER)+"ERRO")	
				Else	
    				ProcLogAtu("ERRO","ERRO","ERRO"+Alltrim(SEM370->CUSER)+"ERRO")
    			EndIf	
			lSai		:= .T.
		EndIf
	EndIf
	SEM370->(dbSkip())
EndDo

If !lSai
	RecLock("SEM370",.T.)
	Field->FILDE		:= PADR(cFilDe,2)
	Field->FILATE		:= PADR(cFilAte,2)
	Field->DTDE			:= dDtVldDe
	Field->DTATE	    := dDtVldAte
	Field->CCART		:= Str(nCart,1)
	Field->CUSER		:= cUserCTB
	Field->HORAI		:= Time()
	Field->DATAI	    := Date()
	MsUnlock()	
	RecLock("SEM370",.F.) ///DEIXA REGISTRO ALOCADO
	CONOUT("FINA370 | "+ALLTRIM(STR(ThreadId())) +" Start Time "+Time()+" "+ALLTRIM(STR(Seconds())))
	lRet := .T.		///PROCESSAMENTO PODE SER EFETUADO
EndIf

UnLockByName("FINA370LOCKPROC"+cEmpAnt,.T.,.T.,.T.)

Return lRet
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³A370FREEPRºAutor  ³Marcos S. Lobo      º Data ³  06/26/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Libera registro alocado no semaforo de processamento.       º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP Contabilizacao Off-Line Financeiro                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function A370FreeProc()

Local cFile 	:= "CTB370"+AllTrim(cEmpAnt)
Local nER		:= 0

If !File(cFile+__cExt)
	Return
EndIf

If Select("SEM370") <= 0
	Return
EndIf

While !LockByName("FINA370LOCKPROC"+cEmpAnt,.T.,.T.,.T.)
    nER++
	If !lBlind
		MsAguarde({|| Sleep(1000) }, "Semaforo de processamento... tentativa "+ALLTRIM(STR(nER)), "Aguarde, arquivo sendo criado por outro usuário.")//"Semaforo de processamento... tentativa "#"Aguarde, arquivo sendo criado por outro usuário."
	Else
		Sleep(5000)		
	EndIf
	If nER > 5	/// A PARTIR DA QUINTA TENTATIVA
		If !lBlind
			If Aviso("Gravacao de Semaforo de processamento.","Não foi possivel acesso exclusivo para gravar o semaforo de processamento.",{"Repetir","Fechar"},2) == 2//"Gravacao de Semaforo de processamento."#"Não foi possivel acesso exclusivo para gravar o semaforo de processamento."#"Repetir"#"Fechar"
				If Funname() == "FINA370" .And. AdmGetRpo("R1.1")
					oSelf:Savelog("ERRO","ERRO","ERRO"+"ERRO")	
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Utilizacao da funcao ProcLogAtu para permitir a gravacao ³
					//³do log no CV8 quando do uso da classe tNewProcess que    ³
					//³grava o LOG no SXU (FNC 00000028259/2009)                ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					ProcLogAtu("ERRO","ERRO","ERRO"+"ERRO")	
				Else	
					ProcLogAtu("ERRO","ERRO","ERRO"+"ERRO")	
				EndIf
				
				Return
			Else
				nER := 0
			EndIf		
		ElseIf nER >= 30
			If Funname() == "FINA370" .And. AdmGetRpo("R1.1")
				oSelf:Savelog("ERRO","ERRO","ERRO"+"ERRO")	
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Utilizacao da funcao ProcLogAtu para permitir a gravacao ³
				//³do log no CV8 quando do uso da classe tNewProcess que    ³
				//³grava o LOG no SXU (FNC 00000028259/2009)                ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				ProcLogAtu("ERRO","ERRO","ERRO"+"ERRO")	
			Else	
				ProcLogAtu("ERRO","ERRO","ERRO"+"ERRO")	
			EndIf
			Return
		EndIf
    EndIf
EndDo

dbSelectArea("SEM370")
If !Eof()
	If SEM370->(RLock())
		Field->HORAF	:= Time()
		Field->DATAF	:= Date()
	EndIf
	MsUnlock()
	CONOUT("FINA370 | "+ALLTRIM(STR(ThreadId())) +" End Time   "+Time()+" "+ALLTRIM(STR(Seconds())))
	RecLock("SEM370",.F.)
	SEM370->(dbDelete())
	MsUnlock()
EndIf

UnLockByName("FINA370LOCKPROC"+cEmpAnt,.T.,.T.,.T.)

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³MenuDef   ³ Autor ³ Ana Paula N. Silva     ³ Data ³24/11/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Utilizacao de menu Funcional                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Array com opcoes da rotina.                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Parametros do array a Rotina:                               ³±±
±±³          ³1. Nome a aparecer no cabecalho                             ³±±
±±³          ³2. Nome da Rotina associada                                 ³±±
±±³          ³3. Reservado                                                ³±±
±±³          ³4. Tipo de Transa‡„o a ser efetuada:                        ³±±
±±³          ³		1 - Pesquisa e Posiciona em um Banco de Dados         ³±±
±±³          ³    2 - Simplesmente Mostra os Campos                       ³±±
±±³          ³    3 - Inclui registros no Bancos de Dados                 ³±±
±±³          ³    4 - Altera o registro corrente                          ³±±
±±³          ³    5 - Remove o registro corrente do Banco de Dados        ³±±
±±³          ³5. Nivel de acesso                                          ³±±
±±³          ³6. Habilita Menu Funcional                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function MenuDef()
Local aRotina:={ 	{ "Localizar","AxPesqui" , 0 , 1},;  //"Localizar"
					{ "Pagar","fA100Pag" , 0 , 3},;  //"Pagar"
					{ "Receber","fA100Rec" , 0 , 3},;  //"Receber"
					{ "Excluir","fA100Can" , 0 , 5},;  //"Excluir"
					{ "Transferir","fA100Tran", 0 , 3},;  //"Transferir"
					{ "Classificar","fA100Clas", 0 , 5} }  //"Classificar"
Return(aRotina)
                             


Static Function F370Process(oSelf)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Utilizacao da funcao ProcLogAtu para permitir a gravacao ³
//³do log no CV8 quando do uso da classe tNewProcess que    ³
//³grava o LOG no SXU (FNC 00000028259/2009)                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ProcLogAtu("INICIO")
If mv_par08 == 1
		If A370CanProc(mv_par06, mv_par04, mv_par05,mv_par09,mv_par10)
			U_FA370Processa(.F.,oSelf)  // Chamada da funcao de Contabilizacao Off-Line
		EndIf
Else
		If A370CanProc(mv_par06, mv_par04, mv_par05)
			 FA370Processa(.F.,oSelf)  // Chamada da funcao de Contabilizacao Off-Line
		EndIf	
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Utilizacao da funcao ProcLogAtu para permitir a gravacao ³
//³do log no CV8 quando do uso da classe tNewProcess que    ³
//³grava o LOG no SXU (FNC 00000028259/2009)                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If AdmGetRpo("R1.1")
	ProcLogAtu("FIM")	
Endif
A370FreeProc()          

Return
	
	
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³F370CTBSELºAutor  ³Microsiga           º Data ³  03/05/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao que pesquisa e contabiliza todos os registro de um  º±±
±±º          ³ recibo gerado pelo FINA087a                                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ FINA370                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function F370CTBSEL( cSerie, cRecibo, nTotal, cLote, nHdlPrv, cArquivo, lUsaFlag, aFlagCTB )
Local lResult		:=	.T.
Local aListArea		:=	{ GetArea() } // Atencao: A primeira deve ser restaurada por ultimo. (UEPS)
Local i				:=	0
Local cKeyImp		:=	""
Local cAlias		:=	""
Local lAchou		:=	.F.
Local nLinha		:=	1 
Local aRecSEL		:= {}

lResult := VerPadrao( "575" )
    
	If lResult .and. !lCabecalho
		a370Cabecalho( @nHdlPrv, @cArquivo )	
		If nHdlPrv <= 0
			Help( " ", 1, "A100NOPROV" )
			lResult := .F.
		EndIf
	EndIf

	If lResult
		GetDBArea( "SEL", @aListArea )
		SEL->( DBSetOrder( 8 ) )	// EL_FILIAL+EL_SERIE+EL_RECIBO+EL_TIPODOC+EL_PREFIXO+EL_NUMERO+EL_PARCELA+EL_TIPO
		SEL->( DBSeek( xFilial("SEL") + cSerie + cRecibo ) )	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Gera Lancamento Contab. para RECIBO.³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		Do while	!SEL->( EOF() ) .and.;
					( SEL->EL_SERIE == cSerie ) .and.;
					( SEL->EL_RECIBO == cRecibo ) .and.;
					( SEL->EL_LA <> 'S' )

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Guarda Registro³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			AADD( aRecSEL, SEL->(RECNO()) )
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Posiciona Banco.³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			GetDBArea( "SA6", @aListArea )
			SA6->( DbsetOrder( 1 ) )
			SA6->( DbSeek( xFilial("SA6") + SEL->EL_BANCO + SEL->EL_AGENCIA + SEL->EL_CONTA, .F.) )
			
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Verifica se tem titulo vinculado.³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			GetDBArea( "SE1", @aListArea )
			SE1->( DbsetOrder( 2 ) )
			SE1->( DbSeek(	xFilial("SE1") +;
							SEL->EL_CLIORIG +;
							SEL->EL_LOJORIG +;
							SEL->EL_PREFIXO +;
							SEL->EL_NUMERO +;
							SEL->EL_PARCELA +;
							SEL->EL_TIPO, .F.) )

			If !SE1->( EOF() )
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Posiciona na Natureza do Titulo .³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				GetDBArea( "SED", @aListArea )
				SED->( DbsetOrder( 1 ) )
				SED->( DbSeek(	xFilial("SED") +;
								SE1->E1_NATUREZ, .F.) )
			Endif

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Posiciona Cliente.³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			GetDBArea( "SA1", @aListArea )
			SA1->( DbsetOrder( 1 ) )
			SA1->( DbSeek( xFilial("SA1") + SE1->E1_CLIENTE + SE1->E1_LOJA, .F.) )
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Posiciona no cabecalho da NF vinculada.³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				Do Case
				Case ( Alltrim( SEL->EL_TIPO ) == Alltrim( GetSESnew("NCC") ) )
					cAlias := "SF1"
				Case ( Alltrim( SEL->EL_TIPO ) == Alltrim( GetSESnew("NDE") ) )
					cAlias := "SF1"         
				Otherwise
					cAlias := "SF2"    
				EndCase
				cKeyImp := 	xFilial(cAlias)	+;
							SE1->E1_NUM		+;
							SE1->E1_PREFIXO	+;
							SE1->E1_CLIENTE	+;
							SE1->E1_LOJA			

				If ( cAlias == "SF1" )
					cKeyImp += SE1->E1_TIPO
				Endif

				Posicione( cAlias, 1, cKeyImp, "F" + SubStr( cAlias, 3, 1 ) + "_VALIMP1" )
				lAchou := .F.

			GetDBArea( "SEL", @aListArea )
			If lUsaFlag  // Armazena em aFlagCTB para atualizar no modulo Contabil 
				aAdd( aFlagCTB, {"EL_LA", "S", "SEL", SEL->( Recno() ), 0, 0, 0} )
			Endif
			
			nTotal += DetProva( nHdlPrv,;
			                    "575" /*cPadrao*/,;
			                    "FINA087a" /*cPrograma*/,;
			                    cLote,;
			                    nLinha,;
			                    /*lExecuta*/,;
			                    /*cCriterio*/,;
			                    /*lRateio*/,;
			                    /*cChaveBusca*/,;
			                    /*aCT5*/,;
			                    /*lPosiciona*/,;
			                    @aFlagCTB,;
			                    /*aTabRecOri*/,;
			                    /*aDadosProva*/ )
			
			SEL->( DbSkip() )
		EndDo
	
		If !lUsaFlag .and. ( Len( aRecSEL ) > 0 )
			For i := 1 To Len( aRecSEL )
				SEL->( DBGoTo( aRecSEL[ i ] ) )
				RecLock( "SEL", .F. )
				Replace EL_LA With "S"
				MsUnLock()
			Next i

		EndIf
	
	EndIf

    // Restaura todas as areas. 
    // A ultima area a ser restaurada sera a area ativa no momento da chamada a esta funcao.
	for i := Len( aListArea	 ) to 1 Step -1 // UEPS
		RestArea( aListArea[ i ] )
	Next i

Return lResult

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GetDBArea ºAutor  ³Microsiga           º Data ³  03/06/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Seleciona uma area de dados, armazena a area numa lista    º±±
±±º          ³ para permitir a restauracao porterior.                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ FINA370                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function GetDBArea( cAlias, aListGetArea )
Default cAlias			:= Alias()
Default aListGetArea	:= {}

	DBSelectArea( cAlias )
	// Pesquisa para evitar duplicidade.
	If ASCAN( aListGetArea, { | aVal | aVal[ 1 ] == cAlias } ) == 0
		AADD( aListGetArea, (cAlias)->( GetArea() ) )
	Endif

Return NIL /*Function GetDBArea*/
/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³FinA370T   ³ Autor ³ Marcelo Celi Marques ³ Data ³ 26.03.08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Chamada semi-automatica utilizado pelo gestor financeiro   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ FINA370                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function FinA370T(aParam)
	cRotinaExec := "FINA370"
	ReCreateBrow("SE2",FinWindow)      	
	FinA370()
	ReCreateBrow("SE2",FinWindow)      	

	dbSelectArea("SE2")
	
	INCLUI := .F.
	ALTERA := .F.

Return .T.	


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ F370RatFin ºAutor ³ Gustavo Henrique   º Data ³ 21/05/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Chamar a rotina de rateio do Contas a Pagar com tratamento º±±
±±º          ³ de ambiente                                                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Financeiro                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function F370RatFin( cPadrao, cProg, cLote, nTipo, cCodRateio, nOpc, cDebito, cCredito, cHistorico, nHdlPrv, nTotDoc, aFlagCTB )

Local dMvPar04 := CtoD( "  /  /  " )	
Local dMvPar05 := CtoD( "  /  /  " )
                     
// Guarda as perguntas de data inicial e data final, que sao alteradas durante o processamento, 
// quando selecionada a contabilizacao pela data de emissao ao inves de database
If mv_par03 == 1
	dMvPar04 := mv_par04
	dMvPar05 := mv_par05
EndIf	

CtbRatFin( cPadrao, "FINA370", cLote, 4, " ", 4,,,, @nHdlPrv, @nTotDoc, @aFlagCTB )
     
If mv_par03 == 1
	mv_par04 := dMvPar04
	mv_par05 := dMvPar05
EndIf

Return .T.