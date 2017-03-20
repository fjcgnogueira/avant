#include "totvs.ch"
#include "fwmvcdef.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ AprovVencto º Autor ³ Fernando Nogueira  º Data ³31/05/2016º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Aprovacao de alteracoes nos Titulos a Receber              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico AVANT.                   	                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÏÍÍÍÑÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAnalista Resp.³  Data  ³ Manutencao Efetuada                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º              ³  /  /  ³                                               º±±
±±º              ³  /  /  ³                                               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function AprovVencto()

Local bKeyF5  := SetKey(VK_F5)
Local bKeyF12 := SetKey(VK_F12)

Private oBrowse
Private lEnd  := .T.
Private cPerg := "SE1AV"

AjustaSX1(cPerg)
Pergunte(cPerg,.F.)

oBrowse:= FWMarkBrowse():New()
oBrowse:SetDescription('Aprovacao Tit. a Receber')
oBrowse:SetMenuDef("AprovVencto")
oBrowse:SetAlias("SE1")
oBrowse:SetFieldMark("E1_X_OK")
oBrowse:SetAllMark({||AllMark()})
oBrowse:SetFilterDefault("@"+AprFinQry())
oBrowse:SetWalkThru(.F.)
oBrowse:SetAmbiente(.F.)
oBrowse:SetTimer({|| oBrowse:Refresh(.T.)}, 600000) // 10 min
oBrowse:SetIniWindow({||oBrowse:oBrowse:oTimer:lActive := .T.})
oBrowse:SetValid({||If(SE1->E1_APRVENC = 'S',ApMsgInfo("Título já aprovado"),),SE1->E1_APRVENC <> 'S'})

// Definicao da legenda
oBrowse:AddLegend("Empty(E1_APRVENC)" ,'GREEN' , "Pendente")
oBrowse:AddLegend("E1_APRVENC == 'S'" ,'RED'   , "Aprovado")
oBrowse:AddLegend("E1_APRVENC == 'N'" ,'BLACK' , "Rejeitado")

SetKey (VK_F5  , {|| Processa({|lEnd|oBrowse:Refresh(.T.)},'Aprovacao Tit. a Receber','Selecionando Titulos...',.T.)})
SetKey (VK_F12 , {|| Processa({|lEnd|If(Pergunte(cPerg,.T.),Eval({||oBrowse:SetFilterDefault("@"+AprFinQry()),oBrowse:Refresh(.T.)}),)},'Aprovacao Tit. a Receber','Selecionando Titulos...',.T.)})

oBrowse:Activate()

SetKey (VK_F5  , bKeyF5)
SetKey (VK_F12 , bKeyF12)

Return

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ MenuDef  ³ Autor ³ Fernando Nogueira       ³Data³14/06/2016³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Definicoes de Menu                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±*/
Static Function MenuDef()

	Local aRotina := {} 
        
    //Adicionando opcoes
    ADD OPTION aRotina Title 'Pesquisar'  ACTION 'PesqBrw'                              OPERATION 1 ACCESS 0 
	
	// Somente quem pertence ao Grupo de Administrador e Coordenador de Credito
	If aScan(PswRet(1)[1][10],'000000') <> 0 .Or. aScan(PswRet(1)[1][10],'000074') <> 0
		ADD OPTION aRotina TITLE "Aprovar"    ACTION 'StaticCall(AprovVencto,ConfApr)'	OPERATION 2 ACCESS 0
		ADD OPTION aRotina TITLE "Rejeitar"   ACTION 'StaticCall(AprovVencto,ConfRej)'	OPERATION 2 ACCESS 0
	Endif
	
	ADD OPTION aRotina TITLE "Visualizar" ACTION 'VIEWDEF.AprovVencto'                  OPERATION 2 ACCESS 0 
 
Return aRotina

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ ModelDef ³ Autor ³ Fernando Nogueira       ³Data³14/06/2016³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Cricao do Modelo                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±*/
Static Function ModelDef()

Local oModel     := Nil
Local oStructSE1 := FWFormStruct(1, "SE1")
 
//Instanciando o modelo, nao deve ser o mesmo nome da funcao
oModel := MPFormModel():New("AprFin",/*bPre*/, /*bPos*/,/*bCommit*/,/*bCancel*/) 
 
//Atribuindo formularios para o modelo
oModel:AddFields("FORMSE1",/*cOwner*/,oStructSE1)
 
//Setando a chave primaria da rotina
oModel:SetPrimaryKey({'E1_FILIAL','E1_PREFIXO','E1_NUM','E1_PARCELA','E1_TIPO'})
 
//Adicionando descricao ao modelo
oModel:SetDescription('Modelo Aprovacao Tit. a Receber')
 
