#include "PROTHEUS.CH"
#include "tbiconn.ch"
#include "tbicode.ch"
#include "font.ch"

#Define ENTER Chr(13)+Chr(10)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออปฑฑ
ฑฑบPrograma  ณ WebTK270()  บ Autor ณ Fernando Nogueira  บ Data ณ23/10/2013บฑฑ
ฑฑฬออออออออออุอออออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออนฑฑ
ฑฑบDescrio ณ Programa de abertura de chamados...	  (Copy TOTVS)        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico AVANT.                   	                      บฑฑ
ฑฑฬออออออออออฯอออัออออออออัอออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAnalista Resp.ณ  Data  ณ Manutencao Efetuada                           บฑฑ
ฑฑฬออออออออออออออุออออออออุอออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ              ณ  /  /  ณ                                               บฑฑ
ฑฑบ              ณ  /  /  ณ                                               บฑฑ
ฑฑศออออออออออออออฯออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function WebTK270( cAlias, nRecNo, nOpc )

	Local cAlias1		:= "SZU"
	Local nRecno		:= SZU->( RECNO() )
	Local nX       	   	:= 0
	Local xOpc			:= 0

	Private lOpenProc	:= IIF( GetNewPar("ES_NOTIF","S") == "S" , .T. , .F. )
	Private cTexto		:= ""
	Private aBotoes		:= {}
	Private aTela    	:= {}
	Private aGets    	:= {}
	Private aCposEnch	:= { "ZU_CHAMADO" }
	Private aAlter		:= { "ZU_CHAMADO" }
	Private bCampo   	:= {|nField| FieldName(nField) }
	Private aPosEnch	:= { 017,005,115,360 }
	Private oDlg

	Private bOk			:= {|| IIF(TecTudoOk(),(xOpc:=1,oDlg:End()),Nil) }
	Private	bCancel 	:= {|| xOpc:=0,oDlg:End() }
	Private lVisual		:= .F.

	Private lVisual		:= IIF( nOpc == 2 , .T. , .F. )
	Private lInclui		:= IIF( nOpc == 3 , .T. , .F. )

	DEFINE FONT oFontPad  NAME "Tahoma" 	SIZE 0, -12

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Barra de botoes ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If lVisual
		aAdd( aBotoes,{ "HISTORIC",{|| u_LJVerHist() },OemToAnsi("Hist๓rico") })
	Endif

	PswOrder(2)
	If PswSeek( AllTrim(cUserName) , .T. )
		aTecnico := PswRet()
		aDados	 := aTecnico[1]
		cTecnico := RTrim(aDados[4])
	Endif

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Carrega as informacoes se Visualizacao ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If lVisual

		PswOrder(1)
		If PswSeek( SZU->ZU_TECNICO , .T. )
			aTecnico := PswRet()
			aDados	:= aTecnico[1]
			cTecnico := RTrim(aDados[4])
		Endif

		DbSelectArea("SZU")
		For nX := 1 To FCount()
			M->&(Eval(bCampo,nX)) := FieldGet(nX)
		Next nX

		SZV->( DbSetOrder(1) )
		SZV->( DbSeek( xFilial("SZV") + SZU->ZU_CHAMADO + "001" ) )

		SZB->( DbSetOrder(1) )
		SZB->( DbSeek( xFilial("SZB") + SZU->ZU_ROTINA ) )

		cTexto := u_GETTexto(SZV->ZV_CODSYP)

	Else

		DbSelectArea("SZU")
		For nX := 1 To FCount()
			M->&(Eval(bCampo,nX)) := CriaVar(FieldName(Nx))
		Next nX

	Endif

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Cria a interface ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

	DbSelectArea("SZU")

	oDlg := TDialog():New(263,234,720,968,"Abertura de chamados",,,,,,,,oMainWnd,.T.)

	oEnchoice := MsMGet():New(cAlias1,nRecno,nOpc,,,,aCposEnch,aPosEnch,,3,,,,,,.T.)

	@ 122,006 TO 222,360 LABEL " Detalhamento  " PIXEL OF oDlg

	IF lVisual
		@ 133,011 GET oMemo2 Var cTexto MEMO Size 342,082 FONT oFontPad READONLY PIXEL OF oDlg
	Else
		@ 133,011 GET oMemo2 Var cTexto MEMO Size 342,082 FONT oFontPad  PIXEL OF oDlg
	Endif

	oDlg:Activate(,,,.T.,,,{||EnchoiceBar(oDlg,bOk,bCancel,,aBotoes)},,)

	a := 1

	Do Case

		Case xOpc == 1

			If lInclui .And. !lVisual

				Begin Transaction

				DbSelectArea("SZU")
				DbSetOrder(1)
				RecLock( "SZU" , .T. )
			    	ConfirmSx8()
					SZU->ZU_FILIAL	:= xFilial("SZU")
					SZU->ZU_CHAMADO	:= M->ZU_CHAMADO
					SZU->ZU_DATA	:= ddatabase
					SZU->ZU_DATAORI	:= Date()
					SZU->ZU_DATAATU	:= Date()
					SZU->ZU_CODUSR  := m->ZU_CODUSR
					SZU->ZU_NOMEUSR := m->ZU_NOMEUSR
					SZU->ZU_MAILUSR := lower(m->ZU_MAILUSR)
					SZU->ZU_TELUSR  := m->ZU_TELUSR
					SZU->ZU_CODSUP  := m->ZU_CODSUP
					SZU->ZU_NOMESUP := m->ZU_NOMESUP
					SZU->ZU_MAILSUP := lower(m->ZU_MAILSUP)
					SZU->ZU_EMAILS  := lower(m->ZU_EMAILS)
					SZU->ZU_STATUS	:= "A"
					SZU->ZU_DIVISAO	:= m->ZU_DIVISAO
					SZU->ZU_ROTINA	:= m->ZU_ROTINA
					SZU->ZU_HRABERT	:= Time()
					SZU->ZU_ASSUNTO := m->ZU_ASSUNTO
					SZU->ZU_TECNICO	:= "AUTOMA"
					SZU->ZU_FEEDBAC	:= "S"
					SZU->ZU_DATAOK  := DataValida(ddatabase+1)//Data prevista para encerramento
					SZU->ZU_IP_ADDR := m->ZU_IP_ADDR
				MsUnLock()

				DbSelectArea("SZV")
				RecLock( "SZV" , .T. )
					SZV->ZV_FILIAL	:= xFilial("SZV")
					SZV->ZV_CHAMADO	:= M->ZU_CHAMADO
					SZV->ZV_DATA	:= ddatabase
					SZV->ZV_TIPO	:= "001"
					SZV->ZV_CODSYP	:= u_GrvMemo( cTexto , "ZV_CODSYP" )
					SZV->ZV_NUMSEQ	:= u_RetZVNum( M->ZU_CHAMADO )
					SZV->ZV_HORA	:= Time()
					SZV->ZV_TECNICO	:= RetCodUsr()
				MsUnLock()

				End Transaction

				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณ Registra a abertura do chamado para os supervisores ณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
				If lOpenProc
					LjMsgRun("Aguarde ... Atualizando dados ..."  ,, { || u_OpenProc(M->ZU_CHAMADO,"A",1) })
				Endif

				MsgInfo("Chamado n๚mero " + M->ZU_CHAMADO + " aberto com sucesso.",,"Sucesso !!")

			Endif

		OtherWise

			If lInclui .And. !lVisual
				RollBackSx8()
			Endif

	EndCase

Return()
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออปฑฑ
ฑฑบFuno    ณ RetZVNum()  บ Autor ณ Fernando Nogueira  บ Data ณ23/10/2013บฑฑ
ฑฑฬออออออออออุอออออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออนฑฑ
ฑฑบDescricao ณ Numero sequencial do Chamado                               บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function RetZVNum( __cChamado )

	Local aArea := GetArea()

	BeginSql alias "TRB"

		%noparser%

		Select IsNull(Max(SZV.ZV_NUMSEQ),'001') ZV_NUMSEQ
		From %table:SZV% SZV
		Where SZV.%notDel% And ZV_FILIAL = %xfilial:SZV%
		  And SZV.ZV_CHAMADO = %exp:__cChamado%

	EndSql

	__cNum := trb->ZV_NUMSEQ
	DbSelectArea('TRB')
	TRB->(DbCloseArea())

	RestArea(aArea)

