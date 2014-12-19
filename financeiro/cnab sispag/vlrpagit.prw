#include "rwmake.ch"      

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �VLRPAG    �Autor  �Ricardo Arruda      � Data �  23/07/09   ���
�������������������������������������������������������������������������͹��
���Desc.     �Este programa tem como objetivo calcular o valor a ser pago ���
���          �para o t�tulo                                               ���
�������������������������������������������������������������������������͹��
���Uso       � AP7                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function VLRPAGIT()        

	_VLRPAG := ""
           
    _VLRPAG := STRZERO(ABS((SE2->E2_SALDO+SE2->E2_ACRESC-SE2->E2_DECRESC)*100),15)       


Return(_VLRPAG)