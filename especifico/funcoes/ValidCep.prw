#Include "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ ValidCEP บ Autor ณ Fernando Nogueira  บ Data ณ 14/10/2015  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao para validar o CEP.                                 บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico AVANT.                   	                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function ValidCEP(_cCep,_cEstado)

Local aCeps := {}

// Range de Ceps por Estado
aAdd(aCeps,{"AC","69900","69999"})
aAdd(aCeps,{"AL","57000","57999"})
aAdd(aCeps,{"AP","68900","68999"})
aAdd(aCeps,{"AM","69000","69899"})
aAdd(aCeps,{"BA","40000","48999"})
aAdd(aCeps,{"CE","60000","63999"})
aAdd(aCeps,{"DF","70000","73699"})
aAdd(aCeps,{"ES","29000","29999"})
aAdd(aCeps,{"GO","72800","76799"})
aAdd(aCeps,{"MA","65000","65999"})
aAdd(aCeps,{"MT","78000","78899"})
aAdd(aCeps,{"MS","79000","79999"})
aAdd(aCeps,{"MG","30000","39999"})
aAdd(aCeps,{"PA","66000","68899"})
aAdd(aCeps,{"PB","58000","58999"})
aAdd(aCeps,{"PR","80000","87999"})
aAdd(aCeps,{"PE","50000","56999"})
aAdd(aCeps,{"PI","64000","64999"})
aAdd(aCeps,{"RJ","20000","28999"})
aAdd(aCeps,{"RN","59000","59999"})
aAdd(aCeps,{"RS","90000","99999"})
aAdd(aCeps,{"RO","76800","78999"})
aAdd(aCeps,{"RR","69300","69399"})
aAdd(aCeps,{"SC","88000","89999"})
aAdd(aCeps,{"SP","01000","19999"})
aAdd(aCeps,{"SE","49000","49999"})
aAdd(aCeps,{"TO","77000","77999"})

If Empty(_cCep)
	Return .T.
ElseIf Len(AllTrim(_cCep)) <> 8
	ApMsgInfo("Cep Invแlido")
	Return .F.
ElseIf Empty(_cEstado)
	ApMsgInfo("Primeiro preencher o Estado")
	Return .F.
Else
	For _nI := 1 to Len(aCeps)
		If aCeps[_nI][1] == _cEstado
			If Left(_cCep,5) >= aCeps[_nI][2] .And. Left(_cCep,5) <= aCeps[_nI][3] 
				Return .T.
			Else
				ApMsgInfo("Cep nใo pertence ao Estado")
				Return .F.
			Endif
		Endif
	Next
Endif

Return .T.