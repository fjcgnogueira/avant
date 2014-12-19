#INCLUDE "Protheus.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ CUBAGEM  º Autor ³ Fernando Nogueira  º Data ³ 03/11/2014 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Faz o calculo de cubagem para imprimir na Danfe           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Avant                                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function Cubagem(aCubagem)
// aCubagem(Produto, Quantidade)

Local nCubagem := 0
Local aAreaSB1 := SB1->(GetArea())
Local aAreaSB5 := SB5->(GetArea())
Local cRetorno := ""

For _nI := 1 to Len(aCubagem)

	SB1->(dbSeek(xFilial("SB1")+aCubagem[_nI][1]))
	
	If SB1->B1_LOCALIZ = 'S' .And. SB1->B1_TIPO $ ('PA.PR') .And. AllTrim(SB1->B1_POSIPI) <> '99999999'
	
		If SB1->B1_X_COM2 > 0 .And. SB1->B1_X_LAR2 > 0 .And. SB1->B1_X_ALT2 > 0
	
			If SB5->(msSeek(xFilial("SB5")+aCubagem[_nI][1]))
				If SB5->B5_ALTURA > 0 .And. SB5->B5_LARG > 0 .And. SB5->B5_COMPR > 0
					nCubagem += NoRound(SB5->B5_ALTURA * SB5->B5_LARG * SB5->B5_COMPR * aCubagem[_nI][2],4)
				Else
					nCubagem := 0
					Exit
				Endif
			Else
				nCubagem := 0
				Exit
			Endif
			
		Else
			nCubagem := 0
			DispCub()
			Exit
		Endif
		
	Else
		nCubagem := 0
		Exit
	Endif
	
Next _nI

If nCubagem > 0
	cRetorno += " - Cubagem (m3): " + Transform(nCubagem, "@E 999.9999")
Endif

SB5->(RestArea(aAreaSB5))
SB1->(RestArea(aAreaSB1))

Return cRetorno

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ DispCub   ³ Autor ³ Fernando Nogueira  ³ Data  ³ 06/11/2014 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Dispara e-mail na definicao de cubagem da Danfe             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function DispCub()

Local _cMailTo  := GetMv("ES_MAILPRD")
Local _cMailCC  := GetMv("ES_EMAILTI")
Local _cAssunto := ""
Local _cCorpoM  := "" 

_cAssunto := 'Produto: '+AllTrim(SB1->B1_COD)+' - Faltando Dimensões da Caixa Externa' 

_cCorpoM += '<html>' 
_cCorpoM += '<head>'
_cCorpoM += '<title>Produto Faltando Dimensões da Caixa Externa</title>'
_cCorpoM += '<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">' 
_cCorpoM += '<style type="text/css">'
_cCorpoM += '<!--'
_cCorpoM += '.style1 {font-family: Arial, Helvetica, sans-serif}'
_cCorpoM += '.style3 {font-family: Arial, Helvetica, sans-serif; font-weight: bold; }'
_cCorpoM += '.style4 {color: #FF0000}'
_cCorpoM += '-->'
_cCorpoM += '</style>' 
_cCorpoM += '</head>' 
_cCorpoM += '<body>'
_cCorpoM += '  <p align="center" class="style1"><strong>PRODUTO FALTANDO DIMENSÕES DA CAIXA EXTERNA</strong></p>' 
_cCorpoM += '  <p class="style1"><strong>Data: </strong>'+DtoC(Date())+'</p>'
_cCorpoM += '  <p class="style1"><strong>Hora: </strong>'+Substr(Time(),1,5)+'</p>'
_cCorpoM += '  <p class="style1"><strong>Filial : </strong>'+SM0->M0_FILIAL+'</p>'
_cCorpoM += '  <p class="style1"><strong>Produto: </strong>'+AllTrim(SB1->B1_COD)+'</p>'
_cCorpoM += '  <p class="style1"><strong>Descrição: </strong>'+AllTrim(SB1->B1_DESC)+'</p>'
_cCorpoM += '</body>' 
_cCorpoM += '</html>'

U_MHDEnvMail(_cMailTo, _cMailCC, "", _cAssunto, _cCorpoM, "")
 
Return
