#Include "Protheus.Ch"
#INCLUDE 'FWMVCDEF.CH'
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ CtrlTrocas  º Autor ³ Fernando Nogueira  º Data ³28/03/2014º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Controle de Trocas                                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico AVANT.                                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÏÍÍÍÑÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAnalista Resp.³  Data  ³ Manutencao Efetuada                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º              ³  /  /  ³                                               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function CtrlTrocas(cAlias,nReg,nOpcx)

Local cTitulo      := "Controle de Trocas"
Local cAliasEnch   := "SZH"
Local cAliasGetDad := "SZI"
Local cLinOk       := "AllwaysTrue()"
Local cTudOk       := "AllwaysTrue()"
Local cFieldOk     := "AllwaysTrue()"
Local aCpoEnch     := {}
Local nX           := 0

Private nUsado  := 0
Private aBotoes	:= {}

cAlias := "SZH"
nOpcx  := 4

INCLUI 	:= nOpcx==3
ALTERA 	:= nOpcx==4
EXCLUI 	:= nOpcx==5

nOpce := nOpcG := nOpcx
aRecnosSZI := {}

SZH->(dbSetOrder(1))

If SZH->(dbSeek(xFilial()+SF1->F1_NUMTRC))

	Default nReg := SZH->(Recno())

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Cria variaveis M->????? da Enchoice                          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aCposSZH := GetaHeader("SZH",,)
	RegToMemory("SZH",INCLUI)
	DbSelectArea("SX3")
	DbSetOrder(1)
	DbSeek("SZH")
	SZH->(dbSeek(xFilial("SZH")+SF1->F1_NUMTRC))
	While !Eof().And.(x3_arquivo=="SZH")
		If X3USO(x3_usado) .And. cNivel>=x3_nivel .And. !(Alltrim(x3_campo) $ ("ZH_FILIAL.ZH_STATUS"))
			AADD(aCpoEnch,x3_campo)
		Endif
		//&("M->"+x3_campo):= CriaVar(x3_campo)
		&("M->"+x3_campo):= &("SZH->"+x3_campo)
		dbSkip()
	End
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Campos carregados no aHeader                                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ		
	dbSelectArea("SX3")
	dbSeek("SZI")
	aHeader:={}
	While !Eof().And.(x3_arquivo=="SZI")
		If Alltrim(x3_campo) $ "ZI_NUMTRC.ZI_CLIENTE.ZI_LOJA"
			dbSkip()
			Loop
		Endif
		If X3USO(x3_usado).And.cNivel>=x3_nivel
			nUsado:=nUsado+1
			AADD(aHeader,{ Trim(X3Titulo()), ;
				X3_CAMPO,;
				X3_PICTURE, ;
				X3_TAMANHO, ;
				X3_DECIMAL, ;
				"AllwaysTrue()" , ;
				X3_USADO,;
				X3_TIPO, ;
				X3_ARQUIVO,;
				X3_CONTEXT } )
		Endif
	    dbSkip()
	End
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Carga do aCols                                               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If nOpcx == 3  // Incluir
	     aCols:={Array(nUsado+1)}
	     aCols[1,nUsado+1]:=.F.
	     For nX:=1 to nUsado
	     	aCols[1,nX]:=CriaVar(aHeader[nX,2])
	     Next
	ElseIf nOpcx == 4  // Alterar
	     aCols:={}
	     dbSelectArea("SZI")
	     dbSetOrder(1)
	     dbSeek(xFilial()+SF1->F1_NUMTRC)
	     While !EoF().And. ZI_NUMTRC == SF1->F1_NUMTRC
	          AADD(aCols,Array(nUsado+1))
	          For nX:=1 to nUsado
	               aCols[Len(aCols),nX]:=FieldGet(FieldPos(aHeader[nX,2]))
	          Next
	          aCols[Len(aCols),nUsado+1]:=.F.
	          aAdd( aRecnosSZI , Recno() )
	          dbSkip()
	     End
	Endif
	
	If Len(aCols) > 0
	    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	    //³ Executa a Modelo 3                                  ³
	    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	    
	    aAdd( aBotoes,{"ANEXO"  ,{|| MsAnxItem() },"Anexo"  })
	    aAdd( aBotoes,{"ANALISE",{|| AnaliseTRC()},"Analise"})
	
	    lRetMod3 := Modelo3(cTitulo, cAliasEnch, cAliasGetDad, aCpoEnCh, cLinOk, cTudOk, nOpcE, nOpcG, cFieldOk, , , , , aBotoes)
	    
	    /* 
		Modelo3[1]  -> C (    7) [CTITULO]      Titulo do(a) "Dialog"/Janela
		Modelo3[2]  -> C (    7) [CALIAS1]      Alias Usado na Enchoice
		Modelo3[3]  -> C (    7) [CALIAS2]      Alias Usado na Alias da GetDados
		Modelo3[4]  -> C (    8) [AMYENCHO]     Array com campos a serem usados na Enchoice
		Modelo3[5]  -> C (    6) [CLINOK]       String com a Funcao a ser usada para valida a Linha da GetDados
		Modelo3[6]  -> C (    7) [CTUDOOK]      String com a Funcao para Validar o Tudo Ok da GetDados
		Modelo3[7]  -> C (    5) [NOPCE]        Tipo de Operação a ser executada na Enchoice (Visualizar ou Alterar ...)
		Modelo3[8]  -> C (    5) [NOPCG]        Tipo de Opcao a ser executada na GetDados (visualizar, Incluir, Alterar ... )
		Modelo3[9]  -> C (    8) [CFIELDOK]     Função para validacao de todos os campos da GetDados
		Modelo3[10] -> C (    8) [LVIRTUAL]     Se os campos Virtuais deverão aparecer na Enchoice
		Modelo3[11] -> C (    7) [NLINHAS]      Numero Maximo de linhas que serão suportadas pela GetDados
		Modelo3[12] -> C (   12) [AALTENCHOICE] Array contendo os campos Alteraveis na Enchoice
		Modelo3[13] -> C (    7) [NFREEZE]      Posição para o Congelamento (Freeze) de Colunas na GetDados
		Modelo3[14] -> C (    8) [ABUTTONS]     Botoes a serem disponibizados na EnchoiceBar
		Modelo3[15] -> C (    6) [ACORDW]       Coordenadas do(a) "Dialog"/janela
		Modelo3[16] -> C (   11) [NSIZEHEADER]  Valor para Alinhamento dos Objetos
		*/	     
	     
	    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	    //³ Executar processamento                              ³
	    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	    If lRetMod3
	    	//Aviso("Controle de Trocas","Operação Confirmada!",{"Ok"})
	    	
			// Grava Cabecalho
			DbSelectArea("SZH")
			If ALTERA .or. INCLUI
				DbGoTo(nReg)			
			EndIf
			
			If ALTERA .or. INCLUI
		
				/*SZH->(RecLock("SZH",INCLUI))
				
				// Grava campos que nao estao disponiveis na tela
				SZH->ZH_FILIAL	:= xFilial("SZH")
				If INCLUI
					SZH->ZH_STATUS := "1"
				EndIf
				AEval(aCposSZH, {|x,y| If(!(Alltrim(x[2])$"") .and. x[10]<>"V" , FieldPut(FieldPos(x[2]),&("M->"+x[2])) , .F. ) })
				
				MsUnLock()*/
		
			ElseIf EXCLUI
		
				RecLock("SZI",INCLUI)
					DbDelete()
				MsUnLock()
			
			EndIf
			
			// Grava Itens
			DbSelectArea("SZI")
			For _nX := 1 To Len(aCols)
				
				If (aCols[_nX,Len(aHeader)+1] .And. Len(aRecnosSZI) <= _nX) .or. EXCLUI // Deletado
				
					DbGoto(aRecnosSZI[_nX])
					RecLock("SZI",.F.)
						DbDelete()
					MsUnLock()
				
				ElseIf INCLUI .or. Len(aRecnosSZI) < _nX

					RecLock("SZI",.T.)
						SZI->ZI_FILIAL	:= xFilial("SZI")
						SZI->ZI_NUMTRC	:= SF1->F1_NUMTRC
						AEval(aHeader, {|x,y|  If(!(Alltrim(x[2])$"") .and. x[10]<>"V" , FieldPut(FieldPos(x[2]),aCols[_nX,y]) , .F. ) })	
					MsUnLock()
				
				ElseIf ALTERA
		
					DbGoto(aRecnosSZI[_nX])
					RecLock("SZI",.F.)
						AEval(aHeader, {|x,y|  If(!(Alltrim(x[2])$"") .and. x[10]<>"V" , FieldPut(FieldPos(x[2]),aCols[_nX,y]) , .F. )  })
					MsUnLock()
				
				EndIf
			Next
	    Endif
	Endif