Return(__cNum)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออปฑฑ
ฑฑบFuno    ณ ExItens()   บ Autor ณ TOTVS SA           บ Data ณ27/10/2011บฑฑ
ฑฑฬออออออออออุอออออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออนฑฑ
ฑฑบDescricao ณGrava na tabela SYP um campo memo                           บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function GrvMemo( cVariavel , _CampoCod )

	_aMemoArea 		:= GetArea()
	_cChave 		:= ""
	nLines 			:= 0
	Seq				:= 0
	nLines 			:= MLCount( cVariavel , 80 , 0 , .F. )

	If !Empty(cVariavel)

		//_cChave := u_NextSYP()
		_cChave := GetSX8Num("SYP",PrefixoCpo("SYP")+"_CHAVE")

		nCpo 	:= cVariavel
		xCpo	:= ""
		xCpo2 := ""

		For s := 1 To Len(nCpo)
			If ASC(Substr(nCpo,s,1)) <> 13
				xCpo := xCpo + Substr(nCpo,s,1)
			Else
				xCpo := xCpo + "<br>"
			Endif
		Next

		For s := 1 To Len(xCpo)
			If ASC(Substr(xCpo,s,1)) == 32 .And. Mod(s-1,80) == 0
				xCpo2 := xCpo2 + Substr(xCpo,s,1) + " "
			Else
				xCpo2 := xCpo2 + Substr(xCpo,s,1)
			Endif
		Next

		xVariavel := xCpo2

		DbSelectArea("SYP")
		DbSetOrder(1)
		For Seq := 1 To nLines
			RecLock("SYP",.T.)
				SYP->YP_FILIAL	:= xFilial("SYP")
				SYP->YP_CHAVE	:= _cChave
				SYP->YP_SEQ		:= StrZero(Seq,3)
				SYP->YP_TEXTO	:= MemoLine( xVariavel , 80 , Seq , 0 , .F. )
				SYP->YP_CAMPO 	:= _CampoCod
			MsUnLock()
		Next

		ConfirmSX8()

	Endif

	RestArea( _aMemoArea )

Return( _cChave )
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออปฑฑ
ฑฑบFuno    ณ NextSYP()   บ Autor ณ TOTVS SA           บ Data ณ27/10/2011บฑฑ
ฑฑฬออออออออออุอออออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออนฑฑ
ฑฑบDescricao ณObtem proximo numero para gravacao do campo Atendimento     บฑฑ
ฑฑบ          ณ(MEMO) no arquivo de campos memos SYP **  ES_SEQSYP         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function NextSYP()

	_aAlias	  := GetArea()
	_cNumAtu  := GetMv("ES_SEQSYP")
	_cProximo := Soma1(_cNumAtu)
	_cPadrao  := GetSxeNum("SYP","YP_CHAVE")

	If _cProximo < _cPadrao
		//Aviso("Tabela SYP",	"Um erro foi detectado no controle da numera็ใo sequencial dos itens dos chamados. Nใo ้ possํvel a inser็ใo de registros." + CHR(10) + ;
		//					"Para que voc๊ nใo perca sua movimenta็ใo um ajuste nesta sequencia serแ feito e a grava็ใo irแ continuar normalmente." + CHR(10) + ;
		//					"A sequencia atual " + _cProximo + " serแ ajustada para " + Soma1(_cPadrao) , {"     Ok     "} ,3 ,"Informa็ใo")
		_cProximo := Soma1(_cPadrao)
	Endif

	// Acerta deletados SYP
	U_Acerta_SYP()

    DbSelectArea("SX6")
    DbSetOrder(1)
    If DbSeek( Space(6) + "ES_SEQSYP" )
    	RecLock("SX6",.F.)
	    	SX6->X6_CONTEUD	:= _cProximo
	    	SX6->X6_CONTSPA	:= _cProximo
	    	SX6->X6_CONTENG	:= _cProximo
	    MsUnLock()
    Else
    	MsgInfo("O parametro ES_SEQSYP nao foi encontrado. A rotina nao podera prosseguir. Entre em contato com o Administrador do Sistema.","MV_SEQSYP Nao Cadastrado","INFO")
    	Final("Parametro ES_SEQSYP nao encontrado.")
    Endif

    RestArea( _aAlias )

Return( _cProximo )
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออปฑฑ
ฑฑบFuno    ณ __VldObrig()บ Autor ณ TOTVS SA           บ Data ณ27/10/2011บฑฑ
ฑฑฬออออออออออุอออออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออนฑฑ
ฑฑบDescricao ณValidacao dos campos referentes ao Debito Automatico        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function __VldObrig(cCampo)

	lRet	 := .T.
	cMSGHELP := ""

	Do Case

		Case cCampo $ "cContato/cMemo"

			If Empty(&cCampo)
				lRet := .F.
			Endif

		Case cCampo $ "cTelefone"

			cMSGHELP := "O campo n๚mero de telefone deve ser" + CHR(13) + CHR(10)
			cMSGHELP += "informado corretamente."

			cNaoPermite := "(011) 9999-9999/(011) 9999-1234/(011) 1111-1111/(011) 2222-2222/(011) 3333-3333/(011) 4444-4444"
			cNaoPermite += "(011) 5555-5555/(011) 6666-6666/(011) 7777-7777/(011) 8888-8888/"
			cNaoPermite += "(111) 1111-1111/(111) 2222-2222/(111) 3333-3333/(111) 4444-4444/(111) 5555-5555/(111) 6666-6666"
			cNaoPermite += "(111) 7777-7777/(111) 8888-8888/(111) 9999-9999"
			cNaoPermite += "(222) 1111-1111/(222) 2222-2222/(222) 3333-3333/(222) 4444-4444/(222) 5555-5555/(222) 6666-6666"
			cNaoPermite += "(222) 7777-7777/(222) 8888-8888/(222) 9999-9999"
			cNaoPermite += "(333) 1111-1111/(333) 2222-2222/(333) 3333-3333/(333) 4444-4444/(333) 5555-5555/(333) 6666-6666"
			cNaoPermite += "(333) 7777-7777/(333) 8888-8888/(333) 9999-9999"
			cNaoPermite += "(444) 1111-1111/(444) 2222-2222/(444) 3333-3333/(444) 4444-4444/(444) 5555-5555/(444) 6666-6666"
			cNaoPermite += "(444) 7777-7777/(444) 8888-8888/(444) 9999-9999"
			cNaoPermite += "(555) 1111-1111/(555) 2222-2222/(555) 3333-3333/(555) 4444-4444/(555) 5555-5555/(555) 6666-6666"
			cNaoPermite += "(555) 7777-7777/(555) 8888-8888/(555) 9999-9999"
			cNaoPermite += "(666) 1111-1111/(666) 2222-2222/(666) 3333-3333/(666) 4444-4444/(666) 5555-5555/(666) 6666-6666"
			cNaoPermite += "(666) 7777-7777/(666) 8888-8888/(666) 9999-9999"
			cNaoPermite += "(777) 1111-1111/(777) 2222-2222/(777) 3333-3333/(777) 4444-4444/(777) 5555-5555/(777) 6666-6666"
			cNaoPermite += "(777) 7777-7777/(777) 8888-8888/(777) 9999-9999"
			cNaoPermite += "(888) 1111-1111/(888) 2222-2222/(888) 3333-3333/(888) 4444-4444/(888) 5555-5555/(888) 6666-6666"
			cNaoPermite += "(888) 7777-7777/(888) 8888-8888/(888) 9999-9999"
			cNaoPermite += "(999) 1111-1111/(999) 2222-2222/(999) 3333-3333/(999) 4444-4444/(999) 5555-5555/(999) 6666-6666"
			cNaoPermite += "(999) 7777-7777/(999) 8888-8888/(999) 9999-9999"

			If Empty(&cCampo)
				lRet := .F.
			Elseif Len(cTelefone) < 15
				lRet := .F.
			Elseif cTelefone $ cNaoPermite
				lRet := .F.
			Elseif Substr(cTelefone,2,3) $ "111/222/333/444/555/666/777/888/999/000"
				lRet := .F.
			Elseif Substr(cTelefone,7,4) $ "1111/2222/3333/4444/5555/6666/7777/8888/0000"
				lRet := .F.
			Elseif Substr(cTelefone,2,1) <> "0"
				lRet := .F.
			Endif

	EndCase

	If !lRet
		Help("",1,".ERRO.",,IIF(Len(cMSGHELP)>1,cMSGHELP,"Campos obrigatorios nao preenchidos"),4,0)
	Endif

Return ( lRet )
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออปฑฑ
ฑฑบFuno    ณ __LJAtu()   บ Autor ณ TOTVS SA           บ Data ณ27/10/2011บฑฑ
ฑฑฬออออออออออุอออออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออนฑฑ
ฑฑบDescricao ณAtualiza o nome da rotina selecionada                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function __RotAtu()

	Local lRet	:= .T.

	cNomeRotina	:= LTrim(SX5->X5_DESCRI)
	oNomeRotina:Refresh()

