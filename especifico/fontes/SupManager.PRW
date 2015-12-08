#include "PROTHEUS.CH"
#include "vkey.ch"
#include "font.ch"
#define cEOL CHR(10)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ SupManager()º Autor ³ Fernando Nogueira  º Data ³23/10/2013º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Administracao de chamados pendentes, avalia e faz alocacao º±±
±±º          ³ dos chamados em aberto para tecnicos... (Copy TOTVS)       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico AVANT.                   	                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÏÍÍÍÑÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAnalista Resp.³  Data  ³ Manutencao Efetuada                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º              ³  /  /  ³                                               º±±
±±º              ³  /  /  ³                                               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function SupManager(w,y,nOpc)

	Local aArea	:= GetArea()
	Local aBut	:= {}

	Private cTecID	:= RetCodUsr()
	Private oDlgChamados
	Private oLbx3
	Private oStatus1
	Private oStatus2
	Private oStatus3
	Private oStatus4
	Private oStatus5
	Private oStatus6
	Private aHeadLbx := {}
	Private aChamados:= {{ "","","","","","","","","","","","","","","","","","","","","","","","" }}

	Private dDataIni := ddatabase - 1500
	Private dDataFim := ddatabase
	Private cEquipe	  := Space(2)
	Private cCliente := Space(6)
	Private cNomeCli := Space(10)
	Private cTecnico := Space(6)
	Private cNomeTec := Space(40)

	Private lFirst		:= .T.
	Private lAberto		:= .T.
	Private lAnalise	:= .T.
	Private lTransf		:= .T.
	Private lPendente	:= .F.
	Private lEncerrado	:= .F.
	Private lTodos		:= .F.
	Private lUser		:= .T.
	Private lSort		:= .F.
	Private aRecursos	:= {}

	Private aSize    := MsAdvSize()
	Private aObjects := {}
	Private aInfo    := {}
	Private aPosObj  := {}
	Private aPosGet  := {}
	Private aGets	 := {}

	Private bCancel  := {|| xOpc:=0,oDlgChamados:End()}
	Private bOk	  	 := {|| xOpc:=1,oDlgChamados:End()}

	Private oFlwS 	 := LoadBitmap( GetResources(), "BR_VERMELHO_OCEAN.BMP" )
	Private oFlwU 	 := LoadBitmap( GetResources(), "BMPUSER.BMP" )
	Private oFlwT 	 := LoadBitmap( GetResources(), "IC_20_USUARIO.GIF" )

	aAdd(aObjects,{100,100,.T.,.T.})
	aAdd(aObjects,{100,030,.T.,.F.})

	aInfo 	:= {aSize[1],aSize[2],aSize[3],aSize[4],3,3}
	aPosObj := MsObjSize(aInfo,aObjects)
	aPosGet := MsObjGetPos((aSize[3]-aSize[1]),315,{{004,024,240,270}} )

