#Include "Totvs.ch"
#Include "FwMvcDef.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � PedidoWeb � Autor � Fernando Nogueira  � Data � 19/09/2016 ���
�������������������������������������������������������������������������͹��
���Desc.     � Cadastro do Pedido Web no Protheus                         ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico Avant                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function PedidoWeb()

Private oBrowse := FwMBrowse():New()

//Alias do Browse
oBrowse:SetAlias('SZ3')

//Descri��o da Parte Superior Esquerda do Browse
oBrowse:SetDescripton("Pedido Web")

//Legendas do Browse
oBrowse:AddLegend("Z3_STATUS=='1'", "BLUE"  , "Parado na Web")
oBrowse:AddLegend("Z3_STATUS=='2'", "YELLOW", "Aguardando Integra��o")
oBrowse:AddLegend("Z3_STATUS=='3'", "GREEN" , "Integrado com Sucesso")
oBrowse:AddLegend("Z3_STATUS=='4'", "RED"   , "Erro na Integra��o")
oBrowse:AddLegend("Z3_STATUS=='P'", "ORANGE", "Em processo de Integra��o")
oBrowse:AddLegend("!(Z3_STATUS$'1.2.3.4.P')", "WHITE", "Outros Status Web")

//Habilita os Bot�es Ambiente e WalkThru
oBrowse:SetAmbiente(.T.)
oBrowse:SetWalkThru(.T.)

//Desabilita os Detalhes da parte inferior do Browse
oBrowse:DisableDetails()

//Ativa o Browse
oBrowse:Activate()

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � MenuDef  � Autor � Fernando Nogueira  � Data � 19/09/2016  ���
�������������������������������������������������������������������������͹��
���Desc.     � Funcao para Menu do Browse                                 ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico Avant                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function MenuDef()

Local aMenu :=	{}

	ADD OPTION aMenu TITLE 'Pesquisar'  ACTION 'PesqBrw'       		OPERATION 1 ACCESS 0
	ADD OPTION aMenu TITLE 'Visualizar' ACTION 'VIEWDEF.PedidoWeb'	OPERATION 2 ACCESS 0
	// Usuarios que pertencem ao grupo de Administradores
	If aScan(PswRet(1)[1][10],'000000') <> 0
		ADD OPTION aMenu TITLE 'Incluir'    ACTION 'VIEWDEF.PedidoWeb' 	OPERATION 3 ACCESS 0
		ADD OPTION aMenu TITLE 'Alterar'    ACTION 'VIEWDEF.PedidoWeb	' 	OPERATION 4 ACCESS 0
		ADD OPTION aMenu TITLE 'Excluir'    ACTION 'VIEWDEF.PedidoWeb' 	OPERATION 5 ACCESS 0
		ADD OPTION aMenu TITLE 'Imprimir'   ACTION 'VIEWDEF.PedidoWeb'	OPERATION 8 ACCESS 0
		ADD OPTION aMenu TITLE 'Copiar'     ACTION 'VIEWDEF.PedidoWeb'	OPERATION 9 ACCESS 0
	ElseIf aScan(PswRet(1)[1][10],'000067') <> 0
		ADD OPTION aMenu TITLE 'Alterar'    ACTION 'VIEWDEF.PedidoWeb' 	OPERATION 4 ACCESS 0
	Endif
	ADD OPTION aMenu TITLE 'Volta Ped'  ACTION 'U_VoltaPedido'		OPERATION 4 ACCESS 0
	ADD OPTION aMenu TITLE 'Lib Integr' ACTION 'U_LibIntegr'		OPERATION 4 ACCESS 0

Return(aMenu)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � ModelDef � Autor � Fernando Nogueira  � Data � 19/09/2016  ���
�������������������������������������������������������������������������͹��
���Desc.     � Funcao de Modelo de Dados.                                 ���
���          � Onde � definido a estrutura de dados                       ���
���          � Regra de Negocio.                                          ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico Avant                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function ModelDef()

