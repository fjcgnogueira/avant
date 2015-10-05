#INCLUDE "PROTHEUS.CH"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัอออออออออออออออออออออหออออออัออออออออออออปฑฑ
ฑฑบPrograma  ณ MT100CLA บ Autor ณ Fernando Nogueira   บ Data ณ 30/09/2015 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯอออออออออออออออออออออสออออออฯออออออออออออนฑฑ
ฑฑบDescricao ณ Ponto de Entrada na Classificacao da NF                    บฑฑ
ฑฑบ          ณ Chamado 002007                                             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico Avant                                           บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
User Function MT100CLA()

Local cUsrCod := PswRet()[1][1]
Local nBlqMov := MV_PAR17

If Left(DtoS(dDataBase),6) <> Left(DtoS(SF1->F1_DTDIGIT),6)
	Final('Classifica็ใo deve ser no mesmo m๊s da entrada.')
ElseIf cUsrCod == "000405" .And. nBlqMov == 2
	Final('O Usuแrio de Importa็ใo deve classificar a nota com Bloqueio de','Movimento.')
ElseIf cUsrCod <> "000405" .And. nBlqMov == 1
	Final('A Classifica็ใo com Bloqueio de Movimento s๓ pode ser utilizada pelo','usuแrio de importa็ใo.')
Endif 

Return .T.