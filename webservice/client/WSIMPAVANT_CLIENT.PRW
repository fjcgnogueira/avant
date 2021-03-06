#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"

/* ===============================================================================
WSDL Location    http://192.168.0.8:8088/IMPAVANT.apw?WSDL
Gerado em        05/17/16 18:41:43
Observa��es      C�digo-Fonte gerado por ADVPL WSDL Client 1.120703
                 Altera��es neste arquivo podem causar funcionamento incorreto
                 e ser�o perdidas caso o c�digo-fonte seja gerado novamente.
=============================================================================== */

User Function _KYVYMOG ; Return  // "dummy" function - Internal Use 

/* -------------------------------------------------------------------------------
WSDL Service WSIMPAVANT
------------------------------------------------------------------------------- */

WSCLIENT WSIMPAVANT

	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD RESET
	WSMETHOD CLONE
	WSMETHOD CONSULTA

	WSDATA   _URL                      AS String
	WSDATA   _HEADOUT                  AS Array of String
	WSDATA   _COOKIES                  AS Array of String
	WSDATA   cEMPCONS                  AS string
	WSDATA   cFILCONS                  AS string
	WSDATA   cCLIENTE                  AS string
	WSDATA   cLOJA                     AS string
	WSDATA   cOPERACAO                 AS string
	WSDATA   cPRODUTO                  AS string
	WSDATA   nQUANTIDADE               AS float
	WSDATA   nVALOR                    AS float
	WSDATA   oWSCONSULTARESULT         AS IMPAVANT_AVANIMPRET

ENDWSCLIENT

WSMETHOD NEW WSCLIENT WSIMPAVANT
::Init()
If !FindFunction("XMLCHILDEX")
	UserException("O C�digo-Fonte Client atual requer os execut�veis do Protheus Build [7.00.131227A-20150625] ou superior. Atualize o Protheus ou gere o C�digo-Fonte novamente utilizando o Build atual.")
EndIf
Return Self

WSMETHOD INIT WSCLIENT WSIMPAVANT
	::oWSCONSULTARESULT  := IMPAVANT_AVANIMPRET():New()
Return

WSMETHOD RESET WSCLIENT WSIMPAVANT
	::cEMPCONS           := NIL 
	::cFILCONS           := NIL 
	::cCLIENTE           := NIL 
	::cLOJA              := NIL 
	::cOPERACAO          := NIL 
	::cPRODUTO           := NIL 
	::nQUANTIDADE        := NIL 
	::nVALOR             := NIL 
	::oWSCONSULTARESULT  := NIL 
	::Init()
Return

WSMETHOD CLONE WSCLIENT WSIMPAVANT
Local oClone := WSIMPAVANT():New()
	oClone:_URL          := ::_URL 
	oClone:cEMPCONS      := ::cEMPCONS
	oClone:cFILCONS      := ::cFILCONS
	oClone:cCLIENTE      := ::cCLIENTE
	oClone:cLOJA         := ::cLOJA
	oClone:cOPERACAO     := ::cOPERACAO
	oClone:cPRODUTO      := ::cPRODUTO
	oClone:nQUANTIDADE   := ::nQUANTIDADE
	oClone:nVALOR        := ::nVALOR
	oClone:oWSCONSULTARESULT :=  IIF(::oWSCONSULTARESULT = NIL , NIL ,::oWSCONSULTARESULT:Clone() )
Return oClone

// WSDL Method CONSULTA of Service WSIMPAVANT

WSMETHOD CONSULTA WSSEND cEMPCONS,cFILCONS,cCLIENTE,cLOJA,cOPERACAO,cPRODUTO,nQUANTIDADE,nVALOR WSRECEIVE oWSCONSULTARESULT WSCLIENT WSIMPAVANT
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<CONSULTA xmlns="http://192.168.0.8:8088/">'
cSoap += WSSoapValue("EMPCONS", ::cEMPCONS, cEMPCONS , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("FILCONS", ::cFILCONS, cFILCONS , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("CLIENTE", ::cCLIENTE, cCLIENTE , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("LOJA", ::cLOJA, cLOJA , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("OPERACAO", ::cOPERACAO, cOPERACAO , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("PRODUTO", ::cPRODUTO, cPRODUTO , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("QUANTIDADE", ::nQUANTIDADE, nQUANTIDADE , "float", .T. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("VALOR", ::nVALOR, nVALOR , "float", .T. , .F., 0 , NIL, .F.) 
cSoap += "</CONSULTA>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://192.168.0.8:8088/CONSULTA",; 
	"DOCUMENT","http://192.168.0.8:8088/",,"1.031217",; 
	"http://192.168.0.8:8088/IMPAVANT.apw")

::Init()
::oWSCONSULTARESULT:SoapRecv( WSAdvValue( oXmlRet,"_CONSULTARESPONSE:_CONSULTARESULT","AVANIMPRET",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.


// WSDL Data Structure AVANIMPRET

WSSTRUCT IMPAVANT_AVANIMPRET
	WSDATA   nCOFINS                   AS float
	WSDATA   nDESCSUF                  AS float
	WSDATA   nDIF                      AS float
	WSDATA   nICC                      AS float
	WSDATA   nICMS                     AS float
	WSDATA   nICMSRET                  AS float
	WSDATA   nIPI                      AS float
	WSDATA   nPIS                      AS float
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT IMPAVANT_AVANIMPRET
	::Init()
Return Self

WSMETHOD INIT WSCLIENT IMPAVANT_AVANIMPRET
Return

WSMETHOD CLONE WSCLIENT IMPAVANT_AVANIMPRET
	Local oClone := IMPAVANT_AVANIMPRET():NEW()
	oClone:nCOFINS              := ::nCOFINS
	oClone:nDESCSUF             := ::nDESCSUF
	oClone:nDIF                 := ::nDIF
	oClone:nICC                 := ::nICC
	oClone:nICMS                := ::nICMS
	oClone:nICMSRET             := ::nICMSRET
	oClone:nIPI                 := ::nIPI
	oClone:nPIS                 := ::nPIS
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT IMPAVANT_AVANIMPRET
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::nCOFINS            :=  WSAdvValue( oResponse,"_COFINS","float",NIL,"Property nCOFINS as s:float on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::nDESCSUF           :=  WSAdvValue( oResponse,"_DESCSUF","float",NIL,"Property nDESCSUF as s:float on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::nDIF               :=  WSAdvValue( oResponse,"_DIF","float",NIL,"Property nDIF as s:float on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::nICC               :=  WSAdvValue( oResponse,"_ICC","float",NIL,"Property nICC as s:float on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::nICMS              :=  WSAdvValue( oResponse,"_ICMS","float",NIL,"Property nICMS as s:float on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::nICMSRET           :=  WSAdvValue( oResponse,"_ICMSRET","float",NIL,"Property nICMSRET as s:float on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::nIPI               :=  WSAdvValue( oResponse,"_IPI","float",NIL,"Property nIPI as s:float on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::nPIS               :=  WSAdvValue( oResponse,"_PIS","float",NIL,"Property nPIS as s:float on SOAP Response not found.",NIL,"N",NIL,NIL) 
Return


