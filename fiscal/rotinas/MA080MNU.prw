#INCLUDE "rwmake.ch"
#INCLUDE "PROTHEUS.CH"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MA080MNU  � Autor � Fernando Nogueira  � Data � 09/06/2017  ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de Entrada para adicionar funcao no menu do cadastro ���
���          � de TES                                                     ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico Avant                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function MA080MNU()
     AADD(aRotina, {"Copia","U_MSGMATA080",0,6}) //Copia de TES
Return()

/*
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
���������������������������������������������������������������������������Ŀ��
���Funcao    �MSGMATA080� Autor � Fernando Nogueira     � Data � 09/06/2017 ���
���������������������������������������������������������������������������Ĵ��
���Descricao �Funcao que copia um registro do arquivo.                      ���
���          �Chamado 005026.                                               ���
���������������������������������������������������������������������������Ĵ��
��� Uso      �Especifico Avant                                              ���
����������������������������������������������������������������������������ٱ�
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
*/
User Function MSGMATA080()

Local nx

nOpcA    := 0
cNewTes  := Space(03)
_cFilial := xFilial("SF4")
cOldTes  := SF4->F4_CODIGO

@ 000,000 To 170,300 Dialog oDLGA Title "Copia de TES"
@ 00.5,00.5 To 004,018

@ 001,002 Say OemtoAnsi("Da   TES:   ") COLOR CLR_HBLUE
@ 001,005 Say SF4->F4_CODIGO+' - '+SF4->F4_TEXTO

@ 002,002 Say OemtoAnsi("Filial:   ") COLOR CLR_HBLUE
@ 002,005 Get _cFilial Picture '999999' Size 006,005 Valid If(MtValidFil(SM0->M0_CODIGO+_cFilial),.T.,Eval({||ApMsgInfo("Filial n�o existe!"),.F.}))

@ 003,002 Say OemtoAnsi("Para TES:   ") COLOR CLR_HBLUE
@ 003,005 Get cNewTES Picture '999' Size 004,005 Valid ValTes(cOldTes,cNewTES,_cFilial)


@ C(050),C(030) BMPBUTTON TYPE 1 Action (CONFIRMA(_cFilial),oDlga:End())
@ C(050),C(070) BMPBUTTON TYPE 2 Action oDlga:End()

Activate MsDialog oDlgA Center

Return

/*/
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
���Programa  � Confirma  � Autor � Fernando Nogueira  � Data  � 09/06/2017 ���
��������������������������������������������������������������������������Ĵ��
���Descricao � Confirma a copia                                            ���
���������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������
������������������������������������������������������������������������������
/*/
Static Function Confirma(_cFilial)

Local aRegistro   := {}
Local nPosicao    := 0
Local nFilial     := 0


     //�����������������������������������������������������������������Ŀ
     //� Le as informacoes do registro corrente                          �
     //�������������������������������������������������������������������
     For nx := 1 to FCount()
          AADD(aRegistro,FieldGet(nx))
     Next nx

     //�����������������������������������������������������������������Ŀ
     //� Efetua a gravacao do novo registro                              �
     //�������������������������������������������������������������������
     RecLock(Alias(),.T.)
     For nx := 1 TO FCount()
	 	  nFilial  := FieldPos("F4_FILIAL")
          nPosicao := FieldPos("F4_CODIGO")
          If nPosicao == nx
               FieldPut(nx,cNewTes)
		  ElseIf nFilial == nx
		       FieldPut(nx,_cFilial)
          Else
               FieldPut(nx,aRegistro[nx])
          Endif
     Next nx
     MsUnlock()
     MsgBox("Tes copiada com Sucesso."+chr(10)+"Efetue as alteracoes necessarias na nova tes.")

Return

/*/
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
���Programa  � ValTes    � Autor � Fernando Nogueira  � Data  � 09/06/2017 ���
��������������������������������������������������������������������������Ĵ��
���Descricao � Valida a TES                                                ���
���������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������
������������������������������������������������������������������������������
/*/
Static Function ValTes(cOldTes,cNewTES,_cFilial)

_lRet :=.T.
_AREA := GETAREA()

If SF4->(DbSeek(_cFilial+cNewTes))
     MsgBox("Tes J� Cadastrada, escolha outra numera��o.")
     _lRet :=.F.
Endif

If cOldTes < '500' .And. cNewTes >= '500'
     ApMsgInfo("Tes de Entrada deve ser menor que 500.")
     _lRet :=.F.
Endif

If cOldTes >= '500' .And. cNewTes < '500'
     ApMsgInfo("Tes de Saida deve ser maior que 500.")
     _lRet :=.F.
Endif

RESTAREA(_AREA)

Return(_lRet)
