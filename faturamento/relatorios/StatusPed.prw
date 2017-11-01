#INCLUDE "PROTHEUS.CH"
#INCLUDE "Totvs.ch"
#INCLUDE "FILEIO.ch"
#INCLUDE "TbiConn.ch"
#INCLUDE "AP5MAIL.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ STATUSPEDบ Autor ณ Rogerio Machado    บ Data ณ  12/08/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Relatorio de acompanhamento de pedido.                     บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico Avant                                           บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function STATUSPED(aParam)

	Local _cPara    := ""
	Local _cBCC     := "rogerio.machado@avantlux.com.br,tecnologia@avantlux.com.br"
	Local _cAssunto := "AVANT - Pedido na Transportadora"
	Local cAlias1   := GetNextAlias()
	Local cNota    := ""
	Local cData    := ""
	Local cCliente := ""
	Local cLoja    := ""
	Local oProcess  := Nil
	Local cArquivo  := "\MODELOS\Na_Transp.html"
	Local aTabelas  := {"GW1","SA1","GWN"}
	
	
	RpcClearEnv()
	RPCSetType(3)
	RpcSetEnv(aParam[1], aParam[2], NIL, NIL, "FIN", NIL, aTabelas)

	Prepare Environment EMPRESA '01' FILIAL '010104'
	

	BeginSql alias cAlias1

		SELECT GW1_NRDC AS Nota, GW1_DTEMIS AS Data, A1_NOME Cliente, A1_LOJA Loja, A1_EMAIL Email, GW1_XWFPWD Enviado FROM %table:GW1% AS GW1
		INNER JOIN %table:GWN% AS GWN ON GW1_FILIAL = GWN_FILIAL AND GW1_NRROM = GWN_NRROM AND GWN.%notDel%
		INNER JOIN %table:SA1% AS SA1 ON GW1_CDDEST = A1_CGC AND SA1.%notDel%
		WHERE GW1.%notDel%
		AND GW1_NRROM <> '' AND GWN_SIT = '3'
		AND GW1_XWFPWD = 'N'

	EndSql
	
	(cAlias1)->(DbGoTop())

	While (cAlias1)->(!Eof())

		cCliente  := (cAlias1)->Cliente
		cLoja     := (cAlias1)->Loja
		cNota     := (cAlias1)->Nota
		_cPara    := (cAlias1)->Email
		_cAssunto := "AVANT - Pedido na Transportadora - NF: " +cNota
		
		oProcess := TWFProcess():New("STATUSPED","PEDIDO NA TRANSPORTADORA")
		oProcess:NewTask("Relacao de Pedidos enviados para a transportadora",cArquivo)
		oHTML := oProcess:oHTML

		aAdd((oHTML:ValByName("aR.cCli")) , (cAlias1)->Cliente)
		aAdd((oHTML:ValByName("aR.cLoj")) , (cAlias1)->Loja)
		aAdd((oHTML:ValByName("aR.cNota")), (cAlias1)->Nota)

		oProcess:cSubject := _cAssunto

		oProcess:USerSiga := "000000"
		oProcess:cTo      := _cPara
		oProcess:cBCC     := _cBCC
	
		oProcess:Start()
		oProcess:Finish()

		
		GW1->(DBSetOrder(8))
		GW1->(DbGoTop())
		GW1->(DBSeek(xFilial("GW1")+(cAlias1)->Nota))

		If GW1->(RecLock("GW1",.F.))
			GW1->GW1_XWFPWD := "S"
		Endif
		GW1->(MsUnlock())
		

		(cAlias1)->(dbSkip())

	EndDo

	RESET ENVIRONMENT

Return
