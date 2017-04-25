#INCLUDE "Protheus.ch"
/*/
����������������������������������������������������������������������������
����������������������������������������������������������������������������
������������������������������������������������������������������������ͻ��
���Programa  � MAAVCRPR � Autor � Fernando Nogueira  � Data � 23/11/2015 ���
������������������������������������������������������������������������͹��
���Descricao � Ponto de Entrada Apos a Avaliacao de Credito, para fazer  ���
���          � uma avaliacao propria                                     ���
������������������������������������������������������������������������͹��
���Uso       � Especifico Avant                                          ���
������������������������������������������������������������������������ͼ��
����������������������������������������������������������������������������
����������������������������������������������������������������������������
/*/
User Function MAAVCRPR()

Local cCodigo := ParamIXB[8]

If !Empty(cCodigo)
	Return .F.
Endif

If IsBlind() .Or. AllTrim(FunName()) $ ('MATA410.MATA440')
	If AllTrim(SC5->C5_X_BLQ) $ 'SC' .Or. AllTrim(SC5->C5_X_BLQFI) == 'S' .Or. AllTrim(SC5->C5_X_BLFIN) == 'S' .Or. (SC5->C5_CONDPAG = '149' .And. SC6->C6_TPOPERW = 'VENDAS')
		Return .F.
	Endif
Endif

Return .T.
