#Include "PROTHEUS.CH"
#Include "FILEIO.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPedNeoGridบ Autor ณ Fernando Nogueira  บ Data ณ 01/07/2014  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณImportar arquivo de Pedidos da NeoGrid                      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico Avant                                           บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function PedNeoGrid()

Local _oProcess  := Nil

_oProcess := MsNewProcess():New({|lEnd| ProcArq(@lEnd,_oProcess)},"Processando...","Processando Arquivos EDI...",.T.)
_oProcess:Activate()

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณPrograma  ณ ProcArq   ณ Autor ณ Fernando Nogueira  ณ Data  ณ 05/08/14 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescricao ณ Processa Arquivos EDI para Importacao                     ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function ProcArq(lEnd,_oProcess)
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis utilizadas na leitura do arquivo EDI        ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local cLog     	 := "<html><body>"  // Log de mensagens
Local cFim       := "</body></html>"
Local nHdl
Local nItem      := 0
Local cBuff	   	 := "" 	// variavel que recebe o conteudo da linha
Local cIdReg   	 := "" 	// IDENTIFICADOR DE REGISTRO
Local cNumPed  	 := "" 	// Numero do Pedido EDI
Local aIdSZJ   	 := {} 	// Array com 2 dimensoes. A primeira deve conter o nome do campo e o segundo o conteudo para o identificar a gravacao da tabela SZJ
Local aIdSZK     := {}   // Array com 2 dimensoes. A primeira deve conter o nome do campo e o segundo o conteudo para o identificar a gravacao da tabela SZK
Local lRetorno	 := .T.
Local lPedDup    := .F.  // Pedido Duplicao - Jah foi importado anteriormente
Local _cArqEdi   := ""
Local aLogs      := 0
Local cAliasSZJ  := GetNextAlias()
Local cPedCli    := ""
Local cItem      := ""
Local aDiretorio := Directory("\Neogrid_Mercantil\Makro\Pedido\PED*.EDI", "D")
Local cArqNoExt  := ""  // Arquivo Edi sem a extensao
Local cDirEdi    := "\Neogrid_Mercantil\Makro\Pedido\"
Local cDirProc   := "\Neogrid_Mercantil\Makro\Pedido\Processados\"+Left(DtoS(Date()),6)+"\"
Local cDirErr    := "\Neogrid_Mercantil\Makro\Pedido\Erro\"+Left(DtoS(Date()),6)+"\"
Local cBOL       := "'<p>'+DtoC(Date())+Space(01)+Time()+Space(01)"
Local cEOL       := "</p>"+CHR(13)+CHR(10)
Local cAssunto   := ""
Local aRetInt    := {}
Local _cQuant	   := ""

nRegua := Len(aDiretorio)
_oProcess:SetRegua1(nRegua)
_oProcess:SetRegua2(3)

_oProcess:IncRegua2("Enviando E-mail")

