#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"
#INCLUDE "FWMVCDEF.CH"

User Function ListarFuncoes()

Local aIntFunctions := __FunArr()

For _nX := 1 To Len(aIntFunctions) 
	ConOut(aIntFunctions[_nX,1])
Next
 
Return

User Function TesteImp(cEmpInt, cFilInt, cCliente, cLoja, cOperacao,cProduto,nQuantidade,nValor)
	Local aTabelas	:= {"SA1", "SC5", "SC6", "SC9", "SD2", "SF2", "SF4", "SF5", "SFM", "SB1", "SB2", "SB9"}
	Local lRetorno 	:= .T.
	Local cPicture	:= "@E 999,999,999,999.99"

	Local cEmpCons	:= cEmpInt
	Local cFilCons	:= cFilInt
	Local cCliente	:= cCliente
	Local cLojaCli	:= cLoja
	Local cTpOper	:= cOperacao
	Local cProduto	:= PadR(cProduto,TamSx3("B1_COD")[1])
	Local cLocal	:= "01"
	Local nQtdProd	:= nQuantidade
	Local nVlrProd	:= nValor
	Local cTesOper	:= ""
	Local nVlrTot	:= nQtdProd * nVlrProd
	Local nItem		:= 0
	Local aImpostos	:= {}
	Local nVlrIcm	:= 0
	Local nVlrIpi	:= 0
	Local nVlrIcc	:= 0
	Local nVlrDif	:= 0
	Local nVlrPis	:= 0
	Local nVlrCof	:= 0
	Local nVlrRet	:= 0
	Local nDescSuf	:= 0
	
	DbSelectArea("SA1")
	DbSetOrder(1)
	
	If DbSeek(xFilial("SA1") + cCliente + cLojaCli)
		//Inicializa a Funcao Fiscal
		MaFisIni(	SA1->A1_COD		,;		// 01-Codigo Cliente
					SA1->A1_LOJA	,;		// 02-Loja do Cliente
					"C"				,;		// 03-C:Cliente , F:Fornecedor
					"N"				,;		// 04-Tipo da NF
					SA1->A1_TIPO	,;		// 05-Tipo do Cliente
					Nil				,;		// 06-Relacao de Impostos que suportados no arquivo
					Nil				,;		// 07-Tipo de complemento
					Nil				,;		// 08-Permite Incluir Impostos no Rodape .T./.F.
					"SB1"			,;		// 09-Alias do Cadastro de Produtos - ("SBI" P/ Front Loja)
					"MATA461"		,;		// 10-Nome da rotina que esta utilizando a funcao
					Nil				,;		// 11-Tipo de documento
					Nil				,;		// 12-Especie do documento 
					Nil				,;		// 13-Codigo e Loja do Prospect 
					Nil				,;		// 14-Grupo Cliente
					Nil				,;		// 15-Recolhe ISS
					Nil				,;		// 16-Codigo do cliente de entrega na nota fiscal de saida
					Nil				,;		// 17-Loja do cliente de entrega na nota fiscal de saida
					Nil				)		// 18-Informacoes do transportador [01]-UF,[02]-TPTRANS

		//Recupera a TES de Saida para a Operacao Informada
		cTesOper := MaTesInt(2, cTpOper, SA1->A1_COD, SA1->A1_LOJA, "C", cProduto, NIL)

		If SA1->A1_CALCSUF = 'S'
			//nVlrTot := nVlrTot*(1-(GetMV("MV_TXPIS")+GetMV("MV_TXCOFIN"))/100)
		Endif

		//Adiciona o Produto para Calculo dos Impostos
		nItem := 	MaFisAdd(	cProduto	,;   	// 1-Codigo do Produto ( Obrigatorio )
								cTesOper	,;	   	// 2-Codigo do TES ( Opcional )
								nQtdProd	,;	   	// 3-Quantidade ( Obrigatorio )
								nVlrProd	,;   	// 4-Preco Unitario ( Obrigatorio )
								0			,;  	// 5-Valor do Desconto ( Opcional )
								""			,;	   	// 6-Numero da NF Original ( Devolucao/Benef )
								""			,;		// 7-Serie da NF Original ( Devolucao/Benef )
								0			,;		// 8-RecNo da NF Original no arq SD1/SD2
								0			,;		// 9-Valor do Frete do Item ( Opcional )
								0			,;		// 10-Valor da Despesa do item ( Opcional )
								0			,;		// 11-Valor do Seguro do item ( Opcional )
								0			,;		// 12-Valor do Frete Autonomo ( Opcional )
								nVlrTot		,;		// 13-Valor da Mercadoria ( Obrigatorio )
								0			,;		// 14-Valor da Embalagem ( Opiconal )
								NIL			,;		// 15-RecNo do SB1
								NIL			,;		// 16-RecNo do SF4
								NIL			)

		aImpostos	:= MafisRet(NIL, "NF_IMPOSTOS")
		nPosIcm		:= Ascan(aImpostos, {|x| AllTrim(x[01]) == "ICM"})
		nPosIpi		:= Ascan(aImpostos, {|x| AllTrim(x[01]) == "IPI"})
		nPosIcc		:= Ascan(aImpostos, {|x| AllTrim(x[01]) == "ICC"})
		nPosDif		:= Ascan(aImpostos, {|x| AllTrim(x[01]) == "DIF"})
		nPosPis		:= Ascan(aImpostos, {|x| AllTrim(x[01]) == "PS2"})
		nPosCof		:= Ascan(aImpostos, {|x| AllTrim(x[01]) == "CF2"})
		nPosRet		:= Ascan(aImpostos, {|x| AllTrim(x[01]) == "ICR"})
		
		If nPosIcm > 0
			nVlrIcm := aImpostos[nPosIcm][05]
		EndIf
		
		If nPosPis > 0
			nVlrPis := aImpostos[nPosPis][05]
		EndIf

		If nPosCof > 0
			nVlrCof := aImpostos[nPosCof][05]
		EndIf

		If nPosRet > 0
			nVlrRet := aImpostos[nPosRet][05]
		EndIf

		MaFisEnd()
	EndIf

