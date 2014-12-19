#include "TOTVS.ch"
#include "rwmake.ch"

/*----------------------+--------------------------------+------------------+
|   Programa: F050ROT   | Autor: Pedro Augusto           | Data: Maio/2014  |
+-----------------------+--------------------------------+------------------+
|  Descricao: Ponto de entrada criado para habilitar consulta do processo de
|			   aprovacao (SCR ). 
+---------------------------------------------------------------------------+
|    Projeto: AVANT
+--------------------------------------------------------------------------*/

User Function F050ROT()

Local aRotina := ParamIxb
aAdd( aRotina, {"Consulta Aprovacao", 'U_ConsultAprov("TP",SE2->(E2_PREFIXO+E2_NUM+E2_TIPO+E2_FORNECE+E2_LOJA+E2_PARCELA),"Título a Pagar",SE2->E2_NUM,SE2->E2_X_USUAR)', 0, 8,, .F. } )  

Return aRotina  

/*-------------------------+-----------------------------+------------------+
|   Programa: ConsultAprov | Autor: Kley@TOTVS           | Data: Julho/2014 |
+--------------------------+-----------------------------+------------------+
|  Descricao: Tela para consulta ao Processo de Aprovação (SCR).
+---------------------------------------------------------------------------+
|    Projeto: AVANT
+---------------------------------------------------------------------------+
|    Sintaxe: U_ConsultAprov(cCRTipo,cCRNum,cTitulo,cNumDocto,cUsuario)
+----------------------------------------------------------------------------
|    Retorno: (nOpc = 0)                                                               
+--------------------------------------------------------------------------*/
              
User Function ConsultAprov(cCRTipo,cCRNum,cTitulo,cNumDocto,cUsuario)  

Local aAreaAnt := GetArea()
Local bCampo
Local oDlg, oGet
Local nAcols   := 0
Local nOpca    := 0
Local cCampos  := ""
Local cSituaca := ""
Local oBold

Local aColsAnt   := Iif( Type("aCols")#"A",{},aClone(aCols) )
Local aHeaderAnt := Iif( Type("aHeader")#"A",{},aClone(aHeader) )

Private aCols    := {}
Private aHeader  := {}

/*--------------------------------------------------------+
| Abre o arquivo SCR sem filtros                          |
+---------------------------------------------------------*/
ChkFile("SCR",.F.,"TMP")
DbSelectArea("TMP")
TMP->(DbSetOrder(1), DbSeek(xFilial("SCR")+cCRTipo+cCRNum,.F.))

/*--------------------------------------------------------+
| Monta a entrada de dados do arquivo                     |
+---------------------------------------------------------*/
Private aTELA[0][0],aGETS[0],Continua,nUsado:=0

/*--------------------------------------------------------+
| Faz a montagem do aHeader com os campos fixos.          |
+---------------------------------------------------------*/
cCampos := "CR_NIVEL/CR_OBS/CR_DATALIB"
dbSelectArea("SX3")
dbSetOrder(1)
dbSeek("SCR")
While !EOF() .And. (x3_arquivo == "SCR")
	IF AllTrim(x3_campo)$cCampos
		nUsado++
		AADD(aHeader,{ TRIM(x3titulo()), x3_campo, x3_picture,x3_tamanho, x3_decimal, x3_valid,x3_usado, x3_tipo, x3_arquivo, x3_context } )
		If AllTrim(x3_campo) == "CR_NIVEL"
			AADD(aHeader,{ OemToAnsi("Usuario")     ,"bCR_NOME"   , "@", 15, 0, "","","C","",""} )
			nUsado++		
			AADD(aHeader,{ OemToAnsi("Situacao")    ,"bCR_SITUACA", "@", 20, 0, "","","C","",""} )
			nUsado++						
			AADD(aHeader,{ OemToAnsi("Aprovado por"),"bCR_NOMELIB", "@", 15, 0, "","","C","",""} )
			nUsado++						
		EndIf					 
	Endif
	dbSkip()
End
dbSelectArea("TMP")
While !TMP->(Eof()) .And. TMP->(CR_FILIAL+CR_TIPO+Rtrim(CR_NUM)) == xFilial("SCR")+cCRTipo+RTrim(cCRNum)
	aadd(aCols,Array(nUsado+1))
	nAcols ++
	For nCntFor := 1 To nUsado
		If aHeader[nCntFor][02] == "bCR_NOME"
			aCols[nAcols][nCntFor] := Capital(UsrFullName(TMP->CR_USER))
		ElseIf aHeader[nCntFor][02] == "bCR_SITUACA"
		   Do Case
				Case TMP->CR_STATUS == "01"
					cSituaca := OemToAnsi("Aguardando Liberação")
				Case TMP->CR_STATUS == "02"
					cSituaca := OemToAnsi("Em Aprovação")
				Case TMP->CR_STATUS == "03"
					cSituaca := OemToAnsi("Aprovado")					
				Case TMP->CR_STATUS == "04"
					cSituaca := OemToAnsi("Bloqueado")	
					//lBloq := .T.
				Case TMP->CR_STATUS == "05"
					cSituaca := OemToAnsi("Nivel Liberado ") 
				EndCase
			aCols[nAcols][nCntFor] := cSituaca
		ElseIf aHeader[nCntFor][02] == "bCR_NOMELIB"
			aCols[nAcols][nCntFor] := Capital(UsrFullName(TMP->CR_USERLIB))			
		ElseIf ( aHeader[nCntFor][10] != "V")
			aCols[nAcols][nCntFor] := FieldGet(FieldPos(aHeader[nCntFor][2]))
		EndIf
	Next nCntFor
	aCols[nAcols][nUsado+1] := .F.
	dbSkip()
EndDo

If Empty(aCols)
	MsgInfo("Este documento não possui controle de Alçada de Aprovação.","Controle de Aprovação")
Else
	
	Continua := .F.
	nOpca 	  := 0
	DEFINE FONT oBold NAME "Arial" SIZE 0, -12 BOLD
	DEFINE MSDIALOG oDlg TITLE OEMTOANSI("Aprovação de " + Capital(cTitulo)) From 109,95 To 400,600 OF oMainWnd PIXEL
		@ 5,3 TO 32,250 LABEL "" OF oDlg PIXEL
		@ 15,7 SAY OemToAnsi("No. Docto.") Of oDlg FONT oBold PIXEL SIZE 46,9 
		@ 14,40 MSGET cNumDocto Picture "@"  When .F. PIXEL SIZE 38,9 Of oDlg FONT oBold
		@ 15,110 SAY OemToAnsi("Usuário")  Of oDlg PIXEL SIZE 33,9 FONT oBold
		@ 14,138 MSGET Capital(RTrim(UsrFullName(cUsuario))) Picture "@" When .F. of oDlg PIXEL SIZE 103,9 FONT oBold
		@ 132,8 SAY OemToAnsi("Situação: ") Of oDlg PIXEL SIZE 52,9
		@ 132,38 SAY cSituaca Of oDlg PIXEL SIZE 120,9 FONT oBold
		@ 132,205 BUTTON "Fechar" SIZE 35 ,10  FONT oDlg:oFont ACTION (oDlg:End()) Of oDlg PIXEL
		oGet := MSGetDados():New(38,3,120,250,1,,,"")
	   @ 126,2   TO 127,250 LABEL '' OF oDlg PIXEL
	ACTIVATE MSDIALOG oDlg CENTERED

EndIf

dbCloseArea("TMP")

aCols   := aClone(aColsAnt)
aHeader := aClone(aHeaderAnt)
RestArea(aAreaAnt)

Return nOpca
