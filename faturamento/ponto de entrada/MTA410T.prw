#include "TOTVS.ch"
#include "rwmake.ch"

/*----------------------+--------------------------------+------------------+
|   Programa: MTA410T   | Autor: Kley Gonçalves          | Data: Julho/2014 |
+-----------------------+--------------------------------+------------------+
|  Descricao: Ponto de entrada que executa a função U_M410STTS para apagar os
|			    registros de Alçada de Aprovação, se existir registros na SCR. 
+---------------------------------------------------------------------------+
|    Projeto: AVANT
+--------------------------------------------------------------------------*/

User Function MTA410T
//U_M410STTS()
U_M440STTS()

If SC5->C5_CONDPAG = '149'
	
	SC9->(DBSetOrder(1))
	SC9->(DbGoTop())
	SC9->(DBSeek(xFilial("SC9")+SC5->C5_NUM+SC6->C6_ITEM))
	
	//Bloqueia pedidos antecipados mesmo com limite de credito :: chamado 002138
	SC9->(RecLock("SC9",.F.))
	SC9->C9_BLCRED := '01'
	SC9->(MsUnlock())
	
EndIf


Return