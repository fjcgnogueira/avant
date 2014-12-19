#include "TOTVS.ch"
#include "TbiConn.ch"
#include "TbiCode.ch"
#include "TopConn.ch"

/*----------------------+--------------------------------+------------------+
|   Programa: MATXWKFL  | Autor: Kley@TOTVS              | Data: Abril/2014 |
+-----------------------+--------------------------------+------------------+
|  Descricao:  Funções genéricas do Workflow                                |
+--------------------------------------------------------------------------*/

User Function WFCOM1
U_ProcWkF({"01","010104",1})		// PC A APROVAR E PC COM APROVADOR SEM SALDO PARA APROVACAO
//U_ProcWkF()		// PC A APROVAR E PC COM APROVADOR SEM SALDO PARA APROVACAO
U_ProcWkF({"01","010104",3})		// Envia Notif REPROVADOS
//U_ProcWkF({"01","010104"})		// Envia Notif REPROVADOS
U_ProcWkF({"01","010104",5})		// Envia Notif APROVADOS
Return

User Function WFENVEML	// Envia e-mails da Caixa de Saída do Workflow
Local cCodEmp := "01"
ConOut("["+DtoC(Date()) + ' ' + Time()+"] [U_WFENVEML] Enviando e-mails da caixa de saída. Empresa " + cCodEmp)
WfSendMail({cCodEmp,"010104"})
Return

/*----------------------+--------------------------------+------------------+
|   Programa: ProcWkF   | Autor: Kley@TOTVS              | Data: 28/04/2014 |
+-----------------------+--------------------------------+------------------+
|  Descricao: Prepara o ambiente e executa a função passada como parâmetro
|				em todas as filiais da Empresa informada.
+---------------------------------------------------------------------------+
|    Projeto:  AVANT
+---------------------------------------------------------------------------+
|    Sintaxe:  U_ProcWkF(aParam)
|				 <ExpA1[1]><C> = Código da Empresa
|				 <ExpA1[2]><C> = Código da Filial - Pode ser a 1a. Filial da Empresa
|				 <ExpA1[3]><N> = Número da Opção da Execução a ser passado para a rotina
+----------------------------------------------------------------------------
|    Retorno:  Nulo                                                               
+--------------------------------------------------------------------------*/

User Function ProcWkF(aParam)

Local aEmpFil  := {} 
Local nScan    := 0
Local nX       := 0
Local cFunc		:= "U_ProcWkF"

/*----------------------------------------------------------------+
|  Teste o recebimento dos parametros.                            |                                            
+----------------------------------------------------------------*/
If Empty(aParam) //Type("aParam") # "A"
	U_Console("Parametro nao recebido: ARRAY (cEmp<C>/cFil<C>/nOpc<N>). Abortado!",cFunc)
	Return
ElseIf Len(aParam) # 3 .or. ValType(aParam) # "A"
	U_Console("O parametro recebido nao possui 3 elementos - ARRAY (cEmp<C>/cFil<C>/nOpc<N>). Abortado!",cFunc)
	//U_Console("Tipo: " + Type("aParam"),cFunc)
	Return
ElseIf ValType(aParam[1]) # "C" .or. ValType(aParam[2]) # "C" .or. ValType(aParam[3]) # "N"
	U_Console("Tipo do Conteudo do Parametro incorreto - ARRAY (cEmp<C>/cFil<C>/nOpc<N>). Abortado!",cFunc)
	//U_Console("Tipo: " + Type("aParam"),cFunc)
	Return
Else
	//ConOut("["+DtoC(Date()) + ' ' + Time()+"] [U_ProcWkF] Parametros recebidos. Emp/Fil/Opcao: " + aParam[1] + "/" + aParam[2] + "/"+ LTrim(Str(aParam[3])) )
	U_Console("Parametros recebidos. Emp/Fil/Opcao: " + aParam[1] + "/" + aParam[2] + "/"+ LTrim(Str(aParam[3])),cFunc)
EndIf

/*----------------------------------------------------------------+
|  Inicia o Ambiente                                              |                                            
+----------------------------------------------------------------*/
RPCSetType(3)
RpcSetEnv(aParam[1],aParam[2],,,"CFG","U_ProcWkF",{"SM0"},,,,)
SM0->(DbSetOrder(1), DBSeek(aParam[1],.F.), DbGoTop())
While !SM0->(Eof()) .and. SM0->M0_CODIGO == aParam[1]
	If (nScan := aScan(aEmpFil, {|z| z[1] == SM0->M0_CODIGO})) == 0
		aAdd(aEmpFil,{SM0->M0_CODIGO,SM0->M0_CODFIL})
	Endif
	SM0->(DbSkip())
End
RpcClearEnv() 										//Limpa o ambiente, libera licenças e fecha conexões

If Len(aEmpFil) > 0
	//ConOut("["+DtoC(Date()) + ' ' + Time()+"] [U_ProcWkF] " + LTrim(Str(aParam[3])) + " - Encontradas " + LTrim(Str(Len(aEmpFil))) + " filial(is) para processamento." )
	U_Console(LTrim(Str(aParam[3])) + " - Encontradas " + LTrim(Str(Len(aEmpFil))) + " filial(is) para processamento.",cFunc)
Else
	//ConOut("["+DtoC(Date()) + ' ' + Time()+"] [U_ProcWkF] " + LTrim(Str(aParam[3])) + " - Possível erro na leitura do SIGAMAT.EMP. Verificar.")
	U_Console(LTrim(Str(aParam[3])) + " - Possível erro na leitura do SIGAMAT.EMP. Verificar.",cFunc)
EndIf

&&*********************** P A R E I   A Q U I   1 6 / 0 7 / 2 0 1 4 *********************** 

