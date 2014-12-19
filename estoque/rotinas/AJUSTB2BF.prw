#INCLUDE "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ"±±
±±ºPrograma  ³AJUSTB2BF ºAutor  ³Rodrigo Leite       º Data ³  06/07/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Programa para realizar o balancemento das tabelas          º±±
±±º          ³ do sistema                                                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function AJUSTB2BF()


Processa({|| AJUSTB2BF1(), "Gerando Ajuste de tabelas SB2,SB8,SBF,SD3,SD5","Processando",.T.})


Return()


Static Function AJUSTB2BF1()

Local   cQuery     := ""
Local   nSegQtd    := 0
Local   nTotal     := 0
Local   nTotalSeg  := 0
Local   cLocal     := ""
Local   cLote      := ""
Local   nSegMov    := 0
Local   nSeq       := 0
Local   nSeqLot    := 0
Local   nCusto     := 0
Local   _aUtru     := {}
Local   lPrdDiv    := .F.
Local 	ARQTRB     := ""
Local	ARQTMS	   := ""
Private cCod       := ""
Private cLotes     := ""
Private nQuant     := 0


aadd(_aUtru,{"CODIGO"	     	, "C",16,00})
aadd(_aUtru,{"DESCRICAO"		, "C",50,00})
aadd(_aUtru,{"LOC"		        , "C",10,00})
aadd(_aUtru,{"QUANT"			, "N",15,02})


_cTemp := CriaTrab(_aUtru, .T.)
DbUseArea(.T.,"DBFCDX",_cTemp,"XLS",.F.,.F.)

cQuery  := " SELECT B2_COD , B2_LOCAL , B2_QATU , B2_QTSEGUM  " + CRLF
cQuery  += " FROM " + RETSQLNAME("SB2")  + CRLF
cQuery  += " WHERE B2_COD NOT IN (SELECT BF_PRODUTO FROM SBF010 WHERE BF_FILIAL='010104' AND BF_LOCAL = '01' AND D_E_L_E_T_ = ' ') " + CRLF
cQuery  += " AND B2_FILIAL = '" +xFilial("SB2")+ "'" + CRLF
cQuery  += " AND B2_LOCAL = '01' AND D_E_L_E_T_ = ' ' AND B2_QATU != 0 AND B2_QACLASS = 0  " + CRLF
cQuery  += " ORDER BY B2_COD "                 
cQuery := ChangeQuery(cQuery)
ARQTMS := GetNextAlias()                                                       

dbUseArea(.T., 'TOPCONN', TcGenQry( ,, cQuery) ,ARQTMS, .T., .F.)

DBSelectArea((ARQTMS))
(ARQTMS)->(dbGotop())                            

While (ARQTMS)->(!Eof())
	
	cCod   := (ARQTMS)->B2_COD
	cLocal := (ARQTMS)->B2_LOCAL
	
	IncProc("Processando...Aguarde: ")
	
	cLote := BUSCALOTE(cCod)
	
	If !Empty(cLote)
		
		nQuant := (ARQTMS)->B2_QATU     
		dbselectarea("SB8")
		dbsetorder(3)
		If SB8->(dbseek(xfilial()+cCod+cLocal+cLote))
			
			nMov      :=   (ARQTMS)->B2_QATU
			nSegMov   :=   (ARQTMS)->B2_QTSEGUM
			cMov      := "499"
			reclock("SD5",.T.)
			SD5->D5_FILIAL   := xFilial("SD5")
			SD5->D5_PRODUTO  := cCod
			SD5->D5_LOCAL    := (ARQTMS)->B2_LOCAL
			SD5->D5_DOC      := "B2BF"
			SD5->D5_DATA     := ddatabase
			SD5->D5_ORIGLAN  := "MAN"
			SD5->D5_NUMSEQ   := SD5->(ProxNum())
			SD5->D5_QUANT    := nMov                    
			SD5->D5_LOTECTL  := cLote
			SD5->D5_DTVALID  := SB8->B8_DTVALID
			SD5->D5_QTSEGUM  := nSegMov
			msunlock()
			
			
			reclock("SB8",.F.)
			
			SB8->B8_SALDO   :=  SB8->B8_SALDO  + nMov
			SB8->B8_SALDO2  :=  SB8->B8_SALDO2 + nSegMov
			
			msunlock()
			
			
			
			reclock("SBF",.T.)
			
			
			SBF->BF_FILIAL  := xFilial("SBF")
			SBF->BF_QUANT   := nMov
			SBF->BF_PRODUTO := (ARQTMS)->B2_COD
			SBF->BF_LOCAL   := cLocal
			SBF->BF_PRIOR   := "ZZZ"
			SBF->BF_LOCALIZ := "BL01"
			SBF->BF_LOTECTL := cLote
			SBF->BF_QTSEGUM := nSegMov
			
			
			msunlock()
			
			
			reclock("SDB",.T.)
			
			SDB->DB_FILIAL  := xFilial("SDB")
			SDB->DB_ITEM    := "0001"
			SDB->DB_PRODUTO := (ARQTMS)->B2_COD
			SDB->DB_LOCAL   := (ARQTMS)->B2_LOCAL
			SDB->DB_LOCALIZ := "BL01"
			SDB->DB_DOC     := "B2BF"
			SDB->DB_TM      := "499"
			SDB->DB_ORIGEM  := "SD3"
			SDB->DB_QUANT   := nMov
			SDB->DB_DATA    := dDataBase
			SDB->DB_LOTECTL := cLote
			SDB->DB_NUMSEQ  := SDB->(ProxNum())
			SDB->DB_TIPO    := "M"
			SDB->DB_QTSEGUM := nSegMov
			SDB->DB_SERVIC  := "499"
			SDB->DB_ATIVID  := "ZZZ"
			SDB->DB_ESTFIS  := "000001"
			SDB->DB_HRINI   := TIME()
			SDB->DB_HRFIM   := TIME()
			SDB->DB_ATUEST  := "S"
			SDB->DB_STATUS  := "M"
			SDB->DB_PRIORI  := "ZZ"
			SDB->DB_ORDATIV := "ZZ"
			SDB->DB_IDOPERA := SDB->(ProxNum())
			
			
			msunlock()
			
			
		Endif
		
	Else
		lPrdDiv    := .T.
		DbSelectArea("XLS")
		Reclock("XLS",.T.)         
		XLS->CODIGO             := (ARQTMS)->B2_COD
		XLS->DESCRICAO          := Posicione("SB1",1,xFilial("SB1")+(ARQTMS)->B2_COD,"B1_DESC")
		XLS->LOC                := (ARQTMS)->B2_LOCAL
		XLS->QUANT              := (ARQTMS)->B2_QATU
		MsUnlock()
		
	Endif
	
	(ARQTMS)->(dbSkip())