Return( lRet )
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออปฑฑ
ฑฑบFuno    ณ __LJAtu()   บ Autor ณ TOTVS SA           บ Data ณ27/10/2011บฑฑ
ฑฑฬออออออออออุอออออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออนฑฑ
ฑฑบDescrio ณ Retorna a somatoria de todas as strings gravadas na tabela บฑฑ
ฑฑบ          ณ SYP ( descricao de campo memo )                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function GETTexto( cRef , lWeb )

	Local cTexto 	:= ""
	Local _Texto 	:= ""
	Local _aArea	:= GetArea()
	Local lWeb		:= IIF( lWeb == Nil , .F. , lWeb )

	DbSelectArea("SYP")
	DbSetOrder(1)
	If DbSeek( xFilial("SYP") + cRef )

		dbEval( {|| cTexto += SYP->YP_TEXTO  },,{|| SYP->YP_CHAVE==cRef },,,)

		xTexto := cTexto

		If !lWeb
			For s := 1 To Len(xTexto)
				If Lower(Substr(xTexto,s,4)) == "<br>"
					_Texto := _Texto + CHR(13)
					s := s + 3
				Else
					_Texto := _Texto + Substr(xTexto,s,1)
				Endif
			Next
		Else
			For s := 1 To Len(xTexto)
				If Lower(Substr(xTexto,s,4)) == "<br>"
					_Texto := _Texto + "<br>"
					s := s + 4
				Else
					_Texto := _Texto + Substr(xTexto,s,1)
				Endif
			Next
		Endif

	Endif

	RestArea( _aArea )

Return( _Texto )
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออปฑฑ
ฑฑบFuno    ณ __LJAtu()   บ Autor ณ TOTVS SA           บ Data ณ27/10/2011บฑฑ
ฑฑฬออออออออออุอออออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออนฑฑ
ฑฑบDescricao ณVerifica se todos os campos obrigatorios foram preenchidos  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function TecTudoOk()

	Local lRet		:= .T.

	lRet := Obrigatorio(aGets,aTela)

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Valida os campos referente a queda de link ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If M->ZU_DIVISAO == "03" .And. ( EMPTY(M->ZU_PROTOC) .Or. EMPTY(M->ZU_OPERADO) ) .And. lRet
		Aviso("","Campos obrigat๓rios nใo foram preenchidos. Reveja os Campos Protocolo/Atendente",{"Voltar"},2,"Campos obrigat๓rios")
		lRet := .F.
	Endif

	If Empty(cTexto)
		Aviso("","Campos obrigat๓rios nใo foram preenchidos. Reveja o Campo Detalhamento",{"Voltar"},2,"Campos obrigat๓rios")
		lRet := .F.
	Endif

Return(lRet)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออปฑฑ
ฑฑบFuno    ณ __LJAtu()   บ Autor ณ TOTVS SA           บ Data ณ27/10/2011บฑฑ
ฑฑฬออออออออออุอออออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออนฑฑ
ฑฑบDescricao ณValida os campos obrigatorios na manipulacao do chamado.    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function TecOk()

	Local lRet	:= .T.

	If Empty(AllTrim(cTexto))
		MsgStop("Digite o detalhamento do processo no campo indicado.",,"INFO")
		lRet := .F.
	Endif

	If lRet
		If Empty(cCodAcao)
			MsgStop("Informe o c๓digo da anแlise corretamente",,"INFO")
			lRet := .F.
		Endif
	Endif

Return(lRet)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออปฑฑ
ฑฑบFuno    ณ TecEdit()   บ Autor ณ TOTVS SA           บ Data ณ27/10/2011บฑฑ
ฑฑฬออออออออออุอออออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออนฑฑ
ฑฑบDescricao ณManipulacao do chamado                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function TecEdit()

	Local oOk   	:= LoadBitmap( GetResources(), "BR_VERDE_OCEAN" )   //CHECKED    //LBOK  //LBTIK
	Local oNo  	    := LoadBitmap( GetResources(), "BR_VERMELHO_OCEAN" ) //UNCHECKED  //LBNO
	Local lOpenProc	:= IIF( GetNewPar("ES_NOTIF","S") == "S" , .T. , .F. )
	Local aArea		:= GetArea()
	Local lEncerra	:= .F.

	Private cChamado 	:= SZU->ZU_CHAMADO
	Private cCodLoja 	:= SZU->ZU_CODLOJA
	Private cNome 		:= SZU->ZU_LOJA
	Private cCodAcao 	:= Space(3)
	Private cAcao 		:= Space(1)
	Private cView 		:= Space(1)
	Private cTexto		:= ""
	Private aHistorico	:= u_RetHistory(SZU->ZU_CHAMADO)
	Private bOk			:= {|| IIF(TecOk(),(xOpc:=1,oDlg:End()),Nil) }
	Private	bCancel 	:= {|| xOpc:=0,oDlg:End() }
	Private xOpc		:= 0
	Private aBotoes		:= {}