Local oStruSZ3  := FWFormStruct(1,'SZ3', /*bAvalCampo*/, /*lViewUsado*/) //Retorna a Estrutura do Alias passado como Parametro (1=Model,2=View)
Local oStruSZ4  := FWFormStruct(1,'SZ4', /*bAvalCampo*/, /*lViewUsado*/) //Retorna a Estrutura do Alias passado como Parametro (1=Model,2=View)
Local oModel
Local nTotItem  := 0
Local aGat1Prl  := {}
Local aGat2Prl  := {}
Local aGat3Prl  := {}
Local aGat4Prl  := {}
Local aGat1Res  := {}
Local aGat2Res  := {}
Local aGat3Res  := {}
Local aGat4Res  := {}

SetKey(VK_F4,({||If(IsMemVar("M->Z4_PRESERV"),MaViewSB2(GdFieldGet("Z4_CODPROD")),Nil)}))

oStruSZ3:SetProperty('Z3_NPEDWEB',MODEL_FIELD_INIT,{||ProxWeb()})

oStruSZ3:AddField('Frete','Habilita Frete','Z3_FRETE','L',1,0,,,,,{||.F.},,,.T.)

aGat1Prl := FwStruTrigger("Z4_PRLIQ","Z4_VLRTTIT","0"                                ,.F.,,,,"Empty(GdFieldGet('Z4_PRESERV')).And.U_SaldoProd(GdFieldGet('Z4_CODPROD'),'01') < GdFieldGet('Z4_QTDE') ","001")
aGat2Prl := FwStruTrigger("Z4_PRLIQ","Z4_VLRTTIT","GdFieldGet('Z4_QTDE')*M->Z4_PRLIQ",.F.,,,,"Empty(GdFieldGet('Z4_PRESERV')).And.U_SaldoProd(GdFieldGet('Z4_CODPROD'),'01') >= GdFieldGet('Z4_QTDE')","002")
aGat3Prl := FwStruTrigger("Z4_PRLIQ","Z4_VLRTTIT","0"                                ,.F.,,,,"!Empty(GdFieldGet('Z4_PRESERV')).And.!U_WebReserv()"                                                    ,"003")
aGat4Prl := FwStruTrigger("Z4_PRLIQ","Z4_VLRTTIT","GdFieldGet('Z4_QTDE')*M->Z4_PRLIQ",.F.,,,,"!Empty(GdFieldGet('Z4_PRESERV')).And.U_WebReserv()"                                                     ,"004")

aGat1Res := FwStruTrigger("Z4_PRESERV","Z4_VLRTTIT","0"                                           ,.F.,,,,"Empty(M->Z4_PRESERV).And.U_SaldoProd(GdFieldGet('Z4_CODPROD'),'01') < GdFieldGet('Z4_QTDE') ","001")
aGat2Res := FwStruTrigger("Z4_PRESERV","Z4_VLRTTIT","GdFieldGet('Z4_QTDE')*GdFieldGet('Z4_PRLIQ')",.F.,,,,"Empty(M->Z4_PRESERV).And.U_SaldoProd(GdFieldGet('Z4_CODPROD'),'01') >= GdFieldGet('Z4_QTDE')","002")
aGat3Res := FwStruTrigger("Z4_PRESERV","Z4_VLRTTIT","0"                                           ,.F.,,,,"!Empty(M->Z4_PRESERV).And.!U_WebReserv()"                                                    ,"003")
aGat4Res := FwStruTrigger("Z4_PRESERV","Z4_VLRTTIT","GdFieldGet('Z4_QTDE')*GdFieldGet('Z4_PRLIQ')",.F.,,,,"!Empty(M->Z4_PRESERV).And.U_WebReserv()"                                                     ,"004")

oStruSZ4:AddTrigger(aGat1Prl[1],aGat1Prl[2],aGat1Prl[3],aGat1Prl[4])
oStruSZ4:AddTrigger(aGat2Prl[1],aGat2Prl[2],aGat2Prl[3],aGat2Prl[4])
oStruSZ4:AddTrigger(aGat3Prl[1],aGat3Prl[2],aGat3Prl[3],aGat3Prl[4])
oStruSZ4:AddTrigger(aGat4Prl[1],aGat4Prl[2],aGat4Prl[3],aGat4Prl[4])

