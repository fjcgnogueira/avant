#Include "Totvs.ch"
#Include "FwMvcDef.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � CadZZI   � Autor � Fernando Nogueira   � Data � 03/05/2017 ���
�������������������������������������������������������������������������͹��
���Desc.     � Cadastro das Regras para geracao da tabela de impostos     ���
���          � utilizada na consulta web                                  ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico Avant                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function CadZZI()

Private oBrowse := FwMBrowse():New()

oBrowse:SetAlias('ZZI')
oBrowse:SetDescripton("Regras de Impostos Avant") 

//Legendas do Browse
oBrowse:AddLegend( "ZZI_DIAGER=='0'", "RED" , "Prioridade")
oBrowse:AddLegend( "ZZI_DIAGER<>'0'", "BLUE", "Normal")

oBrowse:Activate()

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � MenuDef  � Autor � Fernando Nogueira   � Data � 03/05/2017 ���
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
	
ADD OPTION aMenu TITLE 'Pesquisar'  ACTION 'PesqBrw'       	OPERATION 1 ACCESS 0
ADD OPTION aMenu TITLE 'Visualizar' ACTION 'VIEWDEF.CadZZI'	OPERATION 2 ACCESS 0
ADD OPTION aMenu TITLE 'Incluir'    ACTION 'VIEWDEF.CadZZI' OPERATION 3 ACCESS 0
ADD OPTION aMenu TITLE 'Alterar'    ACTION 'VIEWDEF.CadZZI' OPERATION 4 ACCESS 0
ADD OPTION aMenu TITLE 'Excluir'    ACTION 'VIEWDEF.CadZZI' OPERATION 5 ACCESS 0
	
Return(aMenu)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � ModelDef � Autor � Fernando Nogueira   � Data � 03/05/2017 ���
�������������������������������������������������������������������������͹��
���Desc.     � Funcao de Modelo de Dados                                  ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico Avant                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function ModelDef()

//Retorna a Estrutura do Alias passado como Parametro (1=Model,2=View)
Local oStruZZI := FWFormStruct(1,"ZZI") 
Local oModel

oStruZZI:SetProperty('ZZI_UF'    , MODEL_FIELD_VALID, FWBuildFeature(STRUCT_FEATURE_VALID, "ExistChav('ZZI',M->ZZI_UF+M->ZZI_TIPO,01).And.ExistCPO('C09',M->ZZI_UF,01)"))
oStruZZI:SetProperty('ZZI_TIPO'  , MODEL_FIELD_VALID, FWBuildFeature(STRUCT_FEATURE_VALID, "ExistChav('ZZI',M->ZZI_UF+M->ZZI_TIPO,01)"))
oStruZZI:SetProperty('ZZI_CLIENT', MODEL_FIELD_VALID, FWBuildFeature(STRUCT_FEATURE_VALID, "If(Empty(M->ZZI_LOJA)  ,Vazio().Or.ExistCPO('SA1',M->ZZI_CLIENT,01),Vazio().Or.StaticCall(CadZZI,ValidCli))"))
oStruZZI:SetProperty('ZZI_LOJA'  , MODEL_FIELD_VALID, FWBuildFeature(STRUCT_FEATURE_VALID, "If(Empty(M->ZZI_CLIENT),Vazio(),Vazio().Or.StaticCall(CadZZI,ValidCli))"))
oStruZZI:SetProperty('ZZI_DIAGER', MODEL_FIELD_VALID, FWBuildFeature(STRUCT_FEATURE_VALID, "StaticCall(CadZZI,ValidDia,A)"))

oModel := MpFormModel():New('MDCadZZI',/*Pre-Validacao*/,/*Pos-Validacao*/,/*Commit*/,/*Cancel*/)
oModel:AddFields('ID_FLD_CadZZI', /*cOwner*/, oStruZZI, /*bPreValidacao*/, /*bPosValidacao*/, /*bCarga*/)
oModel:SetPrimaryKey({"ZZI_FILIAL", "ZZI_UF", "ZZI_TIPO"})
oModel:SetDescription( 'Modelo de Dados das Regras de Impostos Avant' )
oModel:GetModel('ID_FLD_CadZZI'):SetDescription('Formulario de Cadastro das Regras de Impostos Avant')

Return(oModel)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � ValidCli � Autor � Fernando Nogueira   � Data � 04/05/2017 ���
�������������������������������������������������������������������������͹��
���Desc.     � Validacao do Cliente                                       ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico Avant                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function ValidCli(oModel)

Local lReturn := .T.

If ExistCPO('SA1',M->ZZI_CLIENT+M->ZZI_LOJA,01)
	If Posicione('SA1',01,xFilial('SA1')+M->ZZI_CLIENT+M->ZZI_LOJA,'A1_EST') <> M->ZZI_UF
		ApMsgInfo("A UF do cliente � diferente da UF da Regra.")
		lReturn := .F.
	Endif
Else
	lReturn := .F.
Endif

Return lReturn

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � ValidDia � Autor � Fernando Nogueira   � Data � 04/05/2017 ���
�������������������������������������������������������������������������͹��
���Desc.     � Validacao do Dia da Semana                                 ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico Avant                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function ValidDia()

Local lReturn := .T.
Local cWhere  := "%%"

If M->ZZI_DIAGER >= '2' .Or. M->ZZI_DIAGER = '0'
	
	If Altera
		cWhere := "% AND ZZI.R_E_C_N_O_ <> " + cValToChar(ZZI->(Recno())) + " %" 
	Endif

	BeginSql alias 'TRB'
	
		SELECT COUNT(*) QUANT FROM %table:ZZI% ZZI
		WHERE ZZI.%notDel%
		 	%exp:cWhere%
			AND ZZI_FILIAL = %exp:xFilial("ZZI")%
			AND ZZI_DIAGER = %exp:M->ZZI_DIAGER%
	
	EndSql
	
	If TRB->QUANT >= 1 .And. M->ZZI_DIAGER = '0'
		ApMsgInfo("J� existe uma regra com prioridade")
		lReturn := .F.
	ElseIf TRB->QUANT >= 3
		ApMsgInfo("Esse dia j� possui 3 regras, escolha outro dia ou Domingo")
		lReturn := .F.
	Endif
	TRB->(dbCloseArea())
Endif

Return lReturn

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � ViewDef  � Autor � Fernando Nogueira   � Data � 03/05/2017 ���
�������������������������������������������������������������������������͹��
���Desc.     � Funcao de Visualizacao                                     ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico Avant                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function ViewDef()
Local oStruZZI	:=	FWFormStruct(2,"ZZI") 	//Retorna a Estrutura do Alias passado como Parametro (1=Model,2=View)
Local oModel	:=	FwLoadModel('CadZZI')	//Retorna o Objeto do Modelo de Dados 
Local oView		:=	FwFormView():New()      //Instancia do Objeto de Visualizacao

oView:SetModel(oModel)	
oView:AddField( 'ID_VIEW_CadZZI', oStruZZI, 'ID_FLD_CadZZI')

//Forca o fechamento da janela na confirmacao
oView:SetCloseOnOk({||.T.})

Return(oView)                       
