//#INCLUDE "GFEA117A.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "FWMVCDEF.CH"

//-------------------------------------------------------------------
/*/{Protheus.doc} GFEA117A
EDI - Importação de Ocorrências

GXL - Espelho da GW3

@author Israel A. Possoli
@since 27/06/12
@version 1.0
/*/
//-------------------------------------------------------------------
//Function GFEA117IMP()
User Function GFEA117IMP()
	Private tTabOCO				// Tabela temporária do conhecimento
	Private aCamposOCO := {}	// Campos da tabela intermediária de CTRC

	If Pergunte("GFEA117",.T.)
		CriaTab()
		Processa({|| Importacao()},"Importando arquivos", "")
		GFEDelTab(tTabOCO)
	Else
		Return .F.
	EndIf
Return .T.


//-------------------------------------------------------------------
/*/{Protheus.doc} GFEA117PRO
Processamento das Ocorrências importadas

GWD - Ocorrências
GWL - Doc Cargas X Ocorrências

@author Israel A. Possoli
@since 03/07/12
@version 1.0
/*/
//-------------------------------------------------------------------
Function GFEA117PRO()
	Processa({|| Processamento()},"Processando registros", "")
Return .T.


//-------------------------------------------------------------------
/*/{Protheus.doc} CriaTab
Criação das tabelas temporárias

@author Israel A. Possoli
@since 11/08/12
@version 1.0
/*/
//-------------------------------------------------------------------
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


//-------------------------------------------------------------------
/*/{Protheus.doc} Importacao
EDI - Importação de Ocorrências

@author Israel A. Possoli
@since 14/08/12
@version 1.0
/*/
//-------------------------------------------------------------------
Static Function Importacao()
	Local aDirImpor   := {}		// Array com os arquivos do diretorio
	Local nCountFiles := 0  	// Contador dos arquivos do diretorio
	Local lArquivoValido
	Local cLayoutVer  := "" 	// Versão do Layout 3 ou 5
	Local cFormatDt
	Local cFormatTm
	Local cNewNomeArq	:= ""
	Local cDiretorio	:= AllTrim(MV_PAR04)
	Local cDirOk		:= AllTrim(MV_PAR05)
	Local cDirErro		:= AllTrim(MV_PAR06)
	Private GFEResult := GFEViewProc():New()
	Private cFilialOcor
	Private cNomeArq
	Private nNRIMP		:= 0
	Private nCountImpor := 0  	// Contador de arquivos importados
	Private cMsgPreVal	:= ""	// Armazena as mensagens de pré-validações para o Campo Observação (Importação)
	Private GFELog117   := GFELog():New("EDI_Ocorrencias_Importacao", "EDI Ocorrências - Importação", SuperGetMV('MV_GFEEDIL',,'1'))
	Private GFEFile     := GFEXFILE():New()

	cFilialOcor := MV_PAR03

	GFELog117:Add("Parâmetros" + CRLF + Replicate("-", 20))
	GFELog117:Add("Transportador De..: " + MV_PAR01)
	GFELog117:Add("Transportador Até.: " + MV_PAR02)
	GFELog117:Add("Filial Ocorrências: " + cFilialOcor)
	GFELog117:Add("Dir. Importação..: "  + MV_PAR04)
	GFELog117:Add("Dir. Backup OK...: "  + MV_PAR05)
	GFELog117:Add("Dir. Backup Erros: "  + MV_PAR06)
	GFELog117:NewLine()

	// Validação do diretório de importação
	If Empty(cDiretorio)
		GFELog117:Add("** " + "Diretório de importação deve ser informado.")
		GFELog117:EndLog()
		MsgAlert("Diretório de importação deve ser informado.", "Aviso")
		Return
	EndIf

	aDirImpor := DIRECTORY(cDiretorio + "\*.TXT" )

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

		// Verifica se é um arquivo válido. Identificador '000' e sigla 'COCO'
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


//-------------------------------------------------------------------
/*/{Protheus.doc} GerarGXL
Geração da tabela intermediária GXL

@author Israel A Possoli
@since 13/08/10
@version 1.0
/*/
//-------------------------------------------------------------------
Static Function GerarGXL()
	Local nI
	Local cNRIMP

	dbSelectArea((tTabOCO))
	dbGoTop()

	// Conhecimentos
	While !(tTabOCO)->(EOF())
		cNRIMP := GETSXENUM("GXL", "GXL_NRIMP")

		RecLock("GXL", .T.)
			GXL->GXL_FILIAL := xFilial("GXL")
			GXL->GXL_NRIMP  := cNRIMP
			GXL->GXL_MARKBR := oBrowse117:Mark()
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


