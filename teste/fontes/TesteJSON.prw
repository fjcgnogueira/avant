#Include "Totvs.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � TesteJSON � Autor � Fernando Nogueira  � Data � 21/08/2017 ���
�������������������������������������������������������������������������͹��
���Desc.     � Teste de comunicacao de API JSON                           ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico Avant                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function TesteJSON()

Local cUrl       := "http://api1.27hub.com/api/emh/a/v2?k=261C7C92&e=acarol@eletricavivalux.com.br"
Local cGetParams := ""
Local nTimeOut   := 200
Local aHeadStr   := {"Content-Type: application/json"}
Local cHeaderGet := ""
Local cRetorno   := ""
Local oObjJson   := Nil

cRetorno := HttpGet(cUrl,cGetParams,nTimeOut,aHeadStr,@cHeaderGet)

If !FwJsonDeserialize(cRetorno,@oObjJson)
	MsgStop("Erro no processamento do Json")
	Return
Endif 

MsgInfo("Resultado "+oObjJson:result+", raz�o: "+oObjJson:reason)

Return