#INCLUDE "Protheus.CH"
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � DescFin  � Autor � Fernando Nogueira  � Data � 16/04/2018  ���
�������������������������������������������������������������������������͹��
���Descricao � Desconto Financeiro na Remessa de Titulo                   ���
���          � Chamado 005229                                             ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico Avant                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function DescFin()

Local nDescFin := 0
Local cDescFin := Replicate("0",13)

If SA1->A1_XCONTRA > 0 .And. SA1->A1_X_DESCF = 'S'
	// O calculo eh feito com a base de comissao porque jah vem sem os impostos
	nDescFin := Round(SA1->A1_XCONTRA / 100 * SE1->E1_BASCOM1, 02)
	If nDescFin > 0
		cDescFin := StrZero(nDescFin*100,13)
	Endif
Endif

Return(cDescFin)