//	ChkFile("SX5")

	SetKey(VK_F5,{ || Processa( {|| MTLoadLbx(dDataIni,dDataFim,cEquipe,IIF(lUser,cTecId,""),,,,cCliente,,cTecnico) }, "Lista de chamados","Aguarde ...", .T. ) } )

	aAdd( aBut, { "BMPINCLUIR"	, { || u_WEB270EDIT(,0,3) } 	,OemToAnsi("Incluir") })
	aAdd( aBut, { "EDIT_OCEAN"	, { || EditLbx( oLbx3:aArray[oLbx3:nAt,2] ) } 	,OemToAnsi("Editar") })
	aAdd( aBut, { "BMPVISUAL"	, { || VisuLbx( oLbx3:aArray[oLbx3:nAt,2] ) } 	,OemToAnsi("Visualizar") })
	aAdd( aBut, { "BMPPOST"		, { || NotifLbx( oLbx3:aArray[oLbx3:nAt,2] ) }	,OemToAnsi("Enviar atualização") })
	aAdd( aBut, { "PMSRRFSH"	, { || Processa( {|| MTLoadLbx(dDataIni,dDataFim,cEquipe,IIF(lUser,cTecId,""),,,,cCliente) }, "Lista de chamados","Aguarde ...", .T. ) } 	,OemToAnsi("Atualizar - F5") })
	aAdd( aBut, { "IMPRESSAO_OCEAN"	, { || u_ExpHtml( oLbx3:aArray[oLbx3:nAt,2] ) } ,OemToAnsi("Imprimir") })

	If cNivel > 5
		aAdd( aBut, { "MSGFORWD.PNG" , { || FowardLbx( oLbx3:aArray[oLbx3:nAt,2] ) } 	,OemToAnsi("Distribuir") })
		LjMsgRun("Aguarde ... Carregando recursos ... "  ,, { || aRecursos := u_RetRecursos() })
	Endif

	aAdd( aBut, { "FILTRO1.PNG"	, { || MTFilterU( oLbx3:aArray[oLbx3:nAt,2] ) } ,OemToAnsi("Filtrar por usuário") })

	DEFINE MSDIALOG oDlgChamados TITLE "Console de Chamados"  FROM aSize[7],aSize[1] TO aSize[6],aSize[5] PIXEL // FROM 178,181 TO 654,967 PIXEL

		// Cria as Groups do Sistema
		// @ 014,006 TO 204,386 LABEL "" PIXEL OF oDlgChamados

		@ aPosObj[1,1],aPosObj[1,2] LISTBOX oLbx3 VAR cVar FIELDS HEADER ;
		" ",;				//[1]
		"Chamado",;			//[2]
		"DT Abert",;		//[3]
		"HR Abert",;		//[4]
		" ",;				//[5]
		"Dias",;			//[6]
		"Atualizado",;		//[7]
		"Dias",;			//[8]
		"Técnico",;			//[9]
		"Cod. Contato",;	//[10]
		"Nome Contato",;	//[11]
		"Mail Contato",;	//[12]
		"Telefone",;		//[13]
		"Área",;            //[14]
		"Status",;			//[15]
		"DT Encerra",;		//[16]
		"HR Encerra",;		//[17]
		"Alocação",;		//[18]
		"Assunto",;			//[19]
		"Ocorrência" ;		//[20]
		SIZE aPosObj[1,4],(aPosObj[1,3]-15) OF oDlgChamados PIXEL
		//ON dblClick( VisuLbx( oLbx3:aArray[oLbx3:nAt,2] ) ) SIZE aPosObj[1,4],(aPosObj[1,3]-15) OF oDlgChamados PIXEL;
		oLbx3:bLDblClick := {|| VisuLbx( oLbx3:aArray[oLbx3:nAt,2] ), oLbx3:DrawSelect()}
		oLbx3:bRClicked := {|| Posicione("SZU",1,xFilial("SZU")+oLbx3:aArray[oLbx3:nAt,2],"ZU_CHAMADO"), u_LjVerHist(), oLbx3:DrawSelect()}

		oLbx3:SetArray( aChamados )
		oLbx3:bLine := {|| { 	LoadBitmap( GetResources(), RetLegenda(aChamados[oLbx3:nAt,1]) ) ,;
                               	aChamados[oLbx3:nAt,2],;
                		       	aChamados[oLbx3:nAt,3],;
		                       	aChamados[oLbx3:nAt,4],;
								IIF( aChamados[oLbx3:nAt,21] == "U", oFlwU , IIF( aChamados[oLbx3:nAt,21] == "T", oFlwT , oFlwS ) ),;
								aChamados[oLbx3:nAt,19],;	// No de dias TOTAl
								aChamados[oLbx3:nAt,22],;	// Atualizado em
								aChamados[oLbx3:nAt,23],;	// No de dias da Ult. Atualizacao
								aChamados[oLbx3:nAt,20],;
		                       	aChamados[oLbx3:nAt,5],;
		                       	aChamados[oLbx3:nAt,6],;
		                       	aChamados[oLbx3:nAt,7],;
		                       	aChamados[oLbx3:nAt,9],;
		                       	aChamados[oLbx3:nAt,10],;
		                       	aChamados[oLbx3:nAt,11],;
		                       	aChamados[oLbx3:nAt,12],;
		                       	aChamados[oLbx3:nAt,13],;
		                        aChamados[oLbx3:nAt,14],;
		                       	aChamados[oLbx3:nAt,15],;
		                       	aChamados[oLbx3:nAt,16]}}
		oLbx3:bHeaderClick := {|x,y| LbxSort(y) }
		oLbx3:lAdjustColSize := .T.
		oLbx3:Ljustific := .T.

		oPanel:= tPanel():New((aPosObj[2,1]),aPosObj[2,2],””,oDlgChamados,,,,,/*CLR_BLUE*/,(aPosObj[2,4]),(aPosObj[2,3])) // cria o painel

		// Cria Componentes Padroes do Sistema
		@ 005,006 Say "Data Inicial:" Size 030,008 COLOR CLR_BLACK PIXEL OF oPanel
		@ 005,079 Say "Data Final:" Size 027,008 COLOR CLR_BLACK PIXEL OF oPanel
		@ 005,150 Say "Equipe:" Size 020,008 COLOR CLR_BLACK PIXEL OF oPanel
		@ 017,006 Say "Cliente interno:" Size 037,008 COLOR CLR_BLACK PIXEL OF oPanel
		@ 017,220 Say "Tecnico:" Size 037,008 COLOR CLR_BLACK PIXEL OF oPanel

		@ 004,036 MsGet oDataIni Var dDataIni Size 033,009 COLOR CLR_BLACK PIXEL OF oPanel
		@ 004,106 MsGet oDataFim Var dDataFim Size 033,009 COLOR CLR_BLACK PIXEL OF oPanel
		@ 004,170 MsGet oEquipe Var cEquipe F3 "ZZ" Size 025,009 COLOR CLR_BLACK PIXEL OF oPanel

		@ 016,046 MsGet oCliente Var cCliente F3 "US4" Valid(VldCli(cCliente)) Size 025,009 COLOR CLR_BLACK PIXEL OF oPanel
		@ 016,080 MsGet oNomeCli Var cNomeCli Size 122,009 COLOR CLR_BLACK WHEN .F.  PIXEL OF oPanel

		@ 016,246 MsGet oTecnico Var cTecnico F3 "SZC" Size 025,009 COLOR CLR_BLACK PIXEL OF oPanel
		@ 016,280 MsGet oNomeTec Var cNomeTec Size 122,009 COLOR CLR_BLACK WHEN .F.  PIXEL OF oPanel

		@ 005,430 CheckBox oStatus1 Var lAberto 		Prompt "Em aberto" 		ON CLICK(AtuOption(1))	Size 040,008 PIXEL OF oPanel
		@ 015,430 CheckBox oStatus2 Var lAnalise 		Prompt "Em análise" 	ON CLICK(AtuOption(2))	Size 040,008 PIXEL OF oPanel
		@ 025,430 CheckBox oStatus3 Var lTransf			Prompt "Transferidos" 	ON CLICK(AtuOption(3))	Size 042,008 PIXEL OF oPanel

		@ 005,474 CheckBox oStatus4 Var lPendente 		Prompt "Pendentes" 		ON CLICK(AtuOption(4))	Size 048,008 PIXEL OF oPanel
		@ 015,474 CheckBox oStatus5 Var lEncerrado 		Prompt "Encerrados" 	ON CLICK(AtuOption(5))	Size 048,008 PIXEL OF oPanel
		@ 025,474 CheckBox oStatus6 Var lTodos 			Prompt "Todos" 			ON CLICK(AtuOption(6))	Size 048,008 PIXEL OF oPanel

		@ 005,518 CheckBox oStatus7 Var lUser 			Prompt "Filtra ID" 		ON CLICK(AtuOption(7))	Size 048,008 PIXEL OF oPanel

	ACTIVATE MSDIALOG oDlgChamados ON INIT EnchoiceBar(oDlgChamados,bOk,bCancel,,aBut)

	RestArea(aArea)

	SetKey(VK_F5,Nil)

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³ LbxSort()   º Autor ³ TOTVS SA           º Data ³27/10/2011º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Permite a re-ordenação dos chamados de acordo com o campo   º±±
±±º          ³selecionado                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function LbxSort(nCol)

	If nCol == 6
		nCol := 14
	Endif

	// Procura a coluna do listbox e obtem a coluna correspondente
	// do vetor para ordenar
	nPosHld := aScan( aHeadLbx , { |e| e[1] == nCol })
	If nPosHld > 0

		nPosOri := aHeadLbx[nPosHld,2]

		If lSort
			aSort(aChamados,,, { |x,y| x[nPosOri] > y[nPosOri] } )
		Else
			aSort(aChamados,,, { |x,y| x[nPosOri] < y[nPosOri] } )
		Endif

		oLbx3:SetArray( aChamados )
		oLbx3:bLine := {|| { 	LoadBitmap( GetResources(), RetLegenda(aChamados[oLbx3:nAt,1]) ) ,;
	                            aChamados[oLbx3:nAt,2],;
	                		    aChamados[oLbx3:nAt,3],;
		                       	aChamados[oLbx3:nAt,4],;
								IIF( aChamados[oLbx3:nAt,21] == "U", oFlwU , IIF( aChamados[oLbx3:nAt,21] == "T", oFlwT , oFlwS ) ),;
								aChamados[oLbx3:nAt,19],;	// No de dias TOTAl
								aChamados[oLbx3:nAt,22],;	// Atualizado em
								aChamados[oLbx3:nAt,23],;	// No de dias da Ult. Atualizacao
								aChamados[oLbx3:nAt,20],;
		                       	aChamados[oLbx3:nAt,5],;
		                       	aChamados[oLbx3:nAt,6],;
		                       	aChamados[oLbx3:nAt,7],;
		                       	aChamados[oLbx3:nAt,9],;
		                       	aChamados[oLbx3:nAt,10],;
		                       	aChamados[oLbx3:nAt,11],;
		                       	aChamados[oLbx3:nAt,12],;
		                       	aChamados[oLbx3:nAt,13],;
		                        aChamados[oLbx3:nAt,14],;
		                       	aChamados[oLbx3:nAt,15],;
		                       	aChamados[oLbx3:nAt,16]}}
		oLbx3:Refresh()
		lSort := !lSort

	Endif