Return lRetorno


User Function TesteWsImp(cEmpInt, cFilInt, cCliente, cLoja, cOperacao,cProduto,nQuantidade,nValor)
//U_TesteWsImp('01','010104','022499','01','51','873261372',10,200)

Local oWs := NIL

oWs := WSIMPAVANT():New()

ConOut('TesteWsImp1')

If oWs:CONSULTA(cEmpInt,cFilInt,cCliente,cLoja,cOperacao,cProduto,nQuantidade,nValor)
	ConOut('TesteWsImp2')
	ConOut('ICMS')
	ConOut(oWs:oWSCONSULTARESULT:nICMS)
	ConOut('IPI')
	ConOut(oWs:oWSCONSULTARESULT:nIPI)
	ConOut('ICC')
	ConOut(oWs:oWSCONSULTARESULT:nICC)
	ConOut('DIF')
	ConOut(oWs:oWSCONSULTARESULT:nDIF)
	ConOut('PIS')
	ConOut(oWs:oWSCONSULTARESULT:nPIS)
	ConOut('COFINS')
	ConOut(oWs:oWSCONSULTARESULT:nCOFINS)
	ConOut('ICMSRET')
	ConOut(oWs:oWSCONSULTARESULT:nICMSRET)
	ConOut('DESCSUF')
	ConOut(oWs:oWSCONSULTARESULT:nDESCSUF)
Endif

Return

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
	alert('Erro de ExecuÁ„o : '+GetWSCError())
Endif
 
Return


/*User Function TESTLOT()

ConOut("Teste")

Return &("Eval({||cAlias:='SB1',.T.})")*/