/*	PswOrder(2)
	If PswSeek( RTrim(Substr(cUsuario,7,15)) , .T. )
		aTecnico := PswRet()
		aDados	 := aTecnico[1]
		cTecName := RTrim(aDados[4])
	Endif
*/
	If cNivel > 6
		aAdd( aBotoes,{ "EXCLUIR",{|| MsDelItem(@aHistorico) },OemToAnsi("Remover linha") })
	Endif

	DEFINE FONT oFontPad  NAME "Tahoma" 	SIZE 0, -12

	DbSelectArea("SZU")

	If SZU->ZU_STATUS == "C"
		MsgInfo("Nใo ้ possํvel manipular um chamado jแ encerrado. Primeiro fa็a a reabertura do chamado para depois manipulแ-lo.",,"INFO")
		Return
	Elseif SZU->ZU_STATUS == "F"
		MsgInfo("Chamado aguardando retorno com valida็ใo de encerramento. Solicite a confirma็ใo do chamado ou fa็a a re-abertura do chamado.",,"INFO")
		Return
	Endif

	DEFINE MSDIALOG oDlg FROM 065,000 TO 474,591 PIXEL TITLE "Manipula็ใo do Chamado" STYLE DS_MODALFRAME STATUS

		@ 014,004 FOLDER oFld OF oDlg PROMPT "&Anแlise" , "&Hist๓rico" , "&Cabe็alho do Chamado" PIXEL SIZE 290,188

		// Folder 1
		@ 006,006 TO 031,048 LABEL " Chamado "  PIXEL OF oFld:aDialogs[1]
		@ 006,051 TO 031,171 LABEL " Loja "     PIXEL OF oFld:aDialogs[1]
		@ 006,174 TO 031,281 LABEL " Analise"   PIXEL OF oFld:aDialogs[1]
		@ 033,006 TO 173,282 LABEL " Analise detalhada " PIXEL OF oFld:aDialogs[1]
		@ 016,011 MSGET oChamado VAR cChamado WHEN .F. SIZE 30,10 	PIXEL OF oFld:aDialogs[1]
		@ 016,056 MSGET oCodLoja VAR cCodLoja WHEN .F. SIZE 20,10 	PIXEL OF oFld:aDialogs[1]
		@ 016,083 MSGET oNome VAR cNome WHEN .F. SIZE 85,10			PIXEL OF oFld:aDialogs[1]
		@ 016,178 MSGET oCodAcao VAR cCodAcao F3 "SZG"  VALID LJAtuAcao(@cAcao) SIZE 27,10	PIXEL OF oFld:aDialogs[1]
		@ 016,207 MSGET oAcao VAR cAcao WHEN .F. SIZE 68,10			PIXEL OF oFld:aDialogs[1]
	  	@ 042,011 GET oTexto VAR cTexto MEMO SIZE 266,127 FONT oFontPad PIXEL OF oFld:aDialogs[1]
	  	oTexto:oFont:= oFontPad

		// Folder 2
		@ 003,004 TO 072,285 LABEL " Manipulacoes do chamado "		PIXEL OF oFld:aDialogs[2]
		@ 074,004 TO 171,285 LABEL " Detalhamento "					PIXEL OF oFld:aDialogs[2]
	  	@ 082,008 GET oView VAR cView MEMO SIZE 275,85 FONT oFontPad READONLY PIXEL OF oFld:aDialogs[2]
	  	oView:oFont:= oFontPad

	  	// Folder 3
		@ 011,009 LISTBOX oLbx VAR cVar FIELDS HEADER "Data","Hora","Tipo","Descricao","Origem" SIZE 271,057 OF oFld:aDialogs[2] PIXEL ;
		ON CHANGE u_UpdateMemo(oLbx:nAt)
		oLbx:SetArray( aHistorico )
		oLbx:LHScroll := .F.
		oLbx:bLine := {|| {   aHistorico[oLbx:nAt,1],;
                               aHistorico[oLbx:nAt,2],;
                		       aHistorico[oLbx:nAt,3],;
		                       aHistorico[oLbx:nAt,4],;
		                       aHistorico[oLbx:nAt,5]}}

	ACTIVATE MSDIALOG oDlg On Init EnchoiceBar(oDlg,bOk,bCancel,,aBotoes) Centered

	Do Case

		Case xOpc == 1

			Begin Transaction

			DbSelectArea("SZG")
			DbSetOrder(1)
			DbSeek( xFilial("SZG") + cCodAcao )

			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณ Faz a alocacao do chamado para o tecnico que realizar o primeiro complemento ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			RecLock("SZU",.F.)
				SZU->ZU_DATAATU	:= Date()
				IF SZU->ZU_TECNICO == "AUTOMA"
					SZU->ZU_TECNICO	:= RetCodUsr()
				Endif
			MsUnLock()


			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณ Gera registro de acompanhamento ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			DbSelectArea("SZV")
			RecLock( "SZV" , .T. )
				SZV->ZV_FILIAL	:= xFilial("SZV")
				SZV->ZV_CHAMADO	:= cChamado
				SZV->ZV_DATA	:= ddatabase
				SZV->ZV_TIPO	:= cCodAcao
				SZV->ZV_CODSYP	:= u_GrvMemo( cTexto , "ZV_CODSYP" )
				SZV->ZV_NUMSEQ	:= u_RetZVNum( cChamado )
				SZV->ZV_HORA	:= Time()
				SZV->ZV_TECNICO	:= RetCodUsr()
			MsUnLock()


			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณ Da baixa no chamado de acordo com o tipo da analise ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			IF SZG->ZG_ENCERRA == "S" .AND. SZG->ZG_TRANSF != "S"

				lEncerra:= .T.
				cHr		:= Time()
				cMsg 	:= "Em " + DTOC(Date()) + " as " + cHr + " o usuแrio " + cTecName + " encerrou este chamado."

				Begin Transaction

					DbSelectArea("SZU")
					DbSetOrder(1)
					If DbSeek( xFilial("SZU") + cChamado  )
						RecLock("SZU",.F.)
							SZU->ZU_FEEDBAC	:= ""
							SZU->ZU_STATUS	:= "F"
							SZU->ZU_DATAOK	:= ddatabase
							SZU->ZU_HROK	:= Time()
						MsUnLock()
					Endif

					DbSelectArea("SZV")
					RecLock( "SZV" , .T. )
						SZV->ZV_FILIAL	:= xFilial("SZV")
						SZV->ZV_CHAMADO	:= SZU->ZU_CHAMADO
						SZV->ZV_DATA	:= ddatabase
						SZV->ZV_TIPO	:= SZG->ZG_CODIGO
						SZV->ZV_CODSYP	:= u_GrvMemo( cMsg , "ZV_CODSYP" )
						SZV->ZV_NUMSEQ	:= u_RetZVNum( SZU->ZU_CHAMADO )
						SZV->ZV_HORA	:= cHr
						SZV->ZV_TECNICO	:= RetCodUsr()
					MsUnLock()

				End Transaction

				LjMsgRun("Aguarde ... Encerrando chamado ... "  ,, { || u_ConfEncerra(SZU->ZU_CHAMADO,DTOC(SZU->ZU_DATA),SZU->ZU_HRABERT,SZU->ZU_TECNICO,cTexto,alltrim(SZU->ZU_MAILUSR)+';'+alltrim(SZU->ZU_MAILSUP)+';'+alltrim(SZU->ZU_EMAILS)) })

			Elseif SZG->ZG_TRANSF == "S" .And. SZG->ZG_ENCERRA !="S'

				cHr		:= Time()
				cMsg 	:= "Em " + DTOC(Date()) + " as " + cHr + " o usuแrio " + cTecName + " transferiu este chamado para: " + Tabela("ZZ",SZG->ZG_AREA)

				Begin Transaction
					DbSelectArea("SZU")
					DbSetOrder(1)
					If DbSeek( xFilial("SZU") + cChamado  )
						RecLock("SZU",.F.)
							SZU->ZU_TECNICO	:= "AUTOMA"			// Deixa o chamado novamente sem alocacao pois foi transferido
							SZU->ZU_STATUS	:= "T"
							SZU->ZU_DIVISAO	:= SZG->ZG_AREA
							SZU->ZU_FEEDBAC	:= "S"				// Aguarda Feedback do Suporte
						MsUnLock()
					Endif

					DbSelectArea("SZV")
					RecLock( "SZV" , .T. )
						SZV->ZV_FILIAL	:= xFilial("SZV")
						SZV->ZV_CHAMADO	:= SZU->ZU_CHAMADO
						SZV->ZV_DATA	:= ddatabase
						SZV->ZV_TIPO	:= SZG->ZG_CODIGO
						SZV->ZV_CODSYP	:= u_GrvMemo( cMsg , "ZV_CODSYP" )
						SZV->ZV_NUMSEQ	:= u_RetZVNum( SZU->ZU_CHAMADO )
						SZV->ZV_HORA	:= cHr
						SZV->ZV_TECNICO	:= RetCodUsr()
					MsUnLock()
                End Transaction

			Else

				DbSelectArea("SZU")
				DbSetOrder(1)
				If DbSeek( xFilial("SZU") + cChamado  )
					RecLock("SZU",.F.)
						SZU->ZU_STATUS	:= "E"
						IF !EMPTY(SZG->ZG_FEEDBAC)
							SZU->ZU_FEEDBAC	:= SZG->ZG_FEEDBAC
						Endif
					MsUnLock()
				Endif

			Endif

			End Transaction

			If lOpenProc
				IF lEncerra
					LjMsgRun("Enviando mensagem ... Aguarde .."  ,, { || u_OpenProc(cChamado,"E",2) })
				Else
					IF MsgYesNo("Deseja enviar a ficha do chamado atualizado via e-mail para o cliente ?","Atualiza็ใo")
						LjMsgRun("Enviando mensagem ... Aguarde .."  ,, { || u_OpenProc(cChamado,"C",2) })
					Endif
				Endif
			Endif

	EndCase

	RestArea(aArea)

Return(IIF(xOpc==1,.T.,.F.))
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออปฑฑ
ฑฑบFuno    ณ TecEdit()   บ Autor ณ TOTVS SA           บ Data ณ27/10/2011บฑฑ
ฑฑฬออออออออออุอออออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออนฑฑ
ฑฑบDescricao ณAtualiza campo memo de acordo com a linha do listbox        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function UpdateMemo( __Lin )

	Local _aArea  := GetArea()
	Local aNewRet := {}

	cView := u_GetTexto( AllTrim( aHistorico[__Lin,6] ) )
	oView:Refresh()

	RestArea(_aArea)

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออปฑฑ
ฑฑบFuno    ณ RetHistory()บ Autor ณ TOTVS SA           บ Data ณ27/10/2011บฑฑ
ฑฑฬออออออออออุอออออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออนฑฑ
ฑฑบDescricao ณCarrega e retorna um vetor contendo todas as ocorrencias de บฑฑ
ฑฑบ          ณum chamado.                                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function RetHistory( pChamado )

	Local aRet	:= {}
	Local cSZV	:= RETSQLNAME("SZV")
	Local cSZG	:= RETSQLNAME("SZG")
	Local aSave1:= GetArea()

	If Select("TRB") > 0
		DbSelectArea("TRB")
		DbCloseArea()
	Endif

	cSQL := "SELECT ZV_DATA,ZV_HORA,ZV_TIPO,ZG_DESCRI,ZV_TECNICO,ZV_CODSYP,SZV.R_E_C_N_O_ AS NREG FROM "
	cSQL += cSZV + " SZV, " + cSZG + " SZG WHERE ZV_TIPO = ZG_CODIGO AND "
	cSQL += "ZV_CHAMADO = '" + pChamado  + "' AND SZV.D_E_L_E_T_ = ' ' AND SZG.D_E_L_E_T_ = ' ' ORDER BY ZV_NUMSEQ"
	DBUSEAREA( .T.,"TOPCONN",TCGenQry(,,cSQL),'TRB',.F.,.T.)

	DbSelectArea("TRB")
	DbGoTop()
	While !Eof()

		cDetalhe := u_GetTexto( AllTrim( TRB->ZV_CODSYP ) )

		aAdd(aRet,{ DTOC(STOD(TRB->ZV_DATA)),TRB->ZV_HORA,TRB->ZV_TIPO,RTrim(TRB->ZG_DESCRI),u_RetTecName(TRB->ZV_TECNICO),TRB->ZV_CODSYP,TRB->NREG,Substr(cDetalhe,1,70)  })
		DbSelectArea("TRB")
		DbSkip()
	End

	DbCloseArea()

	If Len(aRet) == 0
		aAdd(aRet,{"","","","","","","",""})
	Endif

	RestArea(aSave1)

