#include "PROTHEUS.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ PedTroca    º Autor ³ Fernando Nogueira  º Data ³30/03/2014º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Pedido de Trocas                                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico AVANT.                                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÏÍÍÍÑÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAnalista Resp.³  Data  ³ Manutencao Efetuada                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º              ³  /  /  ³                                               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function PedTroca()

Local   aCabPV
Local   aItemPV     := {}
Local   cNumPV      := CriaVar("C5_NUM")
Local   cItem		:= CriaVar("C6_ITEM")
Local   nValTot

Private lMsErroAuto := .F.

If Empty(cItem)
	cItem := Soma1(cItem)
EndIf
	
SZH->(dbSetOrder(1))  // ZH_FILIAL + ZH_NUMTRC
	
If SZH->(dbSeek(xFilial()+SF1->F1_NUMTRC))

	SZI->(dbSetOrder(1)) 	//	ZI_FILIAL + ZI_NUMTRC
	SB1->(dbSetOrder(1)) 	//	B1_FILIAL + B1_COD
	SA1->(dbSetOrder(1)) 	//	A1_FILIAL + A1_COD + A1_LOJA

	SA1->(dbSeek( xFilial() + SF1->F1_FORNECE + SF1->F1_LOJA ))

	aCabPV := 	{{"C5_NUM"    , cNumPV					,Nil},;
				 {"C5_TIPO"   , "N"						,Nil},;
				 {"C5_CLIENTE", SA1->A1_COD				,Nil},;
				 {"C5_CLIENT" , SA1->A1_COD				,Nil},;
				 {"C5_LOJAENT", SA1->A1_LOJA			,Nil},;
				 {"C5_LOJACLI", SA1->A1_LOJA			,Nil},;
		         {"C5_EMISSAO", dDatabase				,Nil},;
				 {"C5_CONDPAG", "001",Nil},; // Cond. Pagto. Ver Parâmetro?
				 {"C5_DESC1"  , 0						,Nil},;
				 {"C5_TIPLIB" , "1"						,Nil},;
				 {"C5_MOEDA"  , 1						,Nil},;
				 {"C5_TIPOCLI", SA1->A1_TIPO			,Nil},;
				 {"C5_TPFRETE", "C"                     ,Nil} }

	While !SZI->(EOF()) .And.  SZI->ZI_FILIAL+SZI->ZI_NUMTRC == SF1->F1_FILIAL+SF1->F1_NUMTRC

		SB1->(dbSeek( xFilial() + SZI->ZI_PRODUTO ))
		
		// Posiciona no Item da Nota Original
		SD2->(dbSetOrder(3))
		SD2->(msSeek(SZI->ZI_FILIAL+SZI->ZI_NFORI+SZI->ZI_SERIORI+SZI->ZI_CLIENTE+SZI->ZI_LOJA+SZI->ZI_PRODUTO+SZI->ZI_ITEMORI))
		
		nValTot := SZI->ZI_QTDTRC * SZI->ZI_VLRUNIT

		AAdd(aItemPV,{	{"C6_NUM"    ,cNumPV			,Nil},;
						{"C6_ITEM"   ,cItem				,Nil},;
						{"C6_PRODUTO",SZI->ZI_PRODUTO	,Nil},;
						{"C6_QTDVEN" ,SZI->ZI_QTDTRC	,Nil},;
						{"C6_PRUNIT" ,SZI->ZI_VLRUNIT	,Nil},;
						{"C6_PRCVEN" ,SZI->ZI_VLRUNIT	,Nil},;
						{"C6_VALOR"  ,nValTot       	,Nil},;
						{"C6_ENTREG" ,dDatabase			,Nil},;
						{"C6_UM"     ,SZI->ZI_UM		,Nil},; //{"C6_SEGUM"  ,SZ1->ZI_SEGUM		,Nil},;
						{"C6_TES"    ,SD2->D2_TES       ,Nil},; // Tipo de Entrada/Saida do Item
						{"C6_LOCAL"  ,"01"				,Nil},;
						{"C6_CLI"    ,SA1->A1_COD		,Nil},;
						{"C6_LOJA"   ,SA1->A1_LOJA		,Nil} })

		cItem := Soma1(cItem)

		SZI->(dbSkip())
	End

	MSExecAuto({|x,y,z|Mata410(x,y,z)},aCabPv,aItemPV,3)

	If lMsErroAuto
		DisarmTransaction()
    	Mostraerro()
	Else
		ConfirmSX8()
		MsgInfo("Pedido de Vendas Nº "+cNumPV+" criado com sucesso!","Pedido de Troca criado")
	EndIf

Else
	ApMsgAlert("Essa nota não é de Troca")
Endif

Return