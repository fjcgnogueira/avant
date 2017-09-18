#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"

/* ===============================================================================
WSDL Location    http://192.168.0.8:8088/NFEXML.apw?WSDL
Gerado em        09/18/17 14:41:12
Observações      Código-Fonte gerado por ADVPL WSDL Client 1.120703
                 Alterações neste arquivo podem causar funcionamento incorreto
                 e serão perdidas caso o código-fonte seja gerado novamente.
=============================================================================== */

User Function _STPPOOX ; Return  // "dummy" function - Internal Use 

/* -------------------------------------------------------------------------------
WSDL Service WSNFEXML
------------------------------------------------------------------------------- */

WSCLIENT WSNFEXML

	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD RESET
	WSMETHOD CLONE
	WSMETHOD XMLDADOS

	WSDATA   _URL                      AS String
	WSDATA   _HEADOUT                  AS Array of String
	WSDATA   _COOKIES                  AS Array of String
	WSDATA   cEMPCONS                  AS string
	WSDATA   cFILCONS                  AS string
	WSDATA   cNFEXML                   AS string
	WSDATA   cNFETIME                  AS string
	WSDATA   cNFEVERSAO                AS string
	WSDATA   oWSXMLDADOSRESULT         AS NFEXML_NFEXMLRET

ENDWSCLIENT

WSMETHOD NEW WSCLIENT WSNFEXML
::Init()
If !FindFunction("XMLCHILDEX")
	UserException("O Código-Fonte Client atual requer os executáveis do Protheus Build [7.00.131227A-20170322] ou superior. Atualize o Protheus ou gere o Código-Fonte novamente utilizando o Build atual.")
EndIf
Return Self

WSMETHOD INIT WSCLIENT WSNFEXML
	::oWSXMLDADOSRESULT  := NFEXML_NFEXMLRET():New()
Return

WSMETHOD RESET WSCLIENT WSNFEXML
	::cEMPCONS           := NIL 
	::cFILCONS           := NIL 
	::cNFEXML            := NIL 
	::cNFETIME           := NIL 
	::cNFEVERSAO         := NIL 
	::oWSXMLDADOSRESULT  := NIL 
	::Init()
Return

WSMETHOD CLONE WSCLIENT WSNFEXML
Local oClone := WSNFEXML():New()
	oClone:_URL          := ::_URL 
	oClone:cEMPCONS      := ::cEMPCONS
	oClone:cFILCONS      := ::cFILCONS
	oClone:cNFEXML       := ::cNFEXML
	oClone:cNFETIME      := ::cNFETIME
	oClone:cNFEVERSAO    := ::cNFEVERSAO
	oClone:oWSXMLDADOSRESULT :=  IIF(::oWSXMLDADOSRESULT = NIL , NIL ,::oWSXMLDADOSRESULT:Clone() )
Return oClone

// WSDL Method XMLDADOS of Service WSNFEXML

WSMETHOD XMLDADOS WSSEND cEMPCONS,cFILCONS,cNFEXML,cNFETIME,cNFEVERSAO WSRECEIVE oWSXMLDADOSRESULT WSCLIENT WSNFEXML
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<XMLDADOS xmlns="http://192.168.0.8:8088/">'
cSoap += WSSoapValue("EMPCONS", ::cEMPCONS, cEMPCONS , "string", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("FILCONS", ::cFILCONS, cFILCONS , "string", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("NFEXML", ::cNFEXML, cNFEXML , "string", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("NFETIME", ::cNFETIME, cNFETIME , "string", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("NFEVERSAO", ::cNFEVERSAO, cNFEVERSAO , "string", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</XMLDADOS>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://192.168.0.8:8088/XMLDADOS",; 
	"DOCUMENT","http://192.168.0.8:8088/",,"1.031217",; 
	"http://192.168.0.8:8088/NFEXML.apw")

::Init()
::oWSXMLDADOSRESULT:SoapRecv( WSAdvValue( oXmlRet,"_XMLDADOSRESPONSE:_XMLDADOSRESULT","NFEXMLRET",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.


// WSDL Data Structure NFEXMLRET

WSSTRUCT NFEXML_NFEXMLRET
	WSDATA   cXMLDADOS                 AS string
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT NFEXML_NFEXMLRET
	::Init()
Return Self

WSMETHOD INIT WSCLIENT NFEXML_NFEXMLRET
Return

WSMETHOD CLONE WSCLIENT NFEXML_NFEXMLRET
	Local oClone := NFEXML_NFEXMLRET():NEW()
	oClone:cXMLDADOS            := ::cXMLDADOS
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT NFEXML_NFEXMLRET
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::cXMLDADOS          :=  WSAdvValue( oResponse,"_XMLDADOS","string",NIL,"Property cXMLDADOS as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
Return


User Function CLIWSNFEXML()
 
Local oWs := NIL
Local cEmpCons := '01'
Local cFilCons := '010104'

Private cXmlDados   := ""
Private nHdlXml     := 0
Private aNotas      := {}
Private aXml        := {}
Private oNFe
Private cModalidade := ""

Alert(Posicione("SF2",1,xFilial("SF2")+"000160000"+"1  "+"022597"+"01","F2_DOC"))

aadd(aNotas,{})
aadd(Atail(aNotas),.F.)
aadd(Atail(aNotas),"S")
aadd(Atail(aNotas),SF2->F2_EMISSAO)
aadd(Atail(aNotas),SF2->F2_SERIE)
aadd(Atail(aNotas),SF2->F2_DOC)
aadd(Atail(aNotas),SF2->F2_CLIENTE)
aadd(Atail(aNotas),SF2->F2_LOJA)

aXml := StaticCall(DanfeII,GetXml,StaticCall(SPEDNFE,GetIdEnt),aNotas,@cModalidade)

oWs := WSNFEXML():New()
 
If oWs:XmlDados(cEmpCons, cFilCons, aXML[1][2],aXML[1][6],NfeIdSPED(aXML[1][2],"versao"))
	Alert(oWs:oWSXMLDADOSRESULT:cXmlDados)
	ConOut(oWs:oWSXMLDADOSRESULT:cXmlDados)
Else 
	alert('Erro de Execução : '+GetWSCError())
Endif
 
Return