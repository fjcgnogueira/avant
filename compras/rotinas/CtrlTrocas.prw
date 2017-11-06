#Include "Protheus.Ch"
#INCLUDE 'FWMVCDEF.CH'
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � CtrlTrocas  � Autor � Fernando Nogueira  � Data �28/03/2014���
�������������������������������������������������������������������������͹��
���Descri��o � Controle de Trocas                                         ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico AVANT.                                          ���
�������������������������������������������������������������������������͹��
���Analista Resp.�  Data  � Manutencao Efetuada                           ���
�������������������������������������������������������������������������͹��
���              �  /  /  �                                               ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function CtrlTrocas(cAlias,nReg,nOpcx)

Local cTitulo      := "Controle de Trocas"
Local cAliasEnch   := "SZH"
Local cAliasGetDad := "SZI"
Local cLinOk       := "U_VldLinTrc()"
Local cTudOk       := "AllwaysTrue()"
Local cFieldOk     := "AllwaysTrue()"
Local aCpoEnch     := {}
Local nX           := 0

Private nUsado  := 0
Private aBotoes	:= {}
Private nQtdTot := 0
Private nVlrTot := 0
Private oDlg
Private nPosQtd := 0
Private nPosVlr := 0

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

	//��������������������������������������������������������������Ŀ
	//� Cria variaveis M->????? da Enchoice                          �
	//����������������������������������������������������������������
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

	//��������������������������������������������������������������Ŀ
	//� Campos carregados no aHeader                                 �
	//����������������������������������������������������������������
	dbSelectArea("SX3")
	dbSeek("SZI")
	aHeader:={}
	While !Eof().And.(x3_arquivo=="SZI")
		If Alltrim(x3_campo) $ "ZI_NUMTRC.ZI_CLIENTE.ZI_LOJA"
			dbSkip()
			Loop
		Endif
		If X3USO(x3_usado).And.cNivel>=x3_nivel.And.cNivel<9
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

	//��������������������������������������������������������������Ŀ
	//� Carga do aCols                                               �
	//����������������������������������������������������������������
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
	    //�����������������������������������������������������Ŀ
	    //� Executa a Modelo 3                                  �
	    //�������������������������������������������������������

	    aAdd( aBotoes,{"ANEXO"  ,{|| MsAnxItem() },"Anexo"  })
	    aAdd( aBotoes,{"ANALISE",{|| AnaliseTRC()},"Analise"})

	    nPosQtd  := aScan(aHeader,{|x| AllTrim(x[2]) == "ZI_QUANT"})
    	nPosVlr  := aScan(aHeader,{|x| AllTrim(x[2]) == "ZI_VLRTOTA"})

    	For J := 1 To Len(aCols)
			If !aCols[J,Len(aHeader)+1]
				nQtdTot += aCols[J,nPosQtd]
				nVlrTot += aCols[J,nPosVlr]
			Endif
		Next J

	    lRetMod3 := U_ModeloFN(cTitulo, cAliasEnch, cAliasGetDad, aCpoEnCh, cLinOk, cTudOk, nOpcE, nOpcG, cFieldOk, , , , , aBotoes)

	    /*
		Modelo3[1]  -> C (    7) [CTITULO]      Titulo do(a) "Dialog"/Janela
		Modelo3[2]  -> C (    7) [CALIAS1]      Alias Usado na Enchoice
		Modelo3[3]  -> C (    7) [CALIAS2]      Alias Usado na Alias da GetDados
		Modelo3[4]  -> C (    8) [AMYENCHO]     Array com campos a serem usados na Enchoice
		Modelo3[5]  -> C (    6) [CLINOK]       String com a Funcao a ser usada para valida a Linha da GetDados
		Modelo3[6]  -> C (    7) [CTUDOOK]      String com a Funcao para Validar o Tudo Ok da GetDados
		Modelo3[7]  -> C (    5) [NOPCE]        Tipo de Opera��o a ser executada na Enchoice (Visualizar ou Alterar ...)
		Modelo3[8]  -> C (    5) [NOPCG]        Tipo de Opcao a ser executada na GetDados (visualizar, Incluir, Alterar ... )
		Modelo3[9]  -> C (    8) [CFIELDOK]     Fun��o para validacao de todos os campos da GetDados
		Modelo3[10] -> C (    8) [LVIRTUAL]     Se os campos Virtuais dever�o aparecer na Enchoice
		Modelo3[11] -> C (    7) [NLINHAS]      Numero Maximo de linhas que ser�o suportadas pela GetDados
		Modelo3[12] -> C (   12) [AALTENCHOICE] Array contendo os campos Alteraveis na Enchoice
		Modelo3[13] -> C (    7) [NFREEZE]      Posi��o para o Congelamento (Freeze) de Colunas na GetDados
		Modelo3[14] -> C (    8) [ABUTTONS]     Botoes a serem disponibizados na EnchoiceBar
		Modelo3[15] -> C (    6) [ACORDW]       Coordenadas do(a) "Dialog"/janela
		Modelo3[16] -> C (   11) [NSIZEHEADER]  Valor para Alinhamento dos Objetos
		*/

	    //�����������������������������������������������������Ŀ
	    //� Executar processamento                              �
	    //�������������������������������������������������������
	    If lRetMod3
	    	//Aviso("Controle de Trocas","Opera��o Confirmada!",{"Ok"})

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
	ApMsgAlert("Essa nota n�o � de Troca")
