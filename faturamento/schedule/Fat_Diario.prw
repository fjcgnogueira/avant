#INCLUDE "PROTHEUS.CH"
#INCLUDE "Totvs.ch"
#INCLUDE "FILEIO.ch"
#INCLUDE "TbiConn.ch"
#INCLUDE "AP5MAIL.CH"
#include "tbicode.ch"
#include "font.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ Fat_Diario() º Autor ³ Fernando Nogueira º Data ³ 09/01/14 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Faturamento Diario                                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Avant                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function Fat_Diario(aParam)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³aParam     |  [01]  | [02]  |  [03]   |   [04]   |  [05]  |  [06] |  [07]    |  [08]   |  [09]  |
	//³           | REGIAO | GRUPO | Data De | Data Ate | E-mail |   CC  | Schedule | Empresa | Filial |
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	/*
	ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	³ Exemplos de Relatorios:                                                              |
	ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
	³ U_Fat_Diario({'GERAL','','DIARIO','','','',''})                                      |
	³ U_Fat_Diario({'CO','','DIARIO','','','',.F.})                                        |
	³ U_Fat_Diario({'VENDEDORES','','DIARIO','','','',.F.})                                |
	³ U_Fat_Diario({'','','DIARIO','','','',.F.})                                          ³
	³ U_Fat_Diario({'GERAL','A070','20140110','20140120','','',.F.})                       |
	³ U_Fat_Diario({'NO','',Date()-7,Date(),'','',''})                                     |
	³ U_Fat_Diario({'CO','','ACUMULADO','','','',''})                                      |
	³ U_Fat_Diario({'CO','A070','ACUMULADO','','fernando.nogueira@avantlux.com.br','',''}) |
	³ U_Fat_Diario({'DIRETORIA','A070','20140110','20140120','',.F.})                      |
	ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	*/

	Local _oProcess := Nil
	Local lEnd      := .F.

	Private _lReturn    := .T.
	Private _cFilial    := ""
	Private _cGrupo     := aParam[2]
	Private _cDataDe    := ""
	Private _cDataAte   := Date()
	Private _cTitulo    := "Faturamento Diario"
	Private _cEmail     := aParam[5]
	Private _cEmailCC   := aParam[6]
	Private _lSchedule  := aParam[7]
	Private lAcumulado  := If(ValType(aParam[3]) == "C",aParam[3] == "ACUMULADO",.F.)

	// Padrao do Schedule eh Falso
	If Empty(_lSchedule)
		_lSchedule := .F.
	Endif

	// Caso seja disparado via workflow
	If _lSchedule
		PREPARE ENVIRONMENT EMPRESA aParam[8] FILIAL aParam[9]
		_cFilial := aParam[9]
	Else
		_cFilial := AllTrim(SM0->M0_CODFIL)
	Endif


	Private _cRegionais := AllTrim(GetMv("ES_REGIONA"))

	If Empty(aParam[3])
		_lReturn := .F.
		If _lSchedule
			Conout("Parâmetro 3 é Obrigatório!")
		Else
			MsgInfo("Parâmetro 3 é Obrigatório!")
		Endif
	ElseIf ValType(aParam[3]) == "C" .And. aParam[3] == "DIARIO"
		Private _cDataDe  := Date()
		Private _cDataAte := Date()
	ElseIf ValType(aParam[3]) == "C" .And. aParam[3] == "ACUMULADO"
		dbSelectArea("ZZP")
		dbSetOrder(2)
		If ZZP->(dbSeek(xFilial("ZZP")+StrZero(Year(Date()),4)+StrZero(Month(Date()),2)))
			If ZZP->ZZP_DATADE > Date()
				If !ZZP->(dbSeek(xFilial("ZZP")+StrZero(Year(Date()),4)+StrZero(Month(Date()-28),2)))
					_lReturn := .F.
				Endif
			Endif
			If _lReturn
				_cDataDe  := ZZP->ZZP_DATADE
				_cDataAte := ZZP->ZZP_DATATE
				_cTitulo := "Faturamento Acumulado"
			Endif
		Else
			_lReturn := .F.
		Endif
		If !_lReturn
			If _lSchedule
				Conout("Programação não cadastrada!")
			Else
				MsgInfo("Programação não cadastrada!")
			Endif
		Endif
	ElseIf !Empty(aParam[3]) .And. !Empty(aParam[4])
		If ValType(aParam[3]) == "D"
			_cDataDe  := aParam[3]
			_cDataAte := aParam[4]
		Else
			_cDataDe  := STOD(aParam[3])
			_cDataAte := STOD(aParam[4])
		Endif
		_cTitulo := "Faturamento Acumulado"
	EndIf

	_cRegiao := AllTrim(aParam[1])

	If Empty(_cRegiao)
		While !Empty(_cRegionais)
			If At(";",_cRegionais) > 0
				_cRegiao    := Substring(_cRegionais,1,At(";",_cRegionais)-1)
				_cRegionais := Substring(_cRegionais,Len(_cRegiao)+2,Len(_cRegionais)-Len(_cRegiao)-1)
			Else
				_cRegiao    := _cRegionais
				_cRegionais := ""
				_lReturn := .F.
			Endif
			If _lSchedule
				GeraArqTRB()
				EnviaEmail(lEnd,_oProcess)
			Else
				LjMsgRun("Montando massa de dados temporaria ...",,{|| CursorWait(),GeraArqTRB(),CursorArrow()})
				_oProcess := MsNewProcess():New({|lEnd| EnviaEmail(lEnd,_oProcess)},"Processando...","Processando e-mail...",.T.)
				_oProcess:Activate()
			Endif
		End
	Endif

	If _lReturn	.And. !Empty(_cRegiao) .And. !Empty(_cRegionais)
		If _lSchedule
			GeraArqTRB()
			EnviaEmail(lEnd,_oProcess)
		Else
			LjMsgRun("Montando massa de dados temporaria ...",,{|| CursorWait(),GeraArqTRB(),CursorArrow()})
			_oProcess := MsNewProcess():New({|lEnd| EnviaEmail(lEnd,_oProcess)},"Processando...","Processando e-mail...",.T.)
			_oProcess:Activate()
		Endif
	Endif

