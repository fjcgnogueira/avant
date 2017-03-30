#Include "rwmake.ch"
#Include "Protheus.Ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MT120TEL()  º Autor ³ Rogerio Machado    º Data ³02/08/2016 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Ponto de Entrada Disnibiliza o Objeto da Dialog e cordenadasº±±
±±ÈÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MT120TEL()
/*
Local aPosGet	 := {}
Local aPosObj	 := {}
Local aObj	      // Array com os objetos utilizados no Folder
Local aObj2[2]	 // Array 2 com objetos utilizados no Folder
Local aObjects	 := {}
Local aInfo 	 := {}
Local aSizeAut   := MsAdvSize(,.F.,400)
Local oDlg
Local l120Visual := .F.
Local lMt120Ped  := .F.
Local l120Inclui := .F.

Public __av_cStsLi := If(l120Inclui.And. !lCopia,CriaVar("C7_XSTALI") ,SC7->C7_XSTALI)
Public __av_cShip  := If(l120Inclui.And. !lCopia,CriaVar("C7_XSHIPME"),SC7->C7_XSHIPME)
Public __av_cImpo  := If(l120Inclui.And. !lCopia,CriaVar("C7_XIMPSTA"),SC7->C7_XIMPSTA)

	AAdd( aObjects, { 0,    65, .T., .F. } )				
	AAdd( aObjects, { 100, 100, .T., .T. } )
	AAdd( aObjects, { 0,    75, .T., .F. } )
	aInfo := { aSizeAut[ 1 ], aSizeAut[ 2 ], aSizeAut[ 3 ], aSizeAut[ 4 ], 3, 3 }
	aPosObj := MsObjSize( aInfo, aObjects )
	aPosGet := MsObjGetPos(aSizeAut[3]-aSizeAut[1],305,;
		{{10,40,105,140,200,234,275,200,225,260,285,265},;
		If(cPaisLoc<>"PTG",{10,40,105,140,200,234,63},{10,40,101,120,175,205,63,250,270}),;
		Iif(cPaisLoc<>"PTG",{5,70,160,205,295},{5,50,120,145,205,245,293}),;
		{6,34,200,215},;
		{6,34,80,113,160,185},;
		{6,34,245,268,260},;
		{10,50,150,190},;
		{273,130,190},;
		{8,45,80,103,139,173,200,235,270},;
		{133,190,144,190,289,293},;
		{142,293,140},;
		{9,47,188,148,9,146} } )


	@ aPosObj[1][1]+29,aPosGet[1,1]+395 SAY   "LI Status" OF oDlg PIXEL SIZE 023,006  //Status Li
	@ aPosObj[1][1]+29,aposget[1,1]+454 MSGET __av_cStsLi OF oDlg ;
	PICTURE PesqPict("SC7","C7_XSTALI",30) F3 CpoRetF3('C7_XSTALI');
	WHEN    !l120Visual .And. VisualSX3('C7_XSTALI') .And. !lMt120Ped PIXEL SIZE 080,006 HASBUTTON
	
	@ aPosObj[1][1]+41,aPosGet[1,1] SAY   "Shipment Status" OF oDlg PIXEL SIZE 023,006  //Shipment Status
	@ aPosObj[1][1]+41,aposget[1,1]+064 MSGET __av_cShip OF oDlg ;
	PICTURE PesqPict("SC7","C7_XSHIPME",3) F3 CpoRetF3('C7_XSHIPME');
	WHEN    !l120Visual .And. VisualSX3('C7_XSHIPME') .And. !lMt120Ped PIXEL SIZE 080,006 HASBUTTON
	
	@ aPosObj[1][1]+41,aPosGet[1,1]+203 SAY   "Import License" OF oDlg PIXEL SIZE 023,006  //Import License
	@ aPosObj[1][1]+41,aposget[1,1]+278 MSGET __av_cImpo OF oDlg ;
	PICTURE PesqPict("SC7","C7_XIMPSTA",3) F3 CpoRetF3('C7_XIMPSTA');
	WHEN    !l120Visual .And. VisualSX3('C7_XIMPSTA') .And. !lMt120Ped PIXEL SIZE 080,006 HASBUTTON 

*/		

Return