Enddo

(ARQTMS)->(dbClosearea())     


cQuery  := " SELECT BF_FILIAL, BF_PRODUTO , BF_LOCAL , BF_LOCALIZ , BF_LOTECTL , BF_QUANT , BF_QTSEGUM " + CRLF
cQuery  += " FROM "+RETSQLNAME("SBF") + CRLF
cQuery  += " WHERE BF_FILIAL = '"+xFilial("SBF")+"' AND BF_LOCAL = '01'  AND  D_E_L_E_T_ = ' '" + CRLF //AND BF_PRODUTO BETWEEN '102041351' AND 'ZZZZZZZZZZZ'
cQuery  += " ORDER BY BF_PRODUTO,BF_LOTECTL " + CRLF
                                             

//MemoWrit("MILAGRE.sql",cQuery)

cQuery := ChangeQuery(cQuery)
ARQTRB := GetNextAlias()                                                   
dbUseArea(.T., 'TOPCONN', TcGenQry( ,, cQuery) ,ARQTRB, .T., .F.)

DBSelectArea((ARQTRB))
(ARQTRB)->(dbGotop())

cCod   := (ARQTRB)->BF_PRODUTO
cLocal := (ARQTRB)->BF_LOCAL
cLote  := (ARQTRB)->BF_LOTECTL
cLotes += "'"+Alltrim((ARQTRB)->BF_LOTECTL)+"'"


