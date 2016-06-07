#Include "Protheus.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³GIASTAV   ³ Autor ³ Fernando Nogueira     ³ Data ³07/06/2016³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³GIASTAV - Guia de Informacao e Apuracao do ICMS Mensal de   ³±±
±±³          ³Substituicao Tributaria para todos os estados brasileiros	  ³±±
±±³          ³Desenvolvimento com base no GIASTBR da Totvs				  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpD -> Data incial do periodo - mv_par01     			  ³±±
±±³          ³ExpD -> Data final do periodo - mv_par02                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao Efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function GIASTAV(dDtInicial, dDtFinal,cUf)
	Local aTrbs		:= {}

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Gera arquivos temporarios            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aTrbs := GeraTemp()
	
	Processa({||ProGIAST(dDtInicial, dDtFinal, cUf)})


Return (aTrbs)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ProGIAST   ³ Autor ³Fernando Nogueira      ³ Data ³07/06/2016³±± 
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Processa Registro da GIAST-BR                                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ProGIAST(dDtInicial, dDtFinal,cUf)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Processa Regitros                                                       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	ProcPrinc(dDtInicial, dDtFinal, cUf)		//Registro Principal

Return Nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ProGIAST   ³ Autor ³Rodrigo Zatt           ³ Data ³ 18.12.08 ³±± 
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Processamento do Registro Principal                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ProcPrinc(dDtInicial, dDtFinal,cUF)
	Local cAliasFTE 	:= "FTE"
	Local cAliasFTS    	:= "FTS"
	Local cRessarST    	:= Getnewpar("MV_RESST","")
	Local cCombusST   	:= Getnewpar("MV_COMBST","")	
	Local cTransfST   	:= Getnewpar("MV_TRANFST","") 
	Local nVlrProd 		:= 0 
	Local nVlrIPI      	:= 0
	Local nVlrDesp		:= 0
	Local nVlrIcms  	:= 0
	Local nBaseST  		:= 0
	Local nVlrST		:= 0
	Local nBaseProp  	:= 0 
    Local nVlrDev      	:= 0
    Local nVlrRessarc  	:= 0
    Local nVlrComb    	:= 0
    Local nVlrCombST  	:= 0      
    Local nValorV     	:= 0 
	Local nContRG1    	:= 0
	Local nContRG2    	:= 0
	Local nContRG3    	:= 0
	Local nValDifal		:= 0
	Local nTotDifal		:= 0
	Local nTotFecp		:= 0
    Local cVencto     	:= ""
    Local cCnpjFor 		:= "" 			
    Local cSelect		:= ""
    Local cFrom			:= ""
    Local cWhere		:= ""
    Local cAliasQry		:= ""
	Local cSubtrib    	:= IIf(FindFunction("GETSUBTRIB"), GetSubTrib(), SuperGetMv("MV_SUBTRIB")) //mauro
	Local cInsc       	:= Substr(cSubtrib,At(cUF,cSubtrib)+2,99) 	
    Local cInscOutrEst	:= Iif(At("/",cInsc)>0,Substr(cInsc,0,At("/",cInsc)-1),cInsc)      

	#IFDEF TOP
		Local aStruFTE  := {}
		Local aStruFTS  := {}		
		Local cQuery   	:=	""
		Local nX		:=	0
	#ENDIF

	#IFDEF TOP    
    If TcSrvType()<>"AS/400"
		lQuery		:= .T.
		cAliasFTS	:= "FTS_GIAST"
		aStruFTS	:= SFT->(dbStruct())
		cQuery		:= "SELECT * "
		cQuery    	+= "FROM " + RetSqlName("SFT") + " "
		cQuery    	+= "WHERE FT_FILIAL = '" + xFilial("SFT") + "' AND "
		cQuery 		+= "FT_ENTRADA >= '" + Dtos(dDtInicial) + "' AND "				
		cQuery 		+= "FT_ENTRADA <= '" + Dtos(dDtFinal) + "' AND "
		cQuery 		+= "FT_TIPOMOV = 'S' AND "
		cQuery 		+= "FT_OBSERV NOT LIKE '%CANCEL%' AND "
		cQuery		+= "(FT_DIFAL > 0 OR "
		cQuery    	+= "FT_ICMSRET > 0) AND "
		cQuery    	+= "D_E_L_E_T_=' ' "
		cQuery 		:= ChangeQuery(cQuery)                       
		
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasFTS)
		For nX := 1 To len(cAliasFTS)
			If aStruFTS[nX][2] <> "C" .And. FieldPos(aStruFTS[nX][1])<>0
				TcSetField(cAliasFTS,aStruFTS[nX][1],aStruFTS[nX][2],aStruFTS[nX][3],aStruFTS[nX][4])
			EndIf
		Next nX

	Else
	#ENDIF
	    cIndex    := CriaTrab(NIL,.F.)
		cCondicao := 'FT_FILIAL == "' + xFilial("SFT") + '" .And. '
		cCondicao += 'DTOS(FT_ENTRADA) >= "' + Dtos(dDtInicial) + '" .And. '
		cCondicao += 'DTOS(FT_ENTRADA) <= "' + Dtos(dDtFinal) + '" .And. '
		cCondicao += "FT_TIPOMOV = 'S' .And. "
		cCondicao += "!('CANCEL' $ UPPER(FT_OBSERV)) .And. "
		cCondicao += "(FT_DIFAL > 0 .Or. FT_VFCPDIF > 0 .Or. "
		cCondicao += 'FT_ICMSRET > 0) '

	    IndRegua(cAliasFTS,cIndex,SFT->(IndexKey()),,cCondicao)
	    dbSelectArea(cAliasSFT)
	    ProcRegua(LastRec())
	    dbGoTop()
	#IFDEF TOP
		Endif    
	#ENDIF

	Do While !((cAliasFTS)->(Eof()))                                                 
		dbSelectArea("SA1") 
		SA1->(DbSetOrder(1))
		SA1->(DbSeek(xFilial("SA1")+(cAliasFTS)->FT_CLIEFOR+(cAliasFTS)->FT_LOJA))
	
	    dbSelectArea("SF2")        
		SF2->(dbSetOrder(1))
		SF2->(dbSeek(xFilial("SF2")+(cAliasFTS)->FT_NFISCAL+(cAliasFTS)->FT_SERIE+(cAliasFTS)->FT_CLIEFOR+(cAliasFTS)->FT_LOJA,.T.))
		
		If SF2->F2_EST == cUf
			nVlrProd	+= (cAliasFTS)->FT_TOTAL
			nVlrIPI		+= (cAliasFTS)->FT_VALIPI		
			nVlrDesp 	+= Iif((cAliasFTS)->FT_ICMSRET > 0,(cAliasFTS)->FT_DESPESA + (cAliasFTS)->FT_SEGURO,0)
			nBaseProp   += (cAliasFTS)->FT_BASEICM  
	 		nVlrIcms    += (cAliasFTS)->FT_VALICM
			nBaseST     += (cAliasFTS)->FT_BASERET  
	 		nVlrST      += (cAliasFTS)->FT_ICMSRET 		  
	 		nVlrComb 	+= Iif( Alltrim((cAliasFTS)->FT_CFOP)$cCombusST,(cAliasFTS)->FT_ICMSRET, 0) 
			nValDifal	+= (cAliasFTS)->FT_DIFAL
			nTotDifal	+= (cAliasFTS)->FT_DIFAL
			nTotFecp	+= (cAliasFTS)->FT_VFCPDIF
		EndIf
		(cAliasFTS)->(dbSkip())
	Enddo                      					

	#IFDEF TOP    
    If TcSrvType()<>"AS/400"
		lQuery		:= .T.
		cAliasFTE	:= "FTE_GIAST"
		aStruFTE	:= SFT->(dbStruct())
		cQuery		:= "SELECT FT_NFISCAL, FT_SERIE, FT_CLIEFOR, FT_LOJA, FT_BASERET, FT_ICMSRET, FT_CFOP, FT_ENTRADA, FT_TIPO, FT_ICMNDES, FT_NFORI, FT_SERORI "  
		cQuery    	+= "FROM " + RetSqlName("SFT") + " "
		cQuery    	+= "WHERE FT_FILIAL = '" + xFilial("SFT") + "' AND "
		cQuery 		+= "FT_ENTRADA >= '" + Dtos(dDtInicial) + "' AND "				
		cQuery 		+= "FT_ENTRADA <= '" + Dtos(dDtFinal) + "' AND "
		cQuery    	+= "FT_TIPOMOV = 'E' AND "	
		cQuery    	+= "FT_OBSERV NOT LIKE '%CANCEL%' AND "
		cQuery    	+= "FT_ICMSRET > 0 AND FT_TIPO NOT IN ('S') AND "
		cQuery    	+= "D_E_L_E_T_=' ' "
		cQuery 		:= ChangeQuery(cQuery)                       
		
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasFTE)
		For nX := 1 To len(aStruFTE)
			If aStruFTE[nX][2] <> "C" .And. FieldPos(aStruFTE[nX][1])<>0
				TcSetField(cAliasFTE,aStruFTE[nX][1],aStruFTE[nX][2],aStruFTE[nX][3],aStruFTE[nX][4])
			EndIf
		Next nX

	Else
	#ENDIF
	    cIndex    := CriaTrab(NIL,.F.)       
		cCondicao := 'FT_FILIAL == "' + xFilial("SFT") + '" .And. '
		cCondicao += 'DTOS(FT_ENTRADA) >= "' + Dtos(dDtInicial) + '" .And. '
		cCondicao += 'DTOS(FT_ENTRADA) <= "' + Dtos(dDtFinal) + '" .And. ' 
		cCondicao += "FT_TIPOMOV = 'E' .And. "
		cCondicao += "!('CANCEL' $ UPPER(FT_OBSERV)) .And. "
		cCondicao += 'FT_ICMSRET > 0 '

	    IndRegua(cAliasFTE,cIndex,SFT->(IndexKey()),,cCondicao)
	    dbSelectArea(cAliasFTE)
	    ProcRegua(LastRec())
	    dbGoTop()
	#IFDEF TOP
	Endif    
	#ENDIF
	 
	Do While !((cAliasFTE)->(Eof())) 
			dbSelectArea("SA2") 
			SA2->(DbSetOrder(1))
			SA2->(DbSeek(xFilial("SA2")+(cAliasFTE)->FT_CLIEFOR+(cAliasFTE)->FT_LOJA))
		    cInscA2 = SA2->A2_INSCR   
		    dbSelectArea("SA1") 
	     	SA1->(DbSetOrder(1))
	        SA1->(DbSeek(xFilial("SA1")+(cAliasFTE)->FT_CLIEFOR+(cAliasFTE)->FT_LOJA))
			dbSelectArea("SF1")        
			SF1->(dbSetOrder(1))
			SF1->(dbSeek(xFilial("SF1")+(cAliasFTE)->FT_NFISCAL+(cAliasFTE)->FT_SERIE+(cAliasFTE)->FT_CLIEFOR+(cAliasFTE)->FT_LOJA,.T.))
						
			If SF1->F1_EST == cUf 
		 		If (cAliasFTE)->FT_TIPO == 'D' .Or. ((cAliasFTE)->FT_TIPO $ 'D|B' .And. AT("MG",cSubtrib) <> 0) 
		 			RG1->(DbSetOrder(1))
		 			dbSelectArea("RG1")
			        If !(RG1->(dbSeek(padr((cAliasFTE)->FT_NFISCAL,13,' ')+(cAliasFTE)->FT_SERIE)))
						RecLock("RG1",.T.)		
						RG1->NFISCAL	:= (cAliasFTE)->FT_NFISCAL
						RG1->SERIE  	:= (cAliasFTE)->FT_SERIE
						RG1->IE		 	:= SA1->A1_INSCR
						RG1->EMISSAO	:= Dtos((cAliasFTE)->FT_ENTRADA)
						RG1->ICMSDEV	:= (cAliasFTE)->FT_ICMSRET
		            	RG1->CONTRG1    := nContRG1
			 			nVlrDev 		+= (cAliasFTE)->FT_ICMSRET
				    	nContRG1 += 1
						MsUnlock()
				    Else
				       	RecLock("RG1",.F.)
			       		RG1->ICMSDEV	+= (cAliasFTE)->FT_ICMSRET
		       			nVlrDev 		+= (cAliasFTE)->FT_ICMSRET
			       		MsUnlock()
				    EndIf
				EndIf			            
				
                //Busca as notas fiscais de complemento de devolução - solicitado no chamado TIGTO8   
				If (cAliasFTE)->FT_TIPO $'I|C|P'  .And. !Empty( (cAliasFTE)->FT_NFORI) .And. !Empty( (cAliasFTE)->FT_SERORI) // Verifica se tem a NF é de complemento e se tem NF/Serie original preenchida
					IF (SA2->(dbSeek(xFilial("SA2")+(cAliasFTE)->FT_CLIEFOR+(cAliasFTE)->FT_LOJA))) // Verifica se o fornecedor existe e guarda o CNPJ na variave,                                                                                                                                      
				 		cCnpjFor:= SA2->A2_CGC
						SF1->(dbSetOrder(1))
						IF (SF1->(dbSeek(xFilial("SF1")+(cAliasFTE)->FT_NFORI+(cAliasFTE)->FT_SERORI))  .And. SF1->F1_TIPO=="D") //Verifica se existe a nota/serie da Devolução informada manualmente
							IF (SA1->(dbSeek(xFilial("SA1")+SF1->F1_FORNECE+SF1->F1_LOJA))) .And. SA1->A1_CGC == cCnpjFor	//Verifica se o Cliente existe e compara com o CNPJ do Fornecedor
								RG1->(DbSetOrder(1))
						   		dbSelectArea("RG1")   
						        If !(RG1->(dbSeek(padl((cAliasFTE)->FT_NFISCAL,13,' ')+(cAliasFTE)->FT_SERIE)))
									RecLock("RG1",.T.)		
									RG1->NFISCAL	:= (cAliasFTE)->FT_NFISCAL
									RG1->SERIE  	:= (cAliasFTE)->FT_SERIE
									RG1->IE		 	:= SA2->A2_INSCR
									RG1->EMISSAO	:= Dtos((cAliasFTE)->FT_ENTRADA)
									RG1->ICMSDEV	:= (cAliasFTE)->FT_ICMSRET
						           	RG1->CONTRG1    := nContRG1
						 			nVlrDev 		+= (cAliasFTE)->FT_ICMSRET
							    	nContRG1 += 1
									MsUnlock()
							    Else
							       	RecLock("RG1",.F.)
						       		RG1->ICMSDEV	+= (cAliasFTE)->FT_ICMSRET
						   			nVlrDev 		+= (cAliasFTE)->FT_ICMSRET
						       		MsUnlock()
						    	EndIf  
                               EndIf
						EndIf	    
					EndIf 
				EndIf			

		    	If Alltrim((cAliasFTE)->FT_CFOP)$cTransfST	
					dbSelectArea("RG3")  
					IF !RG3->(dbSeek(Alltrim(SA2->A2_INSCR)))
						RecLock("RG3",.T.)
						RG3->IE		 	:= If ((cAliasFTE)->FT_TIPO =='D',SA1->A1_INSCR,SA2->A2_INSCR)
						RG3->BASE		:= (cAliasFTE)->FT_BASERET
						RG3->ICMSTR		:= (cAliasFTE)->FT_ICMSRET 
						RG3->CONTRG3    += 1
						nContRG3 		+= 1
					Else                 
						RecLock("RG3",.F.)
						RG3->BASE		+= (cAliasFTE)->FT_BASERET
						RG3->ICMSTR		+= (cAliasFTE)->FT_ICMSRET					
					EndIf
					MsUnlock()           
				EndIf
				If Alltrim((cAliasFTE)->FT_CFOP)$cRessarST   
					RG2->(DbSetOrder(1))
		 			dbSelectArea("RG2")
			        If !(RG2->(dbSeek((cAliasFTE)->FT_NFISCAL+(cAliasFTE)->FT_SERIE)))					
						nContRG2 += 1
						RecLock("RG2",.T.)
						RG2->NFISCAL	:= (cAliasFTE)->FT_NFISCAL
						RG2->SERIE  	:= (cAliasFTE)->FT_SERIE
						RG2->IE		 	:= SA2->A2_INSCR 
						RG2->EMISSAO	:= Dtos((cAliasFTE)->FT_ENTRADA)
						RG2->ICMSRES	:= (cAliasFTE)->FT_ICMSRET
						RG2->CONTRG2    += 1
		            	nVlrRessarc	    += (cAliasFTE)->FT_ICMSRET
						MsUnlock()
			   		Else
						RecLock("RG2",.F.)
						RG2->ICMSRES	+= (cAliasFTE)->FT_ICMSRET
						nVlrRessarc	    += (cAliasFTE)->FT_ICMSRET
						MsUnlock()
					EndIf
				EndIf
				
				If Alltrim((cAliasFTE)->FT_CFOP)$cCombusST	 
					nVlrCombST 	+= (cAliasFTE)->FT_ICMNDES   
				Else
					nVlrCombST 	+= 0
				EndIf   		    
		    Endif			
		    (cAliasFTE)->(dbSkip())
	EndDo		                                          

	cSelect	+= "SF6.F6_DTVENC AS F6_DTVENC, SF6.F6_VALOR AS F6_VALOR "
	cFrom	+= RetSQLName( "SF6" ) + " SF6 "
	cWhere	+= "SF6.F6_FILIAL = '" + xFilial( "SF6" ) + "' AND "
	cWhere	+= "SF6.F6_MESREF = '" + Alltrim(Str(Month(dDtInicial))) + "' AND SF6.F6_ANOREF = '" + Alltrim(Str(Year(dDtFinal))) + "' AND "
	cWhere	+= "SF6.F6_EST = '" + cUf + "' AND SF6.D_E_L_E_T_ = ''"
	
	cSelect  := "%" + cSelect  + "%" 
	cFrom    := "%" + cFrom    + "%" 
	cWhere   := "%" + cWhere   + "%"
	
	If (TcSrvType ()<>"AS/400")
	
		cAliasQry	:=	GetNextAlias()
		
		BeginSql Alias cAliasQry
			SELECT 
				%Exp:cSelect%
			FROM 
				%Exp:cFrom%
			WHERE 
				%Exp:cWhere%
		EndSql
	Endif	
	            
	cVencto  := (cAliasQry)->F6_DTVENC
   	nValorV  := (cAliasQry)->F6_VALOR

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Processamento Registro RGP	            		                       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ       
	dbSelectArea("RGP")
	RecLock("RGP",.T.)
	RGP->IE         := cInscOutrEst
	RGP->PERIODOREF	:= StrZero(Month(dDtInicial),2)+StrZero(Year(dDtInicial),4)
	RGP->VENCTO	 	:= cVencto
	RGP->VALORV	 	:= Iif(!Empty(cVencto),nValorV,0)
	RGP->UF			:= SuperGetMv("MV_ESTADO")
	RGP->VLRPROD   	:= nVlrProd
	RGP->VLRIPI   	:= nVlrIPI
	RGP->DESP       := nVlrDesp
	RGP->BASECALC  	:= nBaseProp
	RGP->ICMSPROP 	:= nVlrIcms	
	RGP->BASEST  	:= nBaseSt
	RGP->ICMSSUBST 	:= nVlrST   
	RGP->DEVOL	 	:= nVlrDev
	RGP->RESSARC 	:= nVlrRessarc
	RGP->COMBUST 	:= nVlrComb
	RGP->IMPDEV 	:= nVlrST - nVlrDev -  nVlrRessarc 
	RGP->CREDPER 	:= 0
	RGP->TOTALREC   := (nVlrST - nVlrDev -  nVlrRessarc) + nVlrComb + nVlrCombST
	RGP->CIDADE     := SuperGetMv("MV_CIDADE")
	RGP->DATAP      := Dtos(dDataBase)  
	RGP->CONTRG1    := nContRG1
	RGP->CONTRG2    := nContRG2
	RGP->CONTRG3    := nContRG3
	RGP->ICMCOMB	:= nVlrCombST
	RGP->REF39TDIF	:= nValDifal
	RGP->REF39TFCP	:= nTotFecp
	MsUnlock()

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³   Atualiza Registro Anexo EC 87/15    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
   	If nTotDifal > 0
		dbSelectArea("RG4")
		IF !RG4->(dbSeek(Alltrim(cVencto)))
			RecLock("RG4",.T.)
			RG4->DTVENC		:= cVencto					// Data de Vencimento do ICMS Devido à UF de Destino
			RG4->VALIMCS	:= nTotDifal				// Valor do ICMS
			RG4->VENCFCP	:= "00000000"				// Data de Vencimento FCP
			RG4->VALFCP		:= nTotFecp					// Valor do ICMS FCP
		Else                 
			RecLock("RG4",.F.)
			RG4->VALIMCS	+= nTotDifal
			RG4->VALFCP	+= nTotFecp
		EndIf
		MsUnlock()
	Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Exclui area de trabalho utilizada - SFT³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !lQuery
		RetIndex("FTS")	
		dbClearFilter()	
		Ferase(cIndex+OrdBagExt())
		
		RetIndex("FTE")	
		dbClearFilter()	
	Else
		(cAliasFTE)->(DbCloseArea())
		(cAliasFTS)->(dbCloseArea())
	Endif