//-------------------------------------------------------------------
/*/{Protheus.doc} LayoutPro3
EDI - Importação de Documento de Frete

@author Felipe Rafael Mendes
@since 10/06/10
@version 1.0
/*/
//-------------------------------------------------------------------
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

//-------------------------------------------------------------------
/*/{Protheus.doc} Processamento
Rotina para processar as ocorrências importadas.

@author Felipe Rafael Mendes
@since 17/06/10
@version 1.0
/*/
//-------------------------------------------------------------------
Static Function Processamento()
	Local lRet
	Local nValCGC
	Local lProc     := .F.
	Local bSeek
	Local oModel
	Local oModelGWD
	Local oModelGWL
	Local aArea     := GetArea()
	Local aAreaSM0  := SM0->( GetArea() )
	Local nCount    := 0
	Local nTotal    := 0
	Local nCtOcoEnt := 0
	Local cAddMsg   := ""
	Local cTpDc
	Local cDsOcor   := ""
	Local cTipo		:= ""
	Local cDtOcor
	Local cHrOcor
	Local cFilOco
	Local cCdMot
	Local cNrDC
	Local aNrRoms	:= {}
	Local lBuscaDC	 := .F.
	Local nTrechoRec := 0 		// RecNo do Trecho de entrega
	Local nCountTrEn := 0		// Total de trechos pagos
	Local nPosTrecho := 0 		// Posição do trecho a ser entregue em relação aos trechos do Documento de Carga
	Local nCountDC   := 0 // Contador do tamanho do número do DC
	Local aFormat	 := {7, 8, 9, 6, 0} //Sequência do tamanho para as tentativas de posicionamento no Documento de Carga.
	Local cMarcaBrw	 := oBrowse117:Mark()
	Local lTMS2GFE // Novo campo integração ocorrencia tms
	Local cDocTrp  // chave documento transporte
	Local aAreaGWL
	Local aAreaGXL
	Local cChaveGXL
	Local cFilGXL
	Local lSeekGXL
	Local lCdTipo := GfeVerCmpo({"GXL_CDTIPO"})
	Local aDocTrp := {}
	Local nDocTrp := 0
	Local nGXL
	dbSelectArea("GU5")
	lTMS2GFE := GfeVerCmpo({"GU5_INTTMS"}) 
	// Public lFlagMov := .F. // Variavel utilizada pelas validações do oModel, valor padrão .F.
	Private GFELog117 := GFELog():New("EDI_Ocorrencias_Processamento", "EDI Ocorrências - Processamento", SuperGetMV('MV_GFEEDIL',,'1'))

	DbSelectArea('GXL')
	GXL->( DbSetOrder( 1 ) )
	GXL->( DBGoTop() )
    While !GXL->( Eof() )
		// Verifica se o registro está selecionado
		If !oBrowse117:IsMark(cMarcaBrw) .OR. GXL->GXL_EDISIT == "4"
			GXL->( dbSkip() )
			Loop
		EndIf

		nTotal++

		If GXL->GXL_EDISIT != '4'

			lProc := .T.

			GFELog117:NewLine()
			GFELog117:Add(Replicate("-", 60))
			GFELog117:Add("Sequência Importação: " + GXL->GXL_NRIMP)
			GFELog117:NewLine()
			GFELog117:Add("- Buscando Documento de Carga.")
			GFELog117:Add("> Filial.: " + GXL->GXL_FILDC, 1)
			GFELog117:Add("> Emissor: " + GXL->GXL_EMISDC, 1)
			GFELog117:Add("> Série..: " + GXL->GXL_SERDC, 1)
			GFELog117:Add("> Número.: " + GXL->GXL_NRDC, 1)

			dbSelectArea("GW1")
			GW1->( dbSetOrder(13) )
			If GW1->( dbSeek(GXL->GXL_EMISDC + GXL->GXL_SERDC + GXL->GXL_NRDC) )
				cNrDC := GXL->GXL_NRDC
			Else

				GFELog117:Add("** Documento de Carga não encontrado.", 1)
				GFELog117:Add("- Tentativa de busca do número com zeros à esquerda.", 1)
				lBuscaDC := .F.
				For nCountDC := 1 To Len(aFormat)
					cNrDC := GFEFrNrDC(AllTrim(GXL->GXL_NRDC), aFormat[nCountDC])

					If !Empty(cNrDC)
			    		dbSelectArea("GW1")
			    		dbSetOrder(13)
			    		If dbSeek(GXL->GXL_EMISDC + GXL->GXL_SERDC + cNrDC)
			    			lBuscaDC := .T.
			    			GFELog117:Add("> Número.: " + cNrDC + "[Encontrado]", 1)
							Exit
						Else
							GFELog117:Add("> Número.: " + cNrDC, 1)
						EndIf
					EndIf
				Next

				If !lBuscaDC
					GFELog117:Add("** Não foi possível encontrar o número do Documento de Carga.", 1)
					GFELog117:Save()

					RecLock("GXL",.F.)
						GXL->GXL_EDIMSG := "- " + "Documento de carga inexistente. Filial: " + ALLTRIM(GXL->GXL_FILDC) + ", Serie: " + ALLTRIM(GXL->GXL_SERDC) + ", Número: " + ALLTRIM(GXL->GXL_NRDC)
				   		GXL->GXL_EDISIT := "3"
					MsUnLock("GXL")

					GXL->( dbSkip() )
					Loop
				EndIf
			EndIf

			GFELog117:Save()

			// Busca Documento de Carga da ocorrência
			dbSelectArea("GW1")
			GW1->( dbSetOrder(13) )
			If GW1->( dbSeek(GXL->GXL_EMISDC + GXL->GXL_SERDC + cNrDC) )
				GFELog117:Add("> Tipo...: " + GW1->GW1_CDTPDC, 1)
				GFELog117:NewLine()

				cTpDc := AllTrim(GW1->GW1_CDTPDC)

				/* ---------------------------------------------------------------
				    Ocorrência de Entrega
				    Uma ocorrência (GWD) será sempre criada se MV_REGOCO == 2
				    ou se GXL_CODOBS != 3
				   --------------------------------------------------------------- */
				If GXL->GXL_CODOBS == 3 .And. SuperGetMv("MV_REGOCO",.F.,"1") != "2"
					nTrechoRec   := 0
					nPosTrecho   := 0
					nCountTrEn   := 0

					//Verificando se o Doc. Carga está embarcado
					If GW1->GW1_SIT == "4"

						GFELog117:Add("- Ocorrência de entrega. Buscando trecho com o transportador: " + GXL->GXL_CDTRP)

						// Busca os trechos do documento de carga para atribuir a data e hora de entrega e marcar o documento de carga como entrege
						// A Data e Hora de entrega serão atribuidos nos trechos que:
						// 		a) O transportador do arquivo (GXL->GXL_CDTRP) for igual ao do trecho
						// 		b) O Transportador de faturamento do transportador do arquivo for igual ao do trecho
						//  	c) Também é possível buscar pela raiz do CNPJ, desconsiderando a filial
						// O Documento de Carga será entregue quando?
						//      a) For o último trecho
						GFELog117:AddDebug("*****************************")
						GFELog117:AddDebug("Buscando trechos pagos")
						dbSelectArea("GWU")
						GWU->( dbSetOrder(1) )
						If GWU->(dbSeek(GW1->GW1_FILIAL + GW1->GW1_CDTPDC + GW1->GW1_EMISDC + GW1->GW1_SERDC + GW1->GW1_NRDC))
							While !GWU->( Eof() ) .And. ;
								   GWU->GWU_FILIAL == GW1->GW1_FILIAL .And. ;
								   GWU->GWU_CDTPDC == GW1->GW1_CDTPDC .And. ;
								   GWU->GWU_EMISDC == GW1->GW1_EMISDC .And. ;
								   GWU->GWU_SERDC  == GW1->GW1_SERDC  .And. ;
								   GWU->GWU_NRDC   == GW1->GW1_NRDC

								// Soma os trechos que são de entregas ou não pagos
								If GWU->GWU_PAGAR == '1'
									nCountTrEn++
									GFELog117:AddDebug(" # " + cValToChar(nPosTrecho) + " - Seq: " + GWU->GWU_SEQ)
								EndIf

								If nTrechoRec == 0
									If AllTrim(GWU->GWU_CDTRP) == AllTrim(GXL->GXL_CDTRP) // CDEMFT
										nTrechoRec := GWU->( RecNo() )
										nPosTrecho := nCountTrEn
										GFELog117:AddDebug("    > Trecho para registro da entrega. RecNo: " + cValToChar(nTrechoRec))
									Else
										dbSelectArea("GU3")
										dbSetOrder(1)
										If dbSeek(xFilial("GU3") + GXL->GXL_CDTRP)
											If AllTrim(GU3->GU3_CDEMFT) == AllTrim(GWU->GWU_CDTRP)
												GFELog117:Add("> Transp. Faturam: " + GU3->GU3_CDEMFT, 1)
												nTrechoRec := GWU->( RecNo() )
												nPosTrecho := nCountTrEn
												GFELog117:AddDebug("    > Trecho para registro da entrega. RecNo: " + cValToChar(nTrechoRec))
											EndIf
										EndIf
									EndIf
								EndIf

								dbSelectArea("GWU")
								GWU->( dbSkip() )
							EndDo
						EndIf
						GFELog117:AddDebug(" > Total de trechos pagos: " + cValToChar(nCountTrEn))
						GFELog117:AddDebug(" > Posição do trecho a ser entregue: " + cValToChar(nPosTrecho))

						GFELog117:AddDebug("*****************************")

						// Efetiva a alteração do trecho com a Data e Hora de entrega
						// Marca o Documento de Carga como entregue
						If nTrechoRec != 0
							dbSelectArea("GWU")
							dbGoTo(nTrechoRec)
							If !GWU->( EoF() )
								GFELog117:Add("> Seq. do Trecho.: " + GWU->GWU_SEQ, 1)
								GFELog117:Add("> Data de Entrega: " + cValToChar(GXL->GXL_DTOCOR), 1)
								GFELog117:Add("> Hora de Entrega: " + GXL->GXL_HROCOR, 1)

								If GXL->GXL_DTOCOR > Date()
									GFELog117:Add("A data de entrega da Ocorrência não pode ser maior que a data atual.")
									RecLock("GXL",.F.)
										GXL->GXL_EDIMSG := "A data de entrega da Ocorrência não pode ser maior que a data atual."
										GXL->GXL_EDISIT := "3"
									MsUnLock("GXL")

									DbSelectArea("GXL")
									GXL->( dbSkip() )
									Loop
								Else
									// Altera o Documento de Carga para Entregue caso seja o último trecho
									If nPosTrecho == nCountTrEn
										GFELog117:Add("# Último trecho. Alterando situação para Entregue para o Documento de Carga", 1)
										RecLock("GW1",.F.)
											GW1->GW1_SIT := "5"
											//Armazena os romaneios afetados
											Aadd(aNrRoms, {GW1->GW1_FILIAL,GW1->GW1_NRROM})
										MsUnlock("GW1")
									EndIf

									// Atribui a Data e Hora de entrega para o trecho
									RecLock("GWU",.F.)
										GWU->GWU_DTENT := GXL->GXL_DTOCOR
										GWU->GWU_HRENT := GXL->GXL_HROCOR
									MSUnlock("GWU")

									RecLock("GXL",.F.)
										If nPosTrecho == nCountTrEn
											GXL->GXL_EDIMSG := "Ocorrência de entrega para o último trecho, documento de carga marcado como entregue."
										Else
											GXL->GXL_EDIMSG := "Ocorrência de entrega."
										EndIf
										GXL->GXL_EDISIT := "4"
									MsUnLock("GXL")
								EndIf

								nCount++
							Else
								GFELog117:Add("** Erro fatal ao encontrar trecho para entrega", 1)
							EndIf
						Else
							GFELog117:Add("** Trecho não encontrado com transportador " + GXL->GXL_CDTRP)
							GFELog117:Add("   > Filial: " + GW1->GW1_FILIAL + ", Tipo: " + GW1->GW1_CDTPDC + ", Emissor: " + GW1->GW1_EMISDC + ", Série: " + GW1->GW1_SERDC + ", Nr: " + GW1->GW1_NRDC)

							RecLock("GXL",.F.)
								GXL->GXL_EDIMSG := "Não foi encontrado o trecho do documento de carga com o código do transportador: " + GXL->GXL_CDTRP
								GXL->GXL_EDISIT := "3"
							MsUnLock("GXL")
						EndIf

						GFELog117:Save()

	                    DbSelectArea("GXL")
						GXL->( dbSkip() )
						Loop
					Else
						GFELog117:Add("** " + "Documento de carga deve estar com a situação 4=Embarcado. Filial: " + ALLTRIM(GXL->GXL_FILDC) + ", Serie: " + ALLTRIM(GXL->GXL_SERDC) + ", Número: " + ALLTRIM(GXL->GXL_NRDC))
						RecLock("GXL",.F.)
							GXL->GXL_EDIMSG := "- " + "Documento de carga deve estar com a situação 4=Embarcado. Filial: " + ALLTRIM(GXL->GXL_FILDC) + ", Serie: " + ALLTRIM(GXL->GXL_SERDC) + ", Número: " + ALLTRIM(GXL->GXL_NRDC)
							GXL->GXL_EDISIT := "3"
						MsUnLock("GXL")
						GXL->( dbSkip() )
						Loop
					EndIf

				EndIf
			Else
				GFELog117:Add("** " + "Documento de carga inexistente. Filial: " + ALLTRIM(GXL->GXL_FILDC) + ", Serie: " + ALLTRIM(GXL->GXL_SERDC) + ", Número: " + ALLTRIM(GXL->GXL_NRDC))

				RecLock("GXL",.F.)
					GXL->GXL_EDIMSG := "- " + "Documento de carga inexistente. Filial: " + ALLTRIM(GXL->GXL_FILDC) + ", Serie: " + ALLTRIM(GXL->GXL_SERDC) + ", Número: " + ALLTRIM(GXL->GXL_NRDC)
					GXL->GXL_EDISIT := "3"
				MsUnLock("GXL")

				GXL->( dbSkip() )
				Loop
			EndIf

			GFELog117:Add("- Criando a ocorrência.")

		    oModel    := FWLoadModel("GFEA032")
		    oModelGWD := oModel:GetModel("GFEA032_GWD")
    		oModelGWL := oModel:GetModel("GFEA032_GWL")
            oModel:SetOperation( 3 )

            oModel:Activate()

			//Atribui valor atravez de do SetValue da tabela GWD
			//Atribui valor atravez de do SetValue da tabela GWL
			//oModelGWL:SetValue("GWL_FILIAL",GXL->GXL_FILIAL)
			oModelGWL:SetValue("GWL_FILIAL" , AllTrim(GXL->GXL_FILOCO))
			//o Campo é substituido pelo model
