#INCLUDE "Protheus.ch"
/*/
����������������������������������������������������������������������������
����������������������������������������������������������������������������
������������������������������������������������������������������������ͻ��
���Programa  � M440SC9I � Autor � Fernando Nogueira  � Data � 19/10/2015 ���
������������������������������������������������������������������������͹��
���Descricao � Ponto de Entrada Anterior a Implantacao da Liberacao do   ���
���          � Pedido de Vendas                                          ���
������������������������������������������������������������������������͹��
���Uso       � Especifico Avant                                          ���
������������������������������������������������������������������������ͼ��
����������������������������������������������������������������������������
����������������������������������������������������������������������������
/*/
User Function M440SC9I()

If IsBlind() .Or. AllTrim(FunName()) $ ('MATA410.MATA440')

	If AllTrim(SC5->C5_X_BLQ) == 'C'
		SC5->C5_X_BLQ := 'S'
	Endif

    If AllTrim(SC5->C5_X_BLQFI) == 'S'
    	SC9->C9_BLOQUEI := '02'
	// Chamado 001777 - Fernando Nogueira
	ElseIf AllTrim(SC5->C5_X_BLQ) == 'S'
		SC9->C9_BLOQUEI := '01'
   	// Chamado 004840 - Fernando Nogueira
    ElseIf AllTrim(SC5->C5_X_BLFIN) == 'S'
    	SC9->C9_BLOQUEI := '03'
	Endif
Endif

Return
