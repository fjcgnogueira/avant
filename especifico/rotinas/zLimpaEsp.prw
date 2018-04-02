#Include "Protheus.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � zLimpaEsp   � Autor � Fernando Nogueira  � Data �02/04/2018���
�������������������������������������������������������������������������͹��
���Descricao � Trata caracteres especiais em campos                       ���
���          � Chamado 005233                                             ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico AVANT.                   	                      ���
�������������������������������������������������������������������������͹��
���Analista Resp.�  Data  � Manutencao Efetuada                           ���
�������������������������������������������������������������������������͹��
���              �  /  /  �                                               ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
cConteudo := StrTran(cConteudo, '�', ' ')
cConteudo := StrTran(cConteudo, '�', ' ')
cConteudo := StrTran(cConteudo, '�', 'o')

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