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

Local cUrl       := "http://numbersapi.com/random/trivia"
Local cGetParams := ""
Local nTimeOut   := 200
Local aHeadStr   := {"Content-Type: application/json"}
Local cHeaderGet := ""
Local cRetorno   := ""
Local oObjJson   := Nil

cRetorno := HttpGet(cUrl,cGetParams,nTimeOut,aHeadStr,@cHeaderGet)

MsgInfo(cRetorno)

If !FwJsonDeserialize(cRetorno,@oObjJson)
	MsgStop("Erro no processamento do Json")
	Return
Endif 

MsgInfo("O valor "+oObjJson:type+" para o n�mero "+AllTrim(Str(oObjJson:number))+" equivale: "+oObjJson:text)

Return