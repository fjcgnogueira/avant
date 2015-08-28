#INCLUDE "PROTHEUS.CH"           
#INCLUDE "TOPCONN.CH"  
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ FA740BRW บ Autor ณ Fernando Nogueira  บ Data ณ 25/08/2015  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Ponto de Entrada para Adicionar Itens no Funcoes Contas a  บฑฑ
ฑฑบ          ณ Receber                                                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico Avant                                           บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function FA740BRW()

Local aBotao := {}

aAdd(aBotao, {'Exp.Bordero',"U_ExpBordero", 0, 3})

Return(aBotao)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณExpBorderoบ Autor ณ Fernando Nogueira  บ Data ณ 25/08/2015  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Exportar os Titulos dos Borderos em XML                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function ExpBordero()

Local aPerg     := {}
Local lEnd      := .F.
Local _oProcess

Private cPara := ""

dbSelectArea("SEA")
dbSetOrder(1)
dbGoTop()

Aadd(aPerg,{1,"Num.Bordero",Space(06),"","ExistCpo('SEA').And.NaoVazio()","SEA","",20,.T.})
Aadd(aPerg,{6,"Arq.Remessa",Space(50),"@!","","",95,.T.,"","",GETF_LOCALHARD+GETF_LOCALFLOPPY+GETF_NETWORKDRIVE})

If ParamBox(aPerg,"Exp.Bordero",,,,.T.,,,,"EXPBOR",.T.,.T.)

	If SEA->(dbSeek(xFilial("SEA")+MV_PAR01))
		cPara := AllTrim(Posicione("SA6",1,xFilial("SA6")+SEA->EA_PORTADO+SEA->EA_AGEDEP+SEA->EA_NUMCON,"A6_EMAIL"))
	Else
		Alert("Border๔ Invแlido!")
		Return
	Endif	

	If !File(AllTrim(MV_PAR02))
		Alert("Arquivo de Remessa nใo Existe!")
	ElseIf Empty(cPara) .Or. At("@",cPara) == 0
		aArrSay := {"Email invแlido ou nใo cadastrado.","Acertar o cadastro de e-mail no banco:","Banco: "+SEA->EA_PORTADO,"Ag: "+SEA->EA_AGEDEP,"CC: "+SEA->EA_NUMCON}
		aArrBut := {{1, .T., {|| lExeFun := .T., FechaBatch()}}}
		FormBatch('Alerta Email',aArrSay,aArrBut)
	Else
		_oProcess := MsNewProcess():New({|lEnd| ProcBorde(lEnd,_oProcess)},"Processando...","Gerando XMLs...",.T.)
		_oProcess:Activate()
	Endif
	
Endif

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณProcBorde บAutor  ณ Fernando Nogueira  บ Data ณ 26/08/2015  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณProcessa a geracao dos XMLs do Bordero                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ProcBorde(lEnd,_oProcess)

Local cPathLog	:= "\LOGS\EXPXML.LOG"
Local aFiles    := {}
Local aXMLs     := {}
Local cNumTit   := ""
Local dDataEmis
Local oMemo
Local oDlg
Local oFont
Local cMensagem := ""
Local aMensagem := {}
Local aArrBut   := {}
Local cTemp     := ""

Private nRegua1  := 0
Private nRegua2  := 4
Private nTempArq := 2
Private cBordero := MV_PAR01
Private cLocDir  := "\workflow\xmlnfe\" + cBordero + "\"
Private cCompact := "\workflow\xmlnfe\" + cBordero + ".rar" 
Private cLocRar  := "E:\Protheus_data\workflow\xmlnfe\" + cBordero
Private cArqRar  := "E:\Protheus_data\workflow\WinRAR\Rar.exe a E:\Protheus_data\workflow\xmlnfe\" + cBordero + ".rar"
Private lEnviou  := .F.

aAdd(aArrBut, {1, .T., {|| lExeFun := .T., FechaBatch()}})
aAdd(aArrBut, {2, .T., {|| lExeFun := .F., FechaBatch()}})

// Definicao do nRegua1 para barra de processamento 
SEA->(dbSeek(xFilial("SEA")+cBordero))
While SEA->EA_FILIAL+SEA->EA_NUMBOR == xFilial("SEA")+cBordero
	nRegua1++
	SEA->(dbSkip())
End

SEA->(dbGoTop())
SEA->(dbSeek(xFilial("SEA")+cBordero))

If SEA->EA_STMAIL == "G"   //Gerado XML
	ApMsgInfo("XMLs desse Border๔ jแ foram gerados")
ElseIf nRegua1 == 0
	ApMsgInfo("Nใo tem XML a ser Gerado")	