Return()
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³ AtuOption() º Autor ³ TOTVS SA           º Data ³27/10/2011º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Funcao que atualiza os objetos de selecao RadioButton na    º±±
±±º          ³tela de visualizacao dos chamados                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function AtuOption(nObj)

	If nObj == 6
		lAberto		:= .F.
		lAnalise	:= .F.
		lTransf		:= .F.
		lPendente	:= .F.
		lEncerrado	:= .F.
		oStatus1:Refresh()
		oStatus2:Refresh()
		oStatus3:Refresh()
		oStatus4:Refresh()
		oStatus5:Refresh()
	Elseif nObj == 4
		lAberto		:= .F.
		lAnalise	:= .F.
		lTransf		:= .F.
		lEncerrado	:= .F.
		lTodos		:= .F.
		oStatus1:Refresh()
		oStatus2:Refresh()
		oStatus3:Refresh()
		oStatus5:Refresh()
		oStatus6:Refresh()
	Else
		lTodos		:= .F.
		oStatus6:Refresh()
	Endif

Return()
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³ VisuLbx()   º Autor ³ TOTVS SA           º Data ³27/10/2011º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Permite visualizar o chamado a partir de um ListBox         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function VisuLbx( cChamado )

	Local aArea		:= GetArea()

	// Acerta deletados SYP
	U_Acerta_SYP()

	IF lFirst
		MsgStop("Nenhum chamado selecionado para esta opção. Informe os parâmetros abaixo e pressione F5 para atualizar.",,"INFO")
		Return
	Endif

	DbSelectArea("SZU")
	DbSetOrder(1)
	IF DbSeek( xFilial("SZU") + cChamado )
		u_Web270Edit(,,2)
		// u_LjVerHist()
	Else
		Help("",1,".ERRO.",,"Registro inválido",4,0)
	Endif

	RestArea(aArea)

