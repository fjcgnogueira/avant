#Include "PROTHEUS.CH"
#Include "Totvs.ch"

/*/
зддддддддддбдддддддддддддбдддддбддддддддддддддддддддддбддддддбдддддддддд©
ЁFun┤┘o    ЁBmpLeg    	 ЁAutorЁMarinaldo de Jesus    Ё Data Ё26/10/2005Ё
цддддддддддедддддддддддддадддддаддддддддддддддддддддддаддддддадддддддддд╢
ЁDescri┤┘o ЁRetorna informacoes de Legenda para a GetDads do SRA        Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁSintaxe   Ё<vide parametros formais>									Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁParametrosЁ<vide parametros formais>									Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁUso       ЁGdBmp()	                                                	Ё
юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
User Function MPBmpLeg( aMksColor , lLegend )

Local aSvKeys
Local aBmpLegend

Local cResourceName

Local nLoop
Local nLoops

Begin Sequence

DEFAULT lLegend := .F.
IF ( lLegend )
	aSvKeys 	:= GetKeys()
EndIF

nLoops		:= Len( aMksColor )
aBmpLegend	:= Array( nLoops , 2 )
For nLoop := 1 To nLoops
	aBmpLegend[ nLoop , 1 ] := aMksColor[ nLoop , 1 ]
	aBmpLegend[ nLoop , 2 ] := aMksColor[ nLoop , 2 ]
Next nLoop

IF ( lLegend )
	BrwLegenda( OemToAnsi( 'Legenda' ) , 'Status' , aBmpLegend )
Else
	cResourceName := GetResource( aBmpLegend )
EndIF

End Sequence

IF ( lLegend )
	RestKeys( aSvKeys , .T. )
EndIF

Return( cResourceName )
