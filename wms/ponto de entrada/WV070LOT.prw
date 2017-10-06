#INCLUDE "PROTHEUS.CH"
#INCLUDE 'APVT100.CH'
#INCLUDE 'INKEY.CH'
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � WV070LOT � Autor � Fernando Nogueira  � Data � 05/10/2017  ���
�������������������������������������������������������������������������͹��
���Desc.     � P.E. na Digitacao do Lote na Conferencia.                  ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico Avant                                           ���
���          � Chamado 005283                                             ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function WV070LOT()

Local cProduto  := ParamIXB[1]
Local cLote     := ParamIXB[2]
Local cPedido   := SDB->DB_DOC
Local cAliasSDB := GetNextAlias()

ConOut("Ponto de Entrada  : WV070LOT")

BeginSql alias cAliasSDB
	SELECT DB_LOTECTL FROM SDB010
	WHERE D_E_L_E_T_ = ' ' 
		AND DB_FILIAL = %Exp:xFilial("SDB")% 
		AND DB_TAREFA = '002'
		AND DB_DOC = %Exp:cPedido%
		AND DB_TIPO = 'E'
		AND DB_ESTORNO = ''
		AND DB_PRODUTO = %Exp:cProduto%
EndSql

cLote := (cAliasSDB)->DB_LOTECTL

(cAliasSDB)->(dbCloseArea())

Return cLote