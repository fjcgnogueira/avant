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

//Bloqueia pedidos antecipados mesmo com limite de credito :: chamado 002138
If IsBlind() .Or. AllTrim(FunName()) == 'MATA410'
	If SC5->C5_CONDPAG = '149' .And. SC6->C6_TPOPERW = 'VENDAS'
		SC9->C9_BLCRED := '01'
	EndIf
	
	If AllTrim(SC5->C5_X_BLQ) == 'C'
		SC5->C5_X_BLQ := 'S'
	Endif
	
	// Chamado 001777 - Fernando Nogueira
	If AllTrim(SC5->C5_X_BLQ) == 'S'
		SC9->C9_BLCRED  := '01'
		SC9->C9_BLOQUEI := '01'
	Endif
Endif

Return