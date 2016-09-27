#Include "Totvs.ch"
#Include "FwMvcDef.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ PedWebAut º Autor ³ Fernando Nogueira  º Data ³ 23/09/2016 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ ExecAuto para Pedido Web                                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Avant                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function PedWebAut()
Local   aSay     := {}
Local   aButton  := {}
Local   nOpc     := 0
Local   Titulo   := 'Inclusao de Pedido Web Automatico'
Local   cDesc1   := 'Esta rotina fara a inclusao de Pedido Web'
Local   cDesc2   := ''
Local   cDesc3   := ''
Local   lOk      := .T.

aAdd(aSay, cDesc1)
aAdd(aSay, cDesc2)
aAdd(aSay, cDesc3)

aAdd(aButton, {1, .T., {|| nOpc := 1, FechaBatch()}})
aAdd(aButton, {2, .T., {|| FechaBatch()           }})

FormBatch(Titulo, aSay, aButton)

If nOpc == 1

	Processa({|| lOk := Runproc()},'Aguarde','Processando...',.F.)

	If lOk
		ApMsgInfo('Processamento terminado com sucesso.', 'ATENÇÃO')

	Else
		ApMsgStop('Processamento realizado com problemas.', 'ATENÇÃO')

	EndIf

EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ Runproc  º Autor ³ Fernando Nogueira  º Data ³ 23/09/2016  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Processamento da Inclusao                                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Avant                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Runproc()
Local lRet     := .T.
Local aCposCab := {}
Local aCposDet := {}
Local aAux     := {}

aCposCab := {}
aCposDet := {}

aAdd(aCposCab, {'Z3_CNPJ'   , '23743770000120'})
aAdd(aCposCab, {'Z3_CODTSAC', '51'            })

aAux := {}
aAdd(aAux, {'Z4_ITEMPED', '01'       })
aAdd(aAux, {'Z4_CODPROD', '135051363'})
aAdd(aAux, {'Z4_QTDE'   , 25         })
aAdd(aAux, {'Z4_PRVEN'  , 25         })
aAdd(aAux, {'Z4_VLRTTIT', 25         })
aAdd( aCposDet, aAux )

aAux := {}
aAdd(aAux, {'Z4_ITEMPED', '02'       })
aAdd(aAux, {'Z4_CODPROD', '901405159'})
aAdd(aAux, {'Z4_QTDE'   , 30         })
aAdd(aAux, {'Z4_PRVEN'  , 30         })
aAdd(aAux, {'Z4_VLRTTIT', 30         })
aAdd( aCposDet, aAux )

If !Import('SZ3', 'SZ4', aCposCab, aCposDet)
	lRet := .F.
EndIf

aCposCab := {}
aCposDet := {}

aAdd(aCposCab, {'Z3_CNPJ'   , '10469209000152'})
aAdd(aCposCab, {'Z3_CODTSAC', '51'            })

aAux := {}
aAdd(aAux, {'Z4_ITEMPED', '01'       })
aAdd(aAux, {'Z4_CODPROD', '135051363'})
aAdd(aAux, {'Z4_QTDE'   , 35         })
aAdd(aAux, {'Z4_PRVEN'  , 25         })
aAdd(aAux, {'Z4_VLRTTIT', 15         })
aAdd( aCposDet, aAux )

aAux := {}
aAdd(aAux, {'Z4_ITEMPED', '02'       })
aAdd(aAux, {'Z4_CODPROD', '901405159'})
aAdd(aAux, {'Z4_QTDE'   , 10         })
aAdd(aAux, {'Z4_PRVEN'  , 20         })
aAdd(aAux, {'Z4_VLRTTIT', 30         })
aAdd( aCposDet, aAux )

If !Import('SZ3', 'SZ4', aCposCab, aCposDet)
	lRet := .F.
EndIf

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ Import   º Autor ³ Fernando Nogueira  º Data ³ 23/09/2016  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Processamento da Importacao dos Dados                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Avant                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Import(cMaster, cDetail, aCpoMaster, aCpoDetail)

Local oModel, oAux, oStruct
Local nI      := 0
Local nJ      := 0
Local nPos    := 0
Local lRet    := .T.
Local aAux    := {}
Local aC      := {}
Local aH      := {}
Local nItErro := 0
Local lAux    := .T.

dbSelectArea(cMaster)
dbSetOrder(01)

//Instacia o Modelo de onde iremos importar as informacoes
oModel := FWLoadModel('PedidoWeb')

// Temos que definir qual a operacao deseja: 3 Inclusao / 4 Alteracao / 5 - Exclusao
oModel:SetOperation(3)

// Antes de atribuirmos os valores dos campos temos que ativar o modelo
oModel:Activate()

// Instanciamos apenas a parte do modelo referente aos dados de cabecalho
oAux := oModel:GetModel('ID_MODEL_FLD_PedidoWeb')

