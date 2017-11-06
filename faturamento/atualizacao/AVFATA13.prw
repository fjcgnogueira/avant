#include "TOTVS.ch"

/*----------------------+--------------------------------+------------------+
|   Programa: AVFATA13  | Autor: Kley@TOTVS              | Data: 04/06/2014 |
+-----------------------+--------------------------------+------------------+
|  Descricao:  Previsão de Entrega de Compras
+---------------------------------------------------------------------------+
|    Projeto:  AVANT
+---------------------------------------------------------------------------+
|    Sintaxe:  U_AVFATA13()
+----------------------------------------------------------------------------
|    Retorno:  Nulo
+--------------------------------------------------------------------------*/

User Function AVFATA13()

Local cAlias := "SZX"

Private cCadastro	:= "Previsão de Entrega de Compras"
Private aRotina 	:= {}
Private cDelFunc 	:= ".T." // Validacao para a exclusao. Pode-se utilizar ExecBlock

//AxCadastro("SZX","Previsão de Compras")

aAdd(aRotina,{"Pesquisar"	,"AxPesqui"   ,0,1})
aAdd(aRotina,{"Visualizar"	,"U_AVF13Man" ,0,2})
aAdd(aRotina,{"Incluir"		,"U_AVF13Man" ,0,3})
aAdd(aRotina,{"Alterar"		,"U_AVF13Man" ,0,4})
aAdd(aRotina,{"Excluir"		,"U_AVF13Man" ,0,5})

aAdd(aRotina,{"Exporta CSV" ,"U_AVF13Exp" ,0,4})
aAdd(aRotina,{"Importa CSV" ,"U_AVF13Imp" ,0,4})

dbSelectArea(cAlias)
dbSetOrder(1)
mBrowse( 6,1,22,75,cAlias)

DbCloseArea(cAlias)

Return


/*----------------------+--------------------------------+------------------+
|   Programa: AVF13Man  | Autor: Kley@TOTVS              | Data: 24/03/2014 |
+-----------------------+--------------------------------+------------------+
|  Descricao:  Previsão de Entrega de Compras - VISUALIZAÇÃO
+---------------------------------------------------------------------------+
|        Uso:  U_AVFATA13()
+--------------------------------------------------------------------------*/

User Function AVF13Man(cAlias,nReg,nOpc)

Local nX			:= 0
Local nUsado		:= 0
Local aButtons	:= {}
Local aCpoEnch	:= {}
Local cAliasE		:= cAlias
Local aAlterEnch	:= {"ZX_CODPREV","ZX_DESPREV","ZX_ANO"}
Local aPos 		:= {000,000,080,650}	//{000,000,080,400}
Local nModelo		:= 3
Local lF3			:= .F.
Local lMemoria	:= .T.
Local lColumn		:= .F.
Local caTela		:= ""
Local lNoFolder	:= .F.
Local lProperty	:= .F.
Local aCpoGDa		:= {}
Local cAliasGD	:= cAlias
Local nSuperior	:= 061	//081
Local nEsquerda	:= 000
Local nInferior	:= 250
Local nDireita	:= 650	//400
Local cLinOk		:= "AllwaysTrue"
Local cTudoOk 	:= "AllwaysTrue"
Local cIniCpos 	:= ""
Local nFreeze 	:= 0	//1
Local nMax 		:= 999
Local cFieldOk 	:= "AllwaysTrue"
Local cSuperDel 	:= ""
//Local bSZXGdDelOk	:= { |lDelOk| CursorWait(), lDelOk := AVF13DelOk( "SZX", NIL, nOpc, cZWxCodPro, nSZXOrder ) , CursorArrow() , lDelOk }
Local bSZXGdDelOk	:= { |lDelOk| CursorWait(), lDelOk := .T., CursorArrow(), lDelOk }
Local aHeader 	:= {}
Local aCols 		:= {}
Local aAlterGDa 	:= {}
Local nStyle  	:= 0
Local lConfirOk	:= .F.
Local aAliasSZX	:= {}

Private oDlg
Private oGetD
Private oEnch
Private aTELA[0][0]
Private aGETS[0]

// Variaveis da Enchoice
Private cCodFil  	:= xFilial("SZX")
Private cCodPrev	:= SZX->ZX_CODPREV
Private cAno   		:= SZX->ZX_ANO

// Campos da Enchoice
DbSelectArea("SX3")
SX3->(DbSetOrder(1), DbGoTop())
DbSeek(cAliasE)
While !Eof() .And. SX3->X3_ARQUIVO == cAliasE
	If RTrim(SX3->X3_CAMPO) $ "ZX_CODPREV/ZX_DESPREV/ZX_ANO" .And. cNivel >= SX3->X3_NIVEL .And. X3Uso(SX3->X3_USADO)
		aAdd(aCpoEnch,SX3->X3_CAMPO)
	EndIf
	SX3->(DbSkip())
End
aAdd(aCpoEnch,"NOUSER")	//Exibe apenas os campos selecionados acima

aAlterEnch := aClone(aCpoEnch)

// Campos da GetDados
DbSelectArea("SX3")
SX3->(DbSetOrder(1), DbGoTop())
MsSeek(cAliasGD)
While !Eof() .And. SX3->X3_ARQUIVO == cAliasGD
	If RTrim(SX3->X3_CAMPO) $ "ZX_CODPROD/ZX_DESPROD/ZX_MES01/ZX_MES02/ZX_MES03/ZX_MES04/ZX_MES05/ZX_MES06/ZX_MES07/ZX_MES08/ZX_MES09/ZX_MES10/ZX_MES11/ZX_MES12" .and.;
		cNivel >= SX3->X3_NIVEL .And. X3Uso(SX3->X3_USADO)
		aAdd(aCpoGDa,SX3->X3_CAMPO)
	EndIf
	SX3->(DbSkip())
End

aAlterGDa := aClone(aCpoGDa)

// aHeader
nUsado:=0
dbSelectArea("SX3")
SX3->(DbSetOrder(1), DbGoTop())
DbSeek(cAliasGD)
aHeader:={}
While !Eof().And.(x3_arquivo==cAliasGD)
	If RTrim(SX3->X3_CAMPO) $ "ZX_CODPROD/ZX_DESPROD/ZX_MES01/ZX_MES02/ZX_MES03/ZX_MES04/ZX_MES05/ZX_MES06/ZX_MES07/ZX_MES08/ZX_MES09/ZX_MES10/ZX_MES11/ZX_MES12" .and.;
		cNivel >= SX3->X3_NIVEL .And. X3Uso(SX3->X3_USADO)
		nUsado	:= nUsado+1
		aAdd(aHeader,{AllTrim(X3_TITULO), X3_CAMPO, X3_PICTURE, X3_TAMANHO, X3_DECIMAL, X3_VALID, X3_USADO, X3_TIPO, X3_F3, X3_CONTEXT })
	Endif
	SX3->(dbSkip())
End