While (ARQTRB)->(!Eof())
	
	IncProc("Processando...Aguarde: ")
	
	IF  cCod   != (ARQTRB)->BF_PRODUTO
		  
		
		MILAGRESB8(cCod,cLotes) // LIMPAR OS ITENS DA SB8 QUE NÃO TEM SALDO NO SBF		
		
		dbselectarea("SB8")
		dbsetorder(3)
		If SB8->(dbseek(xfilial()+cCod+cLocal+cLote))
			
			IF nQuant != SB8->B8_SALDO
				
				If nQuant > SB8->B8_SALDO                   // se a contagem for maior que o saldo atual
					nMov      :=   nQuant  - SB8->B8_SALDO
					nSegMov   :=   nSegQtd - SB8->B8_SALDO2
					cMov      := "499"
					reclock("SD5",.T.)
					SD5->D5_FILIAL   := xFilial("SD5")
					SD5->D5_PRODUTO  := cCod
					SD5->D5_LOCAL    := "01"
					SD5->D5_DOC      := "B2BF"
					SD5->D5_DATA     := ddatabase
					SD5->D5_ORIGLAN  := "MAN"
					SD5->D5_NUMSEQ   := SD5->(ProxNum())
					SD5->D5_QUANT    := nMov
					SD5->D5_LOTECTL  := cLote
					SD5->D5_DTVALID  := SB8->B8_DTVALID
					SD5->D5_QTSEGUM  := nSegMov
					msunlock()
					
					
					reclock("SB8",.F.)
					
					SB8->B8_SALDO   :=  nQuant
					SB8->B8_SALDO2  :=  nSegQtd
					
					msunlock()
					
					
				Endif
				
				If nQuant < SB8->B8_SALDO  .and. nTotal != 0               	// se a contagem for menor que o saldo atual
					
					nMov      :=  SB8->B8_SALDO  - nQuant
					nSegMov   :=  SB8->B8_SALDO2 - nSegQtd
					cMov      :=   "999"
					reclock("SD5",.T.)
					SD5->D5_FILIAL   := xFilial("SD5")
					SD5->D5_PRODUTO  := cCod
					SD5->D5_LOCAL    := "01"
					SD5->D5_DOC      := "B2BF"
					SD5->D5_DATA     := ddatabase
					SD5->D5_ORIGLAN  := "MAN"
					SD5->D5_NUMSEQ   := SD5->(ProxNum())
					SD5->D5_QUANT    := nMov
					SD5->D5_LOTECTL  := cLote
					SD5->D5_DTVALID  := SB8->B8_DTVALID
					SD5->D5_QTSEGUM  := nSegMov
					SD5->D5_ESTORNO  := "S"
					msunlock()
					
					reclock("SB8",.F.)
					
					SB8->B8_SALDO   :=  nQuant
					SB8->B8_SALDO2  :=  nSegQtd
					
					msunlock()
					
				Endif
				
				
			Endif
			
		EndIf
		
		dbselectarea("SB2")
		dbsetorder(1)  //B2_FILIAL+B2_COD+B2_LOCAL
		IF SB2->(dbseek(xfilial()+cCod+cLocal))//dbseek(xFilial("SB2")+cCod+cLocal)
			
			If nTotal != SB2->B2_QATU
				
				If SB2->B2_QATU < 0    // zera o saldo menor que 0 na SD3
					
					reclock("SD3",.T.)
					
					nCusto    := SB2->B2_CM1 * SB2->B2_QATU
					nMov      := SB2->B2_QATU * -1
					
					SD3->D3_FILIAL   := xFilial("SD3")
					SD3->D3_TM       := "499" //cMov
					SD3->D3_COD      := cCod
					SD3->D3_UM       := "UN"
					SD3->D3_QUANT    := nMov
					SD3->D3_CF       := "DE4"
					SD3->D3_LOCAL    := "01"
					SD3->D3_DOC      := "B2BF"
					SD3->D3_EMISSAO  := ddatabase
					SD3->D3_GRUPO    := Posicione("SB1",1,xFilial("SB1")+cCod,"B1_GRUPO")
					SD3->D3_CUSTO1    := nCusto
					SD3->D3_SEGUM    := Posicione("SB1",1,xFilial("SB1")+cCod,"B1_SEGUM")
					SD3->D3_QTSEGUM  := SB2->B2_QTSEGUM * -1
					SD3->D3_TIPO     := "PR"
					SD3->D3_USUARIO  := cUserName
					SD3->D3_NUMSEQ   := SD3->(ProxNum())
					
					msunlock()                              '
					
					reclock("SB2",.F.)         // Atualiza o SB2 com os Saldos da SBF
					SB2->B2_QATU      := 0
					SB2->B2_QTSEGUM   := 0
					msunlock()
					
					
					
				Endif
				
				If nTotal > SB2->B2_QATU                    // se a contagem for maior que o saldo atual
					
					nMov      := nTotal     - SB2->B2_QATU
					nSegMov   := nTotalSeg  - SB2->B2_QTSEGUM
					cMov      := "499"
					nCusto    := SB2->B2_CM1 * nMov
					
					reclock("SD3",.T.)
					SD3->D3_FILIAL   := xFilial("SD3")
					SD3->D3_TM       := cMov
					SD3->D3_COD      := cCod
					SD3->D3_UM       := "UN"
					SD3->D3_QUANT    := nMov
					SD3->D3_CF       := "DE4"
					SD3->D3_LOCAL    := "01"
					SD3->D3_DOC      := "B2BF"
					SD3->D3_EMISSAO  := ddatabase
					SD3->D3_GRUPO    := Posicione("SB1",1,xFilial("SB1")+cCod,"B1_GRUPO")
					SD3->D3_CUSTO1   :=	nCusto
					SD3->D3_SEGUM    := Posicione("SB1",1,xFilial("SB1")+cCod,"B1_SEGUM")
					SD3->D3_QTSEGUM  := nSegMov
					SD3->D3_TIPO     := "PR"
					SD3->D3_USUARIO  := cUserName
					SD3->D3_NUMSEQ   := SD3->(ProxNum())
					msunlock()
					
					
					
					reclock("SB2",.F.)         // Atualiza o SB2 com os Saldos da SBF
					SB2->B2_QATU      := nTotal
					SB2->B2_QTSEGUM   := nTotalSeg
					msunlock()
					
					
				Endif
				
				If 	nTotal < SB2->B2_QATU .and. nTotal != 0                   // se a contagem for maior que o saldo atual
					
					nMov      := SB2->B2_QATU  - nTotal
					cMov      := "999"
					nSegMov   := SB2->B2_QTSEGUM - nTotalSeg
					nCusto    := SB2->B2_CM1 * nMov
					
					reclock("SD3",.T.)
					SD3->D3_FILIAL   := xFilial("SD3")
					SD3->D3_TM       := cMov
					SD3->D3_COD      := cCod
					SD3->D3_UM       := "UN"
					SD3->D3_QUANT    := nMov
					SD3->D3_CF       := "DE4"
					SD3->D3_LOCAL    := "01"
					SD3->D3_DOC      := "B2BF"
					SD3->D3_EMISSAO  := ddatabase
					SD3->D3_GRUPO    := Posicione("SB1",1,xFilial("SB1")+cCod,"B1_GRUPO")
					SD3->D3_CUSTO1   := nCusto
					SD3->D3_SEGUM    := Posicione("SB1",1,xFilial("SB1")+cCod,"B1_SEGUM")
					SD3->D3_QTSEGUM  := nSegMov
					SD3->D3_TIPO     := "PR"
					SD3->D3_USUARIO  := cUserName
					SD3->D3_NUMSEQ   := SD3->(ProxNum())
					msunlock()
					
					
					reclock("SB2",.F.)         // Atualiza o SB2 com os Saldos da SBF
					SB2->B2_QATU      := nTotal
					SB2->B2_QTSEGUM   := nTotalSeg
					msunlock()
					
					
				Endif
				
				If nTotal = 0  .and. SB2->B2_QATU != 0 // aqui a logica do total igual a 0
					
					nMov      := SB2->B2_QATU
					cMov      := "999"
					nSegMov   := SB2->B2_QTSEGUM
					nCusto    := SB2->B2_CM1 * nMov
					
					reclock("SD3",.T.)
					SD3->D3_FILIAL   := xFilial("SD3")
					SD3->D3_TM       := cMov
					SD3->D3_COD      := cCod
					SD3->D3_UM       := "UN"
					SD3->D3_QUANT    := nMov
					SD3->D3_CF       := "DE4"
					SD3->D3_LOCAL    := "01"
					SD3->D3_DOC      := "B2BF"
					SD3->D3_EMISSAO  := ddatabase
					SD3->D3_GRUPO    := Posicione("SB1",1,xFilial("SB1")+cCod,"B1_GRUPO")
					SD3->D3_CUSTO1   := nCusto
					SD3->D3_SEGUM    := Posicione("SB1",1,xFilial("SB1")+cCod,"B1_SEGUM")
					SD3->D3_QTSEGUM  := nSegMov
					SD3->D3_TIPO     := "PR"
					SD3->D3_USUARIO  := cUserName
					SD3->D3_NUMSEQ   := SD3->(ProxNum())
					msunlock()
					
					
					reclock("SB2",.F.)         // Atualiza o SB2 com os Saldos da SBF
					SB2->B2_QATU      := 0
					SB2->B2_QTSEGUM   := 0
					msunlock()
					
				Endif
				
				
			EndIf
			nTotal    	:= 0
			nTotalSeg   := 0
			nQuant      := 0
			nSegQtd     := 0
			
			
			cCod   := (ARQTRB)->BF_PRODUTO
			cLote  := (ARQTRB)->BF_LOTECTL
			cLotes := "'"+Alltrim((ARQTRB)->BF_LOTECTL)+"'"  // LIMPA OS LOTES ANTERIORES E COMEÇA UM NOVO
			
		Endif
		
		
	Endif

	
	IF  cCod  == (ARQTRB)->BF_PRODUTO .and. cLote  != (ARQTRB)->BF_LOTECTL
		
		dbselectarea("SB8")
		dbsetorder(3)
		If SB8->(dbseek(xfilial()+cCod+cLocal+cLote))//dbSeek(xFilial("SB8")+cCod+cLocal+cLote)
			
			IF nQuant != SB8->B8_SALDO
				
				If nQuant > SB8->B8_SALDO                   // se a contagem for maior que o saldo atual
					nMov      :=   nQuant  - SB8->B8_SALDO
					nSegMov   :=   nSegQtd - SB8->B8_SALDO2
					cMov      := "499"
					reclock("SD5",.T.)
					SD5->D5_FILIAL   := xFilial("SD5")
					SD5->D5_PRODUTO  := cCod
					SD5->D5_LOCAL    := "01"
					SD5->D5_DOC      := "B2BF"
					SD5->D5_DATA     := ddatabase
					SD5->D5_ORIGLAN  := "MAN"
					SD5->D5_NUMSEQ   := SD5->(ProxNum())
					SD5->D5_QUANT    := nMov
					SD5->D5_LOTECTL  := cLote
					SD5->D5_DTVALID  := SB8->B8_DTVALID
					SD5->D5_QTSEGUM  := nSegMov
					msunlock()
					
					
					reclock("SB8",.F.)
					
					SB8->B8_SALDO   :=  nQuant
					SB8->B8_SALDO2  :=  nSegQtd
					
					msunlock()
					
					
				Endif
				
				If nQuant < SB8->B8_SALDO  .and. nTotal != 0               	// se a contagem for menor que o saldo atual
					
					nMov      :=  SB8->B8_SALDO  - nQuant
					nSegMov   :=  SB8->B8_SALDO2 - nSegQtd
					cMov      :=   "999"
					reclock("SD5",.T.)
					SD5->D5_FILIAL   := xFilial("SD5")
					SD5->D5_PRODUTO  := cCod
					SD5->D5_LOCAL    := "01"
					SD5->D5_DOC      := "B2BF"
					SD5->D5_DATA     := ddatabase
					SD5->D5_ORIGLAN  := "MAN"
					SD5->D5_NUMSEQ   := SD5->(ProxNum())
					SD5->D5_QUANT    := nMov
					SD5->D5_LOTECTL  := cLote
					SD5->D5_DTVALID  := SB8->B8_DTVALID
					SD5->D5_QTSEGUM  := nSegMov
					SD5->D5_ESTORNO  := "S"
					msunlock()
					
					reclock("SB8",.F.)
					
					SB8->B8_SALDO   :=  nQuant
					SB8->B8_SALDO2  :=  nSegQtd
					
					msunlock()
					
				Endif
				
				If nQuant = 0 // se o saldo por endereço for 0 para o lote
					
					nMov      :=  SB8->B8_SALDO
					nSegMov   :=  SB8->B8_SALDO2
					cMov      :=   "999"
					reclock("SD5",.T.)
					SD5->D5_FILIAL   := xFilial("SD5")
					SD5->D5_PRODUTO  := cCod
					SD5->D5_LOCAL    := "01"
					SD5->D5_DOC      := "B2BF"
					SD5->D5_DATA     := ddatabase
					SD5->D5_ORIGLAN  := "MAN"
					SD5->D5_NUMSEQ   := SD5->(ProxNum())
					SD5->D5_QUANT    := nMov
					SD5->D5_LOTECTL  := cLote
					SD5->D5_DTVALID  := SB8->B8_DTVALID
					SD5->D5_QTSEGUM  := nSegMov
					SD5->D5_ESTORNO  := "S"
					msunlock()
					
					reclock("SB8",.F.)
					
					SB8->B8_SALDO   :=  0
					SB8->B8_SALDO2  :=  0
					
					msunlock()
					
					
				EndIf
				
				
			Endif
			
			cLote   := (ARQTRB)->BF_LOTECTL
			nQuant  := 0
			nSegQtd := 0
			cLotes  += ",'"+Alltrim((ARQTRB)->BF_LOTECTL)+"'"
			
		EndIf
		
	Endif
	
	nQuant    += (ARQTRB)->BF_QUANT
	nSegQtd   += (ARQTRB)->BF_QTSEGUM
	nTotal    += (ARQTRB)->BF_QUANT
	nTotalSeg += (ARQTRB)->BF_QTSEGUM
	cCod   := (ARQTRB)->BF_PRODUTO
	cLote  := (ARQTRB)->BF_LOTECTL
		
	
	
	(ARQTRB)->(dbSkip())
	
