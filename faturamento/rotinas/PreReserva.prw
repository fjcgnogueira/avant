#Include "Totvs.ch"
#Include "FwMvcDef.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออปฑฑ
ฑฑบPrograma  ณ PreReservaบ Autor ณ Fernando Nogueira  บ Data ณ 17/07/2017 บฑฑ
ฑฑฬออออออออออุอออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออนฑฑ
ฑฑบDesc.     ณ Fazer uma pre-reserva para produtos que nao tem estoque    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico Avant                                           บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function PreReserva()

Private oBrowse := FwMBrowse():New() 

oBrowse:SetAlias('ZZR')
oBrowse:SetDescripton("Pre Reserva") 

//Legendas do Browse
oBrowse:AddLegend("ZZR_STATUS=='A'", "GREEN"     , "Em Aberto")
oBrowse:AddLegend("ZZR_STATUS=='B'", "RED"       , "Baixado")
oBrowse:AddLegend("ZZR_STATUS=='P'", "BR_AMARELO", "Baixa Parcial")
oBrowse:AddLegend("ZZR_STATUS=='R'", "BR_CINZA"  , "Eliminado Residuo")

//Habilita os Bot๕es Ambiente e WalkThru
oBrowse:SetAmbiente(.T.)
oBrowse:SetWalkThru(.T.)

//Desabilita os Detalhes da parte inferior do Browse
oBrowse:DisableDetails()

oBrowse:Activate()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ MenuDef  บ Autor ณ Fernando Nogueira  บ Data ณ 18/07/2017  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao para Menu do Browse                                 บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico Avant                                           บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function MenuDef()

Local aMenu :=	{}
	
	ADD OPTION aMenu TITLE 'Pesquisar'  ACTION 'PesqBrw'       		OPERATION 1 ACCESS 0
	ADD OPTION aMenu TITLE 'Visualizar' ACTION 'VIEWDEF.PreReserva'	OPERATION 2 ACCESS 0
	ADD OPTION aMenu TITLE 'Incluir'    ACTION 'VIEWDEF.PreReserva' OPERATION 3 ACCESS 0
	ADD OPTION aMenu TITLE 'Alterar'    ACTION 'VIEWDEF.PreReserva' OPERATION 4 ACCESS 0
	ADD OPTION aMenu TITLE 'Excluir'    ACTION 'VIEWDEF.PreReserva' OPERATION 5 ACCESS 0
	ADD OPTION aMenu TITLE 'Imprimir'   ACTION 'VIEWDEF.PreReserva'	OPERATION 8 ACCESS 0
	ADD OPTION aMenu TITLE 'Elim.Resid' ACTION 'StaticCall(PreReserva,ElimRes)' OPERATION 4 ACCESS 0
	
Return(aMenu)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ ModelDef บ Autor ณ Fernando Nogueira  บ Data ณ 18/07/2017  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao de Modelo de Dados.                                 บฑฑ
ฑฑบ          ณ Onde ้ definido a estrutura de dados                       บฑฑ
ฑฑบ          ณ Regra de Negocio.                                          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico Avant                                           บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ModelDef()

Local oStruCZZR  := FWFormStruct(1,'ZZR', { |cCampo|  AllTrim(cCampo) + "|" $ "ZZR_NUM|ZZR_TIPO|ZZR_SOLICI|"    }, /*lViewUsado*/)
Local oStruIZZR  := FWFormStruct(1,'ZZR', { |cCampo|  !(AllTrim(cCampo) + "|" $ "ZZR_NUM|ZZR_TIPO|ZZR_SOLICI|") }, /*lViewUsado*/)
Local oModel
Local bLinePre   := {|oModel,nLinha,cAcao|If(cAcao='DELETE'.And.oModel:GetValue("ZZR_STATUS")<>'A',Eval({||Help(,,'Help',,'Pode-se deletar somente Pr้ Reservas em aberto',1,0),.F.}),.T.)}
Local bLinePost  := {|oModel|PosVldLin(oModel)}