Return(aRet)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออปฑฑ
ฑฑบFuno    ณ RetTecName()บ Autor ณ TOTVS SA           บ Data ณ27/10/2011บฑฑ
ฑฑฬออออออออออุอออออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออนฑฑ
ฑฑบDescricao ณRetorna o nome do tecnico em questao atraves do PPSWSeek    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function RetTecName(CodUsuario)

	Local xRet	:= ""
	Local aArea	:= GetArea()

	PswOrder(1)
	If CodUsuario == "000000"
		xRet := "Sistema"
	Elseif CodUsuario == "AUTOMA"
		xRet := "ALOCACAO AUTOMมTICA"
	Else
		If PswSeek( CodUsuario , .T. )
			aTecnico := PswRet()
			aDados	 := aTecnico[1]
			xRet	 := RTrim(aDados[4])
		Endif
	Endif

	RestArea(aArea)

Return( RTrim(xRet) )
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออปฑฑ
ฑฑบFuno    ณConfEncerra()บ Autor ณ TOTVS SA           บ Data ณ27/10/2011บฑฑ
ฑฑฬออออออออออุอออออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออนฑฑ
ฑฑบDescricao ณEnvia email de confirmacao do encerramento do chamado       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function ConfEncerra(cChamado,cDTAbertura,cHora,cTecnico,cTexto,cEMail)

	Local oEncerra
	Local oHTML
	Local cNomeTecnico 	:= "Administrador"

	PswOrder(1)
	If PswSeek( cTecnico , .T. )
		aTecnico 		:= PswRet()
		aDados	 		:= aTecnico[1]
		cNomeTecnico 	:= RTrim(aDados[4])
		cMailTo			:= AllTrim(aDados[14])
	Endif

	DbSelectArea("SZV")
	cSolucao := "O t้cnico " + cNomeTecnico + " encerrou o chamado apresentando a seguinte solu็ใo: " + cTexto

	DbSetOrder(1)
	DbSeek( xFilial("SZV") + cChamado )
	cProblema := u_GETTexto(SZV->ZV_CODSYP)

	oEncerra := TWFProcess():New("300001","Conf de encerramento de chamado")
	oEncerra:NewTask("300001","\MODELOS\ENCERRAOK.HTM")

	oEncerra:oHtml:ValByName("cChamado",cChamado  )
	oEncerra:oHtml:ValByName("cGerente",cGerente  )
	oEncerra:oHtml:ValByName("cChamado",cChamado  )
	oEncerra:oHtml:ValByName("cDtAbertura",cDTAbertura  )
	oEncerra:oHtml:ValByName("cHora",cHora  )
	oEncerra:oHtml:ValByName("cTecnico",cNomeTecnico  )

	oEncerra:oHtml:ValByName("cAssunto",RTrim(SZU->ZU_ASSUNTO))
	oEncerra:oHtml:ValByName("cProblema",AllTrim(cProblema))
	oEncerra:oHtml:ValByName("cSolucao",AllTrim(cSolucao))

	oEncerra:cSubject	:= "Ref encerramento do seu chamado No " + cChamado
	oEncerra:bReturn 	:= "U_CONFOK(.T.)"
	oEncerra:bTimeOut 	:= {{"U_CNFTIMEOUT('" + cChamado + "')",1,0,0}}
	oEncerra:USerSiga	:= "000000"
	oEncerra:cTo		:= cEmail
	oEncerra:Start()

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออปฑฑ
ฑฑบFuno    ณ ConfOK()    บ Autor ณ TOTVS SA           บ Data ณ27/10/2011บฑฑ
ฑฑฬออออออออออุอออออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออนฑฑ
ฑฑบDescricao ณTrata o retorno da confirmacao de encerramento do chamado.A บฑฑ
ฑฑบ          ณLoja confirma ou nao o encerramento. Tratar esse retorno.   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function ConfOk(lOk,oEncerra)

//	CHKFile("SZU")
//	CHKFile("SZV")

	cChamado 	:= oEncerra:oHtml:RetByName('cChamado')
	cAprova		:= oEncerra:oHtml:RetByName('RbAprova')
	cMotivo		:= oEncerra:oHtml:RetByName('cObs')
	cCodAnalise	:= ""
	cTXT		:= " ** A confirmacao de encerramento deste chamado foi feita eletronicamente com sucesso."

    DbSelectArea("SX6")
    IF Substr(cAprova,1,1) == "S"
	    If DbSeek( "  ES_CODENCE" )
	    	cCodAnalise	:= RTRIM(SX6->X6_CONTEUD)
	    Endif
	Else
	    If DbSeek( "  ES_CODABER" )
	    	cCodAnalise	:= RTRIM(SX6->X6_CONTEUD)
	    Endif
    Endif

	IF Substr(cAprova,1,1) == "S"

		IF !Empty(AllTrim(cMotivo))
			cMotivo += cTXT
		Else
			cMotivo := LTrim(cTXT)
		Endif

		DbSelectArea("SZU")
		DbSetOrder(1)
		If DbSeek( xFilial("SZU") + cChamado )
			RecLock("SZU",.F.)
				SZU->ZU_DTCONF	:= Date()
				SZU->ZU_HRCONF	:= Time()
				SZU->ZU_STATUS	:= "C"
			MsUnLock()
		Endif

		DbSelectArea("SZV")
		RecLock( "SZV" , .T. )
			SZV->ZV_FILIAL	:= xFilial("SZV")
			SZV->ZV_CHAMADO	:= cChamado
			SZV->ZV_DATA	:= Date()
			SZV->ZV_TIPO	:= cCodAnalise
			SZV->ZV_CODSYP	:= u_GrvMemo( Alltrim(cMotivo) , "ZV_CODSYP" )
			SZV->ZV_NUMSEQ	:= u_RetZVNum( cChamado )
			SZV->ZV_HORA	:= Time()
			SZV->ZV_TECNICO	:= SZU->ZU_TECNICO
		MsUnLock()
		oEncerra:Finish()

	Else

		DbSelectArea("SZU")
		DbSetOrder(1)
		If DbSeek( xFilial("SZU") + cChamado )
			RecLock("SZU",.F.)
				SZU->ZU_STATUS	:= "A"
				SZU->ZU_DATAOK	:= CTOD("")
				SZU->ZU_HROK	:= ""
			MsUnLock()
		Endif

		DbSelectArea("SZV")
		RecLock( "SZV" , .T. )
			SZV->ZV_FILIAL	:= xFilial("SZV")
			SZV->ZV_CHAMADO	:= cChamado
			SZV->ZV_DATA	:= Date()
			SZV->ZV_TIPO	:= cCodAnalise
			SZV->ZV_CODSYP	:= u_GrvMemo( Alltrim(cMotivo) , "ZV_CODSYP" )
			SZV->ZV_NUMSEQ	:= u_RetZVNum( cChamado )
			SZV->ZV_HORA	:= Time()
			SZV->ZV_TECNICO	:= SZU->ZU_TECNICO
		MsUnLock()

	Endif

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออปฑฑ
ฑฑบFuno    ณ ConfOK()    บ Autor ณ TOTVS SA           บ Data ณ27/10/2011บฑฑ
ฑฑฬออออออออออุอออออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออนฑฑ
ฑฑบDescricao ณFaz a reabertura manual de um chamado encerrado.            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function LJReabre()

	Local cCodAnalise	:= GetMv("ES_CODABER")
	Local cTecnico		:= RetCodUsr()

	IF SZU->ZU_STATUS $ "A/E"
		MsgInfo("Este chamado ainda nใo foi encerrado para ser reaberto.",,"INFO")
		Return
	Endif

	PswOrder(1)
	If PswSeek( cTecnico , .T. )
		aTecnico 		:= PswRet()
		aDados	 		:= aTecnico[1]
		cNomeTecnico 	:= RTrim(aDados[4])
	Endif

	cMotivo := "O t้cnico " + cNomeTecnico + " realizou a reabertura manual desta chamado em " + DTOC(Date())

	IF MsgYesNo("Confirma a reabertura do chamado ?","Reabertura")

		Begin Transaction
		DbSelectArea("SZU")
		RecLock("SZU",.F.)
			SZU->ZU_STATUS	:= "E"
			SZU->ZU_DATAOK	:= CTOD("")
			SZU->ZU_HROK	:= ""
			SZU->ZU_DTCONF	:= CTOD("")
			SZU->ZU_HRCONF	:= ""
		MsUnLock()

		DbSelectArea("SZV")
		RecLock( "SZV" , .T. )
			SZV->ZV_FILIAL	:= xFilial("SZV")
			SZV->ZV_CHAMADO	:= SZU->ZU_CHAMADO
			SZV->ZV_DATA	:= Date()
			SZV->ZV_TIPO	:= cCodAnalise
			SZV->ZV_CODSYP	:= u_GrvMemo( cMotivo , "ZV_CODSYP" )
			SZV->ZV_NUMSEQ	:= u_RetZVNum( SZU->ZU_CHAMADO )
			SZV->ZV_HORA	:= Time()
			SZV->ZV_TECNICO	:= cTecnico
		MsUnLock()
		End Transaction

		MsgInfo("O chamado foi reaberto com sucesso. Ao encerrar este chamado um novo e-mail serแ enviado ao usuแrio.",,"INFO")

	Endif

