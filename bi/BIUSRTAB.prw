User Function BIUSRTAB   
Local cAlias   := PARAMIXB[1] // Alias da Fato ou Dimensão em gravação no momento
Local aRet   := {}

Do Case 	
	Case cAlias == "HJ7"  //CLIENTE
		aRet := {"SA1"}
		ConOut("Passou pelo ponto HJ7")
EndCase	
Do Case 
	Case cAlias == "HJ8"  //PRODUTO
		aRet := {"SB1"}
		ConOut("Passou pelo ponto HJ8")		
EndCase	

Return aRet