//Setando a descricao do formulário
oModel:GetModel("FORMSE1"):SetDescription("Formulario Aprovacao Tit. a Receber")
Return oModel

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ ViewDef  ³ Autor ³ Fernando Nogueira       ³Data³14/06/2016³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Cricao da Visao                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±*/
Static Function ViewDef()
//Criação do objeto do modelo de dados da Interface do Cadastro de Autor/Interprete
Local oModel := FWLoadModel("AprovVencto")
 
//Criação da estrutura de dados utilizada na interface do cadastro de Autor
Local oStructSE1 := FWFormStruct(2,"SE1")  //pode se usar um terceiro parametro para filtrar os campos exibidos { |cCampo| cCampo $ 'SBM_NOME|SBM_DTAFAL|'}
 
//Criando oView como nulo
Local oView := Nil
 
//Criando a view que será o retorno da função e setando o modelo da rotina
oView := FWFormView():New()
oView:SetModel(oModel)
 
//Atribuindo formularios para interface
oView:AddField("VIEW_SE1", oStructSE1, "FORMSE1")
 
//Criando um container com nome tela com 100%
oView:CreateHorizontalBox("TELA",100)
 
//Colocando titulo do formulario
oView:EnableTitleView('VIEW_SE1', 'Titulos a Receber' )  
 
//Forca o fechamento da janela na confirmacao
oView:SetCloseOnOk({||.T.})
 
//O formulario da interface sera colocado dentro do container
oView:SetOwnerView("VIEW_SE1","TELA")
Return oView

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³AprFinQry ³ Autor ³ Fernando Nogueira       ³Data³14/06/2016³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Retorna expressao do filtro                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±*/
Static Function AprFinQry()
Local cQuery := ''

cQuery  := "E1_FILIAL = '"+xFilial('SE1')+"' "
cQuery  += " AND E1_SALDO > 0 "
If MV_PAR01 == 1
	cQuery  += " AND E1_APRVENC = ' ' "
ElseIF MV_PAR01 == 2
	cQuery  += " AND E1_APRVENC = 'S' "
ElseIF MV_PAR01 == 3
	cQuery  += " AND E1_APRVENC = 'N' "

Endif
cQuery  += " AND E1_VENCAPR <> ' ' "

Return(cQuery)

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ ConfApr  ³ Autor ³ Fernando Nogueira       ³Data³23/02/2017³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Confirma a Aprovacao da Data                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±*/
Static Function ConfApr()

Local lEnd := .F.
Local cMarca   	:= oBrowse:cMark
Local cAliasSE1	:= GetNextAlias()

Private _x_oProcess

BeginSql Alias cAliasSE1
	SELECT R_E_C_N_O_, E1_VENCAPR FROM %table:SE1% SE1
	WHERE E1_FILIAL = %xFilial:SE1%
		AND E1_APRVENC <> 'S'
		AND E1_X_OK = %exp:cMarca%
		AND SE1.%NotDel%
EndSql

dbSelectArea(cAliasSE1)
(cAliasSE1)->(DbGoTop())

If (cAliasSE1)->(Eof())
	ApMsgInfo("Nenhum Item para ser Aprovado.")
ElseIf MsgNoYes("Confirma a Aprovação do(s) Item(ns) Selecionados?")
	_x_oProcess := MsNewProcess():New({|lEnd| xConfApr(lEnd)},"Processando...","Processando Aprovações...",.T.)
	_x_oProcess:Activate()
	ApMsgInfo("Processo Finalizado.")
	oBrowse:SetFilterDefault("@"+AprFinQry())
	oBrowse:Refresh(.T.)
Endif

Return


/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ xConfApr ³ Autor ³ Fernando Nogueira       ³Data³20/06/2016³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Processo para a Confirmacao de Aprovacao da Data           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±*/
Static Function xConfApr(lEnd)

Local cAliasSE1	:= GetNextAlias()
Local cMarca   	:= oBrowse:cMark
Local aValues	:= {}

BeginSql Alias cAliasSE1
	SELECT ROW_NUMBER() OVER(ORDER BY R_E_C_N_O_) AS Row,R_E_C_N_O_, E1_VENCAPR FROM %table:SE1% SE1
	WHERE E1_FILIAL = %xFilial:SE1%
		AND E1_APRVENC <> 'S'
		AND E1_X_OK = %exp:cMarca%
		AND SE1.%NotDel%
	ORDER BY Row
EndSql

dbSelectArea("SE1")
dbSetOrder(01)

dbSelectArea(cAliasSE1)
(cAliasSE1)->(dbGoBottom())

_x_oProcess:SetRegua1((cAliasSE1)->Row)
_x_oProcess:SetRegua2((cAliasSE1)->Row)

(cAliasSE1)->(DbGoTop())

