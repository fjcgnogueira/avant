#include "PROTHEUS.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ IntNFDev()  º Autor ³ Fernando Nogueira  º Data ³06/03/2014º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Integra Nota de Trocas/Devolucao Web                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico AVANT.                                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÏÍÍÍÑÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAnalista Resp.³  Data  ³ Manutencao Efetuada                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º              ³  /  /  ³                                        	      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function IntNFDev(cEmpInt, cFilInt, cNumTroca, cMensagem, cDocumen, lAutomatic)
//U_IntNFDev('01', '010104', '000001', '', '', .F.)

Local aTabelas	 := {"SA1","SA2","SB1","SE1","SF1","SD1","SF2","SD2","SZI","SZH"}
Local cPathLog	 := "\LOGS\"
Local cFileLog	 := "MATA103.LOG"
Local cModulo	 := "COM"
Local cAliasSF1	 := GetNextAlias()
Local lRetorno	 := .T.
Local _aCabSF1   := {}
Local _aItem     := {}
Local _aItensSD1 := {}
Local _cChave    := cFilInt+cNumTroca
Local cNumero    := ""
Local cSerie     := ""
Local dEmissao   := dDataBase
Local cArmazem   := GetMV("ES_ARMTROC")

Default cMensagem   := ""
Default cDocumen    := ""
Default lAutomatic	:= .F.

Private lMsHelpAuto := .F.
Private lMsErroAuto := .F.

If lAutomatic
	RpcClearEnv()
	RPCSetType(3)
	RpcSetEnv(cEmpInt, cFilInt, Nil, Nil, cModulo, Nil, aTabelas, Nil, Nil, Nil, Nil)
EndIf

//Verifica se a Devolucao WEB ja esta no SF1 (Notas de Entrada Protheus)
BeginSQL Alias cAliasSF1
	SELECT	R_E_C_N_O_	AS RECSF1
	FROM	%Table:SF1%
	WHERE	%NotDel%
	AND 	F1_FILIAL = %Exp:xFilial("SF1")%
	AND		F1_NUMTRC = %Exp:cNumTroca%
EndSQL

If !(cAliasSF1)->(Eof())
	lRetorno 	:= .F.
	cMensagem	:= "Atenção: Erro ao processar sua devolução; Informe seu representante, codigo:01-Devolução já cadastrado no Sistema Nro(s)"
	
	While !(cAliasSF1)->(Eof())
		DbSelectarea("SF1")
		SF1->(DbGoto( (cAliasSF1)->RECSF1 ))
		cMensagem += " - " + SF1->F1_DOC
		(cAliasSF1)->(DbSkip())
	Enddo
EndIf

(cAliasSF1)->(DbCloseArea())

