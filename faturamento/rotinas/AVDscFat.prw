

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AVDSCFAT  ºAutor  ³Microsiga           º Data ³  01/10/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function AVDescFat()
Local nPerDesc   := 0
Local nPosVlDsc  := aScan(aHeader,{|x| AllTrim(x[2])=="C6_DESCONT"})
Local nPosXDsc1  := aScan(aHeader,{|x| AllTrim(x[2])=="C6_X_DESC1"})
Local nPosXDsc2  := aScan(aHeader,{|x| AllTrim(x[2])=="C6_X_DESC2"})
Local cVar       := ReadVar()

If cVar == "M->C6_X_DESC1"

   __readvar := "M->C6_DESCONT"

   &(__readvar) := M->C6_X_DESC1+(100-M->C6_X_DESC1)*(aCols[n][nPosXDsc2]/100)
   GdFieldPut("C6_DESCONT",&(__readvar))

   DbSelectArea("SX3")
   DbSetOrder(2)
   DbSeek("C6_DESCONT")
   &(SX3->X3_VALID)

   __readvar := cVar

ElseIf cVar == "M->C6_X_DESC2"

   __readvar := "M->C6_DESCONT"

   &(__readvar) := aCols[n][nPosXDsc1]+(100-aCols[n][nPosXDsc1])*(M->C6_X_DESC2/100)
   GdFieldPut("C6_DESCONT",&(__readvar),n)

   DbSelectArea("SX3")
   DbSetOrder(2)
   DbSeek("C6_DESCONT")
   &(SX3->X3_VALID)

   __readvar := cVar

EndIf

Return .T.
