#INCLUDE "Protheus.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MA030ROT º Autor ³ Rogerio Machado    º Data ³ 21/07/2016  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Ponto de entrada, adiciona botao ao aRotina de Clientes    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Avant                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function MA030ROT()

	Local aRotina := {}
		
	aAdd(aRotina,{"Exportar_Fornec.",  "U_EXPFOR()" , 0, 4, 0, NIL})
	aAdd(aRotina,{"Exportar_Vendedor", "U_EXPVEND()", 0, 4, 0, NIL})
	
Return(aRotina)


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ EXPFOR   º Autor ³ Rogerio Machado    º Data ³ 21/07/2016  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Exporta cadastro de cliente para fornecedor                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Avant                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function EXPFOR()
	Local aArea     := GetArea()
	Local aAreaSA1  := SA1->(GetArea())
	Local aAreaSA2  := SA2->(GetArea())
	Local aAreaSA3  := SA3->(GetArea())
	Local aValues		:= {}
    Local cCgcCad		:= ""
    Local cCodFor		:= ""
    Local cLojaFor		:= ""
    Local cCodPa		:= ""
	Local lAchou		:= .F.
	Local nOpc			:= 3
	Local _cTipo	    := ""
	Local _cGRPTRIB	    := ""
	Local cEndFor       := ""
	LOCAL aCpos  := {"A2_NOME","A2_NREDUZ"}
	Private aRotAuto 	:= Nil
	Private lMsErroAuto := .F.
	Private A1_CODMARC
	Private A1_OBS
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se ja Existe no Cadastro de Fornecedores	³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	DbSelectarea("SA2")
	SA2->(DbSetorder(3))
	
	If SA2->(DbSeek(xFilial("SA2") + SA1->A1_CGC))
		Aviso("Aviso",	"Fornecedor " + ALLTRIM(SA1->A1_NOME) + " CNPJ/CPF: " + SA1->A1_CGC + CRLF +;
						"Já está cadastrado como fornecedor!" + CRLF +;
						"Código / Loja: " + SA2->A2_COD + " / " + SA2->A2_LOJA + CRLF, {"OK"},3)
		Return
	Else
		cCodFor	 := GetSx8Num("SA2","A2_COD")
		cLojaFor := StrZero(1,TamSx3("A2_LOJA")[1])
	EndIf

	aValues	:= {	{"A2_LOJA"		,cLojaFor  , Nil},;
		{"A2_COD"		,cCodFor			   , Nil},;
		{"A2_NOME"		,UPPER(SA1->A1_NOME)   , Nil},;
		{"A2_NREDUZ"	,UPPER(SA1->A1_NREDUZ) , Nil},;
		{"A2_TIPO"  	,SA1->A1_PESSOA		   , Nil},;
		{"A2_CGC"		,SA1->A1_CGC		   , Nil},;
		{"A2_END"   	,SA1->A1_END           , Nil},;
		{"A2_EST"   	,UPPER(SA1->A1_EST)    , Nil},;
		{"A2_COD_MUN"	,SA1->A1_COD_MUN	   , Nil},;
		{"A2_MUN"   	,UPPER(SA1->A1_MUN)    , Nil},;
		{"A2_INSCR"		,SA1->A1_INSCR	       , Nil},;
		{"A2_CEP"		,SA1->A1_CEP		   , Nil},;
		{"A2_DDD"		,SA1->A1_DDD    	   , Nil},;
		{"A2_TEL"		,SA1->A1_TEL     	   , Nil},;
		{"A2_BAIRRO"	,UPPER(SA1->A1_BAIRRO) , Nil},;
		{"A2_FAX"		,SA1->A1_FAX		   , Nil},;
		{"A2_CONTATO"	,UPPER(SA1->A1_CONTATO), Nil},;
		{"A2_COMPLEM"	,UPPER(SA1->A1_COMPLEM), Nil},;
		{"A2_ENDC"		,UPPER(SA1->A1_ENDCOB) , Nil},;
		{"A2_CEPC"		,SA1->A1_CEPC		   , Nil},;
		{"A2_MUNC"		,UPPER(SA1->A1_MUNC)   , Nil},;
		{"A2_ESTC"		,UPPER(SA1->A1_ESTC)   , Nil},;
		{"A2_EMAIL"		,SA1->A1_EMAIL		   , Nil},;
		{"A2_TIPORUR"	,SA1->A1_PESSOA		   , Nil},;
		{"A2_TPESSOA"	,"OS"           	   , Nil},;
		{"A2_PAIS"		,ALLTRIM("105")		   , Nil}}

	If Aviso("Aviso","Confirma Importação do Cliente para o cadastro de Fornecedores?" + CRLF + CRLF +;
					 "Favor verificar os campos que devem ser preenchidos após a importação.",{"Sim","Não"}) == 2
		Return
	EndIf

	MSExecAuto({|x,y| MATA020(x,y)}, aValues, 3)
	If lMsErroAuto
		RollBackSX8()
		MostraErro()
	Else
		ConfirmSX8()
		If MsgYesNo("Deseja abrir tela de Cadastro?")
			AxAltera("SA2", SA2->(Recno()) ,3)
		EndIf
		MsgInfo("Fornecedor " +cCodFor+ " loja " +cLojaFor+ " importado com sucesso!","TOTVS")
		RecLock("SA1",.F.)
			SA1->A1_XIMPFOR := "S"
		MsUnlock()
	EndIf		
	
