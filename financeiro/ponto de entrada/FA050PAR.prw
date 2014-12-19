#include "TOTVS.ch"

/*----------------------+--------------------------------+------------------+
|   Programa: FA050PAR  | Autor: Kley@TOTVS              | Data: Junho/2014 |
+-----------------------+--------------------------------+------------------+
|  Descricao: Ponto de entrada após o desdfobramento do título do Contas a Pagar. 
+---------------------------------------------------------------------------+
|    Projeto: AVANT
+--------------------------------------------------------------------------*/

User Function FA050PAR    

Local aArea		:= GetArea()
Local aAreaSE2	:= SE2->(GetArea())
Local cGrAprov	:= Alltrim(GetMV("MV_XGRAPRO"))

MAAlcDoc({SE2->(E2_PREFIXO+E2_NUM+E2_TIPO+E2_FORNECE+E2_LOJA+E2_PARCELA),"TP",SE2->E2_VALOR,,,cGrAprov,,1,1,SE2->E2_EMISSAO},,1)

SE2->(RestArea(aAreaSE2))
RestArea(aArea)

Return