Endif

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao    � VldLinTrc() � Autor � Fernando Nogueira  � Data �10/08/2015���
�������������������������������������������������������������������������͹��
���Desc.     � Validacao da linha do controle de trocas				   	  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function VldLinTrc()

Local nPosProd := aScan(aHeader,{|x| AllTrim(x[2]) == "ZI_PRODUTO"})
Local cProduto := AllTrim(aCols[n,nPosProd])

nQtdTot := 0
nVlrTot := 0

For J := 1 To Len(aCols)
	If !aCols[J,Len(aHeader)+1]
		nQtdTot += aCols[J,nPosQtd]
		nVlrTot += aCols[J,nPosVlr]
	Endif
Next J

Eval(oDlg:Cargo,nQtdTot,nVlrTot)

If aCols[n,Len(aHeader)+1] .And. !Empty(GdFieldGet('ZI_NFORI'))
	ApMsgInfo('N�o pode deletar item original.')
	Return .F.
ElseIf !aCols[n,Len(aHeader)+1] .And. Empty(GdFieldGet('ZI_NFORI')) .And. FwFldGet('ZI_QTDTRC') == 0
	ApMsgInfo('Item n�o original deve ter quantidade de troca.')
	Return .F.
Else
	 For I := 1 To Len(aCols)
	 	If I <> n .And. AllTrim(aCols[I,nPosProd]) == cProduto .And. !aCols[n,Len(aHeader)+1] .And. !aCols[I,Len(aHeader)+1]
	 		ApMsgInfo('Produto Repetido.')
	 		Return .F.
	 	Endif
	 Next I
Endif

Return .T.

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao    � MsAnxItem() � Autor � Fernando Nogueira  � Data �25/05/2014���
�������������������������������������������������������������������������͹��
���Desc.     � Faz anexo de foto ao laudo                                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
			ApMsgAlert("Anexar arquivos com Extens�o 'JPG'")
		Endif
	Endif

Return()

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao    � Grv_Anexo() � Autor � Fernando Nogueira  � Data �25/05/2014���
�������������������������������������������������������������������������͹��
���Desc.     � Grava um item com o anexo... 						   	  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao    � AnaliseTRC()� Autor � Fernando Nogueira  � Data �23/06/2015���
�������������������������������������������������������������������������͹��
���Desc.     � Incluir as Ocorrencias de Trocas						   	  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function AnaliseTRC()

	Local nRet	      := 0
	Local nPosItemTrc := aScan(aHeader,{|x| AllTrim(x[2]) == "ZI_ITEM"})
	Local cExprFilTop := "(ZO_FILIAL+ZO_NUMTRC+ZO_ITEMTRC = '"+AllTrim(SM0->M0_CODFIL)+SF1->F1_NUMTRC+aCols[n][nPosItemTrc]+"')"

	Private cString
	Private cAlias		:= "SZO"
	Private cCadastro 	:= "Analise de Trocas"
	Private aRotina := { {"Pesquisar" 	,"AxPesqui"    ,0,1} ,;
	             		 {"Visualizar"	,"AxVisual"    ,0,2} ,;
	             		 {"Incluir"   	,"U_CtrlTrInc" ,0,3} ,;
	             		 {"Alterar"    	,"AxAltera"    ,0,4} ,;
	             		 {"Excluir"		,"AxDeleta"    ,0,5} }

	Private cDelFunc 	:= ".T."
	Private cString 	:= "SZO"

	DbSelectArea("SZO")
	DbSetOrder(1)

	mBrowse(6,1,22,75,"SZO",,,,,,,,,,,,,,cExprFilTop)