Return()
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออปฑฑ
ฑฑบFuno    ณ ConfOK()    บ Autor ณ TOTVS SA           บ Data ณ27/10/2011บฑฑ
ฑฑฬออออออออออุอออออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออนฑฑ
ฑฑบDescricao ณCarrega todo o historico do chamado atual                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function LjVerHist()

	Local aArea		:= GetArea()

	Private cChamado 	:= SZU->ZU_CHAMADO
	Private cCodigo 	:= SZU->ZU_CODUSR
	Private cNome 		:= SZU->ZU_NOMEUSR
	Private aHistorico	:= u_RetHistory(SZU->ZU_CHAMADO)
	Private bOk			:= {|| xOpc:=1,oDlg2:End() }
	Private	bCancel 	:= {|| xOpc:=0,oDlg2:End() }
	Private xOpc		:= 0
	Private cView 		:= Space(1)

	// Acerta deletados SYP
	U_Acerta_SYP()

	DEFINE FONT oFontPad  NAME "Tahoma" 	SIZE 0, -12

	DbSelectArea("SZU")

	DEFINE MSDIALOG oDlg2 FROM 065,000 TO 474,591 PIXEL TITLE "Hist๓rico do Chamado" STYLE DS_MODALFRAME STATUS


		@ 014,004 FOLDER oFld OF oDlg2 PROMPT "&Hist๓rico" PIXEL SIZE 290,188

		@ 003,004 TO 072,285 LABEL " Manipulacoes do chamado "		PIXEL OF oFld:aDialogs[1]
		@ 074,004 TO 171,285 LABEL " Detalhamento "					PIXEL OF oFld:aDialogs[1]
	  	@ 082,008 GET oView VAR cView MEMO SIZE 275,85 FONT oFontPad READONLY PIXEL OF oFld:aDialogs[1]
	  	oView:oFont:= oFontPad

		@ 011,009 LISTBOX oLbx2 VAR cVar FIELDS HEADER "Data","Hora","Tipo","Descricao","Origem" SIZE 271,057 OF oFld:aDialogs[1] PIXEL ;
		ON CHANGE u_UpdateMemo(oLbx2:nAt)

		oLbx2:SetArray( aHistorico )
		oLbx2:LHScroll := .F.
		oLbx2:bLine := {|| {   aHistorico[oLbx2:nAt,1],;
                               	aHistorico[oLbx2:nAt,2],;
                		       	aHistorico[oLbx2:nAt,3],;
		                       	aHistorico[oLbx2:nAt,4],;
		                       	aHistorico[oLbx2:nAt,5]}}

	ACTIVATE MSDIALOG oDlg2 On Init EnchoiceBar(oDlg2,bOk,bCancel,,) Centered

	RestArea(aArea)

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออปฑฑ
ฑฑบFuno    ณ MsDelItem() บ Autor ณ TOTVS SA           บ Data ณ27/10/2011บฑฑ
ฑฑฬออออออออออุอออออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออนฑฑ
ฑฑบDescricao ณExclui uma linha do aCols                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function MsDelItem(aHistorico)

	Local aArea	:= GetArea()
	Local aNew 	:= {}
	Local nLin	:= oLbx:nAT

	IF oFld:nOPTION == 1
		Return
	Endif

	IF UPPER(aHistorico[nLin,5]) <> UPPER(ALLTRIM( u_RetTecName(RetCodUsr()) ))
		MsgInfo("Voc๋ nใo tem permissใo para excluir este registro do chamado.",,"INFO")
		Return
	Endif

	IF aHistorico[nLin,3] == "001"
		MsgInfo("Nใo ้ permitido excluir o registro de abertura do chamado. Exclua o chamado caso necessแrio.",,"INFO")
		Return
	Endif

	If nLin <> 0

		IF MsgNoYes("Confirma a exclusใo deste registro ?",,"NOYES")
			DbSelectArea("SZV")
			DbGoTo(aHistorico[nLin,7])
			RecLock("SZV",.F.)
				DbDelete()
			MsUnLock("SZV")
		Else
			Return
		Endif

		For g := 1 To Len(aHistorico)
			IF g <> nLin
				aAdd(aNew,{ aHistorico[g,1],aHistorico[g,2],aHistorico[g,3],aHistorico[g,4],aHistorico[g,5],aHistorico[g,6],aHistorico[g,7] })
			Endif
		Next
		aHistorico := aClone(aNew)
		oLbx:SetArray(aHistorico)
		oLbx:bLine := {|| {   aHistorico[oLbx:nAt,1],;
                               aHistorico[oLbx:nAt,2],;
                		       aHistorico[oLbx:nAt,3],;
		                       aHistorico[oLbx:nAt,4],;
		                       aHistorico[oLbx:nAt,5]}}
		oLbx:Refresh()
		u_UpdateMemo(1)

	Else
		MsgInfo("Clique primeiro em cima da linha que deseja excluir e depois clique com o botใo direito para excluir.",,"INFO")
	Endif

	RestArea(aArea)

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออปฑฑ
ฑฑบFuno    ณ CNFTIMEOUT()บ Autor ณ TOTVS SA           บ Data ณ27/10/2011บฑฑ
ฑฑฬออออออออออุอออออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออนฑฑ
ฑฑบDescricao ณConfirma o chamado caso o usuario nao confirme o chamado no บฑฑ
ฑฑบ          ณprazo estipulado.                                           บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function CNFTIMEOUT( cChamado,oEncerra )