For nX := 1 to Len(aEmpFil)
	//WfPrepEnv( aEmpFil[nX][1], aEmpFil[nX][2] )
	WfPrepEnv( aParam[1], aParam[2] )
	U_Console(LTrim(Str(aParam[3])) + " - Ambiente inicializado -> Emp/Fil: " + aParam[1] + "/" + aParam[2],"U_ProcWkF")
	U_AVCOMW10(aParam[3])	// PROCESSO WORKFLOW PEDIDO DE COMPRAS
	//ExecBlock("Teste123Kley",.F.,.F.,"**Param passado para função**")
	Reset Environment
Next nX

RETURN

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ MAAlcDoc ³Autor  ³ Aline Correa do Vale  ³ Data ³Jun/2007  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Controla a alcada dos documentos (SCS-Saldos/SCR-Bloqueios)³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ WFAlcDoc(ExpA1,ExpD1,ExpN1,ExpC1)                     	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpA1 = Array com informacoes do documento                 ³±±
±±³          ³       [1] Numero do documento                              ³±±
±±³          ³       [2] Tipo de Documento                                ³±±
±±³          ³       [3] Valor do Documento                               ³±±
±±³          ³       [4] Codigo do Aprovador                              ³±±
±±³          ³       [5] Codigo do Usuario                                ³±±
±±³          ³       [6] Grupo do Aprovador                               ³±±
±±³          ³       [7] Aprovador Superior                               ³±±
±±³          ³       [8] Moeda do Documento                               ³±±
±±³          ³       [9] Taxa da Moeda                                    ³±±
±±³          ³      [10] Data de Emissao do Documento                     ³±±
±±³          ³      [11] Grupo de Compras                                 ³±±
±±³          ³ ExpD1 = Data de referencia para o saldo                    ³±±
±±³          ³ ExpN1 = Operacao a ser executada                           ³±±
±±³          ³       1 = Inclusao do documento                            ³±±
±±³          ³       2 = Estorno do documento                             ³±±
±±³          ³       3 = Exclusao do documento                            ³±±
±±³          ³       4 = Aprovacao do documento                           ³±±
±±³          ³       5 = Estorno da Aprovacao                             ³±±
±±³          ³       6 = Bloqueio Manual da Aprovacao                     ³±±
±±³          ³ ExpC1 = Respondido a 1 Vez ou a 2						  ³±±
±±³          ³ ExpB1 = Chamado via Menu do Sistema .T. or .F.             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MAAlcDoc(aDocto,dDataRef,nOper, cWF, lMENU)
Local cDocto		:= aDocto[1]
Local cTipoDoc	:= aDocto[2]
Local nValDcto	:= aDocto[3]
Local cAprov		:= If(aDocto[4]==Nil,"",aDocto[4])
Local cUsuario	:= If(aDocto[5]==Nil,"",aDocto[5])
Local nMoeDcto	:= If(Len(aDocto)>7,If(aDocto[8]==Nil, 1,aDocto[8]),1)
Local nTxMoeda	:= If(Len(aDocto)>8,If(aDocto[9]==Nil, 0,aDocto[9]),0)
Local aArea		:= GetArea()
Local aAreaSCS  	:= SCS->(GetArea())
Local aAreaSCR  	:= SCR->(GetArea())
Local nSaldo		:= 0
Local cGrupo		:= If(aDocto[6]==Nil,"",aDocto[6])
Local lFirstNiv	:= .T.
Local cAuxNivel	:= ""
Local cNextNiv 	:= ""
Local lAchou		:= .F.
Local nRec			:= 0
Local lRetorno	:= .T.
Local aSaldo		:= {}
Local cNivIgual	:= ""
Local cStatusAnt	:= ""
Local lAchou		:= .F.

dDataRef	:= dDataBase
cDocto		:= cDocto+Space(Len(SCR->CR_NUM)-Len(cDocto))
cWF			:= IIF(cWF==Nil, "", cWF)
lMENU		:= IIF(lMENU==Nil, .F., lMENU)  // SE .T. UTILIZADA VIA MENU DO SISTEMA

IF !lMENU
	CHKFile("SAK")
	CHKFile("SC7")
	CHKFile("SCR")
	CHKFile("SCS")
	CHKFile("SAL")
ENDIF

If Empty(cUsuario) .And. (nOper != 1 .And. nOper != 6) //nao e inclusao ou estorno de liberacao
	dbSelectArea("SAK")
	dbSetOrder(1)
	dbSeek(xFilial()+cAprov)
	cUsuario := AK_USER
	nMoeDcto := AK_MOEDA
	nTxMoeda := 0
EndIf

If nOper == 1  //Inclusao do Documento
	U_Console("U_MaAlcDoc:: Processando Alcada de Docto ==> 1 - Inclusao do Documento")
	cGrupo := If(!Empty(aDocto[6]),aDocto[6],cGrupo)
	dbSelectArea("SAL")
	dbSetOrder(2)
	If !Empty(cGrupo) .And. dbSeek(xFilial()+cGrupo)
		While !Eof() .And. xFilial("SAL")+cGrupo == AL_FILIAL+AL_COD
			If SAL->AL_AUTOLIM == "S" .And. !MaAlcLim(SAL->AL_APROV,nValDcto,nMoeDcto,nTxMoeda) .AND. !EMPTY(cWF)
				dbSelectArea("SAL")
				dbSkip()
				Loop
			EndIf
			If lFirstNiv
				cAuxNivel := SAL->AL_NIVEL
				lFirstNiv := .F.
			EndIf
			Reclock("SCR",.T.)
			SCR->CR_FILIAL  := xFilial("SCR")
			SCR->CR_NUM	  := cDocto
			SCR->CR_TIPO	  := cTipoDoc
			SCR->CR_NIVEL	  := SAL->AL_NIVEL
			SCR->CR_USER	  := SAL->AL_USER
			SCR->CR_APROV	  := SAL->AL_APROV
			SCR->CR_STATUS  := IIF(SAL->AL_NIVEL == cAuxNivel,"02","01")
			SCR->CR_TOTAL	  := nValDcto
			SCR->CR_EMISSAO := aDocto[10]
			SCR->CR_MOEDA	  :=	nMoeDcto
			SCR->CR_TXMOEDA := nTxMoeda
			MsUnlock()
			dbSelectArea("SAL")
			dbSkip()
		EndDo
	EndIf
	lRetorno := lFirstNiv