//			oModelGWL:SetValue("GWL_NROCO" , AllTrim(GXL->GXL_CODOCO)) 
			oModelGWL:SetValue("GWL_FILDC" , AllTrim(GXL->GXL_FILDC))
			oModelGWL:SetValue("GWL_NRDC"  , AllTrim(cNrDC))
			oModelGWL:SetValue("GWL_EMITDC", AllTrim(GXL->GXL_EMISDC))
			oModelGWL:SetValue("GWL_SERDC" , AllTrim(GXL->GXL_SERDC))
			oModelGWL:SetValue("GWL_TPDC"  , cTpDc)
			oModelGWD:SetValue("GWD_CDTRP" , GXL->GXL_CDTRP)
			oModelGWD:SetValue("GWD_DTOCOR", GXL->GXL_DTOCOR)
			oModelGWD:SetValue("GWD_HROCOR", AllTrim(GXL->GXL_HROCOR))
			oModelGWD:SetValue("GWD_ORIGEM", "1") //Origem EDI
			If GfeVerCmpo({"GWD_QTDVOL"}) 
				GW1->(dbSetOrder(1))
				If GW1->(dbSeek(GXL->GXL_FILDC+PadR(cTpDc,TamSx3("GWL_TPDC")[1])+GXL->GXL_EMISDC+GXL->GXL_SERDC+PadR(cNrDC,TamSx3("GWL_NRDC")[1])))
					oModelGWD:SetValue("GWD_QTDVOL", GW1->GW1_QTVOL)
				EndIf
			EndIf
			//---------------------------------------------------
			//Processo: Procurar primeira incidência na tabela de tp-motivo onde o código do motivo da GXL for igual..
			//Se sim: Atribuir o código do tipo para a tabela da tabela de tp-motivo para o campo CDTIPO da GWD
			//senao: Procurar na tabela de tipos o primeiro registro que o tipo da ocorrência seja igual a '1'
			//Adiciona o CDTIPO da tabela de tipo no CDTIPO da GWD
			//Depois procura o primeiro motivo pelo tipo, na tabela de tipo-motivo e adiciona no motivo da GWD.
			//o DS_SOLUCAO E DS_PROBLEMA são iguais a descrição!
			//---------------------------------------------------

			DbSelectArea("GU4")
			DbSelectArea("GU6")
            GU6->( dbSetOrder(1) )
			GU4->( dbSetOrder(1) )
			cTipo := ""
			cCdMot := ""
			cDsOcor := ""
			
			If lCdTipo .And. !Empty(GXL->GXL_CDTIPO)
				cTipo := GXL->GXL_CDTIPO
				If !Empty(GXL->GXL_CDMOT)
					cCdMot := GXL->GXL_CDMOT
					cDsOcor := Posicione("GU6",1,xFilial("GU6") + GXL->GXL_CDMOT, "GU6_DESC")
				EndIf					
			EndIf
			
			If Empty (cTipo)
	            If GU4->( dbSeek(xFilial("GU4")+GXL->GXL_CODOCO) )
	                cTipo := GU4->GU4_CDTIPO
	            ElseIf GU4->( dbSeek(xFilial("GU4")+StrZero(Val(GXL->GXL_CODOCO),6)) )      //Trocar as exclamações
	                cTipo := GU4->GU4_CDTIPO
				Else
	
					dbSelectArea("GU5")
					GU5->( dbSetOrder(1) )
					GU5->( dbSetFilter({|| GU5->GU5_FILIAL+GU5->GU5_EVENTO == xFilial("GU5")+If(SuperGetMv("MV_REGOCO",.F.,"1") == "2","4","1")},"") )
					GU5->( dbGoTop() )
	
					If GU5->(RecCount() ) > 0
	
						cTipo := GU5->GU5_CDTIPO
	
						DbSelectArea("GU4")
						GU4->( dbSetOrder(2) )
						If GU4->( dbSeek(xFilial("GU4")+cTipo) )
							cCdMot := GU4->GU4_CDMOT
						EndIf
	
					EndIf
				EndIf
			EndIf			
			/*--------------PROCESSO PRA PREENCHIMENTO DO CAMPO DSOCOR
			Processo: Se o campo da observação da tabel GXL for vazio:
			Senao: o campo DSOCOR recebe o campo da observação.
			Se for vazio: procurar primeira incidência na tabela de motivos de acordo com o código do motivo da GXL.
			Se achar: Atribuir a DSOCOR
			Senão achar: fazer um case com o status (observação) da GXL se for '1' DSOCOR = Devolução/recusa total,
			'2' DSOCOR = Devolução/recusa parcial, '3' DSOCOR = Aceite/entrega por acordo
	    	---------------------------------------------------*/
	    	If Empty(cCdMot)
				cCdMot := StrZero(Val(GXL->GXL_CODOCO),6)
	            cDsOcor := ''
	            DbSelectArea("GU6")
	            GU6->( dbSetOrder(1) )
	            If GU6->( dbSeek(xFilial("GU6")+GXL->GXL_CODOCO) )
	               cCdMot := GXL->GXL_CODOCO
	               cDsOcor := GU6->GU6_DESC
	            ElseIf GU6->( dbSeek(xFilial("GU6")+StrZero(Val(GXL->GXL_CODOCO),6)) )
                    cCdMot := StrZero(Val(GXL->GXL_CODOCO),6)
                    cDsOcor := GU6->GU6_DESC
	            EndIf
			EndIf
			If Empty(GXL->GXL_OBS)
               If Empty(cDsOcor)
                  Do Case
						Case GXL->GXL_CODOBS == 1
							cDsOcor := STR0010 //"Devolução/recusa total"
						Case GXL->GXL_CODOBS == 2
							cDsOcor := STR0011 //"Devolução/recusa parcial"
						Case GXL->GXL_CODOBS == 3
							cDsOcor := STR0012 //"Aceite/entrega por acordo"
					Endcase

				EndIf
			Else
				cDsOcor := GXL->GXL_OBS
			EndIf
			GFELog117:Add("> Desc Ocorrência: " + cDsOcor, 1)
			GFELog117:Add("> Cod Tipo.......: " + cTipo, 1)
			GFELog117:Add("> Cod Motivo.....: " + cCdMot, 1)
			GFELog117:Save()

			oModelGWD:SetValue("GWD_DSOCOR",AllTrim(cDsOcor))
			oModelGWD:SetValue("GWD_DSPROB",AllTrim(cDsOcor))
			oModelGWD:SetValue("GWD_DSSOLU",AllTrim(cDsOcor))
			oModelGWD:SetValue("GWD_CDTIPO",AllTrim(cTipo))
			oModelGWD:SetValue("GWD_CDMOT" ,AllTrim(cCdMot))
			
			
			dbSelectArea("GU5")
			//Verifica se usa a integração tms
			If lTMS2GFE .And. SuperGetMv("MV_TMS2GFE",.F.,.F.) .And. Posicione("GU5",1,xFilial("GU5") + cTipo, "GU5_INTTMS") == "2"
				
				dbSelectArea("GXL")
				aAreaGXL := GXL->(GetArea())
				dbSelectArea("GWL")
				aAreaGWL := GWL->(GetArea())
				dbSelectArea("GWE")
				GWE->(dbSetOrder(1))
				cFilGXL := GXL->GXL_FILDC
				cChaveGXL := PadR(cFilGXL,TamSx3("GWE_FILIAL")[1]);
							  +PadR(cTpDc,TamSx3("GWE_CDTPDC")[1]);
							  +PadR(GXL->GXL_EMISDC,TamSx3("GWE_EMISDC")[1]);
							  +PadR(GXL->GXL_SERDC,TamSx3("GWE_SERDC")[1]);
							  +PadR(cNrDC,TamSx3("GWE_NRDC")[1])
				If GWE->(dbSeek(cChaveGXL))
					cDocTrp := GWE->GWE_FILDT + GWE->GWE_NRDT + GWE->GWE_SERDT
					cTipo := GXL->GXL_CDTIPO
					cDtOcor := GXL->GXL_DTOCOR
					cHrOcor := GXL->GXL_HROCOR
					cFilOco := GXL->GXL_FILOCO
					aDocTrp := {}
					nDocTrp := 0
					GWE->(dbSetOrder(2))
					GWE->(dbSeek(GXL->GXL_FILDC + cDocTrp)) // Busca por documentos de carga do mesmo documento de transporte
					While !GWE->(Eof()) .And. GXL->GXL_FILDC + cDocTrp == GWE->GWE_FILIAL + GWE->GWE_FILDT + GWE->GWE_NRDT + GWE->GWE_SERDT
						GXL->(dbSetOrder(5))
						GWL->(dbSetOrder(2))
						nDocTrp++
						If Len(aDocTrp) +1 != nDocTrp // Se pelos testes abaixo um documento não foi adicionado, nao serão adicionado os relacionados na ocorrencia atual
							Exit
						EndIf
						//Busca por ocorrências relacionadas ou registros de importacao EDI relacionados
						//Só é possível adicionar na mesma ocorrencia se não existirem outras ocorrencias ou registros
						//com o mesmo tipo, data e hora
						If GXL->GXL_FILDC + GWE->GWE_CDTPDC + GWE->GWE_EMISDC + GWE->GWE_SERDC + GWE->GWE_NRDC != GXL->GXL_FILDC+PadR(cTpDc,TamSx3("GWE_CDTPDC")[1])+GXL->GXL_EMISDC+GXL->GXL_SERDC+PadR(cNrDC,TamSx3("GWE_NRDC")[1])
							If GWL->(dbSeek(GWE->(GWE_FILIAL+GWE_NRDC+GWE_FILIAL+GWE_EMISDC+GWE_SERDC/*+GWE_CDTPDC*/)))
								dbSelectArea("GWD")
								GWD->(dbSetOrder(1))
								GWD->(dbSeek(GWL->(GWL_FILIAL + GWL_NROCO)))
								
								If cTipo != GWD->GWD_CDTIPO
									GWE->(dbSkip())
									Loop
								EndIf
								
								If cDtOcor != GWD->GWD_DTOCOR
									GWE->(dbSkip())
									Loop
								EndIf
								
								If cHrOcor != GWD->GWD_HROCOR
									GWE->(dbSkip())
									Loop
								EndIf
							EndIf
							nGXL := -1
							If GXL->(dbSeek(cFilGXL+GWE->(GWE_FILIAL+GWE_EMISDC+GWE_SERDC+GWE_NRDC)))
								GWE->(dbSkip())
								Loop
							EndIf
							RestArea(aAreaGWL)
							GW1->(dbSeek(GWE->GWE_FILIAL+GWE->GWE_CDTPDC+GWE->GWE_EMISDC+GWE->GWE_SERDC+GWE->GWE_NRDC))
							aAdd(aDocTrp,{AllTrim(cFilOco),;
											AllTrim(GWE->GWE_FILIAL),;
											AllTrim(GWE->GWE_NRDC),;
											AllTrim(GWE->GWE_EMISDC),;
											AllTrim(GWE->GWE_SERDC),;
											AllTrim(GWE->GWE_CDTPDC),;
											GW1->GW1_QTVOL})
							
						EndIf
						RestArea(aAreaGWL)
						RestArea(aAreaGXL)
						GWE->(dbSkip())
					EndDo
					// Adiciona os documentos de carga na ocorrencia
					If Len(aDocTrp) == nDocTrp
						For nDocTrp := 1 to Len(aDocTrp)
							If oModelGWL:Length() > 0
								oModelGWL:AddLine(.T.)
							EndIf
							oModelGWL:GoLine(oModelGWL:Length())
							oModelGWL:SetValue("GWL_FILIAL" , aDocTrp[nDocTrp][1])
							oModelGWL:SetValue("GWL_FILDC" , aDocTrp[nDocTrp][2])
							oModelGWL:SetValue("GWL_NRDC"  , aDocTrp[nDocTrp][3])
							oModelGWL:SetValue("GWL_EMITDC", aDocTrp[nDocTrp][4])
							oModelGWL:SetValue("GWL_SERDC" , aDocTrp[nDocTrp][5])
							oModelGWL:SetValue("GWL_TPDC"  , aDocTrp[nDocTrp][6])
							oModelGWD:SetValue("GWD_QTDVOL", aDocTrp[nDocTrp][7] + oModelGWD:GetValue("GWD_QTDVOL") )
							If !(lRet:= oModelGWL:VldLineData())
								ErroModel(oModel)
								Exit
							EndIf
							
						Next nDocTrp						
					EndIf
				EndIf
				If (lRet := GravaModel(oModel))
					nCount++
				Else
					ErroModel(oModel)
				EndIf
				oModel:DeActivate()
			Else // sem integração tms 
				If (lRet := GravaModel(oModel))
					nCount++
				Else
					ErroModel(oModel)
				EndIf
				
				oModel:DeActivate()
			EndIf
			oModel:Destroy()
		EndIf
		GFELog117:Save()
		
		DbSelectArea("GXL")
		GXL->( DbSkip() )
		
	EndDo

	If len(aNrRoms) > 0
		A117AtuSitRom(aNrRoms)
	EndIf

	GFELog117:Add(Replicate("-", 60))
	GFELog117:NewLine()

	If nCount == 0 .And. lProc
		GFELog117:Add("Nenhum registro processado com sucesso.")
		GFELog117:Add("Total de registros processados: " + cValToChar(nTotal))
		MessageBox ("Nenhum registro processado com sucesso. Total de registros processados: " + cValToChar(nTotal) + CRLF + "Verifique o campo 'Mensagens' dos registros para a descrição dos erros ocorridos.", "Processamento", 48)
	ElseIf nCount == 0 .And. !lProc
		GFELog117:Add("** " + STR0015)
		MessageBox (STR0015, "Processamento", 48)	// "Não há registros para processar."
	ElseIf nCount > 0 .And. lProc
		GFELog117:Add(STR0013)
		GFELog117:Add(STR0016 + AllTrim(Str(nCount)) + STR0017 + AllTrim(Str(nTotal)) + ".")
		MsgInfo(STR0013 + CRLF + STR0016 + AllTrim(Str(nCount)) + STR0017 + AllTrim(Str(nTotal)) + "." + CRLF + ;
				If(nCount != nTotal, "Verifique o campo observação dos registros para a descrição dos erros ocorridos.","") ;
				,"") //"Processo concluído. " ### "Processada(s) " ### " ocorrências(s) do total de "
	EndIf

	GFELog117:EndLog()

	RestArea( aAreaSM0 )
	RestArea( aArea )
