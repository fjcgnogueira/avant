#INCLUDE "PROTHEUS.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MTA265MNU º Autor ³ Fernando Nogueira  º Data ³ 09/06/2017 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de Entrada para adicionar funcao no menu do          º±±
±±º          ³ enderecamento                                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Avant                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MTA265MNU()

aAdd(aRotina, {'Enderec.Doc', 'U_xEndDoc', 0, 2, 0, NIL})

Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ xEndDoc   ³ Autor ³ Fernando Nogueira  ³ Data  ³ 09/06/2017 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Dispara Processo do Enderecamento por Documento             ³±±
±±³          ³ Chamado 005018                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function xEndDoc()

Local lEnd   := .F.
Local nRegua := 0

Private cPerg := PadR("ENDDOC",Len(SX1->X1_GRUPO))

AjustaSX1(cPerg)

If Pergunte(cPerg,.T.)

	If MsgNoYes("Confirma endereçamento por Documento?")
		_oProcess := MsNewProcess():New({|lEnd| U_EndDoc(lEnd,@nRegua)},"Processando...","Enderecando...",.T.)
		_oProcess:Activate()
		If nRegua > 0
			ApMsgInfo("Processo Finalizado.")
		Else
			ApMsgInfo("Nenhum endereçamento a fazer")
		Endif
	Endif
	
Endif

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ EndDoc    ³ Autor ³ Fernando Nogueira  ³ Data  ³ 09/06/2017 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Enderecamento por Documento                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function EndDoc(lEnd,nRegua)

Local aCab   := {}
Local aItens := {}
Local cErro  := ""
Local cItem  := ""

Private lMsErroAuto  := .F.
Private lMsHelpAuto  := .T.

If	!Empty(Select("TRB"))
	TRB->(dbCloseArea())
EndIf

BeginSql alias 'TRB'
	SELECT DA_DOC,DA_SERIE,DA_CLIFOR,DA_LOJA,DA_PRODUTO,DA_LOCAL,DA_LOTECTL,DA_NUMLOTE,DA_NUMSEQ,DA_SALDO FROM %table:SDA% SDA
	WHERE SDA.%notDel%
		AND DA_FILIAL = %xFilial:SDA%
		AND DA_SALDO > 0
		AND DA_LOCAL = %Exp:MV_PAR03%
		AND DA_DOC BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
	ORDER BY DA_DOC,DA_SERIE,DA_CLIFOR,DA_LOJA,DA_NUMSEQ
EndSql
	
TRB->(dbGoTop())

If TRB->(!Eof())

	While TRB->(!Eof())
		nRegua++
		TRB->(dbSkip())
	End
	
	_oProcess:SetRegua1(nRegua)
	_oProcess:SetRegua2(nRegua)
	
	TRB->(dbGoTop())

	dbSelectArea("SDA")
	dbSetOrder(01)
	dbSelectArea("SDB")
	dbSetOrder(01)	
	
	Begin Transaction
	
		While TRB->(!Eof())
		
			_oProcess:IncRegua1("Enderecando Doc "+TRB->DA_DOC+", Produto "+TRB->DA_PRODUTO)
			
			cItem := "0001"
			
			If SDB->(dbSeek(xFilial("SDB")+TRB->(DA_PRODUTO+DA_LOCAL+DA_NUMSEQ+DA_DOC+DA_SERIE+DA_CLIFOR+DA_LOJA)))
				While SDB->(!EoF()) .And. SDB->(DB_FILIAL+DB_PRODUTO+DB_LOCAL+DB_NUMSEQ+DB_DOC+DB_SERIE+DB_CLIFOR+DB_LOJA) = xFilial("SDB")+TRB->(DA_PRODUTO+DA_LOCAL+DA_NUMSEQ+DA_DOC+DA_SERIE+DA_CLIFOR+DA_LOJA)
					SDB->(dbSkip())
				End
				SDB->(dbSkip(-1))
				cItem := StrZero(Val(SDB->DB_ITEM)+1,04)
			Endif
			
			aCab  := {{"DA_PRODUTO",TRB->DA_PRODUTO, nil},;
					  {"DA_LOCAL"  ,TRB->DA_LOCAL  , nil},;
					  {"DA_NUMSEQ" ,TRB->DA_NUMSEQ , nil},;
					  {"DA_DOC"    ,TRB->DA_DOC    , nil},;
					  {"DA_SERIE"  ,TRB->DA_SERIE  , nil},;
					  {"DA_CLIFOR" ,TRB->DA_CLIFOR , nil},;
					  {"DA_LOJA"   ,TRB->DA_LOJA   , nil}}
	
			aItens := {{{"DB_ITEM"   ,cItem          ,nil},;
					    {"DB_LOCALIZ",MV_PAR04       ,nil},;
					    {"DB_QUANT"  ,TRB->DA_SALDO  ,nil},;
					    {"DB_DATA"   ,dDataBase      ,nil},;
					    {"DB_LOTECTL",TRB->DA_LOTECTL,nil},;
					    {"DB_NUMLOTE",TRB->DA_NUMLOTE,nil}}}
		
			lMSHelpAuto := .T.
			lMSErroAuto := .F.
			
			// Trava caso o registro esteja bloqueado por outro usuario
			SDA->(dbSeek(xFilial("SDA")+TRB->(DA_PRODUTO+DA_LOCAL+DA_NUMSEQ+DA_DOC+DA_SERIE+DA_CLIFOR+DA_LOJA)))
			SDA->(RecLock("SDA",.F.))
			SDA->(MsUnlock())
			
			msExecAuto({|x,y,z|mata265(x,y,z)},aCab,aItens,03)// distribuicao
			
			lMSHelpAuto := .F.
			
			If	lMSErroAuto
				DisarmTransaction()
				cErro := MostraErro()
				Break
			EndIf
		
			TRB->(dbSkip())
			
			_oProcess:IncRegua2()
							
		End
		
	End Transaction

Endif

TRB->(dbCloseArea())

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AjustaSX1 º Autor ³ Fernando Nogueira  º Data ³ 09/06/2017  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Cria as perguntas do programa no dicionario de perguntas    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function AjustaSX1(cPerg)

	Local aAreaAnt := GetArea()
	Local aRegs    := {}
	Local aHelpPor := {}
	Local aHelpEng := {}
	Local aHelpSpa := {}

	aHelpPor := {"Doc Inicial a enderecar"}
	PutSX1(cPerg,"01","Do Documento ?"   ,"","","mv_ch1","C",09,0,0,"G","","SF1","","","mv_par01","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)
	aHelpPor := {"Doc Final a enderecar"}
	PutSX1(cPerg,"02","Ate o Documento ?","","","mv_ch2","C",09,0,0,"G","","SF1","","","mv_par02","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)
	aHelpPor := {"Armazem dos Documentos que serao enderecados"}
	PutSX1(cPerg,"03","Armazem ?"        ,"","","mv_ch3","C",02,0,0,"G","","NNR","","","mv_par03","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)
	aHelpPor := {"Endereco onde sera enderecado"}
	PutSX1(cPerg,"04","Endereco ?"       ,"","","mv_ch4","C",15,0,0,"G","","SBE","","","mv_par04","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)
		
	RestArea(aAreaAnt)

Return Nil