EndIf

If nOper == 2  //Transferencia da Alcada para o Superior
	U_Console("U_MaAlcDoc:: Processando Alcada de Docto ==> 2 - Transferencia para o Superior")

	SAK->( DbSetOrder(1), DbSeek(xFilial('SAK')+cAprov) )
	// O SCR deve estar posicionado, para que seja transferido o atual para o Superior
	If !SCR->(Eof()) .And. SCR->CR_FILIAL+SCR->CR_TIPO+SCR->CR_NUM == xFilial("SCR")+cTipoDoc+cDocto
		// Carrega dados do Registro a ser tranferido e exclui
		cTipoDoc := SCR->CR_TIPO
		cAuxNivel:= SCR->CR_STATUS
		nValDcto := SCR->CR_TOTAL
		cUsuario := SAK->AK_USER
		nMoeDcto := SAK->AK_MOEDA
		cNextNiv := SCR->CR_NIVEL
		nTxMoeda := SCR->CR_TXMOEDA
		dDataRef := SCR->CR_EMISSAO
		Reclock("SCR",.F.,.T.)
		dbDelete()
		MsUnlock()
		// Inclui Registro para Aprovador Superior
		SAK->( DbSeek(xFilial('SAK')+SAK->AK_APROSUP) )
		Reclock("SCR",.T.)
		SCR->CR_FILIAL  := xFilial("SCR")
		SCR->CR_NUM	  := cDocto
		SCR->CR_TIPO	  := cTipoDoc
		SCR->CR_NIVEL	  := cNextNiv
		SCR->CR_USER	  := SAK->AK_USER
		SCR->CR_APROV	  := SAK->AK_COD
		SCR->CR_STATUS  := cAuxNivel
		SCR->CR_TOTAL	  := nValDcto
		SCR->CR_EMISSAO := dDataRef
		SCR->CR_MOEDA	  :=	nMoeDcto
		SCR->CR_TXMOEDA := nTxMoeda
		If SCR->( FieldPos('CR_WFOBS') ) > 0
			CR_WFOBS	  := 'Transferido ao superior atraves do Workflow.'
		Else
			CR_OBS		  := 'Transf. superior p/ Workflow.'
		EndIf
		MsUnlock()
	EndIf
	lRetorno := .F.
EndIf

If nOper == 3  //exclusao do documento
	U_Console("U_MaAlcDoc:: Processando Alcada de Docto ==> 3 - Exclusao de Documento")

	dbSelectArea("SAK")
	dbSetOrder(1)
	dbSelectArea("SCR")
	dbSetOrder(1)
	dbSeek(xFilial("SCR")+cTipoDoc+cDocto)
	While !Eof() .And. SCR->CR_FILIAL+SCR->CR_TIPO+SCR->CR_NUM == xFilial("SCR")+cTipoDoc+cDocto
		If SCR->CR_STATUS == "03"
			dbSelectArea("SAL")
			dbSetOrder(3)
			dbSeek(xFilial()+cGrupo+SAK->AK_COD)
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Reposiciona o usuario aprovador.               ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			dbSelectArea("SAK")
			dbSeek(xFilial()+SCR->CR_LIBAPRO)
			If SAL->AL_LIBAPR == "A" .and. MaAlcLim(SAL->AL_APROV,nValDcto,nMoeDcto,nTxMoeda) .and. Empty(cWF)
				dbSelectArea("SCS")
				dbSetOrder(2)
				If dbSeek(xFilial()+SAK->AK_COD+DTOS(MaAlcDtRef(SCR->CR_LIBAPRO,SCR->CR_DATALIB,SCR->CR_TIPOLIM)))
					RecLock("SCS",.F.)
					SCS->CS_SALDO := SCS->CS_SALDO + SCR->CR_VALLIB
					MsUnlock()
				EndIf
			EndIf
		EndIf
		
		// SE OPCAO FOR PELO MENU - EXECUTA KILLPROCESS PARA O WF
		IF !EMPTY(SCR->CR_X_WFID) .AND. lMENU
			WFKillProcess(SCR->CR_X_WFID)
		ENDIF
		
		Reclock("SCR",.F.,.T.)
		dbDelete()
		MsUnlock()
		dbSkip()
	EndDo
EndIf

