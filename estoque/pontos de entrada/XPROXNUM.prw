#Include "Protheus.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ xProxNum ³ Autor ³ Fernando Nogueira   ³ Data ³ 02/09/2015 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Definicao do proximo NumSeq                                ³±±
±±³          ³ O sistema estah perdendo a sequencia para os Pedidos que   ³±±
±±³          ³ sao gerados pelo execauto e liberados automaticamente no   ³±±
±±³          ³ credito na geracao do DCF                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Utilizacao³ AVANT                                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function xProxNum()

Local cNumSeq := ""

BeginSQL Alias 'TRB'
	SELECT MAX(NUMSEQ) NUMSEQ FROM
	(SELECT MAX(D1_NUMSEQ) NUMSEQ FROM %Table:SD1%
	UNION
	SELECT MAX(D2_NUMSEQ) NUMSEQ FROM %Table:SD2%
	UNION
	SELECT MAX(D3_NUMSEQ) NUMSEQ FROM %Table:SD3%
	UNION
	SELECT MAX(DCF_NUMSEQ) NUMSEQ FROM %Table:DCF%) QRY_NUMSEQ
EndSQL

cNumSeq := Soma1(PadR(TRB->NUMSEQ,TamSx3("D3_NUMSEQ")[1]),,,.T.)
PutMV("MV_DOCSEQ",cNumSeq)

TRB->(DbCloseArea())

Return cNumSeq