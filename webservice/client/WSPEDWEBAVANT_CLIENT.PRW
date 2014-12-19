#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"

/* ===============================================================================
WSDL Location    http://192.168.0.1:8088/PEDWEBAVANT.apw?WSDL
Gerado em        03/21/12 14:47:56
Observações      Código-Fonte gerado por ADVPL WSDL Client 1.111215
                 Alterações neste arquivo podem causar funcionamento incorreto
                 e serão perdidas caso o código-fonte seja gerado novamente.
=============================================================================== */

User Function _OXFLLRN ; Return  // "dummy" function - Internal Use 

/* -------------------------------------------------------------------------------
WSDL Service WSPEDWEBAVANT
------------------------------------------------------------------------------- */

WSCLIENT WSPEDWEBAVANT

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
	WSDATA   oWSCONNECTRESULT          AS PEDWEBAVANT_RETINTEGRA

ENDWSCLIENT

WSMETHOD NEW WSCLIENT WSPEDWEBAVANT
::Init()
If !FindFunction("XMLCHILDEX")
	UserException("O Código-Fonte Client atual requer os executáveis do Protheus Build [7.00.111010P-20120120] ou superior. Atualize o Protheus ou gere o Código-Fonte novamente utilizando o Build atual.")
EndIf
Return Self

WSMETHOD INIT WSCLIENT WSPEDWEBAVANT
	::oWSCONNECTRESULT   := PEDWEBAVANT_RETINTEGRA():New()
Return

WSMETHOD RESET WSCLIENT WSPEDWEBAVANT
	::cEMPINTEGRA        := NIL 
	::cFILINTEGRA        := NIL 
	::cPARAMETRO         := NIL 
	::oWSCONNECTRESULT   := NIL 
	::Init()
Return

WSMETHOD CLONE WSCLIENT WSPEDWEBAVANT
Local oClone := WSPEDWEBAVANT():New()
	oClone:_URL          := ::_URL 
	oClone:cEMPINTEGRA   := ::cEMPINTEGRA
	oClone:cFILINTEGRA   := ::cFILINTEGRA
	oClone:cPARAMETRO    := ::cPARAMETRO
	oClone:oWSCONNECTRESULT :=  IIF(::oWSCONNECTRESULT = NIL , NIL ,::oWSCONNECTRESULT:Clone() )
Return oClone

// WSDL Method CONNECT of Service WSPEDWEBAVANT

WSMETHOD CONNECT WSSEND cEMPINTEGRA,cFILINTEGRA,cPARAMETRO WSRECEIVE oWSCONNECTRESULT WSCLIENT WSPEDWEBAVANT
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
	"http://192.168.0.8:8088/PEDWEBAVANT.apw")

::Init()
::oWSCONNECTRESULT:SoapRecv( WSAdvValue( oXmlRet,"_CONNECTRESPONSE:_CONNECTRESULT","RETINTEGRA",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.


// WSDL Data Structure RETINTEGRA

WSSTRUCT PEDWEBAVANT_RETINTEGRA
	WSDATA   cDOCUMENTO                AS string
	WSDATA   cMENSAGEM                 AS string
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT PEDWEBAVANT_RETINTEGRA
	::Init()
Return Self

WSMETHOD INIT WSCLIENT PEDWEBAVANT_RETINTEGRA
Return

WSMETHOD CLONE WSCLIENT PEDWEBAVANT_RETINTEGRA
	Local oClone := PEDWEBAVANT_RETINTEGRA():NEW()
	oClone:cDOCUMENTO           := ::cDOCUMENTO
	oClone:cMENSAGEM            := ::cMENSAGEM
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT PEDWEBAVANT_RETINTEGRA
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::cDOCUMENTO         :=  WSAdvValue( oResponse,"_DOCUMENTO","string",NIL,"Property cDOCUMENTO as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cMENSAGEM          :=  WSAdvValue( oResponse,"_MENSAGEM","string",NIL,"Property cMENSAGEM as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
Return