Return()
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³ EditLbx()   º Autor ³ TOTVS SA           º Data ³27/10/2011º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Permite editar o chamado                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function EditLbx( cChamado )

	Local aArea		:= GetArea()

	Private oFlwS 	 := LoadBitmap( GetResources(), "BR_VERMELHO_OCEAN.BMP" )
	Private oFlwU 	 := LoadBitmap( GetResources(), "BMPUSER.BMP" )
	Private oFlwT 	 := LoadBitmap( GetResources(), "IC_20_USUARIO.GIF" )

	// Acerta deletados SYP
	U_Acerta_SYP()

	IF lFirst
		MsgStop("Nenhum chamado selecionado para esta opção. Informe os parâmetros abaixo e pressione F5 para atualizar.",,"INFO")
		Return
	Endif

	DbSelectArea("SZU")
	DbSetOrder(1)
	IF DbSeek( xFilial("SZU") + cChamado )

		If u_Web270Edit(,,4)

			aRegs := MTLoadLbx(dDataIni,dDataFim,cEquipe,IIF(lUser,cTecId,""),,,,cCliente,cChamado,cTecnico)
			nCps		:= Len(aRegs[1])

			For o := 1 To nCps
				aChamados[oLbx3:nAT,o] := aRegs[1,o]
			Next

			oLbx3:SetArray( aChamados )
			oLbx3:bLine := {|| { 	LoadBitmap( GetResources(), RetLegenda(aChamados[oLbx3:nAt,1]) ) ,;
	                               	aChamados[oLbx3:nAt,2],;
	                		       	aChamados[oLbx3:nAt,3],;
			                       	aChamados[oLbx3:nAt,4],;
									IIF( aChamados[oLbx3:nAt,21] == "U", oFlwU , IIF( aChamados[oLbx3:nAt,21] == "T", oFlwT , oFlwS ) ),;
									aChamados[oLbx3:nAt,19],;	// No de dias TOTAl
									aChamados[oLbx3:nAt,22],;	// Atualizado em
									aChamados[oLbx3:nAt,23],;	// No de dias da Ult. Atualizacao
									aChamados[oLbx3:nAt,20],;
			                       	aChamados[oLbx3:nAt,5],;
			                       	aChamados[oLbx3:nAt,6],;
			                       	aChamados[oLbx3:nAt,7],;
			                       	aChamados[oLbx3:nAt,9],;
			                       	aChamados[oLbx3:nAt,10],;
			                       	aChamados[oLbx3:nAt,11],;
			                       	aChamados[oLbx3:nAt,12],;
			                       	aChamados[oLbx3:nAt,13],;
			                        aChamados[oLbx3:nAt,14],;
			                       	aChamados[oLbx3:nAt,15],;
			                       	aChamados[oLbx3:nAt,16]}}
				oLbx3:Refresh()
		Endif
	Else
		Help("",1,".ERRO.",,"Registro inválido",4,0)
	Endif

	RestArea(aArea)