// Preenche a Cols com dados
If nOpc==3 // Incluir
	aCols	:= {Array(nUsado+1)}
	aCols[1,nUsado+1]	:= .F.
	For nX:=1 to nUsado
		If ( aHeader[nX,10] # "V" )
			aCols[1,nX] := CriaVar(aHeader[nX,2])
		EndIf
	Next
Else
	aCols	:={}
	aAliasSZX := SZX->(GetArea())
	dbSelectArea("SZX")
	dbSetOrder(1)
	dbSeek(cCodFil+cCodPrev)
	While !Eof() .and. SZX->(ZX_FILIAL+ZX_CODPREV) == cCodFil+cCodPrev
		aAdd(aCols,Array(nUsado+1))
		For nX := 1 to nUsado
			If aHeader[nX,2] == "ZX_DESPROD"
				aCols[Len(aCols),nX] := RetField("SB1",1,xFilial("SB1")+FieldGet(FieldPos(aHeader[nX-1,2])),"SB1->B1_DESC")
			Else
				aCols[Len(aCols),nX] := FieldGet(FieldPos(aHeader[nX,2]))
			EndIf
		Next
		aCols[Len(aCols),nUsado+1]	:= .F.
		SZX->(dbSkip())
	End
	SZX->(RestArea(aAliasSZX))
Endif

If nOpc >=3 .and. nOpc <=5
	nStyle:=GD_UPDATE+GD_INSERT+GD_DELETE
EndIf

dbSelectArea("SZX")
//SZX->(dbSetOrder(1),DbGoTop())
//dbSeek(cCodFil+cCodPrev)

oDlg := MSDIALOG():New(000,000,560,1300, cCadastro,,,,,,,,,.T.)	//New(000,000,400,600, cCadastro,,,,,,,,,.T.)
RegToMemory("SZX", If(nOpc==3,.T.,.F.))

oEnch	:= MsMGet():New(cAliasE,nReg,nOpc,/*aCRA*/,/*cLetra*/,/*cTexto*/,aCpoEnch,aPos,aAlterEnch, nModelo, /*nColMens*/, /*cMensagem*/,;
		/*cTudoOk*/, oDlg,lF3, lMemoria,lColumn,caTela,lNoFolder,lProperty)
oGetD	:= MsNewGetDados():New(nSuperior, nEsquerda, nInferior, nDireita, nStyle, cLinOk, cTudoOk, cIniCpos, aAlterGDa, nFreeze, nMax, cFieldOk,;
		cSuperDel, bSZXGdDelOk, oDLG, aHeader, aCols)

//oDlg:bInit	:= {|| EnchoiceBar(oDlg, {||oDlg:End()},{||oDlg:End()},,aButtons)}
oDlg:bInit	:= {|| EnchoiceBar(oDlg, {||lConfirOk:=.T. , Iif(oGetD:TudoOk().and.Obrigatorio(aGets,aTela),oDlg:End(),lConfirOk:=.F.)}, {||lConfirOk:=.F.,oDlg:End()},,aButtons)}
oDlg:lCentered := .T.
oDlg:Activate()

If lConfirOk .and. (nOpc >= 3 .and. nOpc <= 5)
	If MsgYesNo("Confirma a "+Iif(nOpc==3,"Inclusão.",Iif(nOpc==4,"Alteração","Exclusão")),"Confirmação")
		MsgRun("Atualizando os dados. Aguarde...",, {|| AVF13Grv(nReg,nReg,nOpc) } )
	Else
		MsgAlert("Operação cancelada!","Confirmação")
	EndIf
Endif

Return


/*----------------------+--------------------------------+------------------+
|   Programa: AVF13Grv  | Autor: Kley@TOTVS              | Data: 24/03/2014 |
+-----------------------+--------------------------------+------------------+
|  Descricao:  Previsão de Entrega de Compras - VISUALIZAÇÃO
+---------------------------------------------------------------------------+
|        Uso:  U_AVFATA13()
+--------------------------------------------------------------------------*/

Static Function AVF13Grv(cAlias,nReg,nOpc)

Local nLinha    := 0
Local lInclusao := .F.
Local nX        := 0
Local bCampo := {|nCPO| Field(nCPO) }

// Backup do TTS
lSavTTsInUse := __TTSInUse

// Ativa TTS
__TTSInUse := .T.

Begin Transaction

	If nOpc == 5	// Exclusão
		SZX->(DbSetOrder(1),DbGoTop())
		SZX->(DbSeek(xFilial("SZX") + cCodPrev + cAno))
		While SZX->(!Eof()) .and. SZX->(ZX_FILIAL+ZX_CODPREV+ZX_ANO) == xFilial("SZX") + cCodPrev + cAno
			Eval({ || RecLock("SZX",.F.), SZX->(DbDelete()), SZX->(MsUnLock()) })
			SZX->(DbSkip())
		EndDo
	Else
		For nLinha := 1 to Len(oGetD:aCols)

			DbSelectArea("SZX")
			SZX->(DbSetOrder(1))

			If SZX->(DbSeek(xFilial("SZX") + M->ZX_CODPREV + M->ZX_ANO + FwFldGet("ZX_CODPROD",nLinha,,oGetD:aHeader,oGetD:aCols)))	//Alteração | Encontrou o registro
				If GdDeleted(nLinha,oGetD:aHeader,oGetD:aCols)		// Se a linha estiver deletada
					RecLock("SZX",.F.)
					SZX->(DbDelete())
					MsUnlock("SZX")
					Loop
				Else
					lInclusao := .F.
				EndIf
			Else			//Inclusão | Não Encontrou o registro
				If GdDeleted(nLinha,oGetD:aHeader,oGetD:aCols)		// Se a linha estiver deletada
					Loop
				Else
					lInclusao := .T.
				EndIf
			EndIf

			If lInclusao
				RecLock("SZX",.T.)
				SZX->ZX_FILIAL	:= xFilial("SZX")
				SZX->ZX_CODPREV	:= M->ZX_CODPREV
				SZX->ZX_DESPREV	:= M->ZX_DESPREV
				SZX->ZX_ANO		:= M->ZX_ANO
			Else
				RecLock("SZX",.F.)
				SZX->ZX_DESPREV	:= M->ZX_DESPREV
			EndIf

			For nX := 1 to Len(oGetD:aHeader)
				If ( oGetD:aHeader[nX,10] # "V" )
					SZX->(FieldPut(FieldPos(oGetD:aHeader[nX,2]),oGetD:aCols[nLinha,nX]))
				EndIf
			Next

			MsUnLock("SZX")

		Next nLinha

	EndIf

End Transaction

// Restaura TTS
__TTSInUse := lSavTTsInUse

Return


/*----------------------+--------------------------------+------------------+
|   Programa: AVF13DelOk| Autor: Kley@TOTVS              | Data: 24/03/2014 |
+-----------------------+--------------------------------+------------------+
|  Descricao: Validação da exclusão de linha na GetDados
+---------------------------------------------------------------------------+
|        Uso: AVF13DelOk( "SZX", NIL, nOpc, cZWxCodPro, nSZXOrder )
+--------------------------------------------------------------------------*/

Static Function AVF13DelOk( cAlias , nRecno , nOpc , cXCODPRO , nSZXOrder )

Local lDelOk     := .T.
Local lStatusDel := .F.

Static lFirstDelOk
Static lLstDelOk

Default lFirstDelOk := .T.
Default lLstDelOk   := .T.

Begin Sequence

//Quando for Visualizacao ou Exclusao Abandona
If (;
	( nOpc == 2 ) .or. ; //Visualizacao
	( nOpc == 5 ); 		//Exclusao
	)
Break
EndIf

//Apenas se for a primeira vez
If !( lFirstDelOk )
	lFirstDelOk	:= .T.
	lDelOk			:= lLstDelOk
	lLstDelOk		:= .T.
	Break
EndIF

lStatusDel := !( GdDeleted() ) //Inverte o Estado

If ( lStatusDel ) //Deletar
	If !( nOpc == 3 ) //Quando nao for Inclusao
		If !( lDelOk := .T. )
			CursorArrow()
			//"A chave a ser excluida está sendo utilizada."
			//"Até que as referências a ela sejam eliminadas a mesma não pode ser excluida."
			//MsgInfo( OemToAnsi( STR0008 + chr(13)+chr(10)+ STR0009 ) , cCadastro )
			lLstDelOk := lDelOk
			//Ja Passou pela funcao
			lFirstDelOk := .F.
			Break
		EndIf
	EndIf
Else //Restaurar
	lLstDelOk := lDelOk
	//Ja Passou pela funcao
	lFirstDelOk := .F.
	Break
EndIf

//Ja Passou pela funcao
lFirstDelOk := .F.

End Sequence

Return( lDelOk )


/*----------------------+--------------------------------+------------------+
|   Programa: AVF13Exp  | Autor: Kley@TOTVS              | Data: 24/03/2014 |
+-----------------------+--------------------------------+------------------+
|  Descricao: Exporta a Previsão de Entrega de Compras para arquivo CSV
+---------------------------------------------------------------------------+
|        Uso: U_AVFATA13()
+--------------------------------------------------------------------------*/

User Function AVF13Exp

Local oWizard
Local cArquivo
Local aAreaSZX 	:= SZX->(GetArea())
Local lRet 		:= .F.
Local lParam, lBrowse:=.T.
Local cNomeCSV 	:= "PREV_COMPRAS-"+Alltrim(SZX->ZX_CODPREV)+"-"+Alltrim(SZX->ZX_ANO)+".CSV"
Local aParametros := { { 1 ,"Filial"					,Space(LEN(SZX->ZX_FILIAL))		,"@!" 	 ,""  ,"" 	 ,".F." ,065 ,.F. },;
						  { 1 ,"Código da Previsão"		,Replicate(" ",Len(SZX->ZX_CODPREV))	,"@!" 	 ,""  ,"SZX",".F."	,065 ,.T. },;
						  { 1 ,"Descrição da Previsão"	,Replicate(" ",Len(SZX->ZX_DESPREV))	,"@!" 	 ,""  ,""   ,".F."	,120 ,.T. },;
						  { 1 ,"Ano"					    ,Replicate(" ",Len(SZX->ZX_ANO))  		,"@!" 	 ,""  ,""   ,".F."  	,065 ,.T. },;
						  { 1 ,"Nome do arquivo"			,Space(60)									,"@!" 	 ,""  ,"" 	  ,""  	,120 ,.T. },;
						  { 6 ,"Local do arquivo"		,Space(60)									,""		 ,	   ,""   		 	,120 ,.T. ,"" ,'' ,GETF_RETDIRECTORY+GETF_LOCALHARD}}

Local aConfig 	:= {SZX->ZX_FILIAL, SZX->ZX_CODPREV, SZX->ZX_DESPREV, SZX->ZX_ANO, ;
						cNomeCSV,;
						Space(60)}
Local aCoord 		:= {000,000,480,600}	//{000,000,080,650}

Private cCodFil  	:= xFilial("SZX")
Private cCodPrev	:= SZX->ZX_CODPREV
Private cAno   		:= SZX->ZX_ANO

oWizard := APWizard():New("Atenção"/*<chTitle>*/,;
						"Este assistente lhe ajudara a exportar os dados da Previsão de Compras para um arquivo CSV."/*<chMsg>*/, "Exportação da Previsão de Compras"/*<cTitle>*/, ;
						"Você deverá indicar os parâmetros e ao finalizar o assistente, os dados serão exportados conforme os parâmetros solicitados."/*<cText>*/,;
						{||.T.}/*<bNext>*/, ;
						{||.T.}/*<bFinish>*/,;
						/*<.lPanel.>*/, , , /*<.lNoFirst.>*/,;
						aCoord)

oWizard:NewPanel( "Parâmetros"/*<chTitle>*/,;
				"Neste passo você deverá informar os parâmetros para exportação da Previsão de Compras."/*<chMsg>*/, ;
				{||.T.}/*<bBack>*/, ;
				{||Rest_Par(aConfig),ParamOk(aParametros, aConfig) }/*<bNext>*/, ;
				{||.T.}/*<bFinish>*/,;
				.T./*<.lPanel.>*/,;
				{||Plan_Box(oWizard,@lParam, aParametros, aConfig)}/*<bExecute>*/ )

oWizard:NewPanel( "Exportação da Previsão de Compras"/*<chTitle>*/,;
				"Neste passo você deverá confirmar ou abortar a geração do arquivo.",;
				{||.T.}/*<bBack>*/, ;
				{||.T.}/*<bNext>*/, ;
				{|| lRet := ProcWizExp(aConfig, cCodFil, cCodPrev, cAno)}/*<bFinish>*/, ;
				.T./*<.lPanel.>*/, ;
				{||.T.}/*<bExecute>*/ )

TSay():New( 010, 007, {|| "A Previsão de Compras será exportada em arquivo no formato CSV conforme parâmetros selecionados." }	, oWizard:oMPanel[3],,,,  , /*<.lBorder.>*/, .T./*<.lPixel.>*/, /*<nClrText>*/, /*<nClrBack>*/, 300/*<nWidth>*/, 08/*<nHeight>*/, /*<.design.>*/, /*<.update.>*/, /*<.lShaded.>*/, /*<.lBox.>*/, /*<.lRaised.>*/, /*<.lHtml.>*/ )
TSay():New( 025, 007, {|| "Se o objetivo desta exportação for alterar ou inserir novos itens na Previsão para posterior importação no sistema" }	, oWizard:oMPanel[3],,,,  , /*<.lBorder.>*/, .T./*<.lPixel.>*/, /*<nClrText>*/, /*<nClrBack>*/, 300/*<nWidth>*/, 08/*<nHeight>*/, /*<.design.>*/, /*<.update.>*/, /*<.lShaded.>*/, /*<.lBox.>*/, /*<.lRaised.>*/, /*<.lHtml.>*/ )
TSay():New( 035, 007, {|| "os seguintes critérios devem ser observados:" }	, oWizard:oMPanel[3],,,,  , /*<.lBorder.>*/, .T./*<.lPixel.>*/, /*<nClrText>*/, /*<nClrBack>*/, 300/*<nWidth>*/, 08/*<nHeight>*/, /*<.design.>*/, /*<.update.>*/, /*<.lShaded.>*/, /*<.lBox.>*/, /*<.lRaised.>*/, /*<.lHtml.>*/ )
TSay():New( 045, 007, {|| "1)  O cabeçalho do arquivo não pode ser alterado ou excluído, e os títulos das colunas devem ser mantidos," }	, oWizard:oMPanel[3],,,,  , /*<.lBorder.>*/, .T./*<.lPixel.>*/, /*<nClrText>*/, /*<nClrBack>*/, 300/*<nWidth>*/, 08/*<nHeight>*/, /*<.design.>*/, /*<.update.>*/, /*<.lShaded.>*/, /*<.lBox.>*/, /*<.lRaised.>*/, /*<.lHtml.>*/ )
TSay():New( 055, 007, {|| "      caso contrário não será possível a sua importação;" }	, oWizard:oMPanel[3],,,,  , /*<.lBorder.>*/, .T./*<.lPixel.>*/, /*<nClrText>*/, /*<nClrBack>*/, 300/*<nWidth>*/, 08/*<nHeight>*/, /*<.design.>*/, /*<.update.>*/, /*<.lShaded.>*/, /*<.lBox.>*/, /*<.lRaised.>*/, /*<.lHtml.>*/ )
TSay():New( 065, 007, {|| "2)  Nenhuma coluna pode ser excluída;" }	, oWizard:oMPanel[3],,,,  , /*<.lBorder.>*/, .T./*<.lPixel.>*/, /*<nClrText>*/, /*<nClrBack>*/, 300/*<nWidth>*/, 08/*<nHeight>*/, /*<.design.>*/, /*<.update.>*/, /*<.lShaded.>*/, /*<.lBox.>*/, /*<.lRaised.>*/, /*<.lHtml.>*/ )
TSay():New( 075, 007, {|| "3)  Caso sejam alterados ou inseridos novos códigos para Filial e Produto o respectivo cadastro" }	, oWizard:oMPanel[3],,,,  , /*<.lBorder.>*/, .T./*<.lPixel.>*/, /*<nClrText>*/, /*<nClrBack>*/, 300/*<nWidth>*/, 08/*<nHeight>*/, /*<.design.>*/, /*<.update.>*/, /*<.lShaded.>*/, /*<.lBox.>*/, /*<.lRaised.>*/, /*<.lHtml.>*/ )
TSay():New( 085, 007, {|| "      deve existir no sistema;" }	, oWizard:oMPanel[3],,,,  , /*<.lBorder.>*/, .T./*<.lPixel.>*/, /*<nClrText>*/, /*<nClrBack>*/, 300/*<nWidth>*/, 08/*<nHeight>*/, /*<.design.>*/, /*<.update.>*/, /*<.lShaded.>*/, /*<.lBox.>*/, /*<.lRaised.>*/, /*<.lHtml.>*/ )
TSay():New( 095, 007, {|| "4)  Caso sejam inseridas novas colunas no arquivo que não fazem parte da sua estrutura exportada estas serão" }	, oWizard:oMPanel[3],,,,  , /*<.lBorder.>*/, .T./*<.lPixel.>*/, /*<nClrText>*/, /*<nClrBack>*/, 300/*<nWidth>*/, 08/*<nHeight>*/, /*<.design.>*/, /*<.update.>*/, /*<.lShaded.>*/, /*<.lBox.>*/, /*<.lRaised.>*/, /*<.lHtml.>*/ )
TSay():New( 105, 007, {|| "      desconsideradas na importação;" }	, oWizard:oMPanel[3],,,,  , /*<.lBorder.>*/, .T./*<.lPixel.>*/, /*<nClrText>*/, /*<nClrBack>*/, 300/*<nWidth>*/, 08/*<nHeight>*/, /*<.design.>*/, /*<.update.>*/, /*<.lShaded.>*/, /*<.lBox.>*/, /*<.lRaised.>*/, /*<.lHtml.>*/ )
TSay():New( 115, 007, {|| "5)  A coluna 'Descrição do Produto' (ZX_DESPROD) foi exportada somente como informativa, porque será "}	, oWizard:oMPanel[3],,,,  , /*<.lBorder.>*/, .T./*<.lPixel.>*/, /*<nClrText>*/, /*<nClrBack>*/, 300/*<nWidth>*/, 08/*<nHeight>*/, /*<.design.>*/, /*<.update.>*/, /*<.lShaded.>*/, /*<.lBox.>*/, /*<.lRaised.>*/, /*<.lHtml.>*/ )
TSay():New( 125, 007, {|| "      considerada a descrição atual do cadastro do Produto."}	, oWizard:oMPanel[3],,,,  , /*<.lBorder.>*/, .T./*<.lPixel.>*/, /*<nClrText>*/, /*<nClrBack>*/, 300/*<nWidth>*/, 08/*<nHeight>*/, /*<.design.>*/, /*<.update.>*/, /*<.lShaded.>*/, /*<.lBox.>*/, /*<.lRaised.>*/, /*<.lHtml.>*/ )
TSay():New( 135, 007, {|| "6)  ATENÇÃO! Ao abrir o arquivo no Excel(r) os dados com zeros à esquerda são suprimidos, e ao salvar um valor"}	, oWizard:oMPanel[3],,,,  , /*<.lBorder.>*/, .T./*<.lPixel.>*/, /*<nClrText>*/, /*<nClrBack>*/, 300/*<nWidth>*/, 08/*<nHeight>*/, /*<.design.>*/, /*<.update.>*/, /*<.lShaded.>*/, /*<.lBox.>*/, /*<.lRaised.>*/, /*<.lHtml.>*/ )
TSay():New( 145, 007, {|| "      como '000001' pode ficar salvo apenas como '1'. Esse cuidado deve ser tomado com os campos de código."}	, oWizard:oMPanel[3],,,,  , /*<.lBorder.>*/, .T./*<.lPixel.>*/, /*<nClrText>*/, /*<nClrBack>*/, 300/*<nWidth>*/, 08/*<nHeight>*/, /*<.design.>*/, /*<.update.>*/, /*<.lShaded.>*/, /*<.lBox.>*/, /*<.lRaised.>*/, /*<.lHtml.>*/ )

oWizard:Activate( .T./*<.lCenter.>*/,;
				{||.T.}/*<bValid>*/, ;
				{||.T.}/*<bInit>*/, ;
				{||.T.}/*<bWhen>*/ )

RestArea(aAreaSZX)

Return

/*----------------------+--------------------------------+------------------+
|   Programa: Rest_Par  | Autor: Paulo Carnelossi        | Data: 16/05/2005 |
+-----------------------+--------------------------------+------------------+
|  Descricao: Funcao para restauracao dos conteudos das variaveis MV_PAR
|			na navegacao entre os paineis do assistente de copia
+---------------------------------------------------------------------------+
|    Sintaxe: Rest_Par(aParam)
+--------------------------------------------------------------------------*/

Static Function Rest_Par(aParam)
Local nX
Local cVarMem

For nX := 1 TO Len(aParam)
	cVarMem := "MV_PAR"+AllTrim(STRZERO(nX,2,0))
	&(cVarMem) := aParam[nX]
Next

Return

/*----------------------+--------------------------------+------------------+
|   Programa: Plan_Box  | Autor: Kley@TOTVS              | Data: 24/03/2014 |
+-----------------------+--------------------------------+------------------+
|  Descricao: Funcao para escolha da Previsão de Compras
+---------------------------------------------------------------------------+
|    Sintaxe: Plan_Box(oWizard, lParam, aParametros, aConfig)
+--------------------------------------------------------------------------*/

Static Function Plan_Box(oWizard, lParam, aParametros, aConfig)

Local cLoad		:= ""						// Nome do arquivo aonde as respostas do usuário serão salvas / lidas
Local lCanSave	:= .T.						// Se as respostas para as perguntas podem ser salvas
Local lUserSave	:= .T.						// Se o usuário pode salvar sua propria configuracao

If lParam == NIL
	ParamBox(aParametros ,"Parametros", aConfig,,,.F.,120,3, oWizard:oMPanel[oWizard:nPanel], cLoad, lCanSave, lUserSave)
	lParam := .T.
Else
	Rest_Par(aConfig)
EndIf

Return

/*----------------------+--------------------------------+------------------+
|   Programa: ProcWizExp| Autor: Kley@TOTVS              | Data: 24/03/2014 |
+-----------------------+--------------------------------+------------------+
|  Descricao: Processa o Wizard
+---------------------------------------------------------------------------+
|    Sintaxe: ProcWizExp(aConfig, cCodFil, cCodPrev, cAno)
+--------------------------------------------------------------------------*/

Static Function ProcWizExp(aConfig, cCodFil, cCodPrev, cAno)

MsgRun("Processando a exportação. Aguarde...",, {|lEnd| FimWizExp(aConfig, cCodFil, cCodPrev, cAno, .F.) } )

Return .T.

/*----------------------+--------------------------------+------------------+
|   Programa: FimWizExp | Autor: Kley@TOTVS              | Data: 24/03/2014 |
+-----------------------+--------------------------------+------------------+
|  Descricao: Funcao para execucao das rotinas de copias quando pressionar
|			o botao Finalizar do assistente de copia.
+---------------------------------------------------------------------------+
|    Sintaxe: FimWizExp(aConfig, cCodFil, cCodPrev, cAno)
+--------------------------------------------------------------------------*/

Static Function FimWizExp(aConfig, cCodFil, cCodPrev, cAno, lEnd)

Local lRet 		:= .T.
Local aEstrut	:= {}
Local cNomeArq	:= ""
Local cAliasTmp	:= GetNextAlias()
Local cNomArq	:= AllTrim(MV_PAR05)
Local cDest 	:= Alltrim(MV_PAR06)
Local nHdl 		:= 0
Local cAliasTRB	:= GetNextAlias()

// Estrutura do arquivo temporario
aAdd( aEstrut, { "ZX_FILIAL"	,"C", TamSx3("ZX_FILIAL")[1], 0 } )
aAdd( aEstrut, { "ZX_CODPREV"	,"C", TamSx3("ZX_CODPREV")[1], 0 } )
aAdd( aEstrut, { "ZX_DESPREV"	,"C", TamSx3("ZX_DESPREV")[1], 0 } )
aAdd( aEstrut, { "ZX_ANO"		,"C", TamSx3("ZX_ANO")[1], 0 } )
aAdd( aEstrut, { "ZX_CODPROD"	,"C", TamSx3("ZX_CODPROD")[1], 0 } )
aAdd( aEstrut, { "ZX_DESPROD"	,"C", TamSx3("B1_DESC")[1], 0 } )
aAdd( aEstrut, { "ZX_MES01"	,"N", TamSx3("ZX_MES01")[1]+2, 0 } )
aAdd( aEstrut, { "ZX_MES02"	,"N", TamSx3("ZX_MES02")[1]+2, 0 } )
aAdd( aEstrut, { "ZX_MES03"	,"N", TamSx3("ZX_MES03")[1]+2, 0 } )
aAdd( aEstrut, { "ZX_MES04"	,"N", TamSx3("ZX_MES04")[1]+2, 0 } )
aAdd( aEstrut, { "ZX_MES05"	,"N", TamSx3("ZX_MES05")[1]+2, 0 } )
aAdd( aEstrut, { "ZX_MES06"	,"N", TamSx3("ZX_MES06")[1]+2, 0 } )
aAdd( aEstrut, { "ZX_MES07"	,"N", TamSx3("ZX_MES07")[1]+2, 0 } )
aAdd( aEstrut, { "ZX_MES08"	,"N", TamSx3("ZX_MES08")[1]+2, 0 } )
aAdd( aEstrut, { "ZX_MES09"	,"N", TamSx3("ZX_MES09")[1]+2, 0 } )
aAdd( aEstrut, { "ZX_MES10"	,"N", TamSx3("ZX_MES10")[1]+2, 0 } )
aAdd( aEstrut, { "ZX_MES11"	,"N", TamSx3("ZX_MES11")[1]+2, 0 } )
aAdd( aEstrut, { "ZX_MES12"	,"N", TamSx3("ZX_MES12")[1]+2, 0 } )

// Cria o arquivo temporario
cNomeArq := CriaTrab( aEstrut, .T. )
dbUseArea( .T.,,cNomeArq, cAliasTmp, .F., .F. )

IndRegua( cAliasTmp, cNomeArq, "ZX_FILIAL+ZX_CODPREV+ZX_ANO+ZX_CODPROD",,,"Criando Indice, Aguarde..." )
dbClearIndex()
dbSetIndex( cNomeArq + OrdBagExt() )

// Monta nome do arquivo e diretorio onde sera gravado.
cDest	:= Iif( Right(cDest,1)=="\",cDest,cDest+"\" )

MakeDir(Left(cDest,Len(cDest)-1))
If File(cDest + cNomArq)
	If !(MsgYesNo("O arquivo '"+cDest+cNomArq+"' já existe. Sobrescrever?","Criação do Arquivo"))
		// Apaga o TMP
		dbSelectArea( cAliasTmp )
		dbCloseArea()
		FErase( cNomeArq + ".DBF" )
		FErase( cNomeArq + OrdBagExt() )
		Return(lRet)
	Endif
Endif

nHdl := FCreate( cDest + cNomArq )

If nHdl < 0
	MsgStop("Nao foi possivel criar o arquivo '"+cDest+cNomArq+"'.","Criação do Arquivo")
	// Apaga o TMP
	dbSelectArea( cAliasTmp )
	dbCloseArea()
	FErase( cNomeArq + ".DBF" )
	FErase( cNomeArq + OrdBagExt() )
	Return(lRet)
EndIf

// Exporta Cabecalho do arquivo
FWrite(nHdl, "ZX_FILIAL;ZX_CODPREV;ZX_DESPREV;ZX_ANO;ZX_CODPROD;ZX_DESPROD;ZX_MES01;ZX_MES02;ZX_MES03;ZX_MES04;ZX_MES05;ZX_MES06;ZX_MES07;ZX_MES08;ZX_MES09;ZX_MES10;ZX_MES11;ZX_MES12")
FWrite(nHdl, CRLF)

// Geração dos dados no arquivo de trabalho, de acordo com os parâmetros
If Select(cAliasTRB) > 0
	(cAliasTRB)->(dbCloseArea())
Endif

BeginSQL Alias cAliasTRB
	select
		rtrim(ZX_FILIAL) as ZX_FILIAL,  rtrim(ZX_CODPREV) as ZX_CODPREV, rtrim(ZX_DESPREV) as ZX_DESPREV, rtrim(ZX_ANO) as ZX_ANO,
		rtrim(ZX_CODPROD) as ZX_CODPROD, rtrim(isnull(B1_DESC,' '))   as ZX_DESPROD,
		ZX_MES01, ZX_MES02, ZX_MES03, ZX_MES04, ZX_MES05, ZX_MES06, ZX_MES07, ZX_MES08, ZX_MES09, ZX_MES10, ZX_MES11, ZX_MES12
	from %Table:SZX% SZX
	left join %Table:SB1% SB1 on B1_FILIAL = %xFilial:SB1% and B1_COD    = ZX_CODPROD and SB1.%NotDel%
	where ZX_FILIAL  = %Exp:MV_PAR01%
	  and ZX_CODPREV = %Exp:MV_PAR02%
	  and ZX_ANO     = %Exp:MV_PAR04%
	  and SZX.%NotDel%
	order by ZX_FILIAL, ZX_CODPREV, ZX_ANO, ZX_CODPROD
 EndSQL

DbSelectArea(cAliasTRB)
(cAliasTRB)->(dbGoTop())

If !Eof(cAliasTRB)

	While !Eof(cAliasTRB)

		// Grava a linha do Detalhe
		FWrite(nHdl, (cAliasTRB)->ZX_FILIAL + ";" + (cAliasTRB)->ZX_CODPREV + ";" + (cAliasTRB)->ZX_DESPREV + ";" + (cAliasTRB)->ZX_ANO + ";" + ;
				   (cAliasTRB)->ZX_CODPROD + ";" + (cAliasTRB)->ZX_DESPROD + ";" + ;
				   Transform((cAliasTRB)->ZX_MES01, PesqPict("SZX","ZX_MES01")) + ";" + Transform((cAliasTRB)->ZX_MES02, PesqPict("SZX","ZX_MES02")) + ";" + ;
				   Transform((cAliasTRB)->ZX_MES03, PesqPict("SZX","ZX_MES03")) + ";" + Transform((cAliasTRB)->ZX_MES04, PesqPict("SZX","ZX_MES04")) + ";" + ;
				   Transform((cAliasTRB)->ZX_MES05, PesqPict("SZX","ZX_MES05")) + ";" + Transform((cAliasTRB)->ZX_MES06, PesqPict("SZX","ZX_MES06")) + ";" + ;
				   Transform((cAliasTRB)->ZX_MES07, PesqPict("SZX","ZX_MES07")) + ";" + Transform((cAliasTRB)->ZX_MES08, PesqPict("SZX","ZX_MES08")) + ";" + ;
				   Transform((cAliasTRB)->ZX_MES09, PesqPict("SZX","ZX_MES09")) + ";" + Transform((cAliasTRB)->ZX_MES10, PesqPict("SZX","ZX_MES10")) + ";" + ;
				   Transform((cAliasTRB)->ZX_MES11, PesqPict("SZX","ZX_MES11")) + ";" + Transform((cAliasTRB)->ZX_MES12, PesqPict("SZX","ZX_MES12")) )
		FWrite(nHdl, CRLF)

		(cAliasTRB)->(dbSkip())
	Enddo

Else
	MsgStop("Não existem Produtos para esta Previsão de Compras. Para exportação da Previsão é necessário que exista pelo menos um Produto cadastrado.", "Exportação da Previsão de Compras" )
Endif

FClose(nHdl)

// Apaga o TMP
DbCloseArea("cAliasTmp")
FErase( cNomeArq + ".DBF" )
FErase( cNomeArq + OrdBagExt() )

Return(lRet)

/*----------------------+--------------------------------+------------------+
|   Programa: AVF13Imp  | Autor: Kley@TOTVS              | Data: 24/03/2014 |
+-----------------------+--------------------------------+------------------+
|  Descricao: Exporta a Previsão de Entrega de Compras para arquivo CSV
+---------------------------------------------------------------------------+
|        Uso: U_AVFATA13()
+--------------------------------------------------------------------------*/

User Function AVF13Imp

Local oWizard
Local cArquivo
Local aAreaSZX 	:= SZX->(GetArea())
Local lRet 		:= .F.
Local lParam, lBrowse:=.T.
Local aParametros := { { 1 ,"Código da Filial"		,Space(10)									,"@!" 	 ,""  ,"" 	 ,".F." 	,065 ,.F. },;
						  { 1 ,"Filial"					,Space(120)								,"@!" 	 ,""  ,""	 ,".F."	,065 ,.T. },;
						  { 1 ,"Código da Empresa"		,Space(10)									,"@!" 	 ,""  ,""   ,".F."	,065 ,.T. },;
						  { 1 ,"Empresa"					,Space(120)  								,"@!" 	 ,""  ,""   ,".F."  	,160 ,.T. },;
						  { 6 ,"Local e Nome do arquivo",Space(120)								,""		 ,	   ,""   		 	,160 ,.T. ,"" ,'' ,GETF_LOCALHARD+GETF_LOCALFLOPPY}}

Local aConfig 	:= {cFilAnt, Capital( AllTrim( GetAdvFVal( "SM0", "M0_FILIAL" , cEmpAnt + cFilAnt, 1, "" ) ) ), ;
						cEmpAnt, Capital( AllTrim( GetAdvFVal( "SM0", "M0_NOMECOM", cEmpAnt + cFilAnt, 1, "" ) ) ), ;
						Space(120)}

Local aCoord 		:= {000,000,480,600}	//{000,000,080,650}

Private cCodFil  	:= xFilial("SZX")
Private cCodPrev	:= SZX->ZX_CODPREV
Private cAno   		:= SZX->ZX_ANO

oWizard := APWizard():New("Atenção"/*<chTitle>*/,;
						"Este assistente lhe ajudara a importar os dados de um arquivo CSV para uma Previsão de Compras."/*<chMsg>*/, "Importação da Previsão de Compras"/*<cTitle>*/, ;
						"Você deverá indicar os parâmetros e ao finalizar o assistente, os dados serão importados conforme os parâmetros solicitados."/*<cText>*/,;
						{||.T.}/*<bNext>*/, ;
						{||.T.}/*<bFinish>*/,;
						/*<.lPanel.>*/, , , /*<.lNoFirst.>*/,;
						aCoord)

oWizard:NewPanel( "Parâmetros"/*<chTitle>*/,;
				"Neste passo você deverá informar os parâmetros para importação da Previsão de Compras."/*<chMsg>*/, ;
				{||.T.}/*<bBack>*/, ;
				{||Rest_Par(aConfig),ParamOk(aParametros, aConfig) }/*<bNext>*/, ;
				{||.T.}/*<bFinish>*/,;
				.T./*<.lPanel.>*/,;
				{||Plan_Box(oWizard,@lParam, aParametros, aConfig)}/*<bExecute>*/ )

oWizard:NewPanel( "Importação da Previsão de Compras"/*<chTitle>*/,;
				"Neste passo você deverá confirmar ou abortar a importação do arquivo.",;
				{||.T.}/*<bBack>*/, ;
				{||.T.}/*<bNext>*/, ;
				{|| lRet := ProcWizImp(aConfig, cCodFil, cCodPrev, cAno)}/*<bFinish>*/, ;
				.T./*<.lPanel.>*/, ;
				{||.T.}/*<bExecute>*/ )

TSay():New( 010, 007, {|| "A Previsão de Compras será importada de um arquivo no formato CSV conforme parâmetros selecionados." }	, oWizard:oMPanel[3],,,,  , /*<.lBorder.>*/, .T./*<.lPixel.>*/, /*<nClrText>*/, /*<nClrBack>*/, 300/*<nWidth>*/, 08/*<nHeight>*/, /*<.design.>*/, /*<.update.>*/, /*<.lShaded.>*/, /*<.lBox.>*/, /*<.lRaised.>*/, /*<.lHtml.>*/ )
TSay():New( 025, 007, {|| "Os critérios abaixos devem ser observados para importação dos dados com sucesso:" }	, oWizard:oMPanel[3],,,,  , /*<.lBorder.>*/, .T./*<.lPixel.>*/, /*<nClrText>*/, /*<nClrBack>*/, 300/*<nWidth>*/, 08/*<nHeight>*/, /*<.design.>*/, /*<.update.>*/, /*<.lShaded.>*/, /*<.lBox.>*/, /*<.lRaised.>*/, /*<.lHtml.>*/ )
TSay():New( 035, 007, {|| "1)  Para se obter o layout do arquivo para importação é recomendável fazer primeiro uma exportação;" }	, oWizard:oMPanel[3],,,,  , /*<.lBorder.>*/, .T./*<.lPixel.>*/, /*<nClrText>*/, /*<nClrBack>*/, 300/*<nWidth>*/, 08/*<nHeight>*/, /*<.design.>*/, /*<.update.>*/, /*<.lShaded.>*/, /*<.lBox.>*/, /*<.lRaised.>*/, /*<.lHtml.>*/ )
TSay():New( 045, 007, {|| "2)  O cabeçalho do arquivo, que corresponde a primeira linha, deve conter os títulos das colunas e não podem" }	, oWizard:oMPanel[3],,,,  , /*<.lBorder.>*/, .T./*<.lPixel.>*/, /*<nClrText>*/, /*<nClrBack>*/, 300/*<nWidth>*/, 08/*<nHeight>*/, /*<.design.>*/, /*<.update.>*/, /*<.lShaded.>*/, /*<.lBox.>*/, /*<.lRaised.>*/, /*<.lHtml.>*/ )
TSay():New( 055, 007, {|| "      ser excluídos, alterados ou incluídos;" }	, oWizard:oMPanel[3],,,,  , /*<.lBorder.>*/, .T./*<.lPixel.>*/, /*<nClrText>*/, /*<nClrBack>*/, 300/*<nWidth>*/, 08/*<nHeight>*/, /*<.design.>*/, /*<.update.>*/, /*<.lShaded.>*/, /*<.lBox.>*/, /*<.lRaised.>*/, /*<.lHtml.>*/ )
TSay():New( 065, 007, {|| "3)  O arquivo inteiro deve corresponder a uma única Previsão de Compras, que é identificada pelas colunas:" }	, oWizard:oMPanel[3],,,,  , /*<.lBorder.>*/, .T./*<.lPixel.>*/, /*<nClrText>*/, /*<nClrBack>*/, 300/*<nWidth>*/, 08/*<nHeight>*/, /*<.design.>*/, /*<.update.>*/, /*<.lShaded.>*/, /*<.lBox.>*/, /*<.lRaised.>*/, /*<.lHtml.>*/ )
TSay():New( 075, 007, {|| "      FILIAL, CÓDIGO DA PREVISÃO, ANO; portanto as quatro primeiras colunas do arquivo devem" }	, oWizard:oMPanel[3],,,,  , /*<.lBorder.>*/, .T./*<.lPixel.>*/, /*<nClrText>*/, /*<nClrBack>*/, 300/*<nWidth>*/, 08/*<nHeight>*/, /*<.design.>*/, /*<.update.>*/, /*<.lShaded.>*/, /*<.lBox.>*/, /*<.lRaised.>*/, /*<.lHtml.>*/ )
TSay():New( 085, 007, {|| "      obrigatoriamente ser iguais." }	, oWizard:oMPanel[3],,,,  , /*<.lBorder.>*/, .T./*<.lPixel.>*/, /*<nClrText>*/, /*<nClrBack>*/, 300/*<nWidth>*/, 08/*<nHeight>*/, /*<.design.>*/, /*<.update.>*/, /*<.lShaded.>*/, /*<.lBox.>*/, /*<.lRaised.>*/, /*<.lHtml.>*/ )
TSay():New( 095, 007, {|| "4)  A coluna 'Descrição do Produto' (ZX_DESPROD) é somente informativo, e portanto não é obrigatório e não será" }	, oWizard:oMPanel[3],,,,  , /*<.lBorder.>*/, .T./*<.lPixel.>*/, /*<nClrText>*/, /*<nClrBack>*/, 300/*<nWidth>*/, 08/*<nHeight>*/, /*<.design.>*/, /*<.update.>*/, /*<.lShaded.>*/, /*<.lBox.>*/, /*<.lRaised.>*/, /*<.lHtml.>*/ )
TSay():New( 105, 007, {|| "      considerada na importação;"}	, oWizard:oMPanel[3],,,,  , /*<.lBorder.>*/, .T./*<.lPixel.>*/, /*<nClrText>*/, /*<nClrBack>*/, 300/*<nWidth>*/, 08/*<nHeight>*/, /*<.design.>*/, /*<.update.>*/, /*<.lShaded.>*/, /*<.lBox.>*/, /*<.lRaised.>*/, /*<.lHtml.>*/ )
TSay():New( 115, 007, {|| "5)  IMPORTANTE! Atualização ou Inclusão: se a Previsão de Compras já estiver cadastrada no sistema os Produtos"}	, oWizard:oMPanel[3],,,,  , /*<.lBorder.>*/, .T./*<.lPixel.>*/, /*<nClrText>*/, /*<nClrBack>*/, 300/*<nWidth>*/, 08/*<nHeight>*/, /*<.design.>*/, /*<.update.>*/, /*<.lShaded.>*/, /*<.lBox.>*/, /*<.lRaised.>*/, /*<.lHtml.>*/ )
TSay():New( 125, 007, {|| "      existentes serão atualizados, e os Produtos que não existem serão incluídos; se a Previsão de Compras não"}	, oWizard:oMPanel[3],,,,  , /*<.lBorder.>*/, .T./*<.lPixel.>*/, /*<nClrText>*/, /*<nClrBack>*/, 300/*<nWidth>*/, 08/*<nHeight>*/, /*<.design.>*/, /*<.update.>*/, /*<.lShaded.>*/, /*<.lBox.>*/, /*<.lRaised.>*/, /*<.lHtml.>*/ )
TSay():New( 135, 007, {|| "       estiver cadastrada os dados serão incluídos no sistema como novos;"}	, oWizard:oMPanel[3],,,,  , /*<.lBorder.>*/, .T./*<.lPixel.>*/, /*<nClrText>*/, /*<nClrBack>*/, 300/*<nWidth>*/, 08/*<nHeight>*/, /*<.design.>*/, /*<.update.>*/, /*<.lShaded.>*/, /*<.lBox.>*/, /*<.lRaised.>*/, /*<.lHtml.>*/ )
TSay():New( 145, 007, {|| "6)  ATENÇÃO! Ao abrir o arquivo no Excel(r) os dados com zeros à esquerda são suprimidos, e ao salvar um valor"}	, oWizard:oMPanel[3],,,,  , /*<.lBorder.>*/, .T./*<.lPixel.>*/, /*<nClrText>*/, /*<nClrBack>*/, 300/*<nWidth>*/, 08/*<nHeight>*/, /*<.design.>*/, /*<.update.>*/, /*<.lShaded.>*/, /*<.lBox.>*/, /*<.lRaised.>*/, /*<.lHtml.>*/ )
TSay():New( 155, 007, {|| "      como '000001' pode ficar salvo apenas como '1'. Esse cuidado deve ser tomado com os campos de código."}	, oWizard:oMPanel[3],,,,  , /*<.lBorder.>*/, .T./*<.lPixel.>*/, /*<nClrText>*/, /*<nClrBack>*/, 300/*<nWidth>*/, 08/*<nHeight>*/, /*<.design.>*/, /*<.update.>*/, /*<.lShaded.>*/, /*<.lBox.>*/, /*<.lRaised.>*/, /*<.lHtml.>*/ )

oWizard:Activate( .T./*<.lCenter.>*/,;
				{||.T.}/*<bValid>*/, ;
				{||.T.}/*<bInit>*/, ;
				{||.T.}/*<bWhen>*/ )

RestArea(aAreaSZX)

Return

/*----------------------+--------------------------------+------------------+
|   Programa: ProcWizImp| Autor: Kley@TOTVS              | Data: 24/03/2014 |
+-----------------------+--------------------------------+------------------+
|  Descricao: Processa o Wizard
+---------------------------------------------------------------------------+
|    Sintaxe: ProcWizImp(aConfig, cCodFil, cCodPrev, cAno)
+--------------------------------------------------------------------------*/

Static Function ProcWizImp(aConfig, cCodFil, cCodPrev, cAno)

Local oProcess

oProcess:= MsNewProcess():New({|lEnd| FimWizImp(aConfig, cCodFil, cCodPrev, cAno, .F., oProcess)})
oProcess:Activate()

Return .T.

/*----------------------+--------------------------------+------------------+
|   Programa: FimWizImp | Autor: Kley@TOTVS              | Data: 24/03/2014 |
+-----------------------+--------------------------------+------------------+
|  Descricao: Funcao para execucao das rotinas de copias quando pressionar
|			o botao Finalizar do assistente de copia.
+---------------------------------------------------------------------------+
|    Sintaxe: FimWizImp(aConfig, cCodFil, cCodPrev, cAno, lEnd, oProcess)
+--------------------------------------------------------------------------*/

Static Function FimWizImp(aConfig, cCodFil, cCodPrev, cAno, lEnd, oProcess)

Local lRet 		:= .T.
Local aEstrut	:= {}
Local cNomeArq	:= ""
Local cAliasTmp	:= GetNextAlias()
Local cNomArq	:= AllTrim(MV_PAR05)
Local nHdl 		:= 0
Local cAliasTRB	:= GetNextAlias()
Local aCampos	:= {}
Local aPosCampos:= {}
Local nPos		:= 0
Local nAt		:= 0
Local cCampo	:= ""
Local nPosCpo	:= 0
Local nPosNil	:= 0
Local aTxt		:= {}
Local nCampo	:= 0
Local nX		:= 0
Local nY		:= 0
Local nValor 	:= 0

// Estrutura do arquivo temporario
aAdd( aEstrut, { "LINHA"		,"C", 5, 0 } )
aAdd( aEstrut, { "ZX_FILIAL"	,"C", TamSx3("ZX_FILIAL")[1], 0 } )
aAdd( aEstrut, { "ZX_CODPREV"	,"C", TamSx3("ZX_CODPREV")[1], 0 } )
aAdd( aEstrut, { "ZX_DESPREV"	,"C", TamSx3("ZX_DESPREV")[1], 0 } )
aAdd( aEstrut, { "ZX_ANO"		,"C", TamSx3("ZX_ANO")[1], 0 } )
aAdd( aEstrut, { "ZX_CODPROD"	,"C", TamSx3("ZX_CODPROD")[1], 0 } )
aAdd( aEstrut, { "ZX_DESPROD"	,"C", TamSx3("B1_DESC")[1], 0 } )
aAdd( aEstrut, { "ZX_MES01"	,"N", TamSx3("ZX_MES01")[1]+2, 0 } )
aAdd( aEstrut, { "ZX_MES02"	,"N", TamSx3("ZX_MES02")[1]+2, 0 } )
aAdd( aEstrut, { "ZX_MES03"	,"N", TamSx3("ZX_MES03")[1]+2, 0 } )
aAdd( aEstrut, { "ZX_MES04"	,"N", TamSx3("ZX_MES04")[1]+2, 0 } )
aAdd( aEstrut, { "ZX_MES05"	,"N", TamSx3("ZX_MES05")[1]+2, 0 } )
aAdd( aEstrut, { "ZX_MES06"	,"N", TamSx3("ZX_MES06")[1]+2, 0 } )
aAdd( aEstrut, { "ZX_MES07"	,"N", TamSx3("ZX_MES07")[1]+2, 0 } )
aAdd( aEstrut, { "ZX_MES08"	,"N", TamSx3("ZX_MES08")[1]+2, 0 } )
aAdd( aEstrut, { "ZX_MES09"	,"N", TamSx3("ZX_MES09")[1]+2, 0 } )
aAdd( aEstrut, { "ZX_MES10"	,"N", TamSx3("ZX_MES10")[1]+2, 0 } )
aAdd( aEstrut, { "ZX_MES11"	,"N", TamSx3("ZX_MES11")[1]+2, 0 } )
aAdd( aEstrut, { "ZX_MES12"	,"N", TamSx3("ZX_MES12")[1]+2, 0 } )

// Cria o arquivo temporario
cNomeArq := CriaTrab( aEstrut, .T. )
dbUseArea( .T.,,cNomeArq, cAliasTmp, .F., .F. )

IndRegua( cAliasTmp, cNomeArq, "ZX_FILIAL+ZX_CODPREV+ZX_ANO+ZX_CODPROD",,,"Criando Indice, Aguarde..." )
dbClearIndex()
dbSetIndex( cNomeArq + OrdBagExt() )

// Campos para Validacao
aAdd(aCampos,"ZX_FILIAL")
aAdd(aCampos,"ZX_CODPREV")
aAdd(aCampos,"ZX_DESPREV")
aAdd(aCampos,"ZX_ANO")
aAdd(aCampos,"ZX_CODPROD")
aAdd(aCampos,"ZX_MES01")
aAdd(aCampos,"ZX_MES02")
aAdd(aCampos,"ZX_MES03")
aAdd(aCampos,"ZX_MES04")
aAdd(aCampos,"ZX_MES05")
aAdd(aCampos,"ZX_MES06")
aAdd(aCampos,"ZX_MES07")
aAdd(aCampos,"ZX_MES08")
aAdd(aCampos,"ZX_MES09")
aAdd(aCampos,"ZX_MES10")
aAdd(aCampos,"ZX_MES11")
aAdd(aCampos,"ZX_MES12")

//Define o valor do array conforme estrutura
aPosCampos:= Array(Len(aCampos))

// Abre o arquivo a ser importado
If (nHdl := FT_FUse(cNomArq)) == -1
	Help(" ",1,"NOFILE")
	// Apaga o TMP
	If Select(cAliasTmp) # 0
		(cAliasTmp)->(dbCloseArea())
		FErase(cNomeArq+GetDBExtension())
		FErase(cNomeArq+OrdBagExt())
	Endif
	Return
EndIf

// Valida se o Arquivo é CSV
If Upper(Right(cNomArq,4)) # ".CSV"
	Help(" ",1, "ARQINV","Arquivo inválido","O arquivo de importação não é um arquivo CSV.",1,0 )
	// Apaga o TMP
	If Select(cAliasTmp) # 0
		(cAliasTmp)->(dbCloseArea())
		FErase(cNomeArq+GetDBExtension())
		FErase(cNomeArq+OrdBagExt())
	Endif
	fClose(nHdl)
	Return
Endif

// Posiciona na primeira linha do arquivo, e lê primeira linha
FT_FGOTOP()
cLinha := FT_FREADLN()
nPos	:=	0
nAt	:=	1

While nAt > 0
	nPos++
	nAt	:=	At(";",cLinha)
	If nAt == 0
		cCampo := cLinha
	Else
		cCampo := Substr(cLinha,1,nAt-1)
	Endif
	nPosCpo	:=	aScan(aCampos,{|x| x==cCampo})
	If nPosCPO > 0
		aPosCampos[nPosCpo]:= nPos
	Endif
	cLinha	:=	Substr(cLinha,nAt+1)
EndDo

If (nPosNil:= Ascan(aPosCampos,Nil)) > 0
	MsgStop("O campo "+aCampos[nPosNil]+" não foi encontrado na estrutura do arquivo. Por favor verifique.","Importação da Previsão")
	If Select(cAliasTmp) # 0
		(cAliasTmp)->(dbCloseArea())
		FErase(cNomeArq+GetDBExtension())
		FErase(cNomeArq+OrdBagExt())
	Endif
	fClose(nHdl)
	Return .F.
Endif

// Inicia Importacao das Linhas
FT_FSKIP()
While !FT_FEOF()
	cLinha := FT_FREADLN()
	aAdd(aTxt,{})
	nCampo := 1
	While At(";",cLinha)>0
		aAdd(aTxt[Len(aTxt)],Substr(cLinha,1,At(";",cLinha)-1))
		nCampo ++
		cLinha := StrTran(Substr(cLinha,At(";",cLinha)+1,Len(cLinha)-At(";",cLinha)),'"','')
	End
	If Len(AllTrim(cLinha)) > 0
		aAdd(aTxt[Len(aTxt)],StrTran(Substr(cLinha,1,Len(cLinha)),'"','') )
	Else
		aAdd(aTxt[Len(aTxt)],"")
	Endif
	FT_FSKIP()
End

// Gravacao dos Itens no TRB
FT_FUSE()
For nX := 1 to Len(aTxt)
	dbSelectArea(cAliasTmp)
	RecLock((cAliasTmp),.T.)
	(cAliasTmp)->LINHA := LTrim(Str(nX))
	For nY := 1 to Len(aCampos)
		If "_MES" $ AllTrim(aCampos[nY])
			nValor := Val(StrTran(StrTran(aTxt[nX,aPosCampos[nY]] ,".","") ,",","." ))
			FieldPut(FieldPos(aCampos[nY]),nValor)
		Else
			FieldPut(FieldPos(aCampos[nY]),aTxt[nX,aPosCampos[nY]])
		Endif
	Next
	MsUnLock(cAliasTmp)
Next

dbSelectArea(cAliasTmp)
(cAliasTmp)->(dbGotop())

ImpPrevVen(aConfig, cCodFil, cCodPrev, cAno, lEnd, cAliasTmp, cNomArq, oProcess)

// Apaga o TMP
If Select(cAliasTmp) # 0
	(cAliasTmp)->(dbCloseArea())
	FErase(cNomeArq+GetDBExtension())
	FErase(cNomeArq+OrdBagExt())
Endif
fClose(nHdl)

Return(lRet)

/*----------------------+--------------------------------+------------------+
|   Programa: ImpPrevVen| Autor: Kley@TOTVS              | Data: 24/03/2014 |
+-----------------------+--------------------------------+------------------+
|  Descricao: Realiza a importação da Previsão de Compras.
+---------------------------------------------------------------------------+
|    Sintaxe: ImpPrevVen(aConfig, cCodFil, cCodPrev, cAno, lEnd, cAliasTmp, cNomArq, oProcess)
+--------------------------------------------------------------------------*/

Static Function ImpPrevVen(aConfig, cCodFil, cCodPrev, cAno, lEnd, cAliasTmp, cNomArq, oProcess)

Local nTotRegs	:= 0
Local cTexto 		:= ""
Local nProcRegs	:= 0
Local lErro		:= .F.
Local cChaveSZX	:= ""
Local lExistSZX	:= .F.
Local cFileLog  	:= Left(cNomArq,Len(cNomArq)-4) + ".log"
Local nTotReg		:= 0
Local aSM0			:= {}

dbEval( {|x| nTotRegs++ },,{|| (cAliasTmp)->(!EOF())})
oProcess:SetRegua1(nTotRegs)
oProcess:IncRegua1("Iniciando processamento...")
oProcess:SetRegua2(nTotRegs)
oProcess:IncRegua2("Aguarde...")

cTexto += Replicate( "-", 128 ) + CRLF
ctexto += Replicate( " ", 128 ) + CRLF
ctexto += "LOG DE IMPORTACAO DA PREVISAO DE COMPRAS" + CRLF
ctexto += Replicate( " ", 128 ) + CRLF
ctexto += Replicate( "-", 128 ) + CRLF
ctexto += CRLF
ctexto += " Dados Ambiente" + CRLF
ctexto += " --------------------"  + CRLF
ctexto += " Empresa / Filial...: " + cEmpAnt + "/" + cFilAnt  + CRLF
ctexto += " Nome Empresa.......: " + Capital( AllTrim( GetAdvFVal( "SM0", "M0_NOMECOM", cEmpAnt + cFilAnt, 1, "" ) ) ) + CRLF
ctexto += " Nome Filial........: " + Capital( AllTrim( GetAdvFVal( "SM0", "M0_FILIAL" , cEmpAnt + cFilAnt, 1, "" ) ) ) + CRLF
ctexto += " DataBase...........: " + DtoC( dDataBase )  + CRLF
ctexto += " Data / Hora Inicio.: " + DtoC( Date() )  + " / " + Time()  + CRLF
ctexto += " Usuario PROTHEUS...: " + __cUserId + " - " +  cUserName + CRLF
ctexto += " Arquivo Importado..: " + cNomArq + CRLF
ctexto += Replicate( "-", 128 ) + CRLF
ctexto += CRLF

dbSelectArea(cAliasTmp)
(cAliasTmp)->(dbGotop())

While (cAliasTmp)->(!EOF())

	nProcRegs++
	oProcess:IncRegua1("Validando arquivo item: "+cValToChar(nProcRegs)+" / "+CValToChar(nTotRegs))

	// Valida Registros e Gerar Log

	// Verifica se c Chave da linha corrente é diferente da 1ª linha do arquivo
	If Empty(cChaveSZX)
		cChaveSZX  := (cAliasTmp)->(ZX_FILIAL+ZX_CODPREV+ZX_ANO)	// 1ª linha do arquivo usada para comparação com as demais linhas
		// Verifica se já existe Previsão de Compras com a mesma chave do arquivo
		dbSelectArea("SZX")
		SZX->(dbSetOrder(1))

		If SZX->(dbSeek(cChaveSZX))
			cTexto += " Já existe uma Previsão de Compras cadastrada com a mesma chave do arquivo. Fil/Cod.Prev./Ano: "+RTrim((cAliasTmp)->(ZX_FILIAL))+"/"+RTrim((cAliasTmp)->(ZX_CODPREV))+"/"+RTrim((cAliasTmp)->(ZX_ANO))+";"+CRLF
			cTexto += " As linhas existentes serão atualizadas, e as novas serão inseridas."+CRLF
			lExistSZX := .T.
		Else

			// Valida a Filial logada
			If (cAliasTmp)->(ZX_FILIAL) # xFilial("SZX")
				aSM0 := FWLoadSM0()
				If aScan(aSM0, { |x,y| x[1]==cEmpAnt .and. x[2]==(cAliasTmp)->(ZX_FILIAL) } ) > 0
					cTexto += " O código da Filial informada no arquivo (" + (cAliasTmp)->(ZX_FILIAL) + ") é diferente da Filial logada no sistema (" + RTrim(cFilAnt) +")."+CRLF
					lErro := .T.
				Else
					cTexto += " O código da Filial informada no arquivo (" + (cAliasTmp)->(ZX_FILIAL) + ") é inválida para a Empresa logada ou inexistente."+CRLF
					lErro := .T.
				EndIf
			EndIf

			// Verifica se já existe Previsão de Compras com o mesmo Código, porém com ANO é Diferente
			dbSelectArea("SZX")
			SZX->(dbSetOrder(1),dbGoTop(),dbSeek((cAliasTmp)->(ZX_FILIAL+ZX_CODPREV)))
			Do While SZX->(!Eof()) .and. SZX->(ZX_FILIAL+ZX_CODPREV) == (cAliasTmp)->(ZX_FILIAL+ZX_CODPREV)
				If SZX->ZX_ANO # (cAliasTmp)->ZX_ANO
					cTexto += " Já existe Previsão cadastrada com o mesmo código (" + (cAliasTmp)->ZX_CODPREV + "), porém o ANO é diferentes;"+CRLF+;
								" ANO do arquivo: " + (cAliasTmp)->ZX_ANO+" | ANO cadastrado: " + SZX->ZX_ANO+"."+CRLF
					lErro := .T.
				EndIf
				SZX->(dbSkip())
			EndDo

			// Valida o Ano
			If (cAliasTmp)->(ZX_ANO) < "2010" .or. (cAliasTmp)->(ZX_ANO) > "2030"
				cTexto += " O Ano informada no arquivo (" + (cAliasTmp)->(ZX_ANO) + ") é inválido."+CRLF
				lErro := .T.
			EndIf

		EndIf
	ElseIf cChaveSZX # (cAliasTmp)->(ZX_FILIAL+ZX_CODPREV+ZX_ANO)
		cTexto += " Linha ["+(cAliasTmp)->LINHA+"] A chave da Previsão de Compras (Fil/Cod.Prev./Ano) é diferente da 1a. linha de dados do arquivo;"+CRLF+;
				" Chave da linha corrente: "+(cAliasTmp)->(ZX_FILIAL+ZX_CODPREV+ZX_ANO)+" | Chave 1a. linha: "+cChaveSZX+"."+CRLF
		lErro := .T.
	EndIf

	(cAliasTmp)->(DbSkip())

EndDo

If lErro
	MsgStop("Existem inconsistências no arquivo CSV, e a importação não foi realizada!"+CRLF+CRLF+;
			"Para obter detalhes consulte o arquivo de log que foi gerado no mesmo diretório do arquivo importado:"+CRLF+Alltrim(cFileLog),"Erro na Importação")
Else
	// Processa Importacao
	(cAliasTmp)->(dbGotop())
	While (cAliasTmp)->(!Eof())

		oProcess:IncRegua2("Importando os dados para Previsão - Produto: "+(cAliasTmp)->ZX_CODPROD)

		DbSelectArea("SZX")
		SZX->(DbSetOrder(1))

		If SZX->(DbSeek(cChaveSZX+(cAliasTmp)->ZX_CODPROD))	//Alteração | Encontrou a chave
			RecLock("SZX",.F.)
			SZX->ZX_DESPREV	:=(cAliasTmp)->ZX_DESPREV
		Else														//Inclusão  | Não Encontrou a chave
			RecLock("SZX",.T.)
			SZX->ZX_FILIAL	:= xFilial("SZX")
			SZX->ZX_CODPREV	:=(cAliasTmp)->ZX_CODPREV
			SZX->ZX_DESPREV	:=(cAliasTmp)->ZX_DESPREV
			SZX->ZX_ANO		:=(cAliasTmp)->ZX_ANO
			SZX->ZX_CODPROD	:=(cAliasTmp)->ZX_CODPROD
		EndIf

		SZX->ZX_MES01		:=(cAliasTmp)->ZX_MES01
		SZX->ZX_MES02		:=(cAliasTmp)->ZX_MES02
		SZX->ZX_MES03		:=(cAliasTmp)->ZX_MES03
		SZX->ZX_MES04		:=(cAliasTmp)->ZX_MES04
		SZX->ZX_MES05		:=(cAliasTmp)->ZX_MES05
		SZX->ZX_MES06		:=(cAliasTmp)->ZX_MES06
		SZX->ZX_MES07		:=(cAliasTmp)->ZX_MES07
		SZX->ZX_MES08		:=(cAliasTmp)->ZX_MES08
		SZX->ZX_MES09		:=(cAliasTmp)->ZX_MES09
		SZX->ZX_MES10		:=(cAliasTmp)->ZX_MES10
		SZX->ZX_MES11		:=(cAliasTmp)->ZX_MES11
		SZX->ZX_MES12		:=(cAliasTmp)->ZX_MES12

		MsUnLock("SZX")

		nTotReg++
		(cAliasTmp)->(dbSkip())
	EndDo

	cTexto += " Importação realizada com sucesso!"+CRLF
	MsgInfo("A importação foi concluída com sucesso!"+CRLF+CRLF+;
			"Para obter detalhes consulte o arquivo de log que foi gerado no mesmo diretório do arquivo importado:"+CRLF+Alltrim(cFileLog),"Importação com sucesso")
Endif

cTexto += Replicate( "-", 128 ) + CRLF
cTexto += " Data / Hora Final.: " + DtoC( Date() ) + " / " + Time()  + CRLF
cTexto += Replicate( "-", 128 ) + CRLF

MemoWrite( cFileLog, cTexto )

Return lErro
