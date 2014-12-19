#include "Protheus.ch"
#include "Rwmake.ch"
#include "Topconn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ AltCadCli³ Autor ³ Rogerio Machado       ³ Data ³ 13/05/14 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Programa para alterar o vendedor ou a regiao no cadastro   ³±±
±±³          ³ de clientes                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Utilizacao³ Especifico Avant                                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function AltCadRep()

Local bRepD    := {|_x|cGetRepD:=Posicione("SA3",1,xFilial("SA3")+cGetRepD,"A3_NOME"),.T.}
Local bRepA    := {|_x|cGetRepA:=Posicione("SA3",1,xFilial("SA3")+cGetRepA,"A3_NOME"),.T.}
Local bEstadoD := {|_x|cGetEstD:=Posicione("SX5",1,xFilial("SX5")+"12"+cGetEstD,"X5_CHAVE"),.T.}
Local bEstadoA := {|_x|cGetEstA:=Posicione("SX5",1,xFilial("SX5")+"12"+cGetEstA,"X5_CHAVE"),.T.}
Local bRepNov  := {|_x|cGetNovR:=Posicione("SA3",1,xFilial("SA3")+cGetNovR,"A3_NOME"),.T.}

Local _lRetorno := .F. //Validacao da dialog criada oDlg
Local _nOpca    := 0 //Opcao da confirmacao
Local _bOk       := {|| _nOpca:=1,_lRetorno:=ProcAlt(),oDlgVend:End() } //botao de ok
Local _bCancel   := {|| _nOpca:=0,oDlgVend:End() } //botao de cancelamento
Local _cArqEmp  := "" //Arquivo temporario com as empresas a serem escolhidas
Local _aStruTrb := {} //estrutura do temporario
Local _aBrowse  := {} //array do browse para demonstracao das empresas
Local _aEmpMigr := {} //array de retorno com as empresas escolhidas

Private lInverte := .F.       //Variaveis para o MsSelect
Private cMarca   := GetMark() //Variaveis para o MsSelect
Private oBrwTrb               //objeto do msselect
Private oDlg

//Local oFntAr10	:= TFont():New("Arial",10,14,,.F.,,,,.T.,.F.)

Private cGetEstA   := Space(TamSx3("A1_EST")[1])
Private cGetEstD   := Space(TamSx3("A1_EST")[1])
Private cGetNovR   := Space(TamSx3("A3_COD")[1])
Private cGetRegA   := Space(3)
Private cGetRegD   := Space(3)
Private cGetRepA   := Space(TamSx3("A3_NOME")[1])
Private cGetRepD   := Space(TamSx3("A3_NOME")[1])
Private cSayEstA   := Space(1)
Private cSayEstD   := Space(1)
Private cSayNovR   := Space(1)
Private cSayRegA   := Space(1)
Private cSayRegD   := Space(1)
Private cSayRepA   := Space(1)
Private cSayRepD   := Space(1)
Private cGetNovRG  := Space(3)

SetPrvt("oDlgVend","oGrp1","oSayEstD","oSay2","oSay3","oSay4","oSay5","oSay6","oSay8","oGetEstD","oGetEstA")
SetPrvt("oGetRepA","oGetRegD","oGetRegA","oGetNovR","oBtn1","oGetNovRG")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define campos do TRB                                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

aadd(_aStruTrb,{"A1COD"    ,"C",06,0})
aadd(_aStruTrb,{"A1LOJA"   ,"C",02,0})
aadd(_aStruTrb,{"A1NOME"   ,"C",50,0})
aadd(_aStruTrb,{"A1EST"    ,"C",2,0})
aadd(_aStruTrb,{"A1VEND"   ,"C",6,0})
aadd(_aStruTrb,{"OK"       ,"C",02,0})
aadd(_aStruTrb,{"A1REGIAO" ,"C",3,0})
aadd(_aStruTrb,{"A3NOME"   ,"C",40,0})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define campos do MsSelect                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

aadd(_aBrowse,{"OK"       ,,"" })
aadd(_aBrowse,{"A1COD"    ,,"Código" })
aadd(_aBrowse,{"A1LOJA"   ,,"Loja" })
aadd(_aBrowse,{"A1NOME"   ,,"Nome" })
aadd(_aBrowse,{"A1EST"    ,,"Estado" })
aadd(_aBrowse,{"A1VEND"   ,,"Cod. Repre." })
aadd(_aBrowse,{"A3NOME"   ,,"Representante" })
aadd(_aBrowse,{"A1REGIAO" ,,"Região" })

