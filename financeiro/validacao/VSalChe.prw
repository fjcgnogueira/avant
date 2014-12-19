#INCLUDE "Protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³VSalChe   ºAutor  ³Rodrigo Leite       º Data ³  11/10/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Verifica o valor de baixas do Cheque se o mesmo ja existe  º±±
±±º          ³ e retorna o Saldo do cheque                                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/                                                                           


User Function VSalChe()

Local nTotal     := 0
Local nSaldo     := 0
Local nValChe    := 0
Local cNumChe    := M->EF_NUM // NUMERO CHEQUE
Local cNumBco    := M->EF_BANCO // BANCO CHEQUE
Local cNumAgen   := M->EF_AGENCIA // AGENCIA CHEQUE 
Local cNumCont   := M->EF_CONTA // CONTA CHEQUE
Local cValBX     := M->EF_VALORBX
Local _cQuery    := ""
Local lReturn    := .T.
Local aCheques   := {}   
Local cTitulos   := ""
Local nValatu    := 0


	_cQuery	:=	" SELECT  EF_NUM , EF_BANCO , EF_AGENCIA , EF_CONTA , EF_VALOR , EF_VALORBX , EF_TITULO , EF_PARCELA  FROM "+RetSqlName("SEF")+" SEF "+ chr(13)+chr(10)
	_cQuery	+=	" WHERE EF_NUM   = '"+cNumChe+"'"+ chr(13)+chr(10)
	_cQuery	+=	" AND EF_BANCO   = '"+cNumBco+"'"+ chr(13)+chr(10)
	_cQuery	+=	" AND EF_AGENCIA = '"+cNumAgen+"'"+ chr(13)+chr(10)
    _cQuery	+=	" AND EF_CONTA   = '"+cNumCont+"'"+ chr(13)+chr(10)   
	_cQuery	+=	" AND D_E_L_E_T_ = ''"+ chr(13)+chr(10)
	
	_cQuery := ChangeQuery(_cQuery)
	
	If Select("TRB") > 0
		TRB->(DbCloseArea())
	EndIf
	 
	DbUseArea(.T., "TOPCONN", TcGenQry(NIL, NIL, _cQuery), "TRB", .T., .T.)

	DbSelectArea("TRB")
	TRB->(DbGoTop())
	
If  !Empty (TRB->EF_NUM)

	  nValChe := TRB->EF_VALOR
	
	While !TRB->(Eof())
					
		 nSaldo    += TRB->EF_VALORBX

		 AADD(aCheques, {TRB->EF_TITULO , TRB->EF_PARCELA} )
		 		 		
		TRB->(DbSkip())
		
	End
	    
    If Select("TRB") > 0
			TRB->(DbCloseArea())
	EndIf
	    
   	If !Empty(aCheques)
		
		For  _y:= 1 to len(aCheques)
			
			cTitulos := cTitulos + ALLTRIM(aCheques[_y][1])+ " /" + ALLTRIM(aCheques[_y][2])+ "-" 
			
		Next
         
    	nTotal    := (nValChe - nSaldo)                    
	
		

		Aviso("Atenção", "Este cheque ja foi cadastrado para os titulos "+cTitulos+" e o saldo atual para este cheque é R$" + Transform (nTotal,"@E 999999999.99"), {"Ok"})
    EndIf 

   

	
	nValatu := nTotal - cValBX 

	If nValatu < 0
    
    		 Alert("Não existe saldo suficiente para ser distribuido para este cheque")
  			lReturn := .F.

	EndIf
Endif

Return(lReturn)  
