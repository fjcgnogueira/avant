#INCLUDE "PROTHEUS.CH"           
#INCLUDE "Totvs.ch"
#INCLUDE "FILEIO.ch"
#INCLUDE "TbiConn.ch"
#INCLUDE "AP5MAIL.CH"

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
	//³           | Regiao | Grupo | Data De | Data Ate | E-mail |   CC  | Schedule | Empresa | Filial |
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
	³ U_Fat_Diario({'CO','A070','ACUMULADO','','fernando.nogueira@avantled.com.br','',''}) |
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
	Private _cTitulo    := "Faturamento Diário"
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
		cField1 := "%F2_REGIAO Regiao,%"
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
		cOrder1 := "%Filial,Reais DESC,Regiao%"
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
	
	
	If _cRegiao $ "DIRETORIA.GERAL"
		
		// Por Regiao
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
			WHERE F4_DUPLIC = 'S' 
				AND D2_EMISSAO BETWEEN %Exp:DTOS(_cDataDe)% AND %Exp:DTOS(_cDataAte)% AND D2_TIPO = 'N' 
				AND D2_TIPO = 'N'
				AND D2_FILIAL = %Exp:_cFilial% 
				AND SD2.%notDel%
			GROUP BY %Exp:cGroup1%
			ORDER BY %Exp:cOrder1%
			
		EndSql
		
		Conout('Teste')
		         
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
		
		conout("teste")
	
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
		
		Conout('Teste')
		
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
Local _cCorpoM    := ""
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