SetKey(VK_F4,({||If(IsMemVar("M->ZZR_PRODUT"),MaViewSB2(M->ZZR_PRODUT),Nil)}))

oStruIZZR:AddTrigger("ZZR_PRODUT","ZZR_LOCAL",{||.T.},{|oModel|Posicione("SB1",01,xFilial("SB1")+oModel:GetValue("ZZR_PRODUT"),"B1_LOCPAD")})
oStruIZZR:AddTrigger("ZZR_QUANT","ZZR_QTDORI",{||.T.},{|oModel|If(oModel:GetValue("ZZR_STATUS")="A",oModel:GetValue("ZZR_QUANT"),oModel:GetValue("ZZR_QTDORI"))})

oStruIZZR:SetProperty('ZZR_PRODUT',MODEL_FIELD_WHEN,{|oModel|oModel:GetValue("ZZR_STATUS")="A"})
oStruIZZR:SetProperty('ZZR_LOCAL' ,MODEL_FIELD_WHEN,{|oModel|oModel:GetValue("ZZR_STATUS")="A"})
oStruIZZR:SetProperty('ZZR_QUANT' ,MODEL_FIELD_WHEN,{|oModel|oModel:GetValue("ZZR_STATUS")="A"})
oStruIZZR:SetProperty('ZZR_OBS'   ,MODEL_FIELD_WHEN,{|oModel|oModel:GetValue("ZZR_STATUS")="A"})

oModel := MpFormModel():New('MDPRESERV',/*Pre-Validacao*/,/*Pos-Validacao*/,/*Commit*/,/*Cancel*/)
oModel:AddFields('ID_MODEL_FLD_PreReserva', /*cOwner*/, oStruCZZR, /*bPreValidacao*/, /*bPosValidacao*/, /*bCarga*/)
oModel:SetPrimaryKey({'ZZR_FILIAL','ZZR_NUM','ZZR_PRODUT','ZZR_LOCAL'})
oModel:SetDescription('Modelo de Dados do Pre Reserva')
                               		
oModel:AddGrid('ID_MODEL_GRD_PreReserva', 'ID_MODEL_FLD_PreReserva', oStruIZZR, bLinePre, bLinePost, /*bPreVal*/, /*bPosVal*/, /*BLoad*/)
oModel:SetRelation('ID_MODEL_GRD_PreReserva', {{'ZZR_FILIAL', 'xFilial("ZZR")'},{'ZZR_NUM', 'ZZR_NUM'},{'ZZR_TIPO', 'ZZR_TIPO'},{'ZZR_SOLICI', 'ZZR_SOLICI'}}, 'ZZR_FILIAL+ZZR_NUM+ZZR_TIPO+ZZR_SOLICI')
oModel:GetModel('ID_MODEL_GRD_PreReserva'):SetUniqueLine({'ZZR_PRODUT','ZZR_LOCAL'})

oModel:GetModel('ID_MODEL_FLD_PreReserva'):SetDescription('Formulario de Pre Reserva')
oModel:GetModel('ID_MODEL_GRD_PreReserva'):SetDescription('Grid de Pre Reserva')

// Valida na inicializacao do Model
oModel:SetVldActivate({|oModel|ActPed(oModel)})

Return(oModel)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ PosVldLinบ Autor ณ Fernando Nogueira  บ Data ณ 25/07/2017  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao de Pos Validacao de Linha                           บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico Avant                                           บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function PosVldLin(oModel)

Local lRet := .T.

If U_SaldoProd(oModel:GetValue("ZZR_PRODUT"),oModel:GetValue("ZZR_LOCAL")) > 0
	oModel:GetModel():SetErrorMessage(oModel:GetId(),'ZZR_PRODUT',,,"Saldo","Produto com Saldo","Utilizar somente produtos sem saldo disponํvel")
	lRet := .F.