Return Nil
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³ NotifLbx()  º Autor ³ TOTVS SA           º Data ³27/10/2011º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³Envia ficha atualizada do chamado via e-mail                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function NotifLbx( cChamado )

	Local aArea		:= GetArea()

	IF lFirst
		MsgStop("Nenhum chamado selecionado para esta opção. Informe os parâmetros abaixo e pressione F5 para atualizar.",,"INFO")
		Return
	Endif

	DbSelectArea("SZU")
	DbSetOrder(1)
	IF DbSeek( xFilial("SZU") + cChamado )
		u_TECREENV()
	Else
		Help("",1,".ERRO.",,"Registro inválido",4,0)
	Endif

	RestArea(aArea)

Return Nil
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³ VldCli ()   º Autor ³ TOTVS SA           º Data ³27/10/2011º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³Faz a validacao do campo cliente interno e atualiza a descriº±±
±±º          ³cao com o nome do departamento.                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function VldCli( cVarCli )

	Local lRet	:= .T.

	If Empty(cVarCli)
		cNomeCli := ""
		oNomeCli:Refresh()
	Else
		aGuarda := u_usr_campos(cVarCli)
		IF !Empty(aGuarda[1]+aGuarda[2]+aGuarda[3])
			cNomeCli := aGuarda[1]
			oNomeCli:Refresh()
		Else
			Help("",1,".ERRO.",,"Código inválido",4,0)
			lRet(.F.)
		Endif
	Endif

