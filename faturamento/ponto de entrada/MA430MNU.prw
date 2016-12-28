#INCLUDE "Protheus.ch"
/*/
����������������������������������������������������������������������������
����������������������������������������������������������������������������
������������������������������������������������������������������������ͻ��
���Programa  � MA430MNU � Autor � Fernando Nogueira  � Data � 23/08/2016 ���
������������������������������������������������������������������������͹��
���Descricao � Ponto de Entrada Altera aRotina do Controle de Reservas   ���
������������������������������������������������������������������������͹��
���Uso       � Especifico Avant                                          ���
������������������������������������������������������������������������ͼ��
����������������������������������������������������������������������������
����������������������������������������������������������������������������
/*/
User Function MA430MNU()

Local aRotAV := {}

For _i := 1 to Len(aRotina)
	If aRotina[_i,2] <> "A430Resid"
		aAdd(aRotAV,aRotina[_i])
	Else
		aAdd(aRotAV,{"Elim.Residuo","U_AVResid",0,2,0,NIL})
	Endif
Next _i

aRotina := aRotAV

Return .T.

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �A430Resid � Autor � Eduardo Riera         � Data � 03/11/05 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Programa de elimina��o de residuos de uma reserva          ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe e � Void A430Resid (ExpC1,ExpN1,ExpN2)                         ���
�������������������������������������������������������������������������Ĵ��
���Parametros� ExpC1 = Alias do arquivo                                   ���
���          � ExpN1 = Numero do registro                                 ���
���          � ExpN2 = Numero da opcao selecionada                        ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATA430                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function AVResid(cAlias,nReg,nOpcx)

Local aArea := GetArea()
Local cNum  := SC0->C0_NUM

If !Empty(SC0->C0_SOLICIT) .And. AllTrim(SC0->C0_SOLICIT) <> AllTrim(cUserName) .And. aScan(PswRet(1)[1][10],'000000') == 0
	ApMsgInfo("Eliminar Res�duos liberado somente para o mesmo usu�rio que fez a reserva: "+AllTrim(SC0->C0_SOLICIT))
	Return
ElseIf a430Visual(cAlias,nReg,nOpcx)==1
	dbSelectArea("SC0")
	dbSetOrder(1)
	MsSeek(xFilial("SC0")+cNum)
	While !Eof() .And. xFilial("SC0") == SC0->C0_FILIAL .And. cNum == SC0->C0_NUM
			Begin Transaction
				If SC0->C0_QUANT <> 0 .And. SC0->C0_QUANT<>SC0->C0_QTDORIG
					a430Reserva({2,SC0->C0_TIPO,SC0->C0_DOCRES,SC0->C0_SOLICIT,SC0->C0_FILRES},;
							SC0->C0_NUM,;
							SC0->C0_PRODUTO,;
							SC0->C0_LOCAL,;
							0,;
							{	SC0->C0_NUMLOTE,;
							SC0->C0_LOTECTL,;
							SC0->C0_LOCALIZ,;
							SC0->C0_NUMSERI},,,SC0->C0_QUANT)
				EndIf
			End Transaction

			If ExistBlock("MT430ELIM")
				ExecBlock("MT430ELIM",.F.,.F.,{SC0->C0_NUM})
			EndIf

		dbSelectArea("SC0")
		dbSkip()
	EndDo
EndIf
RestArea(aArea)
Return(Nil)
