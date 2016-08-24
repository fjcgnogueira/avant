#INCLUDE "PROTHEUS.CH"           
#INCLUDE "TbiConn.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ PedSched º Autor ³ Fernando Nogueira  º Data ³ 23/08/2016  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Integracao de Pedido de Vendas via Schedule                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Avant                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function PedSched(aParam)

Local aTabelas   := {"SA1", "SC5", "SC6", "SC9", "SD2", "SF2", "SF4", "SF5", "SFM", "SB1", "SB2", "SB9","ZZI","ZIA","SZ3","SZ4"}
Local cMensagem  := ""
Local cDocumen   := ""
Local cNextAlias := GetNextAlias()

Private aPVlNFs  := {}

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³aParam     |  [01]   |  [02]  |
	//³           | Empresa | Filial |
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
RpcClearEnv()
RPCSetType(3)
RpcSetEnv(aParam[1], aParam[2], NIL, NIL, "FAT", NIL, aTabelas)

BeginSql alias cNextAlias

	SELECT Z3_NPEDWEB FROM %table:SZ3% SZ3
	INNER JOIN %table:SZ4% SZ4 ON Z3_NPEDWEB = Z4_NUMPEDW AND SZ4.%notDel%
	WHERE SZ3.%notDel% AND Z3_FILIAL = %xfilial:SZ3% AND Z3_STATUS = '2'
	GROUP BY Z3_NPEDWEB
	ORDER BY Z3_NPEDWEB

EndSql

// Gera as Notas Fiscais referentes aos Pedidos Liberados
While (cNextAlias)->(!EoF())

	cMensagem := ""
	cDocumen  := ""
	
	ConOut("["+DtoC(Date())+" "+Time()+"] [PedSched] Processando Pedido Web: "+AllTrim(cValToChar((cNextAlias)->Z3_NPEDWEB)))

	U_INTPEDIDO(aParam[1], aParam[2], AllTrim(cValToChar((cNextAlias)->Z3_NPEDWEB)), @cMensagem, @cDocumen, .F.)
	
	If !Empty(cMensagem)
		ConOut("["+DtoC(Date())+" "+Time()+"] [PedSched] "+cMensagem)
	Endif
	If !Empty(cDocumen)
		ConOut("["+DtoC(Date())+" "+Time()+"] [PedSched] "+cDocumen)
	Endif
	
	Sleep(20000)
	
	(cNextAlias)->(dbSkip())
End

(cNextAlias)->(DbCloseArea())

If Empty(cDocumen) .And. Empty(cMensagem)
	ConOut("["+DtoC(Date())+" "+Time()+"] [PedSched] Nenhum pedido a integrar")
Endif

RpcClearEnv()

Return