Enddo

dbselectarea("SB8")
dbsetorder(3)
If SB8->(dbseek(xfilial()+cCod+cLocal+cLote))//dbSeek(xFilial("SB8")+cCod+cLocal+cLote)
	
	IF nQuant != SB8->B8_SALDO
		
		If nQuant > SB8->B8_SALDO                   // se a contagem for maior que o saldo atual
			nMov      :=   nQuant  - SB8->B8_SALDO
			nSegMov   :=   nSegQtd - SB8->B8_SALDO2
			cMov      := "499"
			reclock("SD5",.T.)
			SD5->D5_FILIAL   := xFilial("SD5")
			SD5->D5_PRODUTO  := cCod
			SD5->D5_LOCAL    := "01"
			SD5->D5_DOC      := "B2BF"
			SD5->D5_DATA     := ddatabase
			SD5->D5_ORIGLAN  := "MAN"
			SD5->D5_NUMSEQ   := SD5->(ProxNum())
			SD5->D5_QUANT    := nMov
			SD5->D5_LOTECTL  := cLote
			SD5->D5_DTVALID  := SB8->B8_DTVALID
			SD5->D5_QTSEGUM  := nSegMov
			msunlock()
			
			
			reclock("SB8",.F.)
			
		 	SB8->B8_SALDO   :=  nQuant
			SB8->B8_SALDO2  :=  nSegQtd
			
			msunlock()
			
			
		Endif
		
		If nQuant < SB8->B8_SALDO  .and. nTotal != 0               	// se a contagem for menor que o saldo atual
			
			nMov      :=  SB8->B8_SALDO  - nQuant
			nSegMov   :=  SB8->B8_SALDO2 - nSegQtd
			cMov      :=   "999"
			reclock("SD5",.T.)
			SD5->D5_FILIAL   := xFilial("SD5")
			SD5->D5_PRODUTO  := cCod
			SD5->D5_LOCAL    := "01"
			SD5->D5_DOC      := "B2BF"
			SD5->D5_DATA     := ddatabase
			SD5->D5_ORIGLAN  := "MAN"
			SD5->D5_NUMSEQ   := SD5->(ProxNum())
			SD5->D5_QUANT    := nMov
			SD5->D5_LOTECTL  := cLote
			SD5->D5_DTVALID  := SB8->B8_DTVALID
			SD5->D5_QTSEGUM  := nSegMov
			SD5->D5_ESTORNO  := "S"
			msunlock()
			
			reclock("SB8",.F.)
			
			SB8->B8_SALDO   :=  nQuant
			SB8->B8_SALDO2  :=  nSegQtd
			
			msunlock()
			
		Endif
		
		
	Endif
	
