#include "TOTVS.ch"

/*----------------------+--------------------------------+------------------+
|   Programa: FA050Del  | Autor: Pedro Augusto           | Data: Maio/2014  |
+-----------------------+--------------------------------+------------------+
|  Descricao: Ponto de entrada criado para excluir alcada de aprovacao para o 
|			  titulo que está sendo excluido.
+---------------------------------------------------------------------------+
|    Projeto: AVANT
+--------------------------------------------------------------------------*/

User Function FA050Del    
                            
Local aArea 	:=	GetArea()
//Local cNum     := M->(E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA)
Local cNum     := M->(E2_PREFIXO+E2_NUM+E2_TIPO+E2_FORNECE+E2_LOJA+E2_PARCELA) 
Local cGrAprov := Alltrim(GetMV("MV_XGRAPRO"))
Local lRet     := .T.

MAAlcDoc({cNum,"TP",M->E2_VALOR,,,cGrAprov,,1,1,M->E2_EMISSAO},,3)    
     
RestArea(aArea)

Return(lRet) 