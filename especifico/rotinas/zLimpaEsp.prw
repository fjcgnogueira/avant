#Include "Protheus.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ zLimpaEsp   º Autor ³ Fernando Nogueira  º Data ³02/04/2018º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Trata caracteres especiais em campos                       º±±
±±º          ³ Chamado 005233                                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico AVANT.                   	                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÏÍÍÍÑÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAnalista Resp.³  Data  ³ Manutencao Efetuada                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º              ³  /  /  ³                                               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function zLimpaEsp(lPontuacao)

Local aArea			:= GetArea()
Local cCampo		:= ReadVar()
Local cConteudo		:= &(cCampo)
Local nTamOrig		:= Len(cConteudo)
Default lPontuacao	:= .F.
 
//Retirando caracteres
cConteudo := StrTran(cConteudo, "'", " ")
cConteudo := StrTran(cConteudo, "#", " ")
cConteudo := StrTran(cConteudo, "%", " ")
cConteudo := StrTran(cConteudo, "*", " ")
cConteudo := StrTran(cConteudo, "&", "E")
cConteudo := StrTran(cConteudo, ">", " ")
cConteudo := StrTran(cConteudo, "<", " ")
cConteudo := StrTran(cConteudo, "!", " ")
cConteudo := StrTran(cConteudo, "@", " ")
cConteudo := StrTran(cConteudo, "$", " ")
cConteudo := StrTran(cConteudo, "(", " ")
cConteudo := StrTran(cConteudo, ")", " ")
cConteudo := StrTran(cConteudo, "_", " ")
cConteudo := StrTran(cConteudo, "=", " ")
cConteudo := StrTran(cConteudo, "+", " ")
cConteudo := StrTran(cConteudo, "{", " ")
cConteudo := StrTran(cConteudo, "}", " ")
cConteudo := StrTran(cConteudo, "[", " ")
cConteudo := StrTran(cConteudo, "]", " ")
cConteudo := StrTran(cConteudo, "/", " ")
cConteudo := StrTran(cConteudo, "?", " ")
cConteudo := StrTran(cConteudo, "\", " ")
cConteudo := StrTran(cConteudo, "|", " ")
cConteudo := StrTran(cConteudo, '"', ' ')
cConteudo := StrTran(cConteudo, '°', ' ')
cConteudo := StrTran(cConteudo, 'ª', ' ')
cConteudo := StrTran(cConteudo, 'º', 'o')

// Tira Pontuacao
If lPontuacao
	cConteudo := StrTran(cConteudo, "-", " ")
	cConteudo := StrTran(cConteudo, ".", " ")
	cConteudo := StrTran(cConteudo, ":", " ")
	cConteudo := StrTran(cConteudo, ";", " ")
	cConteudo := StrTran(cConteudo, ",", " ")
EndIf

While Space(02) $ cConteudo
	cConteudo := StrTran(cConteudo, Space(02), Space(01))
End
 
//Adicionando os espacos a direita
cConteudo := Alltrim(cConteudo)
cConteudo += Space(nTamOrig - Len(cConteudo))
 
//Definindo o conteudo do campo
&(cCampo+" := '"+cConteudo+"' ")
 
RestArea(aArea)

Return .T.