EndIf

dbselectarea("SB2")
dbsetorder(1)  //B2_FILIAL+B2_COD+B2_LOCAL
IF SB2->(dbseek(xfilial()+cCod+cLocal))//dbseek(xFilial("SB2")+cCod+cLocal)
	
	If nTotal != SB2->B2_QATU
		
		If SB2->B2_QATU < 0    // zera o saldo menor que 0 na SD3
			
			reclock("SD3",.T.)
			
			nCusto    := SB2->B2_CM1 * SB2->B2_QATU
			nMov      := SB2->B2_QATU * -1
			
			SD3->D3_FILIAL   := xFilial("SD3")
			SD3->D3_TM       := "499" //cMov
			SD3->D3_COD      := cCod
			SD3->D3_UM       := "UN"
			SD3->D3_QUANT    := nMov
			SD3->D3_CF       := "DE4"
			SD3->D3_LOCAL    := "01"
			SD3->D3_DOC      := "B2BF"
			SD3->D3_EMISSAO  := ddatabase
			SD3->D3_GRUPO    := Posicione("SB1",1,xFilial("SB1")+cCod,"B1_GRUPO")
			SD3->D3_CUSTO1    := nCusto
			SD3->D3_SEGUM    := Posicione("SB1",1,xFilial("SB1")+cCod,"B1_SEGUM")
			SD3->D3_QTSEGUM  := SB2->B2_QTSEGUM * -1
			SD3->D3_TIPO     := "PR"
			SD3->D3_USUARIO  := cUserName
			SD3->D3_NUMSEQ   := SD3->(ProxNum())
			
			msunlock()
			
			reclock("SB2",.F.)         // Atualiza o SB2 com os Saldos da SBF
			SB2->B2_QATU      := 0
			SB2->B2_QTSEGUM   := 0
			msunlock()
			
			
			
		Endif
		
		If nTotal > SB2->B2_QATU                    // se a contagem for maior que o saldo atual
			
			nMov      := nTotal     - SB2->B2_QATU
			nSegMov   := nTotalSeg  - SB2->B2_QTSEGUM
			cMov      := "499"
			nCusto    := SB2->B2_CM1 * nMov
			
			reclock("SD3",.T.)
			SD3->D3_FILIAL   := xFilial("SD3")
			SD3->D3_TM       := cMov
			SD3->D3_COD      := cCod
			SD3->D3_UM       := "UN"
			SD3->D3_QUANT    := nMov
			SD3->D3_CF       := "DE4"
			SD3->D3_LOCAL    := "01"
			SD3->D3_DOC      := "B2BF"
			SD3->D3_EMISSAO  := ddatabase
			SD3->D3_GRUPO    := Posicione("SB1",1,xFilial("SB1")+cCod,"B1_GRUPO")
			SD3->D3_CUSTO1   :=	nCusto
			SD3->D3_SEGUM    := Posicione("SB1",1,xFilial("SB1")+cCod,"B1_SEGUM")
			SD3->D3_QTSEGUM  := nSegMov
			SD3->D3_TIPO     := "PR"
			SD3->D3_USUARIO  := cUserName
			SD3->D3_NUMSEQ   := SD3->(ProxNum())
			msunlock()
			
			
			
			reclock("SB2",.F.)         // Atualiza o SB2 com os Saldos da SBF
			SB2->B2_QATU      := nTotal
			SB2->B2_QTSEGUM   := nTotalSeg
			msunlock()
			
			
		Endif
		
		If 	nTotal < SB2->B2_QATU .and. nTotal != 0                   // se a contagem for maior que o saldo atual
			
			nMov      := SB2->B2_QATU  - nTotal
			cMov      := "999"
			nSegMov   := SB2->B2_QTSEGUM - nTotalSeg
			nCusto    := SB2->B2_CM1 * nMov
			
			reclock("SD3",.T.)
			SD3->D3_FILIAL   := xFilial("SD3")
			SD3->D3_TM       := cMov
			SD3->D3_COD      := cCod
			SD3->D3_UM       := "UN"
			SD3->D3_QUANT    := nMov
			SD3->D3_CF       := "DE4"
			SD3->D3_LOCAL    := "01"
			SD3->D3_DOC      := "B2BF"
			SD3->D3_EMISSAO  := ddatabase
			SD3->D3_GRUPO    := Posicione("SB1",1,xFilial("SB1")+cCod,"B1_GRUPO")
			SD3->D3_CUSTO1   := nCusto
			SD3->D3_SEGUM    := Posicione("SB1",1,xFilial("SB1")+cCod,"B1_SEGUM")
			SD3->D3_QTSEGUM  := nSegMov
			SD3->D3_TIPO     := "PR"
			SD3->D3_USUARIO  := cUserName
			SD3->D3_NUMSEQ   := SD3->(ProxNum())
			msunlock()
			
			
			reclock("SB2",.F.)         // Atualiza o SB2 com os Saldos da SBF
			SB2->B2_QATU      := nTotal
			SB2->B2_QTSEGUM   := nTotalSeg
			msunlock()
			
			
		Endif
		
		If nTotal = 0  .and. SB2->B2_QATU != 0 // aqui a logica do total igual a 0
			
			nMov      := SB2->B2_QATU
			cMov      := "999"
			nSegMov   := SB2->B2_QTSEGUM
			nCusto    := SB2->B2_CM1 * nMov
			
			reclock("SD3",.T.)
			SD3->D3_FILIAL   := xFilial("SD3")
			SD3->D3_TM       := cMov
			SD3->D3_COD      := cCod
			SD3->D3_UM       := "UN"
			SD3->D3_QUANT    := nMov
			SD3->D3_CF       := "DE4"
			SD3->D3_LOCAL    := "01"
			SD3->D3_DOC      := "B2BF"
			SD3->D3_EMISSAO  := ddatabase
			SD3->D3_GRUPO    := Posicione("SB1",1,xFilial("SB1")+cCod,"B1_GRUPO")
			SD3->D3_CUSTO1   := nCusto
			SD3->D3_SEGUM    := Posicione("SB1",1,xFilial("SB1")+cCod,"B1_SEGUM")
			SD3->D3_QTSEGUM  := nSegMov
			SD3->D3_TIPO     := "PR"
			SD3->D3_USUARIO  := cUserName
			SD3->D3_NUMSEQ   := SD3->(ProxNum())
			msunlock()
			
			
			reclock("SB2",.F.)         // Atualiza o SB2 com os Saldos da SBF
			SB2->B2_QATU      := 0
			SB2->B2_QTSEGUM   := 0
			msunlock()
			
		Endif
		
		
	EndIf
	nTotal    	:= 0
	nTotalSeg   := 0
	nQuant      := 0
	nSegQtd     := 0
	
	//			MILAGRESB8(cCod,cLotes) // LIMPAR OS ITENS DA SB8 QUE NÃO TEM SALDO NO SBF
	
	cCod   := (ARQTRB)->BF_PRODUTO
	cLote  := (ARQTRB)->BF_LOTECTL
	cLotes := "'"+Alltrim((ARQTRB)->BF_LOTECTL)+"'"  // LIMPA OS LOTES ANTERIORES E COMEÇA UM NOVO
	
