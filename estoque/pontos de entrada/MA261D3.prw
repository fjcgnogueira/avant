#Include "Totvs.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MA261D3   º Autor ³ Fernando Nogueira  º Data ³ 02/04/2018 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de Entrada Apos a Transferencia Mod. 2               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Avant - Chamado 005134                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MA261D3()

Local aArea     := GetArea()
Local aAreaSBE  := SBE->(GetArea())
Local aAreaSBF  := SBF->(GetArea())
Local aAreaSD3  := SD3->(GetArea())
Local cAliasSBE := GetNextAlias()
Local c1AliaSBF := GetNextAlias()
Local c2AliaSBF := GetNextAlias()
Local cAliasSDB := GetNextAlias()
Local lAltera   := .F.
Local nRecnoSBE := 0
Local cChaveD3  := ""

dbSelectArea("SBE")
dbSetOrder(01)
dbSeek(xFilial("SBE")+SD3->(D3_LOCAL+D3_LOCALIZ))
nRecnoSBE := SBE->(RECNO())

If SBE->BE_ESTFIS = '000001' .And. SD3->D3_COD <> SBE->BE_CODPRO

	lAltera := .T.

	// Lista os pickings do produto
	BeginSQL Alias c1AliaSBF
		SELECT BF_LOCAL,BF_LOCALIZ FROM %Table:SBF% 
		WHERE %NotDel%
			AND BF_FILIAL  =  %Exp:xFilial("SBF")%
			AND BF_LOCAL   =  %Exp:SD3->D3_LOCAL%
			AND BF_LOCALIZ <> %Exp:SD3->D3_LOCALIZ%
			AND BF_PRODUTO =  %Exp:SD3->D3_COD%
			AND BF_ESTFIS  =  '000001'
			AND BF_QUANT    > 0
	EndSQL
	
	(c1AliaSBF)->(dbGoTop())
	// Verifica se tem outro endereco com picking e o mesmo produto chumbado
	While (c1AliaSBF)->(!Eof())
		If SBE->(dbSeek(xFilial("SBE")+(c1AliaSBF)->(BF_LOCAL+BF_LOCALIZ))) .And. SBE->BE_ESTFIS = '000001' .And. SD3->D3_COD = SBE->BE_CODPRO
			lAltera := .F.
		Endif
	
		(c1AliaSBF)->(dbSkip())
	End
	(c1AliaSBF)->(DbCloseArea())
	
	If lAltera
		// Verifica se o picking tem outro produto com saldo
		BeginSQL Alias c2AliaSBF
			SELECT BF_LOCAL,BF_LOCALIZ,BF_PRODUTO FROM %Table:SBF% 
			WHERE %NotDel%
				AND BF_FILIAL  =  %Exp:xFilial("SBF")%
				AND BF_LOCAL   =  %Exp:SD3->D3_LOCAL%
				AND BF_LOCALIZ =  %Exp:SD3->D3_LOCALIZ%
				AND BF_PRODUTO <> %Exp:SD3->D3_COD%
				AND BF_ESTFIS  =  '000001'
				AND BF_QUANT    > 0
		EndSQL
		
		(c2AliaSBF)->(dbGoTop())
		// Verifica se tem outro produto com saldo e produto chumbado no mesmo picking
		While (c2AliaSBF)->(!Eof())
			If SBE->(dbSeek(xFilial("SBE")+(c2AliaSBF)->(BF_LOCAL+BF_LOCALIZ))) .And. SBE->BE_ESTFIS = '000001' .And. (c2AliaSBF)->BF_PRODUTO = SBE->BE_CODPRO
				lAltera := .F.
			Endif
		
			(c2AliaSBF)->(dbSkip())
		End
		(c2AliaSBF)->(DbCloseArea())
	Endif
	
	If lAltera
		// Lista os servicos pendentes do endereco de picking
		BeginSQL Alias cAliasSDB
			SELECT * FROM %Table:SDB% 
			WHERE %NotDel%
				AND DB_FILIAL  =  %Exp:xFilial("SDB")%
				AND DB_LOCAL   =  %Exp:SD3->D3_LOCAL%
				AND DB_LOCALIZ =  %Exp:SD3->D3_LOCALIZ%
				AND DB_PRODUTO <> %Exp:SD3->D3_COD%
				AND DB_TAREFA  =  '002'
				AND DB_TIPO    =  'E'
				AND DB_ESTORNO =  ''
				AND DB_STATUS  <> '1'
		EndSQL
		
		(cAliasSDB)->(dbGoTop())
		// Verifica se tem servico pendente de outro produto chumbado no mesmo picking
		While (cAliasSDB)->(!Eof())
			If SBE->(dbSeek(xFilial("SBE")+(cAliasSDB)->(DB_LOCAL+DB_LOCALIZ))) .And. SBE->BE_ESTFIS = '000001' .And. (cAliasSDB)->DB_PRODUTO = SBE->BE_CODPRO
				lAltera := .F.
			Endif
			
			(cAliasSDB)->(dbSkip())
		End
		(cAliasSDB)->(DbCloseArea())
	Endif
	
	If lAltera
	
		ConOut("["+DtoC(Date())+" "+Time()+"] [MA260D3F] Alteracao de Produto do Endereço "+AllTrim(SD3->D3_LOCALIZ))
	
		If SBE->(dbSeek(xFilial("SBE")+SD3->(D3_LOCAL+D3_LOCALIZ))) .And. SBE->BE_ESTFIS = '000001'
			SBE->(RecLock("SBE",.F.))
			SBE->BE_CODPRO := SD3->D3_COD
			SBE->(MsUnlock())
			
			// Limpa os os outros enderecos com o mesmo produto
			SBE->(dbSetOrder(07))
			If SBE->(dbSeek(xFilial("SBE")+SD3->D3_COD))
				While SBE->(!EoF()) .And. SBE->BE_CODPRO = SD3->D3_COD
				
					If SBE->BE_LOCALIZ <> SD3->D3_LOCALIZ .And. SBE->BE_ESTFIS = '000001' .And. SBE->BE_STATUS = '1'
						SBE->(RecLock("SBE",.F.))
						SBE->BE_CODPRO := Space(TamSx3("BE_CODPRO")[1])
						SBE->(MsUnlock())
					Endif
				
					SBE->(dbSkip())
				End
			Endif
		Endif
		
		SBE->(dbSetOrder(01))
		
		SD3->(dbSetOrder(03))
		cChaveD3 := SD3->(D3_COD+D3_LOCAL+D3_NUMSEQ)+"RE4"
		
		If SD3->(dbSeek(xFilial("SD3")+cChaveD3)) .And. SD3->D3_TM >= '500'
			If SBE->(dbSeek(xFilial("SBE")+SD3->(D3_LOCAL+D3_LOCALIZ))) .And. SBE->BE_CODPRO = SD3->D3_COD
				SBE->(RecLock("SBE",.F.))
				SBE->BE_CODPRO := Space(TamSx3("BE_CODPRO")[1])
				SBE->(MsUnlock())
				
				SBF->(dbSetOrder(01))
				If SBF->(dbSeek(xFilial("SBF")+SD3->(D3_LOCAL+D3_LOCALIZ)))
					While SBF->(!EoF()) .And. SBF->(xFilial("SBF")+BF_LOCAL+BF_LOCALIZ) = SD3->(xFilial("SD3")+D3_LOCAL+D3_LOCALIZ)

						// Verifica se tem outro picking com esse produto
						BeginSQL Alias cAliasSBE
							SELECT BE_LOCAL,BE_LOCALIZ,BE_CODPRO FROM %Table:SBE% 
							WHERE %NotDel%
								AND BE_FILIAL  =  %Exp:xFilial("SBE")%
								AND BE_LOCAL   =  %Exp:SBF->BF_LOCAL%
								AND BE_LOCALIZ <> %Exp:SBF->BF_LOCALIZ%
								AND BE_CODPRO  =  %Exp:SBF->BF_PRODUTO%
								AND BE_ESTFIS  =  '000001'
						EndSQL
						
						(cAliasSBE)->(dbGoTop())
						If (cAliasSBE)->(Eof())
							SBE->(RecLock("SBE",.F.))
							SBE->BE_CODPRO := SBF->BF_PRODUTO
							SBE->(MsUnlock())
							
							(cAliasSBE)->(dbCloseArea())
							
							Exit
						Endif
						
						SBF->(dbSkip())
					End
					
				Endif
				
			Endif
			
		Endif
		
	Endif
	
Endif


SD3->(RestArea(aAreaSD3))
SBF->(RestArea(aAreaSBF))
SBE->(RestArea(aAreaSBE))
RestArea(aArea)

Return