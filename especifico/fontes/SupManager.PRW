#include "PROTHEUS.CH"
#include "vkey.ch"
#include "font.ch"
#define cEOL CHR(10)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออปฑฑ
ฑฑบPrograma  ณ SupManager()บ Autor ณ Fernando Nogueira  บ Data ณ23/10/2013บฑฑ
ฑฑฬออออออออออุอออออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออนฑฑ
ฑฑบDescrio ณ Administracao de chamados pendentes, avalia e faz alocacao บฑฑ
ฑฑบ          ณ dos chamados em aberto para tecnicos... (Copy TOTVS)       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico AVANT.                   	                      บฑฑ
ฑฑฬออออออออออฯอออัออออออออัอออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAnalista Resp.ณ  Data  ณ Manutencao Efetuada                           บฑฑ
ฑฑฬออออออออออออออุออออออออุอออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ              ณ  /  /  ณ                                               บฑฑ
ฑฑบ              ณ  /  /  ณ                                               บฑฑ
ฑฑศออออออออออออออฯออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
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
	Private lFilaPrj	:= .F.
	Private lProjeto	:= .F.
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
	Private oFlwP 	 := LoadBitmap( GetResources(), "IC_SCORECARD.GIF" )
	Private oFlw1 	 := LoadBitmap( GetResources(), "BR_VIOLETA.PNG" )
	Private oFlw2 	 := LoadBitmap( GetResources(), "BR_VERMELHO_OCEAN.PNG" )
	Private oFlw3 	 := LoadBitmap( GetResources(), "BR_AMARELO_OCEAN.PNG" )
	Private oFlw4 	 := LoadBitmap( GetResources(), "BR_AZUL_OCEAN.PNG" )

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
	aAdd( aBut, { "BMPPOST"		, { || NotifLbx( oLbx3:aArray[oLbx3:nAt,2] ) }	,OemToAnsi("Enviar atualiza็ใo") })
	aAdd( aBut, { "PMSRRFSH"	, { || Processa( {|| MTLoadLbx(dDataIni,dDataFim,cEquipe,IIF(lUser,cTecId,""),,,,cCliente) }, "Lista de chamados","Aguarde ...", .T. ) } 	,OemToAnsi("Atualizar - F5") })
	aAdd( aBut, { "IMPRESSAO_OCEAN"	, { || u_ExpHtml( oLbx3:aArray[oLbx3:nAt,2] ) } ,OemToAnsi("Imprimir") })

	If cNivel > 5
		aAdd( aBut, { "MSGFORWD.PNG" , { || FowardLbx( oLbx3:aArray[oLbx3:nAt,2] ) } 	,OemToAnsi("Distribuir") })
		LjMsgRun("Aguarde ... Carregando recursos ... "  ,, { || aRecursos := u_RetRecursos() })
	Endif

	aAdd( aBut, { "FILTRO1.PNG"	, { || MTFilterU( oLbx3:aArray[oLbx3:nAt,2] ) } ,OemToAnsi("Filtrar por usuแrio") })
	aAdd( aBut, { "BPMSEDT3.PNG", { || LegPri() } ,OemToAnsi("Leg.Prioridade") })

	DEFINE MSDIALOG oDlgChamados TITLE "Console de Chamados"  FROM aSize[7],aSize[1] TO aSize[6],aSize[5] PIXEL // FROM 178,181 TO 654,967 PIXEL

		// Cria as Groups do Sistema
		// @ 014,006 TO 204,386 LABEL "" PIXEL OF oDlgChamados

		@ aPosObj[1,1],aPosObj[1,2] LISTBOX oLbx3 VAR cVar FIELDS HEADER ;
		" ",;				//[01]
		"Chamado",;			//[02]
		"P",;				//[03]
		"DT Abert",;		//[04]
		"HR Abert",;		//[05]
		" ",;				//[06]
		"Dias",;			//[07]
		"Atualizado",;		//[08]
		"Dias",;			//[09]
		"T้cnico",;			//[10]
		"Cod. Contato",;	//[11]
		"Nome Contato",;	//[12]
		"Mail Contato",;	//[13]
		"Telefone",;		//[14]
		"มrea",;            //[15]
		"Status",;			//[16]
		"DT Encerra",;		//[17]
		"HR Encerra",;		//[18]
		"Aloca็ใo",;		//[19]
		"Assunto",;			//[20]
		"Ocorr๊ncia" ;		//[21]
		SIZE aPosObj[1,4],(aPosObj[1,3]-15) OF oDlgChamados PIXEL
		//ON dblClick( VisuLbx( oLbx3:aArray[oLbx3:nAt,2] ) ) SIZE aPosObj[1,4],(aPosObj[1,3]-15) OF oDlgChamados PIXEL;
		oLbx3:bLDblClick := {|| VisuLbx( oLbx3:aArray[oLbx3:nAt,2] ), oLbx3:DrawSelect()}
		oLbx3:bRClicked := {|| Posicione("SZU",1,xFilial("SZU")+oLbx3:aArray[oLbx3:nAt,2],"ZU_CHAMADO"), u_LjVerHist(), oLbx3:DrawSelect()}

		oLbx3:SetArray( aChamados )
		oLbx3:bLine := {|| { 	LoadBitmap( GetResources(), RetLegenda(aChamados[oLbx3:nAt,01]) ) ,;
                               	aChamados[oLbx3:nAt,02],;
                               	IIF( aChamados[oLbx3:nAt,24] == "1", oFlw1 , IIF( aChamados[oLbx3:nAt,24] == "2", oFlw2 , IIF( aChamados[oLbx3:nAt,24] == "3", oFlw3 , oFlw4 ) ) ),;
                		       	aChamados[oLbx3:nAt,03],;
		                       	aChamados[oLbx3:nAt,04],;
								IIF( aChamados[oLbx3:nAt,21] == "U", oFlwU , IIF( aChamados[oLbx3:nAt,21] == "T", oFlwT , IIF( aChamados[oLbx3:nAt,21] == "P", oFlwP , oFlwS ) ) ),;
								aChamados[oLbx3:nAt,19],;	// No de dias TOTAl
								aChamados[oLbx3:nAt,22],;	// Atualizado em
								aChamados[oLbx3:nAt,23],;	// No de dias da Ult. Atualizacao
								aChamados[oLbx3:nAt,20],;
		                       	aChamados[oLbx3:nAt,05],;
		                       	aChamados[oLbx3:nAt,06],;
		                       	aChamados[oLbx3:nAt,07],;
		                       	aChamados[oLbx3:nAt,09],;
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
		@ 015,430 CheckBox oStatus2 Var lAnalise 		Prompt "Em anแlise" 	ON CLICK(AtuOption(2))	Size 040,008 PIXEL OF oPanel
		@ 025,430 CheckBox oStatus3 Var lTransf			Prompt "Transferidos" 	ON CLICK(AtuOption(3))	Size 042,008 PIXEL OF oPanel

		@ 005,474 CheckBox oStatus4 Var lPendente 		Prompt "Pendentes" 		ON CLICK(AtuOption(4))	Size 048,008 PIXEL OF oPanel
		@ 015,474 CheckBox oStatus5 Var lEncerrado 		Prompt "Encerrados" 	ON CLICK(AtuOption(5))	Size 048,008 PIXEL OF oPanel
		@ 025,474 CheckBox oStatus6 Var lTodos 			Prompt "Todos" 			ON CLICK(AtuOption(6))	Size 048,008 PIXEL OF oPanel

		@ 005,518 CheckBox oStatus7 Var lUser 			Prompt "Filtra ID" 		ON CLICK(AtuOption(7))	Size 048,008 PIXEL OF oPanel
		@ 015,518 CheckBox oStatus8 Var lFilaPrj		Prompt "Tira Fila Prj"	ON CLICK(AtuOption(8))	Size 048,008 PIXEL OF oPanel
		@ 025,518 CheckBox oStatus9 Var lProjeto		Prompt "Projeto"		ON CLICK(AtuOption(9))	Size 048,008 PIXEL OF oPanel

	ACTIVATE MSDIALOG oDlgChamados ON INIT EnchoiceBar(oDlgChamados,bOk,bCancel,,aBut)

	RestArea(aArea)

	SetKey(VK_F5,Nil)

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออปฑฑ
ฑฑบFuno    ณ LbxSort()   บ Autor ณ TOTVS SA           บ Data ณ27/10/2011บฑฑ
ฑฑฬออออออออออุอออออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออนฑฑ
ฑฑบDesc.     ณPermite a re-ordena็ใo dos chamados de acordo com o campo   บฑฑ
ฑฑบ          ณselecionado                                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
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
	                            IIF( aChamados[oLbx3:nAt,24] == "1", oFlw1 , IIF( aChamados[oLbx3:nAt,24] == "2", oFlw2 , IIF( aChamados[oLbx3:nAt,24] == "3", oFlw3 , oFlw4 ) ) ),;
	                		    aChamados[oLbx3:nAt,3],;
		                       	aChamados[oLbx3:nAt,4],;
								IIF( aChamados[oLbx3:nAt,21] == "U", oFlwU , IIF( aChamados[oLbx3:nAt,21] == "T", oFlwT , IIF( aChamados[oLbx3:nAt,21] == "P", oFlwP , oFlwS ) ) ),;
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
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออปฑฑ
ฑฑบFuno    ณ AtuOption() บ Autor ณ TOTVS SA           บ Data ณ27/10/2011บฑฑ
ฑฑฬออออออออออุอออออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออนฑฑ
ฑฑบDesc.     ณFuncao que atualiza os objetos de selecao RadioButton na    บฑฑ
ฑฑบ          ณtela de visualizacao dos chamados                           บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
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
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออปฑฑ
ฑฑบFuno    ณ VisuLbx()   บ Autor ณ TOTVS SA           บ Data ณ27/10/2011บฑฑ
ฑฑฬออออออออออุอออออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออนฑฑ
ฑฑบDesc.     ณPermite visualizar o chamado a partir de um ListBox         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function VisuLbx( cChamado )

	Local aArea		:= GetArea()

	// Acerta deletados SYP
	U_Acerta_SYP()

	IF lFirst
		MsgStop("Nenhum chamado selecionado para esta op็ใo. Informe os parโmetros abaixo e pressione F5 para atualizar.",,"INFO")
		Return
	Endif

	DbSelectArea("SZU")
	DbSetOrder(1)
	IF DbSeek( xFilial("SZU") + cChamado )
		u_Web270Edit(,,2)
		// u_LjVerHist()
	Else
		Help("",1,".ERRO.",,"Registro invแlido",4,0)
	Endif

	RestArea(aArea)

Return()
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออปฑฑ
ฑฑบFuno    ณ EditLbx()   บ Autor ณ TOTVS SA           บ Data ณ27/10/2011บฑฑ
ฑฑฬออออออออออุอออออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออนฑฑ
ฑฑบDesc.     ณPermite editar o chamado                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function EditLbx( cChamado )

	Local aArea		:= GetArea()

	Private oFlwS 	 := LoadBitmap( GetResources(), "BR_VERMELHO_OCEAN.BMP" )
	Private oFlwU 	 := LoadBitmap( GetResources(), "BMPUSER.BMP" )
	Private oFlwT 	 := LoadBitmap( GetResources(), "IC_20_USUARIO.GIF" )
	Private oFlwP 	 := LoadBitmap( GetResources(), "IC_SCORECARD.GIF" )

	// Acerta deletados SYP
	U_Acerta_SYP()

	IF lFirst
		MsgStop("Nenhum chamado selecionado para esta op็ใo. Informe os parโmetros abaixo e pressione F5 para atualizar.",,"INFO")
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
	                               	IIF( aChamados[oLbx3:nAt,24] == "1", oFlw1 , IIF( aChamados[oLbx3:nAt,24] == "2", oFlw2 , IIF( aChamados[oLbx3:nAt,24] == "3", oFlw3 , oFlw4 ) ) ),;
	                		       	aChamados[oLbx3:nAt,3],;
			                       	aChamados[oLbx3:nAt,4],;
									IIF( aChamados[oLbx3:nAt,21] == "U", oFlwU , IIF( aChamados[oLbx3:nAt,21] == "T", oFlwT , IIF( aChamados[oLbx3:nAt,21] == "P", oFlwP , oFlwS ) ) ),;
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
		Help("",1,".ERRO.",,"Registro invแlido",4,0)
	Endif

	RestArea(aArea)

Return Nil
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออปฑฑ
ฑฑบFuno    ณ NotifLbx()  บ Autor ณ TOTVS SA           บ Data ณ27/10/2011บฑฑ
ฑฑฬออออออออออุอออออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออนฑฑ
ฑฑบDescricao ณEnvia ficha atualizada do chamado via e-mail                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function NotifLbx( cChamado )

	Local aArea		:= GetArea()

	IF lFirst
		MsgStop("Nenhum chamado selecionado para esta op็ใo. Informe os parโmetros abaixo e pressione F5 para atualizar.",,"INFO")
		Return
	Endif

	DbSelectArea("SZU")
	DbSetOrder(1)
	IF DbSeek( xFilial("SZU") + cChamado )
		u_TECREENV()
	Else
		Help("",1,".ERRO.",,"Registro invแlido",4,0)
	Endif

	RestArea(aArea)

Return Nil
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออปฑฑ
ฑฑบFuno    ณ VldCli ()   บ Autor ณ TOTVS SA           บ Data ณ27/10/2011บฑฑ
ฑฑฬออออออออออุอออออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออนฑฑ
ฑฑบDescricao ณFaz a validacao do campo cliente interno e atualiza a descriบฑฑ
ฑฑบ          ณcao com o nome do departamento.                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
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
			Help("",1,".ERRO.",,"C๓digo invแlido",4,0)
			lRet(.F.)
		Endif
	Endif

Return( lRet )
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออปฑฑ
ฑฑบFuno    ณ MTLoadLbx() บ Autor ณ TOTVS SA           บ Data ณ27/10/2011บฑฑ
ฑฑฬออออออออออุอออออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออนฑฑ
ฑฑบDescricao ณFaz SELECT na base de dados e retorna lista dos chamados de บฑฑ
ฑฑบ          ณacordo com o filtro do usuario.                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function MTLoadLbx(cDTAbrIni,cDTAbrFim,cFilArea,cFilTec,cFilStatus,cDTEncIni,cDTEncFim,cFilCli,cNumChamado,cFilTec2)

	Local aRet	:= {}
	Local lRetSimples := .F.

	If !lAberto .And. !lAnalise .And. !lTransf .And. !lPendente .And. !lEncerrado .And. !lTodos
		MsgStop("Voc๊ deve selecionar pelo menos uma op็ใo para o filtro das informa็๕es.",,"INFO")
		Return
	Endif

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Prepara a query que ira retornar os dados filtrados ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
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
		
		IF lFilaPrj
			cSQL += "ZU_FEEDBAC <> 'P' AND " + cEOL
		Endif	

		IF lProjeto
			cSQL += "ZU_ROTINA = '000011' AND " + cEOL
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


	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Atualiza o ListBox com os dados novos ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
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
						ZU_PRIORID;
						} )

