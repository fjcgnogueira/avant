#INCLUDE "Protheus.CH"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออปฑฑ
ฑฑบPrograma  ณ ImgProd      บ Autor ณ Fernando Nogueira  บ Data ณ 14/02/2017 บฑฑ
ฑฑฬออออออออออุออออออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออนฑฑ
ฑฑบDescricao ณ Importa as imagens dos Produtos via schedule                  บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico Avant                                              บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
User Function ImgProd(aParam,lEnd)

Local aTabelas := {"SB1"}
Local aFiles   := {}
Local aSizes   := {}
Local nX
Local cPath    := "\imagens\produtos\"
Local cProd    := ""
Local cOldFile := ""
Local cNewFile := ""
Local lIncluiu
Local cBitMap  := ""

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณaParam     |  [01]   |  [02]  |
//ณ           | Empresa | Filial |
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
// Caso seja executado pelo schedule
If !Empty(aParam)

	RpcClearEnv()
	RPCSetType(03)
	RpcSetEnv(aParam[1], aParam[2], NIL, NIL, "COM", NIL, aTabelas)
	
	DEFINE WINDOW oMainWnd FROM 001,001 TO 400,500 TITLE "Imagens"
		ACTIVATE WINDOW oMainWnd MAXIMIZED ON INIT oMainWnd:End()
Endif

Private oRep   := TBmpRep():New(0, 0, 0, 0, "", .T., oMainWnd, Nil, Nil, .F., .F.)
Private nRegua

dbSelectArea("SB1")
dbSetOrder(01)
dbGoTop()

ADir(cPath + "N*.*", aFiles, aSizes)

nRegua := Len(aFiles)

If Empty(aParam)
	_x_oProcess:SetRegua1(nRegua)
	_x_oProcess:SetRegua2(nRegua)
Endif

For nX := 1 to nRegua

	cOldFile := aFiles[nX]
	cNewFile := SubStr(aFiles[nX],02,Len(aFiles[nX])-01)
	cProd    := SubStr(cNewFile,01,At(".",cNewFile)-01)
	cBitMap  := PadR(cProd, 20)
	
	If Empty(aParam)
		_x_oProcess:IncRegua1("Importando Arquivo "+StrZero(nX,03)+"/"+StrZero(nRegua,03))
		_x_oProcess:IncRegua2()
	Endif
	
	If SB1->(dbSeek(xFilial("SB1")+cProd))
	
		FRename(cPath+cOldFile,cPath+cNewFile)
	
		If oRep:ExistBmp(cBitMap)
			oRep:DeleteBmp(cBitMap)
		Endif
		
		oRep:OpenRepository()
		oRep:InsertBmp(cPath+cNewFile, cProd, @lIncluiu)
		oRep:CloseRepository()

		If SB1->(RecLock("SB1",.F.))
			SB1->B1_BITMAP := cProd
			SB1->(MsUnlock())
		Endif
		
		ConOut("["+DtoC(Date())+" "+Time()+"] [ImgProd] Imagem Importada, Produto: " + cProd)
	Else
		ConOut("["+DtoC(Date())+" "+Time()+"] [ImgProd] Imagem Nใo Importada, Produto Nใo Existe: " + cProd)
	Endif
	
Next nX

If !Empty(aParam)
	RpcClearEnv()
Endif

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณxImgProd  บAutor  ณ Fernando Nogueira  บ Data ณ 14/02/2017  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFuncao para ser chamada via menu                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function xImgProd()

Local aParam
Local lEnd := .F.

Private _x_oProcess

If MsgNoYes("Deseja fazer a importa็ใo das imagens?")
	_x_oProcess := MsNewProcess():New({|lEnd| U_ImgProd(aParam,lEnd)},"Processando...","Importando Imagens...",.T.)
	_x_oProcess:Activate()
	ApMsgInfo("Processo Finalizado.")
Endif

Return
