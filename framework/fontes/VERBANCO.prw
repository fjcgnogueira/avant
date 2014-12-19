#INCLUDE "Protheus.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³VERBANCO  º Autor ³ Amedeo D. P. Filho º Data ³  30/06/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Verifica tabelas com conteudo Limpeza dos Dados            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AVANT.                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function VERBANCO()

	Local nOpc			:= 0
	Private cResultado	:= ""
	
	nOpc := Aviso("Aviso","Analisa Tabelas do Banco de Dados?",{"Sim","Não"})
	
	If nOpc == 1
		Processa( {||ANALISA()},"Analisando Tabelas...")
	EndIf

 	Aviso("Atenção!!!",	"Tabelas com Conteudo:" + CRLF + CRLF + cResultado	,{"Ok"},3,"Analise Concluida")

Return

Static Function ANALISA()

	Local cTabela	:= ""
	Local cAlias	:= ""
	Local cNomTab	:= ""
	Local cQuery	:= ""
	Local cVerTab	:= ""

	DbSelectarea("SX2")
	SX2->(DbSetorder(1))
	SX2->(DbGotop())
	ProcRegua(SX2->(RecCount()))
	While !SX2->(EOF())

		cTabela		:= X2_ARQUIVO
		cAlias 		:= X2_CHAVE
		cNomTab		:= X2_NOME
		cVerTab 	:= ""
		
		IncProc( "Analisando Dados (Tabela : " + cAlias + ")" )

		cVerTab := "SELECT TOP 1 * FROM "+ Alltrim(cTabela) + " WHITH (NOLOCK) "

		If TCSQLExec(cVerTab) < 0 //Caso nao encontre tabela Criada no Banco
			SX2->(DbSkip())
			Loop
		Endif

		cQuery := " SELECT * FROM "+ Alltrim(cTabela) + " WHITH (NOLOCK) " + CRLF

		If Select("TRB") > 0
			TRB->(DbCloseArea())
		EndIf

		DbUseArea(.T., "TopConn", TCGenQry( NIL, NIL, cQuery), "TRB", .F., .F.)

	    TRB->(DbGoTop())
		If !TRB->(EOF())
			cResultado	+= 	"SELECT * FROM " + Alltrim(cTabela) + CHR(9) +;
							" -- " + cNomTab + CHR(9) +;
							" DELETE FROM " + Alltrim(cTabela) + CRLF
		EndIf

		If Select("TRB") > 0
			TRB->(DbCloseArea())
		EndIf

		SX2->(DbSkip())

	Enddo

Return Nil
		