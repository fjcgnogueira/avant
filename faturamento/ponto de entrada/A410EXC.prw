#INCLUDE "Protheus.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ A410EXC  º Autor ³ Fernando Nogueira  º Data ³ 01/09/2016 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Ponto de Entrada para validar se deve excluir o Pedido de º±±
±±º          ³ Vendas                                                    º±±
±±º          ³ Chamado 003947                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Avant                                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function A410EXC()

Local cAliasSZ3 := GetNextAlias()
Local nPedWeb   := SC5->C5_PEDWEB
Local aArea     := GetArea()
Local lReturn   := .T.

If nPedWeb > 0

	BeginSQL Alias cAliasSZ3
	
		SELECT DISTINCT Z3_NPEDWEB,C5_NUM FROM %Table:SZ3% SZ3
		INNER JOIN %Table:SC5% SC5 ON Z3_FILIAL = C5_FILIAL AND Z3_NPEDWEB = C5_PEDWEB AND SC5.%NotDel%
		WHERE SZ3.%NotDel% AND Z3_FILIAL = %xFilial:SZ3% AND Z3_NPEDWEB = %Exp:nPedWeb%
		GROUP BY Z3_NPEDWEB,C5_NUM HAVING COUNT(*) > 1
		
	EndSQL
	
	dbSelectArea(cAliasSZ3)
	(cAliasSZ3)->(dbGoTop())
	
	If !(cAliasSZ3)->(Eof())
		ApMsgInfo('Exclusão não permitida, pedido Web Duplicado, Informar o Depto de TI')
		lReturn := .F.
	Endif
	
	(cAliasSZ3)->(DbCloseArea())
	
	RestArea(aArea)
	
Endif

Return lReturn