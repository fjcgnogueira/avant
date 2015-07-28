#Include "Protheus.Ch"           
#Include "TopConn.Ch"              
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ EnviaLaudo  º Autor ³ Fernando Nogueira  º Data ³28/07/2015º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Envia por e-mail o Laudo do Sota         				  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Avant                   	                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÏÍÍÍÑÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAnalista Resp.³  Data  ³ Manutencao Efetuada                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º              ³  /  /  ³                                               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function EnviaLaudo()

Local cAnexo   := '\web\ws\trocas\'+SF1->F1_NUMTRC+'\troca_'+SF1->F1_NUMTRC+'.doc'
Local cArquivo := "\MODELOS\LAUDO_SOTA.HTM"
Local cPara    := AllTrim(Posicione("SA1",1,xFilial("SA1")+SF1->F1_FORNECE+SF1->F1_LOJA,"A1_EMAIL"))

SZH->(dbSetOrder(1))

If SZH->(dbSeek(xFilial()+SF1->F1_NUMTRC))

	If File(cAnexo)
		If !Empty(cPara)
			oProcess := TWFProcess():New("LAUDO_TRC","LAUDO DE TROCA")
			oProcess:NewTask("Enviando Laudo",cArquivo)
			oHTML := oProcess:oHTML
			oHtml:ValByName("cTroca", SF1->F1_NUMTRC)
			oHtml:ValByName("cNota" , SF1->F1_DOC+"/"+SF1->F1_SERIE)
			oProcess:cSubject := "[SOTA Avant] Laudo de Trocas "+SF1->F1_NUMTRC
			oProcess:USerSiga := "000000"
			oProcess:cTo  := cPara
			oProcess:cCC  := "sota@avantled.com.br"
			oProcess:cBCC := "fernando.nogueira@avantled.com.br;tecnologia@avantled.com.br"
			oProcess:AttachFile(cAnexo)
			oProcess:Start()
			oProcess:Finish()
			
			ApMsgInfo("Laudo da Troca "+SF1->F1_NUMTRC+" enviado.")
		Else
			ApMsgInfo("Cliente "+SF1->F1_FORNECE+"/"+SF1->F1_LOJA+" ("+AllTrim(SA1->A1_NOME)+")."+Chr(13)+Chr(10)+"Sem e-mail cadastrado.")
		Endif
	Else
		ApMsgInfo("Laudo da Troca "+SF1->F1_NUMTRC+" não encontrado.")
	Endif
Else
	ApMsgInfo("Essa nota não é de Troca!")
Endif	

Return