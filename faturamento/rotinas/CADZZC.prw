#INCLUDE "Protheus.ch"
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � CADZZC   � Autor � Fernando Nogueira  � Data � 08/08/2016  ���
�������������������������������������������������������������������������͹��
���Descricao � Cadastro de Comissoes                                      ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AVANT                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function CADZZC()

Private cCadastro 	:= "Cadastro de Comissoes"

Private aRotina 	:= {	{"Pesquisar"	,"AxPesqui"	,0,1} ,;
			             	{"Visualizar"	,"AxVisual"	,0,2} ,;
			             	{"Incluir"		,"AxInclui"	,0,3} ,;
			             	{"Alterar"		,"AxAltera"	,0,4} ,;
			             	{"Excluir"		,"AxDeleta"	,0,5} }

Private cString := "ZZC"

dbSelectArea("ZZC")
dbSetOrder(1)

dbSelectArea(cString)
mBrowse( 6,1,22,75,cString)

Return