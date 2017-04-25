#INCLUDE "Protheus.ch"
/*/
����������������������������������������������������������������������������
����������������������������������������������������������������������������
������������������������������������������������������������������������ͻ��
���Programa  � MA410COR � Autor � Fernando Nogueira  � Data � 10/11/2015 ���
������������������������������������������������������������������������͹��
���Descricao � Ponto de Entrada Para Alterar as Cores da Tela Browse do  ���
���          � Pedido de Vendas                                          ���
���          � Chamado 001777                                            ���
������������������������������������������������������������������������͹��
���Uso       � Especifico Avant                                          ���
������������������������������������������������������������������������ͼ��
����������������������������������������������������������������������������
����������������������������������������������������������������������������
/*/
User Function MA410COR()

Local aCores := {}

Aadd(aCores,{"AllTrim(C5_X_BLQFI) == 'S' .And. AllTrim(C5_LIBEROK) == 'S' ","BR_PINK"})
Aadd(aCores,{"AllTrim(C5_X_BLFIN) == 'S' .And. AllTrim(C5_X_BLQFI) <> 'S' .And. AllTrim(C5_LIBEROK) == 'S' ","BR_VERDE_ESCURO"})
Aadd(aCores,{"AllTrim(C5_X_BLQ) == 'S' .And. AllTrim(C5_X_BLQFI) <> 'S' .And. AllTrim(C5_X_BLFIN) <> 'S' .And. AllTrim(C5_LIBEROK) == 'S' ","BR_PRETO"})
Aadd(aCores,{"AllTrim(C5_X_BLQ) == 'C' .And. AllTrim(C5_X_BLQFI) <> 'S' .And. AllTrim(C5_X_BLFIN) <> 'S' .And. AllTrim(C5_LIBEROK) == 'S' ","BR_BRANCO"})

For _i := 1 to Len(ParamIXB)
	Aadd(aCores,ParamIXB[_i])
Next _i

Return aCores