Return _lReturn

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GeraArqTRBºAutor  ³ Fernando Nogueira  º Data ³ 09/01/2014  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Funcao Auxiliar                                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function GeraArqTRB()

	Local cField1 := "%%"
	Local cField2 := "%%"
	Local cGroup1 := "%%"
	Local cGroup2 := "%%"
	Local cGroup3 := "%%"
	Local cOrder1 := "%%"
	Local cOrder2 := "%%"
	Local cWhere  := "%%"
	Local cInner1 := "%%"
	Local cInner2 := "%%"

	// Campos
	If _cRegiao $ "DIRETORIA.GERAL"
		cField1 := "%F2_REGIAO REGIAO,%"
		If Empty(_cGrupo)
			cField2 := "%BM_DESC GRUPO%"
		Else
			cField2 := "%B1_DESC PRODUTO%"
		Endif
	ElseIf Empty(_cGrupo)
		cField1 := "%C5_VEND1 VENDEDOR,BM_DESC GRUPO,TOTAL_REAIS,TOTAL_QTD,%"
		cField2 := "%BM_DESC GRUPO%"
	Else
		cField1 := "%C5_VEND1 VENDEDOR,B1_DESC PRODUTO,TOTAL_REAIS,TOTAL_QTD,%"
		cField2 := "%B1_DESC PRODUTO%"
	EndIf

	// Condicoes
	If !Empty(_cGrupo) .And. _cRegiao $ AllTrim(GetMv("ES_REGIONA"))
		cWhere := "% AND B1_GRUPO = '"+AllTrim(_cGrupo)+"' AND F2_REGIAO = '"+_cRegiao+"'%"
	ElseIf !Empty(_cGrupo)
		cWhere := "% AND B1_GRUPO = '"+AllTrim(_cGrupo)+"'%"
	ElseIf _cRegiao $ AllTrim(GetMv("ES_REGIONA"))
		cWhere := "% AND F2_REGIAO = '"+_cRegiao+"'%"
	EndIf

	If _cRegiao <> "DIRETORIA"
		cInner1 := "% AND F2_REGIAO <> 'ESP' %"
	Endif

	// Agrupamentos e Ordens
	If _cRegiao $ "DIRETORIA.GERAL"
		cGroup1 := "%D2_FILIAL,F2_REGIAO%"
		cOrder1 := "%FILIAL,REAIS DESC,REGIAO%"
		If Empty(_cGrupo)
			cGroup2 := "%D2_FILIAL,BM_DESC%"
			cOrder2 := "%FILIAL,REAIS DESC,GRUPO%"
		Else
			cGroup2 := "%D2_FILIAL,B1_DESC%"
			cOrder2 := "%FILIAL,REAIS DESC,PRODUTO%"
		Endif
	ElseIf Empty(_cGrupo)
		cGroup1 := "%D2_FILIAL,TOTAL_REAIS,TOTAL_QTD,C5_VEND1,BM_DESC%"
		cGroup2 := "%D2_FILIAL,TOTAL_REAIS,TOTAL_QTD,BM_DESC,C5_VEND1%"
		cGroup3 := "%BM_DESC%"
		cOrder1 := "%FILIAL,TOTAL_REAIS DESC,C5_VEND1,REAIS DESC%"
		cOrder2 := "%FILIAL,TOTAL_REAIS DESC,BM_DESC,REAIS DESC%"
		cInner2 := "%BM_DESC = GRUPO%"
	Else
		cGroup1 := "%D2_FILIAL,TOTAL_REAIS,TOTAL_QTD,C5_VEND1,B1_DESC%"
		cGroup2 := "%D2_FILIAL,TOTAL_REAIS,TOTAL_QTD,B1_DESC,C5_VEND1%"
		cGroup3 := "%B1_DESC%"
		cOrder1 := "%FILIAL,TOTAL_REAIS DESC,C5_VEND1,REAIS DESC%"
		cOrder2 := "%FILIAL,TOTAL_REAIS DESC,B1_DESC,REAIS DESC%"
		cInner2 := "%B1_DESC = PRODUTO%"
	End


	If _cRegiao $ "DIRETORIA.GERAL"

		// Por REGIAO
		BeginSql alias 'TRB'

			SELECT D2_FILIAL FILIAL,
				%Exp:cField1%
				SUM(D2_QUANT) QTD,
				SUM(D2_TOTAL) REAIS
			FROM %table:SD2% SD2
			INNER JOIN %table:SF4% SF4 ON D2_FILIAL = F4_FILIAL AND D2_TES = F4_CODIGO AND SF4.%notDel%
			INNER JOIN %table:SC6% SC6 ON D2_FILIAL = C6_FILIAL AND D2_PEDIDO = C6_NUM AND D2_ITEMPV = C6_ITEM AND SC6.%notDel%
			INNER JOIN %table:SC5% SC5 ON D2_FILIAL = C5_FILIAL AND D2_PEDIDO = C5_NUM AND SC5.%notDel%
			INNER JOIN %table:SF2% SF2 ON D2_FILIAL = F2_FILIAL AND D2_DOC = F2_DOC AND D2_CLIENTE = F2_CLIENTE AND D2_LOJA = F2_LOJA %Exp:cInner1% AND SF2.%notDel%
			INNER JOIN %table:SB1% SB1 ON D2_COD = B1_COD AND SB1.%notDel% %Exp:cWhere%
			INNER JOIN %table:SBM% SBM ON D2_FILIAL = BM_FILIAL AND B1_GRUPO = BM_GRUPO AND SBM.%notDel%
			WHERE F4_DUPLIC = 'S'
				AND D2_EMISSAO BETWEEN %Exp:DTOS(_cDataDe)% AND %Exp:DTOS(_cDataAte)% AND D2_TIPO = 'N'
				AND D2_TIPO = 'N'
				AND D2_FILIAL = %Exp:_cFilial%
				AND SD2.%notDel%
			GROUP BY %Exp:cGroup1%
			ORDER BY %Exp:cOrder1%

		EndSql

		//ConOut(GetLastQuery()[2])

		// Por GRUPO de PRODUTO / PRODUTO
		BeginSql alias 'TRC'

			SELECT CASE WHEN D2_FILIAL IS NULL THEN %Exp:_cFilial% ELSE D2_FILIAL END FILIAL,
				SUM(CASE WHEN D2_QUANT IS NULL THEN 0 ELSE D2_QUANT END) QTD,
				SUM(CASE WHEN D2_TOTAL IS NULL THEN 0 ELSE D2_TOTAL END) REAIS,
				%Exp:cField2%
			FROM %table:SD2% SD2
			INNER JOIN %table:SF4% SF4 ON D2_FILIAL = F4_FILIAL AND D2_TES = F4_CODIGO AND F4_DUPLIC = 'S' AND D2_EMISSAO BETWEEN %Exp:DTOS(_cDataDe)% AND %Exp:DTOS(_cDataAte)% AND D2_TIPO = 'N' AND D2_FILIAL = %Exp:_cFilial% AND D2_TIPO = 'N' AND SD2.%notDel% AND SF4.%notDel%
			INNER JOIN %table:SC6% SC6 ON D2_FILIAL = C6_FILIAL AND D2_PEDIDO = C6_NUM AND D2_ITEMPV = C6_ITEM AND SC6.%notDel%
			INNER JOIN %table:SC5% SC5 ON D2_FILIAL = C5_FILIAL AND D2_PEDIDO = C5_NUM AND SC5.%notDel%
			INNER JOIN %table:SF2% SF2 ON D2_FILIAL = F2_FILIAL AND D2_DOC = F2_DOC AND D2_CLIENTE = F2_CLIENTE AND D2_LOJA = F2_LOJA %Exp:cInner1% AND SF2.%notDel%
			INNER JOIN %table:SB1% SB1 ON D2_COD = B1_COD AND SB1.%notDel% %Exp:cWhere%
			RIGHT JOIN %table:SBM% SBM ON B1_GRUPO = BM_GRUPO
			WHERE BM_FILIAL = %Exp:_cFilial% AND SBM.%notDel%
			GROUP BY %Exp:cGroup2%
			ORDER BY %Exp:cOrder2%

		EndSql

	Else

		// Total por Canal Alimentar
		BeginSql alias 'TRA'

			SELECT SUM(D2_TOTAL) TOTAL FROM SD2010 SD2
			INNER JOIN  %table:SF4% SF4 ON D2_FILIAL = F4_FILIAL AND D2_TES = F4_CODIGO AND SF4.%notDel%
			INNER JOIN  %table:SC6% SC6 ON D2_FILIAL = C6_FILIAL AND D2_PEDIDO = C6_NUM AND D2_ITEMPV = C6_ITEM AND SC6.%notDel%
			INNER JOIN  %table:SC5% SC5 ON D2_FILIAL = C5_FILIAL AND D2_PEDIDO = C5_NUM AND SC5.%notDel%
			INNER JOIN  %table:SF2% SF2 ON D2_FILIAL = F2_FILIAL AND D2_DOC = F2_DOC AND D2_CLIENTE = F2_CLIENTE AND D2_LOJA = F2_LOJA AND SF2.%notDel%
			WHERE D2_EMISSAO BETWEEN %Exp:DTOS(_cDataDe)% AND %Exp:DTOS(_cDataAte)% AND D2_TIPO = 'N'
				AND SD2.%notDel% AND D2_FILIAL = %Exp:_cFilial% AND F4_DUPLIC = 'S' AND F2_X_CANAL = 'CN0002'
				%Exp:cWhere%

		EndSql

		// Por VENDEDOR
		BeginSql alias 'TRB'

			SELECT D2_FILIAL FILIAL,
				%Exp:cField1%
				SUM(D2_QUANT) QTD, SUM(D2_TOTAL) REAIS
			FROM %table:SD2% SD2
			INNER JOIN %table:SF4% SF4 ON D2_FILIAL = F4_FILIAL AND D2_TES = F4_CODIGO AND SF4.%notDel%
			INNER JOIN %table:SC6% SC6 ON D2_FILIAL = C6_FILIAL AND D2_PEDIDO = C6_NUM AND D2_ITEMPV = C6_ITEM AND SC6.%notDel%
			INNER JOIN %table:SC5% SC5 ON D2_FILIAL = C5_FILIAL AND D2_PEDIDO = C5_NUM AND SC5.%notDel%
			INNER JOIN %table:SF2% SF2 ON D2_FILIAL = F2_FILIAL AND D2_DOC = F2_DOC AND D2_CLIENTE = F2_CLIENTE AND D2_LOJA = F2_LOJA %Exp:cInner1% AND SF2.%notDel%
			INNER JOIN %table:SB1% SB1 ON D2_COD = B1_COD AND SB1.%notDel%
			INNER JOIN %table:SBM% SBM ON D2_FILIAL = BM_FILIAL AND B1_GRUPO = BM_GRUPO AND SBM.%notDel%
			INNER JOIN
				(SELECT D2_FILIAL FILIAL, C5_VEND1 VENDEDOR, SUM(D2_QUANT) TOTAL_QTD, SUM(D2_TOTAL) TOTAL_REAIS FROM %table:SD2% SD2
					INNER JOIN %table:SF4% SF4 ON D2_FILIAL = F4_FILIAL AND D2_TES = F4_CODIGO AND SF4.%notDel%
					INNER JOIN %table:SC6% SC6 ON D2_FILIAL = C6_FILIAL AND D2_PEDIDO = C6_NUM AND D2_ITEMPV = C6_ITEM AND SC6.%notDel%
					INNER JOIN %table:SC5% SC5 ON D2_FILIAL = C5_FILIAL AND D2_PEDIDO = C5_NUM AND SC5.%notDel%
					INNER JOIN %table:SF2% SF2 ON D2_FILIAL = F2_FILIAL AND D2_DOC = F2_DOC AND D2_CLIENTE = F2_CLIENTE AND D2_LOJA = F2_LOJA %Exp:cInner1% AND SF2.%notDel%
					INNER JOIN %table:SB1% SB1 ON D2_COD = B1_COD AND SB1.%notDel%
					INNER JOIN %table:SBM% SBM ON D2_FILIAL = BM_FILIAL AND B1_GRUPO = BM_GRUPO AND SBM.%notDel%
				WHERE D2_EMISSAO BETWEEN %Exp:DTOS(_cDataDe)% AND %Exp:DTOS(_cDataAte)% AND D2_TIPO = 'N'
					AND SD2.%notDel%
					AND F4_DUPLIC = 'S'
					%Exp:cWhere%
				GROUP BY D2_FILIAL,C5_VEND1) TOT_VEND ON D2_FILIAL = FILIAL AND C5_VEND1 = VENDEDOR
			WHERE D2_EMISSAO BETWEEN %Exp:DTOS(_cDataDe)% AND %Exp:DTOS(_cDataAte)% AND D2_TIPO = 'N'
				AND SD2.%notDel%
				AND D2_FILIAL = %Exp:_cFilial%
				AND F4_DUPLIC = 'S'
				%Exp:cWhere%
			GROUP BY %Exp:cGroup1%
			ORDER BY %Exp:cOrder1%

		EndSql

		ConOut(GetLastQuery()[2])

		// Por GRUPO de PRODUTO	/ PRODUTO
		BeginSql alias 'TRC'

			SELECT CASE WHEN D2_FILIAL IS NULL THEN %Exp:_cFilial% ELSE D2_FILIAL END FILIAL,
				%Exp:cField1%
				SUM(CASE WHEN D2_QUANT IS NULL THEN 0 ELSE D2_QUANT END) QTD,
				SUM(CASE WHEN D2_TOTAL IS NULL THEN 0 ELSE D2_TOTAL END) REAIS
			FROM %table:SD2% SD2
			INNER JOIN %table:SF4% SF4 ON D2_FILIAL = F4_FILIAL AND D2_TES = F4_CODIGO AND F4_DUPLIC = 'S' AND D2_EMISSAO BETWEEN %Exp:DTOS(_cDataDe)% AND %Exp:DTOS(_cDataAte)% AND D2_FILIAL = %Exp:_cFilial% AND D2_TIPO = 'N' AND SD2.%notDel% AND SF4.%notDel%
			INNER JOIN %table:SC6% SC6 ON D2_FILIAL = C6_FILIAL AND D2_PEDIDO = C6_NUM AND D2_ITEMPV = C6_ITEM AND SC6.%notDel%
			INNER JOIN %table:SC5% SC5 ON D2_FILIAL = C5_FILIAL AND D2_PEDIDO = C5_NUM AND SC5.%notDel%
			INNER JOIN %table:SF2% SF2 ON D2_FILIAL = F2_FILIAL AND D2_DOC = F2_DOC AND D2_CLIENTE = F2_CLIENTE AND D2_LOJA = F2_LOJA %Exp:cInner1% AND SF2.%notDel%
			INNER JOIN %table:SB1% SB1 ON D2_COD = B1_COD AND SB1.%notDel% %Exp:cWhere%
			RIGHT JOIN %table:SBM% SBM ON B1_GRUPO = BM_GRUPO
			INNER JOIN
				(SELECT CASE WHEN D2_FILIAL IS NULL THEN %Exp:_cFilial% ELSE D2_FILIAL END FILIAL,
					SUM(CASE WHEN D2_QUANT IS NULL THEN 0 ELSE D2_QUANT END) TOTAL_QTD,
					SUM(CASE WHEN D2_TOTAL IS NULL THEN 0 ELSE D2_TOTAL END) TOTAL_REAIS,
					%Exp:cField2%
					FROM %table:SD2% SD2
					INNER JOIN %table:SF4% SF4 ON D2_FILIAL = F4_FILIAL AND D2_TES = F4_CODIGO AND F4_DUPLIC = 'S' AND D2_EMISSAO BETWEEN %Exp:DTOS(_cDataDe)% AND %Exp:DTOS(_cDataAte)% AND D2_TIPO = 'N' AND D2_FILIAL = %Exp:_cFilial% AND SD2.%notDel% AND SF4.%notDel%
					INNER JOIN %table:SC6% SC6 ON D2_FILIAL = C6_FILIAL AND D2_PEDIDO = C6_NUM AND D2_ITEMPV = C6_ITEM AND SC6.%notDel%
					INNER JOIN %table:SC5% SC5 ON D2_FILIAL = C5_FILIAL AND D2_PEDIDO = C5_NUM AND SC5.%notDel%
					INNER JOIN %table:SF2% SF2 ON D2_FILIAL = F2_FILIAL AND D2_DOC = F2_DOC AND D2_CLIENTE = F2_CLIENTE AND D2_LOJA = F2_LOJA %Exp:cInner1% AND SF2.%notDel%
					INNER JOIN %table:SB1% SB1 ON D2_COD = B1_COD AND SB1.%notDel% %Exp:cWhere%
					RIGHT JOIN %table:SBM% SBM ON B1_GRUPO = BM_GRUPO
				WHERE BM_FILIAL = %Exp:_cFilial% AND SBM.%notDel%
				GROUP BY D2_FILIAL,%Exp:cGroup3%) TOT_VEND ON FILIAL = %Exp:_cFilial% AND %Exp:cInner2%
			WHERE BM_FILIAL = %Exp:_cFilial% AND SBM.%notDel%
			GROUP BY %Exp:cGroup2%
			ORDER BY %Exp:cOrder2%

		EndSql

	Endif

	ConOut("Ponto de Parada para GETLASTQUERY()[2]")

