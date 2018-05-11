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
Class TstObj
data cData1
data dData2
data aArray1
Method New()
EndClass

Method New() Class TstObj
self:cData1 := "Valor caracter"
self:dData2 := CTOD("01/01/01")
self:aArray1 :={ "Valor array1","Valor array2"}
Return

User Function tstled()
Local oObj := TstObj():New()
Local cJson := FWJsonSerialize(oObj,.T.,.T.)
MsgStop(cJson)
Return


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