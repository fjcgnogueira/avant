#INCLUDE "PROTHEUS.CH"           
#INCLUDE "Totvs.ch"
#INCLUDE "FILEIO.ch"
#INCLUDE "TbiConn.ch"
#INCLUDE "AP5MAIL.CH"

/*
�������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
���Programa  � CONTFOLHA   � Autor � Rogerio Machado    � Data  � 18/04/18 ���
��������������������������������������������������������������������������Ĵ��
���Descricao � Contabiliza��o de folha de pagamento                        ���
���������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������
�������������������������������������������������������������������������������
/*/

User Function CONTFOLHA()

	Local _cReturn    := ""
	Local _cIdent     := ""
	Local _nReturn    := ""

	_cIdent   = LerStr(001,002)
	
	If _cIdent == "03"
		If PARAMIXB == "D" 											//CONTA DEBITO
			DbSelectArea("ZZV")
			DbSetOrder(1)
			DbSeek(xFilial("ZZV")+LerStr(014,003))
			_cReturn := STRTRAN(ZZV->ZZV_CONTA, ".", "")
			Return _cReturn
		ElseIf PARAMIXB == "C" 										//CONTA CREDITO
			DbSelectArea("ZZV")
			DbSetOrder(1)
			DbSeek(xFilial("ZZV")+LerStr(021,003))	
			_cReturn := STRTRAN(ZZV->ZZV_CONTA, ".", "")
			Return _cReturn
		ElseIf PARAMIXB == "V" 										//VALOR
			_nReturn := LerVal(024,015)
			Return _nReturn
		ElseIf PARAMIXB == "H" 										//HISTORICO
			_cReturn := "FPGTO " + LerStr(046,034)
			Return _cReturn
		EndIf
	EndIf
	
	
Return _cReturn