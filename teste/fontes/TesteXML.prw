#Include "Totvs.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � TesteXML  � Autor � Fernando Nogueira  � Data � 21/08/2017 ���
�������������������������������������������������������������������������͹��
���Desc.     � Teste de comunicacao de API XML                            ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico Avant                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function TesteXML()

Local cUrl       := "http://viacep.com.br/ws/01222000/xml"
Local cGetParams := ""
Local nTimeOut   := 200
Local aHeadStr   := {"Content-Type: application/xml"}
Local cHeaderGet := ""
Local cRetorno   := ""
Local oXml       := Nil
Local cErro      := ""
Local cAviso     := ""

cRetorno := HttpGet(cUrl,cGetParams,nTimeOut,aHeadStr,@cHeaderGet)

oXml := XmlParser(cRetorno,"_",@cErro,@cAviso)

If !Empty(cErro)
	MsgStop("Erro no processamento do Json")
	Return
Endif 

MsgInfo("O endere�o do CEP "+oXml:_XMLCEP:_CEP:TEXT+" � "+oXml:_XMLCEP:_LOGRADOURO:TEXT)

Return