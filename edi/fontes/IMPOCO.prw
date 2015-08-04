#INCLUDE "Protheus.ch"
#INCLUDE "Totvs.ch"
#INCLUDE "FILEIO.ch"
#INCLUDE "TbiConn.ch"
#INCLUDE "AP5MAIL.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³IMPOCO    º Autor ³ Rogerio Machado    º Data ³  31/07/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Importar Ocorrencias de Transporte                         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Avant                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/


User Function IMPOCO()
	Private tTabOCO				// Tabela temporária do conhecimento
	Private aCamposOCO := {}	// Campos da tabela intermediária de CTRC

	Prepare Environment EMPRESA '01' FILIAL '010104'

	CriaTab()
	Processa({|| Importacao()},"Importando arquivos", "")
	GFEDelTab(tTabOCO)
	
	RESET ENVIRONMENT
	
Return




Static Function CriaTab()

	aCamposOCO := { {"GXL_FILIAL", "C", TamSx3("GWD_FILIAL")[1], 0},;
					{"GXL_NRIMP" , "C", 16, 0},;
					{"GXL_FILOCO", "C", Len(cFilAnt), 0},;
					{"GXL_CDTRP" , "C", 14, 0},;
					{"GXL_DTOCOR", "D", 8 , 0},;
					{"GXL_HROCOR", "C", 5 , 0},;
					{"GXL_FILDC" , "C", Len(cFilAnt), 0},;
					{"GXL_EMISDC", "C", 14, 0},;
					{"GXL_SERDC" , "C", 5 , 0},;
					{"GXL_NRDC"  , "C", 16, 0},;
					{"GXL_CODOCO", "C", 2 , 0},;
					{"GXL_OBS"   , "C", 70, 0},;
					{"GXL_EDISIT", "C", 1,  0},;
					{"GXL_EDIMSG", "M", 10, 0},;
					{"GXL_EDINRL", "N", 5 , 0},;
					{"GXL_EDILIN", "M", 999, 0},;
					{"GXL_EDIARQ", "C", 200, 0},;
					{"GXL_CODOBS", "N", 2 , 0};
				 }
	If GfeVerCmpo({"GXL_CDTIPO"})
		aAdd(aCamposOCO,{"GXL_CDTIPO", "C", TamSx3("GU4_CDTIPO")[1] , 0})
		aAdd(aCamposOCO,{"GXL_CDMOT", "C", TamSx3("GU4_CDMOT")[1] , 0})
	EndIf
	tTabOCO := GFECriaTab({aCamposOCO,{"GXL_FILIAL+GXL_NRIMP"}})


Return




