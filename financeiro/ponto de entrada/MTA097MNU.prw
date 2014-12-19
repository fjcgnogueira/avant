#Include "Rwmake.ch"
#Include "Protheus.ch"
/*
===========================================================================================
Programa.: 	MTA097MNU
Autor....:	Pedro Augusto
Data.....: 	maio/2014 
Descricao: 	PE utilizado para adicionar opcoes no aRotina
1) Opcao para remover opcao de :
- Aprovar  Docto
- Consulta Docto
- Estornar Docto
Faz-se necessario para que as funcionalidades da MATA097 possar contemplar
outros tipos de documento, tais como TP (Titulo a pagar).
Uso......: 	AVANT
===========================================================================================
*/
User Function MTA097MNU()
Private aRotTmp := MenuDef()
aRotina := aRotTmp
Return aRotina

Static Function MenuDef()
Local aRotTmp:= {}

For i := 1  to Len(aRotina)
	If Upper(aRotina[i][2]) <> "A097VISUAL" .and. ;
		Upper(aRotina[i][2]) <> "A097ESTORNA".and. ;
		Upper(aRotina[i][2]) <> "A097LIBERA"
		AaDd(aRotTmp,aRotina[i])
	Endif
Next i

AaDd(aRotTmp, {"Consulta Docto"	, 	'U_AV097V'  ,0, 2})
AaDd(aRotTmp, {"liberar"	 	, 	'U_AV097L'  ,0, 2})
Return aRotTmp

/*
===========================================================================================
Programa.: 	AV097L
Autor....:	Pedro Augusto
Data.....: 	mar/2014 
Descricao: 	Rotina que fará o desvio para LIBERACAO de documentos nao contemplados na MATA097
Uso......: 	AVANT
===========================================================================================
*/
User function AV097L()
Local _lRet := .t.
Local _aArea := GetArea()

//If SCR->CR_TIPO $ "SC|SA|TP|LQ|EC|AD|RV|CC"
If SCR->CR_TIPO $ "TP"
	AV097Lib(SCR->CR_TIPO)
Else
	A097Libera("SCR",SCR->(RECNO()),2)   // Chama a rotina padrao
Endif
RestArea(_aArea)
Return _lRet

/*
===========================================================================================
Programa.: 	AV097V
Autor....:	Pedro Augusto
Data.....: 	mai/2014
Descricao: 	Rotina que fará o desvio para VISUALIZACAO de documentos nao contemplados na MATA097
Uso......: 	AVANT
===========================================================================================
*/
User function AV097V()
Local _lRet 	:= .t.
Local _aArea  := GetArea()

If SCR->CR_TIPO $ "TP"
	AV097Vis(SCR->CR_TIPO)
Else
	A097Visual()   // Chama a rotina padrao //
Endif
RestArea(_aArea)
Return _lRet


/*
===========================================================================================
Programa.: 	AV097LIB
Autor....:	Pedro Augusto
Data.....: 	mai/2014
Descricao: 	Rotina que fará liberacao de documentos nao contemplados na MATA097
Uso......: 	AVANT
===========================================================================================
*/
Static Function AV097Lib(cTipoDoc)
Local _lContinua:= .T.
Local aArea 	:= GetArea()
Local aRetSaldo := {}
Local cObs 		:= IIF(!Empty(SCR->CR_OBS),SCR->CR_OBS,CriaVar("CR_OBS"))
Local ca097User := RetCodUsr()
Local cTipoLim  := ""
Local CRoeda    := ""
Local cAprov    := ""
Local cName     := ""
Local cGrupo	:= ""
Local cCodLiber := SCR->CR_APROV
Local cDocto    := SCR->CR_NUM
Local cTipo     := SCR->CR_TIPO
Local cFilDoc   := SCR->CR_FILIAL
Local dRefer 	:= dDataBase
Local cSCUser	:= ""
Local nReg 		:= SCR->(Recno())
Local lAprov    := .F.
Local lLiberou	:= .F.
Local lLibOk    := .F.
Local lContinua := .T.
Local lShowBut  := .T.

Local nSavOrd   := IndexOrd()
Local nSaldo    := 0
Local nOpc      := 0
Local nSalDif	:= 0
Local nTotal    := 0
Local nMoeda	:= 1
Local nX        := 1