Else
	MontaDir(cLocDir)
	nRegua1 += nTempArq
	_oProcess:SetRegua1(nRegua1)
	_oProcess:SetRegua2(nRegua2)
	
	_oProcess:IncRegua1()

	While SEA->EA_FILIAL+SEA->EA_NUMBOR == xFilial("SEA")+cBordero
		
		_oProcess:IncRegua1()
	
		dDataEmis := Posicione("SF2",1,xFilial("SF2")+SEA->EA_NUM+SEA->EA_PREFIXO,"F2_EMISSAO")
		
		cTemp := ExpXmlNfs(dDataEmis,SEA->EA_PREFIXO,SEA->EA_NUM,SF2->F2_CLIENTE,SF2->F2_LOJA,cLocDir) + Chr(13)+Chr(10)
		cMensagem += cTemp
		aAdd(aMensagem, cTemp)
		
		cNumTit := SEA->EA_NUM
		
		SEA->(RecLock("SEA",.F.))
		SEA->EA_STMAIL := "G"
		SEA->(MsUnlock())
		
		SEA->(dbSkip())
		
		While SEA->EA_NUM == cNumTit
			_oProcess:IncRegua1()
			SEA->(RecLock("SEA",.F.))
			SEA->EA_STMAIL := "G"
			SEA->(MsUnlock())
			SEA->(dbSkip())
		End		
	End
	
	MemoWrite(cPathLog,cMensagem)
	
	CpyT2S(AllTrim(MV_PAR02), cLocDir, .F.)
	
	// Gera arquivo compactado em Rar
	WaitRunSrv(cArqRar,.T.,cLocRar)
	
	aFiles := Directory(cLocDir + "*.*")
	
	// Remove arquivos e diretorio, deixando apenas o compactado
	For nX := 1 to Len(aFiles)
    	FErase(cLocDir + aFiles[nX,1])
	Next nX
	DirRemove(cLocDir)
	
	// Janela com log de geracao dos XMLs e confirmacao de envio
	DEFINE MSDIALOG oDlg TITLE "Log Gera็ใo dos XMLs" From 3,0 to 340,417 PIXEL
	@ 5,5 GET oMemo VAR cMensagem MEMO SIZE 200,145 OF oDlg PIXEL READONLY
	oMemo:bRClicked := {||AllwaysTrue()}
	oMemo:oFont:=oFont
	DEFINE SBUTTON  FROM 153,145 TYPE 1 ACTION (EnviaXML(lEnd,_oProcess),oDlg:End()) ENABLE OF oDlg PIXEL
	DEFINE SBUTTON  FROM 153,175 TYPE 2 ACTION oDlg:End() ENABLE OF oDlg PIXEL
	ACTIVATE MSDIALOG oDlg CENTER
Endif

If File(cCompact)
	If lEnviou
		For _nX := 1 to nRegua2
			Sleep(1000)
			_oProcess:IncRegua2("Enviando E-mail...")
		Next
	Endif
Endif

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณExpXmlNfs บ Autor ณ Fernando Nogueira  บ Data ณ 25/08/2015  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Exporta XML de Nota Fiscal de Saida                        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico Avant                                           บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ExpXmlNfs(dDataEmis,cSerie,cNumero,cCodCli,cLojCli,cLocDir)

Local cMensagem := ""

Private cAviso      := ""
Private cErro       := ""     
Private cModalidade := ""
Private cChave      := ""
Private cAnexo      := ""
Private cXmlDados   := ""
Private nHdlXml     := 0
Private aNotas      := {}
Private aXml        := {}
Private oNFe
          
aadd(aNotas,{})
aadd(Atail(aNotas),.F.)
aadd(Atail(aNotas),"S")
aadd(Atail(aNotas),dDataEmis)
aadd(Atail(aNotas),cSerie)
aadd(Atail(aNotas),cNumero)
aadd(Atail(aNotas),cCodCli)
aadd(Atail(aNotas),cLojCli)

aXml := StaticCall(DanfeII,GetXml,StaticCall(SPEDNFE,GetIdEnt),aNotas,@cModalidade)

If Len(aXML) <= 0
     Return
Endif

cXmlDados := NfeProcNfe(aXML[1][2],aXML[1][6],NfeIdSPED(aXML[1][2],"versao"))
oNFe      := XmlParser(cXmlDados,"_",@cErro,@cAviso)

If Empty(cErro) .And. Empty(cAviso)
	cMensagem := "Gerado XML da Nota: " + cNumero
	cChave    := SubStr(NfeIdSPED(aXML[1][2],"Id"),4)
	cAnexo    := cLocDir+cChave+"-nfe.xml"
Else
	cMensagem := "Erro na Gera็ใo do XML da Nota: " + cNumero
EndIf

nHdlXml := FCreate(cAnexo,0)
If nHdlXml > 0
     FWrite(nHdlXml,cXmlDados)
     FClose(nHdlXml)
Endif                              

Return(cMensagem)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ EnviaXML บAutor  ณ Fernando Nogueira  บ Data ณ 26/08/2015  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Envia os XMLs gerados                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function EnviaXML(lEnd,_oProcess)

Local cArquivo  := "\MODELOS\NFEXML.HTM"
Local aArqRem   := {}
Local cArqRem   := ""
Local cSaudacao := ""

If Time() > "18:00:00"
	cSaudacao := "Boa Noite"
ElseIf Time() > "12:00:00"
	cSaudacao := "Boa Tarde"
Else
	cSaudacao := "Bom Dia"
Endif

aArqRem := StrTokArr(AllTrim(MV_PAR02), "\")
cArqRem := aArqRem[Len(aArqRem)]

oProcess := TWFProcess():New("NFEXML","XMLs CNAB")
oProcess:NewTask("Enviando XMLs",cArquivo)
oHTML := oProcess:oHTML
oHtml:ValByName("cSaudacao", cSaudacao)
oHtml:ValByName("cArqRem"  , cArqRem)
oProcess:cSubject := "[Financeiro Avant - "+DtoC(Date())+"] "+"XMLs CNAB - Arq. " + cArqRem + " - Bord. " +  cBordero
oProcess:USerSiga := "000000"
oProcess:cTo  := cPara
//oProcess:cCC  := "financeiro@avantled.com.br"
oProcess:cBCC := "fernando.nogueira@avantled.com.br"
If File(cCompact)
	oProcess:AttachFile(cCompact)
	oProcess:Start()
	oProcess:Finish()
	lEnviou := .T.
Else
	Alert("Erro ao Anexar o Arquivo!")
Endif

Return