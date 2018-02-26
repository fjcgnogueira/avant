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
User Function EmailJSON(cEmail,lAviso)

Local cChave     := GetMv("ES_CHVHIPP")
Local cUrl       := "https://api.hippoapi.com/v3/more/json/"+cChave+"/"+AllTrim(cEmail)
Local cGetParams := ""
Local nTimeOut   := 200
Local aHeadStr   := {"Content-Type: application/json"}
Local cHeaderGet := ""
Local cRetorno   := ""
Local oObjJson   := Nil

Default lAviso := .T.

cRetorno := HttpGet(cUrl,cGetParams,nTimeOut,aHeadStr,@cHeaderGet)

If !FwJsonDeserialize(cRetorno,@oObjJson)
	MsgStop("Erro no processamento do Json")
	Return .T.
Endif

If AllTrim(oObjJson:EmailVerification:MailBoxVerification:Result) = "Bad"
	If lAviso
		Aviso('E-mail',"Email "+AllTrim(cEmail)+" inexistente.",{'Ok'})
	Endif
	ConOut("Email "+AllTrim(cEmail)+" inexistente.")
	Return .F.
Endif

Return .T.
