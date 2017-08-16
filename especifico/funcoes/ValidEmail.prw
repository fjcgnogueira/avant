#Include "PROTHEUS.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ ValidEmail º Autor ³ Fernando Nogueira  º Data ³ 14/10/2015 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao para validar campos com e-mail                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico AVANT.                   	                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function ValidEmail()

Local cCampo    := AllTrim(ReadVar())
Local cEmail    := AllTrim(&(ReadVar()))
Local cTexto    := ""
Local cCaracter := ""
Local aEmail    := {}

If cCampo = 'M->A1_EMAIL' .And. cEmail = 'ISENTO'
	Return .T.
ElseIf cCampo = 'M->A1_EMAIL' .And. Empty(cEmail)
	Aviso('E-mail',"Necessario informar e-mail ou 'ISENTO'",{'Ok'})
	Return .F.
ElseIf Empty(cEmail)
	Return .T.
Endif
	
For _nI := 1 To Len(cEmail)
	If Substr(cEmail,_nI,1) $ "/; "+Chr(09)
		Aviso('E-mail',"Não é permitido barra (/), ponto e vírgula (;),espaços em branco e tabulação no e-mail",{'Ok'})
		Return .F.
	EndIf
Next _nI

If "," $ cEmail
	If Left(cEmail,01) = "," .Or. Right(cEmail,01) = "," 
		Aviso('E-mail',"Não use vírgula no início ou no fim, use para separar os e-mails",{'Ok'})
		Return .F.
	Endif
	While "," $ cEmail
		aAdd(aEmail,Left(cEmail,At(",",cEmail)-1))
		cEmail := Substring(cEmail,At(",",cEmail)+1,Len(cEmail)-At(",",cEmail))
	End
	aAdd(aEmail,cEmail)
Else
	aAdd(aEmail,cEmail)
Endif

For _nJ := 1 To Len(aEmail)
	If !IsEmail(aEmail[_nJ])
		Aviso('E-mail',"Necessario informar e-mail válido",{'Ok'})
		Return .F.
	Endif
Next

Return .T.