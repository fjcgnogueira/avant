#Include 'Protheus.ch'
#Include 'Totvs.ch'

User Function LISTATIT(_cFil ,_cCli, _cLoja, _cRazao)

Local oDlg      := Nil
Local oTSay1    := Nil
Local oTSay2    := Nil
Local oTSay3    := Nil
Local oTSay4    := Nil
Local oTSay5    := Nil
Local oTSay6    := Nil
Local oTSay7    := Nil
Local oTSay8    := Nil
Local oTSay9    := Nil
Local oTSay10   := Nil
Local oTSay11   := Nil
Local oTSay12   := Nil
Local oFonte1   := Nil
Local oFonte2   := Nil
Local oFolder   := Nil
Local oLayer    := Nil
Local oBrowse   := Nil
Local oMenuBa   := Nil
Local oMenuB1   := Nil
Local oMenuB2   := Nil
Local oMenuB3   := Nil
Local oOk       := Nil
Local oNo       := Nil
Local aCabec    := {}
Local aDados    := {}
Local aSpace    := {}

	oOk       := LoadBitmap(GetResources(), 'br_verde'    )
	oNo       := LoadBitmap(GetResources(), 'br_vermelho' )
	oFonte1   := TFont()  :New( , , -11, , .T., , , , , , )
	oFonte2   := TFont()  :New( , , -15, , .T., , , , , , )
	oLayer    := FWLayer():New()
	aCabec    := {'' , 'Filial', 'Documento', 'Parcela', 'Valor', 'Emissao', 'Vencimento', 'Vencimento Real', 'Baixa',;
				 'Numero no Banco', 'Conta', 'ID Cnab'}
	aSpace    := {020, 060, 060, 060, 060, 060, 060, 060, 060, 060, 060, 060}
	
	oDlg   := MSDialog():New(180, 180, 580, 900, 'Historico de Transacoes do Cliente', , , , , CLR_BLACK, CLR_WHITE, , , .T.)
	
		oMenuBa   := TBar():New(oDlg, 035, 040, .T., , , , .F.)
			oMenuB1 := TBtnBmp2():New(002, 002, 026, 026, 'discount' , , , , {||oDlg:End()}, oMenuBa, , , .T., )  
			oMenuB2 := TBtnBmp2():New(002, 010, 026, 026, 'copyuser', , , , {||U_HISTCNAB()}, oMenuBa, , , .T., )  			

		aDados   := LOADTIT(_cCli, _cLoja)
		
		If(Len(aDados) < 1)
			
			AADD(aDados, {.T., '', '', '', '' , '', '', '' , '', '', '', ''})
		
		EndIf
					
		//INICIALIZA O OBJETO LAYER COM O BOTAO DE FECHAR DESABILITADO.
		oLayer:Init(oDlg, .F.)
		//ADICIONA AS LINHAS DO OBEJETO LAYER.
		oLayer:AddLine('L1', 025, .F.)
		
		//ADICIONA AS COLUNAS DO OBEJETO LAYER.
		oLayer:AddCollumn('C1_L1', 100, .F., 'L1')
		
		//ADICIONA AS JANELAS DO OBJETO LAYER
		oLayer:AddWindow('C1_L1', 'W1_C1_L1', 'INFORMACOES REFERENTE AO CLIENTE SELECIONADO', 100, .F., .F., , 'L1', )
		
		//INICIALIZA CADA JANELA NO SEU RESPECTIVO LUGAR.
		W1_C1_L1   := oLayer:GetWinPanel('C1_L1', 'W1_C1_L1', 'L1')
		
			oTSay1    := TSay():New(005, 005, {|| 'Cliente'} , W1_C1_L1, /*[ cPicture]*/, oFonte1, , , , .T. , /*[ nClrText]*/, /*[ nClrBack]*/, /*[ nWidth]*/,;
								/*[ nHeight]*/, , , , , , .F.)
			oTSay2    := TSay():New(005, 100, {|| 'Loja'}   , W1_C1_L1, /*[ cPicture]*/, oFonte1, , , , .T. , /*[ nClrText]*/, /*[ nClrBack]*/, /*[ nWidth]*/,;
								/*[ nHeight]*/, , , , , , .F.)
			oTSay3    := TSay():New(005, 180, {|| 'Razão Social'}  , W1_C1_L1, /*[ cPicture]*/, oFonte1, , , , .T. , /*[ nClrText]*/, /*[ nClrBack]*/, /*[ nWidth]*/,;
								/*[ nHeight]*/, , , , , , .F.)														
			oTSay4    := TSay():New(011, 005, {|| CVALTOCHAR(_cCli)}  , W1_C1_L1, /*[ cPicture]*/, oFonte2, , , , .T. , 3788455        , /*[ nClrBack]*/, /*[ nWidth]*/,;
								/*[ nHeight]*/, , , , , , .F.)
			oTSay5    := TSay():New(011, 100, {|| CVALTOCHAR(_cLoja)}        , W1_C1_L1, /*[ cPicture]*/, oFonte2, , , , .T. , 3788455        , /*[ nClrBack]*/, /*[ nWidth]*/,;
								/*[ nHeight]*/, , , , , , .F.)							
			oTSay6    := TSay():New(011, 180, {|| CVALTOCHAR(_cRazao)} , W1_C1_L1, /*[ cPicture]*/, oFonte2, , , , .T. , 3788455        , /*[ nClrBack]*/, /*[ nWidth]*/,;
								/*[ nHeight]*/, , , , , , .F.)
																																						
		oFolder   := TFolder():New(065, 005, {'TITULOS'},, oDlg, , ,16777215 , .T., , 352, 100, , )
			oBrowse   := TWBrowse():New(005 , 005, 340, 077, , aCabec, aSpace, oFolder:aDialogs[1], , , , , {||}, , , , , , , .F. , , .T., , .F., , .T., .T.)
				oBrowse:SetArray(aDados)
				oBrowse:bLine   := {||{IIF(aDados[oBrowse:nAt][1], oOk, oNo), aDados[oBrowse:nAt][2], aDados[oBrowse:nAt][3], aDados[oBrowse:nAt][4],;
										aDados[oBrowse:nAt][5], aDados[oBrowse:nAt][6], aDados[oBrowse:nAt][7], aDados[oBrowse:nAt][8],;
										aDados[oBrowse:nAt][9], aDados[oBrowse:nAt][10], aDados[oBrowse:nAt][11], aDados[oBrowse:nAt][12] } }
				// Troca a imagem no duplo click do mouse
				//oBrowse:bLDblClick   := {|| aDados[oBrowse:nAt][1] := !aDados[oBrowse:nAt][1], oBrowse:DrawSelect()}
				
	//DBSELECTAREA('SEB')

	oDlg:Activate()

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ LOADTIT  | Autor ³ Thiago S. Joaquim     ³ Data ³ 25/06/2012 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Locacao   ³                  ³Contato ³ thiago.joaquim@mpsiga.com.br     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Carrega os Titulos do Cliente.                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ _cClien: Codigo do Cliente.                                  ³±±
±±³          ³ _cLojaC: Loja do Cliente.                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ aTitul: Array com os Titulos do Cliente.                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Aplicacao ³ Historico de registro do Titulo junto ao Banco.              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Generico.                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Analista Resp.³  Data  ³ Bops ³ Manutencao Efetuada                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³              ³  /  /  ³      ³                                          ³±±
±±³              ³  /  /  ³      ³                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function LOADTIT(_cClien, _cLojaC)