If nOper == 4 //Aprovacao do documento
	U_Console("U_MaAlcDoc:: Processando Alcada de Docto ==> 4 - Aprovacao")

	dbSelectArea("SCS")
	dbSetOrder(2)
	aSaldo := MaSalAlc(cAprov,dDataRef,.T.)
	nSaldo 	:= aSaldo[1]
	dDataRef	:= aSaldo[3]
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Atualiza o saldo do aprovador.                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SAK")
	dbSetOrder(1)
	dbSeek(xFilial("SAK")+cAprov)
	dbSelectArea("SAL")
	dbSetOrder(3)
	dbSeek(xFilial("SAL")+cGrupo+cAprov)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Libera o pedido pelo aprovador.                     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SCR")
	cAuxNivel := CR_NIVEL
	Reclock("SCR",.F.)
	dbSetOrder(1)
	CR_STATUS	:= "03"
	If SCR->( FieldPos('CR_WFOBS') ) > 0
		CR_WFOBS	:= If(Len(aDocto)>10,aDocto[11],"")
	Else
		CR_OBS		:= If(Len(aDocto)>10,aDocto[11],"")
	EndIf
	CR_DATALIB	:= Date()
	CR_USERLIB	:= SAK->AK_USER
	CR_LIBAPRO	:= SAK->AK_COD
	CR_VALLIB	:= nValDcto
	CR_TIPOLIM	:= SAK->AK_TIPO
	MsUnlock()
	dbSeek(xFilial("SCR")+cTipoDoc+cDocto+cAuxNivel)
	nRec := RecNo()
	While !Eof() .And. xFilial("SCR")+cDocto+cTipoDoc == CR_FILIAL+CR_NUM+CR_TIPO
		If cAuxNivel == CR_NIVEL .And. CR_STATUS != "03" .And. SAL->AL_TPLIBER$"U "
			Exit
		EndIf
		If cAuxNivel == CR_NIVEL .And. CR_STATUS != "03" .And. SAL->AL_TPLIBER$"NP"
			Reclock("SCR",.F.)
			CR_STATUS	:= "05"
			CR_DATALIB	:= Date()
			CR_USERLIB	:= SAK->AK_USER
			CR_APROV		:= cAprov
			MsUnlock()
		EndIf
		If CR_NIVEL > cAuxNivel .And. CR_STATUS != "03" .And. !lAchou
			lAchou := .T.
			cNextNiv := CR_NIVEL
		EndIf
		If lAchou .And. CR_NIVEL == cNextNiv .And. CR_STATUS != "03"
			Reclock("SCR",.F.)
			CR_STATUS := If(SAL->AL_TPLIBER=="P","05",;
								If(( Empty(cNivIgual) .Or. cNivIgual == CR_NIVEL ) .And. cStatusAnt <> "01" ,"02",CR_STATUS))
			
			If CR_STATUS == "05"
				CR_DATALIB	:= Date()
			EndIf
			MsUnlock()
			cNivIgual := CR_NIVEL
			lAchou    := .F.
		Endif
		
		cStatusAnt := SCR->CR_STATUS
		
		dbSkip()
	EndDo
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Reposiciona e verifica se ja esta totalmente liberado.       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbGoto(nRec)
	While !Eof() .And. xFilial("SCR")+cTipoDoc+cDocto == CR_FILIAL+CR_TIPO+CR_NUM
		If CR_STATUS != "03" .And. CR_STATUS != "05"
			lRetorno := .F.
		EndIf
		dbSkip()
	EndDo
	If SAL->AL_LIBAPR == "A"
		dbSelectArea("SCS")
		If dbSeek(xFilial()+cAprov+dToS(dDataRef))
			Reclock("SCS",.F.)
		Else
			Reclock("SCS",.T.)
		EndIf
		CS_FILIAL:= xFilial("SCS")
		CS_SALDO	:= CS_SALDO - nValDcto
		CS_APROV	:= cAprov
		CS_USER	:= cUsuario
		CS_MOEDA	:= nMoeDcto
		CS_DATA	:= dDataRef
		MsUnlock()
	EndIf
	
EndIf

If nOper == 5  //Estorno da Aprovacao
U_Console("U_MaAlcDoc:: Processando Alcada de Docto ==> 5 - Estorno da Aprovacao")

	cGrupo := If(!Empty(aDocto[6]),aDocto[6],cGrupo)
	dbSelectArea("SAK")
	dbSetOrder(1)
	
	dbSelectArea("SCR")
	dbSetOrder(1)
	dbSeek(xFilial("SCR")+cTipoDoc+cDocto)
	
	nMoeDcto := SCR->CR_MOEDA
	nTxMoeda := SCR->CR_TXMOEDA
	
	While !Eof() .And. SCR->CR_FILIAL+SCR->CR_TIPO+SCR->CR_NUM == xFilial("SCR")+cTipoDoc+cDocto
		If SCR->CR_STATUS == "03"
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Reposiciona o usuario aprovador.               ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			dbSelectArea("SAK")
			dbSeek(xFilial()+SCR->CR_LIBAPRO)
			
			dbSelectArea("SAL")
			dbSetOrder(3)
			dbSeek(xFilial()+cGrupo+SAK->AK_COD)
			If SAL->AL_LIBAPR == "A" .and. MaAlcLim(SAL->AL_APROV,nValDcto,nMoeDcto,nTxMoeda) .and. Empty(cWF)
				dbSelectArea("SCS")
				dbSetOrder(2)
				If dbSeek(xFilial()+SAK->AK_COD+DTOS(MaAlcDtRef(SAK->AK_COD,SCR->CR_DATALIB)))
					RecLock("SCS",.F.)
					SCS->CS_SALDO := SCS->CS_SALDO + SCR->CR_VALLIB
					If SCS->CS_SALDO > SAK->AK_LIMITE
						SCS->CS_SALDO := SAK->AK_LIMITE
					EndIf
					MsUnlock()
				EndIf
			EndIf
		EndIf
		
		// SE OPCAO FOR PELO MENU - EXECUTA KILLPROCESS PARA O WF
		IF !EMPTY(SCR->CR_X_WFID) .AND. lMENU
			WFKillProcess(SCR->CR_X_WFID)
		ENDIF
		
		Reclock("SCR",.F.,.T.)
		dbDelete()
		MsUnlock()
		dbSkip()
	EndDo
	
	dbSelectArea("SAL")
	dbSetOrder(2)
	If !Empty(cGrupo) .And. dbSeek(xFilial()+cGrupo)
		While !Eof() .And. xFilial("SAL")+cGrupo == AL_FILIAL+AL_COD
			If SAL->AL_AUTOLIM == "S" .And. !MaAlcLim(SAL->AL_APROV,nValDcto,nMoeDcto,nTxMoeda) .AND. !Empty(cWF)
				dbSelectArea("SAL")
				dbSkip()
				Loop
			EndIf
			If lFirstNiv
				cAuxNivel := SAL->AL_NIVEL
				lFirstNiv := .F.
			EndIf
			Reclock("SCR",.T.)
			SCR->CR_FILIAL	:= xFilial("SCR")
			SCR->CR_NUM		:= cDocto
			SCR->CR_TIPO	:= cTipoDoc
			SCR->CR_NIVEL	:= SAL->AL_NIVEL
			SCR->CR_USER	:= SAL->AL_USER
			SCR->CR_APROV	:= SAL->AL_APROV
			SCR->CR_STATUS	:= IIF(SAL->AL_NIVEL == cAuxNivel,"02","01")
			SCR->CR_TOTAL	:= nValDcto
			SCR->CR_EMISSAO:= dDataRef
			SCR->CR_MOEDA	:=	nMoeDcto
			SCR->CR_TXMOEDA:= nTxMoeda
			MsUnlock()
			dbSelectArea("SAL")
			dbSkip()
		EndDo
	EndIf
	lRetorno := lFirstNiv
