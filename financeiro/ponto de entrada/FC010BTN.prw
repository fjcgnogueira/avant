#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "FWBROWSE.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ FC010BTN º Autor ³ Fernando Nogueira  º Data ³ 22/08/2016  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de Entrada para Adicionar Botao na Consulta a        º±±
±±º          ³ Posicao do Cliente                                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Avant                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function FC010BTN()

If Paramixb[1] == 1
	Return 'Excluídos'
ElseIf Paramixb[1] == 2
	Return 'Títulos Excluídos'
Endif

Return TitCancel()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ TitCancel() º Autor ³ Fernando Nogueira  º Data ³22/08/2016º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Titulos Cancelados                                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico AVANT.                   	                      º±±
±±º          ³ Chamado 003863                   	                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function TitCancel()

Local oBrowse
Local oColumn
Local oDlg
Local cQuery := ""
Local aIndex := {}
Local aSeek  := {}
Local oBtnCan

Private aSize    := MsAdvSize(.T.)
Private aInfo    := {aSize[1],aSize[2],aSize[3],aSize[4],3,3}
Private aPosObj  := {}
Private aObjects := {}

AAdd( aObjects, { 100, 100, .t., .t. } )
aPosObj	:= MsObjSize(aInfo,aObjects)

//-------------------------------------------------------------------
// Abertura da tabela
//-------------------------------------------------------------------
Connect(,.T.,"01","01",,.T.)
cQuery := "SELECT * FROM "+RetSqlName("SE1")+" "
cQuery += "WHERE D_E_L_E_T_ = '*' "
cQuery += "AND E1_CLIENTE+E1_LOJA = '"+SA1->A1_COD+SA1->A1_LOJA+"'"
cQuery += "AND E1_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' "
cQuery += "AND E1_VENCREA BETWEEN '"+DTOS(MV_PAR03)+"' AND '"+DTOS(MV_PAR04)+"' "

//-------------------------------------------------------------------
// Indica os índices da tabela temporária
//-------------------------------------------------------------------
Aadd( aIndex, "E1_PREFIXO+E1_NUM+E1_PARCELA"  )

//-------------------------------------------------------------------
// Indica as chaves de Pesquisa
//-------------------------------------------------------------------
Aadd(aSeek,{AllTrim(GetSx3Cache("E1_PREFIXO","X3_TITULO"))+"+"+AllTrim(GetSx3Cache("E1_NUM","X3_TITULO"))+"+"+AllTrim(GetSx3Cache("E1_PARCELA","X3_TITULO")),{{"","C",TamSX3("E1_PREFIXO")[1]+TamSX3("E1_NUM")[1]+TamSX3("E1_PARCELA")[1],0,AllTrim(GetSx3Cache("E1_PREFIXO","X3_TITULO"))+"+"+AllTrim(GetSx3Cache("E1_NUM","X3_TITULO"))+"+"+AllTrim(GetSx3Cache("E1_PARCELA","X3_TITULO")),,}}})

//-------------------------------------------------------------------
// Define a janela do Browse
//-------------------------------------------------------------------
DEFINE MSDIALOG oDlg TITLE "Títulos Excluídos - Cliente " + SA1->A1_NOME FROM 0,0 TO aSize[6],aSize[5] PIXEL
	//-------------------------------------------------------------------
	// Define o Browse
	//-------------------------------------------------------------------
	DEFINE FWBROWSE oBrowse DATA QUERY ALIAS "TRB" QUERY cQuery DOUBLECLICK {||oDlg:End()} FILTER SEEK ORDER aSeek INDEXQUERY aIndex OF oDlg
		//-------------------------------------------------------------------
		// Adiciona as colunas do Browse
		//-------------------------------------------------------------------

		ADD COLUMN oColumn DATA {|| E1_FILIAL       } TITLE AllTrim(AvSx3("E1_FILIAL",5))  SIZE TamSX3("E1_FILIAL")[1]  OF oBrowse
		ADD COLUMN oColumn DATA {|| E1_PREFIXO      } TITLE AllTrim(AvSx3("E1_PREFIXO",5)) SIZE TamSX3("E1_PREFIXO")[1] OF oBrowse
		ADD COLUMN oColumn DATA {|| E1_NUM          } TITLE AllTrim(AvSx3("E1_NUM",5))     SIZE TamSX3("E1_NUM")[1]     OF oBrowse
		ADD COLUMN oColumn DATA {|| E1_PARCELA      } TITLE AllTrim(AvSx3("E1_PARCELA",5)) SIZE TamSX3("E1_PARCELA")[1] OF oBrowse
		ADD COLUMN oColumn DATA {|| E1_TIPO         } TITLE AllTrim(AvSx3("E1_TIPO",5))    SIZE TamSX3("E1_TIPO")[1]    OF oBrowse
		ADD COLUMN oColumn DATA {|| StoD(E1_VENCTO) } TITLE AllTrim(AvSx3("E1_VENCTO",5))  SIZE TamSX3("E1_VENCTO")[1]  OF oBrowse
		ADD COLUMN oColumn DATA {|| StoD(E1_VENCREA)} TITLE AllTrim(AvSx3("E1_VENCREA",5)) SIZE TamSX3("E1_VENCREA")[1] OF oBrowse
		ADD COLUMN oColumn DATA {|| E1_MOEDA        } TITLE AllTrim(AvSx3("E1_MOEDA",5))   SIZE TamSX3("E1_MOEDA")[1]   OF oBrowse
		ADD COLUMN oColumn DATA {|| Transform(E1_VALOR,PesqPict("SE1","E1_VALOR"))} TITLE AllTrim(AvSx3("E1_VALOR",5))   SIZE TamSX3("E1_VALOR")[1]   OF oBrowse
	//-------------------------------------------------------------------
	// Ativação do Browse
	//-------------------------------------------------------------------
	ACTIVATE FWBROWSE oBrowse

	@ 01,aPosObj[1][4]-320 BUTTON "&Sair" SIZE 34,11 ACTION ( nOpca := 1, oDlg:End() ) OF oDlg PIXEL
//-------------------------------------------------------------------
// Ativação do janela
//-------------------------------------------------------------------
ACTIVATE MSDIALOG oDlg CENTERED

Return
