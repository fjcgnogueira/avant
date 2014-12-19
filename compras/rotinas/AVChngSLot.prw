#include "Protheus.ch"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AVCHNGSLOTºAutor  ³Microsiga           º Data ³  12/09/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Modifica o lote do fornecedor.                             º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function AVChngSLot
Local oPanel     := Nil, oGDSD1     := Nil, aHSD1      := {}, aCSD1      := {}, nUSD1      := 0
Local nOpcA      := 0
Local cChave     := "SD1->D1_DOC == '" + SF1->F1_DOC + "' .AND. SD1->D1_SERIE == '" + SF1->F1_SERIE + "' .AND. SD1->D1_FORNECE == '" + SF1->F1_FORNECE + "' .AND. SD1->D1_LOJA == '" + SF1->F1_LOJA + "' "
Local cListaCpo  := "D1_ITEM   /D1_COD    /D1_LOCAL  /D1_QUANT  /D1_UM     /D1_VUNIT  /D1_TOTAL  /D1_LOTEFOR/D1_DTVALID"
Local nGDOpc     := GD_UPDATE
Local i, nLen

Private nPosCod := 0
Private oResp   := Nil
Private cResp   := Space(20)

Private nPosLoteF  := 0
Private nPosDtVld  := 0
Private nPosItem   := 0
Private nPosCod    := 0

If SF1->F1_STATUS == 'A' .AND. SF1->F1_TIPO$'NB'

   // BDados(cAlias, aHDados, aCDados, nUDados, nOrd, lFilial, cCond, lStatus, cCpoLeg, cLstCpo, cElimina, cCpoNao, cStaReg, cCpoMar, cMarDef, lLstCpo, aLeg, lEliSql, lOrderBy, cCposGrpBy, cGroupBy, aCposIni, aJoin, aCposCalc, cOrderBy, aCposVis, aCposAlt, cCpoFilial)
   U_BDados("SD1",@aHSD1,@aCSD1,@nUSD1,1,,cChave,,,cListaCpo,,,,,,.T.)
   nPosLoteF  := aScan( aHSD1, { |aMat| aMat[2] == 'D1_LOTEFOR'} )
   nPosDtVld  := aScan( aHSD1, { |aMat| aMat[2] == 'D1_DTVALID'} )
   nPosItem   := aScan( aHSD1, { |aMat| aMat[2] == 'D1_ITEM   '} )
   nPosCod    := aScan( aHSD1, { |aMat| aMat[2] == 'D1_COD    '} )
   
   DbSelectArea("SD1")
   DbSetOrder(1) // D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_COD+D1_ITEM
   nLen := Len(aCSD1)
   For i := 1 To nLen
      DbSeek(xFilial("SD1")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA+aCSD1[i][nPosCod]+aCSD1[i][nPosItem])   
      If !ENDEREC()
         aDel(aCSD1, i)
         aSize(aCSD1, Len(aCSD1)-1)
      EndIf   
   Next


   nPosCod    := aScan(aHSD1, {| aVet | aVet[2] == "D1_COD    "})
   nLen := Len(aHSD1)
   For i := 1 To nLen
      If aHSD1[i][2] == "D1_LOTEFOR" 
         aHSD1[i][14] := "A"
      ElseIf aHSD1[i][2] == "D1_DTVALID"
         aHSD1[i][6] := "U_VldD1DTV()"
         aHSD1[i][14] := "A"
      Else
         aHSD1[i][14] := "V"
      EndIf
   Next

   nLen := Len(aCSD1)
   For i := 1 To nLen
      If !TemRastro(aCSD1[i][nPosCod])
         aDel(aCSD1, i)
         aSize(aCSD1, Len(aCSD1)-1)
      EndIf
   Next
 
   If Len(aCSD1) = 0
      Alert("Não existe produtos com rastro nessa nota fiscal ou todos os produtos já foram endereçados.", "NOREGS")
      Return Nil
   EndIf
 
   aSize := MsAdvSize(.T.)
   aObjects := {}
   AAdd( aObjects, { 100, 100, .T., .T. })
 	
   aInfo  := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 0, 0 }
   aPObjs := MsObjSize(aInfo, aObjects, .T.)
	

   DEFINE MSDIALOG oDlg TITLE "Atualiza Lote Fornecedor" From aSize[7],0 TO aSize[6], aSize[5]	Of oMainWnd PIXEL
  