//	CHKFile("SZU")
//	CHKFile("SZV")

	cChamado 	:= oEncerra:oHtml:RetByName('cChamado')
	cMotivo		:= "Chamado encerrado em "+dToc(Date())+" devido falta de retorno do usuario"

	DbSelectArea("SZU")
	DbSetOrder(1)
	IF DbSeek( xFilial("SZU") + cChamado )

		RecLock("SZU",.F.)
			SZU->ZU_DTCONF	:= Date()
			SZU->ZU_HRCONF	:= Time()
			SZU->ZU_STATUS	:= "C"
		MsUnLock()

		u_RegItem(cChamado,'023'/*GetMv("ES_CODENCE")*/,cMotivo,"000000")

	Endif

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออปฑฑ
ฑฑบFuno    ณ RegItem()   บ Autor ณ TOTVS SA           บ Data ณ27/10/2011บฑฑ
ฑฑฬออออออออออุอออออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออนฑฑ
ฑฑบDescricao ณGera o registro na SZV contendo todos os detalhes do comple-บฑฑ
ฑฑบ          ณmento do chamado                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function RegItem(cChamado,cTipo,cMotivo,cTecnico)

	Local kk	:= GetArea()

	DbSelectArea("SZV")
	RecLock( "SZV" , .T. )
		SZV->ZV_FILIAL	:= xFilial("SZV")
		SZV->ZV_CHAMADO	:= cChamado
		SZV->ZV_DATA	:= Date()
		SZV->ZV_TIPO	:= cTipo
		SZV->ZV_CODSYP	:= u_GrvMemo( cMotivo , "ZV_CODSYP" )
		SZV->ZV_NUMSEQ	:= u_RetZVNum( cChamado )
		SZV->ZV_HORA	:= Time()
		SZV->ZV_TECNICO	:= cTecnico
	MsUnLock()

	RestArea(kk)

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออปฑฑ
ฑฑบFuno    ณ RegItem()   บ Autor ณ TOTVS SA           บ Data ณ27/10/2011บฑฑ
ฑฑฬออออออออออุอออออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออนฑฑ
ฑฑบDescricao ณValidacao do campo cCodAcao ( Tipo de analise )             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function LJAtuAcao(cAcao)

	Local aa	:= GetArea()

	DbSelectArea("SZG")
	DbSetOrder(1)
	IF DbSeek( xFilial("SZG") + cCodAcao )

		IF SZG->ZG_ENCERRA == "S" .And. !MsgNoYes("Confirma o encerramento deste chamado ?","Encerramento")
			RestArea(aa)
			Return(.F.)
		Endif

		IF SZG->ZG_TRANSF == "S"
			IF !EMPTY(SZG->ZG_AREA)
				If !MsgNoYes("Confirma a transfer๊ncia deste chamado para a แrea " + Capital(Tabela("ZZ",SZG->ZG_AREA)) ,"Encerramento")
					RestArea(aa)
					Return(.F.)
				Endif
			Else
				MsgStop("Este c๓digo nใo pode ser utilizado pois faltam informa็๕es da แrea de destino em seu cadastro.")
				RestArea(aa)
				Return(.F.)
			Endif
		Endif

		cAcao	:= SZG->ZG_DESCRI
		oAcao:Refresh()
		oTexto:SetFocus()

	Else

		MsgStop("C๓digo invแlido, no caso de d๚vidas pressione F3 para obter a rela็ใo de c๓digos.",,"INFO")
		oCodAcao:SetFocus()

	Endif

	RestArea(aa)

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออปฑฑ
ฑฑบPrograma  ณ OpenProc()  บ Autor ณ Fernando Nogueira  บ Data ณ23/10/2013บฑฑ
ฑฑฬออออออออออุอออออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออนฑฑ
ฑฑบDescrio ณ Valida usuario e senha de acordo com arquivo sigapss.spf	  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico AVANT.                   	                    บฑฑ
ฑฑฬออออออออออฯอออัออออออออัอออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAnalista Resp.ณ  Data  ณ Manutencao Efetuada                           บฑฑ
ฑฑฬออออออออออออออุออออออออุอออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ              ณ  /  /  ณ                                               บฑฑ
ฑฑบ              ณ  /  /  ณ                                               บฑฑ
ฑฑศออออออออออออออฯออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function OpenProc(cChamado,cOp,nAcao,cArqTrb)

	Local oProcess
	Local oHTML
	Local cEquipe	  := Tabela("ZZ",SZU->ZU_DIVISAO)
	Local cTecncoAtual:= SZU->ZU_TECNICO
	Local aGrupo      := {}
	Local cMailList   := ''
	Local cDescriAtual:= ''
	Local cTecTemp    := cTecnico

	DbSelectArea('SZU')
	DbSetOrder(1)
	DbSeek(xFilial('SZU')+cChamado)

	cEquipe		:= Tabela("ZZ",SZU->ZU_DIVISAO)
	cTecncoAtual	:= SZU->ZU_TECNICO

	// A - Abertura de chamados
	// C - Complemento de chamados
	// T - Alocacao de analista para o chamado
	// E ou W - Chamado Encerrado (W - envia com pesquisa de satisfacao

	cMsg_2 := ""

	If cOp == "A"
		cMsg_1 := 'Seu chamado foi registrado no sistema de atendimento. O c๓digo de controle para acompanhamento ้ <strong>'+cChamado+'</strong>'
//		cMsg_2 := 'Para acompanhar a evolu็ใo do atendimento, acesse seu chamado atrav้s do portal: <a href="http://suporte.marcomar.com.br:84/index.htm" target="_blank">http://suporte.marcomar.com.br:84/index.htm</a>'
	Elseif cOp == "C"
		cMsg_1 := 'O Sistema recebeu retorno referente ao chamado <strong>'+cChamado+'</strong>.'
//		cMsg_2 := 'Para acompanhar a evolu็ใo do atendimento, acesse seu chamado atrav้s do portal: <a href="http://suporte.marcomar.com.br:84/index.htm" target="_blank">http://suporte.marcomar.com.br:84/index.htm</a>'
	Elseif cOp == "T"
		cMsg_1 := 'O Lํder de equipe designou sob sua responsabilidade o chamado <strong>'+cChamado+'</strong>.'
		cMsg_2 := 'Voc๊ deve realizar o atendimento imediato deste chamado.'
	Elseif cOp == "E" .or. cOp == "W"
		cMsg_1 := 'O chamado <strong>'+cChamado+'</strong> foi solucionado'
//		cMsg_2 := 'Por favor, analise a solu็ใo sugerida e registre seu parecer no portal: <a href="http://suporte.marcomar.com.br:84/index.htm">http://suporte.marcomar.com.br:84/index.htm</a><br>'+;
//                   '<br>'+;
//				   'Se nใo houver intera็ใo no chamado, em <strong>5</strong> dias ele serแ encerrado automaticamente.'
	Elseif cOp == "P"
		cMsg_1 := ''
		cMsg_2 := ''
	Endif

	// 1-Abertura de chamados
	// 2-Envio de ficha atualizada

	If nAcao == 1
		cSubject := "ABERTURA: Chamado No "
	Else
		If cOp == "T"
			cSubject := "PENDENTE: Chamado No "
		Elseif cOp == "E" .Or. cOp == "W"
			cSubject := "ENCERRADO: Chamado No "
		Else
			cSubject := "ATUALIZADO: Chamado No "
		Endif
	Endif

	SZB->( DbSetOrder(1) )
	SZB->( DbSeek( xFilial("SZB") + SZU->ZU_ROTINA ) )
	PswOrder(1)
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Cria o Objeto do processo a ser enviado ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	PswSeek(SZU->ZU_CODUSR, .T. )

	If cOp == "P"
		oHTML := TWFHTML():New("\MODELOS\consulta.htm")
	Else
		oProcess := TWFProcess():New("000002","CHAMADO "  + cChamado )
		oProcess:NewTask("001","\MODELOS\FICHACHAMADO.HTM")
		oProcess:cSubject := cSubject + cChamado
		oHTML := oProcess:oHTML

		oHtml:ValByName("cInf_1"		,cMsg_1)
		oHtml:ValByName("cInf_2"		,cMsg_2)
	Endif

	oHtml:ValByName("cChamado"		,SZU->ZU_CHAMADO)

	oHtml:ValByName("cCodUser"		,SZU->ZU_CODUSR)
	oHtml:ValByName("cDepartamento"	,PswRet()[1][12])
	oHtml:ValByName("cSuperv"	    ,SZU->ZU_NOMESUP)
	oHtml:ValByName("cContato"		,SZU->ZU_NOMEUSR)
	oHtml:ValByName("cContatoEmail"	,SZU->ZU_MAILUSR)
	oHtml:ValByName("cTelRetorno"	,SZU->ZU_TELUSR)
	oHtml:ValByName("cEmail"	    ,alltrim(SZU->ZU_MAILUSR)+ENTER+alltrim(SZU->ZU_MAILSUP)+ENTER+StrTran(alltrim(SZU->ZU_EMAILS),";",ENTER))

/*	If cOp == "W"
		cLink := '<Left>'
		cLink +=		'<a href="http://suporte.marcomar.com.br:84/u_ofanswers.apw?psrp='+SZU->ZU_CODUSR+'&code='+SZU->ZU_CHAMADO+'&area='+SZU->ZU_ROTINA+'">'
		cLink +=		'<img src="http://suporte.marcomar.com.br:84/images/smiles_small.png" border="0" title="Responder pesquisa de satisfa็ใo">Pesquisa de Satisfa&ccedil;&atilde;o.</img>'
		cLink +=		'</a>'
		cLink +=	'</Left>'
		oHtml:ValByName("chref",cLink)
	Else*/
		oHtml:ValByName("chref",'&nbsp;')
