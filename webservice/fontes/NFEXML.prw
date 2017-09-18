#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"

User Function NFEXML()
Return Nil
/*
�����������������������������������������������������������������������������������
�����������������������������������������������������������������������������������
�������������������������������������������������������������������������������ͻ��
���Web Service � NFEXML        � Autor � Fernando Nogueira    � Data �18/09/2017���
�������������������������������������������������������������������������������͹��
���Descricao   � Chama a funcao NfeProcNfe para geracao de XML                  ���
�������������������������������������������������������������������������������͹��
���Uso         � Especifico AVANT.                                              ���
�������������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������������
�����������������������������������������������������������������������������������
*/
WSSERVICE NFEXML DESCRIPTION "Geracao de XML de NFE"
	WSDATA EmpCons		As String
	WSDATA FilCons		As String
	WSDATA NfeXML  		As String
	WSDATA NfeTime		As String
	WSDATA NfeVersao	As String
	WSDATA aRetorno		As NFEXMLRET

	WSMETHOD XmlDados DESCRIPTION "Dados do XML da NFE (Especifico AVANT)"
ENDWSSERVICE
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
��� WSMETHOD � XmlDados � Autor � Fernando Nogueira  � Data � 18/09/2017  ���
�������������������������������������������������������������������������͹��
���Desc.     � Dados do XML da Nota Fiscal.                               ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico AVANT                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
WSMETHOD XmlDados WSRECEIVE EmpCons, FilCons, NfeXML, NfeTime, NfeVersao WSSEND aRetorno WSSERVICE NFEXML
	Local aTabelas	:= {"SA1", "SA2", "SA3", "SA4", "SB1", "SB2", "SF1", "SD1", "SF2", "SD2", "SF4", "SF3", "SFT", "CD2", "SED", "SF7"}
	Local lRetorno 	:= .T.

	Local cEmpCons	:= EmpCons
	Local cFilCons	:= FilCons
	Local cCliente	:= Cliente
	Local cNfeXML	:= NfeXML
	Local cNfeTime	:= NfeTime
	Local cNfeVersao:= NfeVersao
	
	RpcClearEnv()
	RPCSetType(3)
	RpcSetEnv(cEmpCons, cFilCons, NIL, NIL, "FAT", NIL, aTabelas)
	
	cXmlDados := NfeProcNfe(cNfeXML,cNfeTime,cNfeVersao)

	::aRetorno:XmlDados	:= cXmlDados

Return lRetorno

//�����������������������������������������������Ŀ
//�Estrutura dos dados utilizados pelo WebService.�
//�������������������������������������������������
WSSTRUCT NFEXMLRET
	WSDATA XmlDados		As String
ENDWSSTRUCT