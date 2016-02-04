User Function BIUSRTAB   
Local cAlias   := PARAMIXB[1] // Alias da Fato ou Dimensão em gravação no momento
Local aRet   := {}

Do Case 
	Case cAlias == "HJ7"  //CLIENTE
		aRet := {"SA1"}
EndCase	

Return aRet