EndIf

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ ViewDef  บ Autor ณ Fernando Nogueira  บ Data ณ 18/07/2017  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao de Visualizacao.                                    บฑฑ
ฑฑบ          ณ Onde ้ definido a visualizacao da Regra de Negocio.        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico Avant                                           บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ViewDef()

Local oStruCZZR := FWFormStruct(2,'ZZR',{ |cCampo|  AllTrim(cCampo) + "|" $ "ZZR_NUM|ZZR_TIPO|ZZR_SOLICI|"   })
Local oStruIZZR := FWFormStruct(2,'ZZR',{ |cCampo|  !(AllTrim(cCampo) + "|" $ "ZZR_NUM|ZZR_TIPO|ZZR_SOLICI|")})
Local oModel    := FwLoadModel('PreReserva') 
Local oView     := FwFormView():New()

oView:SetModel(oModel)

oView:AddField('ID_VIEW_FLD_PreReserva', oStruCZZR, 'ID_MODEL_FLD_PreReserva')
oView:AddGrid('ID_VIEW_GRD_PreReserva', oStruIZZR, 'ID_MODEL_GRD_PreReserva')

oView:CreateHorizontalBox('ID_HBOX_SUPERIOR', 20)
oView:CreateHorizontalBox('ID_HBOX_INFERIOR', 80)

oView:EnableTitleView('ID_VIEW_FLD_PreReserva',"Cabecalho")
oView:EnableTitleView('ID_VIEW_GRD_PreReserva',"Itens")

oView:SetOwnerView('ID_VIEW_FLD_PreReserva', 'ID_HBOX_SUPERIOR')
oView:SetOwnerView('ID_VIEW_GRD_PreReserva', 'ID_HBOX_INFERIOR')

//Forca o fechamento da janela na confirmacao
oView:SetCloseOnOk({||.T.})

Return(oView)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออปฑฑ
ฑฑบPrograma  ณ ElimRes   บ Autor ณ Fernando Nogueira  บ Data ณ 02/08/2017 บฑฑ
ฑฑฬออออออออออุอออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออนฑฑ
ฑฑบDesc.     ณ Eliminar Residuos da Reserva                               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico Avant                                           บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ElimRes()

Local oDlg
Local oButton1
Local oButton2
Local oButton3
Local oFont1   := TFont():New("Arial",,016,,.T.,,,,,.F.,.F.)
Local oGroup1
Local oSay1
Local nPreRes  := ZZR->ZZR_NUM
Local nOpcao   := 0
Local lResid   := .F.
Local aAreaZZR := ZZR->(GetArea()) 

DEFINE MSDIALOG oDlg TITLE "Eliminar Residuos" FROM 000, 000  TO 140, 340 COLORS 0, 16777215 PIXEL
	@ 004, 004 GROUP oGroup1 TO 064, 164 OF oDlg COLOR 0, 16777215 PIXEL
	@ 012, 015 SAY oSay1 PROMPT "Eliminar Resํduos da Pr้ Reserva "+ZZR->ZZR_NUM+" inteira ou somente do produto "+AllTrim(ZZR->ZZR_PRODUT)+" ?" SIZE 135, 017 OF oDlg FONT oFont1 COLORS 0, 16777215 PIXEL
	@ 040, 015 BUTTON oButton1 PROMPT "Inteira"  SIZE 037, 012 OF oDlg PIXEL ACTION (nOpcao := 1, oDlg:End())
	@ 040, 065 BUTTON oButton2 PROMPT "Produto"  SIZE 037, 012 OF oDlg PIXEL ACTION (nOpcao := 2, oDlg:End())
	@ 040, 115 BUTTON oButton3 PROMPT "Cancelar" SIZE 037, 012 OF oDlg PIXEL ACTION (nOpcao := 0, oDlg:End())
ACTIVATE MSDIALOG oDlg CENTER

