#INCLUDE "Protheus.CH"

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

User Function STATUSPED()

	Local cPara    := ""
	Local cBCC     := "rogerio.machado@avantled.com.br"
	Local cAssunto := "AVANT - Pedido na Transportadora"
	Local cNota    := ""
	Local cData    := ""
	Local cCliente := ""
	Local cLoja    := ""
	//Local cEnd     := ""
	//Local cCEP     := ""
	//Local cUF      := ""
	//Local cTel     := ""
	Local cPara    := ""



	BeginSql alias 'TRB'
	
				SELECT DISTINCT F2_DOC Nota, F2_EXPEDID Data, A1_NOME Cliente, A1_LOJA Loja, A1_EMAIL Email
				FROM %table:SF2% SF2
				INNER JOIN %table:SA1% SA1 ON F2_CLIENTE+F2_LOJA = A1_COD+A1_LOJA AND SA1.%notDel%
				INNER JOIN %table:SD2% SD2 ON F2_FILIAL = D2_FILIAL AND F2_DOC+F2_SERIE = D2_DOC+D2_SERIE AND SD2.%notDel%
				INNER JOIN %table:SF4% SF4 ON D2_FILIAL = F4_FILIAL AND D2_TES = F4_CODIGO AND SF4.%notDel%
				WHERE SF2.%notDel% AND  F2_FILIAL = '010104' AND F2_EXPEDID <> '' AND F2_X_WFPWD = ''
							
	EndSql

	While TRB->(!Eof())	
			
		cNota    := TRB->Nota
		cData    := LEFT(TRB->Data,2) +"/"+ SubStr(TRB->Data,3,2) +"/"+ RIGHT(TRB->Data,4) 
		cCliente := TRB->Cliente
		cLoja    := TRB->Loja
		//cEnd	 := TRB->End
		//cCEP     := TRB->CEP
		//cUF      := TRB->UF
		//cTel     := TRB->Tel
		cPara    := TRB->Email

	
		cLog := "<html><body>"
		cLog += "<br>"
		cLog += "<div style='text-align: center;'><img style='width: 339px; height: 74px;' src='http://www.avantled.com.br/BI/acompanhe.png'>"
		cLog += "<br><br>"
		cLog += "<img style='width: 140px; height: 122px;' src='http://www.avantled.com.br/BI/truck.png'><br>"
		cLog += "<br><br>"
		cLog += "<p align=”center”> <b> Pedido na transportadora </b> </center></div>" 
		cLog += "<br><br>" 
		cLog += "<p align=”Left”> <b> DATA: </b>"+ cData 
		cLog += "<br><br>"
		cLog += "<p align=”Left”> <b> Cliente: </b>"+ cCliente 
		cLog += "<br> <b> Loja: </b>" + cLoja 
		cLog += "<br> <b> Nota: </b>" + cNota + "</p>"
		//cLog += "<p align=”Left”> Endere็o: " + cEnd + "</p>"
		//cLog += "<p align=”Left”> CEP: "+ cCEP + "</p>"
		//cLog += "<p align=”Left”> UF: " + cUF + "</p>"
		//cLog += "<p align=”Left”> Telefone: " + cTel + "</p>"
		//cLog += "<br><br>"
		cLog += "<p align=”Left”> Caso jแ tenha recebido o(s) produto(s), pedimos que desconsidere esta mensagem.  </p>
		cLog += "<br><br>"
		cLog += "<p align=”Left”> <b> Polํtica de entrega da Avant </b> </p>
		cLog += "<p align=”Left”> - Em caso de Avarias, Desacordo com o Pedido, etc. gentileza anotar no Comprovante de Entrega o motivo da recusa.  </p>
		cLog += "<p align=”Left”> - Recuse a entrega se a embalagem estiver aberta ou danificada.  </p>
		cLog += "<p align=”Left”> - Ao receber suas mercadorias assinar, carimbar e datar o Comprovante de Entrega.  </p>
		cLog += "<br><br>"
		cLog += "<p align=”Left”> <b> Para garantir a satisfa็ใo da sua compra, recomendamos:  </b> </p>
		cLog += "<p align=”Left”> - Preserve a embalagem do(s) produto(s) e o DANFE (Documento Auxiliar da Nota Fiscal Eletr๔nica) do pedido. Em caso de troca, eles serใo necessแrios.  </p>
		cLog += "<br>"
		cLog += "</body>"
		cLog += "</html>"
		
		
		U_MHDEnvMail(cPara, cBCC, "", cAssunto, cLog, "")
		
		SF2->(DBSetOrder(1))
		SF2->(DbGoTop())
		SF2->(DBSeek(xFilial("SF2")+TRB->Nota))
		
		If SF2->(RecLock("SF2",.F.))
			SF2->F2_X_WFPWD := "S"
		Endif
		SF2->(MsUnlock())
				
		TRB->(dbSkip())
		
	EndDo
		
		
Return