// Obtemos a estrutura de dados do cabecalho
oStruct := oAux:GetStruct()
aAux	:= oStruct:GetFields()

If lRet
	For nI := 1 To Len(aCpoMaster)
		// Verifica se os campos passados existem na estrutura do cabecalho
		If (nPos := aScan(aAux, {|x| AllTrim(x[3]) ==  AllTrim(aCpoMaster[nI][1])})) > 0

			// Eh feita a atribuicao do dado aos campo do Model do cabecalho
			If !( lAux := oModel:SetValue('ID_MODEL_FLD_PedidoWeb', aCpoMaster[nI][1], aCpoMaster[nI][2]))
				// Caso a atribuicao não possa ser feita, por algum motivo (validacao, por exemplo)
				// o metodo SetValue retorna .F.
				lRet    := .F.
				Exit
			EndIf
		EndIf
	Next
EndIf

If lRet
	// Intanciamos apenas a parte do modelo referente aos dados do item
	oAux     := oModel:GetModel('ID_MODEL_GRD_PedidoWeb')

	// Obtemos a estrutura de dados do item
	oStruct  := oAux:GetStruct()
	aAux	 := oStruct:GetFields()

	nItErro  := 0

	For nI := 1 To Len( aCpoDetail )
		// Incluimos uma linha nova
		// ATENCAO: O itens sao criados em uma estrura de grid (FORMGRID), portanto ja 
		// eh criada uma primeira linha
		// branco automaticamente, desta forma começamos a inserir novas linhas a 
		// partir da 2a vez

		If nI > 1

			// Incluimos uma nova linha de item

			If  ( nItErro := oAux:AddLine() ) <> nI

				// Se por algum motivo o metodo AddLine() nao consegue incluir a linha,
				// ele retorna a quantidade de linhas ja
				// existem no grid. Se conseguir retorna a quantidade mais 1
				lRet    := .F.
				Exit

			EndIf

		EndIf

		For nJ := 1 To Len( aCpoDetail[nI] )

		// Verifica se os campos passados existem na estrutura de item
			If (nPos := aScan(aAux, {|x| AllTrim(x[3]) == AllTrim(aCpoDetail[nI][nJ][1])})) > 0

				If !(lAux := oModel:SetValue('ID_MODEL_GRD_PedidoWeb', aCpoDetail[nI][nJ][1], aCpoDetail[nI][nJ][2]))

					// Caso a atribuição nao possa ser feita, por algum motivo (validacao, por exemplo)
					// o metodo SetValue retorna .F.
					lRet    := .F.
					nItErro := nI
					Exit

				EndIf
			EndIf
		Next

		If !lRet
			Exit
		EndIf

	Next

EndIf

If lRet
	// Faz-se a validacao dos dados, note que diferentemente das tradicionais "rotinas automaticas"
	// neste momento os dados nao sao gravados, sao somente validados.
	If (lRet := oModel:VldData())
		// Se o dados foram validados faz-se a gravacao efetiva dos dados (commit)
		oModel:CommitData()
	EndIf
EndIf

If !lRet
	// Se os dados nao foram validados obtemos a descrição do erro para gerar LOG ou mensagem de aviso
	aErro   := oModel:GetErrorMessage()
	// A estrutura do vetor com erro é:
	//  [1] Id do formulario de origem
	//  [2] Id do campo de origem
	//  [3] Id do formulario de erro
	//  [4] Id do campo de erro
	//  [5] Id do erro
	//  [6] mensagem do erro
	//  [7] mensagem da solucao
	//  [8] Valor atribuido
	//  [9] Valor anterior

	AutoGrLog("Id do formulário de origem:" + ' [' + AllToChar(aErro[1]) + ']')
	AutoGrLog("Id do campo de origem:     " + ' [' + AllToChar(aErro[2]) + ']')
	AutoGrLog("Id do formulário de erro:  " + ' [' + AllToChar(aErro[3]) + ']')
	AutoGrLog("Id do campo de erro:       " + ' [' + AllToChar(aErro[4]) + ']')
	AutoGrLog("Id do erro:                " + ' [' + AllToChar(aErro[5]) + ']')
	AutoGrLog("Mensagem do erro:          " + ' [' + AllToChar(aErro[6]) + ']')
	AutoGrLog("Mensagem da solução:       " + ' [' + AllToChar(aErro[7]) + ']')
	AutoGrLog("Valor atribuido:           " + ' [' + AllToChar(aErro[8]) + ']')
	AutoGrLog("Valor anterior:            " + ' [' + AllToChar(aErro[9]) + ']')

	If nItErro > 0
		AutoGrLog("Erro no Item:" + ' [' + AllTrim( AllToChar( nItErro  ) ) + ']')
	EndIf

	MostraErro()

EndIf

// Desativamos o Model
oModel:DeActivate()

Return lRet