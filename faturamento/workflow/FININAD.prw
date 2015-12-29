#INCLUDE "PROTHEUS.CH"           
#INCLUDE "Totvs.ch"
#INCLUDE "FILEIO.ch"
#INCLUDE "TbiConn.ch"
#INCLUDE "AP5MAIL.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ FININAD   ³ Autor ³ Rogerio Machado    ³ Data  ³ 22/12/15 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Envia E-mail de titulos vencidos                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function FININAD()

Local cLog     	 := ""
Local cFim       := "</body></html>"
Local cAssunto   := ""
Local cDtcorte   := ""
Local cVend		 := ""
Local cRepres    := ""
Local cTotSaldo  := 0
Local _cMascara   := "@E 999,999,999.99"
Private _cFilial    := ""

Prepare Environment EMPRESA '01' FILIAL '010104'

cDtcorte := Dtoc(date()-3)

//Domingo
If Dow(CtoD(cDtcorte)) = 1
	cDtcorte := Dtos(date()-5)
EndIf

//Sabado
If Dow(CtoD(cDtcorte)) = 7
	cDtcorte := Dtos(date()-4)
EndIf


BeginSql alias 'TRC'

SELECT A3_COD AS VEND, A3_NOME AS Representante, A3_EMAIL AS Email, A1_NOME AS Cliente, 
CASE 
	WHEN E1_FILIAL = '010104' THEN 'SANTA CATARINA - SC'
	WHEN E1_FILIAL = '010103' THEN 'SÃO FRANCISCO - BA'
	WHEN E1_FILIAL = '010102' THEN 'PINHAIS'
	WHEN E1_FILIAL = '010101' THEN 'MATRIZ'
ELSE E1_FILIAL 
END AS Filial,
 E1_NUM AS Titulo, E1_PARCELA AS Parcela, E1_VENCREA AS Vencimento, E1_SALDO AS Saldo, A1_CGC AS CNPJ FROM %table:SE1% SE1
INNER JOIN %table:SA1% SA1 ON E1_CLIENTE+E1_LOJA = A1_COD+A1_LOJA AND SA1.%notDel%
INNER JOIN %table:SA3% SA3 ON A1_VEND = A3_COD AND SA3.%notDel%
WHERE SE1.%notDel%
AND E1_SALDO > 0
AND E1_TIPO IN ('NF')
AND A3_MSBLQL = '2'
AND A3_COD IN ('000034', '000247')
AND E1_VENCREA <= %exp:cDtcorte%
ORDER BY A3_COD, A3_NOME, A1_NOME, E1_FILIAL, E1_NUM, E1_PARCELA

EndSql

TRC->(DbGoTop())

While TRC->(!Eof())
	cVend     := TRC->VEND
	cRepres   := TRC->Representante
	cTotSaldo := 0
	cAssunto  := ""
	cPara     := ""
	cLog := ""
	cLog += "<html><body>"
	
	cLog += "<span style='color: rgb(1, 0, 0);'></span>"
	cLog += "<table style='text-align: left; width: 100%;' border='1'"
 	cLog += "cellpadding='2' cellspacing='2'>"
	cLog += "<tbody>"
   	cLog += "<tr align='center'>"
	cLog += "<td style='background-color: rgb(191, 225, 214);'"
	cLog += "colspan='8' rowspan='1'><span"
	cLog += "style='font-weight: bold;'><strong>Relação de Títulos em Aberto</strong></span></td>"
	cLog += "</tr>"
	cLog += "  </tbody>"
	cLog += "</table>"
	cLog += "<span style='color: rgb(1, 0, 0);'>"
	cLog += "</span>"
	cLog += "<table style='text-align: left; width: 100%;' border='1'"
 	cLog += "cellpadding='2' cellspacing='2'>"
  	cLog += "<tbody>"
   	cLog += "<tr align='center'>"
   	cLog += "<td style='background-color: rgb(191, 225, 214);'"
 	cLog += "colspan='8' rowspan='1'><span"
 	cLog += "style='font-weight: bold;'><strong>" + cRepres + "</strong></span></td>"
  	cLog += "</tr>"
    
	cLog += "<tr>"
	cLog += "<td><p align='center' class='style1'><strong>Cliente</strong></p></td>"
	cLog += "<td><p align='center' class='style1'><strong>Filial</strong></p></td>"
	cLog += "<td><p align='center' class='style1'><strong>Título</strong></p></td>"
	cLog += "<td><p align='center' class='style1'><strong>Parcela</strong></p></td>"
	cLog += "<td><p align='center' class='style1'><strong>Vencimento</strong></p></td>"
	cLog += "<td><p align='center' class='style1'><strong>Saldo</strong></p></td>"
	cLog += "<td><p align='center' class='style1'><strong>CNPJ</strong></p></td>"
	cLog += "</tr>"
	While(!Eof('TRC')) .AND. cVend = TRC->VEND
			cLog += "<tr>"
			cLog += "<td>" + CValToChar(TRC->Cliente) + "</td>"
			cLog += "<td>" + CValToChar(TRC->Filial)  + "</td>"
			cLog += "<td>" + CValToChar(TRC->Titulo)  + "</td>"
			cLog += "<td>" + CValToChar(TRC->Parcela) + "</td>"
			cLog += "<td>" + CValToChar(StoD(TRC->Vencimento)) + "</td>"			
			cLog += "<td>" + Transform(TRC->Saldo, _cMascara)  + "</td>"
			cTotSaldo += TRC->Saldo
			cLog += "<td>" + CValToChar(TRC->CNPJ)    + "</td>"
			cLog += "</tr>"
			cPara := TRC->Email		
			DbSkip()
	End
	cLog += "<td  align='center' style='background-color: rgb(191, 225, 214);' colspan='8' rowspan='1'><strong>Total: " + Transform(cTotSaldo, _cMascara) + "</strong></td>"	
	cLog += "</tbody>
	cLog += "</table>"
	cLog += cFim
	cAssunto := "TÍTULOS EM ABERTO - " + cRepres
	U_MHDEnvMail(cPara, "", "", cAssunto, cLog, "")
	DbSkip()
End

RESET ENVIRONMENT
	
Return