#Include "Totvs.ch"
#Include "FwMvcDef.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออออหอออออออัออออออออออออออออออออออหออออออัออออออออออปฑฑ
ฑฑบPrograma  ณ Perm_Internaบ Autor ณ Fernando Nogueira    บ Data ณ07/04/2015บฑฑ
ฑฑฬออออออออออุอออออออออออออสอออออออฯออออออออออออออออออออออสออออออฯออออออออออนฑฑ
ฑฑบDescricao ณ Permissao para as Regras Internas                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico Avant                 	                        บฑฑ
ฑฑฬออออออออออฯออออออัออออออออออัออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAnalista Resp.   ณ   Data   ณ Manutencao Efetuada                        บฑฑ
ฑฑฬอออออออออออออออออุออออออออออุออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบFernando Nogueiraณ01/11/2016ณ Incluindo a Opcao de Responsavel por Area. บฑฑ
ฑฑบ                 ณ  /  /    ณ Alteracao do Cadastro para o MVC           บฑฑ
ฑฑศอออออออออออออออออฯออออออออออฯออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function Perm_Interna()

Private oBrowse := FwMBrowse():New()				//Variavel de Browse 

//Alias do Browse
oBrowse:SetAlias('ZZL')
//Descri็ใo da Parte Superior Esquerda do Browse
oBrowse:SetDescripton("Permissao Regras Internas") 

//Legendas do Browse
oBrowse:AddLegend( "ZZL_PERMIS=='1'", "ENABLE" , "Liberado" )
oBrowse:AddLegend( "ZZL_PERMIS=='2'", "DISABLE", "Bloqueado")

// Usuarios que nao sao Administradores terao filtro
If aScan(PswRet(1)[1][10],'000000') == 0
	oBrowse:SetFilterDefault("ZZL_CODRES == "+RetCodUsr()+" .And. ZZL_CODUSR <> "+RetCodUsr())
Endif
	
//Ativa o Browse
oBrowse:Activate()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ MenuDef  บ Autor ณ Fernando Nogueira  บ Data ณ 01/11/2016  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao para Menu do Browse                                 บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico Avant                                           บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function MenuDef()

Local aMenu :=	{}
	
ADD OPTION aMenu TITLE 'Pesquisar'  ACTION 'PesqBrw'       		    OPERATION 1 ACCESS 0
ADD OPTION aMenu TITLE 'Visualizar' ACTION 'VIEWDEF.Perm_Interna'	OPERATION 2 ACCESS 0
ADD OPTION aMenu TITLE 'Incluir'    ACTION 'VIEWDEF.Perm_Interna' 	OPERATION 3 ACCESS 0
ADD OPTION aMenu TITLE 'Alterar'    ACTION 'VIEWDEF.Perm_Interna' 	OPERATION 4 ACCESS 0
ADD OPTION aMenu TITLE 'Excluir'    ACTION 'VIEWDEF.Perm_Interna' 	OPERATION 5 ACCESS 0
ADD OPTION aMenu TITLE 'Imprimir'   ACTION 'VIEWDEF.Perm_Interna'	OPERATION 8 ACCESS 0
ADD OPTION aMenu TITLE 'Copiar'     ACTION 'VIEWDEF.Perm_Interna'	OPERATION 9 ACCESS 0
	
Return(aMenu)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ ModelDef บ Autor ณ Fernando Nogueira  บ Data ณ 01/11/2016  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao de Modelo de Dados.                                 บฑฑ
ฑฑบ          ณ Onde eh definido a estrutura de dados.                     บฑฑ
ฑฑบ          ณ Regra de Negocio.                                          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico Avant                                           บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ModelDef()
//Retorna a Estrutura do Alias passado como Parametro (1=Model,2=View)
Local oStruct := FWFormStruct(1,"ZZL") 
Local oModel

//Instancia do Objeto de Modelo de Dados
oModel := MpFormModel():New('MDPerm',/*Pre-Validacao*/,/*Pos-Validacao*/,/*Commit*/,/*Cancel*/)

//Adiciona um modelo de Formulario de Cadastro Similar ao Enchoice ou Msmget
oModel:AddFields('ID_FLD_Perm', /*cOwner*/, oStruct, /*bPreValidacao*/, /*bPosValidacao*/, /*bCarga*/ )

//Definicao da Chave Primaria
oModel:SetPrimaryKey({"ZZL_FILIAL", "ZZL_AREA"})

//Adiciona Descricao do Modelo de Dados
oModel:SetDescription( 'Modelo de Dados das Permissoes Internas' )

//Adiciona Descricao do Componente do Modelo de Dados      
oModel:GetModel( 'ID_FLD_Perm' ):SetDescription('Formulario dos Dados das Permissoes Internas')

Return(oModel)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ ViewDef  บ Autor ณ Fernando Nogueira  บ Data ณ 01/11/2016  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao de Visualizacao.                                    บฑฑ
ฑฑบ          ณ Onde eh definido a visualizacao da Regra de Negocio.       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Aula de MVC                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ViewDef()

Local oStruct	:=	FWFormStruct(2,"ZZL") 	    //Retorna a Estrutura do Alias passado como Parametro (1=Model,2=View)
Local oModel	:=	FwLoadModel('Perm_Interna')	//Retorna o Objeto do Modelo de Dados 
Local oView		:=	FwFormView():New()          //Instancia do Objeto de Visualiza็ใo

//Define o Modelo sobre qual a Visualizacao sera utilizada
oView:SetModel(oModel)	

//Vincula o Objeto visual de Cadastro com o modelo 
oView:AddField( 'ID_VIEW_Perm', oStruct, 'ID_FLD_Perm')

Return(oView)  

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออปฑฑ
ฑฑบPrograma  ณ Internos()  บ Autor ณ Fernando Nogueira  บ Data ณ07/04/2015บฑฑ
ฑฑฬออออออออออุอออออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออนฑฑ
ฑฑบDescrio ณ Validacao para chamada dos Movimentos Internos             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico AVANT.                   	                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function Internos()

Local cEOL := Chr(13)+Chr(10)

dbSelectArea("ZZL")
dbSetOrder(1)

If (dbSeek(xFilial("ZZL")+"1"+RetCodUsr()) .And. ZZL->ZZL_PERMIS == '1') .Or. aScan(PswRet(1)[1][10],'000000') <> 0
	MATA240()
Else
	ApMsgInfo("Usuแrio nใo Autorizado!"+cEOL+"Entrar em contato com o gerente da Logํstica.")
Endif

Return
