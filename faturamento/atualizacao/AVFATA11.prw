#include "TOTVS.ch"

/*----------------------+--------------------------------+------------------+
|   Programa: AVFATA11  | Autor: Kley@TOTVS              | Data: 24/03/2014 |
+-----------------------+--------------------------------+------------------+
|  Descricao:  Previsão / Orçamento de Vendas
+---------------------------------------------------------------------------+
|    Projeto:  AVANT
+---------------------------------------------------------------------------+
|    Sintaxe:  U_AVFATA11()
+----------------------------------------------------------------------------
|    Retorno:  Nulo                                                               
+--------------------------------------------------------------------------*/

User Function AVFATA11()

Local cAlias := "SZW"

Private cCadastro	:= "Previsão / Orçamento de Vendas"
Private aRotina 	:= {}
Private cDelFunc 	:= ".T." // Validacao para a exclusao. Pode-se utilizar ExecBlock

//AxCadastro("SZW","Previsão de Vendas")

aAdd(aRotina,{"Pesquisar"	,"AxPesqui"   ,0,1})
aAdd(aRotina,{"Visualizar"	,"U_AVF11Man" ,0,2})
aAdd(aRotina,{"Incluir"		,"U_AVF11Man" ,0,3})
aAdd(aRotina,{"Alterar"		,"U_AVF11Man" ,0,4})
aAdd(aRotina,{"Excluir"		,"U_AVF11Man" ,0,5})

aAdd(aRotina,{"Exporta CSV" ,"U_AVF11Exp" ,0,4})
aAdd(aRotina,{"Importa CSV" ,"U_AVF11Imp" ,0,4})

dbSelectArea(cAlias)
dbSetOrder(1)
mBrowse( 6,1,22,75,cAlias)

DbCloseArea(cAlias)

Return


/*----------------------+--------------------------------+------------------+
|   Programa: AVF11Man  | Autor: Kley@TOTVS              | Data: 24/03/2014 |
+-----------------------+--------------------------------+------------------+
|  Descricao:  Previsão / Orçamento de Vendas - VISUALIZAÇÃO
+---------------------------------------------------------------------------+
|        Uso:  U_AVFATA11()
+--------------------------------------------------------------------------*/

User Function AVF11Man(cAlias,nReg,nOpc)

Local nX			:= 0
Local nUsado		:= 0
Local aButtons	:= {}
Local aCpoEnch	:= {}
Local cAliasE		:= cAlias
Local aAlterEnch	:= {"ZW_CODPREV","ZW_DESPREV","ZW_ANO","ZW_CODREG"}
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
//Local bSZWGdDelOk	:= { |lDelOk| CursorWait(), lDelOk := AVF11DelOk( "SZW", NIL, nOpc, cZWxCodPro, nSZWOrder ) , CursorArrow() , lDelOk }
Local bSZWGdDelOk	:= { |lDelOk| CursorWait(), lDelOk := .T., CursorArrow(), lDelOk }
Local aHeader 	:= {}
Local aCols 		:= {}
Local aAlterGDa 	:= {}
Local nStyle  	:= 0
Local lConfirOk	:= .F.
Local aAliasSZW	:= {}

Private oDlg
Private oGetD
Private oEnch
Private aTELA[0][0]
Private aGETS[0]

// Variaveis da Enchoice
Private cCodFil  	:= xFilial("SZW")
Private cCodPrev	:= SZW->ZW_CODPREV
Private cAno   	:= SZW->ZW_ANO
Private cCodReg	:= SZW->ZW_CODREG

// Campos da Enchoice
DbSelectArea("SX3")
SX3->(DbSetOrder(1), DbGoTop())
DbSeek(cAliasE)
While !Eof() .And. SX3->X3_ARQUIVO == cAliasE
	If RTrim(SX3->X3_CAMPO) $ "ZW_CODPREV/ZW_DESPREV/ZW_ANO/ZW_CODREG/ZW_DESREG" .And. cNivel >= SX3->X3_NIVEL .And. X3Uso(SX3->X3_USADO)
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
	If RTrim(SX3->X3_CAMPO) $ "ZW_CODPROD/ZW_DESPROD/ZW_MES01/ZW_MES02/ZW_MES03/ZW_MES04/ZW_MES05/ZW_MES06/ZW_MES07/ZW_MES08/ZW_MES09/ZW_MES10/ZW_MES11/ZW_MES12" .and.;
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
	If RTrim(SX3->X3_CAMPO) $ "ZW_CODPROD/ZW_DESPROD/ZW_MES01/ZW_MES02/ZW_MES03/ZW_MES04/ZW_MES05/ZW_MES06/ZW_MES07/ZW_MES08/ZW_MES09/ZW_MES10/ZW_MES11/ZW_MES12" .and.;
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
	aAliasSZW := SZW->(GetArea())
	dbSelectArea("SZW")
	dbSetOrder(1)
	dbSeek(cCodFil+cCodPrev)
	While !Eof() .and. SZW->(ZW_FILIAL+ZW_CODPREV) == cCodFil+cCodPrev
		aAdd(aCols,Array(nUsado+1))
		For nX := 1 to nUsado
			If aHeader[nX,2] == "ZW_DESPROD"
				aCols[Len(aCols),nX] := RetField("SB1",1,xFilial("SB1")+FieldGet(FieldPos(aHeader[nX-1,2])),"SB1->B1_DESC")
			Else
				aCols[Len(aCols),nX] := FieldGet(FieldPos(aHeader[nX,2]))
			EndIf
		Next
		aCols[Len(aCols),nUsado+1]	:= .F.
		SZW->(dbSkip())
	End
	SZW->(RestArea(aAliasSZW))
Endif

If nOpc >=3 .and. nOpc <=5
	nStyle:=GD_UPDATE+GD_INSERT+GD_DELETE
EndIf

dbSelectArea("SZW")
//SZW->(dbSetOrder(1),DbGoTop())
//dbSeek(cCodFil+cCodPrev)

oDlg := MSDIALOG():New(000,000,560,1300, cCadastro,,,,,,,,,.T.)	//New(000,000,400,600, cCadastro,,,,,,,,,.T.)
RegToMemory("SZW", If(nOpc==3,.T.,.F.))

oEnch	:= MsMGet():New(cAliasE,nReg,nOpc,/*aCRA*/,/*cLetra*/,/*cTexto*/,aCpoEnch,aPos,aAlterEnch, nModelo, /*nColMens*/, /*cMensagem*/,;
		/*cTudoOk*/, oDlg,lF3, lMemoria,lColumn,caTela,lNoFolder,lProperty)
oGetD	:= MsNewGetDados():New(nSuperior, nEsquerda, nInferior, nDireita, nStyle, cLinOk, cTudoOk, cIniCpos, aAlterGDa, nFreeze, nMax, cFieldOk,;
		cSuperDel, bSZWGdDelOk, oDLG, aHeader, aCols)

//oDlg:bInit	:= {|| EnchoiceBar(oDlg, {||oDlg:End()},{||oDlg:End()},,aButtons)}
oDlg:bInit	:= {|| EnchoiceBar(oDlg, {||lConfirOk:=.T. , Iif(oGetD:TudoOk().and.Obrigatorio(aGets,aTela),oDlg:End(),lConfirOk:=.F.)}, {||lConfirOk:=.F.,oDlg:End()},,aButtons)}
oDlg:lCentered := .T.
oDlg:Activate()

