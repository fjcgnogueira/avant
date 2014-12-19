#include "TOTVS.ch"

/*----------------------+--------------------------------+------------------+
|   Programa: MT100AGR  | Autor: Kley@TOTVS              | Data: 13/06/2014 |
+-----------------------+--------------------------------+------------------+
|  Descricao: Ponto de Entrada no Documento de Entrada para exclusão da
|             Alçada de Aprovação.
+---------------------------------------------------------------------------+
|    Projeto: AVANT
+---------------------------------------------------------------------------+
|    Sintaxe: U_MT100AGR()
+----------------------------------------------------------------------------
|    Retorno: Nulo                                                               
+--------------------------------------------------------------------------*/
	
User Function MT100AGR

Local aArea		:= GetArea()
Local aAreaSCR	:= SCR->(GetArea())
Local cNumSCR	:= SF1->(F1_SERIE+F1_DOC+"NF "+F1_FORNECE+F1_LOJA) 
Local cGrpAprov	:= Alltrim(GetMV("MV_XGRAPRO"))
Local lRet		:= .T.

SY1->(DbSetOrder(3))
If SY1->(DbSeek(xFilial("SY1")+__cUserId))
	If Empty(SY1->Y1_X_GRPFI)
		_cGrAprov	:= Alltrim(GetMV("MV_XGRAPRO"))
	Else
		_cGrAprov	:= SY1->Y1_X_GRPFI
	EndIf
Else
	_cGrAprov	:= Alltrim(GetMV("MV_XGRAPRO"))
EndIf

If !INCLUI .and. !ALTERA	// Exclusão
	DBSelectArea("SCR")
	SCR->(DbSetOrder(1))
	SCR->(DBSeek(xFilial("SCR")+"TP"+cNumSCR))
	While !SCR->(Eof()) .and. SCR->(CR_FILIAL+CR_TIPO) == xFilial("SCR")+"TP" .and. Left(SCR->CR_NUM,Len(RTrim(cNumSCR))) == RTrim(cNumSCR)
		MsgInfo("Exclusão da Alçada do Titulo a Pagar (Fil/Num): " + RTrim(xFilial("SCR")+"/"+cNumSCR),"Exclusão de Documento")
		MAAlcDoc({SCR->CR_NUM,SCR->CR_TIPO,SCR->CR_TOTAL,,,cGrpAprov,,1,1,SCR->CR_EMISSAO},,3) // exclui a alcada corrente   
		SCR->(DbSkip())
	EndDo
ElseIf ALTERA
	MsgStop("Alteração não permitida devido a geração das Alçadas de Aprovação."+CRLF+;
			"Por favor, exclua o documento e faça uma nova inclusão. ","Alteração não permitida")
	lRet := .F.
EndIf

SCR->(RestArea(aAreaSCR))
RestArea(aAreaSCR)

Return lRet 
