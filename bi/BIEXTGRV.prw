#Include "topconn.ch"
User Function BIEXTGRV

Local cAlias   := PARAMIXB[1] // Alias da Fato ou Dimensão em gravação no momento
Local aRet     := PARAMIXB[2] // Array contendo os dados do registro para manipulação
Local lIsDim   := PARAMIXB[3] // Variável que indica quando está gravando em uma Dimensão (.T.) ou Fato (.F.)

Local nPLivre0 := aScan(aRet, {|x| AllTrim(x[1]) == cAlias + "_LIVRE0"})
Local nPLivre1 := aScan(aRet, {|x| AllTrim(x[1]) == cAlias + "_LIVRE1"})
Local nPLivre2 := aScan(aRet, {|x| AllTrim(x[1]) == cAlias + "_LIVRE2"})
Local nPLivre3 := aScan(aRet, {|x| AllTrim(x[1]) == cAlias + "_LIVRE3"})
Local nPLivre4 := aScan(aRet, {|x| AllTrim(x[1]) == cAlias + "_LIVRE4"})
Local nPLivre5 := aScan(aRet, {|x| AllTrim(x[1]) == cAlias + "_LIVRE5"})
Local nPLivre6 := aScan(aRet, {|x| AllTrim(x[1]) == cAlias + "_LIVRE6"})
Local nPLivre7 := aScan(aRet, {|x| AllTrim(x[1]) == cAlias + "_LIVRE7"})
Local nPLivre8 := aScan(aRet, {|x| AllTrim(x[1]) == cAlias + "_LIVRE8"})
Local nPLivre9 := aScan(aRet, {|x| AllTrim(x[1]) == cAlias + "_LIVRE9"})

Local nPCliente := aScan(aRet, {|x| AllTrim(x[1]) == cAlias + "_CODIGO"})
Local nPLojaCli := aScan(aRet, {|x| AllTrim(x[1]) == cAlias + "_LOJA"})


