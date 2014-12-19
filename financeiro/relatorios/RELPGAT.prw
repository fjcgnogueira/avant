#INCLUDE "Protheus.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ RELPGAT  º Autor ³ Amedeo D. P. Filho º Data ³  28/03/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Relatorio de titulos em atraso com juros / Posicao         º±±
±±º          ³ do contas a Receber.                                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico AVANT.                                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function RELPGAT()

	Local oReport

	oReport:=ReportDef()
	oReport:PrintDialog()

Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Definicoes do Relatorio                    	³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function ReportDef()

	Local oReport
	Local cTitulo 	:= "Relatorio de Titulos a Receber (Avant)"
	Local cDescri 	:= "Imprime relatorio de Titulos a Receber (Avant)"
	Local aOrdem	:= {"Filial + Cliente", "Filial + Vencimento", "Filial + Regiao", "Filial + Vendedor"}
	Local cPerg   	:= "RELGRPVEN"

	AjustaSX1(@cPerg)	
	
	Pergunte(cPerg,.F.)
	
	oReport := TReport():New("RELGRPVEN",cTitulo,cPerg,{|oReport| ReportPrint(oReport)},cDescri)
	oReport:SetLandscape()
	
	/*
	Definicoes do Relatorio
	1 - Nro. da nota
	2 - Emissão
	3 - Vencimento 
	4 - Valor 
	5 - Codigo
	6 - Nome de Cliente
	7 - Data de pagamento
	8 - Dias de atraso
	9 - Campo para cálculo de juros 
	*/

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³  Secao 1 - Titulos       	  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oSection1 	:= TRSection():New(oReport,"Titulos",{"SE1"},aOrdem,/*Campos do SX3*/,/*Campos do SIX*/)	
	
	TRCell():New(oSection1,"E1_FILIAL"		,"SE1"	,/*Titulo*/			,/*Mascara*/,/*Tamanho*/	,/*lPixel*/	,/*bBlock*/	 	 )
	TRCell():New(oSection1,"E1_NUM"			,"SE1"	,/*Titulo*/			,/*Mascara*/,/*Tamanho*/	,/*lPixel*/	,/*bBlock*/	  	 )
	TRCell():New(oSection1,"E1_PARCELA"		,"SE1"	,/*Titulo*/			,/*Mascara*/,/*Tamanho*/	,/*lPixel*/	,/*bBlock*/	 	 )
	TRCell():New(oSection1,"E1_VENCREA"		,"SE1"	,/*Titulo*/			,/*Mascara*/,13  				,/*lPixel*/	,/*bBlock*/	 	 )
	TRCell():New(oSection1,"E1_VALOR"		,"SE1"	,/*Titulo*/			,/*Mascara*/,/*Tamanho*/	,/*lPixel*/	,/*bBlock*/	 	 )
	TRCell():New(oSection1,"E1_SALDO"		,"SE1"	,/*Titulo*/			,/*Mascara*/,/*Tamanho*/	,/*lPixel*/	,/*bBlock*/	 	 )
	TRCell():New(oSection1,"E1_CLIENTE"		,"SE1"	,/*Titulo*/			,/*Mascara*/,/*Tamanho*/	,/*lPixel*/	,/*bBlock*/	 	 )
	TRCell():New(oSection1,"E1_LOJA"			,"SE1"	,/*Titulo*/			,/*Mascara*/,/*Tamanho*/	,/*lPixel*/	,/*bBlock*/	 	 )
	TRCell():New(oSection1,"A1_NOME"			,"SA1"	,/*Titulo*/			,/*Mascara*/,/*Tamanho*/	,/*lPixel*/	,/*bBlock*/	 	 )
	TRCell():New(oSection1,"E1_REGIAO"		,"SE1"	,"Reg."				,/*Mascara*/,/*Tamanho*/	,/*lPixel*/	,/*bBlock*/	 	 )
	TRCell():New(oSection1,"A3_NOME"			,""		, "Vendedor"		,/*Mascara*/,35				,/*lPixel*/	,/*bBlock*/	 	 )
	TRCell():New(oSection1,"E1_BAIXA"		,"SE1"	,/*Titulo*/			,/*Mascara*/,13				,/*lPixel*/	,/*bBlock*/	 	 )
	TRCell():New(oSection1,"DIASATRASO"		,""   	, "Dias Atr."		,/*Mascara*/,/*Tamanho*/	,/*lPixel*/	,/*bBlock*/	 	 )
	TRCell():New(oSection1,"JUROSCALC"		,""		, "Jrs.Calc"		,/*Mascara*/,/*Tamanho*/	,/*lPixel*/	,/*bBlock*/	 	 )
	TRCell():New(oSection1,"TOTJUROS"		,""		, "Total C/Jrs"	,/*Mascara*/,/*Tamanho*/	,/*lPixel*/	,/*bBlock*/	 	 )
	TRCell():New(oSection1,"DESP_BANCO"		,""		, "Dsp.Bco"			,/*Mascara*/,/*Tamanho*/	,/*lPixel*/	,/*bBlock*/	 	 )
	TRCell():New(oSection1,"DESP_CARTORIO"	,""		, "Dsp.Cart"		,/*Mascara*/,/*Tamanho*/	,/*lPixel*/	,/*bBlock*/	 	 )
	