//	EndIf

	oHtml:ValByName("cStatus"		,Tabela("Z1",SZU->ZU_STATUS))
	oHtml:ValByName("cDTEncerra"	,DTOC(SZU->ZU_DTFECHA))
	oHtml:ValByName("cEquipe"		,Tabela("ZZ",SZU->ZU_DIVISAO))
	oHtml:ValByName("cIncidente"	,Alltrim(SZB->ZB_DESC))

	nLi := 1
	DbSelectArea("SZV")
	DbSetOrder(1)
	If DbSeek( xFilial("SZV") + SZU->ZU_CHAMADO)
		While !SZV->(Eof()) .And. SZV->ZV_FILIAL+SZV->ZV_CHAMADO == xFilial("SZV")+SZU->ZU_CHAMADO

			SZG->( DbSetOrder(1) )
			SZG->( DbSeek( xFilial("SZG") + SZV->ZV_TIPO ) )
			If alltrim(SZV->ZV_TECNICO)	== "AUTO"
				cEquipe := 'ADM_PORTAL'
				cTecnico:= 'AUTO-Administrador'
			Else
				PswSeek(SZV->ZV_TECNICO, .T. )
				aGrupo  := PswRet()[1]
				DbSelectArea('SZC')
				DbSeek(xFilial('SZC')+SZV->ZV_TECNICO) //Posiciona no cadastro de Tecnico
				DbSelectArea('SZD')
				DbSeek(xFilial('SZC')+SZC->ZC_GRUPO) //Posiciona no cadastro de Grupo de Atendimento
				cEquipe := Alltrim(SZD->ZD_DESC)
				cTecnico:= SZV->ZV_TECNICO+'-'+alltrim(aGrupo[4])//Upper(Substr(aGrupo[4],1,At(" ",aGrupo[4])))+Substr(aGrupo[4],At(" ",aGrupo[4])+1,Len(aGrupo[4]))
			EndIf

			aAdd((oHTML:ValByName("a.cLi"))			,StrZero(nLi,3))
			aAdd((oHTML:ValByName("a.cEquipe"))   	,cEquipe)
			aAdd((oHTML:ValByName("a.cTipoOcorr"))	,Alltrim(SZG->ZG_DESCRI) )
			aAdd((oHTML:ValByName("a.cMemo"))		,Alltrim( u_GETTexto(SZV->ZV_CODSYP,.T.) ))
			aAdd((oHTML:ValByName("a.cTecnico"))	,cTecnico)
			aAdd((oHTML:ValByName("a.cDTOcor"))		,DTOC(SZV->ZV_DATA) + ENTER + SZV->ZV_HORA )
			cTecncoAtual := SZV->ZV_TECNICO
			cDescriAtual := Alltrim(SZG->ZG_DESCRI)
			nLi ++
			DbSelectArea("SZV")
			DbSkip()

		End
	Endif

	IF cOp != "P"
		oHtml:ValByName("cDescriAtual",cDescriAtual)
	EndIf

	If cTecncoAtual <> "AUTO"
		cMailList := If(lower(alltrim(u_usr_campos(SZU->ZU_TECNICO)[3])) $ lower(alltrim(GetMv("ES_CRMMAIL"))) .or. Empty(u_usr_campos(SZU->ZU_TECNICO)[3]),'',lower(alltrim(u_usr_campos(SZU->ZU_TECNICO)[3])))
	EndIf

	If cOp == "T"
		cMailList := cMailList
	Else
		If cOp == "W" //Envia somente para o dono do chamado
			cMailList := If(lower(alltrim(SZU->ZU_MAILUSR)) $ lower(alltrim(GetMv("ES_CRMMAIL"))) .or. Empty(SZU->ZU_MAILUSR) .or. cOp == "E",'','; '+lower(alltrim(SZU->ZU_MAILUSR)))
		Else
			cMailList := cMailList+If(lower(alltrim(SZU->ZU_MAILUSR)) $ lower(alltrim(GetMv("ES_CRMMAIL"))) .or. Empty(SZU->ZU_MAILUSR) .or. cOp == "E",'','; '+lower(alltrim(SZU->ZU_MAILUSR)))+If(lower(alltrim(SZU->ZU_MAILSUP)) $ lower(alltrim(GetMv("ES_CRMMAIL"))) .or. Empty(SZU->ZU_MAILSUP),'','; '+lower(alltrim(SZU->ZU_MAILSUP)))+If(lower(alltrim(SZU->ZU_EMAILS)) $ lower(alltrim(GetMv("ES_CRMMAIL"))) .or. Empty(SZU->ZU_EMAILS),'','; '+lower(alltrim(SZU->ZU_EMAILS)))
		EndIf
	Endif

	IF cOp != "P"
		oProcess:USerSiga	:= "000000"
		oProcess:cTo		:= cMailList
		oProcess:cCC		:= If(cOp == "W",'',alltrim(lower(GetMv("ES_CRMMAIL"))))+If(lower(alltrim(u_usr_campos(SZU->ZU_TECNICO)[3]))$cMailList,'','; '+lower(alltrim(u_usr_campos(SZU->ZU_TECNICO)[3])))
		oProcess:cBCC		:= If(cOp == "W",'FERNANDO.NOGUEIRA@AVANTLUX.COM.BR','')
		oProcess:Start()
		oProcess:Finish()
		If cOp == "E"
			cOp := "W"
			u_OpenProc(SZU->ZU_CHAMADO,"W",2)
		Endif
	Else
		aBrowse	:= { "c:\Program Files\Internet Explorer\IEXPLORE.EXE " , "C:\Arquivos de programas\Internet Explorer\iexplore.exe " }
		For p := 1 To Len(aBrowse)
			If File( RTrim(aBrowse[p]) )
				cFileBrowse := aBrowse[p]
				p := Len(aBrowse)
			Endif
		Next
		cServidor := GetNewPar("ES_MP8SRV","E:\Protheus_data")
		cArqTrb   := cServidor + "\spool\" + ALLTRIM(CriaTrab(Nil,.F.)) + ".htm"
		oHTML:SaveFile( cArqTrb )
		cExec	:= cFileBrowse + cArqTrb
		WinExec( cExec )

	Endif

	cTecnico := cTecTemp

Return()
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออปฑฑ
ฑฑบFuno    ณ TECREENV()  บ Autor ณ TOTVS SA           บ Data ณ27/10/2011บฑฑ
ฑฑฬออออออออออุอออออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออนฑฑ
ฑฑบDescricao ณEnvia ficha atualizada do chamado para todos envolvidos     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function TECREENV()

	IF MsgYesNo("Deseja enviar c๓pia atualizada do chamado para todos os envolvidos ?","Pergunta","YESNO")
		u_OpenProc(SZU->ZU_CHAMADO,"C",2)
	Endif

Return()
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออปฑฑ
ฑฑบFuno    ณ VldMail()   บ Autor ณ Fernando Nogueira  บ Data ณ23/10/2013บฑฑ
ฑฑฬออออออออออุอออออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออนฑฑ
ฑฑบDescricao ณ Verifica se existe algum caracter especial no e-mail       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function VldMail()

	Local _lVai := .T.

	If (READVAR() == 'M->ZU_EMAILS' .And. FUNNAME() == 'USRMENU' .And. !Empty(&(READVAR()))) .or. (READVAR() <> 'M->ZU_EMAILS' .And. !Empty(&(READVAR())))
		If At('@',&(READVAR()))==0 .or. At('.',&(READVAR()))==0 .or. At('"',&(READVAR()))<>0 .or. At('!',&(READVAR()))<>0 .or. At('#',&(READVAR()))<>0 .or. At('$',&(READVAR()))<>0 .or. At('%',&(READVAR()))<>0 .or. At('&',&(READVAR()))<>0 .or. At('(',&(READVAR()))<>0 .or. At(')',&(READVAR()))<>0 .or. At('/',&(READVAR()))<>0 .or. At('*',&(READVAR()))<>0 .or. At('+',&(READVAR()))<>0 .or. At('|',&(READVAR()))<>0 .or. At('<',&(READVAR()))<>0 .or. At('>',&(READVAR()))<>0 .or. At(':',&(READVAR()))<>0 .or. At('?',&(READVAR()))<>0 .or. At(',',&(READVAR()))<>0 .or. At('}',&(READVAR()))<>0 .or. At(']',&(READVAR()))<>0 .or. At('{',&(READVAR()))<>0 .or. At('[',&(READVAR()))<>0 .or. At('~',&(READVAR()))<>0 .or. At('^',&(READVAR()))<>0 .or. At('ด',&(READVAR()))<>0 .or. At('`',&(READVAR()))<>0
			_lVai := .F.
		    Msginfo("Este endere็o de e-mail nใo ้ vแlido!")
		Elseif At('@AVANTLED.COM.BR',Upper(&(READVAR())))==0
			_lVai := .F.
			Msginfo("Aceito somente e-mails terminado em '@AVANTLED.COM.BR'")
		EndIf
	EndIf

Return(_lVai)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออปฑฑ
ฑฑบFuno    ณAcerta_SYP() บ Autor ณ Fernando Nogueira  บ Data ณ19/11/2013บฑฑ
ฑฑฬออออออออออุอออออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออนฑฑ
ฑฑบDescricao ณ Verifica se existe algum caracter especial no e-mail       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function Acerta_SYP()
/*
	// Acerta deletados
	_cQuery := "UPDATE "+RetSqlName("SYP")
	_cQuery += "   SET D_E_L_E_T_ = ' ' "
	_cQuery += "WHERE "
	_cQuery += "   YP_CHAVE >= '020758' AND D_E_L_E_T_ = '*' "

	TcSqlExec(_cQuery)
*/
Return