If TRB->(!Eof())
	If _cRegiao <> 'VENDEDORES'
		_cCorpoM += '<html>' 
		_cCorpoM += '<head>'
		_cCorpoM += '<title>'+_cTitulo+'</title>'
		_cCorpoM += '<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">' 
		_cCorpoM += '<style type="text/css">'
		_cCorpoM += '<!--'
		_cCorpoM += '.style1 {font-family: Arial, Helvetica, sans-serif}'
		_cCorpoM += '.style3 {font-family: Arial, Helvetica, sans-serif; font-weight: bold; }'
		_cCorpoM += '.style4 {color: #FF0000}'
		_cCorpoM += '-->'
		_cCorpoM += '</style>' 
		_cCorpoM += '</head>' 
		_cCorpoM += '<body>'
		_cCorpoM += '  <p align="center" class="style1"><strong>'+Upper(_cTitulo)+'</strong></p>' 
		If _cDataDe == Date() .And. _cDataAte = Date()
			_cCorpoM += '  <p class="style1"><strong>Data: </strong>'+DtoC(Date())+'</p>'
		Else
			_cCorpoM += '  <p class="style1"><strong>Data de: </strong>'+DtoC(_cDataDe)+'</p>'
			_cCorpoM += '  <p class="style1"><strong>Data ate: </strong>'+DtoC(_cDataAte)+'</p>'			
		Endif
		_cCorpoM += '  <p class="style1"><strong>Hora: </strong>'+Substr(Time(),1,5)+'</p>'
		_cCorpoM += '  <p class="style1"><strong>Filial : </strong>'+SM0->M0_FILIAL+'</p>'
		_cCorpoM += '  <p class="style1"><strong>Regional : </strong>'+_cRegiao+'</p>'
		If !Empty(_cGrupo)
			_cCorpoM += '  <p class="style1"><strong>Grupo : </strong>'+Posicione("SBM",1,xFilial("SBM")+_cGrupo,"BM_DESC")+'</p>'
		Endif
	EndIf
		
	If _cRegiao $ "DIRETORIA.GERAL"
	
		// Por Regiao
		_cCorpoM += '  <hr width=100% noshade>'
		_cCorpoM += '  <p class="style1"><strong>Total por Região: </strong></p>'

		_cCorpoM += '  <table width="1300" border="1" align="left"> '
		_cCorpoM += '    <tr>
		_cCorpoM += '      <td align="center" width="200"><span class="style3">Regiao</span></td>'
		_cCorpoM += '      <td align="center" width="200"><span class="style3">Quantidade</span></td>'	
		_cCorpoM += '      <td align="center" width="200"><span class="style3">Quant %</span></td>'
		_cCorpoM += '      <td align="center" width="200"><span class="style3">Valor R$</span></td>'
		_cCorpoM += '      <td align="center" width="200"><span class="style3">Valor %</span></td>'
		_cCorpoM += '    </tr>'
		
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
			_cCorpoM += '    <tr>'
			_cCorpoM += '     <td align="center"><span>'+TRB->Regiao+'</span></td>' 		
			_cCorpoM += '	   <td align="right"><span>'+Transform(TRB->QTD,   _cPctQtd)+'</span></td>'
			_cCorpoM += '	   <td align="right"><span>'+Transform(TRB->QTD/_nTotQtd*100, _cD2Total)+'%</span></td>'
			_cCorpoM += '	   <td align="right"><span>'+Transform(TRB->Reais, _cD2Total)+'</span></td>'
			_cCorpoM += '	   <td align="right"><span>'+Transform(TRB->Reais/_nTotReal*100, _cD2Total)+'%</span></td>'
			_cCorpoM += '    </tr>'						
			TRB->(dbSkip()) 
			If !_lSchedule
				_oProcess:IncRegua1()
			Endif
		EndDo
		
		_cCorpoM += '    <tr>
		_cCorpoM += '      <td align="right"><span class="style3">Total:</span></td>'
		_cCorpoM += '      <td align="right"><span class="style3">'+Transform(_nTotQtd, _cPctQtd)+'</span></td>'	
		_cCorpoM += '      <td align="right"><span class="style3">100%</span></td>'
		_cCorpoM += '      <td align="right"><span class="style3">' +Transform(_nTotReal, _cD2Total)+'</span></td>'
		_cCorpoM += '      <td align="right"><span class="style3">100%</span></td>'
		_cCorpoM += '    </tr>'
	
		_cCorpoM += '  </table>'
		
		
		// Por Grupo de Produto / Produto
		_cCorpoM += '  <hr width=100% noshade>'
		If Empty(_cGrupo)		
			_cCorpoM += '  <p class="style1"><strong>Total por Grupo de Produto: </strong></p>'
		Else
			_cCorpoM += '  <p class="style1"><strong>Total por Produto: </strong></p>'
		Endif

		_cCorpoM += '  <table width="1300" border="1" align="left"> '
		_cCorpoM += '    <tr>
		If Empty(_cGrupo)		
			_cCorpoM += '      <td align="left" width="300"><span class="style3">Grupo</span></td>'
		Else
			_cCorpoM += '      <td align="left" width="300"><span class="style3">Produto</span></td>'
		Endif
		_cCorpoM += '      <td align="center" width="250"><span class="style3">Quantidade</span></td>'	
		_cCorpoM += '      <td align="center" width="250"><span class="style3">Quant %</span></td>'
		_cCorpoM += '      <td align="center" width="250"><span class="style3">Valor R$</span></td>'
		_cCorpoM += '      <td align="center" width="250"><span class="style3">Valor %</span></td>'
		_cCorpoM += '    </tr>'
		
	 
		DbSelectArea('TRC')
		DbGotop()

		While TRC->(!Eof())
		
			If !Empty(_cGrupo) .And. TRC->QTD == 0
				TRC->(dbSkip())
				Loop
			Endif
		
			_cCorpoM += '    <tr>'
		
			If Empty(_cGrupo)		
				_cGrupoDesc := TRC->Grupo
				_cCorpoM += '     <td align="left"><span>'+TRC->Grupo+'</span></td>'
			Else
				_cProduto := TRC->Produto
				_cCorpoM += '     <td align="left"><span>'+TRC->Produto+'</span></td>'
			Endif
						
			_cCorpoM += '	   <td align="right"><span>'+Transform(TRC->QTD,   _cPctQtd)+'</span></td>'
			_cCorpoM += '	   <td align="right"><span>'+Transform(TRC->QTD/_nTotQtd*100, _cD2Total)+'%</span></td>'
			_cCorpoM += '	   <td align="right"><span>'+Transform(TRC->Reais, _cD2Total)+'</span></td>'
			_cCorpoM += '	   <td align="right"><span>'+Transform(TRC->Reais/_nTotReal*100, _cD2Total)+'%</span></td>'
			_cCorpoM += '    </tr>'						
			TRC->(dbSkip()) 
		EndDo
		
		_cCorpoM += '    <tr>
		_cCorpoM += '      <td align="right"><span class="style3">Total:</span></td>'
		_cCorpoM += '      <td align="right"><span class="style3">'+Transform(_nTotQtd, _cPctQtd)+'</span></td>'	
		_cCorpoM += '      <td align="right"><span class="style3">100%</span></td>'
		_cCorpoM += '      <td align="right"><span class="style3">' +Transform(_nTotReal, _cD2Total)+'</span></td>'
		_cCorpoM += '      <td align="right"><span class="style3">100%</span></td>'
		_cCorpoM += '    </tr>'
	
		_cCorpoM += '  </table>'
		
	ElseIf _cRegiao $ _cRegionais
	
		While TRB->(!Eof())	
			_nTotQtd  += TRB->QTD
			_nTotReal += TRB->Reais
			TRB->(dbSkip()) 		
			If !_lSchedule
				_oProcess:IncRegua1()
			Endif
		EndDo

		
		// Total por Vendedor		
		DbGotop()
		
		_cCorpoM += '  <hr width=100% noshade>'
		_cCorpoM += '  <p class="style1"><strong>Total por Vendedor: </strong></p>'
		
		_cCorpoM += '  <table width="1300" border="1" align="left"> '
		_cCorpoM += '    <tr>
		_cCorpoM += '      <td align="center" width="500"><span class="style3">Vendedor</span></td>'
		_cCorpoM += '      <td align="center" width="200"><span class="style3">Quantidade</span></td>'	
		_cCorpoM += '      <td align="center" width="200"><span class="style3">Quant %</span></td>'
		_cCorpoM += '      <td align="center" width="200"><span class="style3">Valor R$</span></td>'
		_cCorpoM += '      <td align="center" width="200"><span class="style3">Valor %</span></td>'
		_cCorpoM += '    </tr>'

		While TRB->(!Eof())
			_cVend    := TRB->Vendedor

			_cCorpoM += '    <tr>'
			_cCorpoM += '     <td align="left"><span>'+AllTrim(Posicione("SA3",1,xFilial("SA3")+_cVend,"A3_NOME"))+'</span></td>' 		
			_cCorpoM += '     <td align="right"><span>'+Transform(TRB->Total_QTD, _cPctQtd)+'</span></td>' 		
			_cCorpoM += '	   <td align="right"><span>'+Transform(TRB->Total_QTD/_nTotQtd*100, _cD2Total)+'%</span></td>'
			_cCorpoM += '	   <td align="right"><span>'+Transform(TRB->Total_Reais, _cD2Total)+'</span></td>'
			_cCorpoM += '	   <td align="right"><span>'+Transform(TRB->Total_Reais/_nTotReal*100, _cD2Total)+'%</span></td>'						
			_cCorpoM += '    </tr>'
		
			While TRB->(!Eof()) .And. TRB->Vendedor == _cVend		
				TRB->(dbSkip())
				If !_lSchedule
					_oProcess:IncRegua1()
				Endif
			EndDo
		
		EndDo
		
		_cCorpoM += '    <tr>'
		_cCorpoM += '     <td align="right"><span class="style3">Total:</span></td>' 		
		_cCorpoM += '     <td align="right"><span class="style3">'+Transform(_nTotQtd, _cPctQtd)+'</span></td>' 		
		_cCorpoM += '     <td align="right"><span class="style3">100%</span></td>'
		_cCorpoM += '	   <td align="right"><span class="style3">'+Transform(_nTotReal, _cD2Total)+'</span></td>'
		_cCorpoM += '     <td align="right"><span class="style3">100%</span></td>'						
		_cCorpoM += '    </tr>'
		
		_cCorpoM += '  </table>'
		
		_cCorpoM += '  <br>'
		

		// Total por Grupo de Produto / Produto
		DbSelectArea('TRC')
		DbGotop()
		
		_cCorpoM += '  <hr width=100% noshade>'
		If Empty(_cGrupo)		
			_cCorpoM += '  <p class="style1"><strong>Total por Grupo de Produto: </strong></p>'
		Else
			_cCorpoM += '  <p class="style1"><strong>Total por Produto: </strong></p>'
		Endif
		
		_cCorpoM += '  <table width="1300" border="1" align="left"> '
		_cCorpoM += '    <tr>
		If Empty(_cGrupo)		
			_cCorpoM += '      <td align="left" width="300"><span class="style3">Grupo</span></td>'
		Else
			_cCorpoM += '      <td align="left" width="300"><span class="style3">Produto</span></td>'
		Endif
		_cCorpoM += '      <td align="center" width="250"><span class="style3">Quantidade</span></td>'	
		_cCorpoM += '      <td align="center" width="250"><span class="style3">Quant %</span></td>'
		_cCorpoM += '      <td align="center" width="250"><span class="style3">Valor R$</span></td>'
		_cCorpoM += '      <td align="center" width="250"><span class="style3">Valor %</span></td>'
		_cCorpoM += '    </tr>'

		While TRC->(!Eof())
		
			If !Empty(_cGrupo) .And. TRC->Total_QTD == 0
				TRC->(dbSkip())
				Loop
			Endif
		
			_cCorpoM += '    <tr>'
		
			If Empty(_cGrupo)		
				_cGrupoDesc := TRC->Grupo
				_cCorpoM += '     <td align="left"><span>'+TRC->Grupo+'</span></td>'
			Else
				_cProduto := TRC->Produto
				_cCorpoM += '     <td align="left"><span>'+TRC->Produto+'</span></td>'
			Endif
			
			_cCorpoM += '     <td align="right"><span>'+Transform(TRC->Total_QTD, _cPctQtd)+'</span></td>'
			_cCorpoM += '	   <td align="right"><span>'+Transform(TRC->Total_QTD/_nTotQtd*100, _cD2Total)+'%</span></td>'
			_cCorpoM += '	   <td align="right"><span>'+Transform(TRC->Total_Reais, _cD2Total)+'</span></td>'
			_cCorpoM += '	   <td align="right"><span>'+Transform(TRC->Total_Reais/_nTotReal*100, _cD2Total)+'%</span></td>'
			_cCorpoM += '    </tr>'
			
			If Empty(_cGrupo)			
				While TRC->(!Eof()) .And. TRC->Grupo == _cGrupoDesc		
					TRC->(dbSkip())
				EndDo
			Else
				While TRC->(!Eof()) .And. TRC->Produto == _cProduto		
					TRC->(dbSkip())
				EndDo
			Endif
			
		EndDo
		
		_cCorpoM += '    <tr>'
		_cCorpoM += '     <td align="right"><span class="style3">Total:</span></td>' 		
		_cCorpoM += '     <td align="right"><span class="style3">'+Transform(_nTotQtd, _cPctQtd)+'</span></td>' 		
		_cCorpoM += '     <td align="right"><span class="style3">100%</span></td>'
		_cCorpoM += '	   <td align="right"><span class="style3">'+Transform(_nTotReal, _cD2Total)+'</span></td>'
		_cCorpoM += '     <td align="right"><span class="style3">100%</span></td>'						
		_cCorpoM += '    </tr>'
		
		_cCorpoM += '  </table>'
		
		_cCorpoM += '  <br>'
		
		
		// Vendedores
		DbSelectArea('TRB')
		DbGotop()		

		While TRB->(!Eof())	
			_cVend    := TRB->Vendedor
			_nQtdVend := TRB->Total_QTD
			_nTotVend := TRB->Total_Reais
			
			_cCorpoM += '  <hr width=100% noshade>'
			_cCorpoM += '  <p class="style1"><strong>Vendedor : </strong>'+AllTrim(Posicione("SA3",1,xFilial("SA3")+_cVend,"A3_NOME"))+'</p>'
	
			_cCorpoM += '  <table width="1300" border="1" align="left"> '
			
			_cCorpoM += '    <tr>
			If Empty(_cGrupo)
				_cCorpoM += '      <td align="left" width="300"><span class="style3">Grupo</span></td>'
				_cCorpoM += '      <td align="center" width="250"><span class="style3">Quantidade</span></td>'	
				_cCorpoM += '      <td align="center" width="250"><span class="style3">Quant %</span></td>'
				_cCorpoM += '      <td align="center" width="250"><span class="style3">Valor R$</span></td>'
				_cCorpoM += '      <td align="center" width="250"><span class="style3">Valor %</span></td>'
			Else
				_cCorpoM += '      <td align="left" width="500"><span class="style3">Produto</span></td>'
				_cCorpoM += '      <td align="center" width="200"><span class="style3">Quantidade</span></td>'	
				_cCorpoM += '      <td align="center" width="200"><span class="style3">Quant %</span></td>'
				_cCorpoM += '      <td align="center" width="200"><span class="style3">Valor R$</span></td>'
				_cCorpoM += '      <td align="center" width="200"><span class="style3">Valor %</span></td>'
			EndIF
			_cCorpoM += '    </tr>'

			While TRB->(!Eof()) .And. TRB->Vendedor == _cVend
			
				_cCorpoM += '    <tr>'
				If Empty(_cGrupo)
					_cCorpoM += '     <td align="left"><span>'+TRB->Grupo+'</span></td>' 		
				Else
					_cCorpoM += '     <td align="left"><span>'+TRB->Produto+'</span></td>' 		
				Endif
				_cCorpoM += '	   <td align="right"><span>'+Transform(TRB->QTD,   _cPctQtd)+'</span></td>'
				_cCorpoM += '	   <td align="right"><span>'+Transform(TRB->QTD/TRB->Total_QTD*100, _cD2Total)+'%</span></td>'						
				_cCorpoM += '	   <td align="right"><span>'+Transform(TRB->Reais, _cD2Total)+'</span></td>'
				_cCorpoM += '	   <td align="right"><span>'+Transform(TRB->Reais/TRB->Total_Reais*100, _cD2Total)+'%</span></td>'						
				_cCorpoM += '    </tr>'
				
				TRB->(dbSkip())
				If !_lSchedule
					_oProcess:IncRegua1()
				Endif
			EndDo
			
			_cCorpoM += '    <tr>
			_cCorpoM += '      <td align="right"><span class="style3">Total:</span></td>'
			_cCorpoM += '      <td align="right"><span class="style3">'+Transform(_nQtdVend, _cPctQtd)+'</span></td>'
			_cCorpoM += '      <td align="right"><span class="style3">100%</span></td>'
			_cCorpoM += '      <td align="right"><span class="style3">' +Transform(_nTotVend, _cD2Total)+'</span></td>'	
			_cCorpoM += '      <td align="right"><span class="style3">100%</span></td>'
			_cCorpoM += '    </tr>'
			
			_cCorpoM += '  </table>'
			
			_cCorpoM += '  <br>'
			
		EndDo
		
	ElseIf _cRegiao == 'VENDEDORES'
	
		While TRB->(!Eof())
			_cCorpoM  := ""	
			_cVend    := TRB->Vendedor
			_nQtdVend := TRB->Total_QTD
			_nTotVend := TRB->Total_Reais
			
			_cCorpoM += '<html>' 
			_cCorpoM += '<head>'
			_cCorpoM += '<title>'+_cTitulo+'</title>'
			_cCorpoM += '<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">' 
			_cCorpoM += '<style type="text/css">'
			_cCorpoM += '<!--'
			_cCorpoM += '.style1 {font-family: Arial, Helvetica, sans-serif}'
			_cCorpoM += '.style3 {font-family: Arial, Helvetica, sans-serif; font-weight: bold; }'
			_cCorpoM += '.style4 {color: #FF0000}'
			_cCorpoM += '-->'
			_cCorpoM += '</style>' 
			_cCorpoM += '</head>' 
			_cCorpoM += '<body>'
			_cCorpoM += '  <p align="center" class="style1"><strong>'+Upper(_cTitulo)+'</strong></p>' 
			If _cDataDe == Date() .And. _cDataAte = Date()
				_cCorpoM += '  <p class="style1"><strong>Data: </strong>'+DtoC(Date())+'</p>'
			Else
				_cCorpoM += '  <p class="style1"><strong>Data de: </strong>'+DtoC(_cDataDe)+'</p>'
				_cCorpoM += '  <p class="style1"><strong>Data ate: </strong>'+DtoC(_cDataAte)+'</p>'
			Endif
			_cCorpoM += '  <p class="style1"><strong>Hora: </strong>'+Substr(Time(),1,5)+'</p>'
			_cCorpoM += '  <p class="style1"><strong>Filial : </strong>'+SM0->M0_FILIAL+'</p>'
			_cCorpoM += '  <p class="style1"><strong>Regional : </strong>'+AllTrim(Posicione("SA3",1,xFilial("SA3")+_cVend,"A3_REGIAO"))+'</p>'						
			_cCorpoM += '  <p class="style1"><strong>Vendedor : </strong>'+AllTrim(Posicione("SA3",1,xFilial("SA3")+_cVend,"A3_NOME"))+'</p>'
			If !Empty(_cGrupo)
				_cCorpoM += '  <p class="style1"><strong>Grupo : </strong>'+Posicione("SBM",1,xFilial("SBM")+_cGrupo,"BM_DESC")+'</p>'
			Endif
	
			_cCorpoM += '  <table width="1300" border="1" align="left"> '
			
			_cCorpoM += '    <tr>
			If Empty(_cGrupo)
				_cCorpoM += '      <td align="left" width="300"><span class="style3">Grupo</span></td>'
				_cCorpoM += '      <td align="center" width="250"><span class="style3">Quantidade</span></td>'	
				_cCorpoM += '      <td align="center" width="250"><span class="style3">Quant %</span></td>'
				_cCorpoM += '      <td align="center" width="250"><span class="style3">Valor R$</span></td>'
				_cCorpoM += '      <td align="center" width="250"><span class="style3">Valor %</span></td>'
			Else
				_cCorpoM += '      <td align="left" width="500"><span class="style3">Produto</span></td>'
				_cCorpoM += '      <td align="center" width="200"><span class="style3">Quantidade</span></td>'	
				_cCorpoM += '      <td align="center" width="200"><span class="style3">Quant %</span></td>'
				_cCorpoM += '      <td align="center" width="200"><span class="style3">Valor R$</span></td>'
				_cCorpoM += '      <td align="center" width="200"><span class="style3">Valor %</span></td>'
			EndIF
			_cCorpoM += '    </tr>'

			While TRB->(!Eof()) .And. TRB->Vendedor == _cVend
				_cCorpoM += '    <tr>'
				If Empty(_cGrupo)
					_cCorpoM += '     <td align="left"><span>'+TRB->Grupo+'</span></td>' 		
				Else
					_cCorpoM += '     <td align="left"><span>'+TRB->Produto+'</span></td>' 		
				Endif
				_cCorpoM += '	   <td align="right"><span>'+Transform(TRB->QTD,   _cPctQtd)+'</span></td>'
				_cCorpoM += '	   <td align="right"><span>'+Transform(TRB->QTD/_nQtdVend*100, _cD2Total)+'%</span></td>'						
				_cCorpoM += '	   <td align="right"><span>'+Transform(TRB->Reais, _cD2Total)+'</span></td>'
				_cCorpoM += '	   <td align="right"><span>'+Transform(TRB->Reais/_nTotVend*100, _cD2Total)+'%</span></td>'						
				_cCorpoM += '    </tr>'
				
				TRB->(dbSkip())
				If !_lSchedule
					_oProcess:IncRegua1()
				Endif
			EndDo
			
			_cCorpoM += '    <tr>
			_cCorpoM += '      <td align="right"><span class="style3">Total:</span></td>'
			_cCorpoM += '      <td align="right"><span class="style3">'+Transform(_nQtdVend, _cPctQtd)+'</span></td>'
			_cCorpoM += '      <td align="right"><span class="style3">100%</span></td>'
			_cCorpoM += '      <td align="right"><span class="style3">' +Transform(_nTotVend, _cD2Total)+'</span></td>'	
			_cCorpoM += '      <td align="right"><span class="style3">100%</span></td>'
			_cCorpoM += '    </tr>'
		
			_cCorpoM += '  </table>'
			
			_cCorpoM += '</body>' 
			_cCorpoM += '</html>'
			
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
			                                                                 
			_cMailTo := Posicione("SA3",1,xFilial("SA3")+_cVend,"A3_EMAIL")

			If !Empty(_cMailTo)
				// MHDEnvMail(cPara,cCC,cBCC,cAssunto,cCorpo,cAttach)
				U_MHDEnvMail(_cMailTo,"","fernando.nogueira@avantled.com.br",_cSubject,_cCorpoM,"")
			EndIf
			
		EndDo
	
	Endif


	If _cRegiao <> 'VENDEDORES'

		_cCorpoM += '</body>' 
		_cCorpoM += '</html>'
		
		If _cRegiao $ "DIRETORIA.GERAL" .And. !Empty(_cGrupo)
			_cSubject := _cTitulo+" - Geral - "+AllTrim(Posicione("SBM",1,xFilial("SBM")+AllTrim(_cGrupo),"BM_DESC"))+" ["+DTOC(Date())+"]"
		ElseIf _cRegiao $ "DIRETORIA.GERAL"
			_cSubject := _cTitulo+" - Geral ["+DTOC(Date())+"]"
		ElseIf _cRegiao $ _cRegionais .And. !Empty(_cGrupo)
			_cSubject := _cTitulo+" - Regional "+_cRegiao+" - "+AllTrim(Posicione("SBM",1,xFilial("SBM")+AllTrim(_cGrupo),"BM_DESC"))+" ["+DTOC(Date())+"]"
		ElseIf _cRegiao $ _cRegionais
			_cSubject := _cTitulo+" - Regional "+_cRegiao+" ["+DTOC(Date())+"]"
		Endif
		
		If !Empty(_cCorpoM)
			//MHDEnvMail(cPara,cCC,cBCC,cAssunto,cCorpo,cAttach)
			If Empty(_cEmail)
				If _cRegiao $ "DIRETORIA.GERAL"
					_lReturn :=	U_MHDEnvMail(SepEmail(_cString,_cRegiao), _cEmailCC, "fernando.nogueira@avantled.com.br",_cSubject,_cCorpoM,"")
				Else
					_lReturn := U_MHDEnvMail(SepEmail(_cString,_cRegiao), SepEmail(_cString,"GERAL")+";"+_cEmailCC, "fernando.nogueira@avantled.com.br",_cSubject,_cCorpoM,"")
				Endif
			Else
				_lReturn := U_MHDEnvMail(_cEmail, _cEmailCC, "fernando.nogueira@avantled.com.br",_cSubject,_cCorpoM,"")
			Endif
		Endif
		
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
Static Function SepEmail(_cString,_cRegiao)

Local _cTarget   := _cRegiao + "@"
Local _nDe       := At(_cTarget,_cString)+Len(_cTarget)
Local _nAte      := 6
Local _cVendedor := Substr(_cString,_nDe,_nAte)
Local _cEmail    := Posicione("SA3",1,xFilial("SA3")+_cVendedor,"A3_EMAIL")

Return _cEmail