Return oReport                                                                              
	
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³  Function ReportPrint	      			    	³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function ReportPrint(oReport)
	Local oBreak	:= Nil
	Local oBreak1	:= Nil
	Local oSection1	:= oReport:Section(1)
	Local aQuery	:= {}
	Local aFiliais	:= {}
	Local cFilAtu	:= ""
	Local cWhere	:= ""
	Local cOrder	:= ""
	Local nTotJrs	:= 0
	Local nDiasAt	:= 0
	Local nOrdem	:= oSection1:GetOrder()
	Local cAlias

	oReport:Section(1):BeginQuery()	

	cAlias := GetNextAlias()

	cWhere := "% "
	cWhere += " E1_FILIAL BETWEEN '"+MV_PAR12+"' AND '"+MV_PAR13+"'"
	cWhere += " AND E1_VENCREA BETWEEN '"+DtoS(MV_PAR01)+"' AND '"+DtoS(MV_PAR02)+"'"
	cWhere += " AND E1_EMISSAO BETWEEN '"+DtoS(MV_PAR03)+"' AND '"+DtoS(MV_PAR04)+"'"
	cWhere += " AND E1_CLIENTE BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR07+"'"
	cWhere += " AND E1_LOJA BETWEEN '"+MV_PAR06+"' AND '"+MV_PAR08+"'"
	cWhere += " %"

	If nOrdem == 1
		cOrder	:= "% FILIAL, CLIENTE %"
		oBreak := TRBreak():New(oSection1, {|| (cAlias)->FILIAL + (cAlias)->CLIENTE}, {|| "Total do Cliente" })
	ElseIf nOrdem == 2
		cOrder	:= "% FILIAL, VENCIMENTO %"
		oBreak := TRBreak():New(oSection1, {|| (cAlias)->FILIAL + DtoS((cAlias)->VENCIMENTO)}, {|| "Total por Vencimento" })
	ElseIf nOrdem == 3
		cOrder	:= "% FILIAL, REGIAO %"
		oBreak := TRBreak():New(oSection1, {|| (cAlias)->FILIAL + (cAlias)->REGIAO}, {|| "Total por Região" })
	ElseIf nOrdem == 4
		cOrder	:= "% FILIAL, VENDEDOR %"
		oBreak := TRBreak():New(oSection1, {|| (cAlias)->FILIAL + (cAlias)->VENDEDOR}, {|| "Total por Vendedor" })
	EndIf

	TRFunction():New(oSection1:Cell("E1_VALOR")		, NIL, "SUM",oBreak	, ""	,	, /*bBlock*/, .F./*lEndSection*/	,.F./*lEndReport*/	,.F./*lEndPage*/)
	TRFunction():New(oSection1:Cell("E1_SALDO")		, NIL, "SUM",oBreak	, ""	, 	, /*bBlock*/, .F./*lEndSection*/	,.F./*lEndReport*/	,.F./*lEndPage*/)
	TRFunction():New(oSection1:Cell("JUROSCALC")		, NIL, "SUM",oBreak	, ""	, 	, /*bBlock*/, .F./*lEndSection*/	,.F./*lEndReport*/	,.F./*lEndPage*/)
	TRFunction():New(oSection1:Cell("TOTJUROS")		, NIL, "SUM",oBreak	, ""	, 	, /*bBlock*/, .F./*lEndSection*/	,.F./*lEndReport*/	,.F./*lEndPage*/)
	TRFunction():New(oSection1:Cell("DESP_BANCO")	, NIL, "SUM",oBreak	, ""	, 	, /*bBlock*/, .F./*lEndSection*/	,.F./*lEndReport*/	,.F./*lEndPage*/)
	TRFunction():New(oSection1:Cell("DESP_CARTORIO"), NIL, "SUM",oBreak	, ""	, 	, /*bBlock*/, .F./*lEndSection*/	,.F./*lEndReport*/	,.F./*lEndPage*/)

	BeginSql Alias cAlias
		Column VENCIMENTO 	As Date
		Column BAIXA 		As Date
		
		SELECT FILIAL, TITULO, SERIE, PARCELA, VENCIMENTO, VALOR, SALDO, CLIENTE, LOJA, NOMECLI, ESTADO, REGIAO, BAIXA, VENDEDOR, 
				NOMEVEN, DIASATRASO, JRCALC, SUM(DESP_BANCO) DESP_BANCO, SUM(DESP_CARTORIO) DESP_CARTORIO 
		FROM
		( SELECT	E1_FILIAL	FILIAL
		,		E1_NUM		TITULO
		,		E1_SERIE 	SERIE
		,		E1_PARCELA	PARCELA
		,		E1_VENCREA	VENCIMENTO
		,		E1_VALOR		VALOR
		,		E1_SALDO		SALDO
		,		E1_CLIENTE	CLIENTE
		,		E1_LOJA		LOJA
		,		A1_NOME		NOMECLI
		,		A1_EST		ESTADO
		,		E1_REGIAO	REGIAO
		,		E1_BAIXA		BAIXA
		,		E1_VEND1		VENDEDOR
		,		A3_NOME		NOMEVEN
		,		DATEDIFF(day, E1_VENCTO  ,GETDATE()) AS DIASATRASO
		,		(((E1_VALOR * %Exp:MV_PAR11%)/100)/30) * (	DATEDIFF(day, E1_VENCTO  ,GETDATE())) 	AS JRCALC
		,		CASE WHEN SUM(E5_VALOR) IS NULL THEN 0 ELSE 
					CASE WHEN E5_HISTOR IN ('ALTERACAO DE TITULO','BAIXA CONFIRMADA','BAIXA POR DEVOLUCAO','BAIXA SIMPLES','ENTRADA CONFIRMADA','LIQUIDACAO NORMAL','TARIFA MANUTENCAO TITULO','TARIFA SOBRE TITULO VENCIDO') THEN SUM(E5_VALOR) ELSE 0 END 
				END DESP_BANCO
		, 		CASE WHEN SUM(E5_VALOR) IS NULL THEN 0 ELSE 
					CASE WHEN E5_HISTOR IN ('BAIXA POR PROTESTO','BAIXADO POR PROTESTO','CUSTAS DE PROTESTO','CUSTAS DE SUSTACAO PROTESTO','ENTRADA DE TITULO EM CARTORIO','ENVIADO A CARTORIO','ESTORNO DE PROTESTO','SUSTACAO DE PROTESTO','TITULO ENVIADO PARA CARTORIO') THEN SUM(E5_VALOR) ELSE 0 END 
				END DESP_CARTORIO
		FROM	%Table:SE1% SE1
		INNER JOIN %Table:SA1% SA1 ON E1_CLIENTE+E1_LOJA = A1_COD+A1_LOJA AND SA1.%NotDel%
		LEFT	JOIN %Table:SA3% SA3 ON E1_VEND1 = A3_COD AND SA3.%NotDel%
		LEFT	JOIN %Table:SE5% SE5 ON E1_FILIAL+E1_NUM+E1_SERIE+E1_PARCELA+E1_CLIENTE+E1_LOJA = E5_FILIAL+E5_NUMERO+E5_PREFIXO+E5_PARCELA+E5_CLIFOR+E5_LOJA AND E5_NATUREZ = 'DESP BANC' AND SE5.%NotDel%
		WHERE	SE1.%NotDel%
			AND   DATEDIFF(day, E1_VENCTO  ,GETDATE()) > 0 
	   	AND   E1_TIPO = 'NF' 
	   	AND 	E1_SALDO > 0
			AND	%Exp:cWhere% 
		GROUP BY E1_FILIAL, E1_NUM, E1_SERIE, E1_PARCELA, E1_CLIENTE, E1_LOJA, E1_VENCREA, E1_VALOR, E1_SALDO, E1_BAIXA, E1_VEND1, E1_REGIAO, E1_VENCTO, A1_NOME, A1_EST, A3_NOME, E5_HISTOR ) TITULOS
		GROUP BY FILIAL, TITULO, SERIE, PARCELA, VENCIMENTO, VALOR, SALDO, CLIENTE, LOJA, NOMECLI, ESTADO, REGIAO, BAIXA, VENDEDOR, NOMEVEN, DIASATRASO, JRCALC
		ORDER BY %Exp:cOrder%
		
	EndSQL

	aQuery := GetLastQuery()
	
	aAreaM0 := SM0->(GetArea())
	DbSelectarea("SM0")
	SM0->(DbGotop())
	While !SM0->(Eof())
		If SM0->M0_CODIGO == cEmpAnt
			If Alltrim(MV_PAR12) <= Alltrim(SM0->M0_CODFIL) .And. Alltrim(SM0->M0_CODFIL) <= Alltrim(MV_PAR13)
				Aadd( aFiliais, {	SM0->M0_CODFIL,;
									SM0->M0_FILIAL} )
			EndIf
		EndIf
		SM0->(DbSkip())
	End
	RestArea(aAreaM0)
	
	oReport:Section(1):EndQuery()	

	DbSelectArea((cAlias))
	oReport:SetMeter(RecCount())
	oSection1:Init()
	While !oReport:Cancel() .And. !Eof()

		nPosFil	:= Ascan(aFiliais,{|x| Alltrim(x[01]) == Alltrim((cAlias)->FILIAL)})
		nTotJrs	:= NoRound((cAlias)->SALDO + (cAlias)->JRCALC,2)
		cFilAtu	:= ""
		nDiasAt	:= 0
		
		If nPosFil > 0
			cFilAtu	:= aFiliais[nPosFil][02]
		EndIf
		
		If (cAlias)->VENCIMENTO < dDatabase
			nDiasAt	:= dDatabase - (cAliaS)->VENCIMENTO
		EndIf
			
		If MV_PAR09 == 2
			If nDiasAt < MV_PAR10
				(cAlias)->(DbSkip())
				Loop
			EndIf
		EndIf

		oSection1:Cell("E1_FILIAL"	):SetBlock({|| cFilAtu 				   	})
		oSection1:Cell("E1_NUM"		):SetBlock({|| (cAlias)->TITULO 		})
		oSection1:Cell("E1_PARCELA"	):SetBlock({|| (cAlias)->PARCELA 	})
		oSection1:Cell("E1_VENCREA"	):SetBlock({|| (cAlias)->VENCIMENTO})
		oSection1:Cell("E1_VALOR"	):SetBlock({|| (cAlias)->VALOR 	   	})
		oSection1:Cell("E1_SALDO"	):SetBlock({|| (cAlias)->SALDO 	   	})
		oSection1:Cell("E1_CLIENTE"	):SetBlock({|| (cAlias)->CLIENTE 	})
		oSection1:Cell("E1_LOJA"	):SetBlock({|| (cAlias)->LOJA 			})
		oSection1:Cell("A1_NOME"	):SetBlock({|| (cAlias)->NOMECLI 		})
		oSection1:Cell("E1_REGIAO"	):SetBlock({|| (cAlias)->REGIAO 		})
		oSection1:Cell("E1_BAIXA"	):SetBlock({|| (cAlias)->BAIXA			})
		oSection1:Cell("A3_NOME"	):SetBlock({|| (cAlias)->NOMEVEN		})
		oSection1:Cell("DIASATRASO"	):SetBlock({|| nDiasAt 					})
		oSection1:Cell("JUROSCALC"	):SetBlock({|| (cAlias)->JRCALC	   	})
		oSection1:Cell("TOTJUROS"	):SetBlock({|| nTotJrs			   		})
		oSection1:Cell("DESP_BANCO"):SetBlock({|| (cAlias)->DESP_BANCO	})
		oSection1:Cell("DESP_CARTORIO"):SetBlock({|| (cAlias)->DESP_CARTORIO})		

		oSection1:PrintLine()
		
		(cAlias)->(DbSkip())
	Enddo
	oSection1:Finish()

	(cAlias)->(DbCloseArea())
	
Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³  Function AjustaSX1  	      					³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function AjustaSX1(cPerg)

	Local nXX	:= 0
	Local aPerg	:= {}
	
	cPerg := PADR(cPerg,10)
	
	aAdd( aPerg, {"Vencimento De?"				, "D", 08, 00, "G", ""		, ""	, ""	, "", "", "" 	} )
	aAdd( aPerg, {"Vencimento Ate?"				, "D", 08, 00, "G", ""		, ""	, ""	, "", "", "" 	} )
	aAdd( aPerg, {"Emissão De?"					, "D", 08, 00, "G", ""		, ""	, ""	, "", "", "" 	} )
	aAdd( aPerg, {"Emissão Ate?"			  		, "D", 08, 00, "G", ""		, ""	, ""	, "", "", "" 	} )
	aAdd( aPerg, {"Do Cliente?"					, "C", 06, 00, "G", ""		, ""	, ""	, "", "", "SA1"	} )
	aAdd( aPerg, {"Da Loja?"						, "C", 02, 00, "G", ""		, ""	, ""	, "", "", ""	} )
	aAdd( aPerg, {"Até Cliente?"					, "C", 06, 00, "G", ""		, ""	, ""	, "", "", "SA1"	} )
	aAdd( aPerg, {"Até Loja?"		 				, "C", 02, 00, "G", ""		, ""	, ""	, "", "", ""	} )
	aAdd( aPerg, {"Considera Dias de atraso?"	, "C", 01, 00, "C", "Não"	, "Sim"	, ""	, "", "", "" 	} )
	aAdd( aPerg, {"Vencidos a mais de (Dias)?", "N", 03, 00, "G", ""		, ""	, ""	, "", "", ""	} )
	aAdd( aPerg, {"% de Juros?"					, "N", 03, 00, "G", ""		, ""	, ""	, "", "", ""	} )
	aAdd( aPerg, {"Da Filial?"				  		, "C", 06, 00, "G", ""		, ""	, ""	, "", "", ""	} )
	aAdd( aPerg, {"Até Filial?"					, "C", 06, 00, "G", ""		, ""	, ""	, "", "", ""	} )

	For nXX := 1 To Len(aPerg)
		If !SX1->(Dbseek( cPerg + StrZero(nXX, 2)))
			Reclock("SX1",.T.)
			SX1->X1_GRUPO 		:= cPerg
			SX1->X1_ORDEM		:= StrZero(nXX, 2)
			SX1->X1_VARIAVL		:= "mv_ch" + Chr( nXX +96 )
			SX1->X1_VAR01		:= "mv_par" + StrZero(nXX,2)
			SX1->X1_PRESEL		:= 1
			SX1->X1_PERGUNT		:= aPerg[ nXX , 01 ]
			SX1->X1_TIPO 		:= aPerg[ nXX , 02 ]
			SX1->X1_TAMANHO		:= aPerg[ nXX , 03 ]
			SX1->X1_DECIMAL		:= aPerg[ nXX , 04 ]
			SX1->X1_GSC  		:= aPerg[ nXX , 05 ]
			SX1->X1_DEF01		:= aPerg[ nXX , 06 ]
			SX1->X1_DEF02		:= aPerg[ nXX , 07 ]
			SX1->X1_DEF03		:= aPerg[ nXX , 08 ]
			SX1->X1_DEF04		:= aPerg[ nXX , 09 ]
			SX1->X1_DEF05		:= aPerg[ nXX , 10 ]
			SX1->X1_F3   		:= aPerg[ nXX , 11 ]
			SX1->(MsUnlock())
		EndIf
	Next nXX
Return Nil