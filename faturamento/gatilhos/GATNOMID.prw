#Include "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ GatNoMid º Autor ³ Fernando Nogueira  º Data ³ 15/07/2014  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Gatilho do Campo A3_XNOMID                                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Avant                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function GatNoMid()

_aArea     := GetArea()
_nValor    := 0
//_nNoMid   := M->A3_XNOMID
_cCodVend  := M->A3_COD
_dDataFech := GetMV('ES_FECHMKT')

GeraArqTRB()

TRB->(DbSelectArea('TRB'))
TRB->(DbGotop())

While TRB->(!Eof())
	_nValor += TRB->SALDO
	dbSkip()
End

TRB->(DbCloseArea())

//_nValor += _nNoMid

RestArea(_aArea)

Return _nValor

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GeraArqTRBºAutor  ³ Fernando Nogueira  º Data ³ 15/07/2014  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Funcao Auxiliar                                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function GeraArqTRB()

	BeginSql alias 'TRB'

		SELECT VENDEDOR, NOME, CREDITO, DEBITO, SALDO, A3_ACMMKT ACUMULADOR FROM
		(SELECT VENDEDOR, A3_NOME NOME, SUM(CREDITO) CREDITO, SUM(DEBITO) DEBITO, SUM(CREDITO - DEBITO) SALDO FROM
		(SELECT D2_X_VEND VENDEDOR,
			SUM(CASE WHEN D2_X_TPOPE = 'VENDAS' THEN D2_X_CRVEN ELSE 0 END) CREDITO,
			SUM(CASE WHEN D2_X_TPOPE IN ('BONIFICACAO','REMESSA DOACAO') THEN D2_X_CRVEN ELSE 0 END) DEBITO
			FROM %table:SD2% SD2
		WHERE SD2.%notDel% AND D2_FILIAL = %xfilial:SD2% AND D2_X_CRVEN > 0 AND D2_EMISSAO > %exp:DtoS(_dDataFech)%
		GROUP BY D2_X_VEND
		UNION
		SELECT D1_X_VEND VENDEDOR,
			SUM(CASE WHEN D1_X_TPOPE IN ('DVBONIFICACAO','DVDOACAO') THEN D1_X_DBVEN ELSE 0 END) CREDITO,
			SUM(CASE WHEN D1_X_TPOPE = 'DVVENDAS' THEN D1_X_DBVEN ELSE 0 END) DEBITO
			FROM %table:SD1% SD1
		WHERE SD1.%notDel% AND D1_FILIAL = %xfilial:SD1% AND D1_X_DBVEN > 0 AND D1_DTDIGIT > %exp:DtoS(_dDataFech)%
		GROUP BY D1_X_VEND
		UNION
		SELECT ZZM_VEND VENDEDOR,
			SUM(CASE WHEN ZZM_TIPO < '500' THEN ZZM_VALOR ELSE 0 END) CREDITO,
			SUM(CASE WHEN ZZM_TIPO > '500' THEN ZZM_VALOR ELSE 0 END) DEBITO
			FROM ZZM010 ZZM
		WHERE ZZM.%notDel% AND ZZM_FILIAL = %xfilial:ZZM% AND ZZM_EMISS > %exp:DtoS(_dDataFech)%
		GROUP BY ZZM_VEND
		) CRED_DEB
		INNER JOIN %table:SA3% SA3 ON VENDEDOR = A3_COD AND SA3.%notDel%
		GROUP BY VENDEDOR, A3_NOME, A3_ACMMKT) SALDO_BONIFICAO
		INNER JOIN %table:SA3% SA3 ON VENDEDOR = A3_COD AND SA3.%notDel%
		WHERE A3_COD = %exp:_cCodVend%

	EndSql

Return()
