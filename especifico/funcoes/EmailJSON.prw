#Include "Totvs.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � EmailJSON � Autor � Fernando Nogueira  � Data � 22/08/2017 ���
�������������������������������������������������������������������������͹��
���Desc.     � Valida��o de E-mail pela API JSON do emailhippo            ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico Avant                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function EmailJSON(cEmail)

Local cUrl       := "http://api1.27hub.com/api/emh/a/v2?k=261C7C92&e="+AllTrim(cEmail)
Local cGetParams := ""
Local nTimeOut   := 200
Local aHeadStr   := {"Content-Type: application/json"}
Local cHeaderGet := ""
Local cRetorno   := ""
Local oObjJson   := Nil

cRetorno := HttpGet(cUrl,cGetParams,nTimeOut,aHeadStr,@cHeaderGet)

If !FwJsonDeserialize(cRetorno,@oObjJson)
	MsgStop("Erro no processamento do Json")
	Return .T.
Endif 

If AllTrim(oObjJson:result) = "Bad"
	Aviso('E-mail',"E-mail inexistente.",{'Ok'})
	Return .F.
Endif

Return .T.