Return

Function A117AtuSitRom(aNrRoms)
	Local nI
	Local cNumRom := "ZZZZZZZZ"
	Local bAtualiza := .T.
	Local aAreaGW1 := GW1->(GetArea())
	For nI := 1 to len( aNrRoms )
		If cNumRom == aNrRoms[nI][2]
			loop
		EndIf

		dbSelectArea("GW1")
		GW1->( dbSetOrder(9) )
		GW1->( DbSeek(aNrRoms[nI][1]+aNrRoms[nI][2]) )
		While !Eof() .And. GW1->GW1_FILIAL == aNrRoms[nI][1];
		             .And. GW1->GW1_NRROM == aNrRoms[nI][2]

			If GW1->GW1_SIT != "5"
				bAtualiza := .F.
				Exit
			EndIf

			GW1->( DbSkip() )
		EndDo

		If bAtualiza
			dbSelectArea("GWN")
			GWN->( dbSetOrder(1) )
			GWN->( dbSeek(aNrRoms[nI][1]+aNrRoms[nI][2]) )
			RecLock("GWN",.F.)
				GWN->GWN_SIT := "4"
			MSUnlock("GWN")

		EndIf

		cNumRom := aNrRoms[nI][2]

	Next
	RestArea(aAreaGW1)
Return
//-------------------------------------
// When de dicionário. Usado no Pergunte. Campo Filial Ocorrência MV_PAR03
//-------------------------------------
Function GFEA117VLF(cFil)

	Local lRet := .F.
	Local aAreaSM0 := SM0->( GetArea() )

	dbSelectArea("SM0")
	SM0->( dbGoTop() )

	While !SM0->( Eof() )

		If !SM0->( Deleted() ) .And. AllTrim(cFil) == AllTrim(SM0->M0_CODFIL)
			lRet := .T.
			Exit
		EndIf

		dbSelectArea("SM0")
		SM0->( dbSkip() )
	EndDo

	RestArea(aAreaSM0)

	If !lRet
		Help( ,, 'HELP',, STR0004, 1, 0)
	EndIf

Return lRet

Static Function ErroModel(oModel)
	//  A estrutura do vetor aErro com erro é:
	//  [1] Id do formulário de origem
	//  [2] Id do campo de origem
	//  [3] Id do formulário de erro
	//  [4] Id do campo de erro
	//  [5] Id do erro
	//  [6] mensagem do erro
	//  [7] mensagem da solução
	//  [8] Valor atribuido
	//  [9] Valor anterior
	aErro := oModel:GetErrorMessage()

	GFELog117:Add(" ** " + STR0002+aErro[4]+STR0003+aErro[6])

	RecLock("GXL",.F.)
		GXL->GXL_EDIMSG := STR0002+aErro[4]+STR0003+aErro[6] //"Ocorreu um erro no campo: "###". Motivo: "
		GXL->GXL_EDISIT := "3"
	MsUnLock("GXL")
Return

Static Function GravaModel(oModel)
	Local lRet := .F.
	If ( lRet := oModel:VldData() )
		oModel:CommitData()
		RecLock("GXL",.F.)
			GXL->GXL_EDIMSG := ""
			GXL->GXL_EDISIT := "4"
		MsUnLock("GXL")
	EndIf
