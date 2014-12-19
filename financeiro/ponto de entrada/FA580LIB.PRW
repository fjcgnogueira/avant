#include "TOTVS.ch"

/*----------------------+--------------------------------+------------------+
|   Programa: Fa580Lib  | Autor: Pedro Augusto           | Data: Maio/2014  |
+-----------------------+--------------------------------+------------------+
|  Descricao: Ponto de entrada criado para desabilitar a liberacao do titulo  
|			  pela rotina padrao,pois os titulos terao alcada de aprovacao.
+---------------------------------------------------------------------------+
|    Projeto: AVANT
+--------------------------------------------------------------------------*/

User Function Fa580Lib()    

MsgStop("Rotina desabilitada devido ao Controle de Alçadas de Aprovação."+CRLF+;
		"Por favor, utilize a rotina de Aprovação de Documentos de Alçada.","Workflow de Pagamentos")	

Return(.F.)
