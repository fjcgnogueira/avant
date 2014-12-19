#include "protheus.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ Fernando บAutor  ณFernando Nogueira   บ Data ณ 25/02/2014  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Programa para testes                                       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico Avant                                           บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
/*User Function Fernando()

dbSelectArea("SE1")

aBases := Fa440Comis(133777)

ConOut("Teste")

Return*/

/*
_cNota      := '000057108'
_cSerie     := '1  '
_cCliente   := '019676'
_cLoja      := '01'
_cItem      := '02'

dbSelectArea("SC5")
dbSetOrder(1)
dbSelectArea("SC6")
dbSetOrder(1)
dbSelectArea("SA3")
dbSetOrder(1)
dbSelectArea("SF2")
dbSetOrder(1)
dbSelectArea("SD2")
dbSetOrder(3)
dbSelectArea("SA1")
dbSetOrder(1)

ConOut("teste")

Return
*/
/*User Function Fernando()

Static oDlgFuncao
Static oSButConf
Static oSButEnd
Static oGetFuncao
Static cGetFuncao := PadL(AllTrim(GetMV("ES_FERNAND")),250)
Static oGroup1
Static oSayNome

  DEFINE MSDIALOG oDlgFuncao TITLE "Fun็ใo" FROM 000, 000  TO 170, 480 COLORS 0, 16777215 PIXEL

    @ 007, 005 GROUP oGroup1 TO 054, 232 OF oDlgFuncao COLOR 0, 16777215 PIXEL
    @ 016, 013 SAY oSayNome PROMPT "Digite o nome da fun็ใo:" SIZE 065, 009 OF oDlgFuncao COLORS 0, 16777215 PIXEL
    @ 030, 013 MSGET oGetFuncao VAR cGetFuncao SIZE 210, 010 OF oDlgFuncao COLORS 0, 16777215 PIXEL  
    
    DEFINE SBUTTON oSButConf FROM 065, 160 TYPE 01 OF oDlgFuncao ENABLE ACTION (PutMV("ES_FERNAND",AllTrim(cGetFuncao)),&(AllTrim(cGetFuncao)),ApMsgAlert("Debug Finalizado"))
    DEFINE SBUTTON oSButEnd  FROM 065, 200 TYPE 02 OF oDlgFuncao ENABLE ACTION (oDlgFuncao:End())
    
  ACTIVATE MSDIALOG oDlgFuncao CENTERED

Return*/

User Function AfterLogin()
	Local cId	:= ParamIXB[1]
	Local cNome := ParamIXB[2]      
	//ApMsgAlert("Usuแrio "+ cId + " - " + Alltrim(cNome)+" efetuou login เs "+Time())
	//If AllTrim(cNome) <> "liquidacao"
	//	Final("Acesso nใo autorizado!")
	//Endif
	If (AllTrim(cModulo) <> "FAT" .And. Left(oMainWnd:cCaption,18) == "Documento de Saida")
		Final("Acesso nใo autorizado!")
	Endif
Return

//-------------------------------------------------------------------------------------------------
 
User Function TesteWs(cEmpInt, cFilInt, cNumTroca, cDocumento)
//IntNFDev(cEmpInt, cFilInt, cNumTroca)
//U_IntNFDev("01","010104","000004","DEVOLUCAO")
//U_TesteWs("01","010104","000004","DEVOLUCAO")
//U_INTPEDIDO("01","010104", "124114","PEDIDO","")
//U_TesteWs("01","010104", "124114","PEDIDO","")
 
Local oWs := NIL

If Upper(AllTrim(cDocumento)) == "PEDIDO"
	oWs := WSPEDWEBAVANT():New()
ElseIf Upper(AllTrim(cDocumento)) == "DEVOLUCAO"
	oWs := WSDEVWEBAVANT():New()
Endif
 
If oWs:CONNECT(cEmpInt, cFilInt, cNumTroca)
	If IsMemVar(oWs:oWSCONNECTRESULT:cDOCUMENTO)
		alert('Documento: '+ oWs:oWSCONNECTRESULT:cDOCUMENTO)
	Endif
	If IsMemVar(oWs:oWSCONNECTRESULT:cMENSAGEM)
		alert('Mensagem: '+ oWs:oWSCONNECTRESULT:cMENSAGEM)
	Endif
Else 
	alert('Erro de Execu็ใo : '+GetWSCError())
Endif
 
Return

User Function Arquivos() 

_cArquivo := ""

aDirectory := DIRECTORY("\updates\*.ptm", "D")

conout("teste")

For _n := 1 to Len(aDirectory)

	  _cArquivo += aDirectory[_n][1]

Next _n

conout("teste")

Return