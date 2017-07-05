#INCLUDE "PROTHEUS.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออปฑฑ
ฑฑบPrograma  ณ AltLimite() บ Autor ณ Fernando Nogueira  บ Data ณ29/06/2016บฑฑ
ฑฑฬออออออออออุอออออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออนฑฑ
ฑฑบDescricao ณ Altera limite de credito para clientes inadimplentes       บฑฑ
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
User Function AltLimite(aParam)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณaParam     |  [01]   |  [02]  |
//ณ           | Empresa | Filial |
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Local aTabelas	:= {"SA1", "SE1"}
Local cEmpCons	:= aParam[01]
Local cFilCons	:= aParam[02]
Local cLog		:= ""
Local cFileLog	:= "ALTLIMITE.HTML"
Local cPathLog	:= "\LOGS\"
Local cAliasIna
Local cAliasFoi
Local cAliasCnt
Local lPassou	:= .F.
Local _cMailTo	:= ""
Local _cMailCC	:= ""
Local _cAssunto	:= ""
Local nQtdReg	:= 0

RpcClearEnv()
RPCSetType(3)
RpcSetEnv(cEmpCons, cFilCons, NIL, NIL, "FAT", NIL, aTabelas)

_cMailTo  := GetMv("ES_MAILCRD")
_cMailCC  := GetMv("ES_EMAILTI")
_cAssunto := "["+DtoC(Date())+" "+Time()+"] [AltLimite] Atualiza็ใo de Limite de Cr้dito"

cLog += '<html><font face="Lucida Console"><body>'
cLog += "<hr>"
cLog += "<b> LOG DA ATUALIZACAO DE LIMITE DE CREDITO</b></p>"
cLog += "<hr>"
cLog += " Dados do Ambiente:</p>"
cLog += "<br>"
cLog += " Empresa / Filial...: " + cEmpAnt + "/" + cFilAnt  + "</p>"
cLog += " Nome Empresa.......: " + Capital( AllTrim( GetAdvFVal( "SM0", "M0_NOMECOM", cEmpAnt + cFilAnt, 1, "" ) ) ) + "</p>"
cLog += " Nome Filial........: " + Capital( AllTrim( GetAdvFVal( "SM0", "M0_FILIAL" , cEmpAnt + cFilAnt, 1, "" ) ) ) + "</p>"
cLog += " DataBase...........: " + DtoC( dDataBase )  + "</p>"
cLog += " Data / Hora Inicio.: " + DtoC( Date() )  + " / " + Time()  + "</p>"
cLog += " Environment........: " + GetEnvServer()  + "</p>"
cLog += " StartPath..........: " + GetSrvProfString( "StartPath", "" )  + "</p>"
cLog += " RootPath...........: " + GetSrvProfString( "RootPath" , "" )  + "</p>"
cLog += " Versao.............: " + GetVersao(.T.)  + "</p>"
cLog += " Usuario TOTVS .....: " + __cUserId + " " +  cUserName + "</p>"
cLog += " Computer Name......: " + GetComputerName() + "</p>"

dbSelectArea("SA1")
dbSetOrder(01)
dbGoTop()

cAliasCnt := GetNextAlias()
cAliasIna := GetNextAlias()
cAliasFoi := GetNextAlias()

