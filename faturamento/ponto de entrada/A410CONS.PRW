#include "TOTVS.ch"
#include "rwmake.ch"

/*----------------------+--------------------------------+------------------+
|   Programa: A410Cons  | Autor: Kley Gonçalves          | Data: Julho/2014 |
+-----------------------+--------------------------------+------------------+
|  Descricao: Ponto de entrada para inclusão de Botão na tela de Pedidos de
|			    Venda, para uso do Workflow de Liberação de Crédito.  
+---------------------------------------------------------------------------+
|    Projeto: AVANT
+--------------------------------------------------------------------------*/

User Function A410Cons 

Local wBOTAO:={}

AAdd(wBOTAO,{"VENDEDOR" , {|| U_ConsultAprov("PV",M->C5_NUM,"Pedido de Venda",M->C5_NUM,Substr(Embaralha(M->C5_USERLGI,1),3,6)) }, "Consulta Aprovação" } )
AAdd(wBOTAO,{"POSCLI" ,   {|| SituaPed()  }, 'Situacao do Pedido' } )

Return(wBOTAO)


/*----------------------+--------------------------------+------------------+
|   Programa: ConsAprov | Autor: Kley Gonçalves          | Data: Julho/2014 |
+-----------------------+--------------------------------+------------------+
|  Descricao: Consulta os aprovadores do Pedido de Venda Posicionado.
+---------------------------------------------------------------------------+
|    Projeto: AVANT
+--------------------------------------------------------------------------*/

Static Function ConsAprov

Local cPag   := M->C5_NUM, cSituaca := ''
Local aCampos:= {}, _aStru := {}, _aAreaAnt := GetArea()
Local oFont  := TFont():New("Tahoma",9,,,.T.,,,,,.F.) // Com Negrito
Local oMens

// Obter os dados para exibicao:
AADD(aCampos,{"APROVADOR" ,"Aprovador"  ,"@!"})
AADD(aCampos,{"SITUACAO"  ,"Situacao"   ,"@!"})
AADD(aCampos,{"_DATA"     ,"Atualizacao","@!"})
AAdd( _aStru, {"APROVADOR" , 'C', 30,0} )
AAdd( _aStru, {"SITUACAO"  , 'C', 20,0} )
AAdd( _aStru, {"_DATA"     , 'D', 08,0} )
_cTmp := CriaTrab(_aStru,.t. )
If Select(_cTmp) > 0
	&(_cTmp)->(DbCloseArea())
EndIf
DbUseArea(.t.,,_cTmp,_cTmp,.f.)
DbSelectArea("SCR")
DbSetOrder(1)
DbSeek(xFilial("SCR")+"PV"+cPag)
While !Eof() .And. Rtrim(SCR->(CR_FILIAL+CR_TIPO+CR_NUM)) == xFilial("SCR")+"PV"+cPag
	DbSelectArea(_cTmp)
	RecLock(_cTmp,.t.)
	APROVADOR := UsrFullName(SCR->CR_USER)
	Do Case
		Case SCR->CR_STATUS == "01"
			cSituaca := 'Aguardando Aprovacao'
		Case SCR->CR_STATUS == "02"
			cSituaca := 'Em Aprovacao'
		Case SCR->CR_STATUS == "03"
			cSituaca := 'Aprovado'
		Case SCR->CR_STATUS == "04"
			cSituaca := 'Bloqueado'
		Case SCR->CR_STATUS == "05"
			cSituaca := 'Nivel Liberado'
		OtherWise
		    cSituaca := 'Nao houve bloqueio - Liberado Automaticamente'
	EndCase
	SITUACAO := cSituaca
	_DATA    := SCR->CR_DATALIB
	MsUnLock()
	DbSelectArea('SCR')
	DbSkip()
EndDo

If &(_cTmp)->(Eof())
	MsgInfo("Este Pedido de Vendas nao possui controle de aprovacao.","Consulta Aprovação")
	RestArea(_aAreaAnt)
	Return
EndIf

&(_cTmp)->(DbGoTop())

@ 273,193 To 535,748 Dialog Mkwdlg
@ 004,004 To 130,233 Title "Consulta aos Aprovadores do Pedido de Vendas"
@ 037,236 To 085,271  // "Area do Botao Ok"
@ 031,004 To 130,233 Browse _cTmp Fields aCampos  // "Area do Browse"
@ 017,010 Say "Nro. do PV"   Size 62,08
@ 017,076 Say M->C5_NUM Color 8388608 Object oMens SIZE 96,12
@ 054,240 Button "_Ok" Size 27,16 Action(Close(Mkwdlg))
oMens:ofont:=ofont
Activate Dialog Mkwdlg
DbSelectArea(_cTmp)
DbCloseArea(_cTmp)
RestArea(_aAreaAnt)
Return


/*----------------------+--------------------------------+------------------+
|   Programa: SituaPed  | Autor: Kley Gonçalves          | Data: Julho/2014 |
+-----------------------+--------------------------------+------------------+
|  Descricao: Consulta Situação do Pedido de Venda.
+---------------------------------------------------------------------------+
|    Projeto: AVANT
+--------------------------------------------------------------------------*/

	
Static Function SituaPed

Local _cPed  := Trim(M->C5_NUM)

SC9->( DbSetOrder(1))
SC9->(DbSeek( xFilial('SC9')+_cPed ) )
If !SC9->(Found())
       If SC5->C5_BLQ = ' '
       	MsgAlert("Pedido de Venda em aberto", "Situação do Pedido")
       Else   
       	MsgAlert("Pedido de Venda com bloqueio de regra", "Situação do Pedido")
	   Endif
Else
	If SC9->C9_BLCRED <> "10" .and. SC9->C9_BLCRED <> "  "
		If SC9->C9_BLEST = "02"
       	MsgAlert("Pedido de Venda bloqueado por credito/estoque", "Situação do Pedido")
		Else
       	MsgAlert("Pedido de Venda bloqueado por credito", "Situação do Pedido")
	  	Endif
	ElseIf  SC9->C9_BLCRED = "  "
		If SC9->C9_BLEST = "02"
       	MsgAlert("Pedido de Venda bloqueado por estoque", "Situação do Pedido")
		ElseIf SC9->C9_BLEST = "  "
       	MsgAlert("Pedido de Venda liberado (Cred./Estoque)", "Situação do Pedido")
		Endif
	ElseIf  SC9->C9_BLCRED = "10"
       MsgAlert("Pedido de Venda Faturado", "Situação do Pedido")
	EndIf
Endif

Return