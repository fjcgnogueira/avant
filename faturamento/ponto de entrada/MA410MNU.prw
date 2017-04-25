#include "TOTVS.ch"
#include "rwmake.ch"

/*----------------------+--------------------------------+------------------+
|   Programa: MA410MNU  | Autor: Kley Gon�alves          | Data: Julho/2014 |
+-----------------------+--------------------------------+------------------+
|  Descricao: Ponto de entrada para inclus�o de mais uma op��o a
|			    A��es Relacionadas do browse do Pedido de Venda.
+---------------------------------------------------------------------------+
|    Projeto: AVANT
+--------------------------------------------------------------------------*/

User Function MA410MNU

aAdd(aRotina,{"Consulta Aprova��o"  ,'U_ConsultAprov("PV",SC5->C5_NUM,"Pedido de Venda",SC5->C5_NUM,Substr(Embaralha(SC5->C5_USERLGI,1),3,6))', 0, 1, 0, NIL})
aAdd(aRotina,{"Liberacao Avant"     ,'U_LibPedVen()', 0, 2, 0, NIL})  // Chamado 001777 - Bloqueio Avant - Fernando Nogueira
aAdd(aRotina,{"Liberacao Fiscal"    ,'U_LibPedFis()', 0, 2, 0, NIL})  // Chamado 003522 - Bloqueio Fiscal - Fernando Nogueira
aAdd(aRotina,{"Liberacao Financeiro",'U_LibFinPed()', 0, 2, 0, NIL})  // Chamado 004840 - Bloqueio Financeiro - Fernando Nogueira
aAdd(aRotina,{"Pedido Sucata"       ,'U_Pedido50()' , 0, 3, 0, NIL})  // Chamado 003544 - Pedido Sucata - Fernando Nogueira

Return
