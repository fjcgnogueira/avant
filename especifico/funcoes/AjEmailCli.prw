#Include "Totvs.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออปฑฑ
ฑฑบPrograma  ณ AjEmailCliบ Autor ณ Fernando Nogueira  บ Data ณ 31/08/2017 บฑฑ
ฑฑฬออออออออออุอออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออนฑฑ
ฑฑบDesc.     ณ Ajustar e-mails de clientes, manter somente os validos     บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico Avant                                           บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function AjEmailCli()

Local cAliasTRB  := GetNextAlias()
Local cEmail     := ""
Local cMailFim   := ""
Local aEmail     := {}
Local _nI
Local cLog       := ""
Local cFileLog   := "AJUSTE_EMAIL.TXT"
Local cPathLog   := "\LOGS\"

SET CENTURY ON

ConOut("["+DtoC(Date())+" "+Time()+"] [AjEmailCli] Inicio")
cLog += "["+DtoC(Date())+" "+Time()+"] [AjEmailCli] Inicio" + Chr(13)+Chr(10)
cLog += Replicate( "-", 128 ) + Chr(13)+Chr(10)

dbSelectArea("SA1")
dbSetOrder(01)

BeginSql alias cAliasTRB
	SELECT A1_COD,A1_LOJA,A1_EMAIL,R_E_C_N_O_ SA1RECNO FROM %table:SA1% SA1
	WHERE SA1.%notDel% AND A1_EMAIL <> ' ' AND A1_EMAIL <> 'ISENTO'
	ORDER BY A1_EMAIL
EndSql

(cAliasTRB)->(dbGoTop())

While (cAliasTRB)->(!Eof())

	SA1->(dbGoTo((cAliasTRB)->SA1RECNO))

	cEmail   := AllTrim((cAliasTRB)->A1_EMAIL)
	cMailFim := ""
	aEmail   := {}
	lAltera  := .F.

	If "," $ cEmail
		While "," $ cEmail
			aAdd(aEmail,Left(cEmail,At(",",cEmail)-1))
			cEmail := Substring(cEmail,At(",",cEmail)+1,Len(cEmail)-At(",",cEmail))
		End
		aAdd(aEmail,cEmail)
	Else
		aAdd(aEmail,cEmail)
	Endif

	For _nI := 1 To Len(aEmail)
		If U_EmailJSON(aEmail[_nI],.F.)
			If Empty(cMailFim)
				cMailFim += aEmail[_nI]
			Else
				cMailFim += "," + aEmail[_nI]
			Endif
		Endif
	Next

	If AllTrim((cAliasTRB)->A1_EMAIL) <> cMailFim
		If Empty(cMailFim)
			cMailFim := "ISENTO"
		Endif
		If SA1->(RecLock("SA1",.F.))
			SA1->A1_EMAIL := cMailFim
			SA1->(MsUnlock())
			ConOut("["+DtoC(Date())+" "+Time()+"] [AjEmailCli] Cliente/Loja: "+(cAliasTRB)->(A1_COD+"/"+A1_LOJA + " - Antes: "+AllTrim(A1_EMAIL)+" - Depois: "+cMailFim))
			cLog += "["+DtoC(Date())+" "+Time()+"] [AjEmailCli] Cliente/Loja: "+(cAliasTRB)->(A1_COD+"/"+A1_LOJA + " - Antes: "+AllTrim(A1_EMAIL)+" - Depois: "+cMailFim) + Chr(13)+Chr(10)
		Endif
	Endif

	(cAliasTRB)->(dbSkip())
End

ConOut("["+DtoC(Date())+" "+Time()+"] [AjEmailCli] Fim")
cLog += Replicate( "-", 128 ) + Chr(13)+Chr(10)
cLog += "["+DtoC(Date())+" "+Time()+"] [AjEmailCli] Fim"

MemoWrite(cPathLog+cFileLog, cLog)

Return