EndIf

If nOper == 6  //Bloqueio manual
	U_Console("U_MaAlcDoc:: Processando Alcada de Docto ==> 6 - Bloqueio Manual")

	dbSelectArea("SCR")
	cAuxNivel := CR_NIVEL
	
	// SE OPCAO FOR PELO MENU - EXECUTA KILLPROCESS PARA O WF
	IF !EMPTY(SCR->CR_X_WFID) .AND. lMENU
		WFKillProcess(SCR->CR_X_WFID)
	ENDIF
	
	U_Console("U_MaAlcDoc:: 6 - Bloqueio => 04 -STATUS")
	
	Reclock("SCR",.F.)
	CR_STATUS   := "04"
	If SCR->( FieldPos('CR_WFOBS') ) > 0
		CR_WFOBS    := If(Len(aDocto)>10,aDocto[11],"Reprovaçao manual")
	Else
		CR_OBS	    := If(Len(aDocto)>10,aDocto[11],"Reprovaçao manual")
	EndIf
	CR_DATALIB  := dDataBase
	CR_USERLIB	:= SAK->AK_USER
	CR_LIBAPRO	:= SAK->AK_COD
	MsUnlock()
	
	cNome		:= UsrRetName(SAK->AK_USER)
	
	dbSelectArea("SCR")
	dbSetOrder(1)
	dbSeek(xFilial("SCR")+cTipoDoc+cDocto+cAuxNivel)
	
	nRec := RecNo()
	While !Eof() .And. xFilial("SCR")+cDocto+cTipoDoc == CR_FILIAL+CR_NUM+CR_TIPO
		U_Console("U_MaAlcDoc:: 6 - Bloqueio => LOOP SCR - Fil/Num/Tipo/Nivel/Status: "+;
		          CR_FILIAL+"/"+RTrim(CR_NUM)+"/"+CR_TIPO+"/"+CR_NIVEL+"/"+CR_STATUS)
		
		If (cAuxNivel == CR_NIVEL .And. CR_STATUS != "04" )
			Reclock("SCR",.F.)
			CR_STATUS	:= "04"
			CR_DATALIB	:= dDataBase
			CR_USERLIB	:= SAK->AK_USER
			If SCR->( FieldPos('CR_WFOBS') ) > 0
				CR_WFOBS	:= "Reprovado por " + ALLTRIM(cNome)
			Else
				CR_OBS		:= "Reprovado por " + ALLTRIM(cNome)
			EndIf
			MsUnlock()
			
			// SE OPCAO FOR PELO MENU - EXECUTA KILLPROCESS PARA O WF
			IF !EMPTY(SCR->CR_X_WFID) .AND. lMENU
				WFKillProcess(SCR->CR_X_WFID)
			ENDIF
		EndIf
		dbSkip()
	EndDo
	
	lRetorno := .F.
EndIf

dbSelectArea("SCR")
RestArea(aAreaSCR)

dbSelectArea("SCS")
RestArea(aAreaSCS)
RestArea(aArea)

Return(lRetorno)

/*----------------------+--------------------------------+------------------+
|   Programa: CONSOLE   | Autor: Kley@TOTVS              | Data: Dez/2008   |
+-----------------------+--------------------------------+------------------+
|  Descricao: Grava as mensagens nos logs do Server e do Workflow
+---------------------------------------------------------------------------+
|    Sintaxe: U_CONSOLE(cTexto,cFunc)
+----------------------------------------------------------------------------
|    Retorno: Nulo                                                               
+--------------------------------------------------------------------------*/

User Function Console(cTexto,cFunc)

Local cEOL		:= Chr(13)+Chr(10)
Local nHdl2
Local aLogBody  := {}
Local nW		:= 0

Set Date To British

cFunc	:= Iif(Empty(cFunc),"","["+AllTrim(cFunc)+"] ")
cTexto	:= Iif(Empty(cTexto),"** Texto não recebido **",cTexto )
cTexto := "["+DtoC(Date()) + ' ' + Time()+"] " + cFunc + cTexto

ConOut(cTexto)

If Type("cEmpAnt") == "C"
	If !Empty(cEmpAnt)
		aLogBody := QuebrLin(cTexto,132)
		
		nHdl2 := FOpen("\workflow\emp"+cEmpAnt+"\wfconsole.log",2)
		Iif(nHdl2 > 0,,nHdl2:= MSFCreate("\workflow\emp"+cEmpAnt+"\wfconsole.log",0))
		FSeek(nHdl2,0,2)
		
		For nW := 1 to Len(aLogBody)
			If nW = 1
				FWrite(nHdl2,aLogBody[nW]+cEOL,Len(aLogBody[nW]+cEOL))
			//ElseIf nW > 1 .and. nW < Len(aLogBody)
			Else
				FWrite(nHdl2,Space(20)+aLogBody[nW]+cEOL,Len(Space(20)+aLogBody[nW]+cEOL))
			//Else
			//	FWrite(nHdl2,Space(20)+aLogBody[nW],Len(Space(20)+aLogBody[nW]))
			EndIf
		Next nW
		
		//FWrite(nHdl2,cEOL,Len(cEOL))		// Salta uma linha
		FClose(nHdl2)
	EndIf
