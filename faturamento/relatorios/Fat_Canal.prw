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
±±ºPrograma  ³ Fat_Canal()  º Autor ³ Fernando Nogueira º Data ³ 18/06/15 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Faturamento Canal                                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Avant                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function Fat_Canal(aParam)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³aParam     |  [01]  | [02]  |  [03]   |   [04]   |  [05]  |  [06] |  [07]    |  [08]   |  [09]  |
	//³           | Canal  | Grupo | Data De | Data Ate | E-mail |   CC  | Schedule | Empresa | Filial |
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	/*
	ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	³ Exemplos de Relatorios:                                                                  |
	ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
	³ U_Fat_Canal({'GERAL','','DIARIO','','','',''})                                           |
	³ U_Fat_Canal({'000001','','DIARIO','','','',.F.})                                         |
	³ U_Fat_Canal({'','','DIARIO','','','',.F.})                                               ³
	³ U_Fat_Canal({'GERAL','A070','20140110','20140120','','',.F.})                            |
	³ U_Fat_Canal({'NO','',Date()-7,Date(),'','',''})                                          |
	³ U_Fat_Canal({'000001','','ACUMULADO','','','',''})                                       |
	³ U_Fat_Canal({'000001','A070','ACUMULADO','','fernando.nogueira@avantled.com.br','',''})  |
	³ U_Fat_Canal({'GERAL','A070','20140110','20140120','',.F.})                               |	
	ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	*/
	
	Local _oProcess := Nil
	Local lEnd      := .F.

	Private _lReturn    := .T.	
	Private _cFilial    := ""
	Private _cGrupo     := aParam[2]
	Private _cDataDe    := ""
	Private _cDataAte   := Date()
	Private _cTitulo    := "Faturamento Diário Canal"
	Private _cEmail     := aParam[5]
	Private _cEmailCC   := aParam[6]
	Private _lSchedule  := aParam[7]
	
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
	
	dbSelectArea("SX5")
	dbGoTop()
	dbSetOrder(1)
			
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
				_cTitulo := "Faturamento Acumulado Canal"
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
		_cTitulo := "Faturamento Acumulado Canal"
	EndIf
	
	_cCanal := AllTrim(aParam[1])
	
	If Empty(_cCanal)
		If SX5->(dbSeek(xFilial("SX5")+"CN"))
			While SX5->(!EoF()) .And. SX5->X5_FILIAL+SX5->X5_TABELA = xFilial("SX5")+"CN"
				_cCanal := SX5->X5_CHAVE
				
				If _lSchedule
					GeraArqTRB()
					EnviaEmail(lEnd,_oProcess)
				Else
					LjMsgRun("Montando massa de dados temporaria ...",,{|| CursorWait(),GeraArqTRB(),CursorArrow()})
					_oProcess := MsNewProcess():New({|lEnd| EnviaEmail(lEnd,_oProcess)},"Processando...","Processando e-mail...",.T.)
					_oProcess:Activate()
				Endif
				
				SX5->(dbSkip())
			End
		Else
			_lReturn := .F.
		Endif
	Else
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
	If _cCanal $ "GERAL"
		cField1 := "%X5_DESCRI Canal,%"
		If Empty(_cGrupo)
			cField2 := "%BM_DESC Grupo%"
		Else
			cField2 := "%B1_DESC Produto%"
		Endif
	ElseIf Empty(_cGrupo)
		cField1 := "%C5_VEND1 Vendedor,BM_DESC Grupo,Total_Reais,Total_QTD,%"
		cField2 := "%BM_DESC Grupo%"
	Else
		cField1 := "%C5_VEND1 Vendedor,B1_DESC Produto,Total_Reais,Total_QTD,%"
		cField2 := "%B1_DESC Produto%"
	EndIf
	
	// Condicoes
	If !Empty(_cGrupo) .And. SX5->(dbSeek(xFilial("SX5")+"CN"+_cCanal))
		cWhere := "% AND B1_GRUPO = '"+AllTrim(_cGrupo)+"' AND F2_X_CANAL = '"+_cCanal+"'%"
	ElseIf !Empty(_cGrupo)
		cWhere := "% AND B1_GRUPO = '"+AllTrim(_cGrupo)+"'%"
	ElseIf SX5->(dbSeek(xFilial("SX5")+"CN"+_cCanal))
		cWhere := "% AND F2_X_CANAL = '"+_cCanal+"'%"
	EndIf

	// Agrupamentos e Ordens
	If _cCanal $ "GERAL"
		cGroup1 := "%D2_FILIAL,X5_DESCRI%"
		cOrder1 := "%Filial,Reais DESC,Canal%"
		If Empty(_cGrupo)
			cGroup2 := "%D2_FILIAL,BM_DESC%"
			cOrder2 := "%Filial,Reais DESC,Grupo%"
		Else
			cGroup2 := "%D2_FILIAL,B1_DESC%"
			cOrder2 := "%Filial,Reais DESC,Produto%"
		Endif
	ElseIf Empty(_cGrupo)
		cGroup1 := "%D2_FILIAL,Total_Reais,Total_QTD,C5_VEND1,BM_DESC%"
		cGroup2 := "%D2_FILIAL,Total_Reais,Total_QTD,BM_DESC,C5_VEND1%"
		cGroup3 := "%BM_DESC%"
		cOrder1 := "%Filial,Total_Reais DESC,C5_VEND1,Reais DESC%"
		cOrder2 := "%Filial,Total_Reais DESC,BM_DESC,Reais DESC%"
		cInner2 := "%BM_DESC = Grupo%"
	Else
		cGroup1 := "%D2_FILIAL,Total_Reais,Total_QTD,C5_VEND1,B1_DESC%"
		cGroup2 := "%D2_FILIAL,Total_Reais,Total_QTD,B1_DESC,C5_VEND1%"
		cGroup3 := "%B1_DESC%"
		cOrder1 := "%Filial,Total_Reais DESC,C5_VEND1,Reais DESC%"
		cOrder2 := "%Filial,Total_Reais DESC,B1_DESC,Reais DESC%"
		cInner2 := "%B1_DESC = Produto%"
	End
	
	
	If _cCanal $ "GERAL"
		
		// Por Canal
		BeginSql alias 'TRB'

			SELECT D2_FILIAL Filial,
				%Exp:cField1%
				SUM(D2_QUANT) QTD, 
				SUM(D2_TOTAL) Reais
			FROM %table:SD2% SD2
			INNER JOIN %table:SF4% SF4 ON D2_FILIAL = F4_FILIAL AND D2_TES = F4_CODIGO AND SF4.%notDel%
			INNER JOIN %table:SC6% SC6 ON D2_FILIAL = C6_FILIAL AND D2_PEDIDO = C6_NUM AND D2_ITEMPV = C6_ITEM AND SC6.%notDel% 
			INNER JOIN %table:SC5% SC5 ON D2_FILIAL = C5_FILIAL AND D2_PEDIDO = C5_NUM AND SC5.%notDel% 
			INNER JOIN %table:SF2% SF2 ON D2_FILIAL = F2_FILIAL AND D2_DOC = F2_DOC AND D2_CLIENTE = F2_CLIENTE AND D2_LOJA = F2_LOJA %Exp:cInner1% AND SF2.%notDel% 
			INNER JOIN %table:SB1% SB1 ON D2_COD = B1_COD AND SB1.%notDel% %Exp:cWhere%
			INNER JOIN %table:SBM% SBM ON D2_FILIAL = BM_FILIAL AND B1_GRUPO = BM_GRUPO AND SBM.%notDel%
			INNER JOIN %table:SX5% SX5 ON D2_FILIAL = X5_FILIAL AND X5_TABELA = 'CN' AND F2_X_CANAL = X5_CHAVE AND SX5.%notDel%
			WHERE F4_DUPLIC = 'S' 
				AND D2_EMISSAO BETWEEN %Exp:DTOS(_cDataDe)% AND %Exp:DTOS(_cDataAte)% AND D2_TIPO = 'N' 
				AND D2_TIPO = 'N'
				AND D2_FILIAL = %Exp:_cFilial% 
				AND SD2.%notDel%
			GROUP BY %Exp:cGroup1%
			ORDER BY %Exp:cOrder1%
			
		EndSql
		         
		// Por Grupo de Produto / Produto
		BeginSql alias 'TRC'

			SELECT CASE WHEN D2_FILIAL IS NULL THEN %Exp:_cFilial% ELSE D2_FILIAL END Filial,
				SUM(CASE WHEN D2_QUANT IS NULL THEN 0 ELSE D2_QUANT END) QTD,
				SUM(CASE WHEN D2_TOTAL IS NULL THEN 0 ELSE D2_TOTAL END) Reais,
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

		// Por Vendedor
		BeginSql alias 'TRB'
		
			SELECT D2_FILIAL Filial,
				%Exp:cField1%
				SUM(D2_QUANT) QTD, SUM(D2_TOTAL) Reais
			FROM %table:SD2% SD2
			INNER JOIN %table:SF4% SF4 ON D2_FILIAL = F4_FILIAL AND D2_TES = F4_CODIGO AND SF4.%notDel%
			INNER JOIN %table:SC6% SC6 ON D2_FILIAL = C6_FILIAL AND D2_PEDIDO = C6_NUM AND D2_ITEMPV = C6_ITEM AND SC6.%notDel% 
			INNER JOIN %table:SC5% SC5 ON D2_FILIAL = C5_FILIAL AND D2_PEDIDO = C5_NUM AND SC5.%notDel% 
			INNER JOIN %table:SF2% SF2 ON D2_FILIAL = F2_FILIAL AND D2_DOC = F2_DOC AND D2_CLIENTE = F2_CLIENTE AND D2_LOJA = F2_LOJA %Exp:cInner1% AND SF2.%notDel% 
			INNER JOIN %table:SB1% SB1 ON D2_COD = B1_COD AND SB1.%notDel%
			INNER JOIN %table:SBM% SBM ON D2_FILIAL = BM_FILIAL AND B1_GRUPO = BM_GRUPO AND SBM.%notDel%
			INNER JOIN
				(SELECT D2_FILIAL Filial, C5_VEND1 Vendedor, SUM(D2_QUANT) Total_QTD, SUM(D2_TOTAL) Total_Reais FROM %table:SD2% SD2
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
				GROUP BY D2_FILIAL,C5_VEND1) TOT_VEND ON D2_FILIAL = Filial AND C5_VEND1 = Vendedor
			WHERE D2_EMISSAO BETWEEN %Exp:DTOS(_cDataDe)% AND %Exp:DTOS(_cDataAte)% AND D2_TIPO = 'N'
				AND SD2.%notDel%
				AND D2_FILIAL = %Exp:_cFilial%
				AND F4_DUPLIC = 'S'
				%Exp:cWhere%
			GROUP BY %Exp:cGroup1%
			ORDER BY %Exp:cOrder1%
	
		EndSql
		
		// Por Grupo de Produto	/ Produto
		BeginSql alias 'TRC'
		
			SELECT CASE WHEN D2_FILIAL IS NULL THEN %Exp:_cFilial% ELSE D2_FILIAL END Filial,
				%Exp:cField1%
				SUM(CASE WHEN D2_QUANT IS NULL THEN 0 ELSE D2_QUANT END) QTD,
				SUM(CASE WHEN D2_TOTAL IS NULL THEN 0 ELSE D2_TOTAL END) Reais
			FROM %table:SD2% SD2
			INNER JOIN %table:SF4% SF4 ON D2_FILIAL = F4_FILIAL AND D2_TES = F4_CODIGO AND F4_DUPLIC = 'S' AND D2_EMISSAO BETWEEN %Exp:DTOS(_cDataDe)% AND %Exp:DTOS(_cDataAte)% AND D2_FILIAL = %Exp:_cFilial% AND D2_TIPO = 'N' AND SD2.%notDel% AND SF4.%notDel%
			INNER JOIN %table:SC6% SC6 ON D2_FILIAL = C6_FILIAL AND D2_PEDIDO = C6_NUM AND D2_ITEMPV = C6_ITEM AND SC6.%notDel% 
			INNER JOIN %table:SC5% SC5 ON D2_FILIAL = C5_FILIAL AND D2_PEDIDO = C5_NUM AND SC5.%notDel% 
			INNER JOIN %table:SF2% SF2 ON D2_FILIAL = F2_FILIAL AND D2_DOC = F2_DOC AND D2_CLIENTE = F2_CLIENTE AND D2_LOJA = F2_LOJA %Exp:cInner1% AND SF2.%notDel% 
			INNER JOIN %table:SB1% SB1 ON D2_COD = B1_COD AND SB1.%notDel% %Exp:cWhere%
			RIGHT JOIN %table:SBM% SBM ON B1_GRUPO = BM_GRUPO
			INNER JOIN
				(SELECT CASE WHEN D2_FILIAL IS NULL THEN %Exp:_cFilial% ELSE D2_FILIAL END Filial,
					SUM(CASE WHEN D2_QUANT IS NULL THEN 0 ELSE D2_QUANT END) Total_QTD,
					SUM(CASE WHEN D2_TOTAL IS NULL THEN 0 ELSE D2_TOTAL END) Total_Reais,
					%Exp:cField2%
					FROM %table:SD2% SD2
					INNER JOIN %table:SF4% SF4 ON D2_FILIAL = F4_FILIAL AND D2_TES = F4_CODIGO AND F4_DUPLIC = 'S' AND D2_EMISSAO BETWEEN %Exp:DTOS(_cDataDe)% AND %Exp:DTOS(_cDataAte)% AND D2_TIPO = 'N' AND D2_FILIAL = %Exp:_cFilial% AND SD2.%notDel% AND SF4.%notDel%
					INNER JOIN %table:SC6% SC6 ON D2_FILIAL = C6_FILIAL AND D2_PEDIDO = C6_NUM AND D2_ITEMPV = C6_ITEM AND SC6.%notDel% 
					INNER JOIN %table:SC5% SC5 ON D2_FILIAL = C5_FILIAL AND D2_PEDIDO = C5_NUM AND SC5.%notDel%
					INNER JOIN %table:SF2% SF2 ON D2_FILIAL = F2_FILIAL AND D2_DOC = F2_DOC AND D2_CLIENTE = F2_CLIENTE AND D2_LOJA = F2_LOJA %Exp:cInner1% AND SF2.%notDel%  
					INNER JOIN %table:SB1% SB1 ON D2_COD = B1_COD AND SB1.%notDel% %Exp:cWhere%
					RIGHT JOIN %table:SBM% SBM ON B1_GRUPO = BM_GRUPO
				WHERE BM_FILIAL = %Exp:_cFilial% AND SBM.%notDel%
				GROUP BY D2_FILIAL,%Exp:cGroup3%) TOT_VEND ON Filial = %Exp:_cFilial% AND %Exp:cInner2%
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
Local _cString    := GetMv("ES_GERENCN")
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