If lConfirOk .and. (nOpc >= 3 .and. nOpc <= 5)
	If MsgYesNo("Confirma a "+Iif(nOpc==3,"Inclusão.",Iif(nOpc==4,"Alteração","Exclusão")),"Confirmação")
		MsgRun("Atualizando os dados. Aguarde...",, {|| AVF11Grv(nReg,nReg,nOpc) } )
	Else
		MsgAlert("Operação cancelada!","Confirmação")
	EndIf
Endif

Return


/*----------------------+--------------------------------+------------------+
|   Programa: AVF11Grv  | Autor: Kley@TOTVS              | Data: 24/03/2014 |
+-----------------------+--------------------------------+------------------+
|  Descricao:  Previsão / Orçamento de Vendas - VISUALIZAÇÃO
+---------------------------------------------------------------------------+
|        Uso:  U_AVFATA11()
+--------------------------------------------------------------------------*/

Static Function AVF11Grv(cAlias,nReg,nOpc)

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
		SZW->(DbSetOrder(1),DbGoTop())
		SZW->(DbSeek(xFilial("SZW") + cCodPrev + cAno + cCodReg))
		While SZW->(!Eof()) .and. SZW->(ZW_FILIAL+ZW_CODPREV+ZW_ANO+ZW_CODREG) == xFilial("SZW") + cCodPrev + cAno + cCodReg
			Eval({ || RecLock("SZW",.F.), SZW->(DbDelete()), SZW->(MsUnLock()) })
			SZW->(DbSkip())
		EndDo
	Else
		For nLinha := 1 to Len(oGetD:aCols)
			
			DbSelectArea("SZW")
			SZW->(DbSetOrder(1))

			If SZW->(DbSeek(xFilial("SZW") + M->ZW_CODPREV + M->ZW_ANO + M->ZW_CODREG + GdFieldGet("ZW_CODPROD",nLinha,,oGetD:aHeader,oGetD:aCols)))	//Alteração | Encontrou o registro
				If GdDeleted(nLinha,oGetD:aHeader,oGetD:aCols)		// Se a linha estiver deletada
					RecLock("SZW",.F.)
					SZW->(DbDelete())
					MsUnlock("SZW")
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
				RecLock("SZW",.T.)
				SZW->ZW_FILIAL	:= xFilial("SZW")
				SZW->ZW_CODPREV	:= M->ZW_CODPREV  
				SZW->ZW_DESPREV	:= M->ZW_DESPREV
				SZW->ZW_ANO		:= M->ZW_ANO
				SZW->ZW_CODREG	:= M->ZW_CODREG
			Else
				RecLock("SZW",.F.)
				SZW->ZW_DESPREV	:= M->ZW_DESPREV
			EndIf
			
			For nX := 1 to Len(oGetD:aHeader)
				If ( oGetD:aHeader[nX,10] # "V" )
					SZW->(FieldPut(FieldPos(oGetD:aHeader[nX,2]),oGetD:aCols[nLinha,nX]))
				EndIf
			Next

			MsUnLock("SZW")
			
		Next nLinha
	
	EndIf
	
End Transaction

// Restaura TTS
__TTSInUse := lSavTTsInUse

Return


/*----------------------+--------------------------------+------------------+
|   Programa: AVF11DelOk| Autor: Kley@TOTVS              | Data: 24/03/2014 |
+-----------------------+--------------------------------+------------------+
|  Descricao: Validação da exclusão de linha na GetDados
+---------------------------------------------------------------------------+
|        Uso: AVF11DelOk( "SZW", NIL, nOpc, cZWxCodPro, nSZWOrder )
+--------------------------------------------------------------------------*/

Static Function AVF11DelOk( cAlias , nRecno , nOpc , cXCODPRO , nSZWOrder )

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
|   Programa: AVF11Exp  | Autor: Kley@TOTVS              | Data: 24/03/2014 |
+-----------------------+--------------------------------+------------------+
|  Descricao: Exporta o Planejamento de Vendas para arquivo CSV
+---------------------------------------------------------------------------+
|        Uso: U_AVFATA11()
+--------------------------------------------------------------------------*/

User Function AVF11Exp

Local oWizard
Local cArquivo
Local aAreaSZW 	:= SZW->(GetArea())
Local lRet 		:= .F.
Local lParam, lBrowse:=.T.
Local cNomeCSV 	:= "PREV_VENDAS-"+Alltrim(SZW->ZW_CODPREV)+"-"+Alltrim(SZW->ZW_ANO)+"-"+AllTrim(SZW->ZW_CODREG)+".CSV"
Local aParametros := { { 1 ,"Filial"					,Space(LEN(SZW->ZW_FILIAL))		,"@!" 	 ,""  ,"" 	 ,".F." ,065 ,.F. },;
						  { 1 ,"Código da Previsão"		,Replicate(" ",Len(SZW->ZW_CODPREV))	,"@!" 	 ,""  ,"SZW",".F."	,065 ,.T. },;
						  { 1 ,"Descrição da Previsão"	,Replicate(" ",Len(SZW->ZW_DESPREV))	,"@!" 	 ,""  ,""   ,".F."	,120 ,.T. },;
						  { 1 ,"Ano"					    ,Replicate(" ",Len(SZW->ZW_ANO))  		,"@!" 	 ,""  ,""   ,".F."  	,065 ,.T. },;
						  { 1 ,"Código da Regional"		,Replicate(" ",Len(SZW->ZW_CODREG))  	,"@!" 	 ,""  ,""   ,".F."  	,065 ,.T. },;
						  { 1 ,"Descrição da Regional"	,Space(TamSX3("ZZ_DESREG")[1])		,"@!" 	 ,""  ,""   ,".F."  	,120 ,.T. },;
						  { 1 ,"Nome do arquivo"			,Space(60)									,"@!" 	 ,""  ,"" 	  ,""  	,120 ,.T. },;
						  { 6 ,"Local do arquivo"		,Space(60)									,""		 ,	   ,""   		 	,120 ,.T. ,"" ,'' ,GETF_RETDIRECTORY+GETF_LOCALHARD}}

Local aConfig 	:= {SZW->ZW_FILIAL, SZW->ZW_CODPREV, SZW->ZW_DESPREV, SZW->ZW_ANO, SZW->ZW_CODREG,;
						RetField("SZZ",1,xFilial("SZZ")+SZW->ZW_CODREG,"SZZ->ZZ_DESREG"),;
						cNomeCSV,;
						Space(60)}
Local aCoord 		:= {000,000,480,600}	//{000,000,080,650}

Private cCodFil  	:= xFilial("SZW")
Private cCodPrev	:= SZW->ZW_CODPREV
Private cAno   	:= SZW->ZW_ANO
Private cCodReg	:= SZW->ZW_CODREG

oWizard := APWizard():New("Atenção"/*<chTitle>*/,;
						"Este assistente lhe ajudara a exportar os dados da Previsão de Vendas para um arquivo CSV."/*<chMsg>*/, "Exportação da Previsão de Vendas"/*<cTitle>*/, ;
						"Você deverá indicar os parâmetros e ao finalizar o assistente, os dados serão exportados conforme os parâmetros solicitados."/*<cText>*/,;
						{||.T.}/*<bNext>*/, ;
						{||.T.}/*<bFinish>*/,;
						/*<.lPanel.>*/, , , /*<.lNoFirst.>*/,;
						aCoord)

oWizard:NewPanel( "Parâmetros"/*<chTitle>*/,;
				"Neste passo você deverá informar os parâmetros para exportação da Previsão de Vendas."/*<chMsg>*/, ;
				{||.T.}/*<bBack>*/, ;
				{||Rest_Par(aConfig),ParamOk(aParametros, aConfig) }/*<bNext>*/, ;
				{||.T.}/*<bFinish>*/,;
				.T./*<.lPanel.>*/,;
				{||Plan_Box(oWizard,@lParam, aParametros, aConfig)}/*<bExecute>*/ )

oWizard:NewPanel( "Exportação da Previsão de Vendas"/*<chTitle>*/,;
				"Neste passo você deverá confirmar ou abortar a geração do arquivo.",;
				{||.T.}/*<bBack>*/, ;
				{||.T.}/*<bNext>*/, ;
				{|| lRet := ProcWizExp(aConfig, cCodFil, cCodPrev, cAno, cCodReg)}/*<bFinish>*/, ;
				.T./*<.lPanel.>*/, ;
				{||.T.}/*<bExecute>*/ )
                                                                     
TSay():New( 010, 007, {|| "A Previsão de Vendas será exportada em arquivo no formato CSV conforme parâmetros selecionados." }	, oWizard:oMPanel[3],,,,  , /*<.lBorder.>*/, .T./*<.lPixel.>*/, /*<nClrText>*/, /*<nClrBack>*/, 300/*<nWidth>*/, 08/*<nHeight>*/, /*<.design.>*/, /*<.update.>*/, /*<.lShaded.>*/, /*<.lBox.>*/, /*<.lRaised.>*/, /*<.lHtml.>*/ ) 
TSay():New( 025, 007, {|| "Se o objetivo desta exportação for alterar ou inserir novos itens na Previsão para posterior importação no sistema" }	, oWizard:oMPanel[3],,,,  , /*<.lBorder.>*/, .T./*<.lPixel.>*/, /*<nClrText>*/, /*<nClrBack>*/, 300/*<nWidth>*/, 08/*<nHeight>*/, /*<.design.>*/, /*<.update.>*/, /*<.lShaded.>*/, /*<.lBox.>*/, /*<.lRaised.>*/, /*<.lHtml.>*/ )
TSay():New( 035, 007, {|| "os seguintes critérios devem ser observados:" }	, oWizard:oMPanel[3],,,,  , /*<.lBorder.>*/, .T./*<.lPixel.>*/, /*<nClrText>*/, /*<nClrBack>*/, 300/*<nWidth>*/, 08/*<nHeight>*/, /*<.design.>*/, /*<.update.>*/, /*<.lShaded.>*/, /*<.lBox.>*/, /*<.lRaised.>*/, /*<.lHtml.>*/ )
TSay():New( 045, 007, {|| "1)  O cabeçalho do arquivo não pode ser alterado ou excluído, e os títulos das colunas devem ser mantidos," }	, oWizard:oMPanel[3],,,,  , /*<.lBorder.>*/, .T./*<.lPixel.>*/, /*<nClrText>*/, /*<nClrBack>*/, 300/*<nWidth>*/, 08/*<nHeight>*/, /*<.design.>*/, /*<.update.>*/, /*<.lShaded.>*/, /*<.lBox.>*/, /*<.lRaised.>*/, /*<.lHtml.>*/ )
TSay():New( 055, 007, {|| "      caso contrário não será possível a sua importação;" }	, oWizard:oMPanel[3],,,,  , /*<.lBorder.>*/, .T./*<.lPixel.>*/, /*<nClrText>*/, /*<nClrBack>*/, 300/*<nWidth>*/, 08/*<nHeight>*/, /*<.design.>*/, /*<.update.>*/, /*<.lShaded.>*/, /*<.lBox.>*/, /*<.lRaised.>*/, /*<.lHtml.>*/ )
TSay():New( 065, 007, {|| "2)  Nenhuma coluna pode ser excluída;" }	, oWizard:oMPanel[3],,,,  , /*<.lBorder.>*/, .T./*<.lPixel.>*/, /*<nClrText>*/, /*<nClrBack>*/, 300/*<nWidth>*/, 08/*<nHeight>*/, /*<.design.>*/, /*<.update.>*/, /*<.lShaded.>*/, /*<.lBox.>*/, /*<.lRaised.>*/, /*<.lHtml.>*/ )
TSay():New( 075, 007, {|| "3)  Caso sejam alterados ou inseridos novos códigos para Filial, Regional e Produto o respectivo cadastro" }	, oWizard:oMPanel[3],,,,  , /*<.lBorder.>*/, .T./*<.lPixel.>*/, /*<nClrText>*/, /*<nClrBack>*/, 300/*<nWidth>*/, 08/*<nHeight>*/, /*<.design.>*/, /*<.update.>*/, /*<.lShaded.>*/, /*<.lBox.>*/, /*<.lRaised.>*/, /*<.lHtml.>*/ )
TSay():New( 085, 007, {|| "      deve existir no sistema;" }	, oWizard:oMPanel[3],,,,  , /*<.lBorder.>*/, .T./*<.lPixel.>*/, /*<nClrText>*/, /*<nClrBack>*/, 300/*<nWidth>*/, 08/*<nHeight>*/, /*<.design.>*/, /*<.update.>*/, /*<.lShaded.>*/, /*<.lBox.>*/, /*<.lRaised.>*/, /*<.lHtml.>*/ )
TSay():New( 095, 007, {|| "4)  Caso sejam inseridas novas colunas no arquivo que não fazem parte da sua estrutura exportada estas serão" }	, oWizard:oMPanel[3],,,,  , /*<.lBorder.>*/, .T./*<.lPixel.>*/, /*<nClrText>*/, /*<nClrBack>*/, 300/*<nWidth>*/, 08/*<nHeight>*/, /*<.design.>*/, /*<.update.>*/, /*<.lShaded.>*/, /*<.lBox.>*/, /*<.lRaised.>*/, /*<.lHtml.>*/ )
TSay():New( 105, 007, {|| "      desconsideradas na importação;" }	, oWizard:oMPanel[3],,,,  , /*<.lBorder.>*/, .T./*<.lPixel.>*/, /*<nClrText>*/, /*<nClrBack>*/, 300/*<nWidth>*/, 08/*<nHeight>*/, /*<.design.>*/, /*<.update.>*/, /*<.lShaded.>*/, /*<.lBox.>*/, /*<.lRaised.>*/, /*<.lHtml.>*/ )
TSay():New( 115, 007, {|| "5)  A coluna 'Descrição do Produto' (ZW_DESPROD) foi exportada somente como informativa, porque será "}	, oWizard:oMPanel[3],,,,  , /*<.lBorder.>*/, .T./*<.lPixel.>*/, /*<nClrText>*/, /*<nClrBack>*/, 300/*<nWidth>*/, 08/*<nHeight>*/, /*<.design.>*/, /*<.update.>*/, /*<.lShaded.>*/, /*<.lBox.>*/, /*<.lRaised.>*/, /*<.lHtml.>*/ )
TSay():New( 125, 007, {|| "      considerada a descrição atual do cadastro do Produto."}	, oWizard:oMPanel[3],,,,  , /*<.lBorder.>*/, .T./*<.lPixel.>*/, /*<nClrText>*/, /*<nClrBack>*/, 300/*<nWidth>*/, 08/*<nHeight>*/, /*<.design.>*/, /*<.update.>*/, /*<.lShaded.>*/, /*<.lBox.>*/, /*<.lRaised.>*/, /*<.lHtml.>*/ )
TSay():New( 135, 007, {|| "6)  ATENÇÃO! Ao abrir o arquivo no Excel(r) os dados com zeros à esquerda são suprimidos, e ao salvar um valor"}	, oWizard:oMPanel[3],,,,  , /*<.lBorder.>*/, .T./*<.lPixel.>*/, /*<nClrText>*/, /*<nClrBack>*/, 300/*<nWidth>*/, 08/*<nHeight>*/, /*<.design.>*/, /*<.update.>*/, /*<.lShaded.>*/, /*<.lBox.>*/, /*<.lRaised.>*/, /*<.lHtml.>*/ )
TSay():New( 145, 007, {|| "      como '000001' pode ficar salvo apenas como '1'. Esse cuidado deve ser tomado com os campos de código."}	, oWizard:oMPanel[3],,,,  , /*<.lBorder.>*/, .T./*<.lPixel.>*/, /*<nClrText>*/, /*<nClrBack>*/, 300/*<nWidth>*/, 08/*<nHeight>*/, /*<.design.>*/, /*<.update.>*/, /*<.lShaded.>*/, /*<.lBox.>*/, /*<.lRaised.>*/, /*<.lHtml.>*/ )

oWizard:Activate( .T./*<.lCenter.>*/,;
				{||.T.}/*<bValid>*/, ;
				{||.T.}/*<bInit>*/, ;
				{||.T.}/*<bWhen>*/ )

RestArea(aAreaSZW)

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
|  Descricao: Funcao para escolha da Previsão de Vendas
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
|    Sintaxe: ProcWizExp(aConfig, cCodFil, cCodPrev, cAno, cCodReg)
+--------------------------------------------------------------------------*/

Static Function ProcWizExp(aConfig, cCodFil, cCodPrev, cAno, cCodReg)                                          

MsgRun("Processando a exportação. Aguarde...",, {|lEnd| FimWizExp(aConfig, cCodFil, cCodPrev, cAno, cCodReg, .F.) } )

Return .T.  

/*----------------------+--------------------------------+------------------+
|   Programa: FimWizExp | Autor: Kley@TOTVS              | Data: 24/03/2014 |
+-----------------------+--------------------------------+------------------+
|  Descricao: Funcao para execucao das rotinas de copias quando pressionar
|			o botao Finalizar do assistente de copia.
+---------------------------------------------------------------------------+
|    Sintaxe: FimWizExp(aConfig, cCodFil, cCodPrev, cAno, cCodReg)
+--------------------------------------------------------------------------*/

Static Function FimWizExp(aConfig, cCodFil, cCodPrev, cAno, cCodReg, lEnd)

Local lRet 		:= .T.
Local aEstrut		:= {}
Local cNomeArq	:= ""
Local cAliasTmp	:= GetNextAlias()
Local cNomArq		:= AllTrim(MV_PAR07)
Local cDest 		:= Alltrim(MV_PAR08)
Local nHdl 		:= 0
Local cAliasTRB	:= GetNextAlias()

// Estrutura do arquivo temporario
aAdd( aEstrut, { "ZW_FILIAL"	,"C", TamSx3("ZW_FILIAL")[1], 0 } )
aAdd( aEstrut, { "ZW_CODPREV"	,"C", TamSx3("ZW_CODPREV")[1], 0 } )
aAdd( aEstrut, { "ZW_DESPREV"	,"C", TamSx3("ZW_DESPREV")[1], 0 } )
aAdd( aEstrut, { "ZW_ANO"		,"C", TamSx3("ZW_ANO")[1], 0 } )
aAdd( aEstrut, { "ZW_CODREG"	,"C", TamSx3("ZW_CODREG")[1], 0 } )
aAdd( aEstrut, { "ZW_DESREG"	,"C", TamSx3("ZZ_DESREG")[1], 0 } )
aAdd( aEstrut, { "ZW_CODPROD"	,"C", TamSx3("ZW_CODPROD")[1], 0 } )
aAdd( aEstrut, { "ZW_DESPROD"	,"C", TamSx3("B1_DESC")[1], 0 } )
aAdd( aEstrut, { "ZW_MES01"	,"N", TamSx3("ZW_MES01")[1]+2, 0 } )
aAdd( aEstrut, { "ZW_MES02"	,"N", TamSx3("ZW_MES02")[1]+2, 0 } )
aAdd( aEstrut, { "ZW_MES03"	,"N", TamSx3("ZW_MES03")[1]+2, 0 } )
aAdd( aEstrut, { "ZW_MES04"	,"N", TamSx3("ZW_MES04")[1]+2, 0 } )
aAdd( aEstrut, { "ZW_MES05"	,"N", TamSx3("ZW_MES05")[1]+2, 0 } )
aAdd( aEstrut, { "ZW_MES06"	,"N", TamSx3("ZW_MES06")[1]+2, 0 } )
aAdd( aEstrut, { "ZW_MES07"	,"N", TamSx3("ZW_MES07")[1]+2, 0 } )
aAdd( aEstrut, { "ZW_MES08"	,"N", TamSx3("ZW_MES08")[1]+2, 0 } )
aAdd( aEstrut, { "ZW_MES09"	,"N", TamSx3("ZW_MES09")[1]+2, 0 } )
aAdd( aEstrut, { "ZW_MES10"	,"N", TamSx3("ZW_MES10")[1]+2, 0 } )
aAdd( aEstrut, { "ZW_MES11"	,"N", TamSx3("ZW_MES11")[1]+2, 0 } )
aAdd( aEstrut, { "ZW_MES12"	,"N", TamSx3("ZW_MES12")[1]+2, 0 } )

// Cria o arquivo temporario
cNomeArq := CriaTrab( aEstrut, .T. )
dbUseArea( .T.,,cNomeArq, cAliasTmp, .F., .F. )

IndRegua( cAliasTmp, cNomeArq, "ZW_FILIAL+ZW_CODPREV+ZW_ANO+ZW_CODREG+ZW_CODPROD",,,"Criando Indice, Aguarde..." )
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
FWrite(nHdl, "ZW_FILIAL;ZW_CODPREV;ZW_DESPREV;ZW_ANO;ZW_CODREG;ZW_DESREG;ZW_CODPROD;ZW_DESPROD;ZW_MES01;ZW_MES02;ZW_MES03;ZW_MES04;ZW_MES05;ZW_MES06;ZW_MES07;ZW_MES08;ZW_MES09;ZW_MES10;ZW_MES11;ZW_MES12")
FWrite(nHdl, CRLF)

// Geração dos dados no arquivo de trabalho, de acordo com os parâmetros
If Select(cAliasTRB) > 0
	(cAliasTRB)->(dbCloseArea())
Endif

BeginSQL Alias cAliasTRB
	select 
		rtrim(ZW_FILIAL) as ZW_FILIAL,  rtrim(ZW_CODPREV) as ZW_CODPREV, rtrim(ZW_DESPREV) as ZW_DESPREV, rtrim(ZW_ANO) as ZW_ANO, 
		rtrim(ZW_CODREG) as ZW_CODREG,  rtrim(isnull(ZZ_DESREG,' ')) as ZW_DESREG,
		rtrim(ZW_CODPROD) as ZW_CODPROD, rtrim(isnull(B1_DESC,' '))   as ZW_DESPROD,
		ZW_MES01, ZW_MES02, ZW_MES03, ZW_MES04, ZW_MES05, ZW_MES06, ZW_MES07, ZW_MES08, ZW_MES09, ZW_MES10, ZW_MES11, ZW_MES12
	from %Table:SZW% SZW
	left join %Table:SZZ% SZZ on ZZ_FILIAL = %xFilial:SZZ% and ZZ_CODREG = ZW_CODREG  and SZZ.%NotDel%
	left join %Table:SB1% SB1 on B1_FILIAL = %xFilial:SB1% and B1_COD    = ZW_CODPROD and SB1.%NotDel%
	where ZW_FILIAL  = %Exp:MV_PAR01%
	  and ZW_CODPREV = %Exp:MV_PAR02%
	  and ZW_ANO     = %Exp:MV_PAR04%
	  and ZW_CODREG  = %Exp:MV_PAR05%
	  and SZW.%NotDel%
	order by ZW_FILIAL, ZW_CODPREV, ZW_ANO, ZW_CODREG, ZW_CODPROD
 EndSQL

DbSelectArea(cAliasTRB)
(cAliasTRB)->(dbGoTop())

If !Eof(cAliasTRB)
	
	While !Eof(cAliasTRB)
		
		// Grava a linha do Detalhe
		FWrite(nHdl, (cAliasTRB)->ZW_FILIAL + ";" + (cAliasTRB)->ZW_CODPREV + ";" + (cAliasTRB)->ZW_DESPREV + ";" + (cAliasTRB)->ZW_ANO + ";" + ;
				   (cAliasTRB)->ZW_CODREG + ";" + (cAliasTRB)->ZW_DESREG + ";" + (cAliasTRB)->ZW_CODPROD + ";" + (cAliasTRB)->ZW_DESPROD + ";" + ;
				   Transform((cAliasTRB)->ZW_MES01, PesqPict("SZW","ZW_MES01")) + ";" + Transform((cAliasTRB)->ZW_MES02, PesqPict("SZW","ZW_MES02")) + ";" + ;
				   Transform((cAliasTRB)->ZW_MES03, PesqPict("SZW","ZW_MES03")) + ";" + Transform((cAliasTRB)->ZW_MES04, PesqPict("SZW","ZW_MES04")) + ";" + ;
				   Transform((cAliasTRB)->ZW_MES05, PesqPict("SZW","ZW_MES05")) + ";" + Transform((cAliasTRB)->ZW_MES06, PesqPict("SZW","ZW_MES06")) + ";" + ;
				   Transform((cAliasTRB)->ZW_MES07, PesqPict("SZW","ZW_MES07")) + ";" + Transform((cAliasTRB)->ZW_MES08, PesqPict("SZW","ZW_MES08")) + ";" + ;
				   Transform((cAliasTRB)->ZW_MES09, PesqPict("SZW","ZW_MES09")) + ";" + Transform((cAliasTRB)->ZW_MES10, PesqPict("SZW","ZW_MES10")) + ";" + ;
				   Transform((cAliasTRB)->ZW_MES11, PesqPict("SZW","ZW_MES11")) + ";" + Transform((cAliasTRB)->ZW_MES12, PesqPict("SZW","ZW_MES12")) )
		FWrite(nHdl, CRLF)
		
		(cAliasTRB)->(dbSkip())
	Enddo
	
Else
	MsgStop("Não existem Produtos para esta Previsão de Vendas. Para exportação da Previsão é necessário que exista pelo menos um Produto cadastrado.", "Exportação da Previsão de Vendas" )
Endif

FClose(nHdl)

// Apaga o TMP
DbCloseArea("cAliasTmp")
FErase( cNomeArq + ".DBF" )
FErase( cNomeArq + OrdBagExt() )

Return(lRet)

/*----------------------+--------------------------------+------------------+
|   Programa: AVF11Imp  | Autor: Kley@TOTVS              | Data: 24/03/2014 |
+-----------------------+--------------------------------+------------------+
|  Descricao: Exporta o Planejamento de Vendas para arquivo CSV
+---------------------------------------------------------------------------+
|        Uso: U_AVFATA11()
+--------------------------------------------------------------------------*/

User Function AVF11Imp

Local oWizard
Local cArquivo
Local aAreaSZW 	:= SZW->(GetArea())
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

Private cCodFil  	:= xFilial("SZW")
Private cCodPrev	:= SZW->ZW_CODPREV
Private cAno   	:= SZW->ZW_ANO
Private cCodReg	:= SZW->ZW_CODREG

oWizard := APWizard():New("Atenção"/*<chTitle>*/,;
						"Este assistente lhe ajudara a importar os dados de um arquivo CSV para uma Previsão de Vendas."/*<chMsg>*/, "Importação da Previsão de Vendas"/*<cTitle>*/, ;
						"Você deverá indicar os parâmetros e ao finalizar o assistente, os dados serão importados conforme os parâmetros solicitados."/*<cText>*/,;
						{||.T.}/*<bNext>*/, ;
						{||.T.}/*<bFinish>*/,;
						/*<.lPanel.>*/, , , /*<.lNoFirst.>*/,;
						aCoord)

oWizard:NewPanel( "Parâmetros"/*<chTitle>*/,;
				"Neste passo você deverá informar os parâmetros para importação da Previsão de Vendas."/*<chMsg>*/, ;
				{||.T.}/*<bBack>*/, ;
				{||Rest_Par(aConfig),ParamOk(aParametros, aConfig) }/*<bNext>*/, ;
				{||.T.}/*<bFinish>*/,;
				.T./*<.lPanel.>*/,;
				{||Plan_Box(oWizard,@lParam, aParametros, aConfig)}/*<bExecute>*/ )

oWizard:NewPanel( "Importação da Previsão de Vendas"/*<chTitle>*/,;
				"Neste passo você deverá confirmar ou abortar a importação do arquivo.",;
				{||.T.}/*<bBack>*/, ;
				{||.T.}/*<bNext>*/, ;
				{|| lRet := ProcWizImp(aConfig, cCodFil, cCodPrev, cAno, cCodReg)}/*<bFinish>*/, ;
				.T./*<.lPanel.>*/, ;
				{||.T.}/*<bExecute>*/ )
                                                                     
TSay():New( 010, 007, {|| "A Previsão de Vendas será importada de um arquivo no formato CSV conforme parâmetros selecionados." }	, oWizard:oMPanel[3],,,,  , /*<.lBorder.>*/, .T./*<.lPixel.>*/, /*<nClrText>*/, /*<nClrBack>*/, 300/*<nWidth>*/, 08/*<nHeight>*/, /*<.design.>*/, /*<.update.>*/, /*<.lShaded.>*/, /*<.lBox.>*/, /*<.lRaised.>*/, /*<.lHtml.>*/ ) 
TSay():New( 025, 007, {|| "Os critérios abaixos devem ser observados para importação dos dados com sucesso:" }	, oWizard:oMPanel[3],,,,  , /*<.lBorder.>*/, .T./*<.lPixel.>*/, /*<nClrText>*/, /*<nClrBack>*/, 300/*<nWidth>*/, 08/*<nHeight>*/, /*<.design.>*/, /*<.update.>*/, /*<.lShaded.>*/, /*<.lBox.>*/, /*<.lRaised.>*/, /*<.lHtml.>*/ )
TSay():New( 035, 007, {|| "1)  Para se obter o layout do arquivo para importação é recomendável fazer primeiro uma exportação;" }	, oWizard:oMPanel[3],,,,  , /*<.lBorder.>*/, .T./*<.lPixel.>*/, /*<nClrText>*/, /*<nClrBack>*/, 300/*<nWidth>*/, 08/*<nHeight>*/, /*<.design.>*/, /*<.update.>*/, /*<.lShaded.>*/, /*<.lBox.>*/, /*<.lRaised.>*/, /*<.lHtml.>*/ )
TSay():New( 045, 007, {|| "2)  O cabeçalho do arquivo, que corresponde a primeira linha, deve conter os títulos das colunas e não podem" }	, oWizard:oMPanel[3],,,,  , /*<.lBorder.>*/, .T./*<.lPixel.>*/, /*<nClrText>*/, /*<nClrBack>*/, 300/*<nWidth>*/, 08/*<nHeight>*/, /*<.design.>*/, /*<.update.>*/, /*<.lShaded.>*/, /*<.lBox.>*/, /*<.lRaised.>*/, /*<.lHtml.>*/ )
TSay():New( 055, 007, {|| "      ser excluídos, alterados ou incluídos;" }	, oWizard:oMPanel[3],,,,  , /*<.lBorder.>*/, .T./*<.lPixel.>*/, /*<nClrText>*/, /*<nClrBack>*/, 300/*<nWidth>*/, 08/*<nHeight>*/, /*<.design.>*/, /*<.update.>*/, /*<.lShaded.>*/, /*<.lBox.>*/, /*<.lRaised.>*/, /*<.lHtml.>*/ )
TSay():New( 065, 007, {|| "3)  O arquivo inteiro deve corresponder a uma única Previsão de Vendas, que é identificada pelas colunas:" }	, oWizard:oMPanel[3],,,,  , /*<.lBorder.>*/, .T./*<.lPixel.>*/, /*<nClrText>*/, /*<nClrBack>*/, 300/*<nWidth>*/, 08/*<nHeight>*/, /*<.design.>*/, /*<.update.>*/, /*<.lShaded.>*/, /*<.lBox.>*/, /*<.lRaised.>*/, /*<.lHtml.>*/ )
TSay():New( 075, 007, {|| "      FILIAL, CÓDIGO DA PREVISÃO, ANO, CÓDIGO DA REGIONAL; portanto as seis primeiras colunas do arquivo devem" }	, oWizard:oMPanel[3],,,,  , /*<.lBorder.>*/, .T./*<.lPixel.>*/, /*<nClrText>*/, /*<nClrBack>*/, 300/*<nWidth>*/, 08/*<nHeight>*/, /*<.design.>*/, /*<.update.>*/, /*<.lShaded.>*/, /*<.lBox.>*/, /*<.lRaised.>*/, /*<.lHtml.>*/ )
TSay():New( 085, 007, {|| "      obrigatoriamente ser iguais." }	, oWizard:oMPanel[3],,,,  , /*<.lBorder.>*/, .T./*<.lPixel.>*/, /*<nClrText>*/, /*<nClrBack>*/, 300/*<nWidth>*/, 08/*<nHeight>*/, /*<.design.>*/, /*<.update.>*/, /*<.lShaded.>*/, /*<.lBox.>*/, /*<.lRaised.>*/, /*<.lHtml.>*/ )
TSay():New( 095, 007, {|| "4)  A coluna 'Descrição do Produto' (ZW_DESPROD) é somente informativo, e portanto não é obrigatório e não será" }	, oWizard:oMPanel[3],,,,  , /*<.lBorder.>*/, .T./*<.lPixel.>*/, /*<nClrText>*/, /*<nClrBack>*/, 300/*<nWidth>*/, 08/*<nHeight>*/, /*<.design.>*/, /*<.update.>*/, /*<.lShaded.>*/, /*<.lBox.>*/, /*<.lRaised.>*/, /*<.lHtml.>*/ )
TSay():New( 105, 007, {|| "      considerada na importação;"}	, oWizard:oMPanel[3],,,,  , /*<.lBorder.>*/, .T./*<.lPixel.>*/, /*<nClrText>*/, /*<nClrBack>*/, 300/*<nWidth>*/, 08/*<nHeight>*/, /*<.design.>*/, /*<.update.>*/, /*<.lShaded.>*/, /*<.lBox.>*/, /*<.lRaised.>*/, /*<.lHtml.>*/ )
TSay():New( 115, 007, {|| "5)  IMPORTANTE! Atualização ou Inclusão: se a Previsão de Vendas já estiver cadastrada no sistema os Produtos"}	, oWizard:oMPanel[3],,,,  , /*<.lBorder.>*/, .T./*<.lPixel.>*/, /*<nClrText>*/, /*<nClrBack>*/, 300/*<nWidth>*/, 08/*<nHeight>*/, /*<.design.>*/, /*<.update.>*/, /*<.lShaded.>*/, /*<.lBox.>*/, /*<.lRaised.>*/, /*<.lHtml.>*/ )
TSay():New( 125, 007, {|| "      existentes serão atualizados, e os Produtos que não existem serão incluídos; se a Previsão de Vendas não"}	, oWizard:oMPanel[3],,,,  , /*<.lBorder.>*/, .T./*<.lPixel.>*/, /*<nClrText>*/, /*<nClrBack>*/, 300/*<nWidth>*/, 08/*<nHeight>*/, /*<.design.>*/, /*<.update.>*/, /*<.lShaded.>*/, /*<.lBox.>*/, /*<.lRaised.>*/, /*<.lHtml.>*/ )
TSay():New( 135, 007, {|| "       estiver cadastrada os dados serão incluídos no sistema como novos;"}	, oWizard:oMPanel[3],,,,  , /*<.lBorder.>*/, .T./*<.lPixel.>*/, /*<nClrText>*/, /*<nClrBack>*/, 300/*<nWidth>*/, 08/*<nHeight>*/, /*<.design.>*/, /*<.update.>*/, /*<.lShaded.>*/, /*<.lBox.>*/, /*<.lRaised.>*/, /*<.lHtml.>*/ )
TSay():New( 145, 007, {|| "6)  ATENÇÃO! Ao abrir o arquivo no Excel(r) os dados com zeros à esquerda são suprimidos, e ao salvar um valor"}	, oWizard:oMPanel[3],,,,  , /*<.lBorder.>*/, .T./*<.lPixel.>*/, /*<nClrText>*/, /*<nClrBack>*/, 300/*<nWidth>*/, 08/*<nHeight>*/, /*<.design.>*/, /*<.update.>*/, /*<.lShaded.>*/, /*<.lBox.>*/, /*<.lRaised.>*/, /*<.lHtml.>*/ )
TSay():New( 155, 007, {|| "      como '000001' pode ficar salvo apenas como '1'. Esse cuidado deve ser tomado com os campos de código."}	, oWizard:oMPanel[3],,,,  , /*<.lBorder.>*/, .T./*<.lPixel.>*/, /*<nClrText>*/, /*<nClrBack>*/, 300/*<nWidth>*/, 08/*<nHeight>*/, /*<.design.>*/, /*<.update.>*/, /*<.lShaded.>*/, /*<.lBox.>*/, /*<.lRaised.>*/, /*<.lHtml.>*/ )

oWizard:Activate( .T./*<.lCenter.>*/,;
				{||.T.}/*<bValid>*/, ;
				{||.T.}/*<bInit>*/, ;
				{||.T.}/*<bWhen>*/ )

RestArea(aAreaSZW)

Return

/*----------------------+--------------------------------+------------------+
|   Programa: ProcWizImp| Autor: Kley@TOTVS              | Data: 24/03/2014 |
+-----------------------+--------------------------------+------------------+
|  Descricao: Processa o Wizard
+---------------------------------------------------------------------------+
|    Sintaxe: ProcWizImp(aConfig, cCodFil, cCodPrev, cAno, cCodReg)
+--------------------------------------------------------------------------*/

Static Function ProcWizImp(aConfig, cCodFil, cCodPrev, cAno, cCodReg)                                          

Local oProcess

oProcess:= MsNewProcess():New({|lEnd| FimWizImp(aConfig, cCodFil, cCodPrev, cAno, cCodReg, .F., oProcess)})
oProcess:Activate()

Return .T.  

/*----------------------+--------------------------------+------------------+
|   Programa: FimWizImp | Autor: Kley@TOTVS              | Data: 24/03/2014 |
+-----------------------+--------------------------------+------------------+
|  Descricao: Funcao para execucao das rotinas de copias quando pressionar
|			o botao Finalizar do assistente de copia.
+---------------------------------------------------------------------------+
|    Sintaxe: FimWizImp(aConfig, cCodFil, cCodPrev, cAno, cCodReg, lEnd, oProcess)
+--------------------------------------------------------------------------*/

Static Function FimWizImp(aConfig, cCodFil, cCodPrev, cAno, cCodReg, lEnd, oProcess)

Local lRet 		:= .T.
Local aEstrut		:= {}
Local cNomeArq	:= ""
Local cAliasTmp	:= GetNextAlias()
Local cNomArq		:= AllTrim(MV_PAR05)
Local nHdl 		:= 0
Local cAliasTRB	:= GetNextAlias()
Local aCampos		:= {}
Local aPosCampos	:= {}
Local nPos		:= 0
Local nAt		:= 0
Local cCampo		:= ""
Local nPosCpo		:= 0
Local nPosNil		:= 0
Local aTxt		:= {}
Local nCampo		:= 0
Local nX			:= 0
Local nY			:= 0
Local nValor 		:= 0

// Estrutura do arquivo temporario
aAdd( aEstrut, { "LINHA"		,"C", 5, 0 } )
aAdd( aEstrut, { "ZW_FILIAL"	,"C", TamSx3("ZW_FILIAL")[1], 0 } )
aAdd( aEstrut, { "ZW_CODPREV"	,"C", TamSx3("ZW_CODPREV")[1], 0 } )
aAdd( aEstrut, { "ZW_DESPREV"	,"C", TamSx3("ZW_DESPREV")[1], 0 } )
aAdd( aEstrut, { "ZW_ANO"		,"C", TamSx3("ZW_ANO")[1], 0 } )
aAdd( aEstrut, { "ZW_CODREG"	,"C", TamSx3("ZW_CODREG")[1], 0 } )
aAdd( aEstrut, { "ZW_DESREG"	,"C", TamSx3("ZZ_DESREG")[1], 0 } )
aAdd( aEstrut, { "ZW_CODPROD"	,"C", TamSx3("ZW_CODPROD")[1], 0 } )
aAdd( aEstrut, { "ZW_DESPROD"	,"C", TamSx3("B1_DESC")[1], 0 } )
aAdd( aEstrut, { "ZW_MES01"	,"N", TamSx3("ZW_MES01")[1]+2, 0 } )
aAdd( aEstrut, { "ZW_MES02"	,"N", TamSx3("ZW_MES02")[1]+2, 0 } )
aAdd( aEstrut, { "ZW_MES03"	,"N", TamSx3("ZW_MES03")[1]+2, 0 } )
aAdd( aEstrut, { "ZW_MES04"	,"N", TamSx3("ZW_MES04")[1]+2, 0 } )
aAdd( aEstrut, { "ZW_MES05"	,"N", TamSx3("ZW_MES05")[1]+2, 0 } )
aAdd( aEstrut, { "ZW_MES06"	,"N", TamSx3("ZW_MES06")[1]+2, 0 } )
aAdd( aEstrut, { "ZW_MES07"	,"N", TamSx3("ZW_MES07")[1]+2, 0 } )
aAdd( aEstrut, { "ZW_MES08"	,"N", TamSx3("ZW_MES08")[1]+2, 0 } )
aAdd( aEstrut, { "ZW_MES09"	,"N", TamSx3("ZW_MES09")[1]+2, 0 } )
aAdd( aEstrut, { "ZW_MES10"	,"N", TamSx3("ZW_MES10")[1]+2, 0 } )
aAdd( aEstrut, { "ZW_MES11"	,"N", TamSx3("ZW_MES11")[1]+2, 0 } )
aAdd( aEstrut, { "ZW_MES12"	,"N", TamSx3("ZW_MES12")[1]+2, 0 } )

// Cria o arquivo temporario
cNomeArq := CriaTrab( aEstrut, .T. )
dbUseArea( .T.,,cNomeArq, cAliasTmp, .F., .F. )

IndRegua( cAliasTmp, cNomeArq, "ZW_FILIAL+ZW_CODPREV+ZW_ANO+ZW_CODREG+ZW_CODPROD",,,"Criando Indice, Aguarde..." )
dbClearIndex()
dbSetIndex( cNomeArq + OrdBagExt() )

// Campos para Validacao
aAdd(aCampos,"ZW_FILIAL")
aAdd(aCampos,"ZW_CODPREV")
aAdd(aCampos,"ZW_DESPREV")
aAdd(aCampos,"ZW_ANO")
aAdd(aCampos,"ZW_CODREG")
aAdd(aCampos,"ZW_CODPROD")
aAdd(aCampos,"ZW_MES01")
aAdd(aCampos,"ZW_MES02")
aAdd(aCampos,"ZW_MES03")
aAdd(aCampos,"ZW_MES04")
aAdd(aCampos,"ZW_MES05")
aAdd(aCampos,"ZW_MES06")
aAdd(aCampos,"ZW_MES07")
aAdd(aCampos,"ZW_MES08")
aAdd(aCampos,"ZW_MES09")
aAdd(aCampos,"ZW_MES10")
aAdd(aCampos,"ZW_MES11")
aAdd(aCampos,"ZW_MES12")

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

ImpPrevVen(aConfig, cCodFil, cCodPrev, cAno, cCodReg, lEnd, cAliasTmp, cNomArq, oProcess)

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
|  Descricao: Realiza a importação da Previsão de Vendas.
+---------------------------------------------------------------------------+
|    Sintaxe: ImpPrevVen(aConfig, cCodFil, cCodPrev, cAno, cCodReg, lEnd, cAliasTmp, cNomArq, oProcess)
+--------------------------------------------------------------------------*/

Static Function ImpPrevVen(aConfig, cCodFil, cCodPrev, cAno, cCodReg, lEnd, cAliasTmp, cNomArq, oProcess)

Local nTotRegs	:= 0
Local cTexto 		:= ""
Local nProcRegs	:= 0
Local lErro		:= .F.
Local cChaveSZW	:= ""
Local lExistSZW	:= .F.
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
ctexto += "LOG DE IMPORTACAO DA PREVISAO DE VENDAS" + CRLF
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
	If Empty(cChaveSZW)
		cChaveSZW  := (cAliasTmp)->(ZW_FILIAL+ZW_CODPREV+ZW_ANO+ZW_CODREG)	// 1ª linha do arquivo usada para comparação com as demais linhas	
		// Verifica se já existe Previsão de Vendas com a mesma chave do arquivo
		dbSelectArea("SZW")
		SZW->(dbSetOrder(1))

		If SZW->(dbSeek(cChaveSZW))
			cTexto += " Já existe uma Previsão de Vendas cadastrada com a mesma chave do arquivo. Fil/Cod.Prev./Ano/Cod.Reg.: "+RTrim((cAliasTmp)->(ZW_FILIAL))+"/"+RTrim((cAliasTmp)->(ZW_CODPREV))+"/"+RTrim((cAliasTmp)->(ZW_ANO))+"/"+RTrim((cAliasTmp)->(ZW_CODREG))+";"+CRLF
			cTexto += " As linhas existentes serão atualizadas, e as novas serão inseridas."+CRLF
			lExistSZW := .T.
		Else

			// Valida a Filial logada
			If (cAliasTmp)->(ZW_FILIAL) # xFilial("SZW")
				aSM0 := FWLoadSM0()
				If aScan(aSM0, { |x,y| x[1]==cEmpAnt .and. x[2]==(cAliasTmp)->(ZW_FILIAL) } ) > 0
					cTexto += " O código da Filial informada no arquivo (" + (cAliasTmp)->(ZW_FILIAL) + ") é diferente da Filial logada no sistema (" + RTrim(cFilAnt) +")."+CRLF
					lErro := .T.
				Else
					cTexto += " O código da Filial informada no arquivo (" + (cAliasTmp)->(ZW_FILIAL) + ") é inválida para a Empresa logada ou inexistente."+CRLF
					lErro := .T.					
				EndIf
			EndIf

			// Verifica se já existe Previsão de Vendas com o mesmo Código, porém com ANO ou Cód.Regional são Diferentes
			dbSelectArea("SZW")
			SZW->(dbSetOrder(1),dbGoTop(),dbSeek((cAliasTmp)->(ZW_FILIAL+ZW_CODPREV)))
			Do While SZW->(!Eof()) .and. SZW->(ZW_FILIAL+ZW_CODPREV) == (cAliasTmp)->(ZW_FILIAL+ZW_CODPREV)
				If SZW->ZW_ANO # (cAliasTmp)->ZW_ANO .or. SZW->ZW_CODREG # (cAliasTmp)->ZW_CODREG
					cTexto += " Já existe Previsão cadastrada com o mesmo código (" + (cAliasTmp)->ZW_CODPREV + "), porém o ANO ou REGIONAL são diferentes;"+CRLF+;
								" ANO/COD.REGIONAL do arquivo: " + (cAliasTmp)->ZW_ANO+"/"+(cAliasTmp)->ZW_CODREG+" | ANO/COD.REGIONAL cadastrados: " + SZW->ZW_ANO+"/"+SZW->ZW_CODREG+"."+CRLF
					lErro := .T.					
				EndIf				
				SZW->(dbSkip())
			EndDo

			// Valida o Ano
			If (cAliasTmp)->(ZW_ANO) < "2010" .or. (cAliasTmp)->(ZW_ANO) > "2030"
				cTexto += " O Ano informada no arquivo (" + (cAliasTmp)->(ZW_ANO) + ") é inválido."+CRLF
				lErro := .T.	
			EndIf

			// Valida Código da Regional
			If !ExistCpo("SZZ",(cAliasTmp)->ZW_CODREG)
				cTexto += " O Código da Regional do arquivo ("+(cAliasTmp)->(ZW_CODREG)+") não existe no cadastro de Regional."+CRLF
				lErro := .T.	
			EndIf

		EndIf		
	ElseIf cChaveSZW # (cAliasTmp)->(ZW_FILIAL+ZW_CODPREV+ZW_ANO+ZW_CODREG)
		cTexto += " Linha ["+(cAliasTmp)->LINHA+"] A chave da Previsão de Vendas (Fil/Cod.Prev./Ano/Cod.Reg) é diferente da 1a. linha de dados do arquivo;"+CRLF+;
				" Chave da linha corrente: "+(cAliasTmp)->(ZW_FILIAL+ZW_CODPREV+ZW_ANO+ZW_CODREG)+" | Chave 1a. linha: "+cChaveSZW+"."+CRLF
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
		
		oProcess:IncRegua2("Importando os dados para Previsão - Produto: "+(cAliasTmp)->ZW_CODPROD)

		DbSelectArea("SZW")
		SZW->(DbSetOrder(1))

		If SZW->(DbSeek(cChaveSZW+(cAliasTmp)->ZW_CODPROD))	//Alteração | Encontrou a chave
			RecLock("SZW",.F.)
			SZW->ZW_DESPREV	:=(cAliasTmp)->ZW_DESPREV
		Else														//Inclusão  | Não Encontrou a chave
			RecLock("SZW",.T.)
			SZW->ZW_FILIAL	:= xFilial("SZW")
			SZW->ZW_CODPREV	:=(cAliasTmp)->ZW_CODPREV  
			SZW->ZW_DESPREV	:=(cAliasTmp)->ZW_DESPREV
			SZW->ZW_ANO		:=(cAliasTmp)->ZW_ANO
			SZW->ZW_CODREG	:=(cAliasTmp)->ZW_CODREG
			SZW->ZW_CODPROD	:=(cAliasTmp)->ZW_CODPROD
		EndIf

		SZW->ZW_MES01		:=(cAliasTmp)->ZW_MES01
		SZW->ZW_MES02		:=(cAliasTmp)->ZW_MES02
		SZW->ZW_MES03		:=(cAliasTmp)->ZW_MES03
		SZW->ZW_MES04		:=(cAliasTmp)->ZW_MES04
		SZW->ZW_MES05		:=(cAliasTmp)->ZW_MES05
		SZW->ZW_MES06		:=(cAliasTmp)->ZW_MES06
		SZW->ZW_MES07		:=(cAliasTmp)->ZW_MES07
		SZW->ZW_MES08		:=(cAliasTmp)->ZW_MES08
		SZW->ZW_MES09		:=(cAliasTmp)->ZW_MES09
		SZW->ZW_MES10		:=(cAliasTmp)->ZW_MES10
		SZW->ZW_MES11		:=(cAliasTmp)->ZW_MES11
		SZW->ZW_MES12		:=(cAliasTmp)->ZW_MES12
		
		MsUnLock("SZW")
			
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