EndIf

Return

/*----------------------+--------------------------------+------------------+
|   Programa: QuebrLin  | Autor: Kley@TOTVS              | Data: Jul/2008   |
+-----------------------+--------------------------------+------------------+
|  Descricao: Quebra um string em uma ou varias linhas de acordo com o
|				tamanho da linha especificado, e retorna um array com as linhas.
|				Parametros recebidos:
|					cTexto  ==> String contendo o texto ou mensagem
|					nTamLin ==> Tamanho maximo de cada linha
|				Parametros devolvidos:
|					aLinha  ==> Array com as linhas contendo o texto.
+---------------------------------------------------------------------------+
|    Sintaxe: QuebrLin(cTexto,nTamLin)
+----------------------------------------------------------------------------
|    Retorno: Array com as linhas de texto                                                               
+--------------------------------------------------------------------------*/

Static Function QuebrLin(cTexto,nTamLin)

Local aLinha	:= {}
Local nPosIni	:= 1
Local nCaracLin	:= 0
Local aCaracQbra:= {" ",".",",","-",")",":","/"}
Local nCaracQbra:= 0
Local nN		:= 0

cTexto	:= AllTrim(cTexto)

Do While Len(cTexto) - nPosIni >= 0

	If Len(cTexto) - (nPosIni - 1) <= nTamLin	// Processa ultima linha
		nCaracLin	:= nTamLin
	Else
		nCaracLin := 0
		For nN := 1 to Len(aCaracQbra)
			nCaracQbra	:= RAt(aCaracQbra[nN],Substr(cTexto,nPosIni,nTamLin))	// Encontra o ultimo caracter de quebra
			If nCaracLin < nCaracQbra
				nCaracLin := nCaracQbra
			EndIf		
		Next nN
	EndIf
	
	aAdd(aLinha, Substr(cTexto,nPosIni,nCaracLin))			// Adiciona o trecho ao Array
	
	nPosIni += nCaracLin

EndDo

Return(aLinha)

/*----------------------+--------------------------------+------------------+
|   Programa: MontaView | Autor: TOTVS                   | Data: Mai/2007   |
+-----------------------+--------------------------------+------------------+
|  Descricao: Esta funcao cria a area de trabalho e faz a contagem de registros.
| Parametros: <ExpC1> Instrucao que sera montada a query.
|             <ExpC2> Alias para uso no programa da area de trabalho.
+---------------------------------------------------------------------------+
|    Sintaxe: U_MontaView(cSql,cAliasTRB)
+----------------------------------------------------------------------------
|    Retorno: <ExpN1> : Nro de Registros no arquivo de trabalho.                                                               
+--------------------------------------------------------------------------*/

User Function MontaView( cSql, cAliasTRB )

Local nCnt := 0
Local cSql := ChangeQuery( cSql )

If Select(cAliasTRB) > 0           // Verificar se o Alias ja esta aberto.
	DbSelectArea(cAliasTRB)        // Se estiver, devera ser fechado.
	DbCloseArea(cAliasTRB)
EndIf

DbUseArea( .T., "TOPCONN", TcGenQry(,,cSql), cAliasTRB, .T., .F. )
DbSelectArea(cAliasTRB)
DbGoTop()

DbEval( {|| nCnt++ })              // Conta quantos sao os registros retornados pelo Select.

Return( nCnt )

/*----------------------+--------------------------------+------------------+
|   Programa: EnviaLink | Autor: TOTVS                   | Data: Jun/2007   |
+-----------------------+--------------------------------+------------------+
|  Descricao: Envia um link com o processo de workflow a ser respondido.
+---------------------------------------------------------------------------+
|    Sintaxe: U_EnviaLink(cHtmlFile,cOldTo,cOldCC,cOldBCC,cSubject, pcFilial, pcTipo, pcNumDoc, cDescProc, cNomAprov )
+----------------------------------------------------------------------------
|    Retorno: Nulo                                                               
+--------------------------------------------------------------------------*/


User Function EnviaLink(cHtmlFile,cOldTo,cOldCC,cOldBCC,cSubject, pcFilial, pcTipo, pcNumDoc, cDescProc, cNomAprov )

Local oP
//Local cWFDHTTP := GetMV("MV_WFDHTTP")
Local cWFDHTTP := GetNewPar("MV_WFDHTTP", "http://nomedoservidor:8080/wf/")

If Right(RTrim(cWFDHTTP),1) # "/"
	cWFDHTTP := RTrim(cWFDHTTP) + "/"
EndIf

oP := TWFProcess():New( "000010", "Link de Processos de Workflow" )
oP:NewTask("Link de Processos Workflow", "\workflow\WFLink.htm")

oP:ohtml:valbyname("cLinkWkf", cWFDHTTP+cHtmlFile )
oP:ohtml:valbyname("cNomeProcesso", cSubject)
oP:ohtml:valbyname("DESCPROC", cDescProc )
oP:ohtml:valbyname("cNomAprov", cNomAprov )

oP:cTo      := cOldTo
oP:cCC      := cOldCC
oP:cBCC     := cOldBCC
oP:csubject := cSubject