/*User Function TesteWs(ccnpj,cinscsuf)
 
Local oWs := NIL

cCep := '09694010'

oWs := WSCadastroConsultasWSService():New()

If MsgYesNo('Suframa - sim, CNPJ - nao')
	oWs:consultarSituacaoInscsuf(cinscsuf)
	alert (oWs:nconsultarSituacaoInscsufReturn)
Else
	oWs:consultarSituacaoInscCnpj(ccnpj,cinscsuf)
	alert (oWs:nconsultarSituacaoInscCnpjReturn)
Endif

oCep := WSCEPService():New()
oCep:obterLogradouro(cCep)
alert(oCep:cobterLogradouroResponse)

conout('teste')
  
Return*/

/*User Function AfterLogin()

If Left(oMainWnd:cCaption,12) <> "Unitizadores" ;
	.And. Left(oMainWnd:cCaption,17) <> "Pick List Pedidos" ;
	.And. Left(oMainWnd:cCaption,13) <> "Pick List NFs" ;
	.And. Left(oMainWnd:cCaption,13) <> "Pick List WMS" ;
	.And. Left(oMainWnd:cCaption,12) <> "Habilita WMS" ;
	.And. Left(oMainWnd:cCaption,06) <> "Normas" ;
	.And. Left(oMainWnd:cCaption,17) <> "Zonas Armazenagem" ;
	.And. Left(oMainWnd:cCaption,18) <> "Estruturas FÌsicas" ;
	.And. Left(oMainWnd:cCaption,07) <> "Funcoes" ;
	.And. Left(oMainWnd:cCaption,16) <> "Recursos Humanos" ;
	.And. Left(oMainWnd:cCaption,18) <> "Conf.cod.endereÁos" ;
	.And. Left(oMainWnd:cCaption,18) <> "Excecoes Atividade" ;
	.And. Left(oMainWnd:cCaption,09) <> "EndereÁos" ;
	.And. Left(oMainWnd:cCaption,18) <> "Seq. Abastecimento" ;
	.And. Left(oMainWnd:cCaption,18) <> "Tarefasxatividades" ;
	.And. Left(oMainWnd:cCaption,16) <> "ServiÁosxtarefas" ;
	.And. Left(oMainWnd:cCaption,16) <> "Regra Convocacao" ;
	.And. Left(oMainWnd:cCaption,13) <> "Etiqueta Lote" ;
	.And. Left(oMainWnd:cCaption,15) <> "Etiqueta Volume" ;
	.And. Left(oMainWnd:cCaption,16) <> "Etiq.Volume S/NF" ;
	.And. Left(oMainWnd:cCaption,17) <> "Exec. de Servicos" ;
	.And. Left(oMainWnd:cCaption,08) <> "O.s. Wms" ;
	.And. Left(oMainWnd:cCaption,15) <> "Reabastecimento" ;
	.And. Left(oMainWnd:cCaption,18) <> "Monitor de Servico" ;
	.And. Left(oMainWnd:cCaption,18) <> "Monitor de Volumes" ;
	.And. Left(oMainWnd:cCaption,18) <> "Conf.o.s.wms Embal" ;
	.And. Left(oMainWnd:cCaption,10) <> "Operadores" ;
	.And. Left(oMainWnd:cCaption,15) <> "Local Impressao" ;
	.And. Left(oMainWnd:cCaption,10) <> "Monitor Rf" ;
	.And. Left(oMainWnd:cCaption,18) <> "Controle de Tarefa" ;
	.And. Left(oMainWnd:cCaption,18) <> "Produto X Endereco" ;
	.And. Left(oMainWnd:cCaption,17) <> "Mestre Inventario" ;
	.And. Left(oMainWnd:cCaption,18) <> "Lan. de Inventario" ;
	.And. Left(oMainWnd:cCaption,18) <> "Tipos de Embalagem" ;
	.And. Left(oMainWnd:cCaption,16) <> "Etiq. Operadores" ;
	.And. Left(oMainWnd:cCaption,14) <> "Etiq. Endereco" ;
	.And. Left(oMainWnd:cCaption,18) <> "Etiq. Recursos Prd" ;
	.And. Left(oMainWnd:cCaption,18) <> "Etiq. Transacao Pr" ;
	.And. Left(oMainWnd:cCaption,17) <> "Reimpressao Etiq." ;
	.And. Left(oMainWnd:cCaption,18) <> "Wizard Imp. Etique" ;
	.And. Left(oMainWnd:cCaption,08) <> "Produtos" ;
	.And. Left(oMainWnd:cCaption,18) <> "Altera Etiqueta Vo";
	.And. Left(oMainWnd:cCaption,18) <> "Enderecar Produtos"
	Final("Acesso n„o autorizado! Utilizar o ambiente Avant.")
Endif

Return*/