While !(cAliasSE1)->(Eof())
	_x_oProcess:IncRegua1("Processando aprovação...")
	_x_oProcess:IncRegua2()

	SE1->(dbGoTo((cAliasSE1)->R_E_C_N_O_))
	
	If SE1->(RecLock("SE1",.F.)) 
		If SE1->E1_SALDO > 0
			SE1->E1_APRVENC := 'S'
			SE1->E1_VENCTO  := SE1->E1_VENCAPR
			SE1->E1_VENCREA := DataValida(SE1->E1_VENCAPR,.T.)
			SE1->E1_X_OK    := ''
		Endif
		
		SE1->(MsUnlock())
	Endif
	
	(cAliasSE1)->(dbSkip())
End

Return

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ ConfRej  ³ Autor ³ Fernando Nogueira       ³Data³20/03/2017³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Confirma a Rejeicao da Data                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±*/
Static Function ConfRej()

Local lEnd := .F.
Local cMarca   	:= oBrowse:cMark
Local cAliasSE1	:= GetNextAlias()

Private _x_oProcess

BeginSql Alias cAliasSE1
	SELECT R_E_C_N_O_, E1_VENCAPR FROM %table:SE1% SE1
	WHERE E1_FILIAL = %xFilial:SE1%
		AND E1_APRVENC = ' '
		AND E1_X_OK = %exp:cMarca%
		AND SE1.%NotDel%
EndSql

dbSelectArea(cAliasSE1)
(cAliasSE1)->(DbGoTop())

If (cAliasSE1)->(Eof())
	ApMsgInfo("Nenhum Item para ser Rejeitado.")
ElseIf MsgNoYes("Confirma a Rejeição do(s) Item(ns) Selecionados?")
	_x_oProcess := MsNewProcess():New({|lEnd| xConfRej(lEnd)},"Processando...","Processando Rejeições...",.T.)
	_x_oProcess:Activate()
	ApMsgInfo("Processo Finalizado.")
	oBrowse:SetFilterDefault("@"+AprFinQry())
	oBrowse:Refresh(.T.)
Endif

Return


/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ xConfRej ³ Autor ³ Fernando Nogueira       ³Data³20/03/2017³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Processo para a Confirmacao de Rejeicao da Data            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±*/
Static Function xConfRej(lEnd)

Local cAliasSE1	:= GetNextAlias()
Local cMarca   	:= oBrowse:cMark
Local aValues	:= {}

BeginSql Alias cAliasSE1
	SELECT ROW_NUMBER() OVER(ORDER BY R_E_C_N_O_) AS Row,R_E_C_N_O_, E1_VENCAPR FROM %table:SE1% SE1
	WHERE E1_FILIAL = %xFilial:SE1%
		AND E1_APRVENC = ' '
		AND E1_X_OK = %exp:cMarca%
		AND SE1.%NotDel%
	ORDER BY Row
EndSql

dbSelectArea("SE1")
dbSetOrder(01)

dbSelectArea(cAliasSE1)
(cAliasSE1)->(dbGoBottom())

_x_oProcess:SetRegua1((cAliasSE1)->Row)
_x_oProcess:SetRegua2((cAliasSE1)->Row)

(cAliasSE1)->(DbGoTop())

While !(cAliasSE1)->(Eof())
	_x_oProcess:IncRegua1("Processando rejeição...")
	_x_oProcess:IncRegua2()

	SE1->(dbGoTo((cAliasSE1)->R_E_C_N_O_))
	
	If SE1->(RecLock("SE1",.F.)) 
		If SE1->E1_SALDO > 0
			SE1->E1_APRVENC := 'N'
		Endif
		
		SE1->(MsUnlock())
	Endif
	
	(cAliasSE1)->(dbSkip())
End

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AjustaSX1 ºAutor  ³ Fernando Nogueira  º Data ³ 04/07/2016  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Cria as perguntas do programa no dicionario de perguntas    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function AjustaSX1(cPerg)

	Local aAreaAnt := GetArea()
	Local aRegs    := {}
	Local aHelpPor := {}
	Local aHelpEng := {}
	Local aHelpSpa := {}
	
	aHelpPor := {"Data Inicial"}
	aHelpPor := {"Status","- Pendentes de Aprovacao","- Aprovados","- Rejeitados","- Todos"}
	PutSX1(cPerg,"01","Status ?","","","mv_ch1","N",1,0,1,"C","NaoVazio","","","","mv_par01","Pendentes","Pendentes","Pendentes","","Aprovados","Aprovados","Aprovados","Rejeitados","Rejeitados","Rejeitados","Todos","Todos","Todos","","","",aHelpPor,aHelpEng,aHelpSpa)
	RestArea(aAreaAnt)

Return Nil