oStruSZ4:AddTrigger(aGat1Res[1],aGat1Res[2],aGat1Res[3],aGat1Res[4])
oStruSZ4:AddTrigger(aGat2Res[1],aGat2Res[2],aGat2Res[3],aGat2Res[4])
oStruSZ4:AddTrigger(aGat3Res[1],aGat3Res[2],aGat3Res[3],aGat3Res[4])
oStruSZ4:AddTrigger(aGat4Res[1],aGat4Res[2],aGat4Res[3],aGat4Res[4])

//Instancia do Objeto de Modelo de Dados
oModel := MpFormModel():New('MDPEDWEB',/*Pre-Validacao*/,{|oModel| PosValPed(oModel)},/*bCommit*/,/*Cancel*/)

//Adiciona um modelo de Formulario de Cadastro Similar � Enchoice ou Msmget
oModel:AddFields('ID_MODEL_FLD_PedidoWeb', /*cOwner*/, oStruSZ3, /*bPreValidacao*/, /*bPosValidacao*/, /*bCarga*/)

//Setando a chave primaria da rotina
oModel:SetPrimaryKey({'Z3_FILIAL','Z3_NPEDWEB'})

//Adiciona um Modelo de Grid somilar � MsNewGetDados, BrGetDb
oModel:AddGrid('ID_MODEL_GRD_PedidoWeb', 'ID_MODEL_FLD_PedidoWeb', oStruSZ4, /*bLinePre*/, {|oModel| PosValid(oModel)}, /*bPreVal*/, /*bPosVal*/, /*BLoad*/)

// Faz relaciomaneto entre os compomentes do model
oModel:SetRelation('ID_MODEL_GRD_PedidoWeb', {{'Z4_FILIAL', 'xFilial("SZ4")'}, {'Z4_NUMPEDW', 'Z3_NPEDWEB'}}, 'Z4_FILIAL + Z4_NUMPEDW')

//Liga o controle de n�o repeti��o de Linha
oModel:GetModel('ID_MODEL_GRD_PedidoWeb'):SetUniqueLine({'Z4_ITEMPED'})

oModel:AddCalc('ID_COMP_CALC','ID_MODEL_FLD_PedidoWeb','ID_MODEL_GRD_PedidoWeb','Z4_VLRTTIT','TOTVLRTTIT' ,'FORMULA',/*bCond*/,/*bInitValue*/,"Total do Pedido: ",{|oModel| VlrTot(oModel)},,02)

//Adiciona Descricao do Modelo de Dados
oModel:SetDescription('Modelo de Dados do Pedido Web')

//Adiciona Descricao dos Componentes do Modelo de Dados
oModel:GetModel('ID_MODEL_FLD_PedidoWeb'):SetDescription('Formulario do Pedido Web')
oModel:GetModel('ID_MODEL_GRD_PedidoWeb'):SetDescription('Grid do Pedido Web')

oModel:SetVldActivate({|oModel|ActPed(oModel)})

Return(oModel)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � ViewDef  � Autor � Fernando Nogueira  � Data � 19/09/2016  ���
�������������������������������������������������������������������������͹��
���Desc.     � Funcao de Visualizacao.                                    ���
���          � Onde � definido a visualizacao da Regra de Negocio.        ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico Avant                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function ViewDef()

Local oStruSZ3	:= FWFormStruct(2,'SZ3') 	 //Retorna a Estrutura do Alias passado como Parametro (1=Model,2=View)
Local oStruSZ4	:= FWFormStruct(2,'SZ4') 	 //Retorna a Estrutura do Alias passado como Parametro (1=Model,2=View)
Local oModel	:= FwLoadModel('PedidoWeb') //Retorna o Objeto do Modelo de Dados
Local oView		:= FwFormView():New()       //Instancia do Objeto de Visualiza��o
Local oCalc1	:= FWCalcStruct(oModel:GetModel('ID_COMP_CALC'))

//Define o Modelo sobre qual a Visualizacao sera utilizada
oView:SetModel(oModel)

//Retira um campo da Estrutura da View
oStruSZ4:RemoveField('Z4_NUMPEDW')
oStruSZ4:RemoveField('Z4_VALEPRE')

