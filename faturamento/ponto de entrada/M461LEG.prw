#INCLUDE "Protheus.ch"
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � M461LEG  � Autor � Amedeo D. P. Filho � Data �  24/07/2012 ���
�������������������������������������������������������������������������͹��
���Descricao � Legenda no Browse dos pedidos a Faturar                    ���
�������������������������������������������������������������������������͹��
���Uso       � AVANT.                                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function M461LEG
	Local aRetorno	:= PARAMIXB

    Aadd(aRetorno, {"BR_LARANJA"     , "Pedido N�o Conferido (WMS)"})
    Aadd(aRetorno, {"BR_PRETO"       , "Pedido com Bloqueio Avant"})
    Aadd(aRetorno, {"BR_PINK"        , "Pedido com Bloqueio Fiscal"})
    Aadd(aRetorno, {"BR_VERDE_ESCURO", "Pedido com Bloqueio Financeiro"})

Return aRetorno
