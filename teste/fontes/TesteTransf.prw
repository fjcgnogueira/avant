#INCLUDE "PROTHEUS.CH"
#include "rwmake.ch"
#include "TbiConn.ch"

User Function TesteTransf()

Local cProd	  := "104141352                     "
Local cUM	  := ""
Local cLocal  := ""
Local cDoc	  := ""
Local cLote	  := "18122014  "
Local dDataVl 
Local nQuant  := 100
Local nQtd2   := 0
Local lOk	  := .T.
Local aItem	  := {}
Local nOpcAuto:= 3 // Indica qual tipo de ação será tomada (Inclusão/Exclusão)

PRIVATE lMsHelpAuto := .T.
PRIVATE lMsErroAuto := .F.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//| Abertura do ambiente                                         |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PREPARE ENVIRONMENT EMPRESA "01" FILIAL "010104" MODULO "EST"

dDataVl := dDataBase+1000    

DbSelectArea("SB1")
DbSetOrder(1)

If !SB1->(MsSeek(xFilial("SB1")+cProd))	
	lOk := .F.	
	ConOut(OemToAnsi("Cadastrar produto: " + cProd))
Else		
	cProd 	:= B1_COD 	
	cDescri	:= B1_DESC        
	cUM 	:= B1_UM        
	cLocal	:= B1_LOCPAD
	nQtd2   := nQtd2 / B1_CONV
EndIf                      
	
DbSelectArea("SD5")
DbSetOrder(1)

/*If !SD5->(MsSeek(xFilial("SD5")+ "      " + cProd ))	
	lOk := .F.	
	ConOut(OemToAnsi("Cadastrar lote: " + cLote ))
Else	        
	cLote 	:= D5_LOTECTL        
	dDataVl	:= D5_DTVALID        
	nQuant	:= D5_QUANT
EndIf*/

If lOk		
	cDoc	:= GetSxENum("SD3","D3_DOC",1)		
	ConOut(Repl("-",80))	
	ConOut(PadC("Teste de Transf. Mod2",80))	
	ConOut("Inicio: "+Time())		
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿	
	//| Teste de Inclusao                                            |	
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ   		
	
	Begin Transaction   		
		//Cabecalho a Incluir			
		aAuto := {}		
		
		aadd(aAuto,{cDoc,dDataBase})  //Cabecalho		
		
		//Itens a Incluir				
		aadd(aItem,cProd)  	//D3_COD		
		aadd(aItem,cDescri) //D3_DESCRI				
		aadd(aItem,cUM)  	//D3_UM		
		aadd(aItem,cLocal)  //D3_LOCAL		
		aadd(aItem,"C16101         ")		//D3_LOCALIZ

		aadd(aItem,cProd)  	//D3_COD		
		aadd(aItem,cDescri) //D3_DESCRI				
		aadd(aItem,cUM)  	//D3_UM		
		aadd(aItem,cLocal)    //D3_LOCAL		
		aadd(aItem,"C03001         ")		//D3_LOCALIZ		
		aadd(aItem,"")      //D3_NUMSERI		
		aadd(aItem,cLote)	//D3_LOTECTL  		
		aadd(aItem,"")      //D3_NUMLOTE		
		aadd(aItem,dDataVl)	//D3_DTVALID		
		aadd(aItem,0)		//D3_POTENCI		
		aadd(aItem,nQuant) 	//D3_QUANT		
		aadd(aItem,nQtd2)	//D3_QTSEGUM		
		aadd(aItem,"")   	//D3_ESTORNO		
		aadd(aItem,"")      //D3_NUMSEQ 		
		
		aadd(aItem,cLote)	//D3_LOTECTL		
		aadd(aItem,dDataVl)	//D3_DTVALID
		aadd(aItem,"")		//D3_SERVIC		
		aadd(aItem,"")		//D3_ITEMGRD						
		aadd(aItem,"")		//D3_IDDCF
		aadd(aItem,"")		//D3_OBSERVA
		aadd(aAuto,aItem)								
		
		MSExecAuto({|x,y| mata261(x,y)},aAuto,nOpcAuto)				
		
		If !lMsErroAuto			
			ConOut("Incluido com sucesso! " + cDoc)			
		Else			
			ConOut("Erro na inclusao!")			
			MostraErro()		
		EndIf		
		
		ConOut("Fim  : "+Time())  	
		
	End Transaction
	
EndIf

RESET ENVIRONMENT

Return Nil