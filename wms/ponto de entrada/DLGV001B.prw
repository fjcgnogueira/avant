#INCLUDE "PROTHEUS.CH"
#INCLUDE 'APVT100.CH'
#INCLUDE 'INKEY.CH'
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ DLGV001B º Autor ³ Fernando Nogueira  º Data ³ 21/07/2014  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de Entrada Antes da Confirmacao da Convocacao        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Avant                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function DLGV001B()

Local aArea      := GetArea()
Local cAlias1SDB := GetNextAlias()
Local cAlias2SDB := GetNextAlias()
Local cAliasDCF  := GetNextAlias()
Local cLocal     := SDB->DB_LOCAL
Local cItem      := SDB->DB_SERIE 
Local cTarefa    := ParamIXB[4]
Local cPedido    := ParamIXB[7]
Local lConvoca   := ParamIXB[8]
Local cFuncao    := AllTrim(ParamIXB[9])
Local aReturn    := {}

If lConvoca
	aReturn := {.T.}
Else
	aReturn := {.F.}
Endif

// Fernando Nogueira - Verifica se tem servico de separacao pendente para executar a conferencia
If lConvoca .And. cFuncao $ ('DLCONFEREN().DLAPANHE()')

	// Verifica se foi feita alguma separacao
	BeginSQL Alias cAlias1SDB
		SELECT * FROM SDB010 SDB
		WHERE SDB.%notDel%
			AND DB_FILIAL    = %Exp:xFilial("SDB")%
			AND DB_DOC       = %Exp:cPedido%
			AND DB_TAREFA    = '002' 
			AND DB_LOCAL     = %Exp:cLocal%
			AND DB_TIPO      = 'E' 
			AND DB_ESTORNO   = ' '
			AND DB_STATUS    = '1' 
	EndSQL

	(cAlias1SDB)->(dbGoTop())

	// Se a chamada for de apanhe
	If cFuncao == 'DLAPANHE()'
	
		If (cAlias1SDB)->(Eof()) .And. DLVTAviso("Apanhe","Pedido "+cPedido+CHR(13)+CHR(10)+"Item: "+cItem+CHR(13)+CHR(10)+"Continua Nesse?",{"Sim","Nao"}) <> 1
			aReturn  := {.F.}
			Return aReturn
		ElseIf !(cAlias1SDB)->(Eof())
		
			If DLVTAviso("Apanhe","Pedido "+cPedido+" Separado Parcial"+CHR(13)+CHR(10)+"Item: "+cItem+CHR(13)+CHR(10)+"Continua Nesse?",{"Sim","Nao"}) <> 1
				aReturn := {.F.}
			Else
				VtClear()
				
					@ 01,00 VTSay PadR("Depois de Separar", VTMaxCol())
					@ 02,00 VTSay PadR("Favor Agrupar na", VTMaxCol())	
					@ 03,00 VTSay PadR("Doca de Saida"   , VTMaxCol())
				
				VTPause()
				VTRead
			Endif
		Endif
	
	// Se a chamada for de conferencia
	ElseIf cFuncao == 'DLCONFEREN()' .And. !(cAlias1SDB)->(Eof())
	
		// Verifica se tem alguma execucao pendente
		BeginSQL Alias cAliasDCF
			SELECT * FROM DCF010 DCF
			WHERE DCF.%notDel%
				AND DCF_FILIAL   = %Exp:xFilial("DCF")%
				AND DCF_DOCTO    = %Exp:cPedido%
				AND DCF_LOCAL    = %Exp:cLocal%
				AND DCF_STSERV  <= '2'
		EndSQL
		
		(cAliasDCF)->(dbGoTop())
		
		If !(cAliasDCF)->(Eof())
		
			VtClear()
			
				@ 01,00 VTSay PadR("Pedido: "+AllTrim(cPedido), VTMaxCol())
				@ 02,00 VTSay PadR("Incompleto na" , VTMaxCol())
				@ 03,00 VTSay PadR("Execucao" , VTMaxCol())
			
			VTPause()
			VTRead
			
			aReturn := {.F.}
		
		Else	
			// Verifica se tem alguma separacao pendente
			BeginSQL Alias cAlias2SDB
				SELECT * FROM SDB010 SDB
				WHERE SDB.%notDel%
					AND DB_FILIAL    = %Exp:xFilial("SDB")%
					AND DB_DOC       = %Exp:cPedido%
					AND DB_TAREFA    = '002' 
					AND DB_LOCAL     = %Exp:cLocal%
					AND DB_TIPO      = 'E' 
					AND DB_ESTORNO   = ' '
					AND DB_STATUS    <> '1' 
			EndSQL
	
			(cAlias2SDB)->(dbGoTop())
			
			If !(cAlias2SDB)->(Eof())
	
				VtClear()
				
					@ 01,00 VTSay PadR("Pedido: "+AllTrim(cPedido), VTMaxCol())
					@ 02,00 VTSay PadR("Incompleto na" , VTMaxCol())
					@ 03,00 VTSay PadR("Separacao" , VTMaxCol())
				
				VTPause()
				VTRead
				
				aReturn := {.F.}
			Endif
			
			(cAlias2SDB)->(dbCloseArea())
		Endif
		
		(cAliasDCF)->(dbCloseArea())
	Endif
	
	(cAlias1SDB)->(dbCloseArea())	
Endif

RestArea(aArea)

Return aReturn