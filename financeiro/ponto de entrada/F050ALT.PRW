#include "TOTVS.ch"

/*----------------------+--------------------------------+------------------+
|   Programa: F050ALT  | Autor: Pedro Augusto           | Data: Maio/2014  |
+-----------------------+--------------------------------+------------------+
|  Descricao: Ponto de entrada criado para recriar alcada de aprovacao para o 
|			  titulo que está sendo alterado.
+---------------------------------------------------------------------------+
|    Projeto: AVANT
+--------------------------------------------------------------------------*/

User Function F050ALT    
                            
Local aArea		:= GetArea()
//Local cNum		:= M->(E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA)
Local cNum		:= M->(E2_PREFIXO+E2_NUM+E2_TIPO+E2_FORNECE+E2_LOJA+E2_PARCELA)
Local cGrAprov	:= Alltrim(GetMV("MV_XGRAPRO"))

MAAlcDoc({cNum,"TP",M->E2_VALOR,,,cGrAprov,,1,1,M->E2_EMISSAO},,3) // exclui a alcada corrente   
MAAlcDoc({cNum,"TP",M->E2_VALOR,,,cGrAprov,,1,1,M->E2_EMISSAO},,1) // recria nova alcada                           
    
RecLock("SE2",.F.,.t.)
	SE2->E2_DATALIB := ctod("  /  /  ")
	SE2->E2_USUALIB := Space(TamSX3("E2_USUALIB")[1])
	SE2->E2_X_USUAR := __cUserId
SE2->(MsUnlock())  
      
RestArea( aArea )
Return(.T.)