//Vincula o Objeto visual de Cadastro com o modelo
oView:AddField('ID_VIEW_FLD_PedidoWeb', oStruSZ3, 'ID_MODEL_FLD_PedidoWeb')

//Adiciona no nosso View um controle do tipo FormGrid(antiga newgetdados)
oView:AddGrid('ID_VIEW_GRD_PedidoWeb', oStruSZ4, 'ID_MODEL_GRD_PedidoWeb')

oView:AddField('ID_VIEW_CALC',oCalc1,'ID_COMP_CALC')

//Define o Preenchimento da Janela
oView:CreateHorizontalBox('ID_HBOX_SUPERIOR', 40)
oView:CreateHorizontalBox('ID_HBOX_INFERIOR', 50)
oView:CreateHorizontalBox('ID_HBOX_TOTAIS'  , 10)

oView:CreateVerticalBox('ID_VBOX_LEFT_TOTAIS' ,80,'ID_HBOX_TOTAIS')
oView:CreateVerticalBox('ID_VBOX_RIGHT_TOTAIS',20,'ID_HBOX_TOTAIS')

// Relaciona o ID da View com o "box" para exibicao
oView:SetOwnerView('ID_VIEW_FLD_PedidoWeb', 'ID_HBOX_SUPERIOR')
oView:SetOwnerView('ID_VIEW_GRD_PedidoWeb', 'ID_HBOX_INFERIOR')
oView:SetOwnerView('ID_VIEW_CALC'         , 'ID_VBOX_RIGHT_TOTAIS')

//oView:SetViewProperty("ID_VIEW_GRD_PedidoWeb","ENABLENEWGRID")

// Define campos que terao Auto Incremento
oView:AddIncrementField('ID_VIEW_GRD_PedidoWeb', 'Z4_ITEMPED')

// Executa acao no cancelamento
oView:SetViewAction('BUTTONCANCEL',{|oView|If(Inclui,VoltaNum(M->Z3_NPEDWEB),Nil)})

// Executa acao apos confirmac�ao do campo
oView:SetFieldAction('Z4_PRLIQ',{|oView,cIDView,cField,xValue|FreteRefr(oView)})

//Forca o fechamento da janela na confirmacao
oView:SetCloseOnOk({||.T.})

Return(oView)

/*/
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
���Funcao    � FreteRefr � Autor � Fernando Nogueira     � Data �17/08/2017���
��������������������������������������������������������������������������Ĵ��
���Descricao � Faz refresh de tela quando o valor do Pedido eh abaixo do   ���
���          � limite para cobranca de frete                               ���
���������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������
������������������������������������������������������������������������������
/*/
Static Function FreteRefr(oView)

Local oModel    := oView:GetModel()
Local oMdlCalc  := oModel:GetModel('ID_COMP_CALC')

If oMdlCalc:GetValue("TOTVLRTTIT") < 1500
	oView:Refresh()
Endif

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � PosValid � Autor � Fernando Nogueira  � Data � 19/09/2016  ���
�������������������������������������������������������������������������͹��
���Desc.     � Pos validacao da linha do Grid                             ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico Avant                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function PosValid(oModel)

Local lRet    := .T.
Local nLine   := 0
Local cTpOper := ""

nLine   := oModel:GetLine()
cTpOper := oModel:GetValue("Z4_TPOPERW")

If Empty(cTpOper)
	Help(,,'HELP',,"� preciso definir o Tipo de Opera��o no Cabe�alho."+CHR(13)+CHR(10)+"Depois confirmar o c�digo do produto.",1,0,)
	lRet := .F.
Endif

oModel:GoLine(nLine)

Return lRet

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � ProxWeb  � Autor � Fernando Nogueira  � Data � 20/09/2016  ���
�������������������������������������������������������������������������͹��
���Desc.     � Proximo numero Web                                         ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico Avant                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function ProxWeb()

Local nNumProx  := 0
Local nNumProx1 := 0
Local nNumProx2 := 0
Local nNumProx3 := 0
Local cAliasTRB := GetNextAlias()

BeginSQL Alias cAliasTRB
	SELECT MAX(Z3_NPEDWEB)+1 NUMPROX FROM %Table:SZ3%
	WHERE Z3_FILIAL = %Exp:xFilial("SZ3")%
