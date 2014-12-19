#Include "RwMake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFINAVA01  บAutor  ณAlan S. R. Oliveira บ Data ณ  02/01/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณBaixa automแtica de Tํtulos importados do Tecnix, atrav้s deบฑฑ
ฑฑบ          ณCNABดs.                                                     บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Protheus 11                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
USER FUNCTION FINAVA01()


Local nOpc      := 0
Local cCadastro := "Baixa de Tํtulos เ Receber."
Local aSay      := {}
Local aButton   := {}

Private _DIRTXT   := Space(50) 
Private _cBanco   := Space(03)
Private _cAge     := Space(05)
Private _cCon     := Space(10)

SetPrvt("CPERG,NOPC,CCADASTRO,aregs")

@ 0,0 TO 200,440 DIALOG oDlg TITLE "Lps Distribuidora Ltda"
@ 15,10 SAY 'Nome do Arquivo Texto' SIZE 80,100
@ 15,100 GET _DIRTXT pict "@x" SIZE 80,100

@ 30,10 SAY 'Banco' SIZE 80,100
@ 30,100 GET _cBanco F3 "SA6" SIZE 80,100

@ 45,10 SAY 'Agencia' SIZE 80,100
@ 45,100 GET _cAge SIZE 80,100

@ 60,10 SAY 'Conta' SIZE 80,100
@ 60,100 GET _cCon SIZE 80,100


@ 080,140 BMPBUTTON TYPE 1 ACTION Close(oDlg)

ACTIVATE MSDIALOG oDlg CENTERED

aAdd( aSay, "Esta Rotina Irแ Ler o Arq. "+ALLTRIM(_DIRTXT)+" e efetuar as baixas do Tํtulos na SE1" )

aAdd( aButton, { 1,.T.,{|| nOpc := 1,FechaBatch()}})
aAdd( aButton, { 2,.T.,{|| FechaBatch() }} )

FormBatch( cCadastro, aSay, aButton )

If nOpc == 1
	Processa( {|| Import() }, "Processando..." )
Endif


Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณIMPORT    บAutor  ณAlan S. R. Oliveira บ Data ณ  02/01/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Protheus 11                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
STATIC FUNCTION Import()

Local aBaixa    := {}
Local _cChave   := ""
Local _nCount   := 0
Local _lBanco   := .F. //Indica se o arquivo ้ do banco
Local nBtLidos  := 0
Local cBuffer   := ""
Local _cHist    := "FINAVA01-Bx. Personalizada"
Local cMenErro	:= ""
Local cMenExec	:= ""

Private lMsHelpAuto	:= .T.
Private lMsErroAuto	:= .F.

If !File(alltrim(_DIRTXT))
	MsgAlert("Arquivo texto nใo localizado",cCadastro)
	Return
Endif

aAlias := {"SE1"}

FT_FUSE(ALLTRIM(_DIRTXT))
FT_FGOTOP()
ProcRegua(FT_FLASTREC())
_Passou := .T.
    
//CRIA ARQUIVO DE TRABALHO PARA LOG
If !FT_FEOF()
	CRIATRBX()
Endif

