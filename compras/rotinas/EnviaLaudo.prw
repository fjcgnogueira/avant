#Include "Protheus.Ch"
#Include "TopConn.Ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � EnviaLaudo  � Autor � Fernando Nogueira  � Data �28/07/2015���
�������������������������������������������������������������������������͹��
���Descri��o � Envia por e-mail o Laudo do Sota         				  ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico Avant                   	                      ���
�������������������������������������������������������������������������͹��
���Analista Resp.�  Data  � Manutencao Efetuada                           ���
�������������������������������������������������������������������������͹��
���              �  /  /  �                                               ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function EnviaLaudo()

Local cAnexo   := '\web\ws\trocas\'+SF1->F1_NUMTRC+'\troca_'+SF1->F1_NUMTRC+'.doc'
Local cArquivo := "\MODELOS\LAUDO_SOTA.HTM"
Local cPara    := AllTrim(Posicione("SA1",1,xFilial("SA1")+SF1->F1_FORNECE+SF1->F1_LOJA,"A1_EMAIL"))

SZH->(dbSetOrder(1))

If SZH->(dbSeek(xFilial()+SF1->F1_NUMTRC))

	If File(cAnexo)
		If !Empty(cPara)
			If MsgNoYes("Confirma envio do laudo para o cliente?")
				oProcess := TWFProcess():New("LAUDO_TRC","LAUDO DE TROCA")
				oProcess:NewTask("Enviando Laudo",cArquivo)
				oHTML := oProcess:oHTML
				oHtml:ValByName("cTroca", SF1->F1_NUMTRC)
				oHtml:ValByName("cNota" , SF1->F1_DOC+"/"+SF1->F1_SERIE)
				oProcess:cSubject := "[SOTA Avant] Laudo de Trocas "+SF1->F1_NUMTRC
				oProcess:USerSiga := "000000"
				oProcess:cTo  := cPara
				oProcess:cCC  := "sota@avantlux.com.br"
				oProcess:cBCC := "fernando.nogueira@avantlux.com.br,tecnologia@avantlux.com.br"
				oProcess:AttachFile(cAnexo)
				oProcess:Start()
				oProcess:Finish()

				ApMsgInfo("Laudo da Troca "+SF1->F1_NUMTRC+" enviado.")
			Endif
		Else
			ApMsgInfo("Cliente "+SF1->F1_FORNECE+"/"+SF1->F1_LOJA+" ("+AllTrim(SA1->A1_NOME)+")."+Chr(13)+Chr(10)+"Sem e-mail cadastrado.")
		Endif
	Else
		ApMsgInfo("Laudo da Troca "+SF1->F1_NUMTRC+" n�o encontrado.")
	Endif
Else
	ApMsgInfo("Essa nota n�o � de Troca!")
Endif

Return