/*User Function AfterLogin()
	Local cId	:= ParamIXB[1]
	Local cNome := ParamIXB[2]      
	
	local cError := cWarning := cDestinatario := cDataEmissao := "",;
         cNomearq := "\menus\wms.xnu",; 
         oNotaxml := xmlparserfile(cNomearq, "", @cError, @cWarning)

   if cError # "" .or. cWarning # ""
      alert("Erro: " + cError + "  -  Aviso: " + cWarning )
   else
      cDestinatario := alltrim(oNotaxml:_nfeProc:_NFe:_infNFe:_dest:_xNome:Text)
      cDataEmissao  := alltrim(oNotaxml:_nfeProc:_NFe:_infNFe:_ide:_dEmi:Text)

      msgalert("Destinatario: " + cDestinatario + " - Emissao: " + cDataEmissao )
   endif
	
	//ApMsgAlert("Usu·rio "+ cId + " - " + Alltrim(cNome)+" efetuou login ‡s "+Time())
	//If AllTrim(cNome) <> "liquidacao"
	//	Final("Acesso n„o autorizado!")
	//Endif
	If AllTrim(cModulo) <> "WMS" //.And. Left(oMainWnd:cCaption,18) == "Documento de Saida") .Or. Left(oMainWnd:cCaption,18) <> "Documento de Saida"
		Final("Acesso n„o autorizado!"+Chr(13)+Chr(10)+"Somente mÛdulo do WMS.")
	Endif
Return
*/
/* ===============================================================================
WSDL Location    http://www.byjg.com.br/site/webservice.php/ws/cep?WSDL
Gerado em        05/29/15 15:15:06
ObservaÁıes      CÛdigo-Fonte gerado por ADVPL WSDL Client 1.120703
                 AlteraÁıes neste arquivo podem causar funcionamento incorreto
                 e ser„o perdidas caso o cÛdigo-fonte seja gerado novamente.
=============================================================================== */

//User Function _NLZPYHP ; Return  // "dummy" function - Internal Use 

/*-------------------------------------------------------------------------------
WSDL Service WSCEPService
------------------------------------------------------------------------------- */

