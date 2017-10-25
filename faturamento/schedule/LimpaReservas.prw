#include "PROTHEUS.CH"
#INCLUDE "TbiConn.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ LimpaReservas º Autor ³ Fernando Nogueira º Data ³25/10/2017º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Limpa reservas pendentes                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico AVANT.                   	                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÏÍÍÍÑÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAnalista Resp.³  Data  ³ Manutencao Efetuada                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º              ³  /  /  ³                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function LimpaReservas(aParam)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³aParam     |  [01]    |  [02]   |  [03]  |
//³           | Schedule | Empresa | Filial |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
// Exexutar no Formulas -> U_LimpaReservas({.F.})
// Exexutar no Schedule -> U_LimpaReservas(.T.)

Local cAliasSC0 := GetNextAlias()

Private _lSchedule := .F.

If !Empty(aParam)
	_lSchedule := aParam[1]
Endif

// Caso seja disparado via workflow
If _lSchedule
	PREPARE ENVIRONMENT EMPRESA aParam[2] FILIAL aParam[3]
Endif

SET CENTURY ON

ConOut("["+DtoC(Date())+" "+Time()+"] [LimpaReservas] Inicio")

dbSelectArea("SC0")
dbSetOrder(01)

// Query para trazer as reservas pendentes
BeginSql alias cAliasSC0
		SELECT SC0.R_E_C_N_O_ SC0RECNO FROM %table:SC0% SC0
		INNER JOIN %table:SB1% SB1 ON B1_COD = C0_PRODUTO AND SB1.%notDel%
		INNER JOIN %table:SC6% SC6 ON C0_FILIAL = C6_FILIAL AND C0_DOCRES = C6_NUM AND C0_NUM = C6_RESERVA AND SC6.%notDel%
		WHERE SC0.%notDel% AND C0_FILIAL = %xfilial:SC0% AND C0_QUANT > 0 AND C0_DOCRES <> '' AND C0_SOLICIT = '' AND C6_QTDVEN = C6_QTDENT
		UNION
		SELECT SC0.R_E_C_N_O_ SC0RECNO FROM %table:SC0% SC0
		INNER JOIN %table:SB1% SB1 ON B1_COD = C0_PRODUTO AND SB1.%notDel%
		LEFT JOIN %table:SC6% SC6 ON C0_FILIAL = C6_FILIAL AND C0_DOCRES = C6_NUM AND C0_NUM = C6_RESERVA AND SC6.%notDel%
		WHERE SC0.%notDel% AND C0_FILIAL = %xfilial:SC0% AND C0_QUANT > 0 AND C0_DOCRES <> '' AND C0_SOLICIT = '' AND C6_NUM IS NULL
		ORDER BY SC0RECNO
EndSql

(cAliasSC0)->(dbGoTop())

// Excluir reservas Pendentes
While (cAliasSC0)->(!Eof())
	SC0->(dbGoTo((cAliasSC0)->SC0RECNO))
	
	a430Reserva({3,SC0->C0_TIPO,SC0->C0_DOCRES,SC0->C0_SOLICIT,SC0->C0_FILRES},;
		SC0->C0_NUM,;
		SC0->C0_PRODUTO,;
		SC0->C0_LOCAL,;
		SC0->C0_QUANT,;
		{SC0->C0_NUMLOTE,;
		SC0->C0_LOTECTL,;
		SC0->C0_LOCALIZ,;
		SC0->C0_NUMSERI})

	(cAliasSC0)->(dbSkip())
End

(cAliasSC0)->(dbCloseArea())

ConOut("["+DtoC(Date())+" "+Time()+"] [LimpaReservas] Fim")

// Caso seja disparado via workflow
If _lSchedule
	RESET ENVIRONMENT
Endif

Return