//Importacao dos Arquivos Edi
For _n := 1 to Len(aDiretorio)

	_cArqEdi := aDiretorio[_n][1]

	_oProcess:IncRegua1("Integrando Pedidos")

	If File(cDirEdi+_cArqEdi)

		nHdl := FOpen(cDirEdi+_cArqEdi, 2)

		If nHdl > -1
			cLog += &cBOL+"Abertura do arquivo "+_cArqEdi+" OK"+cEOL

			cNumPed := U_NumPedEdi()

			Begin Transaction

				nItem := 0

				While lRetorno .And. LeLinha( nHdl, @cBuff ) > 0

					cIdReg   := SubStr(cBuff, 1, 2) // IDENTIFICADOR DE REGISTRO

					Do Case
						Case cIdReg == "01" // CABECALHO DO PEDIDO DO CLIENTE
							/*
							PRE CABECALHO DO PEDIDO AVANT - SZJ
							01. FUNCAO MENSAGEM
							02. TIPO DE PEDIDO
							03. NUMERO DO PEDIDO DO COMPRADOR (CLIENTE)
							04. CNPJ DO COMPRADOR
							05. CNPJ DO LOCAL DE ENTREGA
							06. CONDICAO DE ENTREGA (TIPO DE FRETE)
							07. OBSERVACAO DO PEDIDO
							*/

							// Pedido do Cliente
							cPedCli  := Substr(cBuff, 009, 020)

							// Verifica se o Pedido jah foi importado
							BeginSQL Alias cAliasSZJ
								SELECT * FROM %Table:SZJ% SZJ
								WHERE SZJ.%notDel%
									AND ZJ_FILIAL  = %Exp:xFilial("SZJ")%
									AND ZJ_PEDCLI  = %Exp:cPedCli%
							EndSQL

							(cAliasSZJ)->(dbGoTop())

							If !(cAliasSZJ)->(Eof())
								(cAliasSZJ)->(dbCloseArea())
								lPedDup  := .T.
								lRetorno := .F.
								Exit
							Else

								AADD( aIdSZJ, {'ZJ_FILIAL' , xFilial("SZJ")} )         //FILIAL
								AADD( aIdSZJ, {'ZJ_PEDEDI' , cNumPed} )                 //NUMERO DO PRE PEDIDO
								AADD( aIdSZJ, {'ZJ_FUNCAO' , SubStr(cBuff, 003, 003)} ) //FUNCAO MENSAGEM
								AADD( aIdSZJ, {'ZJ_TIPO'   , SubStr(cBuff, 006, 003)} ) //TIPO DE PEDIDO
								AADD( aIdSZJ, {'ZJ_PEDCLI' , cPedCli                } ) //NUMERO DO PEDIDO DO COMPRADOR (CLIENTE)
								AADD( aIdSZJ, {'ZJ_CNPJCLI', SubStr(cBuff, 181, 014)} ) //CNPJ DO COMPRADOR
								AADD( aIdSZJ, {'ZJ_CNPJENT', SubStr(cBuff, 209, 014)} ) //CNPJ DO LOCAL DE ENTREGA
								AADD( aIdSZJ, {'ZJ_TPFRETE', SubStr(cBuff, 270, 003)} ) //CONDICAO DE ENTREGA (TIPO DE FRETE)
								AADD( aIdSZJ, {'ZJ_OBSERV' , SubStr(cBuff, 276, 040)} ) //OBSERVACAO DO PEDIDO
								AADD( aIdSZJ, {'ZJ_STATUS' , '1'} )                     //STATUS DO PEDIDO
								AADD( aIdSZJ, {'ZJ_PROCES' , 'N'} )                     //INTEGROU O PEDIDO NO SISTEMA

								lRetorno := U_AV_EDIGRV('SZJ', aIdSZJ, cNumPed, 1, xFilial("SZJ")) > 0

								(cAliasSZJ)->(dbCloseArea())
							Endif

						Case cIdReg == "04" // ITENS DO PEDIDO DO CLIENTE
							/*
							PRE ITENS DO PEDIDO AVANT - SZK
							01. NUMERO DO ITEM NO PEDIDO
							02. CODIGO DO PRODUTO NO CLIENTE
							03. DESCRICAO DO PRODUTO NO CLIENTE
							04. QUANTIDADE PEDIDA
							*/

							nItem++
							aIdSZK := {}
							cItem  := StrZero(nItem,2)

							AADD( aIdSZK, {'ZK_FILIAL' , xFilial("SZK")} )                   //FILIAL
							AADD( aIdSZK, {'ZK_PEDEDI' , cNumPed} )                          //NUMERO DO PRE PEDIDO
							AADD( aIdSZK, {'ZK_ITEM'   , cItem} )                            //ITEM DO PRE PEDIDO
							AADD( aIdSZK, {'ZK_ITEMCLI', SubStr(cBuff, 007, 005)} )          //ITEM DO PEDIDO DO CLIENTE
							AADD( aIdSZK, {'ZK_PRODCLI', SubStr(cBuff, 018, 014)} )          //CODIGO DO PRODUTO NO CLIENTE
							AADD( aIdSZK, {'ZK_DESCCLI', Substr(cBuff, 032, 040)} )          //DESCRICAO DO PRODUTO NO CLIENTE
							_cQuant := Val(SubStr(cBuff, 100, 015))
							_cQuant := _cQuant/100
							AADD( aIdSZK, {'ZK_QUANT'  , _cQuant} ) //QUANTIDADE PEDIDA

							lRetorno := U_AV_EDIGRV('SZK', aIdSZK, cNumPed+cItem, 1, xFilial("SZK")) > 0

					EndCase

				EndDo

				fClose( nHdl ) // Fechando arquivo texto aos geracao.

			End Transaction

			If lRetorno
				SZJ->(dbSelectArea("SZJ"))
				SZJ->(dbGoTop())
				SZJ->(dbSeek(xFilial("SZJ")+cNumPed))

				// Gravando a Hora e a Data que importou no sistema
				SZJ->(RecLock('SZJ', .F.))
				SZJ->ZJ_HRPROC := Time()
				SZJ->ZJ_DTPROC := Date()
				SZJ->(MsUnlock())

				cLog += &cBOL+'Pedido Cliente '+AllTrim(cPedCli)+' importado com sucesso.'+cEOL

				// Integra o Pedido de Vendas
				cLog += U_IntPedEdi(cNumPed)

				// Tratamento do arquivo apos Processamento
				cArqNoExt := Left(_cArqEdi, At(".", _cArqEdi)-1)

				If !ExistDir(cDirProc)
					MakeDir(cDirProc)
				Endif

				fRename(cDirEdi+_cArqEdi, cDirProc+cArqNoExt+".PRC")
			Else
				RollBackSx8()
				If lPedDup
					cLog += &cBOL+"Pedido EDI "+AllTrim(cPedCli)+" importado anteriormente"+cEOL
				Else
					cLog += &cBOL+"Erro na Integra็ใo do Pedido EDI "+AllTrim(cPedCli)+cEOL
				Endif

				// Tratamento do arquivo em caso de erro
				cArqNoExt := Left(_cArqEdi, At(".", _cArqEdi)-1)

				If !ExistDir(cDirErr)
					MakeDir(cDirErr)
				Endif

				fRename(cDirEdi+_cArqEdi, cDirErr+cArqNoExt+".PRC")
			Endif

		Else
			cLog += &cBOL+"Abertura do arquivo "+_cArqEdi+" com Erro"+cEOL
			lRetorno := .F.
		EndIf
	Else
		cLog += &cBOL+'Erro na abertura do arquivo EDI '+_cArqEdi+cEOL
	EndIf

