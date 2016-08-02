#Include "rwmake.ch"
#Include "Protheus.Ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � MT120GOK () � Autor � Rogerio Machado    � Data �02/08/2016���
�������������������������������������������������������������������������͹��
���Descri��o � Ponto de Entrada Tratamento no PC antes de sua             ���
���          � contabilizacao                                             ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MT120GOK()

SC7->(RecLock('SC7',.F.))
	SC7->C7_XSTALI  := __av_cStsLi
	SC7->C7_XSHIPME := __av_cShip
	SC7->C7_XIMPSTA := __av_cImpo
SC7->(MsUnLock())

Return