oP:start()

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³EnviaNotifºAutor  ³ Kley Goncalves     º Data ³  Dez/2008   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Envia Notificacoes por e-mail.                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³ U_EnvNotif( <ExpC1>, <ExpC2>, <ExpC3>, <ExpC4>, <ExpC5> )  º±±
±±º Sintaxe  ³                                                            º±±
±±º          ³ 1. Linha do Assunto do E-mail;                             º±±
±±º          ³ 2. Titulo da Notitifacao;                                  º±±
±±º          ³ 3. Descricao Detalhada da Notificacao;                     º±±
±±º          ³ 4. Codigo do Usuario ou E-mail que sera enviada a notif.;  º±±
±±º          ³ 5. Caminho e nome do arquivo a ser anexado.                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Business Intelligence                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function EnviaNotif( cSubject, cTitle, cBody, cTo, cFile)

Local nLineSize := 90, nTabSize  := 2
Local lWrap     := .F.
Local cTexto    := "", cID

If '@' $ cTo
	oProcess:cTo   	:= cTo
ElseIf UsrRetMail(cTo) # Nil
	oProcess:cTo    := UsrRetMail(cTo)
Else 
	U_Console("U_EnviaNotif:: Tentativa de envio de notificacao falhou!"+;
	          " O destinatario do e-mail nao foi informado corretamente." )
	Return .F.
EndIf

If cSubject == Nil
	cSubject := "Notificacao Workflow Protheus"
EndIf

IF cTitle == Nil
	cTitle := ""
EndIf

IF cBody == Nil
	cBody := ""
EndIf

IF cFile == Nil
	cFile := ""
EndIf

oProcess          	:= TWFProcess():New( "000001", "Notificacao Avulsa" )
oProcess          	:NewTask( "Notificacao Avulsa", "\workflow\WFNotif.htm" )
oProcess:cSubject 	:= cSubject

oProcess:UserSiga	:= '000000'  // Fixo Administrador
oProcess:NewVersion(.T.)
oHtml     			:= oProcess:oHTML
oHtml:ValByName( "REFERENTE", cTitle)

nLines := MlCount(cBody, nLineSize, nTabSize, lWrap)

For nCurrLine := 1 To nLines
	cTexto += "<p><font color='#0000FF'>"+MemoLine(cBody, nLineSize, nCurrLine, nTabSize, lWrap)+"</font></p>"
Next

oHtml:ValByName( "DESCRICAO", cTexto)

If Len(AllTrim(cFile)) # 0
	oProcess:AttachFile(Upper(cFile))
EndIf        

cID := oProcess:fProcessId

oProcess:Start()

Return(cID)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³ BuscaPrc ºAutor  ³ Microsiga          º Data ³  Jun/2008   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Devolve uma matriz com os 3 ultimos precos do produto passaº±±
±±º          ³ do no parametro na ordem do mais velho p/ mais novo.       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Generico                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function BuscaPrc( pcFilial, pcProduto )

Local aPrecos    := { 0,0,0 }
Local cSelect    := ""
Local cNextAlias := GetNextAlias()
Local nI         := 0

cSelect := " SELECT TOP 3 D1_COD, D1_VUNIT, R_E_C_N_O_ "
cSelect += " FROM "+RetSqlName('SD1')
cSelect += " WHERE  D1_FILIAL = '"+pcFilial+"' "
cSelect += " AND    D1_TIPO = 'N' "
cSelect += " AND    D1_COD = '"+pcProduto+"' "
cSelect += " AND    D_E_L_E_T_ = ' ' "
cSelect += " ORDER BY R_E_C_N_O_ DESC " // Pegar os "N" ultimos, ordenar do maior para o menor

U_MontaView( cSelect, cNextAlias )

(cNextAlias)->( DbGoTop() )

Do While !(cNextAlias)->(Eof())
	nI ++
	aPrecos[nI] := (cNextAlias)->D1_VUNIT
	(cNextAlias)->( DbSkip() )
EndDo

/*
If !(cNextAlias)->(Eof())                  // Antepenultimo preco (3o)
	aPrecos[1] := (cNextAlias)->D1_VUNIT
EndIf

(cNextAlias)->( DbSkip() )                 // Penultimo preco (2o)
If !(cNextAlias)->(Eof())
	aPrecos[2] := (cNextAlias)->D1_VUNIT
EndIf

(cNextAlias)->( DbSkip() )
If !(cNextAlias)->(Eof())                 // Ultimo preco
	aPrecos[3] := (cNextAlias)->D1_VUNIT
EndIf
*/

Return( aPrecos )

/*-----------------------+-------------------------------+------------------+
|   Programa: WFEnvPCFor | Autor: Kley@TOTVS             | Data: 11/12/2013 |
+------------------------+-------------------------------+------------------+
|  Descricao:  Dialog para envio do Pedido de Compra para o Fornecedor por e-mail
+---------------------------------------------------------------------------+
|    Projeto:  AVANT
+---------------------------------------------------------------------------+
| Parâmetros:  cNum = Número do Pedido de Compra
+----------------------------------------------------------------------------
|    Exemplo:  U_WFEnvPCFor(SC7->C7_NUM)
+----------------------------------------------------------------------------
|    Retorno:  Nulo                                                               
+--------------------------------------------------------------------------*/

User Function WFEnvPCFor(cNumPC)

Local aArea	  := GetArea()
Local aAreaSC7  := SC7->(GetArea())
Local oDlg      := Nil
Local nOpca     := 0
Local cMailCC	  := Space(120)
Local lSemEmail :=.F.

SC7->(DbSeek(xFilial("SC7") + cNumPC))

If !(SC7->C7_CONAPRO == "L" )
	MsgStop("O Pedido não está liberado e não pode ser enviado para fornecedor.","Envio não permitido")
	SC7->(RestArea(aAreaSC7))
	RestArea(aArea)
	Return
Endif	

SA2->(DbSetOrder(1),DbSeek(xFilial("SA2")+SC7->C7_FORNECE+SC7->C7_LOJA))

