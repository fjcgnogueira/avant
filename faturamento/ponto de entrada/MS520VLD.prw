#INCLUDE "Protheus.ch"
/*/
����������������������������������������������������������������������������
����������������������������������������������������������������������������
������������������������������������������������������������������������ͻ��
���Programa  � MS520VLD � Autor � Fernando Nogueira  � Data � 08/07/2016 ���
������������������������������������������������������������������������͹��
���Descricao � Ponto de Entrada Para Validar Exclusao de Nota Fiscal de  ���
���          � Saida. Chamado 003505.                                    ���
������������������������������������������������������������������������͹��
���Uso       � Especifico Avant                                          ���
������������������������������������������������������������������������ͼ��
����������������������������������������������������������������������������
����������������������������������������������������������������������������
/*/
User Function MS520VLD()

/*/
����������������������������������ͻ
�Status Nota Fiscal Eletronica     �
����������������������������������͹
�F2_FIMP==' '� NF nao transmitida  �
�F2_FIMP=='S'� NF Autorizada       �
�F2_FIMP=='T'� NF Transmitida      �
�F2_FIMP=='D'� NF Uso Denegado     �
�F2_FIMP=='N'� NF nao autorizada   �
����������������������������������ͼ
/*/

If SF2->F2_FIMP == 'S' .And. Left(DtoS(SF2->F2_EMISSAO),06) <> Left(DtoS(Date()),06) .And. !(aScan(PswRet(1)[1][10],'000000') <> 0)
	ApMsgInfo("Exclus�o de NF autorizada deve ser feita dentro do mesmo m�s em que a mesma foi emitida.")
	Return .F.
ElseIf SF2->F2_FIMP == ' ' .And. Left(DtoS(SF2->F2_EMISSAO),06) <> Left(DtoS(dDataBase),06)
	ApMsgInfo("Exclus�o de NF n�o transmitida deve ser feita dentro do mesmo m�s na data base em que a mesma foi emitida.")
	Return .F.
ElseIf SF2->F2_FIMP == 'D' .And. Left(DtoS(SF2->F2_EMISSAO),06) <> Left(DtoS(dDataBase),06)
	ApMsgInfo("Exclus�o de NF denegada deve ser feita dentro do mesmo m�s na data base em que a mesma foi emitida.")
	Return .F.
ElseIf SF2->F2_FIMP == 'N' .And. Left(DtoS(SF2->F2_EMISSAO),06) <> Left(DtoS(dDataBase),06)
	ApMsgInfo("Exclus�o de NF n�o autorizada deve ser feita dentro do mesmo m�s na data base em que a mesma foi emitida.")
	Return .F.
ElseIf SF2->F2_FIMP == 'T'
	ApMsgInfo("Antes de excluir uma NF transmitida, aguardar o Sefaz definir o status da Nota.")
	Return .F.
Endif

Return .T.