While !FT_FEOF()
	
	// Capturar dados
	cBuffer		:= FT_FREADLN()
	nBtLidos	:= nBtLidos + 1
	
	
	If _cBanco == "001"

		If subs(cBuffer,1,3) == "001" .and. _lBanco == .F.
		
			If Subs(Alltrim(_cAge),1,5) <> Subs(cbuffer,54,5) .and. _lBanco == .F.
				msginfo("Agencia Informado nใo ้ a mesma do Arquivo, verifique os parโmetros..!")
				FT_FUSE()
				dbSelectArea("TRBAUX")
				dbCloseArea()
				Return
			Else
				If Subs(Alltrim(_cCon),1,6) <> Subs(cbuffer,66,6) .and. _lBanco == .F.
					aDados := {}
					msginfo("Conta Informado nใo ้ a mesma do Arquivo, verifique os parโmetros..!")
					FT_FUSE()
					dbSelectArea("TRBAUX")
					dbCloseArea()
					Return
				Endif        
			Endif
		
			_lBanco := .T.
			aDados := {}
			FT_FSKIP()   
			cBuffer  := FT_FREADLN()       
      
      ElseIf subs(cBuffer,1,3) <> "001" .and. _lBanco == .F.
			aDados := {}
			msginfo("Banco Informado nใo ้ a mesmo do Arquivo, verifique os parโmetros..!")
			FT_FUSE()
			dbSelectArea("TRBAUX")
			dbCloseArea()
			Return
		endif
		
		_lBanco := .T.
		
		If subs(cbuffer,14,1) <> "T"
			aDados := {}
			FT_FSKIP()
			Loop
		endif
		
		IF !subs(cbuffer,16,2) $ "06/09"
			aDados := {}
			FT_FSKIP()
			Loop
		endif
		
		IncProc()
		
		aBaixa := {}
		
		_cChave     := subs(cbuffer,59,10)        
			
		//BUCA INFORMAวีES DA BAIXA DO TITULO NO ARQUIVO
		FT_FSKIP()
		cBuffer  := FT_FREADLN()
		_nVlJur	 := Val(Alltrim(Str(Val(Subs(cbuffer,18,13)))) + "." + Alltrim(Subs(cbuffer,31,2)))// / 100
		_nVlbaix := Val(Alltrim(Str(Val(Subs(cbuffer,78,13)))) + "." + Alltrim(Subs(cbuffer,91,2)))// / 100
		_dDtbaixa:= stod(Subs(cbuffer,142,4) + Subs(cbuffer,140,2) + Subs(cbuffer,138,2) )
		_dDtCred := stod(Subs(cbuffer,150,4) + Subs(cbuffer,148,2) + Subs(cbuffer,146,2) )
		
	ElseIF _cBanco == "237"
		
		//VERIFICA SE O ARQUIVO ษ DO BANCO 237
		If subs(cBuffer,77,3) == "237" .AND. _lBanco == .F.
			_lBanco := .T.
			aDados := {}
			FT_FSKIP()   
			cBuffer  := FT_FREADLN()       
		Elseif subs(cBuffer,77,3) <> "237" .AND. _lBanco == .F.
			aDados := {}
			msginfo("Banco Informado nใo ้ a mesmo do Arquivo, verifique os parโmetros..!")   
			FT_FUSE()
			dbSelectArea("TRBAUX")
			dbCloseArea()
			Return
		Endif
		
		If Subs(Alltrim(_cAge),1,4) <> Subs(cbuffer,26,4)
			aDados := {}
			IF Subs(cbuffer,18,4) <> "0000"
				msginfo("Agencia Informado nใo ้ a mesma do Arquivo, verifique os parโmetros..!")
				FT_FUSE()
				dbSelectArea("TRBAUX")
				dbCloseArea()				
				Return
			Else
				FT_FSKIP()
				cBuffer := FT_FREADLN()     
				Loop
			Endif
		Endif
		
		If Subs(Alltrim(_cCon),1,5) <> Subs(cbuffer,32,5)
			aDados := {}
			msginfo("Conta Informado nใo ้ a mesma do Arquivo, verifique os parโmetros..!")      
			FT_FUSE()        
			dbSelectArea("TRBAUX")
			dbCloseArea()			
			Return
		Endif
		
		//Sำ BAIXA SE O ARQUIVO FOR DO BANCO 237 E OCORRENCIA 06
		If subs(cBuffer,109,2) <> "06" 
			Exit
			aDados := {}
			FT_FSKIP()
		Endif
		
		IncProc()
		
		aBaixa := {}
		
	  //	_cChave  	:= subs(cbuffer,38,10)   
		_cChave  	:= subs(cbuffer,38,12)
		_nVlJur	 	:= Val(Alltrim(Str(Val(Subs(cbuffer,267,10)))) + "." + Alltrim(Str(Val(Subs(cbuffer,278,2))))) ///100
		_nVlbaix 	:= Val(Alltrim(Str(Val(Subs(cbuffer,255,10)))) + "." + Alltrim(Str(Val(Subs(cbuffer,265,2))))) ///100
		_dDtbaixa	:= StoD("20"+Subs(cbuffer,115,2) + Subs(cbuffer,113,2) + Subs(cbuffer,111,2) )
		_dDtCred	:= _dDtbaixa  //"  /  /    "//stod("20"+Subs(cbuffer,300,2) + Subs(cbuffer,298,2) + Subs(cbuffer,296,2) )
		
	ElseIF _cBanco == "422"
		
		//VERIFICA SE O ARQUIVO ษ DO BANCO 422
		If subs(cBuffer,77,3) == "422" .AND. _lBanco == .F.
			_lBanco := .T.
			aDados := {}
			FT_FSKIP()   
			cBuffer  := FT_FREADLN()       
		Elseif subs(cBuffer,77,3) <> "422" .AND. _lBanco == .F.
			aDados := {}
			msginfo("Banco Informado nใo ้ a mesmo do Arquivo, verifique os parโmetros..!")   
			FT_FUSE()
			dbSelectArea("TRBAUX")
			dbCloseArea()
			Return
		Endif
		
		If Subs(Alltrim(_cAge),1,4) <> Subs(cbuffer,18,4)
			aDados := {}
			IF Subs(cbuffer,18,4) <> "0000"
				msginfo("Agencia Informado nใo ้ a mesma do Arquivo, verifique os parโmetros..!")
				FT_FUSE()
				dbSelectArea("TRBAUX")
				dbCloseArea()				
				Return
			Else
				FT_FSKIP()
				cBuffer := FT_FREADLN()     
				Loop
			Endif
		Endif
		
		If Subs(Alltrim(_cCon),1,9) <> Subs(cbuffer,23,9)
			aDados := {}
			msginfo("Conta Informado nใo ้ a mesma do Arquivo, verifique os parโmetros..!")      
			FT_FUSE()        
			dbSelectArea("TRBAUX")
			dbCloseArea()			
			Return
		Endif
		
		//Sำ BAIXA SE O ARQUIVO FOR DO BANCO 237 E OCORRENCIA 06
		If subs(cBuffer,109,2) <> "06" 
			aDados := {}
			FT_FSKIP()
		Endif
		
		IncProc()
		
		aBaixa := {}
		
		//_cChave  	:= subs(cbuffer,38,10)
		_cChave  	:= subs(cbuffer,38,12)
		_nVlJur	 	:= Val(Alltrim(Str(Val(Subs(cbuffer,267,10)))) + "." + Alltrim(Str(Val(Subs(cbuffer,278,2))))) ///100
		_nVlbaix 	:= Val(Alltrim(Str(Val(Subs(cbuffer,255,10)))) + "." + Alltrim(Str(Val(Subs(cbuffer,265,2))))) ///100
		_dDtbaixa	:= StoD("20"+Subs(cbuffer,151,2) + Subs(cbuffer,149,2) + Subs(cbuffer,147,2) )
		_dDtCred		:= Stod("20"+Subs(cbuffer,300,2) + Subs(cbuffer,298,2) + Subs(cbuffer,296,2) )


	Elseif _cBanco == "341"
		
		//VERIFICA SE O ARQUIVO ษ DO BANCO 341
		If subs(cBuffer,77,3) == "341"  .AND. _lBanco == .F.
			_lBanco := .T.
			_cBanco	:= subs(cBuffer,77,3)
			aDados  := {}
			FT_FSKIP()
			cBuffer := FT_FREADLN()
		ElseIF subs(cBuffer,77,3) <> "341"  .AND. _lBanco == .F.
			aDados := {}
			msginfo("Banco Informado nใo ้ a mesmo do Arquivo, verifique os parโmetros..!")
			FT_FUSE()    
			dbSelectArea("TRBAUX")
			dbCloseArea()			
			Return
		Endif
		
		If Alltrim(_cAge) <> Subs(cbuffer,18,4)  .AND. _lBanco == .T.
			aDados := {}   
			IF Subs(cbuffer,18,4) <> "0000"
				msginfo("Agencia Informado nใo ้ a mesma do Arquivo, verifique os parโmetros..!")
				FT_FUSE()
				dbSelectArea("TRBAUX")
				dbCloseArea()				
				Return
			Else
				FT_FSKIP()
				cBuffer := FT_FREADLN()     
				Loop
			Endif
		Endif
		
		If Alltrim(_cCon) <> Subs(cbuffer,24,6) 
			aDados := {}
			msginfo("Conta Informado nใo ้ a mesma do Arquivo, verifique os parโmetros..!")
			FT_FUSE()        
			dbSelectArea("TRBAUX")
			dbCloseArea()			
			Return
		Endif
		
		//Sำ BAIXA SE O ARQUIVO FOR DO BANCO 341 E OCORRENCIAS "06, 08"
		If !SubStr(cBuffer,109,2) $ "06/08" 
			aDados := {}
			FT_FSKIP()   
			Loop
		Endif
		
		IncProc()
		
		aBaixa   := {}
		
	  //	_cChave  	:= subs(cbuffer,38,10) 
	  	_cChave  	:= subs(cbuffer,38,12)
		_nVlJur	 	:= Val(Alltrim(Str(Val(Subs(cbuffer,267,11)))) + "." + Alltrim(Str(Val(Subs(cbuffer,278,2))))) // / 100
		_nVlbaix 	:= Val(Alltrim(Str(Val(Subs(cbuffer,254,11)))) + "." + Alltrim(Str(Val(Subs(cbuffer,265,2))))) // / 100
		_dDtbaixa	:= StoD("20"+Subs(cbuffer,115,2) + Subs(cbuffer,113,2) + Subs(cbuffer,111,2) )
		_dDtCred	:= StoD("20"+Subs(cbuffer,300,2) + Subs(cbuffer,298,2) + Subs(cbuffer,296,2) )
	
	Elseif _cBanco == "655"
		
		//VERIFICA SE O ARQUIVO ษ DO BANCO 655
		If subs(cBuffer,77,3) == "001"  .AND. _lBanco == .F.
			_lBanco := .T.
			_cBanco	:= "655"
			aDados  := {}
			FT_FSKIP()
			cBuffer := FT_FREADLN()
		ElseIF subs(cBuffer,77,3) <> "001"  .AND. _lBanco == .F.
			aDados := {}
			msginfo("Banco Informado nใo ้ a mesmo do Arquivo, verifique os parโmetros..!")
			FT_FUSE()    
			dbSelectArea("TRBAUX")
			dbCloseArea()			
			Return
		Endif
		
		If Alltrim(_cAge) <> Subs(cbuffer,18,4)  .AND. _lBanco == .T.
			aDados := {}   
			IF Subs(cbuffer,18,4) <> "0000"
				msginfo("Agencia Informado nใo ้ a mesma do Arquivo, verifique os parโmetros..!")
				FT_FUSE()
				dbSelectArea("TRBAUX")
				dbCloseArea()				
				Return
			Else
				FT_FSKIP()
				cBuffer := FT_FREADLN()     
				Loop
			Endif
		Endif
		
		If Alltrim(_cCon) <> Subs(cbuffer,27,5) 
			aDados := {}
			msginfo("Conta Informado nใo ้ a mesma do Arquivo, verifique os parโmetros..!")
			FT_FUSE()        
			dbSelectArea("TRBAUX")
			dbCloseArea()			
			Return
		Endif
		
		//Sำ BAIXA SE O ARQUIVO FOR DO BANCO 341 E OCORRENCIAS "06, 08"
		If !SubStr(cBuffer,109,2) $ "06/08" 
			aDados := {}
			FT_FSKIP()   
			Loop
		Endif
		
		IncProc()
		
		aBaixa   := {}
		
	  //	_cChave  	:= subs(cbuffer,39,10) 
		_cChave  	:= subs(cbuffer,38,12)
		_nVlJur	 	:= Val(Alltrim(Str(Val(Subs(cbuffer,267,11)))) + "." + Alltrim(Str(Val(Subs(cbuffer,278,2))))) // / 100
		_nVlbaix 	:= Val(Alltrim(Str(Val(Subs(cbuffer,254,11)))) + "." + Alltrim(Str(Val(Subs(cbuffer,265,2))))) // / 100
		_dDtbaixa	:= StoD("20"+Subs(cbuffer,115,2) + Subs(cbuffer,113,2) + Subs(cbuffer,111,2) )
		_dDtCred		:= Iif(subs(cbuffer,176,6)<>"000000",StoD("20"+Subs(cbuffer,180,2) + Subs(cbuffer,178,2) + Subs(cbuffer,176,2) ),StoD("20"+Subs(cbuffer,115,2) + Subs(cbuffer,113,2) + Subs(cbuffer,111,2) ))


	Endif
	
	
	If _lBanco == .T.
		//Busca Informa็๕es dos Tํtulos a Receber de Acordo com a
		//Chave de Identifica็ใo
		DbSelectArea("SE1")
		dbOrderNickName("ID_AVANT")
		DbGotop()
		If(DbSeek(xFilial("SE1") + _cChave))
			If /*SE1->E1_SALDO >= _nVlbaix .AND.*/ SE1->E1_SALDO > 0    
			
				If SE1->E1_SALDO > _nVlbaix .And. _nVlJur == 0
					_nVlJur := _nVlbaix - SE1->E1_SALDO
				EndIf
				
				//If _nVlJur == 0         
				//	_nVlJur := _nVlbaix - SE1->E1_SALDO
				//Endif
			
				aBaixa := {	{"E1_PREFIXO"   ,SE1->E1_PREFIXO 	,Nil},;
							{"E1_NUM"       ,SE1->E1_NUM 		,Nil},;
							{"E1_PARCELA"   ,SE1->E1_PARCELA	,Nil},;
							{"E1_TIPO"      ,SE1->E1_TIPO 		,Nil},;
							{"E1_CLIENTE"   ,SE1->E1_CLIENTE 	,Nil},;
							{"E1_LOJA"      ,SE1->E1_LOJA  		,Nil},;
							{"E1_FILIAL"    ,SE1->E1_FILIAL 	,Nil},;  
							{"AUTBANCO" 	, _cBanco			,Nil},;
							{"AUTAGENCIA"   , _cAge				,Nil},;
							{"AUTCONTA"     , _cCon				,Nil},;			
							{"AUTMOTBX"     , "NOR"      		,Nil},;
							{"AUTDTBAIXA"   , _dDtbaixa  		,Nil},;
							{"AUTDTCREDITO" , _dDtCred	    	,Nil},;
							{"AUTHIST"      , _cHist	  		,Nil},;
							{"AUTJUROS"	    , _nVlJur			,Nil},;
							{"AUTVALREC"    , _nVlbaix  		,Nil}}
							
				lMsErroAuto := .F.
				lMsHelpAuto := .T.
				
				MSExecAuto({|x,y| Fina070(x,y)},aBaixa,3)
				_lerro := lMsErroAuto

				If lMsErroAuto
					lMsErroAuto := .F.
					cMenExec += MostraErro( "\LOGS\", "FINA070.LOG" )
					cMenExec += CHR(13) + CHR(10) + "Titulo: " + SE1->E1_NUM + " Parcela: " + SE1->E1_PARCELA
				EndIf

				//Alimenta Arquivo de LOG   
				If _lerro == .F.
					DbSelectArea("TRBAUX")
					RecLock("TRBAUX", .T.)
						TRBAUX->PREF	:= SE1->E1_PREFIXO
						TRBAUX->TITU	:= SE1->E1_NUM
						TRBAUX->PARC	:= SE1->E1_PARCELA
						TRBAUX->CLIENTE	:= SE1->E1_CLIENTE +"-"+SE1->E1_LOJA +" "+Alltrim(Posicione("SA1",1,xFilial("SA1")+SE1->E1_CLIENTE +SE1->E1_LOJA, "A1_NOME"))
						TRBAUX->DTOCO	:= _dDtbaixa
						TRBAUX->DTCRED	:= _dDtCred
						TRBAUX->VLJUR	:= _nVlJur
						TRBAUX->VLREC	:=_nVlbaix           
						TRBAUX->POSI    := "BAIXA NORMAL"
					MsUnlock()

					_nCount++
				Endif
			    
			Endif
		Else
			DbSelectArea("TRBAUX")
			RecLock("TRBAUX", .T.)
				TRBAUX->PREF	:= ""
				TRBAUX->TITU	:= _cChave
				TRBAUX->PARC	:= ""
				TRBAUX->CLIENTE	:= "TITULO NAO BAIXADO"
				TRBAUX->DTOCO	:= _dDtbaixa
				TRBAUX->DTCRED	:= _dDtCred
				TRBAUX->VLJUR	:= _nVlJur
				TRBAUX->VLREC	:=_nVlbaix           
				TRBAUX->POSI    := "TITULO NAO BAIXADO"
			MsUnlock()		
			cMenErro += _cChave + CHR(13) + CHR(10) 
		Endif
	Endif
	
	FT_FSKIP()
	cBuffer := FT_FREADLN()
	
	IF FT_FEOF()
		EXIT
	ENDIF
	
Enddo

FT_FUSE()   
		  
If !Empty(cMenExec)
	Aviso("Aviso","Erros na Baixa:" + CHR(13) + CHR(10) + cMenExec,{"Ok"},3)
EndIf

If !Empty(cMenErro)
	Aviso("Aviso","Tํtulos nใo encontrados" + CHR(13) + CHR(10) + "Chave:" + CHR(13) + CHR(10) + cMenErro, {"Ok"},3)
EndIf

//GERA ARQUIVO DE LOG
If _nCount > 0
	GERALOGE() 
Else
	msginfo("NAO EXISTEM TITULOS A BAIXAR NESTE ARQUIVO..!")
	dbSelectArea("TRBAUX")
	dbCloseArea()
Endif	
//

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCRIATRBX  บAutor  ณAlan S. R. Oliveira บ Data ณ  05/01/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณCria็ใo de arquivo de LOG de processamento do CNAB, apenas  บฑฑ
ฑฑบ          ณpara os tํtulos baixados.                                   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico                                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function CRIATRBX()

Private _aCampos   := {}

//ARQUIVO TEMPORARIO ITENS            
Aadd(_aCampos,{"PREF"    	,"C", 003, 0})	//PREFIXO DO TITULO
Aadd(_aCampos,{"TITU" 	 	,"C", 009, 0}) 	//NUMERO DO TITULO
Aadd(_aCampos,{"PARC"	 	,"C", 002, 0}) 	//PARCELA
Aadd(_aCampos,{"CLIENTE" 	,"C", 049, 0})	//CLIENTE
Aadd(_aCampos,{"DTOCO"	 	,"D", 008, 0}) 	//DATA OCORRENCIA
Aadd(_aCampos,{"DTCRED"	 	,"D", 008, 0}) 	//DATA DO CREDITO
Aadd(_aCampos,{"VLJUR"	 	,"N", 012, 2}) 	//VALOR DO JUROS
Aadd(_aCampos,{"VLREC"	 	,"N", 012, 2}) 	//VALOR RECEBIDO
Aadd(_aCampos,{"POSI"	 	,"C", 030, 2}) 	//POSICAO DA BAIXA (BAIXA NORMAL OU TITULO NAO BAIXADO)

cArqTRB := CriaTrab(_aCampos,.T.)
dbUseArea( .T.,, cArqTRB, "TRBAUX", .F., .F. )

_cChave := "PREF" // 1o Indice para alimentar o TRB
IndRegua("TRBAUX",cArqTRB,_cChave,,," Criando Consulta ... ") // Cria o INDICE.
                                        
Return
        
                                        
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGeraExcel บAutor  ณStanko              บ Data ณ  23/10/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณGeracao de Excel -                    		              บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP8 - Especifico - MPereira - Alianca                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function GERALOGE()  

Local cArq 		:= CriaTrab(NIL,.F.)
//Local cPath 	:= AllTrim(GetTempPath())
Local cPath 	:= "C:\Microsiga\"
Local cDirDocs 	:= MsDocPath() 
Local nHandle 	:= 0
Local oExcelApp
Local cLin

Private cEOL    := "CHR(13)+CHR(10)"
If Empty(cEOL)
    cEOL := CHR(13)+CHR(10)
Else
    cEOL := Trim(cEOL)
    cEOL := &cEOL
Endif

nHandle := MsfCreate(cDirDocs+"\"+cArq+".CSV",0)
If nHandle <= 0
	MsgInfo("Nใo foi possํvel criar o arquivo temporแrio")
    dbSelectArea("TRBAUX")
	dbCloseArea()
	Return
Endif

cLin := "PREFIXO;TITULO;PARCELA;CLIENTE;DATA OCORRENCIA;DATA BAIXA;VALOR JUROS;VALOR RECEBIDO;POSICAO"+ cEOL 

If fWrite(nHandle,cLin,Len(cLin)) != Len(cLin)
	If !MsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
		fClose(nHandle)
		dbSelectArea("TRBAUX")
		dbCloseArea()
		Return
	Endif
Endif 
		
dbSelectArea("TRBAUX")
dbGoTop()
WHILE TRBAUX->(!EOF())
	
		cLin := TRBAUX->PREF	
		cLin += ";" + TRBAUX->TITU
		cLin += ";" + TRBAUX->PARC
		cLin += ";" + TRBAUX->CLIENTE
		cLin += ";" + DTOC(TRBAUX->DTOCO)
		cLin += ";" + DTOC(TRBAUX->DTCRED)
		cLin += ";" + TRANSFORM(TRBAUX->VLJUR	, "@E 999,999,999.99")
		cLin += ";" + TRANSFORM(TRBAUX->VLREC	, "@E 999,999,999.99")
		cLin += ";" + TRBAUX->POSI
	    cLin += cEOL                                                   
	                      
	    If fWrite(nHandle,cLin,Len(cLin)) != Len(cLin)
	        If !MsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
	        dbSelectArea("TRBAUX")
			dbCloseArea()
	            Exit                                          	            
	        Endif
	    Endif  
		    
	    IncProc()

		dbSelectArea("TRBAUX")
	    TRBAUX->(dbSkip())
ENDDO

FClose(nHandle)
CpyS2T( cDirDocs+"\"+cArq+".CSV" , cPath, .T. )

dbSelectArea("TRBAUX")
dbCloseArea()	

If !ApOleClient('MsExcel')
	MsgAlert('O arquivo foi gerado com sucesso, por้m o MSEXCEL nใo estแ instalado.')
	Return
Endif
	
oExcelApp := MsExcel():New()
oExcelApp:WorkBooks:Open(cPath+cArq+".CSV")
oExcelApp:SetVisible(.T.)

Return