Return( lRet )
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³ MTLoadLbx() º Autor ³ TOTVS SA           º Data ³27/10/2011º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³Faz SELECT na base de dados e retorna lista dos chamados de º±±
±±º          ³acordo com o filtro do usuario.                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function MTLoadLbx(cDTAbrIni,cDTAbrFim,cFilArea,cFilTec,cFilStatus,cDTEncIni,cDTEncFim,cFilCli,cNumChamado,cFilTec2)

	Local aRet	:= {}
	Local lRetSimples := .F.

	If !lAberto .And. !lAnalise .And. !lTransf .And. !lPendente .And. !lEncerrado .And. !lTodos
		MsgStop("Você deve selecionar pelo menos uma opção para o filtro das informações.",,"INFO")
		Return
	Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Prepara a query que ira retornar os dados filtrados ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cSQL := "SELECT * FROM " + RETSQLNAME("SZU") + " WHERE " + cEOL

	If !Empty(cNumChamado)

		cSQL += "ZU_FILIAL = '" + xFilial("SZU") + "' AND ZU_CHAMADO = '" + cNumChamado + "' AND " + cEOL
		lRetSimples := .T.

	Else

		cSQL += "ZU_FILIAL = '" + xFilial("SZU") + "' AND ZU_DATA >= '" + DTOS(cDTAbrIni) + "' AND ZU_DATA <= '" + DTOS(cDTAbrFim) + "' AND " + cEOL

		IF !EMPTY(cDTEncIni)
			cSQL += "ZU_DATAOK >= '" + DTOS(cDTEncIni) + "' AND ZU_DATAOK <= '" + DTOS(cDTEncFim) + "' AND " + cEOL
		Endif

	    IF !EMPTY(cFilArea)
			cSQL += "ZU_DIVISAO = '" + cFilArea + "' AND " + cEOL
		Endif

	    IF !EMPTY(cFilCli)
			cSQL += "ZU_CODUSR = '" + cFilCli + "' AND " + cEOL
		Endif

		IF lUser
			cSQL += "ZU_TECNICO = '" + cFilTec + "' AND " + cEOL
		Endif
		
	    IF !lUser .And. !EMPTY(cFilTec2)
			cSQL += "ZU_TECNICO = '" + cFilTec2 + "' AND " + cEOL
		Endif
	

	 	If !lTodos
	 		IF !lPendente
				cStatus := IIF(lAberto,"'A'","'X'") + "," + IIF(lAnalise,"'E'","'X'") + "," + IIF(lTransf,"'T'","'X'") + "," + IIF(lEncerrado,"'F'","'X'")
				cSQL += "ZU_STATUS IN(" + cStatus + ") AND " + cEOL
			Else
				cStatus := "'A','E','T'
				cSQL += "ZU_STATUS IN(" + cStatus + ") AND " + cEOL
			Endif
		Endif

	Endif

	cSQL += "D_E_L_E_T_ = ' ' " + cEOL
	cSQL += "ORDER BY ZU_DATA DESC " + cEOL
	DbUseArea( .T.,"TOPCONN", TCGenQry(,,cSQL), 'TRB' , .F. , .T.)


	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Atualiza o ListBox com os dados novos ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	DbSelectArea("TRB")
	DbGoTop() ; COUNT TO nRegua ; DbGoTop()
	ProcRegua(nRegua)
	While !Eof()
		IncProc()
		nDias := dDatabase - STOD(ZU_DATA)
		nDiasAtu := ddatabase- STOD(ZU_DATAATU)
		If lPendente .And. nDias < 2 .And. !lRetSimples
			TRB->( DbSkip() )
			Loop
		Endif

		aAdd( aRet, { 	ZU_STATUS,;
						ZU_CHAMADO,;
						STOD(ZU_DATA),;
						ZU_HRABERT,;
						ZU_CODUSR,;
						ZU_NOMEUSR,;
						ZU_MAILUSR,;
						ZU_TELUSR,;
						ZU_TELUSR,;
						ZU_DIVISAO,;
						Capital( RetField("SX5",1,xFilial("SX5")+"Z2    "+SZU->ZU_FEEDBAC,"SX5->X5_DESCRI")) ,;
						STOD(ZU_DATAOK),;
						ZU_HROK,;
						ZU_TECNICO,;
						ZU_ASSUNTO,;
						ZU_ROTINA,;
						STOD(ZU_DTCONF),;
						ZU_HRCONF,;
						LTrim(Str(nDias,3)),;
						u_RetTecName(ZU_TECNICO),;
						ZU_FEEDBAC ,;
						STOD(ZU_DATAATU) ,;
						LTrim(Str(nDiasAtu,3)),;
						} )