Endif


(ARQTRB)->(dbClosearea())


if lPrdDiv
	
if Msgyesno("Alguns intens não poderão ser ajustados por não possuir nenhum lote para movimentação dos mesmos , deseja exibir os itens?")
		DbSelectArea("XLS")
		XLS->(DbCloseArea())
		
		__CopyFIle( _cTemp+".DBF" , AllTrim(GetTempPath())+_ctemp+".XLS")
		
		ShellExecute("open",AllTrim(GetTempPath())+_ctemp+".XLS","","",1)
		Else
		XLS->(DbCloseArea())
	EndIf
EndIF

Aviso("Aviso","Balanceamento Realizado com sucesso",{"OK"})


Return()


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MILAGRESB8ºAutor  ³Rodrigo Leite       º Data ³  10/06/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ajusta os registros da SB8 que não possuem saldo na SBF.   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function MILAGRESB8(cCod,cLotes)


Local cQuery   := ""
Local nMov     := 0
Local nSegMov  := 0
Local cMov     := "999"
Local ARQTMR1  := ''


cQuery  := " SELECT B8_PRODUTO, B8_LOCAL,B8_SALDO,B8_LOTECTL,B8_SALDO2 " + CRLF
cQuery  += " FROM "+RETSQLNAME("SB8") + CRLF
cQuery  += " WHERE B8_FILIAL = '"+xFilial("SB8")+"' AND B8_LOCAL = '01' AND B8_PRODUTO = '"+Alltrim(cCod)+"' AND "+ CRLF
cQuery  += " B8_LOTECTL NOT IN ("+cLotes+") AND   D_E_L_E_T_ = ' ' "
cQuery  += " ORDER BY B8_PRODUTO,B8_LOTECTL " + CRLF

