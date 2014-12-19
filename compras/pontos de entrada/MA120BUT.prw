#include "TOTVS.ch"

/*----------------------+--------------------------------+------------------+
|   Programa: MA120BUT  | Autor: Kley@TOTVS              | Data: 28/04/2014 |
+-----------------------+--------------------------------+------------------+
|  Descricao: Ponto de Entrada no Pedido de Compra para adicionar mais opções
|             as ações Relacionadas.
+---------------------------------------------------------------------------+
|    Projeto: AVANT
+---------------------------------------------------------------------------+
|    Sintaxe: U_MA120BUT()
+----------------------------------------------------------------------------
|    Retorno: Nulo                                                               
+--------------------------------------------------------------------------*/
	
User Function MA120BUT

Local aRet	:= {}

Aadd(aRet,{ "WFREENV",  {|| U_AVCOMW10(1,SC7->C7_NUM)},"Reenvia E-mail Aprov.",        "Reenvia Aprov." }  )
Aadd(aRet,{ "BMPPOST",  {|| U_WFEnvPCFor(SC7->C7_NUM)},"Envia e-mail para fornecedor", "Env. E-mail Fornec." }  )

Return aRet 
