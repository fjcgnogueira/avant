#Include 'Protheus.ch'
#Include 'Totvs.ch'

User Function PANELCLI()

Local   cAlias      := 'SA1'
Private aRotina     := {}
Private cCadastro   := 'Painel Cliente'

	AADD(aRotina,{"Pesquisar"         ,"AxPesqui",0,1})
	AADD(aRotina,{"Visualizar"        ,"AxVisual",0,2})
	AADD(aRotina,{"Posicao Cliente"   ,"a450F4Con()",0,7})
	AADD(aRotina,{"Historico Cliente" ,"U_LISTATIT(SA1->A1_FILIAL, SA1->A1_COD, SA1->A1_LOJA, SA1->A1_NREDUZ)",0,7})
	
	DBSelectArea('SA1')
		SA1->(DBSetOrder(1))
		
	MBrowse(6,1,22,75,cAlias)

Return