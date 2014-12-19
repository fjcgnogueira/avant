#include "TOTVS.ch"

/*----------------------+--------------------------------+------------------+
|   Programa: FA050INC  | Autor: Pedro Augusto           | Data: Maio/2014  |
+-----------------------+--------------------------------+------------------+
|  Descricao: Ponto de entrada criado para criar alcada de aprovacao para o 
|			  titulo que está sendo gerado.
+---------------------------------------------------------------------------+
|    Projeto: AVANT
+--------------------------------------------------------------------------*/

User Function FA050INC    

//Local cNum		:= M->(E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA) 
Local cNum		:= M->(E2_PREFIXO+E2_NUM+E2_TIPO+E2_FORNECE+E2_LOJA+E2_PARCELA) 
Local aAreaSE2	:= SE2->(GetArea())
Local cGrAprov	:= Alltrim(GetMV("MV_XGRAPRO"))
Local lRet		:= .T.

/*** FAZER TRATAMENTO QUANDO PARCELA GERA DESDOBRAMENTO - Tratamento feito dentro do Envio do WF do Financeiro ***/

//If M->E2_DESDOBR == "N" .and. M->E2_SALDO # 0 .and. Empty(M->E2_BAIXA)		// Se houve desdobramento Alçada é gerada através do P.E. U_FA050PAR()
	MAAlcDoc({cNum,"TP",M->E2_VALOR,,,cGrAprov,,1,1,M->E2_EMISSAO},,1)
//EndIf

SE2->(RestArea(aAreaSE2))

Return(lRet)
