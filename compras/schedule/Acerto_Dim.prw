#INCLUDE "Protheus.CH"
#INCLUDE "TbiConn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออปฑฑ
ฑฑบPrograma  ณ Acerto_Dim   บ Autor ณ Fernando Nogueira  บ Data ณ 05/11/2014 บฑฑ
ฑฑฬออออออออออุออออออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออนฑฑ
ฑฑบDescricao ณ Acerta as dimensoes no Complemento do Produto                 บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico Avant                                              บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function Acerto_Dim()

Local cAliasTRB  := GetNextAlias()

BeginSql alias cAliasTRB

SELECT B1_COD,
	   ROUND(B1_X_ALT2/POWER(B1_CONV,1/3.0),6,1) ALT_CALC,
	   ROUND(B1_X_LAR2/POWER(B1_CONV,1/3.0),6,1) LARG_CALC,
	   ROUND(B1_X_COM2/POWER(B1_CONV,1/3.0),6,1) COMP_CALC
	   FROM %table:SB1% SB1
INNER JOIN %table:SB5% SB5 ON B1_COD = B5_COD AND B5_FILIAL = %xfilial:SB5% AND SB5.%notDel%
WHERE SB1.%notDel%
	AND B1_LOCALIZ = 'S'
	AND B1_TIPO IN ('PA','PR')
	AND B1_POSIPI <> '99999999'
	AND B1_CONV <> 0
	AND B1_X_COM2 <> 0
	AND B1_X_LAR2 <> 0
	AND B1_X_ALT2 <> 0
	AND (B5_ALTURA   <> ROUND(B1_X_ALT2/POWER(B1_CONV,1/3.0),6,1)
		 OR B5_LARG  <> ROUND(B1_X_LAR2/POWER(B1_CONV,1/3.0),6,1)
		 OR B5_COMPR <> ROUND(B1_X_COM2/POWER(B1_CONV,1/3.0),6,1))

EndSql

(cAliasTRB)->(dbGoTop())

ConOut(GetLastQuery()[2])

While (cAliasTRB)->(!Eof())

	dbSelectArea("SB5")
	dbSetOrder(1)
	dbSeek(xFilial("SB5")+(cAliasTRB)->B1_COD)

	Reclock("SB5",.F.)
	B5_ALTURA := (cAliasTRB)->ALT_CALC
	B5_LARG   := (cAliasTRB)->LARG_CALC
	B5_COMPR  := (cAliasTRB)->COMP_CALC
	MsUnlock()

	(cAliasTRB)->(dbSkip())

End

(cAliasTRB)->(dbCloseArea())

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAc_Dim_Schedบ Autor ณ Fernando Nogueira  บ Data ณ 05/11/2014  บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณExecutar o acerto de dimensoes via Schedule                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function Ac_Dim_Sched(aParam)

PREPARE ENVIRONMENT EMPRESA aParam[1] FILIAL aParam[2]

U_Acerto_Dim()

RESET ENVIRONMENT

Return