If Empty(SA2->A2_EMAIL)
	MsgAlert('O Fornecedor não possui e-mail cadastrado. Por favor, verifique o cadastro.'+Chr(13)+Chr(10)+Chr(13)+Chr(10)+;
			'Informe um endereço de e-mail alternativo em "Enviar cópia do e-mail para" para que o PC seja enviado.',;
			'Fornecedor sem e-mail cadastrado')
	lSemEmail := .T.
Endif

DEFINE MSDIALOG oDlg TITLE "Envio de e-mail para Fornecedor" FROM 0,0 TO 300,552 OF oDlg PIXEL

@ 06,06 TO 68,271 LABEL "Informações para envio do e-mail" OF oDlg PIXEL

@ 15, 15 SAY "Fornecedor" 					     SIZE  45, 8 PIXEL OF oDlg
@ 25, 15 MSGET (RTrim(SA2->A2_COD)+"/"+RTrim(SA2->A2_LOJA)+" - "+RTrim(SA2->A2_NOME)) WHEN .F. SIZE 246,10 PIXEL OF oDlg
@ 40, 15 SAY "E-mail"                          SIZE  60, 8 PIXEL OF oDlg
@ 50, 15 MSGET RTrim(SA2->A2_EMAIL) WHEN .F.   SIZE 144,10 PIXEL OF oDlg
@ 40,164 SAY "Contato"   					   	  SIZE  60, 8 PIXEL OF oDlg
@ 50,164 MSGET RTrim(SA2->A2_CONTATO) WHEN .F. SIZE  97,10 PIXEL OF oDlg

@ 76,06 TO 116,271 LABEL "Informações para envio da cópia do e-mail" OF oDlg PIXEL

@ 85, 15 SAY "Enviar cópia do e-mail para" 	   SIZE  80, 8 PIXEL OF oDlg
@ 95, 15 MSGET cMailCC VALID ValidEmail(cMailCC) SIZE 246,10 PIXEL OF oDlg

@ 124,189 BUTTON "&Ok"       SIZE 36,16 PIXEL ACTION ( nOpca := 1, oDlg:End() )
@ 124,235 BUTTON "&Cancelar" SIZE 36,16 PIXEL ACTION ( nOpca := 0, oDlg:End() )

ACTIVATE MSDIALOG oDlg CENTER

If nOpca == 0
	Return
EndIf

If lSemEmail .and. Empty(cMailCC)

	MsgAlert('Nenhum endereço de e-mail foi fornecido.'+Chr(13)+Chr(10)+Chr(13)+Chr(10)+;
			 'O Fornecedor não possui e-mail cadastrado, e nenhum e-mail foi informado no campo "Enviar cópia do e-mail para".',;
			 'Nenhum E-mail foi fornecido')
	Return
EndIf

MsgRun("Processando o envio do e-mail para o fornecedor. Aguarde...","Envio do Pedido para Fornecedor",;
		{|| CursorWait(), U_AVCOMW10(6,cNumPC,,cMailCC),CursorArrow()})

SC7->(RestArea(aAreaSC7))
RestArea(aArea)

Return

/*-----------------------+-------------------------------+------------------+
|   Programa: ValidEmail | Autor: Kley@TOTVS             | Data: 11/12/2013 |
+------------------------+-------------------------------+------------------+
|  Descricao: Valida o e-mail.
| Parametros: <ExpC1> Instrucao que sera montada a query.
+---------------------------------------------------------------------------+
|    Sintaxe: ValidEmail(cEmail)
+----------------------------------------------------------------------------
|    Retorno: .T. = Válido / .F. = Inválido                                                               
+--------------------------------------------------------------------------*/

Static Function ValidEmail(cEmail)
Local lRet	:= .T.

If !Empty(cEmail)
	If "@" $ cEmail .and. "." $ cEmail .and. !(" " $ AllTrim(cEmail)) .and. Len(AllTrim(cEmail)) >= 5
		lRet	:= .T.
	Else
		MsgAlert("Formato de e-mail inválido.","E-mail inválido")
		lRet	:= .F.
	EndIf
EndIf
Return lRet


/*-----------------------+-------------------------------+------------------+
|   Programa: SM0Filiais | Autor: TOTVS                  | Data: Dez/2012   |
+------------------------+-------------------------------+------------------+
|  Descricao: Gera array com filiais do SIGAMAT
| Parametros: <ExpC1> Código da Filial
|             <ExpC2> Campo
+---------------------------------------------------------------------------+
|    Sintaxe: U_SM0Filiais(cFil, cField)
+----------------------------------------------------------------------------
|    Retorno: Conteúdo do campo                                                               
+--------------------------------------------------------------------------*/

User Function SM0Filiais(cFil, cField)

Static aFiliais := Nil
Static nPosFil  := Nil
Local aSavAre   := Nil
Local aStru     := Nil
Local nScan     := Nil
Local nField    := Nil
Local nLen      := Nil

Default cFil := cFilAnt
	
If aFiliais == Nil
	aSavAre  := SaveArea1({"SM0"})
	nPosFil  := SM0->(FieldPos("M0_CODFIL"))
	aStru    := SM0->(dbStruct())
	aFiliais := {}
	dbSelectArea("SM0")
	dbGoTop()
	Do While ! Eof()
		Aadd(aFiliais, {})
		aEval(aStru, {|z,w| Aadd(aTail(aFiliais), FieldGet(w))})
		dbSkip()
	Enddo
	RestArea1(aSavAre)
Endif

If Empty(cFil)
	cFil := cFilAnt
Endif

nLen  := Len(Alltrim(cFil))
nScan := aScan(aFiliais, {|z| Pad(z[nPosFil], nLen) == cFil})
nPos  := SM0->(FieldPos(Upper(Alltrim(cField))))
	
Return(aFiliais[nScan, nPos])