Return Nil				

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³GeraTemp   ³ Autor ³Rodrigo Zatt           ³ Data ³ 18.12.08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Gera arquivos temporarios                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function GeraTemp()
	Local aStru		:= {}
	Local aTrbs		:= {}
	Local cArq		:= ""   
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Registro Tipo P - registro Principal                                                                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
   	AADD(aStru,{"IE"       	    ,"C",014,0}) 
	AADD(aStru,{"PERIODOREF"	,"C",006,0})	//Periodo de Referencia - MMAAAA
	AADD(aStru,{"VENCTO"	    ,"C",008,0})	
	AADD(aStru,{"VALORV"    	,"N",015,2})	
	AADD(aStru,{"UF"		    ,"C",002,0})   	 
	AADD(aStru,{"VLRPROD"		,"N",015,2})   
	AADD(aStru,{"VLRIPI"		,"N",015,2})	
	AADD(aStru,{"DESP"			,"N",015,2})  	
	AADD(aStru,{"BASECALC"		,"N",015,2})  
	AADD(aStru,{"ICMSPROP"		,"N",015,2}) 
	AADD(aStru,{"BASEST"		,"N",015,2})
	AADD(aStru,{"ICMSSUBST"		,"N",015,2})	
	AADD(aStru,{"DEVOL"	    	,"N",015,2})
	AADD(aStru,{"RESSARC"		,"N",015,2})
	AADD(aStru,{"COMBUST"		,"N",015,2})
	AADD(aStru,{"IMPDEV"    	,"N",015,2})	
	AADD(aStru,{"CREDPER"   	,"N",015,2})	
	AADD(aStru,{"TOTALREC"  	,"N",015,2})	
	AADD(aStru,{"CIDADE"		,"C",030,0}) 
	AADD(aStru,{"DATAP"	    	,"C",008,2})	
	AADD(aStru,{"CONTRG1"    	,"N",006,0})	
	AADD(aStru,{"CONTRG2"    	,"N",006,0})		
	AADD(aStru,{"CONTRG3"    	,"N",006,0})	
	AADD(aStru,{"ICMCOMB"    	,"N",015,2})
	AADD(aStru,{"REF39TDIF"    	,"N",015,2})
	AADD(aStru,{"REF39TFCP"    	,"N",015,2})	
	
	cArq := CriaTrab(aStru)
	dbUseArea(.T.,__LocalDriver,cArq,"RGP")
	IndRegua("RGP",cArq,"PERIODOREF")
	AADD(aTrbs,{cArq,"RGP"})
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Registro Anexo I                                                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aStru	:= {}
	cArq	:= ""  
	AADD(aStru,{"NFISCAL"		,"C",013,0})   	
	AADD(aStru,{"SERIE"         ,"C",003,0})   
	AADD(aStru,{"IE"       	   ,"C",014,0}) 
	AADD(aStru,{"EMISSAO"    	,"C",008,0}) 
	AADD(aStru,{"ICMSDEV"    	,"N",015,2})
	AADD(aStru,{"CONTRG1"     	,"N",004,0})

	cArq := CriaTrab(aStru)
	dbUseArea(.T.,__LocalDriver,cArq,"RG1")                      	
	cIndRG1 := "RG1->NFISCAL+RG1->SERIE"
	IndRegua("RG1",cArq,cIndRG1)

	dbClearIndex()
	dbSetIndex(cArq + OrdBagExt())
	AADD(aTrbs,{cArq,"RG1"})
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Registro Anexo II                                                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aStru	:= {}
	cArq	:= ""  
	AADD(aStru,{"NFISCAL"		,"C",013,0})
	AADD(aStru,{"SERIE"  		,"C",003,0})
	AADD(aStru,{"IE"       		,"C",014,0})
	AADD(aStru,{"EMISSAO"    	,"C",008,0})
	AADD(aStru,{"ICMSRES"    	,"N",015,2})
	AADD(aStru,{"CONTRG2"     	,"N",004,0})

	cArq := CriaTrab(aStru)
	dbUseArea(.T.,__LocalDriver,cArq,"RG2")                      	
	cIndRG2 := "RG2->NFISCAL+RG2->SERIE"
	IndRegua("RG2",cArq,cIndRG2)
	dbClearIndex()
	dbSetIndex(cArq + OrdBagExt())
	
	
	AADD(aTrbs,{cArq,"RG2"})


	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Registro Anexo III                                                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aStru	:= {}
	cArq	:= ""       
	AADD(aStru,{"IE"       		,"C",014,0}) 	//Codigo CFOP - Verificar Tabela
	AADD(aStru,{"BASE"      	,"N",015,2}) 	//Base de Calculo
	AADD(aStru,{"ICMSTR"    	,"N",015,2})	//Insentas/Nao Tributadas
	AADD(aStru,{"CONTRG3"     	,"N",004,0})	//Outras

	cArq := CriaTrab(aStru)
	dbUseArea(.T.,__LocalDriver,cArq,"RG3")
	IndRegua("RG3",cArq,"IE")
	AADD(aTrbs,{cArq,"RG3"})

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Registro Anexo EC 87/15                                                     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aStru	:= {}
	cArq	:= ""       
	AADD(aStru,{"DTVENC"		,"C",008,0}) 	// Data de Vencimento do ICMS Devido à UF de Destino
	AADD(aStru,{"VALIMCS"	,"N",015,2}) 	// Valor do ICMS
	AADD(aStru,{"VENCFCP"	,"C",008,0})	// Data de Vencimento FCP
	AADD(aStru,{"VALFCP"		,"N",015,2})	// Valor do ICMS FCP

	cArq := CriaTrab(aStru)
	dbUseArea(.T.,__LocalDriver,cArq,"RG4")
	IndRegua("RG4",cArq,"DTVENC")
	AADD(aTrbs,{cArq,"RG4"})

Return (aTrbs)