Local cQuery    := ''
Local cTrb      := '_SE1'
Local cIndTrb   := 'E1_NUM'
Local cNomAr    := ''
Local aEstru    := {}
Local aTitul    := {}

	AADD(aEstru, {'E1_FILIAL' , 'C', 06, 0     })
	AADD(aEstru, {'E1_NUM'    , 'C', 09, 0     })
	AADD(aEstru, {'E1_PARCELA', 'C', 02, 0     })
	AADD(aEstru, {'E1_VALOR'  , 'N', 17, 2     })	
	AADD(aEstru, {'E1_EMISSAO', 'D', 08, 0     })
	AADD(aEstru, {'E1_VENCTO' , 'D', 08, 0     })
	AADD(aEstru, {'E1_VENCREA', 'D', 08, 0     })
	AADD(aEstru, {'E1_BAIXA'  , 'D', 08, 0     })
	AADD(aEstru, {'E1_NUMBCO' , 'C', 20, 0     })	
	AADD(aEstru, {'E1_CONTA'  , 'C', 10, 0     })	
	AADD(aEstru, {'E1_IDCNAB' , 'C', 10, 0     })		
	
	cQuery   := ""
	cQuery   += " SELECT SE1.E1_FILIAL, SE1.E1_NUM, SE1.E1_PARCELA, SE1.E1_VALOR, SE1.E1_EMISSAO, SE1.E1_VENCTO, SE1.E1_VENCREA, SE1.E1_BAIXA, "
	cQuery   += " SE1.E1_NUMBCO, SE1.E1_CONTA, SE1.E1_IDCNAB "
	cQuery   += " FROM " + RetSqlName('SE1') + " SE1, " + RetSqlName('SF2') + " SF2 "
	cQuery   += " WHERE "
	cQuery   += " SE1.E1_FILIAL = '" + xFilial('SE1') + "' "
	cQuery   += " AND SE1.E1_CLIENTE = '" + _cClien + "' "
	cQuery   += " AND SE1.E1_LOJA = '" + _cLojaC + "' "		
	cQuery   += " AND SE1.E1_NUM = SF2.F2_DOC "
	cQuery   += " AND SE1.D_E_L_E_T_ = '' "
	cQuery   += " AND SE1.E1_NUMBCO <> '' "
	cQuery   += " AND SF2.D_E_L_E_T_ = '' "
	cQuery   += " ORDER BY SE1.E1_NUM "
	
	MEMOWRITE("C:\TEMP\_SE1.TXT",cQuery)
	
	If (Select(cTrb) > 0)
		
		(cTrb)->(DBCLOSEAREA())
		
	EndIf
		
	cNomAr := CRIATRAB(aEstru, .T.)
	DBUSEAREA(.T.,__LocalDriver, cNomAr, cTrb, .T., .F.)
	SQLTOTRB(cQuery,aEstru,cTrb)
	//CRIA O INDICE PARA O ARQUIVO DE TRABALHO TEMPORARIO.
	Index on (cTrb)->E1_NUM To cTrb//&cNomArq

	If(Select(cTrb) > 0)  
	
		(cTrb)->(DBGoTop())
	
	EndIf
	
	While((cTrb)->(!EOF()))
	
		AADD(aTitul, {;
						IIF(!Empty((cTrb)->E1_BAIXA), .T., .F.),;
						(cTrb)->E1_FILIAL,;
						(cTrb)->E1_NUM,;
						(cTrb)->E1_PARCELA,;
						(cTrb)->E1_VALOR,;
						(cTrb)->E1_EMISSAO,;
						(cTrb)->E1_VENCTO,;
						(cTrb)->E1_VENCREA,;
						(cTrb)->E1_BAIXA,;
						(cTrb)->E1_NUMBCO,;
						(cTrb)->E1_CONTA,;
						(cTrb)->E1_IDCNAB})
		(cTrb)->(DBSkip())
	
	EndDo
		
	(cTrb)->(DBCloseArea())
	
Return aTitul