Static Function Importacao()
	Local aDirImpor   := {}		// Array com os arquivos do diretorio
	Local nCountFiles := 0  	// Contador dos arquivos do diretorio
	Local lArquivoValido
	Local cLayoutVer  := "" 	// Versão do Layout 3 ou 5
	Local cFormatDt
	Local cFormatTm
	Local cNewNomeArq	:= ""
	Local cDiretorio	:= "\system\EDI"
	Local cDirOk		:= "\system\EDI\OK"
	Local cDirErro		:= "\system\EDI\N-OK"
	Private GFEResult := GFEViewProc():New()
	Private cFilialOcor
	Private cNomeArq
	Private nNRIMP		:= 0
	Private nCountImpor := 0  	// Contador de arquivos importados
	Private cMsgPreVal	:= ""	// Armazena as mensagens de pré-validações para o Campo Observação (Importação)
	Private GFELog117   := GFELog():New("EDI_Ocorrencias_Importacao", "EDI Ocorrências - Importação", SuperGetMV('MV_GFEEDIL',,'1'))
	Private GFEFile     := GFEXFILE():New()

	cFilialOcor := "010104"

	GFELog117:Add("Parâmetros" + CRLF + Replicate("-", 20))
	GFELog117:Add("Transportador De..: " + "")
	GFELog117:Add("Transportador Até.: " + "ZZZ")
	GFELog117:Add("Filial Ocorrências: " + "010104")
	GFELog117:Add("Dir. Importação..: "  + "\system\EDI")
	GFELog117:Add("Dir. Backup OK...: "  + "\system\EDI\OK")
	GFELog117:Add("Dir. Backup Erros: "  + "\system\EDI\N-OK")
	GFELog117:NewLine()

	// Validação do diretório de importação
	If Empty(cDiretorio)
		GFELog117:Add("** " + "Diretório de importação deve ser informado.")
		GFELog117:EndLog()
		MsgAlert("Diretório de importação deve ser informado.", "Aviso")
		Return
	EndIf

	aDirImpor := DIRECTORY(cDiretorio + "\*.EDI" )

	// Verifica se existe arquivos no diretório informado
	If Len(aDirImpor) == 0
		GFELog117:Add("** " + "Nenhum arquivo encontrado no diretório " + cDiretorio)
		GFELog117:EndLog()
		MsgAlert("Nenhum arquivo encontrado no diretório " + cDiretorio, "Aviso")
		Return
	Endif

	// Data e Hora
	cFormatDt := stuff(DTOC(date()),3,1,'')
	cFormatDt := stuff(cFormatDt,5,1,'')

	cFormatTm := stuff(Time(),3,1,'')
	cFormatTm := stuff(cFormatTm,5,1,'')

	GFELog117:Add("- Início da importação")
	GFELog117:NewLine()
	GFELog117:Save()

	ProcRegua(Len(aDirImpor))

	For nCountFiles := 1 To Len(aDirImpor)
		lArquivoValido := .T.
		cNomeArq  	:= aDirImpor[nCountFiles][1]

		GFELog117:Add(Replicate("-", 80))
		GFELog117:Add("[" + ALLTRIM(STR(nCountFiles)) + "] Arquivo: " + cNomeArq)

		GFEFile:Clear()
		GFEFile:Open(cDiretorio + "\" + cNomeArq)

		cBuffer := GFEFile:Line()
		//Se o Arquivo estiver em branco retornará uma mensagem em tela e no log e continuará a importação
		If Empty(cBuffer)
				GFELog117:Add("  ** Arquivo em branco.")
				GFELog117:Add("  ** Linha: " + cBuffer)
				GFEResult:AddErro("Arquivo: " + cNomeArq + "' em branco.")
				lArquivoValido := .F.
		EndIf

		// Verifica se é um arquivo válido. Identificador '000' e sigla 'OCO'
		If SubStr(cBuffer,01,03) == "000" .And. SubStr(cBuffer,84,03) != "OCO"
			GFELog117:Add("  ** Arquivo com Registro '000', Identificador de intercâmbio diferente de 'OCO'")
			GFELog117:Add("  ** Linha: " + cBuffer)
			GFEResult:AddErro("Arquivo: " + cNomeArq + "' inválido.")
			GFELog117:NewLine()
			GFELog117:Save()
			lArquivoValido := .F.
		EndIf

		// Validação da versão do Layout
		If lArquivoValido
			GFEFile:FNext()
			cBuffer := GFEFile:Line()

			// Identifica a versão Layout do arquivo
			cLayoutVer := SubStr(cBuffer, 01, 03)

			// Valida a versão do layout do arquivo
			If (cLayoutVer != "340" .AND. cLayoutVer != "540") .OR. Empty(cLayoutVer)
				GFELog117:Add("** " + "Arquivo '" + cNomeArq + "' com formato inválido ou layout incompatível com o sistema.", 1)
				GFELog117:Save()
				GFEResult:AddErro("Arquivo: " + cNomeArq + "' com formato inválido ou layout incompatível com o sistema.")
				lArquivoValido := .F.
			EndIf
		EndIf

		// Leitura do Arquivo e Gravação do Arquivo
		If lArquivoValido
			IncProc()
			If cLayoutVer == "340"
				LayoutPro3()
			EndIf

			// Gravação para na tabela intermediária
			GerarGXL()
		EndIf

		// Transferência do arqivos para os diretórios de Ok e NOk
		cNewNomeArq := cFormatDt + "_" + cFormatTm + "_" + cNomeArq
		If lArquivoValido //se chegar ao fim do arquivo sem erros
			If (FRename(cDiretorio + "\" + cNomeArq, cDirOk + "\" + cNewNomeArq) == -1)
				GFELog117:Add("** " + "Erro ao mover arquivo '" + cDiretorio + "\" + cNomeArq  + "' para o diretório " + cDirOk + "\" + cNewNomeArq)
				MsgAlert(             "Erro ao mover arquivo '" + cDiretorio + "\" + cNomeArq  + "' para o diretório " + cDirOk + "\" + cNewNomeArq, "Aviso")
			EndIf
		Else
			If (FRename(cDiretorio + "\" + cNomeArq, cDirErro + "\" + cNewNomeArq) == -1)
				GFELog117:Add("** " + "Erro ao mover arquivo '" + cDiretorio + "\" + cNomeArq  + "' para o diretório " + cDirErro + "\" + cNewNomeArq)
				MsgAlert(             "Erro ao mover arquivo '" + cDiretorio + "\" + cNomeArq  + "' para o diretório " + cDirErro + "\" + cNewNomeArq, "Aviso")
			EndIf
		EndIf

		GFELog117:NewLine()
		GFELog117:Add(Replicate("-", 50))
		GFELog117:NewLine()
		If lArquivoValido
			GFEResult:Add("Arquivo: " + cNomeArq + "' importado com sucesso.")
		endif
	Next
	GFEResult:Show("Importação de arquivos", "Arquivos", "Erros", "Alguns arquivos não foram importados.")

		If nCountImpor == 0
			GFELog117:Add("Nenhuma fatura foi importada para a faixa informada.")
		EndIf
	GFELog117:EndLog()

Return .T.






Static Function LayoutPro3()
	Local nContLinhas := 0 		// Contador de Linhas do arquivo
	Local lFlag     := .T.
	Local lSelecao  := .T.

	Local cCGCTrp
	Local cCdTrp
	Local cCdEmis
	Local cFilDc
	Local cBuffer   := ""
	Local lCdTipo := GfeVerCmpo({"GXL_CDTIPO"}) .And. SuperGetMv("MV_REGOCO",.F.,"1") == "2"
	
	While !GFEFile:FEof()
    	nContLinhas++

    	cBuffer := GFEFile:Line()

	    // Verificação da faixa do Transportador
		If SubStr(cBuffer,01,03) == "341"
			lSelecao := .F.
			cCGCTrp := AllTrim(SubStr(cBuffer,04,14))
			cCdTrp  := Posicione("GU3", 11, xFilial("GU3") + cCGCTrp, "GU3_CDEMIT")

			GFELog117:Add("CGC Transportador: " + AllTrim(SubStr(cBuffer,04,14)))
			If Empty(cCdTrp)
				GFELog117:Add("** " + "Emitente não encontrado com CNPJ/CPF: " + cCGCTrp)
			EndIf

			// Log e pré-validação do Emitente
			If Empty(MV_PAR01) .AND. Empty(MV_PAR02)
				lSelecao := .T.
			ElseIf cCdTrp >= MV_PAR01 .AND. cCdTrp <= MV_PAR02
				lSelecao := .T.
			Else
				GFELog117:Add("** Transportador fora da faixa")
			EndIf

			If lSelecao
				GFELog117:Add("Cod Transportador: " + cCdTrp)
			EndIf
		EndIf

		If SubStr(cBuffer,01,03) == "342" .And. lSelecao

			// Código do emissor do Documento de Carga
			cCdEmis := Posicione("GU3",11,xFilial('GU3')+SubStr(cBuffer,04,14),"GU3_CDEMIT")
			If Empty(cCdEmis)
				GFELog117:Add("** " + "Emitente não encontrado com CNPJ/CPF: " + SubStr(cBuffer,04,14), 1)
			EndIf

			// Filial do Documento de Carga com base no Emissor do CNPJ/CPF da Nota
			GFELog117:Add("# Buscando a filial do documento de carga pelo emissor: " + SubStr(cBuffer,04,14), 1)
			cFilDc := ""
			SM0->( dbGoTop() )
			While !SM0->( EOF() )
				If SM0->M0_CGC == ALLTRIM(SubStr(cBuffer,04,14))
					cFilDc := SM0->M0_CODFIL
					GFELog117:Add("- Filial encontrada: " + cFilDc, 1)
					Exit
				EndIf
				dbSelectArea("SM0")
				SM0->( dbSkip() )
			EndDo

			If Empty(cFilDc)
				GFELog117:Add("** " + "Filial não encontrada para a empresa de CNPJ:" + SubStr(cBuffer,04,14), 1)
				cFilDc := cFilialOcor
			EndIf

		   GFELog117:Add("Documento de Carga: ", 1)
		   GFELog117:Add("> CGC Emissor.: " + SubStr(cBuffer,04,14), 2)
		   GFELog117:Add("> Filial......: " + cFilDc				, 2)
		   GFELog117:Add("> Emissor.....: " + cCdEmis				, 2)
		   GFELog117:Add("> Série.......: " + SubStr(cBuffer,18,03), 2)
		   GFELog117:Add("> Número......: " + SubStr(cBuffer,21,08), 2)
		   GFELog117:Save()

			cMsgPreVal := ""
			nCountImpor++
			nNRIMP++
			RecLock((tTabOCO),.T.)
				(tTabOCO)->GXL_FILIAL  := xFilial("GXL")

		  		(tTabOCO)->GXL_FILOCO  := cFilialOcor
		   		(tTabOCO)->GXL_CDTRP   := cCdTrp
		   		(tTabOCO)->GXL_NRIMP   := ALLTRIM(STR(nNRIMP))
		   		(tTabOCO)->GXL_FILDC   := cFilDc
		   		(tTabOCO)->GXL_EMISDC  := cCdEmis
		   		(tTabOCO)->GXL_SERDC   := SubStr(cBuffer,18,03)
		   		(tTabOCO)->GXL_NRDC    := SubStr(cBuffer,21,08)
		   		(tTabOCO)->GXL_CODOCO  := SubStr(cBuffer,29,02)
		   		(tTabOCO)->GXL_CODOBS  := Val(SubStr(cBuffer,43,2))
		   		If lCdTipo .And. (tTabOCO)->GXL_CODOBS == 3
		   			dbSelectArea("GU4")
		   			(tTabOCO)->GXL_CDTIPO  := Posicione("GU4",2,xFilial("GU4") + SuperGetMv("MV_CDTIPOE",.F.,Space(TamSx3("GU4_CDTIPO")[1])), "GU4_CDTIPO")
		   			(tTabOCO)->GXL_CDMOT  := Posicione("GU4",2,xFilial("GU4") + SuperGetMv("MV_CDTIPOE",.F.,Space(TamSx3("GU4_CDMOT")[1])), "GU4_CDMOT")
		   		Else
		   			dbSelectArea("GU4")
		   			GU4->(dbSetOrder(1))
		   			If GU4->( dbSeek(xFilial("GU4")+(tTabOCO)->GXL_CODOCO ) )
		                (tTabOCO)->GXL_CDTIPO := GU4->GU4_CDTIPO
		            ElseIf GU4->( dbSeek(xFilial("GU4")+StrZero(Val((tTabOCO)->GXL_CODOCO),6)) )      //Trocar as exclamações
		                (tTabOCO)->GXL_CDTIPO := GU4->GU4_CDTIPO
					Else
						dbSelectArea("GU5")
						GU5->( dbSetOrder(1) )
						GU5->( dbSetFilter({|| GU5->GU5_FILIAL+GU5->GU5_EVENTO == xFilial("GU5")+If(SuperGetMv("MV_REGOCO",.F.,"1") == "2","4","1")},"") )
						GU5->( dbGoTop() )
						If GU5->(RecCount() ) > 0
							(tTabOCO)->GXL_CDTIPO := GU5->GU5_CDTIPO
		
							DbSelectArea("GU4")
							GU4->( dbSetOrder(2) )
							If GU4->( dbSeek(xFilial("GU4")+(tTabOCO)->GXL_CDTIPO) )
								(tTabOCO)->GXL_CDMOT := GU4->GU4_CDMOT
							EndIf
		
						EndIf
					EndIf
					If Empty((tTabOCO)->GXL_CDMOT)
						(tTabOCO)->GXL_CDMOT := StrZero(Val((tTabOCO)->GXL_CODOCO),6)
			            DbSelectArea("GU6")
			            GU6->( dbSetOrder(1) )
			            If GU6->( dbSeek(xFilial("GU6")+(tTabOCO)->GXL_CODOCO) )
			               (tTabOCO)->GXL_CDMOT := (tTabOCO)->GXL_CODOCO
			            ElseIf GU6->( dbSeek(xFilial("GU6")+StrZero(Val((tTabOCO)->GXL_CODOCO),6)) )
		                    (tTabOCO)->GXL_CDMOT := StrZero(Val((tTabOCO)->GXL_CODOCO),6)
			            EndIf
					EndIf
		   		EndIf
		   		(tTabOCO)->GXL_DTOCOR  := StoD(SubStr(SubStr(cBuffer,31,08),5,4)+SubStr(SubStr(cBuffer,31,08),3,2)+SubStr(SubStr(cBuffer,31,08),1,2))
		   		(tTabOCO)->GXL_HROCOR  := SubStr(cBuffer,39,2)+":"+SubStr(cBuffer,41,2)
				(tTabOCO)->GXL_OBS     := SubStr(cBuffer,45,70)
				(tTabOCO)->GXL_EDISIT  := '1'
				(tTabOCO)->GXL_EDILIN  := cBuffer
				(tTabOCO)->GXL_EDIARQ  := cNomeArq
				(tTabOCO)->GXL_EDINRL  := nContLinhas
			MsUnLock((tTabOCO))

			lFlag := .T.

			// Pré-Validações -------------------------
			If Empty((tTabOCO)->GXL_CDTRP)
				If !Empty(cCGCTrp)
					cMsgPreVal += "- " + "Transportador não encontrado. CNPJ/CPF: " + cCGCTrp + CRLF
				Else
					cMsgPreVal += " - " + "Dados da transportador não informados no registro 341." + CRLF
				EndIf
			EndIf

			If Empty((tTabOCO)->GXL_FILDC)
				cMsgPreVal += "- "  + "Filial da Nota não encontrada. CNPJ/CPF:" + SubStr(cBuffer,04,14) + CRLF
			EndIf

			If Empty((tTabOCO)->GXL_EMISDC)
				cMsgPreVal += "- "  + "Emissor da nota não encontrado. CNPJ/CPF: " + SubStr(cBuffer,04,14) + CRLF
			EndIf

			If !Empty(cMsgPreVal)
				RecLock((tTabOCO))
			   		(tTabOCO)->GXL_EDIMSG := cMsgPreVal
			   		(tTabOCO)->GXL_EDISIT := '2'
			   	 MsUnlock()
			EndIf

		 EndIf

		GFEFile:FNext()

		GFELog117:NewLine()
		GFELog117:Save()
	EndDo
Return



Static Function GerarGXL()
	Local nI
	Local cNRIMP
	Local cBrowse117
	
	cBrowse117 := "a0"

	dbSelectArea((tTabOCO))
	dbGoTop()

	// Conhecimentos
	While !(tTabOCO)->(EOF())
		cNRIMP := GETSXENUM("GXL", "GXL_NRIMP")

		RecLock("GXL", .T.)
			GXL->GXL_FILIAL := xFilial("GXL")
			GXL->GXL_NRIMP  := cNRIMP
			GXL->GXL_MARKBR := cBrowse117
			GXL->GXL_USUIMP := cUserName
			GXL->GXL_DTIMP  := DDATABASE
			GXL->GXL_ALTER  := "2"

			// Grava todos os campos, com execção do GXG_FILIAL e GXG_NRIMP
			For nI := 3 To Len(aCamposOCO)
				&("GXL->" + aCamposOCO[nI][1] + " := (tTabOCO)->" + aCamposOCO[nI][1])
			Next
		MsUnlock("GXL")

		ConfirmSX8()

		(tTabOCO)->(dbSkip())
	EndDo

	dbSelectArea((tTabOCO))
	Zap

Return Nil