ARQTMR1 := GetNextAlias()                                                   
dbUseArea(.T., 'TOPCONN', TcGenQry( ,, cQuery) ,ARQTMR1, .T., .F.)

DBSelectArea((ARQTMR1))

(ARQTMR1)->(dbGotop())

While (ARQTMR1)->(!Eof())
	
	dbselectarea("SB8")
	dbsetorder(3)
	If SB8->(dbseek(xfilial()+(ARQTMR1)->B8_PRODUTO+(ARQTMR1)->B8_LOCAL+(ARQTMR1)->B8_LOTECTL))//dbSeek(xFilial("SB8")+TMR->B8_PRODUTO+TMR->B8_LOCAL+TMR->B8_LOTECTL)
		
		nMov      :=  (ARQTMR1)->B8_SALDO
		nSegMov   :=  (ARQTMR1)->B8_SALDO2
		cMov      :=   "999"
		reclock("SD5",.T.)
		SD5->D5_FILIAL   := xFilial("SD5")
		SD5->D5_PRODUTO  := cCod
		SD5->D5_LOCAL    := "01"
		SD5->D5_DOC      := "B2BF"
		SD5->D5_DATA     := ddatabase
		SD5->D5_ORIGLAN  := "MAN"
		SD5->D5_NUMSEQ   := SD5->(ProxNum())
		SD5->D5_QUANT    := nMov
		SD5->D5_LOTECTL  := (ARQTMR1)->B8_LOTECTL
		SD5->D5_DTVALID  := SB8->B8_DTVALID
		SD5->D5_QTSEGUM  := nSegMov
		SD5->D5_ESTORNO  := "S"
		msunlock()
		
		reclock("SB8",.F.)
		
		SB8->B8_SALDO   :=  0
		SB8->B8_SALDO2  :=  0
		
		msunlock()
		
	Endif
	
	(ARQTMR1)->(dbSkip())
