#INCLUDE "Protheus.ch"
/*/
����������������������������������������������������������������������������
����������������������������������������������������������������������������
������������������������������������������������������������������������ͻ��
���Programa  � MA410LEG � Autor � Fernando Nogueira  � Data � 11/11/2015 ���
������������������������������������������������������������������������͹��
���Descricao � Ponto de Entrada Para Alterar a Legenda da Tela Browse do ���
���          � Pedido de Vendas                                          ���
���          � Chamado 001777                                            ���
������������������������������������������������������������������������͹��
���Uso       � Especifico Avant                                          ���
������������������������������������������������������������������������ͼ��
����������������������������������������������������������������������������
����������������������������������������������������������������������������
/*/
User Function MA410LEG()

Local aCores := ParamIXB

Aadd(aCores,{"BR_PRETO"       ,"Pedido de Venda com Bloqueio Avant"})
Aadd(aCores,{"BR_BRANCO"      ,"Pedido de Venda com Bloqueio Avant Cliente"})
Aadd(aCores,{"BR_PINK"        ,"Pedido de Venda com Bloqueio Fiscal"})
Aadd(aCores,{"BR_VERDE_ESCURO","Pedido de Venda com Bloqueio Financeiro"})

Return aCores