/*WSCLIENT WSCEPService

	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD RESET
	WSMETHOD CLONE
	WSMETHOD obterVersao
	WSMETHOD obterLogradouro
	WSMETHOD obterLogradouroAuth
	WSMETHOD obterCEP
	WSMETHOD obterCEPAuth

	WSDATA   _URL                      AS String
	WSDATA   _HEADOUT                  AS Array of String
	WSDATA   _COOKIES                  AS Array of String
	WSDATA   cobterVersaoResponse      AS string
	WSDATA   ccep                      AS string
	WSDATA   cobterLogradouroResponse  AS string
	WSDATA   cusuario                  AS string
	WSDATA   csenha                    AS string
	WSDATA   cobterLogradouroAuthResponse AS string
	WSDATA   clogradouro               AS string
	WSDATA   clocalidade               AS string
	WSDATA   cUF                       AS string
	WSDATA   oWSobterCEPResponse       AS CEPService_ArrayOfstring
	WSDATA   oWSobterCEPAuthResponse   AS CEPService_ArrayOfstring

ENDWSCLIENT

WSMETHOD NEW WSCLIENT WSCEPService
::Init()
If !FindFunction("XMLCHILDEX")
	UserException("O CÛdigo-Fonte Client atual requer os execut·veis do Protheus Build [7.00.131227A-20150327] ou superior. Atualize o Protheus ou gere o CÛdigo-Fonte novamente utilizando o Build atual.")
EndIf
Return Self

WSMETHOD INIT WSCLIENT WSCEPService
	::oWSobterCEPResponse := CEPService_ARRAYOFSTRING():New()
	::oWSobterCEPAuthResponse := CEPService_ARRAYOFSTRING():New()
Return

WSMETHOD RESET WSCLIENT WSCEPService
	::cobterVersaoResponse := NIL 
	::ccep               := NIL 
	::cobterLogradouroResponse := NIL 
	::cusuario           := NIL 
	::csenha             := NIL 
	::cobterLogradouroAuthResponse := NIL 
	::clogradouro        := NIL 
	::clocalidade        := NIL 
	::cUF                := NIL 
	::oWSobterCEPResponse := NIL 
	::oWSobterCEPAuthResponse := NIL 
	::Init()
Return

WSMETHOD CLONE WSCLIENT WSCEPService
Local oClone := WSCEPService():New()
	oClone:_URL          := ::_URL 
	oClone:cobterVersaoResponse := ::cobterVersaoResponse
	oClone:ccep          := ::ccep
	oClone:cobterLogradouroResponse := ::cobterLogradouroResponse
	oClone:cusuario      := ::cusuario
	oClone:csenha        := ::csenha
	oClone:cobterLogradouroAuthResponse := ::cobterLogradouroAuthResponse
	oClone:clogradouro   := ::clogradouro
	oClone:clocalidade   := ::clocalidade
	oClone:cUF           := ::cUF
	oClone:oWSobterCEPResponse :=  IIF(::oWSobterCEPResponse = NIL , NIL ,::oWSobterCEPResponse:Clone() )
	oClone:oWSobterCEPAuthResponse :=  IIF(::oWSobterCEPAuthResponse = NIL , NIL ,::oWSobterCEPAuthResponse:Clone() )
Return oClone

// WSDL Method obterVersao of Service WSCEPService

WSMETHOD obterVersao WSSEND NULLPARAM WSRECEIVE cobterVersaoResponse WSCLIENT WSCEPService
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<q1:obterVersao xmlns:q1="urn:http://www.byjg.com.br">'
cSoap += "</q1:obterVersao>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"urn:CEPServiceAction",; 
	"RPCX","urn:CEPService",,,; 
	"http://www.byjg.com.br/site/webservice.php/ws/cep")

::Init()
::cobterVersaoResponse :=  WSAdvValue( oXmlRet,"_OBTERVERSAORESPONSE","string",NIL,NIL,NIL,"S",NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method obterLogradouro of Service WSCEPService

WSMETHOD obterLogradouro WSSEND ccep WSRECEIVE cobterLogradouroResponse WSCLIENT WSCEPService
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<q1:obterLogradouro xmlns:q1="http://www.w3.org/2001/XMLSchema">'
cSoap += WSSoapValue("cep", ::ccep, ccep , "string", .T. , .T. , 0 , NIL, .F.) 
cSoap += "</q1:obterLogradouro>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"urn:CEPServiceAction",; 
	"RPCX","urn:CEPService",,,; 
	"http://www.byjg.com.br/site/webservice.php/ws/cep")

::Init()
::cobterLogradouroResponse :=  WSAdvValue( oXmlRet,"_OBTERLOGRADOURORESPONSE","string",NIL,NIL,NIL,"S",NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method obterLogradouroAuth of Service WSCEPService

WSMETHOD obterLogradouroAuth WSSEND ccep,cusuario,csenha WSRECEIVE cobterLogradouroAuthResponse WSCLIENT WSCEPService
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<q1:obterLogradouroAuth xmlns:q1="urn:http://www.byjg.com.br">'
cSoap += WSSoapValue("cep", ::ccep, ccep , "string", .T. , .T. , 0 , NIL, .F.) 
cSoap += WSSoapValue("usuario", ::cusuario, cusuario , "string", .T. , .T. , 0 , NIL, .F.) 
cSoap += WSSoapValue("senha", ::csenha, csenha , "string", .T. , .T. , 0 , NIL, .F.) 
cSoap += "</q1:obterLogradouroAuth>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"urn:CEPServiceAction",; 
	"RPCX","urn:CEPService",,,; 
	"http://www.byjg.com.br/site/webservice.php/ws/cep")

::Init()
::cobterLogradouroAuthResponse :=  WSAdvValue( oXmlRet,"_OBTERLOGRADOUROAUTHRESPONSE","string",NIL,NIL,NIL,"S",NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method obterCEP of Service WSCEPService

WSMETHOD obterCEP WSSEND clogradouro,clocalidade,cUF WSRECEIVE oWSobterCEPResponse WSCLIENT WSCEPService
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<q1:obterCEP xmlns:q1="urn:http://www.byjg.com.br">'
cSoap += WSSoapValue("logradouro", ::clogradouro, clogradouro , "string", .T. , .T. , 0 , NIL, .F.) 
cSoap += WSSoapValue("localidade", ::clocalidade, clocalidade , "string", .T. , .T. , 0 , NIL, .F.) 
cSoap += WSSoapValue("UF", ::cUF, cUF , "string", .T. , .T. , 0 , NIL, .F.) 
cSoap += "</q1:obterCEP>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"urn:CEPServiceAction",; 
	"RPCX","urn:CEPService",,,; 
	"http://www.byjg.com.br/site/webservice.php/ws/cep")

::Init()
::oWSobterCEPResponse:SoapRecv( WSAdvValue( oXmlRet,"_OBTERCEPRESPONSE","ArrayOfstring",NIL,NIL,NIL,"O",NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method obterCEPAuth of Service WSCEPService

WSMETHOD obterCEPAuth WSSEND clogradouro,clocalidade,cUF,cusuario,csenha WSRECEIVE oWSobterCEPAuthResponse WSCLIENT WSCEPService
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<q1:obterCEPAuth xmlns:q1="urn:http://www.byjg.com.br">'
cSoap += WSSoapValue("logradouro", ::clogradouro, clogradouro , "string", .T. , .T. , 0 , NIL, .F.) 
cSoap += WSSoapValue("localidade", ::clocalidade, clocalidade , "string", .T. , .T. , 0 , NIL, .F.) 
cSoap += WSSoapValue("UF", ::cUF, cUF , "string", .T. , .T. , 0 , NIL, .F.) 
cSoap += WSSoapValue("usuario", ::cusuario, cusuario , "string", .T. , .T. , 0 , NIL, .F.) 
cSoap += WSSoapValue("senha", ::csenha, csenha , "string", .T. , .T. , 0 , NIL, .F.) 
cSoap += "</q1:obterCEPAuth>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"urn:CEPServiceAction",; 
	"RPCX","urn:CEPService",,,; 
	"http://www.byjg.com.br/site/webservice.php/ws/cep")

::Init()
::oWSobterCEPAuthResponse:SoapRecv( WSAdvValue( oXmlRet,"_OBTERCEPAUTHRESPONSE","ArrayOfstring",NIL,NIL,NIL,"O",NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.


// WSDL Data Structure ArrayOfstring

WSSTRUCT CEPService_ArrayOfstring
	WSDATA   cstring                   AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT CEPService_ArrayOfstring
	::Init()
Return Self

WSMETHOD INIT WSCLIENT CEPService_ArrayOfstring
	::cstring              := {} // Array Of  ""
Return

WSMETHOD CLONE WSCLIENT CEPService_ArrayOfstring
	Local oClone := CEPService_ArrayOfstring():NEW()
	oClone:cstring              := IIf(::cstring <> NIL , aClone(::cstring) , NIL )
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT CEPService_ArrayOfstring
	Local oNodes1 :=  WSAdvValue( oResponse,"_STRING","string",{},NIL,.T.,"S",NIL,"a") 
	::Init()
	If oResponse = NIL ; Return ; Endif 
	aEval(oNodes1 , { |x| aadd(::cstring ,  x:TEXT  ) } )
Return
*/