Else
	ApMsgAlert("Essa nota não é de Troca")
Endif

Return 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³ MsAnxItem() º Autor ³ Fernando Nogueira  º Data ³25/05/2014º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Faz anexo de foto ao laudo                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function MsAnxItem()

	Local _cAnexo := Space(999999)
	Local oDlgSalva, oDirect
	Local _lRet := .F.
	Local nOpcao
	Local _nI

	DEFINE MSDIALOG oDlgSalva FROM  154,321 TO 280,643 TITLE OemToAnsi("Envio de anexo:") PIXEL

	@  7,5 SAY OemToAnsi("Informe a Imagem 'JPG' a ser anexada:") Size 125,8 OF oDlgSalva PIXEL COLOR CLR_BLUE
	@ 22,5 MSGET oDirect VAR _cAnexo F3 "DIR" Picture "@x" SIZE 140,10 OF oDlgSalva PIXEL

	DEFINE SBUTTON FROM 43, 95 TYPE 1 PIXEL ACTION (nOpcao:=1, oDlgSalva:End()) ENABLE OF oDlgSalva
	DEFINE SBUTTON FROM 43,127 TYPE 2 PIXEL ACTION (nOpcao:=2, oDlgSalva:End()) ENABLE OF oDlgSalva

	ACTIVATE MSDIALOG oDlgSalva CENTER

	If (nOpcao==1)
		If Right(Upper(AllTrim(_cAnexo)),4) == '.JPG'
			Grv_Anexo(_cAnexo)
		Else
			ApMsgAlert("Anexar arquivos com Extensão 'JPG'")
		Endif
	Endif

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³ Grv_Anexo() º Autor ³ Fernando Nogueira  º Data ³25/05/2014º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Grava um item com o anexo... 						   	  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Grv_Anexo(_cAnexo)

	Local nPosQtdFotos := aScan(aHeader,{|x| AllTrim(x[2]) == "ZI_QTDFOTO"})

	cNomeAnt := AllTrim(_cAnexo)

	nItem := n
	nFoto := 1

	cDirDest := '\web\ws\trocas\'+M->ZH_NUMTRC
	MakeDir(cDirDest)
    
	CpyT2S(AllTrim(_cAnexo), cDirDest, .F.)
	
	cArqOrig  := cDirDest+'\'+cNomeAnt
	cNomeNovo := cDirDest+'\'+M->ZH_NUMTRC+'_'+StrZero(nItem,4)+'_'+StrZero(nFoto,2)+'.JPG'
	
	While File(cNomeNovo)
		nFoto++
		cNomeNovo := cDirDest+'\'+M->ZH_NUMTRC+'_'+StrZero(nItem,4)+'_'+StrZero(nFoto,2)+'.JPG'
	End
	
	// Deixa somente o nome do arquivo, sem o caminho de pastas
	While At("\",cNomeAnt) > 0
		cNomeAnt := SubStr(cNomeAnt,At("\",cNomeAnt)+1,Len(cNomeAnt))
	End		
	
	// Renomeia o Arquivo
	cNomeAnt := cDirDest + '\' + cNomeAnt
	If FRename(cNomeAnt,cNomeNovo) <> -1
		MsgInfo("Imagem Anexada!")
		aCols[n][nPosQtdFotos]++
	Endif

Return()

Static Function AnaliseTRC()

	Local nRet	:= 0
	
	Private cString
	Private cAlias		:= "SZO"
	Private cCadastro 	:= "Analise de Trocas"
	Private aRotina := { {"Pesquisar" 	,"AxPesqui" ,0,1} ,;
	             		 {"Visualizar"	,"AxVisual" ,0,2} ,;
	             		 {"Incluir"   	,"AxInclui" ,0,3} ,;
	             		 {"Alterar"    	,"AxAltera" ,0,4} ,;
	             		 {"Excluir"		,"AxDeleta" ,0,5} }
	             		 
	Private cDelFunc 	:= ".T." 
	Private cString 	:= "SZO"

	DbSelectArea("SZO")
	DbSetOrder(1)
	
	mBrowse(6,1,22,75,"SZO",,,,,,,)

Return()

User Function NumAnalise()

nNumAnalise := 1

dbSelectArea("SZO")
dbSetOrder(1)

While SZO->(!EoF()) .And. dbSeek(xFilial("SZO")+M->ZH_NUMTRC+STRZERO(N,4)+StrZero(nNumAnalise,4))
	nNumAnalise := nNumAnalise + 1
	SZO->(dbSkip())
End

Return(StrZero(nNumAnalise,4))