Return()

/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao	 � CtrlTrInc  � Autor � Fernando Nogueira   � Data �27/07/2015���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Inclusao de Ocorrencia de Troca                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso		 � Especifico Avant                                           ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function CtrlTrInc(cAlias,nReg,nOpc)
Local nOpca

nOpca := AxInclui(cAlias,nReg,nOpc,,,,"U_ACtrlTrOk()")
dbSelectArea(cAlias)

Return nOpca

/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao	 � ACtrlTrOk  � Autor � Fernando Nogueira   � Data �27/07/2015���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Validacao na Inclusao da Ocorrencia de Trocas              ���
�������������������������������������������������������������������������Ĵ��
��� Uso		 � Especifico Avant                                           ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function ACtrlTrOk()
Local lRet  := .T.
Local aArea := { Alias() }

If SF1->F1_FILIAL <> AllTrim(SM0->M0_CODFIL)
	ApMsgInfo("Utilizar a Mesma Filial da Troca.")
	lRet := .F.
EndIf

dbSelectArea( aArea[1] )
Return lRet


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao    � NumAnalise()� Autor � Fernando Nogueira  � Data �25/06/2015���
�������������������������������������������������������������������������͹��
���Desc.     � Numeracao das Analises no Inicializador Padrao             ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function NumAnalise()

nNumAnalise := 1

dbSelectArea("SZO")
dbSetOrder(1)

While SZO->(!EoF()) .And. dbSeek(xFilial("SZO")+M->ZH_NUMTRC+STRZERO(N,4)+StrZero(nNumAnalise,4))
	nNumAnalise++
	SZO->(dbSkip())
End

Return(StrZero(nNumAnalise,4))

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao	 � ModeloFN	  � Autor � Fernando Nogueira   � Data � 12/08/15 ���
�������������������������������������������������������������������������Ĵ��
���Descricao �Copia e adaptacao do Modelo3 da Totvs 					  ���
�������������������������������������������������������������������������Ĵ��
���Parametros�lRet:=Modelo3(cTitulo,cAlias1,cAlias2,aMyEncho,cLinOk, 	  ���
���			 � cTudoOk,nOpcE,nOpcG,cFieldOk,lVirtual,nLinhas,aAltEnchoice)���
���			 �lRet=Retorno .T. Confirma / .F. Abandona					  ���
���			 �cTitulo=Titulo da Janela 									  ���
���			 �cAlias1=Alias da Enchoice									  ���
���			 �cAlias2=Alias da GetDados									  ���
���			 �aMyEncho=Array com campos da Enchoice						  ���
���			 �cLinOk=LinOk 												  ���
���			 �cTudOk=TudOk 												  ���
���			 �nOpcE=nOpc da Enchoice									  ���
���			 �nOpcG=nOpc da GetDados									  ���
���			 �cFieldOk=validacao para todos os campos da GetDados 		  ���
���			 �lVirtual=Permite visualizar campos virtuais na enchoice	  ���
���			 �nLinhas=Numero Maximo de linhas na getdados				  ���
���			 �aAltEnchoice=Array com campos da Enchoice Alteraveis		  ���
���			 �nFreeze=Congelamento das colunas.                           ���
�������������������������������������������������������������������������Ĵ��
��� Uso		 �RdMake 													  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function ModeloFN(cTitulo,cAlias1,cAlias2,aMyEncho,cLinOk,cTudoOk,nOpcE,nOpcG,cFieldOk,lVirtual,nLinhas,aAltEnchoice,nFreeze,aButtons,aCordW,nSizeHeader)
Local lRet, nOpca := 0,cSaveMenuh,nReg:=(cAlias1)->(Recno())//,oDlg
Local oEnchoice
Local nDlgHeight
Local nDlgWidth
Local nDiffWidth := 0
Local lMDI := .F.
Local aPosObj  := {}
Local aObjects := {}
Local aSize    := {}
Local aPosGet  := {}
Local aInfo    := {}
Local nGetLin  := 0
Local oSAY1
Local oSAY2

