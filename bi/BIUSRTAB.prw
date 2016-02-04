User Function BIUSRTAB   
Local cAlias   := PARAMIXB[1] // Alias da Fato ou Dimensão em gravação no momento
Local aRet   := {}

Do Case 
	Case cAlias == "HJC"  //REPRESENTANTE
		aRet := {"SA3","SX5"}
	Case cAlias == "HJ7"  //CLIENTE
		aRet := {"SA1","SX5","ACY"}
	Case cAlias == "HJ8" //ITEM
		aRet := {"SB1","SX5"}
	Case cAlias == "HL2"//FATO COMERCIAL
		aRet := {"SD2","SF4","SX5"}
	Case cAlias == "HL5"//FATO COTAS VENDAS
		aRet := {"SCT"}
EndCase	

Return aRet