`		TRB->( DbSkip() )
	End
	DbCloseArea()

	If Len(aRet) < 1
		MsgInfo("Nใo existem dados para esta consulta com os parโmetros informados.",,"INFO")
		Return
	Endif

	If !lRetSimples
		aChamados := aClone(aRet)
		aHeadLbx  := { {1,1},{2,2},{3,3},{4,4},{5,21},{6,19},{7,22},{8,23},{9,20},{10,5},{11,6},{12,7},{13,9},{14,10},{15,11},{16,12},{17,13},{18,14},{19,15},{20,16} }
		oLbx3:SetArray( aRet )
		oLbx3:bLine := {|| { 	LoadBitmap( GetResources(), RetLegenda(aRet[oLbx3:nAt,1]) ) ,;
	                            aRet[oLbx3:nAt,02],;
	                            IIF( aChamados[oLbx3:nAt,24] == "1", oFlw1 , IIF( aChamados[oLbx3:nAt,24] == "2", oFlw2 , IIF( aChamados[oLbx3:nAt,24] == "3", oFlw3 , oFlw4 ) ) ),;
	 							aRet[oLbx3:nAt,03],;
		                       	aRet[oLbx3:nAt,04],;
								IIF( aChamados[oLbx3:nAt,21] == "U", oFlwU , IIF( aChamados[oLbx3:nAt,21] == "T", oFlwT , IIF( aChamados[oLbx3:nAt,21] == "P", oFlwP , oFlwS ) ) ),;
		                       	aRet[oLbx3:nAt,19],;
								aRet[oLbx3:nAt,22],;	// Atualizado em
								aRet[oLbx3:nAt,23],;	// No de dias da Ult. Atualizacao
		                       	aRet[oLbx3:nAt,20],;
		                       	aRet[oLbx3:nAt,05],;
		                       	aRet[oLbx3:nAt,06],;
		                       	aRet[oLbx3:nAt,07],;
		                       	aRet[oLbx3:nAt,09],;
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
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออปฑฑ
ฑฑบFuno    ณ RetBmp()    บ Autor ณ TOTVS SA           บ Data ณ27/10/2011บฑฑ
ฑฑฬออออออออออุอออออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออนฑฑ
ฑฑบDescricao ณFuncao para efetuar tratamento dos Bitmaps que sao exibidos บฑฑ
ฑฑบ          ณno listbox.                                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
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
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออปฑฑ
ฑฑบFuno    ณ MTFilterU() บ Autor ณ TOTVS SA           บ Data ณ27/10/2011บฑฑ
ฑฑฬออออออออออุอออออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออนฑฑ
ฑฑบDescricao ณFuncao que realiza filtro por usuแrio de acordo com o       บฑฑ
ฑฑบ          ณusuแrio selecionado.                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function MTFilterU()

	Local cTecPos := aChamados[oLbx3:nAt,14]

	lUser := .T.

	Processa( {|| MTLoadLbx(dDataIni,dDataFim,cEquipe,cTecPos,,,,cCliente,,cTecnico) } , "Lista de chamados","Aguarde ...", .T. )

	lUser := .F.

Return()
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออปฑฑ
ฑฑบFuno    ณ RetLegenda()บ Autor ณ TOTVS SA           บ Data ณ27/10/2011บฑฑ
ฑฑฬออออออออออุอออออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออนฑฑ
ฑฑบDescricao ณRetorna Bitmap a ser usado na legenda                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
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
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออปฑฑ
ฑฑบFuno    ณ FowardLbx() บ Autor ณ TOTVS SA           บ Data ณ27/10/2011บฑฑ
ฑฑฬออออออออออุอออออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออนฑฑ
ฑฑบDescricao ณInterface para distribuicao dos chamados. Permite que os    บฑฑ
ฑฑบ          ณrecursos sejam alocados entre os chamados.                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function FowardLbx()

	Local oDlgFwd
	Local cCodTec	:= ""

	IF lFirst
		MsgStop("Nenhum chamado selecionado para esta op็ใo. Informe os parโmetros abaixo e pressione F5 para atualizar.",,"INFO")
		Return
	Endif

	DEFINE FONT oFNT1  NAME "Arial" 	SIZE 0, -12
	DEFINE MSDIALOG oDlgFwd TITLE "Aloca็ใo de Recursos" FROM 214,188 TO 400,544 PIXEL

		@ 0, 0 BITMAP RESNAME "LOGIN" oF oDlgFwd SIZE 40,100 NOBORDER WHEN .F. PIXEL

		@ 000,042 TO 075,175 LABEL "" PIXEL OF oDlgFwd
		@ 006,047 SAY "Selecione o recurso que deseja alocar" FONT oFNT1 COLOR CLR_BLACK PIXEL OF oDlgFwd

		@ 080,097 BUTTON "Confirmar" 	ACTION (LjMsgRun("Aguarde ... Processando aloca็ใo ..."  ,, { || MTAlocFun(oLbx3:aArray[oLbx3:nAt,2],Substr(cCodTec,1,6) ) }) ,oDlgFwd:End()) SIZE 037,012 PIXEL OF oDlgFwd
		@ 080,137 BUTTON "Cancelar" 	ACTION (oDlgFwd:End()) SIZE 037,012 PIXEL OF oDlgFwd

		@ 016,047 LISTBOX oRecursos Var cCodTec ITEMS aRecursos SIZE 123,055 PIXEL OF oDlgFwd

	ACTIVATE MSDIALOG oDlgFwd CENTERED

Return()
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออปฑฑ
ฑฑบFuno    ณ MTAlocFun() บ Autor ณ TOTVS SA           บ Data ณ27/10/2011บฑฑ
ฑฑฬออออออออออุอออออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออนฑฑ
ฑฑบDescricao ณFuncao que faz a alocacao dos chamados                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
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
		aChamados[oLbx3:nAt,24] := SZU->ZU_PRIORID

		oLbx3:SetArray( aChamados )
		oLbx3:bLine := {|| { 	LoadBitmap( GetResources(), RetLegenda(aChamados[oLbx3:nAt,1]) ) ,;
                               	aChamados[oLbx3:nAt,2],;
                               	IIF( aChamados[oLbx3:nAt,24] == "1", oFlw1 , IIF( aChamados[oLbx3:nAt,24] == "2", oFlw2 , IIF( aChamados[oLbx3:nAt,24] == "3", oFlw3 , oFlw4 ) ) ),;
                		       	aChamados[oLbx3:nAt,3],;
		                       	aChamados[oLbx3:nAt,4],;
								IIF( aChamados[oLbx3:nAt,21] == "U", oFlwU , IIF( aChamados[oLbx3:nAt,21] == "T", oFlwT , IIF( aChamados[oLbx3:nAt,21] == "P", oFlwP , oFlwS ) ) ),;
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
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออปฑฑ
ฑฑบFuno    ณRetRecursos()บ Autor ณ TOTVS SA           บ Data ณ27/10/2011บฑฑ
ฑฑฬออออออออออุอออออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออนฑฑ
ฑฑบDescricao ณRetorna os usuarios cadastrados no cadastro de usuario      บฑฑ
ฑฑบ          ณcomo tecnicos habilitados para uso da ferramenta.           บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
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
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออปฑฑ
ฑฑบFuno    ณ ExpHtml()   บ Autor ณ TOTVS SA           บ Data ณ27/10/2011บฑฑ
ฑฑฬออออออออออุอออออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออนฑฑ
ฑฑบDescricao ณExporta a ficha do chamado em HTML para impressao           บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
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

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ LegPri   บ Autor ณ Fernando Nogueira  บ Data ณ 06/02/2017  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Legendas da Prioridade do Chamado                          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function LegPri()

	aLegenda := {}
	aAdd( aLegenda, { "BR_VIOLETA" 	, "Urgente" } )
	aAdd( aLegenda, { "BR_VERMELHO"	, "Alta"    } )
	aAdd( aLegenda, { "BR_AMARELO" 	, "Media" } )
	aAdd( aLegenda, { "BR_AZUL"  	, "Baixa" } )

	BrwLegenda("Prioridades do Chamado (P)" ,"Legenda" ,aLegenda) 
	                                    
Return