If Select("TRB") > 0
	TRB->(DbCloseArea())
Endif

_cArqEmp := CriaTrab(_aStruTrb)

dbUseArea(.T.,__LocalDriver,_cArqEmp,"TRB")

cGetRepD := "      "
cGetRepA := "      "

//Monta arquivo para gravar os dados no arquivo temporario...
GeraArqTRB(cGetRepD,cGetRepA,cGetEstD,cGetEstA,cGetRegD,cGetRegA)

cGetRepD := Space(06)
cGetRepA := "ZZZZZZ"
cGetEstD := Space(02)
cGetEstA := "ZZ"
cGetRegD := Space(03)
cGetRegA := "ZZZ"

@ 001,001 TO 768,1024 DIALOG oDlgVend TITLE OemToAnsi("Alterar Cadastros")

oDlgVend   := MSDialog():New( 109,227,617,1140,"Alterar Cadastros",,,.F.,,,,,,.T.,,,.T. )
oGrp1      := TGroup():New( 000,000,080,460,"",oDlgVend,CLR_BLACK,CLR_WHITE,.T.,.F. )
oSayEstD   := TSay():New( 011,004,{||"Estado de?"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay2      := TSay():New( 011,114,{||"Estado até?"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay3      := TSay():New( 023,004,{||"Representante de?"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,054,008)
oSay4      := TSay():New( 023,114,{||"Representante até?"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,054,008)
oSay5      := TSay():New( 037,004,{||"Região de?"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,054,008)
oSay6      := TSay():New( 037,114,{||"Região até?"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,054,011)
oSay8      := TSay():New( 049,004,{||"Novo Representante?"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,054,008)
oSay9      := TSay():New( 049,114,{||"Novo Região?"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,054,020)
oGetEstD   := TGet():New( 007,060,{|u| If(PCount()>0,cGetEstD:=u,cGetEstD)},oGrp1,050,008,"@!",,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"12","cGetEstD",,)
oGetEstA   := TGet():New( 007,165,{|u| If(PCount()>0,cGetEstA:=u,cGetEstA)},oGrp1,050,008,"@!",,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"12","cGetEstA",,)
oGetRepD   := TGet():New( 020,060,{|u| If(PCount()>0,cGetRepD:=u,cGetRepD)},oGrp1,050,008,"@!",,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SA3","cGetRepD",,)
oGetRepA   := TGet():New( 020,165,{|u| If(PCount()>0,cGetRepA:=u,cGetRepA)},oGrp1,050,008,"@!",,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SA3","cGetRepA",,)
oGetRegD   := TGet():New( 033,060,{|u| If(PCount()>0,cGetRegD:=u,cGetRegD)},oGrp1,050,008,"@!",,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"X3","cGetRegD",,)
oGetRegA   := TGet():New( 033,165,{|u| If(PCount()>0,cGetRegA:=u,cGetRegA)},oGrp1,050,008,"@!",,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"X3","cGetRegA",,)
oGetNovR   := TGet():New( 046,060,{|u| If(PCount()>0,cGetNovR:=u,cGetNovR)},oGrp1,050,008,"@!",,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SA3","cGetNovR",,)
oGetNovRG  := TGet():New( 046,165,{|u| If(PCount()>0,cGetNovRG:=u,cGetNovRG)},oGrp1,050,008,"@!",,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"X3","cGetNovRG",,)
oBtn1      := TButton():New( 064,092,"Pesquisar",oGrp1,{|| CursorWait(),GeraArqTRB(cGetRepD,cGetRepA,cGetEstD,cGetEstA,cGetRegD,cGetRegA),CursorArrow()},044,012,,,,.T.,,"",,,,.F. )

oBrwTrb := MsSelect():New("TRB","OK","",_aBrowse,@lInverte,@cMarca,{080,002,240,460})

oBrwTrb:oBrowse:lCanAllmark := .T.

Eval(oBrwTrb:oBrowse:bGoTop)

oBrwTrb:oBrowse:Refresh()

Activate MsDialog oDlgVend On Init (EnchoiceBar(oDlgVend,_bOk,_bCancel,,)) Centered VALID _lRetorno

//fecha area de trabalho e arquivo temporário criados
If Select("TRB") > 0
	DbSelectArea("TRB")
	DbCloseArea()
	Ferase(AllTrim(_cArqEmp)+OrdBagExt())
Endif

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³ GeraArqTRB  º Autor ³ Rogerio Machado    º Data ³13/05/2014º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Gera o arquivo de trabalho temporario para o MsSelect      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function GeraArqTRB(cGetRepD,cGetRepA,cGetEstD,cGetEstA,cGetRegD,cGetRegA)

cQuery := "SELECT SA1.A1_COD, SA1.A1_LOJA, SA1.A1_NOME, SA1.A1_EST, SA1.A1_VEND, SA3.A3_NOME, SA1.A1_REGIAO FROM SA1010 AS SA1 "
cQuery += "INNER JOIN SA3010 AS SA3 ON SA1.A1_VEND = SA3.A3_COD AND SA3.D_E_L_E_T_ = '' "
cQuery += "WHERE SA1.A1_VEND BETWEEN '"+cGetRepD+"' AND '"+cGetRepA+"' AND SA1.D_E_L_E_T_ = '' "
cQuery += "AND SA1.A1_EST BETWEEN '"+cGetEstD+"' AND '"+cGetEstA+"' "
cQuery += "AND SA1.A1_REGIAO BETWEEN '"+cGetRegD+"' AND '"+cGetRegA+"' "
cQuery += "ORDER BY SA1.A1_VEND, SA1.A1_NOME " "
	
TCQuery cQuery new Alias (cAlias:=GetNextAlias())

TRB->(dbGoTop())

// Limpa a TRB
While TRB->(!Eof())
	TRB->(RecLock("TRB",.F.))
	TRB->(dbDelete())
	TRB->(MsUnlock())
	TRB->(DbSkip())
End

// Alimenta a TRB
While (cAlias)->(!Eof())
	RecLock("TRB",.T.)
	
	TRB->OK       := Space(2)
	TRB->A1COD    := (cAlias)->A1_COD
	TRB->A1LOJA   := (cAlias)->A1_LOJA
	TRB->A1NOME   := (cAlias)->A1_NOME
	TRB->A1EST    := (cAlias)->A1_EST
	TRB->A1VEND   := (cAlias)->A1_VEND
	TRB->A3NOME   := (cAlias)->A3_NOME
	TRB->A1REGIAO := (cAlias)->A1_REGIAO
	
	MsUnlock()
	
	(cAlias)->(DbSkip())
Enddo

TRB->(dbGoTop())

(cAlias)->(DbCloseArea())

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³ ProcAlt     º Autor ³ Rogerio Machado    º Data ³13/05/2014º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Processa as alteracoes selecionados pelo usuario           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ProcAlt()

	Local _lReturn := .F.
	Local _nQuant  := 0

	If !Empty(cGetNovR) .And. !Empty(cGetNovRG)
		MSGALERT("Selecionar apenas um campo para alteração: Representante ou Região!")
		Return _lReturn
	EndIf
	
	TRB->(dbGoTop()) 

	If !Empty(cGetNovR)
		While TRB->(!Eof())
			If !Empty(TRB->OK)
				SA1->(dbSeek(xFilial("SA1")+TRB->A1COD))
				SA1->(Reclock("SA1",.F.))
				SA1->A1_VEND := cGetNovR
				SA1->(MSUNLOCK())
				_lReturn := .T.
				_nQuant++ 
			Endif
			TRB->(dbSkip())
		End
	ElseIf !Empty(cGetNovRG)
		While TRB->(!Eof())
			If !Empty(TRB->OK)
				SA1->(dbSeek(xFilial("SA1")+TRB->A1COD))
				Reclock("SA1",.F.)
				SA1->A1_REGIAO := cGetNovRG
				SA1->(MSUNLOCK())
				_lReturn := .T.
				_nQuant++
			Endif
			TRB->(dbSkip())
		End
	Else
		MSGALERT("Selecionar um campo para alteração: Representante ou Região!")
		Return _lReturn
	EndIf
	
	If _lReturn
		MSGALERT("Foram alterados " + CvalToChar(_nQuant)+ " cadastros de clientes com sucesso!")
	Else
		MSGALERT("Selecione algum registro para alteração!")
	Endif

	TRB->(dbGoTop()) 
	
Return _lReturn