EndSQL

nNumProx1 := (cAliasTRB)->NUMPROX
nNumProx2 := Val(Posicione("SX5",1,xFilial("SX5")+"ZA0007","X5_DESCRI"))
nNumProx3 := Val(Posicione("SX5",1,xFilial("SX5")+"ZA0008","X5_DESCRI"))

If nNumProx1 >= nNumProx2
	nNumProx := nNumProx1
Else
	nNumProx := nNumProx2
Endif

If SX5->(dbSeek(xFilial("SX5")+"ZA0008"))
	SX5->(RecLock("SX5",.F.))
		SX5->X5_DESCRI := STRZERO(nNumProx+2,10)
	SX5->(MsUnlock())
Endif

If nNumProx > nNumProx3 .And. !SZ3->(dbSeek(xFilial("SZ3")+PadL(Alltrim(cValToChar(nNumProx3)),TamSx3("Z3_NPEDWEB")[01])))
	nNumProx := nNumProx3
Else
	If SX5->(dbSeek(xFilial("SX5")+"ZA0007"))
		SX5->(RecLock("SX5",.F.))
			SX5->X5_DESCRI := STRZERO(nNumProx+1,10)
		SX5->(MsUnlock())
	Endif
Endif

(cAliasTRB)->(DbCloseArea())

Return nNumProx

/*
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������ͻ��
���Programa  � VoltaNum � Autor � Fernando Nogueira     � Data � 20/09/2016  ���
����������������������������������������������������������������������������͹��
���Desc.     � Disponibiliza o numero web para ser utilizado em outro Pedido ���
����������������������������������������������������������������������������͹��
���Uso       � Especifico Avant                                              ���
����������������������������������������������������������������������������ͼ��
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
*/
Static Function VoltaNum(_nNum)


If SX5->(dbSeek(xFilial("SX5")+"ZA0008"))
	If Val(SX5->X5_DESCRI) > _nNum
		SX5->(RecLock("SX5",.F.))
			SX5->X5_DESCRI := STRZERO(_nNum,10)
		SX5->(MsUnlock())
	Endif
Endif

Return

/*
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������ͻ��
���Programa  � VoltaPedido � Autor � Fernando Nogueira � Data � 13/02/2017 ���
��������������������������������������������������������������������������͹��
���Desc.     � Volta Pedido para o Status de Aguardando Integracao         ���
���          � Chamado 004689                                              ���
��������������������������������������������������������������������������͹��
���Uso       � Especifico Avant                                            ���
��������������������������������������������������������������������������ͼ��
������������������������������������������������������������������������������
������������������������������������������������������������������������������
*/
User Function VoltaPedido()

If SZ3->Z3_STATUS <> '4'
	ApMsgInfo('S� � permitido voltar Status de Pedido com erro na Integra��o.')
ElseIf SZ3->(RecLock("SZ3",.F.))
	If MsgNoYes('Deseja voltar o Pedido Web '+cValToChar(SZ3->Z3_NPEDWEB)+' para o Status de "Aguardando Integra��o"?')
		SZ3->Z3_STATUS := '2'
		SZ3->(MsUnlock())
		ApMsgInfo('O Pedido Web '+cValToChar(SZ3->Z3_NPEDWEB)+' voltou para o Status "Aguardando Integra��o".')
	Endif
Else
	ApMsgInfo('N�o foi poss�vel alterar o Status do Pedido.')
Endif

Return

/*
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������ͻ��
���Programa  � LibIntegr   � Autor � Fernando Nogueira � Data � 20/07/2017 ���
��������������������������������������������������������������������������͹��
���Desc.     � Libera Pedido Gravado para o Status de Aguardando Integracao���
���          � Chamado 005084                                              ���
��������������������������������������������������������������������������͹��
���Uso       � Especifico Avant                                            ���
��������������������������������������������������������������������������ͼ��
������������������������������������������������������������������������������
������������������������������������������������������������������������������
*/
User Function LibIntegr()

If SZ3->Z3_STATUS <> '1'
	ApMsgInfo('S� � permitido liberar Pedido com Status de Parado na Web.')
