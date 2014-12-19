#INCLUDE "PROTHEUS.CH"           
#INCLUDE "Totvs.ch"
#INCLUDE "FILEIO.ch"
#INCLUDE "TbiConn.ch"
#INCLUDE "AP5MAIL.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ ProcArq   ³ Autor ³ Rogerio Machado    ³ Data  ³ 05/08/14 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Envia E-mail de pedidos nao integrados                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function PedNaoInt()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis utilizadas na leitura do arquivo EDI        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cLog     	 := "<html><body>"
Local cFim       := "</body></html>"
Local cAssunto   := ""
Private _cFilial    := ""

Prepare Environment EMPRESA '01' FILIAL '010104'

BeginSql alias 'TRB'

	SELECT SZ3.Z3_FILIAL, SZ3.Z3_NPEDWEB, SA1.A1_COD, SA1.A1_LOJA, SA1.A1_NOME, SA3.A3_NOME, SA3.A3_EMAIL, SZ3.Z3_EMISSAO  
	FROM %table:SZ3% SZ3		
	
	INNER JOIN %table:SA1% SA1 ON
		SZ3.Z3_CNPJ = SA1.A1_CGC AND SA1.%notDel%
	    
	INNER JOIN %table:SA3% SA3 ON
		SZ3.Z3_VEND = SA3.A3_COD AND SA3.%notDel%
		

	//WHERE SZ3.%notDel% AND SZ3.Z3_STATUS = '2' AND SZ3.Z3_EMISSAO = '20140910' AND SZ3.Z3_NPEDWEB NOT IN (
	WHERE SZ3.%notDel% AND SZ3.Z3_STATUS = '2' AND SZ3.Z3_EMISSAO = CONVERT(CHAR(10), GETDATE(),112) AND SZ3.Z3_NPEDWEB NOT IN (	
	SELECT SC5.C5_PEDWEB FROM %table:SC5% SC5 WHERE SC5.%notDel% AND SC5.C5_EMISSAO = CONVERT(CHAR(10), GETDATE(),112))	

EndSql


While (!Eof('TRB'))

		cPara := "elir.ribeiro@avantled.com.br; rogerio.machado@avantled.com.br; fernando.nogueira@avantled.com.br; ewerson.silva@avantled.com.br; "
		//cPara := "rogerio.machado@avantled.com.br; "
		cPara += TRB->A3_EMAIL
		
		cLog := "<html><body>"
		cLog += "<p align='center' class='style1'><strong>AVISO  -  PEDIDO WEB NÃO ENVIADO PARA A AVANT</strong></p>"
		cLog += "<p <strong>Pedido Web: </strong>"+ CValToChar(TRB->Z3_NPEDWEB) + "</p>"
		cLog += "<p <strong>Data: </strong>" +RIGHT(TRB->Z3_EMISSAO,2)+ "/" +SUBSTR(TRB->Z3_EMISSAO,5,2)+ "/" +LEFT(TRB->Z3_EMISSAO,4)+ "</p>"
		cLog += "<p <strong>Cliente/Loja: </strong>"+CValToChar(TRB->A1_COD) +' / '+CValToChar(TRB->A1_LOJA) +' - '+ CValToChar(TRB->A1_NOME)+"</p>"
		cLog += "<p <strong>Mensagem: </strong> Favor entrar em contato com nossos Analistas de IT. (11) 3355-2220</p>"
		cLog += "<p <strong>Observação: </strong> Se o seu pedido tem Desconto Especial, ele está parado na tela de aprovação do Wesley Pazini. Nesse caso, favor desconsiderar esse e-mail.</p>"
		
		cLog += cFim
		cAssunto := "Erro Pedido Web "+CValToChar(TRB->Z3_NPEDWEB)+ " não enviado para a Avant"
		U_MHDEnvMail(cPara, "", "", cAssunto, cLog, "")
		DbSkip()
		
End

RESET ENVIRONMENT
	
Return