#Include "Totvs.ch"
#Include "FwMvcDef.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � TabImp   � Autor � Fernando Nogueira   � Data � 09/05/2017 ���
�������������������������������������������������������������������������͹��
���Desc.     � Tabela de Impostos                                         ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico Avant                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function TabImp()

Private oBrowse := FwMBrowse():New()

oBrowse:SetAlias('ZIA')
oBrowse:SetDescripton("Tabela de Impostos") 

oBrowse:Activate()

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � MenuDef  � Autor � Fernando Nogueira   � Data � 09/05/2017 ���
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
ADD OPTION aMenu TITLE 'Visualizar' ACTION 'VIEWDEF.TabImp'	OPERATION 2 ACCESS 0
	
Return(aMenu)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � ModelDef � Autor � Fernando Nogueira   � Data � 09/05/2017 ���
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
Local oStruZZI := FWFormStruct(1,"ZIA") 
Local oModel

oModel := MpFormModel():New('MDTabImp',/*Pre-Validacao*/,/*Pos-Validacao*/,/*Commit*/,/*Cancel*/)
oModel:AddFields('ID_FLD_TabImp', /*cOwner*/, oStruZZI, /*bPreValidacao*/, /*bPosValidacao*/, /*bCarga*/)
oModel:SetPrimaryKey({"ZIA_FILIAL","ZIA_UF", "ZIA_TIPO", "ZIA_COD"})
oModel:SetDescription( 'Modelo de Dados da Tabela de Impostos Avant' )
oModel:GetModel('ID_FLD_TabImp'):SetDescription('Formulario da Tabela de Impostos Avant')

Return(oModel)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � ViewDef  � Autor � Fernando Nogueira   � Data � 09/05/2017 ���
�������������������������������������������������������������������������͹��
���Desc.     � Funcao de Visualizacao                                     ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico Avant                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function ViewDef()
Local oStruZZI	:=	FWFormStruct(2,"ZIA") 	//Retorna a Estrutura do Alias passado como Parametro (1=Model,2=View)
Local oModel	:=	FwLoadModel('TabImp')	//Retorna o Objeto do Modelo de Dados 
Local oView		:=	FwFormView():New()      //Instancia do Objeto de Visualizacao

oView:SetModel(oModel)	
oView:AddField( 'ID_VIEW_TabImp', oStruZZI, 'ID_FLD_TabImp')

//Forca o fechamento da janela na confirmacao
oView:SetCloseOnOk({||.T.})

Return(oView)                       