If lRetorno

	SZH->(dbSetOrder(1))
	
	If SZH->(msSeek(_cChave))
	
		If SZH->ZH_STATUS <> "1"
			lRetorno 	:= .F.
			cMensagem	:= "Devolucao: " + cNumTroca + " Está com Status " + SZH->ZH_STATUS + " Na tabela de Integração"
		Else
			If SZH->ZH_FORMUL == "N"
				cSerie     := SZH->ZH_SERICLI
				cNumero    := SZH->ZH_NFCLIEN
				dEmissao   := SZH->ZH_EMISSAO
			Else
				cSerie  := "1  "
				cNumero := U_NumDoc(cSerie)
			EndIf
			cDocumen := cNumero+"/"+cSerie
			
			// Cabecalho da Nota de Troca/Devolucao
			Aadd(_aCabSF1,{"F1_FILIAL"    ,SZH->ZH_FILIAL     ,Nil})
			Aadd(_aCabSF1,{"F1_DOC"       ,cNumero            ,Nil})
			Aadd(_aCabSF1,{"F1_SERIE"     ,cSerie             ,Nil})
			Aadd(_aCabSF1,{"F1_FORNECE"   ,SZH->ZH_CLIENTE    ,Nil})
			Aadd(_aCabSF1,{"F1_LOJA"      ,SZH->ZH_LOJA       ,Nil})
			Aadd(_aCabSF1,{"F1_EMISSAO"   ,dEmissao           ,Nil})
			Aadd(_aCabSF1,{"F1_EST"       ,SZH->ZH_EST        ,Nil})
			Aadd(_aCabSF1,{"F1_TIPO"      ,"D"                ,Nil})
			Aadd(_aCabSF1,{"F1_FORMUL"    ,SZH->ZH_FORMUL     ,Nil})
			Aadd(_aCabSF1,{"F1_ESPECIE"   ,"NF"               ,Nil})
			Aadd(_aCabSF1,{"F1_DTDIGIT"   ,dDatabase          ,Nil})
			Aadd(_aCabSF1,{"F1_HORA"      ,SubStr(Time(),1,5) ,Nil})
			Aadd(_aCabSF1,{"F1_NUMTRC"    ,SZH->ZH_NUMTRC     ,Nil})
			
			If SZH->ZH_FORMUL == "N"
				Aadd(_aCabSF1,{"F1_CHVNFE"    ,SZH->ZH_CHVNFE     ,Nil})
			Endif
			
			SZI->(dbSetOrder(1))
			If SZI->(msSeek(_cChave))
				
				// Posiciona no Cabecalho da Nota Original
				SF2->(dbSetOrder(1))
				SF2->(msSeek(cFilInt+SZI->ZI_NFORI+SZI->ZI_SERIORI+SZI->ZI_CLIENTE+SZI->ZI_LOJA))
				
				While SZI->(!EoF()) .And. SZI->ZI_FILIAL+SZI->ZI_NUMTRC == _cChave
				
					_aItem := {}
					
					// Posiciona no Item da Nota Original
					SD2->(dbSetOrder(3))
					SD2->(msSeek(cFilInt+SZI->ZI_NFORI+SZI->ZI_SERIORI+SZI->ZI_CLIENTE+SZI->ZI_LOJA+SZI->ZI_PRODUTO+SZI->ZI_ITEMORI))
				
					// Itens da Nota de Troca/Devolucao
					Aadd(_aItem,{"D1_COD"    ,SZI->ZI_PRODUTO ,Nil})
					Aadd(_aItem,{"D1_UM"     ,SZI->ZI_UM      ,Nil})
					Aadd(_aItem,{"D1_QUANT"  ,SZI->ZI_QUANT   ,Nil})
					Aadd(_aItem,{"D1_VUNIT"  ,SZI->ZI_VLRUNIT ,Nil})
					Aadd(_aItem,{"D1_TES"    ,Posicione("SF4",1,xFilial("SF4")+SD2->D2_TES,"F4_TESTRC") ,Nil})
					Aadd(_aItem,{"D1_NFORI"  ,SZI->ZI_NFORI   ,Nil})
					Aadd(_aItem,{"D1_SERIORI",SZI->ZI_SERIORI ,Nil})
					Aadd(_aItem,{"D1_ITEMORI",SZI->ZI_ITEMORI ,Nil})
					Aadd(_aItem,{"D1_FORNECE",SZI->ZI_CLIENTE ,Nil})
					Aadd(_aItem,{"D1_LOJA"   ,SZI->ZI_LOJA    ,Nil})
					Aadd(_aItem,{"D1_LOCAL"  ,cArmazem        ,Nil})
					Aadd(_aItem,{"D1_DOC"    ,cNumero 		  ,Nil})
					Aadd(_aItem,{"D1_SERIE"  ,cSerie 		  ,Nil})
					Aadd(_aItem,{"D1_EMISSAO",dDataBase       ,Nil})
					If Empty(SD2->D2_LOTECTL)
						Aadd(_aItem,{"D1_LOTECTL",AllTrim(Formula("018")),Nil})
					Else
						Aadd(_aItem,{"D1_LOTECTL",SD2->D2_LOTECTL        ,Nil})
					Endif
					Aadd(_aItem,{"D1_NUMTRC"     ,SZI->ZI_NUMTRC         ,Nil})
					Aadd(_aItem,{"D1_ICMSRET"    ,SZI->ZI_ICMSRET        ,Nil})  // Fernando Nogueira - Chamado 004740
					
					Aadd(_aItensSD1, _aItem)
					
					SZI->(dbSkip())		
				End
					
				// Inclusao de Nota de Devolucao
				Begin Transaction	
					MsExecAuto({|x,y,z| MATA103(x,y,z)}, _aCabSF1, _aItensSD1, 3)
					If lMsErroAuto
						lRetorno  := .F.
						cMensagem := MostraErro(cPathLog, cFileLog)
						RollBackSx8()
					Else
						cDocumen := "Nota/Serie.: " + cDocumen + " Caro Cliente. Sua nota de devolução foi incluída com sucesso!"
					Endif
				End Transaction
				
				//Atualiza Status da SZH
				SZH->(RecLock("SZH", .F.))
				SZH->ZH_STATUS := IIF(lRetorno, "2", "3")
				// Status
				// 1 = Devolucao entra na Web (Nao enviado) / amarelo preparando para entrar no protheus
				// 2 = Integrado com Sucesso
				// 3 = Erro na Integracao
				// 4 = Sota transmitiu o layout
				// 5 = Gerado Pedido de Trocas
				// 6 = Vermelho pedido rejeitado pela logistica
				// 7 = Cinza nao coletado
				// 8 = Azul solicitado coleta
				// 9 = Verde integrado no protheus
				// A = Sem TES pedido sem TES cadastrada
				// B = Pedido de Trocas Parado para liberacao fiscal
				// C = Gerado reembolso ao cliente no Financeiro
				
				SZH->(MsUnlock())
			Else
			
				lRetorno 	:= .F.
				cMensagem	:= "Não encontrado ítens para a devolução: " + cNumTroca
			
			Endif
		Endif		
	Else
		cMensagem := "Troca não encontrada"
		conout(cMensagem)
		Return .F.
	Endif
Endif

Return lRetorno

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ NumDoc   º Autor ³ Fernando Nogueira  º Data ³  26/05/2014 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Recupera o proximo numero de Documento de Entrada          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Avant                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function NumDoc(cSerie)
	Local cNumDoc := GetSX8Num("SD1", "D1_DOC")

	DbSelectArea("SD1")
	DbSetOrder(1)

	While SD1->(DbSeek(xFilial("SD1") + cNumDoc + cSerie))
		ConfirmSx8()
		cNumDoc := GetSx8Num("SD1", "D1_DOC")
	Enddo

Return cNumDoc