Enddo

(ARQTMR1)->(dbClosearea())


Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³BUSCALOTE ºAutor  ³Microsiga           º Data ³  06/10/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


Static Function BUSCALOTE(cCod)


Local cQuery   := ""
Local cRet     := ""
Local ARQTMR2  := ""

cQuery  := " SELECT B8_PRODUTO, B8_LOCAL,B8_LOTECTL " + CRLF
cQuery  += " FROM "+RETSQLNAME("SB8") + CRLF
cQuery  += " WHERE B8_FILIAL = '"+xFilial("SB8")+"' AND B8_LOCAL = '01' AND B8_PRODUTO = '"+Alltrim(cCod)+"' AND "+ CRLF
cQuery  += " D_E_L_E_T_ = ' ' " + CRLF
cQuery  += " ORDER BY B8_LOTECTL " + CRLF
//cQuery := ChangeQuery(cQuery)
ARQTMR2 := GetNextAlias()                                                   

dbUseArea(.T., 'TOPCONN', TcGenQry( ,, cQuery) ,ARQTMR2, .T., .F.)

DBSelectArea((ARQTMR2))
(ARQTMR2)->(dbGotop())        

IF !Empty((ARQTMR2)->B8_LOTECTL)
	
	While (ARQTMR2)->(!Eof())
		
		cRet     := (ARQTMR2)->B8_LOTECTL
		
		(ARQTMR2)->(dbSkip())
	Enddo
	
Endif

(ARQTMR2)->(dbClosearea())

Return (cRet)