Return()

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ DispNFE   ³ Autor ³ Fernando Nogueira  ³ Data  ³ 06/01/14 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Dispara e-mail na baixa da Pre-requisicao.                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function EnviaEmail(lEnd,_oProcess)

Local _cMailTo    := ""
Local _cSubject   := ""
Local _cNReduz    := ""
Local _cD2Total   := PesqPict("SD2","D2_TOTAL")
Local _cPctQtd    := "@e 999,999,999"
Local _nTotQtd    := 0
Local _nTotReal   := 0
Local _nQtdVend   := 0
Local _nTotVend   := 0
Local _cVend      := ""
Local _TabTRB     := CriaTrab(Nil,.F.)
Local _IndTRB     := CriaTrab(Nil,.F.)
Local _cString    := GetMv("ES_GERENRE")
Local _cRegionais := GetMv("ES_REGIONA")
Local _cArquivo   := ""

DbSelectArea('TRC')
DbGotop()
Count To nReguaC
DbGotop()

DbSelectArea('TRB')
DbGotop()
Count To nReguaB
DbGotop()

If !_lSchedule
	_oProcess:SetRegua1(nReguaB)
Endif

If _cRegiao $ "DIRETORIA.GERAL"
	_cArquivo := "\MODELOS\FAT_DIARIO_DIR.HTM"
