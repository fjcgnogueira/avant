#Include "PROTHEUS.CH"
#Include "TOPCONN.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ F200VAR  บ Autor ณ Fernando Nogueira  บ Data ณ 05/12/2014  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Ponto de Entrada do Arquivo de Retorno do CNAB             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico Avant                                           บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function F200VAR()

/*
ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
ณ   	 Posicoes do Array        ณ
ร---------------------------------ด
ณ [01] - Numero do titulo         ณ <<<<
ณ [02] - Data da Baixa            ณ
ณ [03] - Tipo do Titulo           ณ
ณ [04] - Nosso Numero             ณ
ณ [05] - Valor da Despesa         ณ
ณ [06] - Valor do Desconto        ณ 
ณ [07] - Valor do Abatimento      ณ
ณ [08] - Valor Recebido           ณ
ณ [09] - Juros                    ณ
ณ [10] - Multa                    ณ
ณ [11] - Outras Despesas          ณ
ณ [12] - Valor do Credito         ณ
ณ [13] - Data do Credito          ณ
ณ [14] - Ocorrencia               ณ <<<<
ณ [15] - Motivo da Baixa      	  ณ
ณ [16] - Linha Inteira            ณ <<<<
ณ [17] - Data de Vencimento       ณ
ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
*/    

Local aAreaSE1  := SE1->(GetArea())
Local aValores	:= ParamIXB[01]
Local cOcorCnab := aValores[14]
Local cCartBanc	:= Substr(aValores[16],58,01)
Local cNumTit	:= AllTrim(Substr(aValores[16],059,15))
Local cIdCnab   := AllTrim(aValores[01])

// Posiciona na Amarracao Cart. Banco x Cart. Sistema
SZF->(dbSelectArea("SZF"))
SZF->(dbSetOrder(01))
SZF->(dbGoTop())

If SZF->(dbSeek(xFilial("SZF")+cBanco+cCartBanc))
	SE1->(dbSelectArea("SE1"))
	SE1->(dbSetOrder(19))      //IDCNAB
	SE1->(dbGoTop())
 
	If !Empty(cIdCnab) .And. SE1->(dbSeek(cIdCnab)) .And. SE1->E1_SITUACA <> SZF->ZF_CRTSIST
		SE1->(RecLock("SE1",.F.))
		SE1->E1_SITUACA := SZF->ZF_CRTSIST
		SE1->(MsUnLock())
	Else
		SE1->(dbSetOrder(01))      //Numero do Titulo
		SE1->(dbGoTop())
		
		If !Empty(cIdCnab) .And. SE1->(dbSeek(xFilial("SE1")+cNumTit)) .And. SE1->E1_SITUACA <> SZF->ZF_CRTSIST
			SE1->(RecLock("SE1",.F.))
			SE1->E1_SITUACA := SZF->ZF_CRTSIST
			SE1->(MsUnLock())
		Endif
	Endif
Endif

SE1->(RestArea(aAreaSE1))

Return