If _cCanal $ "GERAL"
	_cArquivo := "\MODELOS\FAT_CANAL_DIR.HTM"
ElseIf _cCanal $ "VENDEDORES"
	_cArquivo := "\MODELOS\FAT_DIARIO_VND.HTM"
Else
	_cArquivo := "\MODELOS\FAT_CANAL_GER.HTM"
Endif

If _cCanal <> 'VENDEDORES'
	oProcess := TWFProcess():New("FAT_DIARIO","FATURAMENTO DIARIO")
	oProcess:NewTask("Gerando Relatorio",_cArquivo)
	oHTML := oProcess:oHTML
Endif

If TRB->(!Eof())
	If _cCanal <> 'VENDEDORES'
		oHtml:ValByName("cTitulo", Upper(_cTitulo))
		If _cDataDe == Date() .And. _cDataAte = Date()
			oHtml:ValByName("cDataDe", DtoC(Date()))
		Else
			oHtml:ValByName("cDataDe",  DtoC(_cDataDe))
			oHtml:ValByName("cDataAte", DtoC(_cDataAte))
		Endif
		oHtml:ValByName("cHora"    , Substr(Time(),1,5))
		oHtml:ValByName("cFilial"  , SM0->M0_FILIAL)
		oHtml:ValByName("cCanal", If(_cCanal $ "GERAL",_cCanal,AllTrim(Posicione("SX5",1,xFilial("SX5")+"CN"+_cCanal,"X5_DESCRI"))))
	EndIf
		
	If _cCanal $ "GERAL"
	
		// Por Canal
		While TRB->(!Eof())	
			_nTotQtd  += TRB->QTD
			_nTotReal += TRB->Reais
			TRB->(dbSkip())
			If !_lSchedule
				_oProcess:IncRegua1()
			Endif
		EndDo
		
		DbSelectArea('TRB')		
		DbGotop()

		While TRB->(!Eof())
			aAdd((oHTML:ValByName("aReg.cRegiao"))   , TRB->Canal)
			aAdd((oHTML:ValByName("aReg.cQuant"))    , Transform(TRB->QTD                , _cPctQtd ))
			aAdd((oHTML:ValByName("aReg.cQuantPorc")), Transform(TRB->QTD/_nTotQtd*100   , _cD2Total)+'%')
			aAdd((oHTML:ValByName("aReg.cValor"))    , Transform(TRB->Reais              , _cD2Total))
			aAdd((oHTML:ValByName("aReg.cValorPorc")), Transform(TRB->Reais/_nTotReal*100, _cD2Total)+'%')						
			TRB->(dbSkip()) 
			If !_lSchedule
				_oProcess:IncRegua1()
			Endif
		EndDo
				
		aAdd((oHTML:ValByName("aReg.cRegiao"))   , "TOTAL:")
		aAdd((oHTML:ValByName("aReg.cQuant"))    , Transform(_nTotQtd, _cPctQtd))
		aAdd((oHTML:ValByName("aReg.cQuantPorc")), "100,00%")
		aAdd((oHTML:ValByName("aReg.cValor"))    , Transform(_nTotReal, _cD2Total))
		aAdd((oHTML:ValByName("aReg.cValorPorc")), "100,00%")	
		
		// Por Grupo de Produto / Produto
		oHtml:ValByName("cTitGrpPrd", If(Empty(_cGrupo),"Total por Grupo de Produto","Total por Produto"))			
		oHtml:ValByName("cGrpPrd"   , If(Empty(_cGrupo),"Grupo","Produto"))		
	 
		DbSelectArea('TRC')
		DbGotop()

		While TRC->(!Eof())
		
			If !Empty(_cGrupo) .And. TRC->QTD == 0
				TRC->(dbSkip())
				Loop
			Endif
		
			aAdd((oHTML:ValByName("aGrp.cRegGrp"))   , If(Empty(_cGrupo),TRC->Grupo,TRC->Produto))
			aAdd((oHTML:ValByName("aGrp.cQtdGrp"))   , Transform(TRC->QTD                , _cPctQtd ))
			aAdd((oHTML:ValByName("aGrp.cQtdPrcGrp")), Transform(TRC->QTD/_nTotQtd*100   , _cD2Total)+'%')
			aAdd((oHTML:ValByName("aGrp.cVlrGrp"))   , Transform(TRC->Reais              , _cD2Total))
			aAdd((oHTML:ValByName("aGrp.cVlrPrcGrp")), Transform(TRC->Reais/_nTotReal*100, _cD2Total)+'%')

			TRC->(dbSkip()) 
		EndDo
		
		aAdd((oHTML:ValByName("aGrp.cRegGrp"))   , "TOTAL:")
		aAdd((oHTML:ValByName("aGrp.cQtdGrp"))   , Transform(_nTotQtd, _cPctQtd))
		aAdd((oHTML:ValByName("aGrp.cQtdPrcGrp")), "100,00%")
		aAdd((oHTML:ValByName("aGrp.cVlrGrp"))   , Transform(_nTotReal, _cD2Total))
		aAdd((oHTML:ValByName("aGrp.cVlrPrcGrp")), "100,00%")
		
	ElseIf SX5->(dbSeek(xFilial("SX5")+"CN"+_cCanal))
	
		While TRB->(!Eof())	
			_nTotQtd  += TRB->QTD
			_nTotReal += TRB->Reais
			TRB->(dbSkip()) 		
			If !_lSchedule
				_oProcess:IncRegua1()
			Endif
		EndDo
		
		// Total por Vendedor
		DbSelectArea('TRB')		
		DbGoTop()
		
		While TRB->(!Eof())
			_cVend    := TRB->Vendedor
			
			aAdd((oHTML:ValByName("aReg.cVendedor")), AllTrim(Posicione("SA3",1,xFilial("SA3")+_cVend,"A3_NOME")))
			aAdd((oHTML:ValByName("aReg.cQtd"))     , Transform(TRB->QTD                      , _cPctQtd ))
			aAdd((oHTML:ValByName("aReg.cQtdPrc"))  , Transform(TRB->QTD/_nTotQtd*100         , _cD2Total)+'%')
			aAdd((oHTML:ValByName("aReg.cVlr"))     , Transform(TRB->Total_Reais              , _cD2Total))
			aAdd((oHTML:ValByName("aReg.cVlrPrc"))  , Transform(TRB->Total_Reais/_nTotReal*100, _cD2Total)+'%')
		
			While TRB->(!Eof()) .And. TRB->Vendedor == _cVend		
				TRB->(dbSkip())
				If !_lSchedule
					_oProcess:IncRegua1()
				Endif
			EndDo
		
		EndDo

		aAdd((oHTML:ValByName("aReg.cVendedor")), "TOTAL:")
		aAdd((oHTML:ValByName("aReg.cQtd"))     , Transform(_nTotQtd, _cPctQtd))
		aAdd((oHTML:ValByName("aReg.cQtdPrc"))  , "100,00%")
		aAdd((oHTML:ValByName("aReg.cVlr"))     , Transform(_nTotReal, _cD2Total))
		aAdd((oHTML:ValByName("aReg.cVlrPrc"))  , "100,00%")
		
		// Total por Grupo de Produto / Produto
		DbSelectArea('TRC')
		DbGotop()
		
		oHtml:ValByName("cTitGrp", If(Empty(_cGrupo),"Total por Grupo de Produto","Total por Produto"))
		oHtml:ValByName("cCmpGrp", If(Empty(_cGrupo),"Grupo","Produto"))
		
		While TRC->(!Eof())
		
			If !Empty(_cGrupo) .And. TRC->Total_QTD == 0
				TRC->(dbSkip())
				Loop
			Endif
			
			_cGrpPrd := If(Empty(_cGrupo),TRC->Grupo,TRC->Produto)
		
			aAdd((oHTML:ValByName("aGrp.cGrpPrd")), _cGrpPrd)
			aAdd((oHTML:ValByName("aGrp.cQtd"))   , Transform(TRC->Total_QTD                , _cPctQtd ))
			aAdd((oHTML:ValByName("aGrp.cQtdPrc")), Transform(TRC->Total_QTD/_nTotQtd*100   , _cD2Total)+'%')
			aAdd((oHTML:ValByName("aGrp.cVlr"))   , Transform(TRC->Total_Reais              , _cD2Total))
			aAdd((oHTML:ValByName("aGrp.cVlrPrc")), Transform(TRC->Total_Reais/_nTotReal*100, _cD2Total)+'%')
			
			If Empty(_cGrupo)			
				While TRC->(!Eof()) .And. TRC->Grupo == _cGrpPrd		
					TRC->(dbSkip())
				EndDo
			Else
				While TRC->(!Eof()) .And. TRC->Produto == _cGrpPrd		
					TRC->(dbSkip())
				EndDo
			Endif
			
		EndDo
		
		aAdd((oHTML:ValByName("aGrp.cGrpPrd")), "TOTAL:")
		aAdd((oHTML:ValByName("aGrp.cQtd"))   , Transform(_nTotQtd, _cPctQtd))
		aAdd((oHTML:ValByName("aGrp.cQtdPrc")), "100,00%")
		aAdd((oHTML:ValByName("aGrp.cVlr"))   , Transform(_nTotReal, _cD2Total))
		aAdd((oHTML:ValByName("aGrp.cVlrPrc")), "100,00%")

		// Vendedores
		DbSelectArea('TRB')
		DbGotop()
		
		oHtml:ValByName("cCmpVnd", If(Empty(_cGrupo),"Grupo","Produto"))		

		While TRB->(!Eof())	
			_cVend    := TRB->Vendedor
			_nQtdVend := TRB->Total_QTD
			_nTotVend := TRB->Total_Reais
			
			aAdd((oHTML:ValByName("aVnd.cGrpPrd")), AllTrim(Posicione("SA3",1,xFilial("SA3")+_cVend,"A3_NOME")))
			aAdd((oHTML:ValByName("aVnd.cQtd"))   , "")
			aAdd((oHTML:ValByName("aVnd.cQtdPrc")), "")
			aAdd((oHTML:ValByName("aVnd.cVlr"))   , "")
			aAdd((oHTML:ValByName("aVnd.cVlrPrc")), "")
			
			While TRB->(!Eof()) .And. TRB->Vendedor == _cVend
			
				aAdd((oHTML:ValByName("aVnd.cGrpPrd")), If(Empty(_cGrupo),TRB->Grupo,TRB->Produto))
				aAdd((oHTML:ValByName("aVnd.cQtd"))   , Transform(TRB->QTD                       , _cPctQtd ))
				aAdd((oHTML:ValByName("aVnd.cQtdPrc")), Transform(TRB->QTD/TRB->Total_QTD*100    , _cD2Total)+'%')
				aAdd((oHTML:ValByName("aVnd.cVlr"))   , Transform(TRB->Reais                     , _cD2Total))
				aAdd((oHTML:ValByName("aVnd.cVlrPrc")), Transform(TRB->Reais/TRB->Total_Reais*100, _cD2Total)+'%')

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
		
	ElseIf _cCanal == 'VENDEDORES'
	
		While TRB->(!Eof())
			oProcess := TWFProcess():New("FAT_DIARIO","FATURAMENTO DIARIO")
			oProcess:NewTask("Gerando Relatorio",_cArquivo)
			oHTML := oProcess:oHTML
			
			_cVend    := TRB->Vendedor
			_nQtdVend := TRB->Total_QTD
			_nTotVend := TRB->Total_Reais
			
			oHtml:ValByName("cTitulo"  , _cTitulo)
			oHtml:ValByName("cDataDe"  , DtoC(_cDataDe))
			oHtml:ValByName("cDataAte" , DtoC(_cDataAte))
			oHtml:ValByName("cHora"    , Substr(Time(),1,5))
			oHtml:ValByName("cFilial"  , SM0->M0_FILIAL)
			oHtml:ValByName("cCanal", AllTrim(Posicione("SA3",1,xFilial("SA3")+_cVend,"A3_REGIAO")))
			oHtml:ValByName("cVendedor", +AllTrim(Posicione("SA3",1,xFilial("SA3")+_cVend,"A3_NOME")))

			If !Empty(_cGrupo)
				oHtml:ValByName("cGrupo", +AllTrim(Posicione("SA3",1,xFilial("SA3")+_cVend,"A3_NOME")))
			Else
				oHtml:ValByName("cGrupo", "Grupo")
			Endif

			While TRB->(!Eof()) .And. TRB->Vendedor == _cVend
				aAdd((oHTML:ValByName("aReg.cGrupo")) , If(Empty(_cGrupo),TRB->Grupo,TRB->Produto))
				aAdd((oHTML:ValByName("aReg.cQtd"))   , Transform(TRB->QTD,   _cPctQtd))
				aAdd((oHTML:ValByName("aReg.cQtdPrc")), Transform(TRB->QTD/_nQtdVend*100, _cD2Total)+'%')
				aAdd((oHTML:ValByName("aReg.cVlr"))   , Transform(TRB->Reais, _cD2Total))
				aAdd((oHTML:ValByName("aReg.cVlrPrc")), Transform(TRB->Reais/_nTotVend*100, _cD2Total)+'%')
				
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
					_cSubject := _cTitulo+" - "+AllTrim(Posicione("SA3",1,xFilial("SA3")+_cVend,"A3_REGIAO"))+" - "+AllTrim(Posicione("SBM",1,xFilial("SBM")+AllTrim(_cGrupo),"BM_DESC"))+" - Rep "+_cNReduz+" ["+DTOC(Date())+"]"
				Else
					_cSubject := _cTitulo+" - "+AllTrim(Posicione("SA3",1,xFilial("SA3")+_cVend,"A3_REGIAO"))+" - Rep "+_cNReduz+" ["+DTOC(Date())+"]"
				Endif
			Else
				If !Empty(_cGrupo)
					_cSubject := _cTitulo+" - "+AllTrim(Posicione("SA3",1,xFilial("SA3")+_cVend,"A3_REGIAO"))+" - "+AllTrim(Posicione("SBM",1,xFilial("SBM")+AllTrim(_cGrupo),"BM_DESC"))+" - Rep "+AllTrim(SA3->A3_NOME)+" ["+DTOC(Date())+"]"
				Else
					_cSubject := _cTitulo+" - "+AllTrim(Posicione("SA3",1,xFilial("SA3")+_cVend,"A3_REGIAO"))+" - Rep "+AllTrim(SA3->A3_NOME)+" ["+DTOC(Date())+"]"
				Endif
			EndIf
			                                                                 
			oProcess:cSubject := Upper(_cSubject)
			oProcess:USerSiga := "000000"
			
			_cMailTo := Posicione("SA3",1,xFilial("SA3")+_cVend,"A3_EMAIL")

			If !Empty(_cMailTo)
				oProcess:cTo  := _cMailTo
				oProcess:cCC  := _cEmailCC
				oProcess:cBCC := "fernando.nogueira@avantled.com.br"
				oProcess:Start()
				oProcess:Finish()
			EndIf
			
		EndDo
	
	Endif


	If _cCanal <> 'VENDEDORES'
		
		If _cCanal $ "GERAL" .And. !Empty(_cGrupo)
			_cSubject := _cTitulo+" - Geral - "+AllTrim(Posicione("SBM",1,xFilial("SBM")+AllTrim(_cGrupo),"BM_DESC"))+" ["+DTOC(Date())+"]"
		ElseIf _cCanal $ "GERAL"
			_cSubject := _cTitulo+" - Geral ["+DTOC(Date())+"]"
		ElseIf SX5->(dbSeek(xFilial("SX5")+"CN"+_cCanal)) .And. !Empty(_cGrupo)
			_cSubject := _cTitulo+" - "+AllTrim(Posicione("SX5",1,xFilial("SX5")+"CN"+_cCanal,"X5_DESCRI"))+" - "+AllTrim(Posicione("SBM",1,xFilial("SBM")+AllTrim(_cGrupo),"BM_DESC"))+" ["+DTOC(Date())+"]"
		ElseIf SX5->(dbSeek(xFilial("SX5")+"CN"+_cCanal))
			_cSubject := _cTitulo+" - "+AllTrim(Posicione("SX5",1,xFilial("SX5")+"CN"+_cCanal,"X5_DESCRI"))+" ["+DTOC(Date())+"]"
		Endif
		
		oProcess:cSubject := Upper(_cSubject)
		oProcess:USerSiga := "000000"
		
		If Empty(_cEmail)
			If _cCanal $ "GERAL"
				oProcess:cTo  := SepEmail(_cString,_cCanal)
				oProcess:cCC  := _cEmailCC
				oProcess:cBCC := "fernando.nogueira@avantled.com.br"				
			Else
				oProcess:cTo  := SepEmail(_cString,_cCanal)
				oProcess:cCC  := SepEmail(_cString,"GERAL")+";"+_cEmailCC
				oProcess:cBCC := "fernando.nogueira@avantled.com.br"				
			Endif
		Else
			oProcess:cTo  := _cEmail
			oProcess:cCC  := _cEmailCC
			oProcess:cBCC := "fernando.nogueira@avantled.com.br"
		Endif

		oProcess:Start()
		oProcess:Finish()
		
	EndIf

EndIf 

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
Static Function SepEmail(_cString,_cCanal)

Local _cTarget   := _cCanal + "@"
Local _nDe       := At(_cTarget,_cString)+Len(_cTarget)
Local _nAte      := 6
Local _cVendedor := Substr(_cString,_nDe,_nAte)
Local _cEmail    := Posicione("SA3",1,xFilial("SA3")+_cVendedor,"A3_EMAIL")

Return _cEmail