BeginSQL Alias cAliasCnt
	SELECT COUNT(*) QUANT FROM
	(SELECT E1_CLIENTE+E1_LOJA CLI_LOJA FROM %Table:SE1% SE1
	INNER JOIN %Table:SA1% SA1 ON E1_CLIENTE+E1_LOJA = A1_COD+A1_LOJA AND A1_X_ZLC = 'T' AND SA1.%NotDel%
	WHERE SE1.%NotDel% AND E1_FILIAL = %Exp:xFilial("SE1")% AND E1_SALDO > 0 AND CONVERT(DATETIME,E1_VENCREA)+15 < GETDATE() AND A1_X_MOTRE <> 1
	GROUP BY E1_CLIENTE+E1_LOJA
	UNION
	SELECT A1_COD+A1_LOJA CLI_LOJA FROM %Table:SA1% SA1
	LEFT JOIN %Table:SE1% SE1 ON E1_FILIAL = %Exp:xFilial("SE1")% AND A1_COD+A1_LOJA = E1_CLIENTE+SE1.E1_LOJA AND E1_SALDO > 0 AND CONVERT(DATETIME,E1_VENCREA)+15 < GETDATE() AND SE1.%NotDel%
	WHERE SA1.%NotDel% AND A1_X_ZLC = 'T' AND A1_X_MOTRE = '1' AND SE1.R_E_C_N_O_ IS NULL
	GROUP BY A1_COD+A1_LOJA
	UNION
	SELECT E1_CLIENTE+E1_LOJA CLI_LOJA FROM %Table:SE1% SE1
	INNER JOIN %Table:SA1% SA1 ON E1_CLIENTE+E1_LOJA = A1_COD+A1_LOJA AND A1_X_MOTRE <> 2 AND A1_X_ZLC = 'T' AND SA1.%NotDel%
	INNER JOIN %Table:SE5% SE5 ON E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_CLIENTE+E1_LOJA = E5_FILIAL+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_CLIFOR+E5_LOJA
		AND E5_RECPAG = 'R'
		AND E5_VALOR > 0
		AND E5_HISTOR NOT LIKE 'Juros%'
		AND E5_HISTOR NOT LIKE 'Multa%'
		AND E5_HISTOR NOT LIKE 'Desconto%'
		AND E5_TIPODOC <> 'TR'
		AND E5_TIPO = 'NF'
		AND E5_NATUREZ = '2001'
		AND E5_MOTBX = 'NOR'
		AND SE5.%NotDel%
	WHERE SE1.%NotDel% AND E1_FILIAL = %Exp:xFilial("SE1")% AND CONVERT(DATETIME,E1_VENCREA)+15 < CONVERT(DATETIME,E1_BAIXA) AND E1_SALDO = 0
	GROUP BY E1_CLIENTE+E1_LOJA) CLIENTES
EndSQL

nQtdReg := (cAliasCnt)->QUANT

BeginSQL Alias cAliasIna
	SELECT E1_CLIENTE+E1_LOJA CLI_LOJA FROM %Table:SE1% SE1
	INNER JOIN %Table:SA1% SA1 ON E1_CLIENTE+E1_LOJA = A1_COD+A1_LOJA AND A1_X_ZLC = 'T' AND SA1.%NotDel%
	WHERE SE1.%NotDel% AND E1_FILIAL = %Exp:xFilial("SE1")% AND E1_SALDO > 0 AND CONVERT(DATETIME,E1_VENCREA)+15 < GETDATE() AND A1_X_MOTRE <> 1
	GROUP BY E1_CLIENTE+E1_LOJA
	ORDER BY E1_CLIENTE+E1_LOJA
EndSQL

(cAliasIna)->(DbGoTop())