Local oDlg
Local oDataRef
Local oSaldo
Local oSalDif
Local oBtn1
Local oBtn2
Local oBtn3
Local oQual
Local aSize := {0,0}
Local cTipoDesc := ""

If cTipodoc = "TP"
	cTipoDesc := "Titulo a pagar"
Endif

If  !Empty(SCR->CR_DATALIB) .And. SCR->CR_STATUS$"03#05"
	Aviso("Atencao!","Este documento ja foi liberado anteriormente. Somente os documentos que estao aguardando liberacao (destacado em vermelho no Browse) poderao ser liberados.",{"Voltar"},2)
	_lContinua := .F.
ElseIf _lContinua .And. SCR->CR_STATUS$"01"
	Aviso("A097BLQ","Esta operação não poderá ser realizada pois este registro se encontra bloqueado pelo sistema (aguardando outros niveis)",{"Voltar"})
	_lContinua := .F.
EndIf

If _lContinua
	dbSelectArea("SAL")
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Inicializa as variaveis utilizadas no Display.               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aRetSaldo := MaSalAlc(cCodLiber,dRefer)
	nSaldo 	  := aRetSaldo[1]
	//		CRoeda 	  := A097Moeda(aRetSaldo[2])
	cName  	  := UsrRetName(ca097User)
	nTotal    := xMoeda(SCR->CR_TOTAL,SCR->CR_MOEDA,aRetSaldo[2],SCR->CR_EMISSAO,,SCR->CR_TXMOEDA)
	
	Do Case
		Case SAK->AK_TIPO == "D"
			cTipoLim :=OemToAnsi("Diario") // "Diario"
		Case  SAK->AK_TIPO == "S"
			cTipoLim := OemToAnsi("Semanal") //"Semanal"
		Case  SAK->AK_TIPO == "M"
			cTipoLim := OemToAnsi("Mensal") //"Mensal"
		Case  SAK->AK_TIPO == "A"
			cTipoLim := OemToAnsi("Anual") //"Anual"
	EndCase
	
	Do Case
		Case cTipoDoc == "TP"
			dbSelectArea("SE2")
			dbSetOrder(1)
			MsSeek(xFilial("SE2")+Substr(SCR->CR_NUM,1,len((E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA) )))
			cGrupo := Alltrim(GetMV("MV_XGRAPRO"))
			
			dbSelectArea("SA2")
			dbSetOrder(1)
			MsSeek(xFilial("SA2")+SE2->E2_FORNECE+SE2->E2_LOJA)
			
			dbSelectArea("SAL")
			dbSetOrder(3)
			MsSeek(xFilial("SAL")+Alltrim(SE2->E2_APROVA)+SAK->AK_COD)
			
			If Eof()
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Posiciona a Tabela SAL pelo Aprovador de Origem caso o Documento tenha sido ³
				//| transferido por Ausência Temporária ou Transferência superior e o aprovador |
				//| de destino não fizer parte do Grupo de Aprovação.                           |
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If !Empty(SCR->(FieldPos("CR_USERORI")))
					dbSeek(xFilial("SAL")+cGrupo+SCR->CR_APRORI)
				EndIf
			EndIf
			

	EndCase
	
	If SAL->AL_LIBAPR != "A"
		lAprov := .T.
		cAprov := OemToAnsi("VISTO / LIVRE") // "VISTO / LIVRE"
	EndIf
	nSalDif := nSaldo - IIF(lAprov,0,nTotal)
	If (nSalDif) < 0
		Help(" ",1,"A097SALDO") //Aviso(STR0040,STR0041,{STR0037},2) //"Saldo Insuficiente"###"Saldo na data insuficiente para efetuar a liberacao do pedido. Verifique o saldo disponivel para aprovacao na data e o valor total do pedido."###"Voltar"
		_lContinua := .F.
	EndIf
	