`		TRB->( DbSkip() )
	End
	DbCloseArea()

	If Len(aRet) < 1
		MsgInfo("Não existem dados para esta consulta com os parâmetros informados.",,"INFO")
		Return
	Endif

	If !lRetSimples
		aChamados := aClone(aRet)
		aHeadLbx  := { {1,1},{2,2},{3,3},{4,4},{5,21},{6,19},{7,22},{8,23},{9,20},{10,5},{11,6},{12,7},{13,9},{14,10},{15,11},{16,12},{17,13},{18,14},{19,15},{20,16} }
		oLbx3:SetArray( aRet )
		oLbx3:bLine := {|| { 	LoadBitmap( GetResources(), RetLegenda(aRet[oLbx3:nAt,1]) ) ,;
	                            aRet[oLbx3:nAt,2],;
	 							aRet[oLbx3:nAt,3],;
		                       	aRet[oLbx3:nAt,4],;
								IIF( aChamados[oLbx3:nAt,21] == "U", oFlwU , IIF( aChamados[oLbx3:nAt,21] == "T", oFlwT , oFlwS ) ),;
		                       	aRet[oLbx3:nAt,19],;
								aRet[oLbx3:nAt,22],;	// Atualizado em
								aRet[oLbx3:nAt,23],;	// No de dias da Ult. Atualizacao
		                       	aRet[oLbx3:nAt,20],;
		                       	aRet[oLbx3:nAt,5],;
		                       	aRet[oLbx3:nAt,6],;
		                       	aRet[oLbx3:nAt,7],;
		                       	aRet[oLbx3:nAt,9],;
		                       	aRet[oLbx3:nAt,10],;
		                       	aRet[oLbx3:nAt,11],;
		                       	aRet[oLbx3:nAt,12],;
		                       	aRet[oLbx3:nAt,13],;
		                        aRet[oLbx3:nAt,14],;
		                       	aRet[oLbx3:nAt,15],;
		                       	aRet[oLbx3:nAt,16]}}

		oLbx3:lAdjustColSize := .T.
		oLbx3:Ljustific := .T.
		oLbx3:Refresh()
		lFirst := .F.
	Endif

Return(aRet)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³ RetBmp()    º Autor ³ TOTVS SA           º Data ³27/10/2011º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³Funcao para efetuar tratamento dos Bitmaps que sao exibidos º±±
±±º          ³no listbox.                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function RetBmp( cZuStatus, cZuFeedbac )

	If Empty(cZuFeedback)
		cRet 	:= ""

	Elseif cZuFeedback == "U"
		cRet	:= ""
	Endif


Return( cRet )
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³ MTFilterU() º Autor ³ TOTVS SA           º Data ³27/10/2011º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³Funcao que realiza filtro por usuário de acordo com o       º±±
±±º          ³usuário selecionado.                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function MTFilterU()

	Local cTecPos := aChamados[oLbx3:nAt,14]

	lUser := .T.

	Processa( {|| MTLoadLbx(dDataIni,dDataFim,cEquipe,cTecPos,,,,cCliente,,cTecnico) } , "Lista de chamados","Aguarde ...", .T. )

	lUser := .F.

Return()
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³ RetLegenda()º Autor ³ TOTVS SA           º Data ³27/10/2011º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³Retorna Bitmap a ser usado na legenda                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function RetLegenda(cStatus)

	Local cRet	:= ""

	If cStatus == "A"
		cRet	:= "BR_VERDE_OCEAN"
	Elseif cStatus == "F"
		cRet	:= "BR_AMARELO_OCEAN"
	Elseif cStatus == "C"
		cRet	:= "BR_CINZA_OCEAN"
	Elseif cStatus == "E"
		cRet	:= "BR_AZUL_OCEAN"
	Elseif cStatus == "T"
		cRet	:= "BR_PINK_OCEAN"
	Endif

Return(cRet)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³ FowardLbx() º Autor ³ TOTVS SA           º Data ³27/10/2011º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³Interface para distribuicao dos chamados. Permite que os    º±±
±±º          ³recursos sejam alocados entre os chamados.                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function FowardLbx()

	Local oDlgFwd
	Local cCodTec	:= ""

	IF lFirst
		MsgStop("Nenhum chamado selecionado para esta opção. Informe os parâmetros abaixo e pressione F5 para atualizar.",,"INFO")
		Return
	Endif

	DEFINE FONT oFNT1  NAME "Arial" 	SIZE 0, -12
	DEFINE MSDIALOG oDlgFwd TITLE "Alocação de Recursos" FROM 214,188 TO 400,544 PIXEL

		@ 0, 0 BITMAP RESNAME "LOGIN" oF oDlgFwd SIZE 40,100 NOBORDER WHEN .F. PIXEL

		@ 000,042 TO 075,175 LABEL "" PIXEL OF oDlgFwd
		@ 006,047 SAY "Selecione o recurso que deseja alocar" FONT oFNT1 COLOR CLR_BLACK PIXEL OF oDlgFwd

		@ 080,097 BUTTON "Confirmar" 	ACTION (LjMsgRun("Aguarde ... Processando alocação ..."  ,, { || MTAlocFun(oLbx3:aArray[oLbx3:nAt,2],Substr(cCodTec,1,6) ) }) ,oDlgFwd:End()) SIZE 037,012 PIXEL OF oDlgFwd
		@ 080,137 BUTTON "Cancelar" 	ACTION (oDlgFwd:End()) SIZE 037,012 PIXEL OF oDlgFwd

		@ 016,047 LISTBOX oRecursos Var cCodTec ITEMS aRecursos SIZE 123,055 PIXEL OF oDlgFwd

	ACTIVATE MSDIALOG oDlgFwd CENTERED

Return()
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³ MTAlocFun() º Autor ³ TOTVS SA           º Data ³27/10/2011º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³Funcao que faz a alocacao dos chamados                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function MTAlocFun(cChamado,cIDTecnico)

	Local cCodAloc	:= GetMv("ES_CODALOC")

	DbSelectAreA('SZC')
	SZC->(DbSeek(xFilial('SZC')+cIDTecnico))
	cMotivo := Alltrim(Posicione("SZD",1,xFilial("SZD") + SZC->ZC_GRUPO,"ZD_DESC"))
/*
	IF SZG->( DbSeek( xFilial("SZG") + cCodAloc ) )
		cMotivo := RTRIM(SZG->ZG_DESCRI)
	Else
		cMotivo := "DISTRIBUICAO"
	Endif
*/
	DbSelectArea("SZU")
	DbSetOrder(1)
	IF DbSeek( xFilial("SZU") + cChamado )

		RecLock("SZU",.F.)
			SZU->ZU_TECNICO	:= cIDTecnico
			SZU->ZU_DATAATU	:= Date()
		MsUnLock()


		u_RegItem(cChamado,cCodAloc, "Em " + DTOC(Date()) + " o chamado redirecionado para: " + cMotivo ,cIDTecnico)
		u_OpenProc(cChamado,"T",0)

		aChamados[oLbx3:nAt,1] 	:= SZU->ZU_STATUS
		aChamados[oLbx3:nAt,22] := SZU->ZU_DATAATU
		aChamados[oLbx3:nAt,12] := SZU->ZU_DATAOK
		aChamados[oLbx3:nAt,13] := SZU->ZU_HROK
		aChamados[oLbx3:nAt,20] := u_RetTecName(cIDTecnico)
		aChamados[oLbx3:nAt,21] := SZU->ZU_FEEDBAC
		aChamados[oLbx3:nAt,23] := LTrim(Str(ddatabase- SZU->ZU_DATAATU,3))

		oLbx3:SetArray( aChamados )
		oLbx3:bLine := {|| { 	LoadBitmap( GetResources(), RetLegenda(aChamados[oLbx3:nAt,1]) ) ,;
                               	aChamados[oLbx3:nAt,2],;
                		       	aChamados[oLbx3:nAt,3],;
		                       	aChamados[oLbx3:nAt,4],;
								IIF( aChamados[oLbx3:nAt,21] == "U", oFlwU , IIF( aChamados[oLbx3:nAt,21] == "T", oFlwT , oFlwS ) ),;
								aChamados[oLbx3:nAt,19],;	// No de dias TOTAl
								aChamados[oLbx3:nAt,22],;	// Atualizado em
								aChamados[oLbx3:nAt,23],;	// No de dias da Ult. Atualizacao
								aChamados[oLbx3:nAt,20],;
		                       	aChamados[oLbx3:nAt,5],;
		                       	aChamados[oLbx3:nAt,6],;
		                       	aChamados[oLbx3:nAt,7],;
		                       	aChamados[oLbx3:nAt,9],;
		                       	aChamados[oLbx3:nAt,10],;
		                       	aChamados[oLbx3:nAt,11],;
		                       	aChamados[oLbx3:nAt,12],;
		                       	aChamados[oLbx3:nAt,13],;
		                        aChamados[oLbx3:nAt,14],;
		                       	aChamados[oLbx3:nAt,15],;
		                       	aChamados[oLbx3:nAt,16]}}
		oLbx3:Refresh()

	Endif

Return()
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³RetRecursos()º Autor ³ TOTVS SA           º Data ³27/10/2011º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³Retorna os usuarios cadastrados no cadastro de usuario      º±±
±±º          ³como tecnicos habilitados para uso da ferramenta.           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function RetRecursos()

	Local aArea	:= GetArea()
	Local aRet	:= {}

	DbSelectArea('SZC')
	DbGotop()
	While SZC->(!Eof())
		If SZC->ZC_STATUS <> 'I'
			aAdd( aRet, SZC->ZC_TECID + " " + SZC->ZC_NOME )
		EndIf
		DbSkip()
	EndDo

	RestArea(aArea)

Return(aRet)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³ ExpHtml()   º Autor ³ TOTVS SA           º Data ³27/10/2011º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³Exporta a ficha do chamado em HTML para impressao           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function ExpHtml( cNumero )

	Local aArea	:= GetArea()

	DbSelectArea("SZU")
	DbSetOrder(1)
	IF DbSeek( xFilial("SZU") + cNumero )
		u_OpenProc(SZU->ZU_CHAMADO,"P",0)
	Endif

	RestArea(aArea)

Return()