BeginSQL Alias cAliasFoi
	SELECT A1_COD+A1_LOJA CLI_LOJA FROM %Table:SA1% SA1
	LEFT JOIN %Table:SE1% SE1 ON E1_FILIAL = %Exp:xFilial("SE1")% AND A1_COD+A1_LOJA = E1_CLIENTE+SE1.E1_LOJA AND E1_SALDO > 0 AND CONVERT(DATETIME,E1_VENCREA)+15 < GETDATE() AND SE1.%NotDel%
	WHERE SA1.%NotDel% AND A1_X_ZLC = 'T' AND A1_X_MOTRE = '1' AND SE1.R_E_C_N_O_ IS NULL
	GROUP BY A1_COD+A1_LOJA
	UNION
	SELECT E1_CLIENTE+E1_LOJA CLI_LOJA FROM %Table:SE1% SE1
	INNER JOIN %Table:SA1% SA1 ON E1_CLIENTE+E1_LOJA = A1_COD+A1_LOJA AND A1_X_MOTRE <> 2 AND A1_X_ZLC = 'T' AND SA1.%NotDel%
	INNER JOIN %Table:SE5% SE5 ON E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_CLIENTE+E1_LOJA = E5_FILIAL+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_CLIFOR+E5_LOJA
		AND E5_RECPAG = 'R'
		AND E5_VALOR > 0
		AND E5_HISTOR NOT LIKE 'Juros%'
		AND E5_HISTOR NOT LIKE 'Multa%'
		AND E5_HISTOR NOT LIKE 'Desconto%'
		AND E5_TIPODOC <> 'TR'
		AND E5_TIPO = 'NF'
		AND E5_NATUREZ = '2001'
		AND E5_MOTBX = 'NOR'
		AND SE5.%NotDel%
	WHERE SE1.%NotDel% AND E1_FILIAL = %Exp:xFilial("SE1")% AND CONVERT(DATETIME,E1_VENCREA)+15 < CONVERT(DATETIME,E1_BAIXA) AND E1_SALDO = 0
	GROUP BY E1_CLIENTE+E1_LOJA
	ORDER BY CLI_LOJA
EndSQL

(cAliasFoi)->(DbGoTop())

While !(cAliasIna)->(Eof())
	If SA1->(dbSeek(xFilial("SA1")+(cAliasIna)->CLI_LOJA))

		If !lPassou
			lPassou := .T.
			cLog += "<hr>"
			cLog += " Clientes Alterados para Inadimplentes:" + "</p>"
			cLog += "<br>"
		Endif

		SA1->(RecLock("SA1",.F.))
			SA1->A1_X_LCANT := SA1->A1_LC
			SA1->A1_LC      := 1
			SA1->A1_X_MOTRE := "1"
		SA1->(MsUnlock())
		cLog += " Cliente/Loja......: " + SA1->A1_COD+"/"+SA1->A1_LOJA + " - Nome: " + SA1->A1_NOME + "</p>"
	Endif
	(cAliasIna)->(DbSkip())
End

lPassou	:= .F.

// Fernando Nogueira - Chamado 004947
While !(cAliasFoi)->(Eof())
	If SA1->(dbSeek(xFilial("SA1")+(cAliasFoi)->CLI_LOJA))

		If !lPassou
			lPassou := .T.
			cLog += "<hr>"
			cLog += " Clientes Alterados para Foi Inadimplentes:" + "</p>"
			cLog += "<br>"
		Endif

		SA1->(RecLock("SA1",.F.))
			If SA1->A1_LC <> 1
				SA1->A1_X_LCANT := SA1->A1_LC
				SA1->A1_LC      := 1
			Endif
			SA1->A1_X_MOTRE := "2"
		SA1->(MsUnlock())
		cLog += " Cliente/Loja......: " + SA1->A1_COD+"/"+SA1->A1_LOJA + " - Nome: " + SA1->A1_NOME + "</p>"
	Endif
	(cAliasFoi)->(DbSkip())
End

If nQtdReg > 0
	cLog += "<br>"
	cLog += " Qtd. de Clientes Alterados: " + Transform(nQtdReg,'@E 999999') + "</p>"
Endif

cLog += "<hr>"
cLog += " Data / Hora Final.: " + DtoC( Date() ) + " / " + Time()  + "</p>"
cLog += "<hr>"
cLog += "</body>"
cLog += "</font>"
cLog += "</html>"

If lPassou
	U_MHDEnvMail(_cMailTo, _cMailCC, "", _cAssunto, cLog, "")
Endif

MemoWrite(cPathLog+cFileLog, cLog)

(cAliasIna)->(DbCloseArea())
(cAliasFoi)->(DbCloseArea())
(cAliasCnt)->(DbCloseArea())

RpcClearEnv()

Return
