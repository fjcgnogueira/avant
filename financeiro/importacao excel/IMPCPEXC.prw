#INCLUDE "Protheus.ch"

#Define CMD_OPENWORKBOOK		1
#Define CMD_CLOSEWORKBOOK		2
#Define CMD_ACTIVEWORKSHEET  	3
#Define CMD_READCELL			4

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³IMPCPEXC  º Autor ³ Amedeo D. P. Filho º Data ³  30/06/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Importacao de Contas a Pagar (Via Planilha Excel)          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Generico                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function IMPCPEXC()

	Local aPerg		:= {}
	Local aParam   	:= {	Space(70),;
							Space(10),;
							1,;
							Space(70)}

	Private cMenCNPJ	:= ""
	Private cMenExist	:= ""
	
	/*01*/AADD(aPerg,{6,"Arquivo a Processar "	,aParam[01]	,""	,".T."	,""	,80	,.T.," |*.*"	,"C:\",GETF_LOCALHARD+GETF_NETWORKDRIVE})
	/*02*/AADD(aPerg,{1,"Pasta da Planilha "	,aParam[02]	,"@!","",""	,""	,0	,.T.})
	/*03*/AADD(aPerg,{1,"Linha Inicial "		,aParam[03]	,"@!","",""	,""	,0	,.T.})	
	/*04*/AADD(aPerg,{1,"Coluna Prefixo "		,"K "		,"@!","",""	,""	,0	,.T.})
	/*05*/AADD(aPerg,{1,"Coluna Titulo "		,"I "		,"@!","",""	,""	,0	,.T.})
	/*06*/AADD(aPerg,{1,"Coluna Parcela "		,"J "		,"@!","",""	,""	,0	,.T.})
	/*07*/AADD(aPerg,{1,"Coluna Tipo "			,"N "		,"@!","",""	,""	,0	,.T.})
	/*08*/AADD(aPerg,{1,"Coluna CNPJ "			,"P "		,"@!","",""	,""	,0	,.T.})
	/*09*/AADD(aPerg,{1,"Coluna Valor "			,"A "		,"@!","",""	,""	,0	,.T.})
	/*10*/AADD(aPerg,{1,"Coluna Emissão "		,"X "		,"@!","",""	,""	,0	,.T.})
	/*11*/AADD(aPerg,{1,"Coluna Vencimento "	,"Y "		,"@!","",""	,""	,0	,.T.})
	/*12*/AADD(aPerg,{1,"Coluna Historico "		,"AN"		,"@!","",""	,""	,0	,.T.})
	/*13*/AADD(aPerg,{6,"Arquivo DLL "			,aParam[04]	,""	,".T."	,""	,80	,.T.," |*.*"	,"C:\",GETF_LOCALHARD+GETF_NETWORKDRIVE})

	If ParamBox(aPerg,"",,,,,,,,"IMPCPEXC",.T.,.T.)
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Processa Leitura / Gravacao			|
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		oProcess := MsNewProcess():New({|| LEARQUIVO(	MV_PAR01,MV_PAR02,MV_PAR03,MV_PAR04,;
														MV_PAR05,MV_PAR06,MV_PAR07,MV_PAR08,;
														MV_PAR09,MV_PAR10,MV_PAR11,MV_PAR12,;
														MV_PAR13,oProcess )}, "Selecionando Dados","Por favor Aguarde",.T.)
		oProcess:Activate()	

		If !Empty(cMenCNPJ)
			Aviso("Aviso","CNPJ / CPF não encontrado no cadastro de Fornecedores" + CRLF + CRLF + cMenCNPJ,{"Ok"},3)
		EndIf
		
		If !Empty(cMenExist)
			Aviso("Aviso","Títulos já cadastrados no Contas a Pagar" + CRLF + CRLF + cMenExist,{"Ok"},3)
		EndIf

		MsgInfo("Processo Finalizado")

	EndIf

Return Nil

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ FUNCTION LEARQUIVO                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function LEARQUIVO(	cArquivo, cPasta	, nCelini	, cPrefixo	,;
							cTitulo	, cParcela	, cTipo		, cCNPJ		,;
							cValor	, cEmissao	, cVencto	, cHistor	,;
							cArqDLL	, oObjReg)

	Local nHdl    	:= ExecInDLLOpen(cArqDLL)
	Local cBuffer	:= ""
	Local lContinua	:= .T.
	Local nPlan		:= 0
	Local nCel		:= 0

	Local cVarPref	:= ""			//Prefixo
	Local cVarNum	:= ""			//Numero do Titulo
	Local cVarParc	:= ""			//Parcela
	Local cVarTipo	:= ""			//Tipo
	Local cVarCNPJ	:= ""			//CNPJ
	Local nVarValor	:= ""			//Valor
	Local dVarEmiss	:= CtoD("")		//Emissao
	Local dVarVenc	:= CtoD("")		//Vencimento
	Local cVarHist	:= ""			//Historico
	Local cOrigem	:= "FINA050"	//Origem
	Local cFornece	:= ""			//Cod. Fornecedor
	Local cLojaFor	:= ""			//Loja do Fornecedor
	Local cChave	:= ""
	
	Local lExecuta	:= .T.
	Local aValues	:= {}
	
	Private cCelPref	:= cPrefixo
	Private cCelTit		:= cTitulo
	Private cCelParc	:= cParcela
	Private cCelTipo	:= cTipo
	Private cCelCNPJ	:= cCNPJ
	Private cCelValor	:= cValor
	Private cCelEmiss	:= cEmissao
	Private cCelVencto	:= cVencto
	Private cCelHist	:= cHistor

	Private aCells		:= {}
	Private lMsErroAuto	:= .F.
	
	For nPlan := 1 To 1

		SetArray(aCells,nCelini)

		If !( nHdl >= 0 )
			Aviso("Aviso","Não foi possivel carregar a DLL " + cArqDLL,{"Retornar"},2)
			Return Nil
		Else

			//Carrega o Excel e Abre o arquivo
			cBuffer := cArquivo + Space(512)
			nBytes  := ExeDLLRun2(nHdl, CMD_OPENWORKBOOK, @cBuffer)

			//Verifica se Arquivo Foi aberto Corretamente
			If ( nBytes < 0 )
				Aviso("Aviso","Não foi possivel abrir o arquivo : " + cArquivo,{"Ok"})
				Return Nil
			ElseIf ( nBytes > 0 )
				MsgStop(Substr(cBuffer, 1, nBytes))
				Return Nil
			EndIf
	        
			//Abre a Pasta p/ Iniciar a Leitura
			cBuffer := cPasta + Space(512)
			ExeDLLRun2(nHdl, CMD_ACTIVEWORKSHEET, @cBuffer)
	
			oObjReg:SetRegua1( 0 )

			nCel := 1

			While lContinua
			
				nSeq 		:= 1
				aValues		:= {}
				cFornece 	:= ""
				cLojaFor	:= ""
				cChave		:= ""
				lExecuta	:= .T.
				
				//Prefixo
				cBuffer	:= aCells[nCel][nSeq] + Space(1024)
				nBytes	= ExeDLLRun2(nHdl, CMD_READCELL, @cBuffer)
				cVarPref	:= Substr(cBuffer, 1, nBytes)
				nSeq ++

				//Titulo
				cBuffer	:= aCells[nCel][nSeq] + Space(1024)
				nBytes	= ExeDLLRun2(nHdl, CMD_READCELL, @cBuffer)
				cVarNum		:= Substr(cBuffer, 1, nBytes)
				cVarNum		:= StrTran(cVarNum, "/", "")
				cVarNum		:= StrTran(cVarNum, "-", "")
				cVarNum 	:= StrTran(cVarNum, " ", "")
				nSeq ++

				//Parcela
				cBuffer	:= aCells[nCel][nSeq] + Space(1024)
				nBytes	= ExeDLLRun2(nHdl, CMD_READCELL, @cBuffer)
				cVarParc	:= Left(Substr(cBuffer, 1, nBytes),02)
				nSeq ++

				//Tipo
				cBuffer	:= aCells[nCel][nSeq] + Space(1024)
				nBytes	= ExeDLLRun2(nHdl, CMD_READCELL, @cBuffer)
				cVarTipo	:= Substr(cBuffer, 1, nBytes)
				If Empty(cVarTipo) .Or. Alltrim(cVarTipo) == "unknown error in command"
					cVarTipo := PadR("DP", TamSx3("E2_TIPO")[1])
				EndIf
				nSeq ++

				//CNPJ
				cBuffer	:= aCells[nCel][nSeq] + Space(1024)
				nBytes	= ExeDLLRun2(nHdl, CMD_READCELL, @cBuffer)
				cVarCNPJ	:= Substr(cBuffer, 1, nBytes)
				nSeq ++
				
				DbSelectarea("SA2")
				SA2->(DbSetorder(3))
				If SA2->(DbSeek(xFilial("SA2") + cVarCNPJ))
					cFornece 	:= SA2->A2_COD
					cLojaFor	:= SA2->A2_LOJA
				Else
					lExecuta	:= .F.
					cMenCNPJ	+= PadR(cVarCNPJ, TamSx3("A2_CGC")[1]) + CRLF
				EndIf

				//Valor
				cBuffer	:= aCells[nCel][nSeq] + Space(1024)
				nBytes	= ExeDLLRun2(nHdl, CMD_READCELL, @cBuffer)
				nVarValor	:= StrTran(Substr(cBuffer, 1, nBytes),",",".")
				nVarValor	:= NoRound(Val(nVarValor), TamSx3("CT2_VALOR")[2])
				nSeq ++

				//Emissao
				cBuffer	:= aCells[nCel][nSeq] + Space(1024)
				nBytes	= ExeDLLRun2(nHdl, CMD_READCELL, @cBuffer)
				dVarEmiss	:= Substr(cBuffer, 1, nBytes)
				dVarEmiss	:= CtoD(dVarEmiss)
				nSeq ++

				//Vencimento
				cBuffer	:= aCells[nCel][nSeq] + Space(1024)
				nBytes	= ExeDLLRun2(nHdl, CMD_READCELL, @cBuffer)
				dVarVenc	:= Substr(cBuffer, 1, nBytes)
				dVarVenc	:= CtoD(dVarVenc)
				nSeq ++

				//Historico
				cBuffer	:= aCells[nCel][nSeq] + Space(1024)
				nBytes	= ExeDLLRun2(nHdl, CMD_READCELL, @cBuffer)
				cVarHist	:= Substr(cBuffer, 1, nBytes)
				nSeq ++

				oObjReg:IncRegua1( "Lendo Título : " + cVarNum  )

				If Empty( Alltrim(cVarNum) )
					lContinua := .F.
				EndIf
				
				If lContinua .And. lExecuta

					cChave := 	PadR(cVarPref, TamSx3("E2_PREFIXO")[1]) +;
								PadR(cVarNum, TamSx3("E2_NUM")[1]) +;
								PadR(cVarParc, TamSx3("E2_PARCELA")[1]) +;
								PadR(cVarTipo, TamSx3("E2_TIPO")[1]) +;
								PadR(cFornece, TamSx3("E2_FORNECE")[1]) +;
								PadR(cLojaFor, TamSx3("E2_LOJA")[1])
					
					DbSelectarea("SE2")
					SE2->(DbSetorder(1))
					If !SE2->(DbSeek(xFilial("SE2") + cChave))
						
						//Faz a inclusao do Titulo a Pagar
						Aadd(aValues,{"E2_FILIAL"	, xFilial("SE2")	, Nil	})
						Aadd(aValues,{"E2_PREFIXO"	, cVarPref			, Nil	})
						Aadd(aValues,{"E2_NUM"		, cVarNum			, Nil	})
						Aadd(aValues,{"E2_PARCELA"	, cVarParc			, Nil	})
						Aadd(aValues,{"E2_TIPO"		, cVarTipo			, Nil	})
						Aadd(aValues,{"E2_FORNECE"	, cFornece			, Nil	})
						Aadd(aValues,{"E2_LOJA"		, cLojaFor			, Nil	})
						Aadd(aValues,{"E2_VALOR"	, nVarValor			, Nil	})
						Aadd(aValues,{"E2_EMISSAO"	, dVarEmiss			, Nil	})
						Aadd(aValues,{"E2_VENCTO"	, dVarVenc			, Nil	})
						Aadd(aValues,{"E2_HIST"		, cVarHist			, Nil	})
						Aadd(aValues,{"E2_ORIGEM"	, cOrigem			, Nil	})
	
						lMsErroAuto	:= .F.
						
						oObjReg:SetRegua2( 1 )
						oObjReg:IncRegua2( "Importando Título : " + cVarNum  )
	
						MSExecAuto({|a, b, c| FINA050(a, b, c)}, aValues, Nil, 3)
						
						If lMsErroAuto
							MostraErro()
						EndIf
                    
					Else
						cMenExist += "Num.: " + cVarNum + " Parcela: " + cVarParc + CRLF
					EndIf
					
				EndIf

				nCel ++
				nCelini ++

				//Dimensiona Array
				SetArray(aCells,nCelini)

			Enddo
		
			//Fecha o arquivo e remove o Excel da memoria
			cBuffer := Space(512)
			ExeDLLRun2(nHdl, CMD_CLOSEWORKBOOK, @cBuffer)
			ExecInDLLClose(nHdl)

		EndIf

	Next nPlan
	
Return Nil
				
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ FUNCTION SETARRAY                                ³
//³ Dimensiona o Array para Receber Conteudo da      ³
//³ Proxima Linha da Planilha.                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function SetArray(aCells,nPos)

	Local cPosicao	:= Alltrim(Str(nPos))
	
	Aadd(aCells,{	Alltrim(cCelPref)	+ cPosicao,;
					Alltrim(cCelTit)	+ cPosicao,;
					Alltrim(cCelParc)	+ cPosicao,;
					Alltrim(cCelTipo)	+ cPosicao,;
					Alltrim(cCelCNPJ)	+ cPosicao,;
					Alltrim(cCelValor)	+ cPosicao,;
					Alltrim(cCelEmiss)	+ cPosicao,;
					Alltrim(cCelVencto)	+ cPosicao,;
					Alltrim(cCelHist)	+ cPosicao})
Return Nil