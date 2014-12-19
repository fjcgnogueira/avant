#INCLUDE "APWEBSRV.CH"
#INCLUDE "PROTHEUS.CH"

User Function PEDWEBAV()
Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษอออออออออออออัอออออออออออออหอออออออัออออออออออออออออออหออออออัออออออออออออปฑฑ
ฑฑบ Web Service ณ PEDWEBAVANT บAutor  ณ Amedeo D.P.Filho บ Data ณ  21/03/12  บฑฑ
ฑฑฬอออออออออออออุอออออออออออออสอออออออฯออออออออออออออออออสออออออฯออออออออออออนฑฑ
ฑฑบDescricao    ณ WebService para integracao de pedidos WEB (AVANT)          บฑฑ
ฑฑบ             ณ                                                            บฑฑ
ฑฑฬอออออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso          ณ Especifico AVANT.                                          บฑฑ
ฑฑศอออออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
WSSERVICE PEDWEBAVANT DESCRIPTION "Integracao de pedidos Web (AVANT)"
	WSDATA 	 EmpIntegra	As String
	WSDATA 	 FilIntegra	As String
	WSDATA 	 Parametro	As String
	WSDATA 	 aRetorno 	As RETINTEGRA
	WSMETHOD CONNECT DESCRIPTION "Integracao de pedidos Web (AVANT)"
ENDWSSERVICE

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบ WSMETHOD ณ CONNECT     บ Autor ณ Amedeo D.P. Filho  บ Data ณ  21/03/12   บฑฑ
ฑฑฬออออออออออุอออออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Metodo de Integracao.                                         บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico AVANT.                                             บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
WSMETHOD CONNECT WSRECEIVE EmpIntegra, FilIntegra, Parametro WSSEND aRetorno WSSERVICE PEDWEBAVANT
	Local lRetorno 		:= .T.
	Local cMensagem		:= ""
	Local cDocumen		:= ""

	ConOut(Time() + " - 01 - Iniciando Integracao")

	If Empty(EmpIntegra) .Or. Empty(FilIntegra) .Or. Empty(Parametro)
		lRetorno	:= .F.
		ConOut(Time() + " - 02 - Parametros faltando")
		::aRetorno 	:= WSClassNew("RETINTEGRA")
		::aRetorno:Mensagem	:= "Algum parametro obrigat๓rio nใo foi enviado, integracao nใo serแ processada"
	EndIf
	
	If lRetorno
		
		ConOut(Time() + " - 02 - Processando Integracao")

		lRetorno := U_INTPEDIDO(EmpIntegra, FilIntegra, Parametro, @cMensagem, @cDocumen, .T.)
		
		::aRetorno 	:= WSClassNew("RETINTEGRA")

		If !lRetorno
			ConOut(Time() + " - 03 - Erro na Integracao " + cMensagem)
			::aRetorno:Mensagem := cMensagem
		Else
			ConOut(Time() + " - 03 - Integracao realizada com sucesso Documento " + cDocumen)
			::aRetorno:Documento := cDocumen
		EndIf			

	Else
		ConOut(Time() + " - 03 - Integracao nao sera realizada ")
	EndIf
	
	ConOut(Time() + " - 04 - Finalizando Integracao")

Return (.T.)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Estrutura de Retorno              		ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
WSSTRUCT RETINTEGRA

	WSDATA Mensagem		As String OPTIONAL
	WSDATA Documento	As String OPTIONAL

ENDWSSTRUCT
