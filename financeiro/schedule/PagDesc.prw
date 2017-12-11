#INCLUDE "PROTHEUS.CH"           
#INCLUDE "Totvs.ch"
#INCLUDE "FILEIO.ch"
#INCLUDE "TbiConn.ch"
#INCLUDE "AP5MAIL.CH"



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ PAGDESC   ³ Autor ³ Rogerio Machado        ³ Data  ³ 11/12/17 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Informativo para pagar boletos vencidos com desconto          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function PagDesc(aParam)

Local cAssunto   := ""
Local _cPara     := ""
Local _cCcopia   := "rogerio.machado@avantlux.com.br, cobranca@avantlux.com.br"
Local oProcess  := Nil
Local cArquivo  := "\MODELOS\Pague_Desconto.html"
Local aTabelas  := {"SE1","SA1"}
Local cAlias1   := GetNextAlias()						// Pega o proximo Alias Disponivel

RpcClearEnv()
RPCSetType(3)
RpcSetEnv(aParam[1], aParam[2], NIL, NIL, "FIN", NIL, aTabelas)


Prepare Environment EMPRESA '01' FILIAL '010104'

BeginSql alias cAlias1

	SELECT DISTINCT RTRIM(A1_EMAIL) AS A1_EMAIL FROM %table:SA1% SA1 
	INNER JOIN %table:SE1% AS SE1 ON A1_COD+A1_LOJA = E1_CLIENTE+E1_LOJA AND SE1.%notDel%
	WHERE SA1.%notDel% AND A1_EMAIL NOT IN ('ISENTO',' ') AND E1_SALDO > 0 AND E1_VENCREA <= '20171206'
	ORDER BY 1

EndSql

ConOut("[PAG_DESC] - Disparando e-mails")

DbSelectArea(cAlias1)
(cAlias1)->(DbGoTop())

While (cAlias1)->(!Eof())

	oProcess := TWFProcess():New("PAG_DESC","INADIMPLENCIA")
	oProcess:NewTask("Informativos de descontos para boletos vencidos",cArquivo)
	oHTML := oProcess:oHTML

	_cPara     := (cAlias1)->A1_EMAIL
	cAssunto := "Avant - Pague com Desconto"
	
	oProcess:cSubject := "Avant - Pague com Desconto"

	oProcess:USerSiga := "000000"
	oProcess:cTo      := _cPara
	oProcess:cBCC     := _cCcopia

	oProcess:Start()
	oProcess:Finish()

	ConOut("Enviado para: "+ alltrim(_cPara) +","+ alltrim(_cCcopia))
	(cAlias1)->(DbSkip())
	
End

ConOut("[PAG_DESC] - Finalizado")

(cAlias1)->(dbCloseArea())

Return


//RESET ENVIRONMENT
	