ElseIf SZ3->(RecLock("SZ3",.F.))
	If MsgNoYes('Deseja liberar o Pedido Web '+cValToChar(SZ3->Z3_NPEDWEB)+' para o Status de "Aguardando Integra��o"?')
		SZ3->Z3_STATUS := '2'
		SZ3->(MsUnlock())
		ApMsgInfo('O Pedido Web '+cValToChar(SZ3->Z3_NPEDWEB)+' foi liberado para o Status "Aguardando Integra��o".')
	Endif
Else
	ApMsgInfo('N�o foi poss�vel alterar o Status do Pedido.')
Endif

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    � PosValPed� Autor � Fernando Nogueira     � Data �20/07/2017���
�������������������������������������������������������������������������Ĵ��
���Descricao � Funcao de Pos Validacao do Pedido                          ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function PosValPed(oModel)

Local lRet := .T.

If oModel:GetOperation() == MODEL_OPERATION_UPDATE
	SZ3->(RecLock("SZ3",.F.))
		SZ3->Z3_INTEGRA  := 'P'
	SZ3->(MsUnlock())
Endif

Return lRet

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    � ActPed   � Autor � Fernando Nogueira     � Data �20/07/2017���
�������������������������������������������������������������������������Ĵ��
���Descricao � Validacao na Ativacao do Pedido                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function ActPed(oModel)

Local lRet := .T.

If oModel:GetOperation() == MODEL_OPERATION_UPDATE .And. SZ3->Z3_STATUS <> '1'
	oModel:GetModel():SetErrorMessage(oModel:GetId(),,,,"Altera��o de Pedido Web","Status de Pedido Web sem permiss�o de altera��o","Somente Pedidos com Status de 'Parado na Web' podem ser alterados")
	lRet := .F.
Endif

Return lRet

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �WebReserv � Autor � Fernando Nogueira     � Data �28/07/2017���
�������������������������������������������������������������������������Ĵ��
���Descricao �Validacao da Reserva no Pedido Web                          ���
���          �Referente ao chamado 005107                                 ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function WebReserv()

Local aArea  		:= GetArea()
Local nPProduto		:= aScan(aHeader,{|x| AllTrim(x[2])=="Z4_CODPROD"})
Local nPQtdVen		:= aScan(aHeader,{|x| AllTrim(x[2])=="Z4_QTDE"})
Local nPReserva		:= aScan(aHeader,{|x| AllTrim(x[2])=="Z4_PRESERV"})
Local nPVlrItem		:= aScan(aHeader,{|x| AllTrim(x[2])=="Z4_VLRTTIT"})
Local nPQtde		:= aScan(aHeader,{|x| AllTrim(x[2])=="Z4_QTDE"})
Local nPPrliq		:= aScan(aHeader,{|x| AllTrim(x[2])=="Z4_PRLIQ"})
Local lGrade		:= MaGrade()
Local lRetorna		:= .T.
Local nQtdRes		:= 0
Local nCntFor 		:= 0

cProduto := aCols[n][nPProduto]
cLocal   := "01"
cReserva := aCols[n][nPReserva]

If (ReadVar() $ "M->Z4_PRESERV")
	cReserva := &(ReadVar())
EndIf

//������������������������������������������������������������������������Ŀ
//�Nao pode  haver  reserva  com grade                                     �
//��������������������������������������������������������������������������
If ( lGrade )
	If ( MatGrdPrrf(aCols[n][nPProduto]) )
		Help(" ",1,"A410NGRADE")
		lRetorna := .F.
	EndIf
EndIf

If ( lRetorna )
	dbSelectArea("SC0")
	dbSetOrder( 1 )
	If !MsSeek(xFilial("SC0")+cReserva+cProduto+cLocal)
		Help(" ",1,"A410RES")
		lRetorna := .F.
	Else
		nQtdRes := SC0->C0_QUANT
	EndIf
EndIf