Private Altera:=.t.,Inclui:=.t.,lRefresh:=.t.,aTELA:=Array(0,0),aGets:=Array(0),;
bCampo:={|nCPO|Field(nCPO)},nPosAnt:=9999,nColAnt:=9999
Private cSavScrVT,cSavScrVP,cSavScrHT,cSavScrHP,CurLen,nPosAtu:=0

nOpcE := If(nOpcE==Nil,3,nOpcE)
nOpcG := If(nOpcG==Nil,3,nOpcG)
lVirtual := Iif(lVirtual==Nil,.F.,lVirtual)
nLinhas:=Iif(nLinhas==Nil,99,nLinhas)

If SetMDIChild()
	oMainWnd:ReadClientCoors()
	nDlgHeight := oMainWnd:nHeight
	nDlgWidth := oMainWnd:nWidth
	lMdi := .T.
	nDiffWidth := 0
Else
	nDlgHeight := 420
	nDlgWidth	:= 632
	nDiffWidth := 1
EndIf

Default aCordW := {135,000,nDlgHeight,nDlgWidth}
Default nSizeHeader := 110

aSize := MsAdvSize()
aObjects := {}
AAdd( aObjects, { 100, 100, .t., .t. } )
AAdd( aObjects, { 100, 100, .t., .t. } )
AAdd( aObjects, { 100, 020, .t., .f. } )

aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }
aPosObj := MsObjSize( aInfo, aObjects )

aPosGet := MsObjGetPos(aSize[3]-aSize[1],315,;
	{{020,040,080,100,200,220,260,280}} )

DEFINE MSDIALOG oDlg TITLE cTitulo From aCordW[1],aCordW[2] to aCordW[3],aCordW[4] Pixel of oMainWnd
If lMdi
	oDlg:lMaximized := .T.
EndIf

oEnchoice := Msmget():New(cAlias1,nReg,nOpcE,,,,aMyEncho,{13,1,(nSizeHeader/2)+13,If(lMdi, (oMainWnd:nWidth/2)-2,__DlgWidth(oDlg)-nDiffWidth)},aAltEnchoice,3,,,,oDlg,,lVirtual,,,,,,,,.T.)

nGetLin := aPosObj[3,1]
@ nGetLin+10,aPosGet[1,1]  SAY "Qtd. Original :"  SIZE 040,09 OF oDlg PIXEL
@ nGetLin+10,aPosGet[1,2]  SAY oSAY1 VAR nQtdTot PICTURE PesqPict("SZI","ZI_QUANT") SIZE 060,09 OF oDlg	PIXEL
@ nGetLin+10,aPosGet[1,3]  SAY "Valor Original :" SIZE 040,09 OF oDlg PIXEL
@ nGetLin+10,aPosGet[1,4]  SAY oSAY2 VAR nVlrTot PICTURE PesqPict("SZI","ZI_QUANT") SIZE 060,09 OF oDlg	PIXEL
@ nGetLin+10,aPosGet[1,5]  SAY "Qtd. Troca :"  SIZE 040,09 OF oDlg PIXEL
@ nGetLin+10,aPosGet[1,6]  SAY oSAY1 VAR nQtdTot PICTURE PesqPict("SZI","ZI_QUANT") SIZE 060,09 OF oDlg	PIXEL
@ nGetLin+10,aPosGet[1,7]  SAY "Valor Troca :" SIZE 040,09 OF oDlg PIXEL
@ nGetLin+10,aPosGet[1,8]  SAY oSAY2 VAR nVlrTot PICTURE PesqPict("SZI","ZI_QUANT") SIZE 060,09 OF oDlg	PIXEL

oDlg:Cargo := {|n1,n2| oSay1:SetText(n1),oSay2:SetText(n2)}

oGetDados := MsGetDados():New((nSizeHeader/2)+13+2,1,If(lMdi, (oMainWnd:nHeight/2)-44,__DlgHeight(oDlg)),If(lMdi, (oMainWnd:nWidth/2)-2,__DlgWidth(oDlg)-nDiffWidth),nOpcG,cLinOk,cTudoOk,"",.T.,,nFreeze,,nLinhas,cFieldOk,,,,oDlg)

ACTIVATE MSDIALOG oDlg ON INIT (EnchoiceBar(oDlg,{||nOpca:=1,If(oGetDados:TudoOk(),If(!obrigatorio(aGets,aTela),nOpca := 0,oDlg:End()),nOpca := 0)},{||oDlg:End()},,aButtons))

lRet:=(nOpca==1)
Return lRet
