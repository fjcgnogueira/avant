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

Local cPara    := "rogerio.machado@avantled.com.br"
//Local cBCC     := "rogerio.machado@avantled.com.br"
Local cAssunto := "Pedido em transporte"

	
cLog := "<html><body>"
cLog += "<br>"
cLog += "<div style='text-align: center;'><img style='width: 339px; height: 74px;' src='http://www.avantled.com.br/BI/acompanhe.png'>"
cLog += "<br><br><br>"
cLog += "<img style='width: 140px; height: 122px;' src='http://www.avantled.com.br/BI/truck.png'><br>"
cLog += "<br><br>"
cLog += "<p align=”center”> DATA:  </center></div>" 
cLog += "<br><br>"
cLog += "<p align=”Left”> Cliente:  Loja:  </p>
cLog += "<p align=”Left”> Endere็o:  </p>
cLog += "<p align=”Left”> CEP:  </p>
cLog += "<p align=”Left”> UF:  </p>
cLog += "<p align=”Left”> Telefone:  </p>
cLog += "<br><br>"
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

		U_MHDEnvMail(cPara, "", "", cAssunto, cLog, "")
		
		MsgInfo("OK")
	
Return