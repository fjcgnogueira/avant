#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"

/* ===============================================================================
WSDL Location    http://192.168.0.8:8088/DEVWEBAVANT.apw?WSDL
Gerado em        05/01/14 14:18:03
Observações      Código-Fonte gerado por ADVPL WSDL Client 1.120703
                 Alterações neste arquivo podem causar funcionamento incorreto
                 e serão perdidas caso o código-fonte seja gerado novamente.
=============================================================================== */

User Function _QOMSPYE ; Return  // "dummy" function - Internal Use 

/* -------------------------------------------------------------------------------
WSDL Service WSDEVWEBAVANT
------------------------------------------------------------------------------- */

WSCLIENT WSDEVWEBAVANT

	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD RESET
	WSMETHOD CLONE
	WSMETHOD CONNECT

	WSDATA   _URL                      AS String
	WSDATA   _HEADOUT                  AS Array of String
	WSDATA   _COOKIES                  AS Array of String
	WSDATA   cEMPINTEGRA               AS string
	WSDATA   cFILINTEGRA               AS string
	WSDATA   cPARAMETRO                AS string
	WSDATA   oWSCONNECTRESULT          AS DEVWEBAVANT_RETDEVOL

ENDWSCLIENT

WSMETHOD NEW WSCLIENT WSDEVWEBAVANT
::Init()
If !FindFunction("XMLCHILDEX")
	UserException("O Código-Fonte Client atual requer os executáveis do Protheus Build [7.00.121227P-20131106] ou superior. Atualize o Protheus ou gere o Código-Fonte novamente utilizando o Build atual.")
EndIf
Return Self

WSMETHOD INIT WSCLIENT WSDEVWEBAVANT
	::oWSCONNECTRESULT   := DEVWEBAVANT_RETDEVOL():New()
Return

WSMETHOD RESET WSCLIENT WSDEVWEBAVANT
	::cEMPINTEGRA        := NIL 
	::cFILINTEGRA        := NIL 
	::cPARAMETRO         := NIL 
	::oWSCONNECTRESULT   := NIL 
	::Init()
Return

WSMETHOD CLONE WSCLIENT WSDEVWEBAVANT
Local oClone := WSDEVWEBAVANT():New()
	oClone:_URL          := ::_URL 
	oClone:cEMPINTEGRA   := ::cEMPINTEGRA
	oClone:cFILINTEGRA   := ::cFILINTEGRA
	oClone:cPARAMETRO    := ::cPARAMETRO
	oClone:oWSCONNECTRESULT :=  IIF(::oWSCONNECTRESULT = NIL , NIL ,::oWSCONNECTRESULT:Clone() )
Return oClone

// WSDL Method CONNECT of Service WSDEVWEBAVANT

WSMETHOD CONNECT WSSEND cEMPINTEGRA,cFILINTEGRA,cPARAMETRO WSRECEIVE oWSCONNECTRESULT WSCLIENT WSDEVWEBAVANT
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<CONNECT xmlns="http://192.168.0.8:8088/">'
cSoap += WSSoapValue("EMPINTEGRA", ::cEMPINTEGRA, cEMPINTEGRA , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("FILINTEGRA", ::cFILINTEGRA, cFILINTEGRA , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("PARAMETRO", ::cPARAMETRO, cPARAMETRO , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += "</CONNECT>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://192.168.0.8:8088/CONNECT",; 
	"DOCUMENT","http://192.168.0.8:8088/",,"1.031217",; 
	"http://192.168.0.8:8088/DEVWEBAVANT.apw")

::Init()
::oWSCONNECTRESULT:SoapRecv( WSAdvValue( oXmlRet,"_CONNECTRESPONSE:_CONNECTRESULT","RETDEVOL",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.


// WSDL Data Structure RETDEVOL

WSSTRUCT DEVWEBAVANT_RETDEVOL
	WSDATA   cDOCUMENTO                AS string OPTIONAL
	WSDATA   cMENSAGEM                 AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT DEVWEBAVANT_RETDEVOL
	::Init()
Return Self

WSMETHOD INIT WSCLIENT DEVWEBAVANT_RETDEVOL
Return

WSMETHOD CLONE WSCLIENT DEVWEBAVANT_RETDEVOL
	Local oClone := DEVWEBAVANT_RETDEVOL():NEW()
	oClone:cDOCUMENTO           := ::cDOCUMENTO
	oClone:cMENSAGEM            := ::cMENSAGEM
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT DEVWEBAVANT_RETDEVOL
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::cDOCUMENTO         :=  WSAdvValue( oResponse,"_DOCUMENTO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cMENSAGEM          :=  WSAdvValue( oResponse,"_MENSAGEM","string",NIL,NIL,NIL,"S",NIL,NIL) 
Return