//      oPanel := tPanel():New(aPObjs[1 ,1], aPObjs[1, 2],, oDlg,,,,,, aPObjs[1, 3], aPObjs[1, 4])
//      oPanel:Align := CONTROL_ALIGN_ALLCLIENT
   
      oGDSD1 := MsNewGetDados():New(aPObjs[1, 1], aPObjs[1, 2], aPObjs[1, 3], aPObjs[1, 4], nGDOpc,,,,,,99999,,,, oDlg, aHSD1, aCSD1)
      oGDSD1:oBrowse:Align:= CONTROL_ALIGN_BOTTOM
  
   ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar (oDlg, {|| nOpcA := 1, oDlg:End()}, {|| nOpcA :=0, oDlg:End()})
 
   If nOpcA == 1
      AtuLotFor(oGDSD1:aHeader, oGDSD1:aCols)
   EndIf
 
Else
   Alert("Somente podem ser atualizadas notas fiscais Normais e de Beneficiamento já classificadas.", "NF não pemitida")
EndIf

Return Nil

Static Function AtuLotFor(aHeader, aCols)
Local i          := 0
Local nLen       := Len(aCols)


   For i := 1 To nLen
      If !Empty(aCols[i][nPosLoteF])
         DbSelectArea("SD1")
         DbSetOrder(1) // D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_COD+D1_ITEM
         DbSeek(xFilial("SD1")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA+aCols[i][nPosCod]+aCols[i][nPosItem])
         RecLock("SD1", .F.)
            SD1->D1_LOTEFOR := aCols[i][nPosLoteF]
            SD1->D1_DTVALID := aCols[i][nPosDtVld]
         MsUnlock()
            
         DbSelectArea("SD5")
         DbSetOrder(2) // D5_FILIAL+D5_PRODUTO+D5_LOCAL+D5_LOTECTL+D5_NUMLOTE+D5_NUMSEQ
         If DbSeek(xFilial("SD5")+SD1->D1_COD+SD1->D1_LOCAL+SD1->D1_LOTECTL)
            RecLock("SD5", .F.)
               SD5->D5_LOTEFOR := aCols[i][nPosLoteF]
               SD5->D5_DTVALID := aCols[i][nPosDtVld]
            MsUnlock()
      
            DbSelectArea("SB8")
            DbSetOrder(3) // B8_FILIAL+B8_PRODUTO+B8_LOCAL+B8_LOTECTL+B8_NUMLOTE+DTOS(B8_DTVALID)
            If DbSeek(xFilial("SB8")+SD1->D1_COD+SD1->D1_LOCAL+SD1->D1_LOTECTL)
               RecLock("SB8", .F.)
                  SB8->B8_LOTEFOR := aCols[i][nPosLoteF]
                  SB8->B8_DTVALID := aCols[i][nPosDtVld]
               MsUnlock()
            EndIf
         EndIf
      EndIf
   Next
   
Return Nil   

Static Function TemRastro( cProduto )
Local aArea      := GetArea()
Local lRet       := GetMV("MV_RASTRO") == "S"

   If lRet
      DbSelectArea("SB1")
      DbSetOrder(1) // B1_FILIAL+B1_COD
      DbSeek(xFilial("SB1")+cProduto)
      lRet := !Empty(SB1->B1_RASTRO) .AND. SB1->B1_RASTRO <> 'N'
   EndIf  	

RestArea(aArea)
Return lRet

User Function VldD1DTV()
Local lRet := .T.

If M->D1_DTVALID < SF1->F1_EMISSAO
   Alert("A data de validade deve ser maior que a data de emissão.", "DTINV")
   lRet := .F.
EndIf

Return lRet

Static Function ENDEREC()
Local aArea := GetArea()
Local lRet := .T.

DbSelectArea("SDA")
DbSetOrder(1) // DA_FILIAL+DA_PRODUTO+DA_LOCAL+DA_NUMSEQ+DA_DOC+DA_SERIE+DA_CLIFOR+DA_LOJA
If SDA->(DbSeek(xFilial("SDA")+SD1->D1_COD+SD1->D1_LOCAL+SD1->D1_NUMSEQ+SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA))
   If SDA->DA_SALDO == 0
      lRet := .F.
   EndIf
ENdIf
RestArea(aArea)
Return lRet