If cAlias == 'HJ7'
	
	//A1_END
	DbSelectArea("SA1")
	DbSetOrder(1)
	If DbSeek(aRet[nPCliente][2] + aRet[nPLojaCli][2])
		If SA1->(FieldPos('A1_END'))> 0
			aRet[nPlivre0][2] := SA1->A1_END 
		EndIf
	EndIf

 /* ElseIf cAlias = 'HJ7'

	DbSelectArea("SA1")
	DbSetOrder(1)
	If DbSeek(aRet[1][2] + aRet[2][2])
		If SA1->(FieldPos('A1_GRPVEN')) > 0 	
			_cSeek := ''
        	DbSelectArea("ACY")
        	DbSetOrder(1)
        	If DbSeek(xFilial("ACY") + SA1->A1_GRPVEN)
				_cSeek := ACY->ACY_DESCRI 
			Else
				_cSeek := 'ND -'+ SA1->A1_GRPVEN
        	EndIf
			aRet[nPlivre0][2] := IIF(!Empty(SA1->A1_GRPVEN),_cSeek,'')
		EndIf 
		
					
		If SA1->(FieldPos('A1_SATIV1')) > 0  
			_cSeek := ''
			DbSelectArea("SX5")        
			DbSetOrder(1)
			If DbSeek(xFilial("SX5") + 'T3' + SA1->A1_SATIV1)
				_cSeek := SX5->X5_DESCRI
			Else
			   _cSeek    := 'ND -' + SA1->A1_SATIV1
			EndIf
			aRet[nPlivre1][2] := IIF(!Empty(SA1->A1_SATIV1),_cSeek,'')
		EndIf
		
		If SA1->(FieldPos('A1_XCANAL')) > 0
			_cSeek := ''
			DbSelectArea("SX5")        
			DbSetOrder(1)
			If DbSeek(xFilial("SX5") + 'T3' + SA1->A1_XCANAL)
				_cSeek := SX5->X5_DESCRI
			Else
				_cSeek    := 'ND -'+ SA1->A1_XCANAL
			EndIf
			aRet[nPlivre2][2] := IIF(!Empty(SA1->A1_XCANAL),_cSeek,'') 
		EndIf                
		
		aRet[nPlivre3][2] := IIf(SA1->(FieldPos('A1_XCLUSTE')) > 0 , SA1->A1_XCLUSTE, '')		
	EndIf
	
ElseIf cAlias == 'HJ8'
	//B1_CLCPDMK, B1_MARCA, B1_CATEG, B1_GRPCLES, B1_SITUAC
	//aRet[nPlivre0][2] := "HJ8"
	DbSelectArea("SB1")
	DbSetOrder(1)
	If DbSeek(aRet[1][2] + aRet[2][2]) //B1_FILIAL + B1_COD
		aRet[nPlivre0][2] := Iif(SB1->(FieldPos('B1_CLCODMK'))> 0 ,SB1->B1_CLCODMK,'')

		If SB1->(FieldPos('B1_MARCA'))  > 0 
			DbSelectArea("SX5")        
			DbSetOrder(1)
			If DbSeek(xFilial("SX5") + 'Z2' + SB1->B1_MARCA) 
				_cSeek := SX5->X5_DESCRI
			Else 
				_cSeek    := 'ND -'+ SB1->B1_MARCA			
			EndIf
			aRet[nPlivre1][2] := IIF(!Empty(SB1->B1_MARCA),_cSeek,'')
		EndIf		                   

		If SB1->(FieldPos('B1_CATEG'))  > 0 
			_cSeek    := ''
			DbSelectArea("SX5")        
			DbSetOrder(1)
			If DbSeek(xFilial("SX5") + 'Z4' + SB1->B1_CATEG)
				_cSeek := SX5->X5_DESCRI
			Else
				_cSeek    := 'ND -'+ SB1->B1_CATEG
			EndIf
			aRet[nPlivre2][2] := IIF(!Empty(SB1->B1_CATEG),_cSeek,'')
		EndIf		       
		
		If SB1->(FieldPos('B1_GRPCLES'))  > 0 
			_cSeek := ''
			DbSelectArea("SX5")        
			DbSetOrder(1)
			If DbSeek(xFilial("SX5") + 'Z3' + SB1->B1_GRPCLES)
				_cSeek := SX5->X5_DESCRI
			Else
				_cSeek    := 'ND -' + SB1->B1_GRPCLES
			EndIf
			aRet[nPlivre3][2] := IIF(!Empty(SB1->B1_GRPCLES),_cSeek,'')
		EndIf		       
		
		//C=Catalogo;N=Novas_Categorias;D=Descontinuado;L=Lancamento		
//		aRet[nPlivre4][2] := Iif(SB1->(FieldPos(SB1->B1_XSITUAC))> 0 ,SB1->B1_XSITUAC,'')
		If SB1->(FieldPos('B1_XSITUAC'))  > 0 
			_cSeek := ''
			Do Case 
				Case SB1->B1_XSITUAC == 'C'
					_cSeek := 'Catalogo'
				Case SB1->B1_XSITUAC == 'N'
					_cSeek := 'Novas Categorias'
				Case SB1->B1_XSITUAC == 'D'
					_cSeek := 'Descontinuado'
				Case SB1->B1_XSITUAC == 'L'
					_cSeek := 'Lancamento'															
            EndCase
			aRet[nPlivre4][2] := _cSeek
		EndIf		       
		
	EndIf
	
ElseIf cAlias == 'HL2' .and. !Empty(aRet)
    //_cSeek := padr(aRet[_cFilSD2][2],2) + padr(aRet[_cNF][2],9) + padr(aRet[_cSer][2],3) + padr(aRet[_cCliente][2],6) + ;
    //			padr(aRet[_cLoja][2],2) + padr(aRet[_cProd][2],15) +padr(aRet[_cIte][2],2)
    _cSeek := cFilAnt + padr(aRet[_cNF][2],9) + padr(aRet[_cSer][2],3) + padr(aRet[_cCliente][2],6) + ;
    			padr(aRet[_cLoja][2],2) + padr(aRet[_cProd][2],15) +padr(aRet[_cIte][2],2)

	DbSelectArea("SD2")
	DbSetOrder(3)
	If DbSeek(_cSeek)
        conout("achou a nota " + SD2->D2_DOC + ' TES ' + SD2->D2_TES )
        
		DbSelectArea("SF4")
		DbSetOrder(1)
		If  DbSeek(xFilial("SF4")+SD2->D2_TES)
			conout("achou a tes TES " + SD2->D2_TES )		
			If SF4->F4_DUPLIC = 'N' .AND. SF4->F4_MOVCLES = 'B' // REGRA PARA INDICAR QUE É UMA BONIFICAÇÃO
				conout("TES de bonificacao " + SD2->D2_TES + " Valor para LIVRE0 " + Str(SD2->(D2_CUSTO1 + D2_DESCZFR + D2_VALIMP5 + D2_VALIMP6 + D2_ICMSRET + D2_VALIPI)))		
				aRet[nPlivre0][2] := SD2->(D2_CUSTO1 + D2_DESCZFR + D2_VALIMP5 + D2_VALIMP6 + D2_ICMSRET + D2_VALIPI+D2_VALICM)  //CUSTO DA BONIFICACAO
				aRet[nPlivre1][2] := SD2->(D2_DESCZFR + D2_VALIMP5 + D2_VALIMP6 + D2_ICMSRET + D2_VALIPI+D2_VALICM)  //VALOR DOS IMPOSTOS
				aRet[31][2] := 0 //HL2_VFATOT
				aRet[40][2] := 0  //HL2_VFATLQ
				aRet[39][2] := 0 //HL2_VFATME
				aRet[46][2] := 0 //[HL2_QFATFC]
			    aRet[47][2] := 0 //[HL2_QFATFM]
			    aRet[43][2] := 0 //[HL2_QFATIT]
			    aRet[56][2] := 0 //[HL2_QPRZDP]
			    aRet[59][2] := 0 //[HL2_QTPESL]
			    aRet[60][2] := 0 //[HL2_QTPESB]
				varinfo("aRet",aRet)				
			EndIf
			If !(alltrim(SF4->F4_MOVCLES) $ 'V/B') .AND. alltrim(aRet[58][2]) == "N" // NOTAS QUE NÃO SEJAM BON/VEN DEVEM SER IGNORADAS, POR ISSO TODOS OS CAMPOS SÃO ZERADOS
				 // aRet[58][2] -> C (   20) [N                   ] [HL2_TPNOTA]
			  aRet[31][2] := 0 //[HL2_VFATOT]
			  aRet[32][2] := 0 //[HL2_VCMFAT]
			  aRet[33][2] := 0 // [HL2_VLCSFT]
			  aRet[34][2] := 0 // [HL2_VICMSF]
			  aRet[35][2] := 0 //[HL2_VIPIFT]
			  aRet[36][2] := 0 //[HL2_VRECFI]
			  aRet[37][2] := 0 // [HL2_VFRTNF]
			  aRet[38][2] := 0 // [HL2_VDESPE]
			  aRet[39][2] := 0 // [HL2_VFATME]
			  aRet[40][2] := 0 // [HL2_VFATLQ]
			  aRet[41][2] := 0 // [HL2_VPISFT]
			  aRet[42][2] := 0 // [HL2_VCOFIN]
			  aRet[43][2] := 0 // [HL2_QFATIT]
			  aRet[44][2] := 0 // [HL2_VISSFT]
			  aRet[46][2] := 0 // [HL2_QFATFC]
			  aRet[47][2] := 0 // [HL2_QFATFM]
			  aRet[50][2] := 0 // [HL2_VICMSS]
			  aRet[51][2] := 0 // [HL2_VLDESF]
			  aRet[52][2] := 0 // [HL2_VLIRFF]
			  aRet[53][2] := 0 // [HL2_VINSSF]
			  aRet[56][2] := 0 // [HL2_QPRZDP]
			  aRet[59][2] := 0 //  [HL2_QTPESL]
			  aRet[60][2] := 0 //  [HL2_QTPESB]
			Endif
		EndIf    
	Else
		varinfo("nao achou a nota ", _cSeek)
	EndIf                       
	
ElseIf cAlias == 'HL5' .and. !Empty(aRet)

//     metas de vendas[16] -> ARRAY (    2) [...]
//          metas de vendas[16][1] -> C (   10) [HL5_QUOTID]
//          metas de vendas[16][2] -> C (   12) [141070   073]
	DbSelectArea("SCT")
	DbSetOrder(1)
	If DbSeek(xFilial("SCT") + aRet[16][2])
		conout("Achou a meta " + SCT->CT_DOC + SCT->CT_SEQUEN)
		aRet[nPlivre0][2] := SCT->CT_XIMPOST
		aRet[nPlivre1][2] := SCT->CT_XDEVVLR
		aRet[nPlivre2][2] := SCT->CT_XBONVLR
		aRet[nPlivre3][2] := SCT->CT_XCUSUNI	
	Else
		conout("Nao achou a meta " +xFilial("SCT") + aRet[16][2]  )
    EndIf
*/
EndIf


Return aRet