Next _n

// Envia e-mail com as mensagens de Log
If cLog == "<html><body>"
	cLog += &cBOL+'Nada a Importar'+cEOL
Endif

cLog += cFim
cAssunto := DtoC(Date())+Space(01)+Time()+Space(01)+"Log da Importacao EDI ["+AllTrim(SM0->M0_CODFIL)+" / "+AllTrim(SM0->M0_FILIAL)+"]"
_oProcess:IncRegua2("Enviando E-mail")
U_MHDEnvMail("fernando.nogueira@avantlux.com.br; rogerio.machado@avantlux.com.br; ewerson.silva@avantlux.com.br, cristiane.alves@avantlux.com.br ", "", "", cAssunto, cLog, "")
_oProcess:IncRegua2("Enviando E-mail")

Return lRetorno

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ LeLinha  บ Autor ณ Fernando Nogueira  บ Data ณ  01/08/2014 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao auxiliar                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico Avant                                           บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function LeLinha( nHdl, cRet )
Local cBuff := " "
cRet  := ""

While FRead( nHdl, @cBuff, 1 ) > 0 .and. cBuff <> Chr(13)
	cRet += cBuff
End

// O chr(13) ja foi ignorado. agora ignora o Chr(10)
FRead( nHdl, @cBuff, 1 )

Return len(cRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออปฑฑ
ฑฑบPrograma  ณ NumPedEdi บ Autor ณ Fernando Nogueira  บ Data ณ 03/07/2014 บฑฑ
ฑฑฬออออออออออุอออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออนฑฑ
ฑฑบDesc.     ณ Recupera o proximo numero do Pre Pedido                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico Avant                                           บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function NumPedEdi()
	Local cNumPed := GetSX8Num("SZJ", "ZJ_PEDEDI")

	DbSelectArea("SZJ")
	DbSetOrder(1)

	While SZJ->(DbSeek(xFilial("SZJ") + cNumPed))
		ConfirmSx8()
		cNumPed := GetSx8Num("SZJ", "ZJ_PEDEDI")
	Enddo

Return cNumPed