/* ===============================================================================
WSDL Location    https://200.198.228.131/cadastroWS/services/CadastroWebService?wsdl
Gerado em        05/29/15 10:32:00
ObservaÁıes      CÛdigo-Fonte gerado por ADVPL WSDL Client 1.120703
                 AlteraÁıes neste arquivo podem causar funcionamento incorreto
                 e ser„o perdidas caso o cÛdigo-fonte seja gerado novamente.
=============================================================================== */

//User Function _OJOMKEF ; Return  // "dummy" function - Internal Use 

/* -------------------------------------------------------------------------------
WSDL Service WSCadastroConsultasWSService
------------------------------------------------------------------------------- */

/*WSCLIENT WSCadastroConsultasWSService

	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD RESET
	WSMETHOD CLONE
	WSMETHOD consultarSituacaoInscsuf
	WSMETHOD consultarSituacaoInscCnpj

	WSDATA   _URL                      AS String
	WSDATA   _CERT                     AS String
	WSDATA   _PRIVKEY                  AS String
	WSDATA   _PASSPHRASE               AS String
	WSDATA   _HEADOUT                  AS Array of String
	WSDATA   _COOKIES                  AS Array of String
	WSDATA   cinscsuf                  AS string
	WSDATA   nconsultarSituacaoInscsufReturn AS int
	WSDATA   ccnpj                     AS string
	WSDATA   nconsultarSituacaoInscCnpjReturn AS int

ENDWSCLIENT

WSMETHOD NEW WSCLIENT WSCadastroConsultasWSService
::Init()
If !FindFunction("XMLCHILDEX")
	UserException("O CÛdigo-Fonte Client atual requer os execut·veis do Protheus Build [7.00.131227A-20150327] ou superior. Atualize o Protheus ou gere o CÛdigo-Fonte novamente utilizando o Build atual.")
EndIf
Return Self

WSMETHOD INIT WSCLIENT WSCadastroConsultasWSService
Return

WSMETHOD RESET WSCLIENT WSCadastroConsultasWSService
	::cinscsuf           := NIL 
	::nconsultarSituacaoInscsufReturn := NIL 
	::ccnpj              := NIL 
	::nconsultarSituacaoInscCnpjReturn := NIL 
	::Init()
Return

WSMETHOD CLONE WSCLIENT WSCadastroConsultasWSService
Local oClone := WSCadastroConsultasWSService():New()
	oClone:_URL          := ::_URL 
	oClone:_CERT         := ::_CERT 
	oClone:_PRIVKEY      := ::_PRIVKEY 
	oClone:_PASSPHRASE   := ::_PASSPHRASE 
	oClone:cinscsuf      := ::cinscsuf
	oClone:nconsultarSituacaoInscsufReturn := ::nconsultarSituacaoInscsufReturn
	oClone:ccnpj         := ::ccnpj
	oClone:nconsultarSituacaoInscCnpjReturn := ::nconsultarSituacaoInscCnpjReturn
Return oClone

// WSDL Method consultarSituacaoInscsuf of Service WSCadastroConsultasWSService

WSMETHOD consultarSituacaoInscsuf WSSEND cinscsuf WSRECEIVE nconsultarSituacaoInscsufReturn WSCLIENT WSCadastroConsultasWSService
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<q1:consultarSituacaoInscsuf xmlns:q1="http://schemas.xmlsoap.org/soap/encoding/">'
cSoap += WSSoapValue("inscsuf", ::cinscsuf, cinscsuf , "string", .T. , .T. , 0 , NIL, .F.) 
cSoap += "</q1:consultarSituacaoInscsuf>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"",; 
	"DOCUMENT","https://200.198.228.131/cadastroWS/services/CadastroWebService",,,; 
	"https://200.198.228.131/cadastroWS/services/CadastroWebService")

::Init()
::nconsultarSituacaoInscsufReturn :=  WSAdvValue( oXmlRet,"_CONSULTARSITUACAOINSCSUFRETURN","int",NIL,NIL,NIL,"N",NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method consultarSituacaoInscCnpj of Service WSCadastroConsultasWSService

WSMETHOD consultarSituacaoInscCnpj WSSEND ccnpj,cinscsuf WSRECEIVE nconsultarSituacaoInscCnpjReturn WSCLIENT WSCadastroConsultasWSService
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<q1:consultarSituacaoInscCnpj xmlns:q1="http://consultas.ws.cadastro.fucapi.br">'
cSoap += WSSoapValue("cnpj", ::ccnpj, ccnpj , "string", .T. , .T. , 0 , NIL, .F.) 
cSoap += WSSoapValue("inscsuf", ::cinscsuf, cinscsuf , "string", .T. , .T. , 0 , NIL, .F.) 
cSoap += "</q1:consultarSituacaoInscCnpj>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"",; 
	"RPCX","https://200.198.228.131/cadastroWS/services/CadastroWebService",,,; 
	"https://200.198.228.131/cadastroWS/services/CadastroWebService")

::Init()
::nconsultarSituacaoInscCnpjReturn :=  WSAdvValue( oXmlRet,"_CONSULTARSITUACAOINSCCNPJRETURN","int",NIL,NIL,NIL,"N",NIL,NIL)  

END WSMETHOD

oXmlRet := NIL
Return .T.


/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥ Fernando ∫Autor  ≥Fernando Nogueira   ∫ Data ≥ 25/02/2014  ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥ Programa para testes                                       ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ Especifico Avant                                           ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/
User Function Fernando()

Conout('teste')

Return

/*X31UPDTABLE("SB1")

EVAL({||X31UPDTABLE("SZH"),__GetX31Error(),alert(__GetX31Trace())})

If __GetX31Error()

	ConOut( __GetX31Trace(), "Erro" )

Endif

Return*/

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

  DEFINE MSDIALOG oDlgFuncao TITLE "FunÁ„o" FROM 000, 000  TO 170, 480 COLORS 0, 16777215 PIXEL

    @ 007, 005 GROUP oGroup1 TO 054, 232 OF oDlgFuncao COLOR 0, 16777215 PIXEL
    @ 016, 013 SAY oSayNome PROMPT "Digite o nome da funÁ„o:" SIZE 065, 009 OF oDlgFuncao COLORS 0, 16777215 PIXEL
    @ 030, 013 MSGET oGetFuncao VAR cGetFuncao SIZE 210, 010 OF oDlgFuncao COLORS 0, 16777215 PIXEL  
    
    DEFINE SBUTTON oSButConf FROM 065, 160 TYPE 01 OF oDlgFuncao ENABLE ACTION (PutMV("ES_FERNAND",AllTrim(cGetFuncao)),&(AllTrim(cGetFuncao)),ApMsgAlert("Debug Finalizado"))
    DEFINE SBUTTON oSButEnd  FROM 065, 200 TYPE 02 OF oDlgFuncao ENABLE ACTION (oDlgFuncao:End())
    
  ACTIVATE MSDIALOG oDlgFuncao CENTERED

Return*/


//-------------------------------------------------------------------------------------------------

/* 


User Function Arquivos() 

_cArquivo := ""

aDirectory := DIRECTORY("\updates\*.ptm", "D")

conout("teste")

For _n := 1 to Len(aDirectory)

	  _cArquivo += aDirectory[_n][1]

Next _n

conout("teste")

Return*/