Endif
If _lContinua
	aSize := {290,410}
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Ponto de Entrada MT097DLG permite alterar o tamanho da tela.³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	DEFINE MSDIALOG oDlg FROM 0,0 TO aSize[1],aSize[2] TITLE "Liberacao  - "+cTipoDesc PIXEL
	@ 0.5,01 TO 44,204 LABEL "" OF oDlg PIXEL
	@ 45,01  TO 128,204 LABEL "" OF oDlg PIXEL
	@ 07,06  Say OemToAnsi(cTipoDesc+ " No.") OF oDlg PIXEL
	@ 07,130 Say OemToAnsi("Emissao ") OF oDlg SIZE 50,9 PIXEL
	If cTipoDoc $ "TP"
		@ 19,06  Say OemToAnsi("Fornecedor ") OF oDlg PIXEL
	Endif
	@ 31,06  Say OemToAnsi("Aprovador ") OF oDlg PIXEL SIZE 30,9
	@ 31,130 Say OemToAnsi("Data de ref.  ") SIZE 60,9 OF oDlg PIXEL
	@ 53,06  Say OemToAnsi("Limite min.  ") +CRoeda OF oDlg PIXEL
	@ 53,113 Say OemToAnsi("Limite max. ")+CRoeda SIZE 60,9 OF oDlg PIXEL
	@ 65,06  Say OemToAnsi("Limite  ")+CRoeda  OF oDlg PIXEL
	@ 65,113 Say OemToAnsi("Tipo lim.") OF oDlg PIXEL
	@ 77,06  Say OemToAnsi("Saldo na data  ")+CRoeda OF oDlg PIXEL
	If lAprov .Or. SCR->CR_MOEDA == aRetSaldo[2]
		@ 89,06 Say OemToAnsi("Total do documento ")+CRoeda OF oDlg PIXEL
	Else
		@ 89,06 Say OemToAnsi("Total do documento, convertido em ")+CRoeda OF oDlg PIXEL
	EndIf
	@ 101,06 Say OemToAnsi("Saldo disponivel apos liberacao  ") +CRoeda SIZE 130,10 OF oDlg PIXEL
	@ 113,06 Say OemToAnsi("Observa‡äes ") SIZE 100,10 OF oDlg PIXEL
	
	If cTipoDoc $ "TP"
		@ 07,58  MSGET SUBSTR(SCR->CR_NUM,4,9)  When .F. SIZE 28 ,9 OF oDlg PIXEL
	EndIf
	
	@ 07,155 MSGET SCR->CR_EMISSAO When .F. SIZE 45 ,9 OF oDlg PIXEL
	If cTipoDoc $ "TP"
		@ 19,45  MSGET SA2->A2_NOME    When .F. SIZE 155,9 OF oDlg PIXEL
	Endif
	@ 31,45  MSGET cName           When .F. SIZE 50 ,9 OF oDlg PIXEL
	@ 31,155 MSGET oDataRef VAR dRefer When .F. SIZE 45 ,9 OF oDlg PIXEL
	@ 53,42  MSGET SAK->AK_LIMMIN Picture PesqPict('SAK','AK_LIMMIN')When .F. SIZE 60,9 OF oDlg PIXEL RIGHT
	@ 53,141 MSGET SAK->AK_LIMMAX Picture PesqPict('SAK','AK_LIMMAX')When .F. SIZE 59,1 OF oDlg PIXEL RIGHT
	@ 65,42  MSGET SAK->AK_LIMITE Picture PesqPict('SAK','AK_LIMITE')When .F. SIZE 60,9 OF oDlg PIXEL RIGHT
	@ 65,141 MSGET cTipoLim When .F. SIZE 59,9 OF oDlg PIXEL CENTERED
	@ 77,115 MSGET oSaldo VAR nSaldo Picture "@E 999,999,999,999.99" When .F. SIZE 85,14 OF oDlg PIXEL RIGHT
	If lAprov
		@ 89,115 MSGET cAprov Picture "@!" When .F. SIZE 85,9 OF oDlg PIXEL RIGHT
	Else
		@ 89,115 MSGET nTotal Picture "@E 999,999,999,999.99" When .F. SIZE 85,9 OF oDlg PIXEL RIGHT
	EndIf
	@ 101,115 MSGET oSaldif VAR nSalDif Picture "@E 999,999,999,999.99" When .F. SIZE 85,9 OF oDlg PIXEL RIGHT
	@ 113,115 MSGET cObs Picture "@!" SIZE 85,9 OF oDlg PIXEL
	
	If ExistBlock("MT097DTR")
		lShowBut := IIf(Valtype(lShowBut:=ExecBlock("MT097DTR",.F.,.F.,{SCR->CR_TIPO}))=='L',lShowBut,.T.)
	Endif
	
	If lShowBut
		@ 132, 39 BUTTON OemToAnsi("Data de Ref.") SIZE 40 ,11  FONT oDlg:oFont ACTION A097Data(oDataRef,oSaldo,oSalDif,@dRefer,aRetSaldo,@cCodLiber,@nSaldo,@cRoeda,@cName,@ca097User,@nTotal,@nSalDif,lAprov) OF oDlg PIXEL
	Endif
	
	@ 132, 80 BUTTON OemToAnsi("Libera Docto") SIZE 40 ,11  FONT oDlg:oFont ACTION If(A097ValObs(cObs),(nOpc:=2,oDlg:End()),Nil)  OF oDlg PIXEL
	@ 132,121 BUTTON OemToAnsi("Cancelar") SIZE 40 ,11  FONT oDlg:oFont ACTION (nOpc:=1,oDlg:End())  OF oDlg PIXEL
	@ 132,162 BUTTON OemToAnsi("Bloqueia Docto") SIZE 40 ,11  FONT oDlg:oFont ACTION (nOpc:=3,oDlg:End())  OF oDlg PIXEL
	
	ACTIVATE MSDIALOG oDlg CENTERED
	
	If nOpc == 2 .Or. nOpc == 3
		SCR->(dbClearFilter())
		SCR->(dbGoTo(nReg))
		
		If cTipoDoc = "TP"
			lLibOk := AV097Lock(Substr(SCR->CR_NUM,1,Len(SE2->(E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA ))),SCR->CR_TIPO)
		EndIf
		
		If lLibOk
			Begin Transaction
			lLiberou := MaAlcDoc({SCR->CR_NUM,SCR->CR_TIPO,nTotal,cCodLiber,,cGrupo,,,,,cObs},dRefer,If(nOpc==2,4,6))
			
			If lLiberou .or. nOpc = 3
				
				If	cTipoDoc = "TP"
					dbSelectArea("SE2")
					Reclock("SE2",.F.)
					SE2->E2_DATALIB := dDataBase
					SE2->E2_USUALIB := UsrRetName(SCR->CR_USER)
					SE2->E2_X_WF      := ' '
					MsUnlock()
				Endif
			Endif
			
			End Transaction
			
		Else
			Help(" ",1,"A097LOCK")
		Endif
	EndIf
	dbSelectArea("SCR")
	dbSetOrder(1)
	
	SCR->(Eval(bFilSCRBrw))
	
