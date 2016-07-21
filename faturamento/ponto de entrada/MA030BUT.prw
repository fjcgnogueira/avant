#include "TOTVS.ch"
#include "rwmake.ch"


User Function MA030BUT()

	Local aButtons := {}
	
	//aAdd(aBotao,{"Export_Fornec.",MsgInfo("Estou desenvolvendo estou..."), 0, 3})
	//aAdd(aBotao,{"Export_Vendedor.",MsgInfo("Estou desenvolvendo estou..."), 0, 3})
	aAdd(aButtons,{'BUDGETY',{|| U_AltCli()},'Consulta Alterações','Alterações'})

Return(aButtons)