ElseIf _cRegiao $ "VENDEDORES"
	_cArquivo := "\MODELOS\FAT_DIARIO_VND.HTM"
Else
	_cArquivo := "\MODELOS\FAT_DIARIO_GER.HTM"
Endif

If _cRegiao <> 'VENDEDORES'
	oProcess := TWFProcess():New("FAT_DIARIO","FATURAMENTO DIARIO")
	oProcess:NewTask("Gerando Relatorio",_cArquivo)
	oHTML := oProcess:oHTML
Endif

If TRB->(!Eof())
	If _cRegiao <> 'VENDEDORES'
		oHtml:ValByName("cTitulo", Upper(_cTitulo))
		If _cDataDe == Date() .And. _cDataAte = Date()
			oHtml:ValByName("cDataDe", DtoC(Date()))
		Else
			oHtml:ValByName("cDataDe",  DtoC(_cDataDe))
			oHtml:ValByName("cDataAte", DtoC(_cDataAte))
		Endif
		oHtml:ValByName("cHora"    , Substr(Time(),1,5))
		oHtml:ValByName("cFilial"  , SM0->M0_FILIAL)
		oHtml:ValByName("cRegional", _cRegiao)
	EndIf

	If _cRegiao $ "DIRETORIA.GERAL"

		// Por REGIAO
		While TRB->(!Eof())
			_nTotQtd  += TRB->QTD
			_nTotReal += TRB->REAIS
			TRB->(dbSkip())
			If !_lSchedule
				_oProcess:IncRegua1()
			Endif
		EndDo

		DbSelectArea('TRB')
		DbGotop()

		While TRB->(!Eof())
			aAdd((oHTML:ValByName("aReg.cREGIAO"))   , TRB->REGIAO)
			aAdd((oHTML:ValByName("aReg.cQuant"))    , Transform(TRB->QTD                , _cPctQtd ))
			aAdd((oHTML:ValByName("aReg.cQuantPorc")), Transform(TRB->QTD/_nTotQtd*100   , _cD2Total)+'%')
			aAdd((oHTML:ValByName("aReg.cValor"))    , Transform(TRB->REAIS              , _cD2Total))
			aAdd((oHTML:ValByName("aReg.cValorPorc")), Transform(TRB->REAIS/_nTotReal*100, _cD2Total)+'%')
			TRB->(dbSkip())
			If !_lSchedule
				_oProcess:IncRegua1()
			Endif
		EndDo

		aAdd((oHTML:ValByName("aReg.cREGIAO"))   , "TOTAL:")
		aAdd((oHTML:ValByName("aReg.cQuant"))    , Transform(_nTotQtd, _cPctQtd))
		aAdd((oHTML:ValByName("aReg.cQuantPorc")), "100,00%")
		aAdd((oHTML:ValByName("aReg.cValor"))    , Transform(_nTotReal, _cD2Total))
		aAdd((oHTML:ValByName("aReg.cValorPorc")), "100,00%")

		// Por GRUPO de PRODUTO / PRODUTO
		oHtml:ValByName("cTitGrpPrd", If(Empty(_cGrupo),"Total por GRUPO de PRODUTO","Total por PRODUTO"))
		oHtml:ValByName("cGrpPrd"   , If(Empty(_cGrupo),"GRUPO","PRODUTO"))

		DbSelectArea('TRC')
		DbGotop()

		While TRC->(!Eof())

			If !Empty(_cGrupo) .And. TRC->QTD == 0
				TRC->(dbSkip())
				Loop
			Endif

			aAdd((oHTML:ValByName("aGrp.cRegGrp"))   , If(Empty(_cGrupo),TRC->GRUPO,TRC->PRODUTO))
			aAdd((oHTML:ValByName("aGrp.cQtdGrp"))   , Transform(TRC->QTD                , _cPctQtd ))
			aAdd((oHTML:ValByName("aGrp.cQtdPrcGrp")), Transform(TRC->QTD/_nTotQtd*100   , _cD2Total)+'%')
			aAdd((oHTML:ValByName("aGrp.cVlrGrp"))   , Transform(TRC->REAIS              , _cD2Total))
			aAdd((oHTML:ValByName("aGrp.cVlrPrcGrp")), Transform(TRC->REAIS/_nTotReal*100, _cD2Total)+'%')

			TRC->(dbSkip())
		EndDo

		aAdd((oHTML:ValByName("aGrp.cRegGrp"))   , "TOTAL:")
		aAdd((oHTML:ValByName("aGrp.cQtdGrp"))   , Transform(_nTotQtd, _cPctQtd))
		aAdd((oHTML:ValByName("aGrp.cQtdPrcGrp")), "100,00%")
		aAdd((oHTML:ValByName("aGrp.cVlrGrp"))   , Transform(_nTotReal, _cD2Total))
		aAdd((oHTML:ValByName("aGrp.cVlrPrcGrp")), "100,00%")

	ElseIf _cRegiao $ _cRegionais

		oHtml:ValByName("cAlimentar", Transform(TRA->TOTAL, _cD2Total ))

		While TRB->(!Eof())
			_nTotQtd  += TRB->QTD
			_nTotReal += TRB->REAIS
			TRB->(dbSkip())
			If !_lSchedule
				_oProcess:IncRegua1()
			Endif
		EndDo

		// Total por VENDEDOR
		DbSelectArea('TRB')
		DbGoTop()

		While TRB->(!Eof())
			_cVend    := TRB->VENDEDOR

			aAdd((oHTML:ValByName("aReg.cVENDEDOR")), AllTrim(Posicione("SA3",1,xFilial("SA3")+_cVend,"A3_NOME")))
			aAdd((oHTML:ValByName("aReg.cQtd"))     , Transform(TRB->TOTAL_QTD                , _cPctQtd ))
			aAdd((oHTML:ValByName("aReg.cQtdPrc"))  , Transform(TRB->TOTAL_QTD/_nTotQtd*100   , _cD2Total)+'%')
			aAdd((oHTML:ValByName("aReg.cVlr"))     , Transform(TRB->TOTAL_REAIS              , _cD2Total))
			aAdd((oHTML:ValByName("aReg.cVlrPrc"))  , Transform(TRB->TOTAL_REAIS/_nTotReal*100, _cD2Total)+'%')

			While TRB->(!Eof()) .And. TRB->VENDEDOR == _cVend
				TRB->(dbSkip())
				If !_lSchedule
					_oProcess:IncRegua1()
				Endif
			EndDo

		EndDo

		aAdd((oHTML:ValByName("aReg.cVENDEDOR")), "TOTAL:")
		aAdd((oHTML:ValByName("aReg.cQtd"))     , Transform(_nTotQtd, _cPctQtd))
		aAdd((oHTML:ValByName("aReg.cQtdPrc"))  , "100,00%")
		aAdd((oHTML:ValByName("aReg.cVlr"))     , Transform(_nTotReal, _cD2Total))
		aAdd((oHTML:ValByName("aReg.cVlrPrc"))  , "100,00%")

		// Total por GRUPO de PRODUTO / PRODUTO
		DbSelectArea('TRC')
		DbGotop()

		oHtml:ValByName("cTitGrp", If(Empty(_cGrupo),"Total por GRUPO de PRODUTO","Total por PRODUTO"))
		oHtml:ValByName("cCmpGrp", If(Empty(_cGrupo),"GRUPO","PRODUTO"))

		While TRC->(!Eof())

			If !Empty(_cGrupo) .And. TRC->TOTAL_QTD == 0
				TRC->(dbSkip())
				Loop
			Endif

			_cGrpPrd := If(Empty(_cGrupo),TRC->GRUPO,TRC->PRODUTO)

			aAdd((oHTML:ValByName("aGrp.cGrpPrd")), _cGrpPrd)
			aAdd((oHTML:ValByName("aGrp.cQtd"))   , Transform(TRC->TOTAL_QTD                , _cPctQtd ))
			aAdd((oHTML:ValByName("aGrp.cQtdPrc")), Transform(TRC->TOTAL_QTD/_nTotQtd*100   , _cD2Total)+'%')
			aAdd((oHTML:ValByName("aGrp.cVlr"))   , Transform(TRC->TOTAL_REAIS              , _cD2Total))
			aAdd((oHTML:ValByName("aGrp.cVlrPrc")), Transform(TRC->TOTAL_REAIS/_nTotReal*100, _cD2Total)+'%')

			If Empty(_cGrupo)
				While TRC->(!Eof()) .And. TRC->GRUPO == _cGrpPrd
					TRC->(dbSkip())
				EndDo
			Else
				While TRC->(!Eof()) .And. TRC->PRODUTO == _cGrpPrd
					TRC->(dbSkip())
				EndDo
			Endif

		EndDo

		aAdd((oHTML:ValByName("aGrp.cGrpPrd")), "TOTAL:")
		aAdd((oHTML:ValByName("aGrp.cQtd"))   , Transform(_nTotQtd, _cPctQtd))
		aAdd((oHTML:ValByName("aGrp.cQtdPrc")), "100,00%")
		aAdd((oHTML:ValByName("aGrp.cVlr"))   , Transform(_nTotReal, _cD2Total))
		aAdd((oHTML:ValByName("aGrp.cVlrPrc")), "100,00%")

		// VENDEDORes
		DbSelectArea('TRB')
		DbGotop()

		oHtml:ValByName("cCmpVnd", If(Empty(_cGrupo),"GRUPO","PRODUTO"))

		While TRB->(!Eof())
			_cVend    := TRB->VENDEDOR
			_nQtdVend := TRB->TOTAL_QTD
			_nTotVend := TRB->TOTAL_REAIS

			aAdd((oHTML:ValByName("aVnd.cGrpPrd")), AllTrim(Posicione("SA3",1,xFilial("SA3")+_cVend,"A3_NOME")))
			aAdd((oHTML:ValByName("aVnd.cQtd"))   , "")
			aAdd((oHTML:ValByName("aVnd.cQtdPrc")), "")
			aAdd((oHTML:ValByName("aVnd.cVlr"))   , "")
			aAdd((oHTML:ValByName("aVnd.cVlrPrc")), "")

			While TRB->(!Eof()) .And. TRB->VENDEDOR == _cVend

				aAdd((oHTML:ValByName("aVnd.cGrpPrd")), If(Empty(_cGrupo),TRB->GRUPO,TRB->PRODUTO))
				aAdd((oHTML:ValByName("aVnd.cQtd"))   , Transform(TRB->QTD                       , _cPctQtd ))
				aAdd((oHTML:ValByName("aVnd.cQtdPrc")), Transform(TRB->QTD/TRB->TOTAL_QTD*100    , _cD2Total)+'%')
				aAdd((oHTML:ValByName("aVnd.cVlr"))   , Transform(TRB->REAIS                     , _cD2Total))
				aAdd((oHTML:ValByName("aVnd.cVlrPrc")), Transform(TRB->REAIS/TRB->TOTAL_REAIS*100, _cD2Total)+'%')

				TRB->(dbSkip())
				If !_lSchedule
					_oProcess:IncRegua1()
				Endif
			EndDo

			aAdd((oHTML:ValByName("aVnd.cGrpPrd")), "TOTAL:")
			aAdd((oHTML:ValByName("aVnd.cQtd"))   , Transform(_nQtdVend, _cPctQtd))
			aAdd((oHTML:ValByName("aVnd.cQtdPrc")), "100,00%")
			aAdd((oHTML:ValByName("aVnd.cVlr"))   , Transform(_nTotVend, _cD2Total))
			aAdd((oHTML:ValByName("aVnd.cVlrPrc")), "100,00%")

			aAdd((oHTML:ValByName("aVnd.cGrpPrd")), "")
			aAdd((oHTML:ValByName("aVnd.cQtd"))   , "")
			aAdd((oHTML:ValByName("aVnd.cQtdPrc")), "")
			aAdd((oHTML:ValByName("aVnd.cVlr"))   , "")
			aAdd((oHTML:ValByName("aVnd.cVlrPrc")), "")

		EndDo

	ElseIf _cRegiao == 'VENDEDORES'

		While TRB->(!Eof())
			oProcess := TWFProcess():New("FAT_DIARIO","FATURAMENTO DIARIO")
			oProcess:NewTask("Gerando Relatorio",_cArquivo)
			oHTML := oProcess:oHTML

			_cVend    := TRB->VENDEDOR
			_nQtdVend := TRB->TOTAL_QTD
			_nTotVend := TRB->TOTAL_REAIS

			oHtml:ValByName("cTitulo"  , _cTitulo)
			oHtml:ValByName("cDataDe"  , DtoC(_cDataDe))
			oHtml:ValByName("cDataAte" , DtoC(_cDataAte))
			oHtml:ValByName("cHora"    , Substr(Time(),1,5))
			oHtml:ValByName("cFilial"  , SM0->M0_FILIAL)
			oHtml:ValByName("cRegional", AllTrim(Posicione("SA3",1,xFilial("SA3")+_cVend,"A3_REGIAO")))
			oHtml:ValByName("cVENDEDOR", +AllTrim(Posicione("SA3",1,xFilial("SA3")+_cVend,"A3_NOME")))

			If !Empty(_cGrupo)
				oHtml:ValByName("cGrupo", +AllTrim(Posicione("SA3",1,xFilial("SA3")+_cVend,"A3_NOME")))
			Else
				oHtml:ValByName("cGrupo", "GRUPO")
			Endif

			While TRB->(!Eof()) .And. TRB->VENDEDOR == _cVend
				aAdd((oHTML:ValByName("aReg.cGrupo")) , If(Empty(_cGrupo),TRB->GRUPO,TRB->PRODUTO))
				aAdd((oHTML:ValByName("aReg.cQtd"))   , Transform(TRB->QTD,   _cPctQtd))
				aAdd((oHTML:ValByName("aReg.cQtdPrc")), Transform(TRB->QTD/_nQtdVend*100, _cD2Total)+'%')
				aAdd((oHTML:ValByName("aReg.cVlr"))   , Transform(TRB->REAIS, _cD2Total))
				aAdd((oHTML:ValByName("aReg.cVlrPrc")), Transform(TRB->REAIS/_nTotVend*100, _cD2Total)+'%')

				TRB->(dbSkip())
				If !_lSchedule
					_oProcess:IncRegua1()
				Endif
			EndDo

			aAdd((oHTML:ValByName("aReg.cGrupo")), "TOTAL:")
			aAdd((oHTML:ValByName("aReg.cQtd"))   , Transform(_nQtdVend, _cPctQtd))
			aAdd((oHTML:ValByName("aReg.cQtdPrc")), "100,00%")
			aAdd((oHTML:ValByName("aReg.cVlr"))   , Transform(_nTotVend, _cD2Total))
			aAdd((oHTML:ValByName("aReg.cVlrPrc")), "100,00%")

			_cNReduz := AllTrim(Posicione("SA3",1,xFilial("SA3")+_cVend,"A3_NREDUZ"))

			If !Empty(_cNReduz)
				If !Empty(_cGrupo)
					_cSubject := _cTitulo+" - Regional "+AllTrim(Posicione("SA3",1,xFilial("SA3")+_cVend,"A3_REGIAO"))+" - "+AllTrim(Posicione("SBM",1,xFilial("SBM")+AllTrim(_cGrupo),"BM_DESC"))+" - Rep "+_cNReduz+" ["+DTOC(Date())+"]"
				Else
					_cSubject := _cTitulo+" - Regional "+AllTrim(Posicione("SA3",1,xFilial("SA3")+_cVend,"A3_REGIAO"))+" - Rep "+_cNReduz+" ["+DTOC(Date())+"]"
				Endif
			Else
				If !Empty(_cGrupo)
					_cSubject := _cTitulo+" - Regional "+AllTrim(Posicione("SA3",1,xFilial("SA3")+_cVend,"A3_REGIAO"))+" - "+AllTrim(Posicione("SBM",1,xFilial("SBM")+AllTrim(_cGrupo),"BM_DESC"))+" - Rep "+AllTrim(SA3->A3_NOME)+" ["+DTOC(Date())+"]"
				Else
					_cSubject := _cTitulo+" - Regional "+AllTrim(Posicione("SA3",1,xFilial("SA3")+_cVend,"A3_REGIAO"))+" - Rep "+AllTrim(SA3->A3_NOME)+" ["+DTOC(Date())+"]"
				Endif
			EndIf

			oProcess:cSubject := Upper(_cSubject)
			oProcess:USerSiga := "000000"

			_cMailTo := Posicione("SA3",1,xFilial("SA3")+_cVend,"A3_EMAIL")

			If !Empty(_cMailTo)
				oProcess:cTo  := _cMailTo
				oProcess:cCC  := _cEmailCC
				oProcess:cBCC := "fernando.nogueira@avantlux.com.br"
				oProcess:Start()
				oProcess:Finish()
			EndIf

		EndDo

	Endif


	If _cRegiao <> 'VENDEDORES'

		If _cRegiao $ "DIRETORIA.GERAL" .And. !Empty(_cGrupo)
			_cSubject := _cTitulo+" - Geral - "+AllTrim(Posicione("SBM",1,xFilial("SBM")+AllTrim(_cGrupo),"BM_DESC"))+" ["+DTOC(Date())+"]"
		ElseIf _cRegiao $ "DIRETORIA.GERAL"
			_cSubject := _cTitulo+" - Geral ["+DTOC(Date())+"]"
		ElseIf _cRegiao $ _cRegionais .And. !Empty(_cGrupo)
			_cSubject := _cTitulo+" - Regional "+_cRegiao+" - "+AllTrim(Posicione("SBM",1,xFilial("SBM")+AllTrim(_cGrupo),"BM_DESC"))+" ["+DTOC(Date())+"]"
		ElseIf _cRegiao $ _cRegionais
			_cSubject := _cTitulo+" - Regional "+_cRegiao+" ["+DTOC(Date())+"]"
		Endif

		oProcess:cSubject := Upper(_cSubject)
		oProcess:USerSiga := "000000"

		If Empty(_cEmail)
			If _cRegiao $ "DIRETORIA.GERAL"
				oProcess:cTo  := SepEmail(_cString,_cRegiao)
				oProcess:cCC  := _cEmailCC
				oProcess:cBCC := "fernando.nogueira@avantlux.com.br"
			Else
				oProcess:cTo  := SepEmail(_cString,_cRegiao)
				If lAcumulado
					oProcess:cCC := SepEmail(_cString,"GERAL")+";"+_cEmailCC
				Else
					oProcess:cCC := _cEmailCC
				Endif
				oProcess:cBCC := "fernando.nogueira@avantlux.com.br"
			Endif
		Else
			oProcess:cTo  := _cEmail
			oProcess:cCC  := _cEmailCC
			oProcess:cBCC := "fernando.nogueira@avantlux.com.br"
		Endif

		oProcess:Start()
		oProcess:Finish()

	EndIf

EndIf

TRA->(DbCloseArea())
TRB->(DbCloseArea())
TRC->(DbCloseArea())

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ SepEmail  ³ Autor ³ Fernando Nogueira  ³ Data  ³ 22/01/14 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Separa e-mail da String por Regiao                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function SepEmail(_cString,_cRegiao)

Local _cTarget   := _cRegiao + "@"
Local _nDe       := At(_cTarget,_cString)+Len(_cTarget)
Local _nAte      := 6
Local _cVendedor := Substr(_cString,_nDe,_nAte)
Local _cEmail    := Posicione("SA3",1,xFilial("SA3")+_cVendedor,"A3_EMAIL")

Return _cEmail