EndIf
RestArea(aArea)
Return .F. // retorna .F. para que no retorno para a MATA097 a variavel lContinua volte como F. e nao entre no bloco de processamento padrao

/*
===========================================================================================
Programa.: 	AV097VIS
Autor....:	Pedro Augusto
Data.....: 	mai/2014
Descricao: 	Rotina que fará VISUALIZACAO de documentos nao contemplados na MATA097
Uso......: 	AVANT
===========================================================================================
*/
Static Function AV097Vis(cTipoDoc)

Local cSavAlias  := Alias()
Local cSavOrd    := IndexOrd()
Local cSavReg    := RecNo()

If	cTipoDoc == "TP"
	dbSelectArea("SE2")
	dbSetOrder(1)
	If MsSeek(xFilial("SE2")+Substr(SCR->CR_NUM,1,len(SE2->(E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA ))))
		FA280Visua("SE2",Recno(),2)
	EndIf
EndIf

Pergunte("MTA097",.F.)
dbSelectArea(cSavAlias)
dbSetOrder(cSavOrd)
dbGoto(cSavReg)

Return(.T.)


/*
===========================================================================================
Programa.: 	AV097Lock
Autor....:	Pedro Augusto
Data.....: 	31/07/2013 º±±
Descricao: 	Verifica se o documento nao contemplado na MATA097 nao está com lock
Uso......: 	AVANT
===========================================================================================
*/
Static Function AV097Lock(cNumero,cTipo)
Local aArea    := {}
Local lRet     := .F.
If cTipo == "TP"
	aArea := SE2->(GetArea())
	dbSelectArea("SE2")
	dbSetOrder(1)
	If MsSeek(xFilial("SE2")+cNumero)
		While !Eof() .And. SE2->(E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA) == xFilial("SE2")+alltrim(cNumero)
			If RecLock("SE2")
				lRet := .T.
			Else
				lRet := .F.
				Exit
			Endif
			dbSkip()
		EndDo
	EndIf
Endif

RestArea(aArea)

Return(lRet)