RestArea(aArea)
SA1->(RestArea(aAreaSA1))
SA2->(RestArea(aAreaSA2))
SA3->(RestArea(aAreaSA3))    
Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ EXPVEND  º Autor ³ Rogerio Machado    º Data ³ 21/07/2016  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Exporta cadastro de cliente para vendedor                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Avant                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function EXPVEND()
	Local aArea     := GetArea()
	Local aAreaSA1  := SA1->(GetArea())
	Local aAreaSA2  := SA2->(GetArea())
	Local aAreaSA3  := SA3->(GetArea())
	Local aValues		:= {}
    Local cTipoVend		:= "E"
    Local cCgcCad		:= ""
    Local cCodVend		:= ""
    Local cLojaVend		:= ""
    Local cCodPa		:= ""
	Local lAchou		:= .F.
	Local nOpc			:= 3
	Local _cTipo	    := ""
	Local _cGRPTRIB	    := ""
	Local aArea := GetArea()		// Salva a area
	Local aAreaSA1  := SA1->(GetArea())
	Local aAreaSA2  := SA2->(GetArea())
	Local aAreaSA3  := SA3->(GetArea())
	Private aRotAuto 	:= Nil
	Private lMsErroAuto := .F.
	Private A1_CODMARC
	Private A1_OBS

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se ja Existe no Cadastro de Vendedores     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	DbSelectarea("SA3")
	SA3->(DbSetorder(3))
	If SA3->(DbSeek(xFilial("SA3") + SA1->A1_CGC))
		Aviso("Aviso",	"Vendedor " + ALLTRIM(SA1->A1_NOME) + " CNPJ/CPF: " + SA1->A1_CGC + CRLF +;
						"Já está cadastrado como vendedor!" + CRLF +;
						"Código / Loja: " + SA3->A3_COD + " / " + SA3->A3_LOJA + CRLF, {"OK"},3)
		Return
	Else
		cCodVend	 := GetSx8Num("SA3","A3_COD")
		cLojaVend := StrZero(1,TamSx3("A3_LOJA")[1])
	EndIf
	
	aValues	:= {	{"A3_COD"		,cCodVend  , Nil},;
		{"A3_NOME"		,UPPER(SA1->A1_NOME)   , Nil},;
		{"A3_NREDUZ"	,UPPER(SA1->A1_NREDUZ) , Nil},;
		{"A3_TIPO"  	,"E"        		   , Nil},;
		{"A3_CGC"		,SA1->A1_CGC		   , Nil},;
		{"A3_END"   	,SA1->A1_END           , Nil},;
		{"A3_EST"   	,UPPER(SA1->A1_EST)    , Nil},;
		{"A3_MUN"   	,UPPER(SA1->A1_MUN)    , Nil},;
		{"A3_INSCR"		,SA1->A1_INSCR	       , Nil},;
		{"A3_CEP"		,SA1->A1_CEP		   , Nil},;
		{"A3_DDDTEL"	,SA1->A1_DDD    	   , Nil},;
		{"A3_TEL"		,SA1->A1_TEL    	   , Nil},;
		{"A3_BAIRRO"	,UPPER(SA1->A1_BAIRRO) , Nil},;
		{"A3_FAX"		,SA1->A1_FAX		   , Nil},;
		{"A3_X_END"		,UPPER(SA1->A1_ENDCOB) , Nil},;
		{"A3_X_CEP"		,SA1->A1_CEPC		   , Nil},;
		{"A3_X_MUN"		,UPPER(SA1->A1_MUNC)   , Nil},;
		{"A3_X_EST"		,UPPER(SA1->A1_ESTC)   , Nil},;
		{"A3_EMAIL"		,SA1->A1_EMAIL		   , Nil},;
		{"A3_GERASE2"	,"S"                   , Nil},;
		{"A3_DDD"		,"F"                   , Nil},;
		{"A3_DIA"		,10                    , Nil},;
		{"A3_REGIAO"	,UPPER(SA1->A1_REGIAO) , Nil}}

	If Aviso("Aviso","Confirma Importação do Cliente para o cadastro de Vendedores?" + CRLF + CRLF +;
					 "Favor verificar os campos que devem ser preenchidos após a importação.",{"Sim","Não"}) == 2
		Return
	EndIf

	MSExecAuto({|x,y| MATA040(x,y)}, aValues, 3)
	If lMsErroAuto
		RollBackSX8()
		MostraErro()
	Else
		ConfirmSX8()
		If MsgYesNo("Deseja abrir tela de Cadastro?")
			AxAltera("SA3", SA3->(Recno()) ,3)
		EndIf
		MsgInfo("Vendedor " +cCodVend+ " loja " +cLojaVend+ " importado com sucesso!","TOTVS")
		RecLock("SA1",.F.)
			SA1->A1_XIMPVEN	:= "S"
		MsUnlock()
	EndIf

RestArea(aArea)
SA1->(RestArea(aAreaSA1))
SA2->(RestArea(aAreaSA2))
SA3->(RestArea(aAreaSA3))    
Return