//������������������������������������������������������Ŀ
//�  Verifica Saldo da Reserva                           �
//��������������������������������������������������������
If ( lRetorna )
	//������������������������������������������������������������������������Ŀ
	//�Verifica a quantidade utilizada no Acols                                �
	//��������������������������������������������������������������������������
	For nCntFor := 1 To Len(aCols)
		If ( !aCols[nCntFor][Len(aHeader)+1] 			.And.;
				cReserva==aCols[nCntFor][nPReserva] 	.And.;
				cProduto==aCols[nCntFor][nPProduto] 	.And.;
				n 		!=nCntFor)
			nQtdRes -= Min(aCols[nCntFor][nPQtdVen],nQtdRes)
		EndIf
	Next nCntFor
	//������������������������������������������������������������������������Ŀ
	//�Quantidade utilizada no item                                            �
	//��������������������������������������������������������������������������
	nQtdRes -= aCols[n][nPQtdVen]

	//������������������������������������������������������������������������Ŀ
	//�Valida a Reserva                                                        �
	//��������������������������������������������������������������������������
	If ( nQtdRes < 0 )
		Help(" ",1,"A410RESERV")
		lRetorna := .F.
	EndIf
EndIf

//������������������������������������������������������������������������Ŀ
//�Retorna os registros alterados                                          �
//��������������������������������������������������������������������������
RestArea(aArea)

Return(lRetorna)

/*/
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
���Funcao    � VlrTot    � Autor � Fernando Nogueira     � Data �17/08/2017���
��������������������������������������������������������������������������Ĵ��
���Descricao � Calcula o Valor Total do Pedido e Altera o Tipo de Frete    ���
���          � conforme limite estabelecido                                ���
���������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������
������������������������������������������������������������������������������
/*/
Static Function VlrTot(oModel)

Local oMdlField := oModel:GetModel('ID_MODEL_FLD_PedidoWeb')
Local oMdlGrid  := oModel:GetModel('ID_MODEL_GRD_PedidoWeb')
Local oMdlCalc  := oModel:GetModel('ID_COMP_CALC')
Local cEstFrete := Posicione("SX5",01,xFilial("SX5")+"ZA"+"0002","X5_DESCRI")
Local cEstado   := Posicione("SA1",03,xFilial("SA1")+oMdlField:GetValue("Z3_CNPJ"),"A1_EST")
Local cTransp   := Posicione("SZ1",01,xFilial("SZ1")+SA1->(A1_COD+A1_LOJA),"Z1_TRANSP")
Local cHabFrete := SA1->A1_X_HBFRT
Local cPessoa   := SA1->A1_PESSOA
Local nTotal    := 0
Local cTipoOper := AllTrim(oMdlField:GetValue("Z3_CODTSAC"))
Local nPosVlrIt := aScan(oMdlGrid:aHeader,{|x| AllTrim(x[2]) == "Z4_VLRTTIT"})

For nI := 1 To Len(oMdlGrid:aCols)
	If !oMdlGrid:aCols[nI,Len(oMdlGrid:aHeader)+1]
		nTotal += oMdlGrid:aCols[nI,nPosVlrIt]
	Endif
Next nI
	
If oModel:GetOperation() == MODEL_OPERATION_INSERT .Or. oModel:GetOperation() == MODEL_OPERATION_UPDATE

	If nTotal < oMdlCalc:GetValue("TOTVLRTTIT") .And. nTotal > 0 .And. nTotal < 1500 .And. cPessoa <> "F" .And. cHabFrete == "S" .And. cTipoOper = '51'
		If cEstado $ cEstFrete
			oMdlField:SetValue("Z3_FREPAGO","C")
		Else
			oMdlField:SetValue("Z3_FREPAGO","F")
		Endif
		If !oMdlField:GetValue("Z3_FRETE")
			Aviso('Limite Frete',"O valor total do Pedido vai ficar abaixo de 1500, portanto o frete ser� cobrado",{'Ok'})
		Endif
		oMdlField:SetValue("Z3_FRETE",.T.)
	ElseIf nTotal >= 1500
		If oMdlField:GetValue("Z3_CODTRAN") <> cTransp
			oMdlField:SetValue("Z3_CODTRAN",cTransp)
		Endif
		oMdlField:SetValue("Z3_FREPAGO","C")
		oMdlField:SetValue("Z3_FRETE",.F.)
	Endif

Endif

Return nTotal