If nOpcao = 1

	ZZR->(dbSetOrder(01))
	ZZR->(dbGoTop(01))
	ZZR->(DbSeek(xFilial("ZZR") + nPreRes))
	
	While ZZR->(!EoF()) .And. ZZR->(ZZR_FILIAL+ZZR_NUM) = xFilial("ZZR") + nPreRes 
		If ZZR->ZZR_STATUS = 'P'
			lResid := .T.
			Exit
		Endif
		ZZR->(dbSkip())
	Enddo

	If lResid
		ZZR->(dbGoTop(01))
		ZZR->(DbSeek(xFilial("ZZR") + nPreRes))
		While ZZR->(!EoF()) .And. ZZR->(ZZR_FILIAL+ZZR_NUM) = xFilial("ZZR") + nPreRes
			If ZZR->ZZR_STATUS = 'P' .And. ZZR->(RecLock('ZZR',.F.))
				ZZR->ZZR_STATUS  := "R"
				ZZR->(MsUnLock())
			Endif
			ZZR->(dbSkip())
		Enddo
		ApMsgInfo("Resํduos da Pr้ Reserva "+nPreRes+" eliminados")
	Else
		ApMsgInfo("A Pr้ Reserva "+nPreRes+" nใo possui itens com baixa parcial")
	Endif

ElseIf nOpcao = 2
	If ZZR->ZZR_STATUS = 'P'		
		If ZZR->(RecLock('ZZR',.F.))
			ZZR->ZZR_STATUS  := "R"
			ZZR->(MsUnLock())
		Endif
		ApMsgInfo("Resํduo da Pr้ Reserva "+nPreRes+" produto "+AllTrim(ZZR->ZZR_PRODUT)+" eliminado")
	Else
		ApMsgInfo("Eliminar resํduos somente de Pr้ Reserva com baixa parcial")
	Endif
Endif

ZZR->(Restarea(aAreaZZR))	

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFuncao    ณ ActPed   ณ Autor ณ Fernando Nogueira     ณ Data ณ02/08/2017ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณ Funcao de Validacao na Ativacao do Model                   ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function ActPed(oModel)

Local lRet     := .T.
Local aAreaZZR := ZZR->(GetArea())
Local nPreRes  := ZZR->ZZR_NUM 

If oModel:GetOperation() == MODEL_OPERATION_DELETE
	ZZR->(dbSetOrder(01))
	ZZR->(dbGoTop(01))
	ZZR->(DbSeek(xFilial("ZZR") + nPreRes))
	
	While ZZR->(!EoF()) .And. ZZR->(ZZR_FILIAL+ZZR_NUM) = xFilial("ZZR") + nPreRes 
		If ZZR->ZZR_STATUS <> 'A'
			lRet := .F.
			oModel:GetModel():SetErrorMessage(oModel:GetId(),,,,"Exclusใo de Pr้ Reserva","Somente ้ possํvel excluir Pr้ Reserva que tenha todos os itens em aberto","Caso queira excluir apenas um item da Pr้ Reserva, clique em Alterar, delete o item e confirme")
			Exit
		Endif
		ZZR->(dbSkip())
	Enddo
ElseIf oModel:GetOperation() == MODEL_OPERATION_UPDATE
	ZZR->(dbSetOrder(01))
	ZZR->(dbGoTop(01))
	ZZR->(DbSeek(xFilial("ZZR") + nPreRes))
	
	lRet := .F.
	
	While ZZR->(!EoF()) .And. ZZR->(ZZR_FILIAL+ZZR_NUM) = xFilial("ZZR") + nPreRes 
		If ZZR->ZZR_STATUS = 'A'
			lRet := .T.
			Exit
		Endif
		ZZR->(dbSkip())
	Enddo
	
	If !lRet
		oModel:GetModel():SetErrorMessage(oModel:GetId(),,,,"Altera็ใo de Pr้ Reserva","Somente ้ possํvel alterar Pr้ Reserva que tenha algum item em aberto","Caso tenha algum item com baixa parcial na Pr้ Reserva para eliminar, ้ preciso fazer a Elimina็ใo de Resํduos")
	Endif
Endif

ZZR->(Restarea(aAreaZZR))

Return lRet