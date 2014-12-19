#INCLUDE "PROTHEUS.CH"

#DEFINE SIMPLES Char( 39 )
#DEFINE DUPLAS  Char( 34 )

//--------------------------------------------------------------------
/*{Protheus.doc} AVFATU01
Função de update de dicionários para compatibilização

@author TOTVS Protheus
@since  29/04/2014
@obs    Gerado por EXPORDIC - V.4.19.9.2 EFS / Upd. V.4.17.9 EFS
         Tabelas, Campos, Índices e Gatilhos --> Tabelas: SZW, SZY, SZZ 
         Consulta Padrão --> SB1002 (SB1) e SZZ
         Contempla as atualizações para:
          - Cadastro de Regional
          - Calendário do Planejamento de Compras
          - Previsão/Orçamento de Vendas
@version 1.0


@author Kley@TOTVS
@since  21/05/2014
@obs    Inclusão dos campos ZZ_GERENC e ZZ_GEREND e o respectivo Gatilho, para relacionamento do Gerente Regional ao Cadastro da Regional 
@version 2.0
*/
//--------------------------------------------------------------------
User Function AVFATU01( cEmpAmb, cFilAmb )

Local   aSay      := {}
Local   aButton   := {}
Local   aMarcadas := {}
Local   cTitulo   := "ATUALIZAÇÃO DE DICIONÁRIOS E TABELAS"
Local   cDesc1    := "Esta rotina tem como função fazer  a atualização  dos dicionários do Sistema ( SX?/SIX )"
Local   cDesc2    := "Este processo deve ser executado em modo EXCLUSIVO, ou seja não podem haver outros"
Local   cDesc3    := "usuários  ou  jobs utilizando  o sistema.  É EXTREMAMENTE recomendavél  que  se  faça um"
Local   cDesc4    := "BACKUP  dos DICIONÁRIOS  e da  BASE DE DADOS antes desta atualização, para que caso "
Local   cDesc5    := "ocorram eventuais falhas, esse backup possa ser restaurado."
Local   cDesc6    := ""
Local   cDesc7    := ""
Local   lOk       := .F.
Local   lAuto     := ( cEmpAmb <> NIL .or. cFilAmb <> NIL )

Private oMainWnd  := NIL
Private oProcess  := NIL

#IFDEF TOP
    TCInternal( 5, "*OFF" ) // Desliga Refresh no Lock do Top
#ENDIF

__cInterNet := NIL
__lPYME     := .F.

Set Dele On

// Mensagens de Tela Inicial
aAdd( aSay, cDesc1 )
aAdd( aSay, cDesc2 )
aAdd( aSay, cDesc3 )
aAdd( aSay, cDesc4 )
aAdd( aSay, cDesc5 )
//aAdd( aSay, cDesc6 )
//aAdd( aSay, cDesc7 )

// Botoes Tela Inicial
aAdd(  aButton, {  1, .T., { || lOk := .T., FechaBatch() } } )
aAdd(  aButton, {  2, .T., { || lOk := .F., FechaBatch() } } )

If lAuto
	lOk := .T.
Else
	FormBatch(  cTitulo,  aSay,  aButton )
EndIf

If lOk
	If lAuto
		aMarcadas :={{ cEmpAmb, cFilAmb, "" }}
	Else
		aMarcadas := EscEmpresa()
	EndIf

	If !Empty( aMarcadas )
		If lAuto .OR. MsgNoYes( "Confirma a atualização dos dicionários ?", cTitulo )
			oProcess := MsNewProcess():New( { | lEnd | lOk := FSTProc( @lEnd, aMarcadas ) }, "Atualizando", "Aguarde, atualizando ...", .F. )
			oProcess:Activate()

			If lAuto
				If lOk
					MsgStop( "Atualização Realizada.", "AVFATU01" )
				Else
					MsgStop( "Atualização não Realizada.", "AVFATU01" )
				EndIf
				dbCloseAll()
			Else
				If lOk
					Final( "Atualização Concluída." )
				Else
					Final( "Atualização não Realizada." )
				EndIf
			EndIf

		Else
			MsgStop( "Atualização não Realizada.", "AVFATU01" )

		EndIf

	Else
		MsgStop( "Atualização não Realizada.", "AVFATU01" )

	EndIf

EndIf

Return NIL


//--------------------------------------------------------------------
/*{Protheus.doc} FSTProc
Função de processamento da gravação dos arquivos

@author TOTVS Protheus
@since  29/04/2014
@obs    Gerado por EXPORDIC - V.4.19.9.2 EFS / Upd. V.4.17.9 EFS
@version 1.0
*/
//--------------------------------------------------------------------
Static Function FSTProc( lEnd, aMarcadas )
Local   aInfo     := {}
Local   aRecnoSM0 := {}
Local   cAux      := ""
Local   cFile     := ""
Local   cFileLog  := ""
Local   cMask     := "Arquivos Texto" + "(*.TXT)|*.txt|"
Local   cTCBuild  := "TCGetBuild"
Local   cTexto    := ""
Local   cTopBuild := ""
Local   lOpen     := .F.
Local   lRet      := .T.
Local   nI        := 0
Local   nPos      := 0
Local   nRecno    := 0
Local   nX        := 0
Local   oDlg      := NIL
Local   oFont     := NIL
Local   oMemo     := NIL

Private aArqUpd   := {}

If ( lOpen := MyOpenSm0(.T.) )

	dbSelectArea( "SM0" )
	dbGoTop()

	While !SM0->( EOF() )
		// Só adiciona no aRecnoSM0 se a empresa for diferente
		If aScan( aRecnoSM0, { |x| x[2] == SM0->M0_CODIGO } ) == 0 ;
		   .AND. aScan( aMarcadas, { |x| x[1] == SM0->M0_CODIGO } ) > 0
			aAdd( aRecnoSM0, { Recno(), SM0->M0_CODIGO } )
		EndIf
		SM0->( dbSkip() )
	End

	SM0->( dbCloseArea() )

	If lOpen

		For nI := 1 To Len( aRecnoSM0 )

			If !( lOpen := MyOpenSm0(.F.) )
				MsgStop( "Atualização da empresa " + aRecnoSM0[nI][2] + " não efetuada." )
				Exit
			EndIf

			SM0->( dbGoTo( aRecnoSM0[nI][1] ) )

			RpcSetType( 3 )
			RpcSetEnv( SM0->M0_CODIGO, SM0->M0_CODFIL )

			lMsFinalAuto := .F.
			lMsHelpAuto  := .F.

			cTexto += Replicate( "-", 128 ) + CRLF
			cTexto += "Empresa : " + SM0->M0_CODIGO + "/" + SM0->M0_NOME + CRLF + CRLF

			oProcess:SetRegua1( 8 )

			//------------------------------------
			// Atualiza o dicionário SX2
			//------------------------------------
			oProcess:IncRegua1( "Dicionário de arquivos" + " - " + SM0->M0_CODIGO + " " + SM0->M0_NOME + " ..." )
			FSAtuSX2( @cTexto )

			//------------------------------------
			// Atualiza o dicionário SX3
			//------------------------------------
			FSAtuSX3( @cTexto )

			//------------------------------------
			// Atualiza o dicionário SIX
			//------------------------------------
			oProcess:IncRegua1( "Dicionário de índices" + " - " + SM0->M0_CODIGO + " " + SM0->M0_NOME + " ..." )
			FSAtuSIX( @cTexto )

			oProcess:IncRegua1( "Dicionário de dados" + " - " + SM0->M0_CODIGO + " " + SM0->M0_NOME + " ..." )
			oProcess:IncRegua2( "Atualizando campos/índices" )

			// Alteração física dos arquivos
			__SetX31Mode( .F. )

			If FindFunction(cTCBuild)
				cTopBuild := &cTCBuild.()
			EndIf

			For nX := 1 To Len( aArqUpd )

				If cTopBuild >= "20090811" .AND. TcInternal( 89 ) == "CLOB_SUPPORTED"
					If ( ( aArqUpd[nX] >= "NQ " .AND. aArqUpd[nX] <= "NZZ" ) .OR. ( aArqUpd[nX] >= "O0 " .AND. aArqUpd[nX] <= "NZZ" ) ) .AND.;
						!aArqUpd[nX] $ "NQD,NQF,NQP,NQT"
						TcInternal( 25, "CLOB" )
					EndIf
				EndIf

				If Select( aArqUpd[nX] ) > 0
					dbSelectArea( aArqUpd[nX] )
					dbCloseArea()
				EndIf

				X31UpdTable( aArqUpd[nX] )

				If __GetX31Error()
					Alert( __GetX31Trace() )
					MsgStop( "Ocorreu um erro desconhecido durante a atualização da tabela : " + aArqUpd[nX] + ". Verifique a integridade do dicionário e da tabela.", "ATENÇÃO" )
					cTexto += "Ocorreu um erro desconhecido durante a atualização da estrutura da tabela : " + aArqUpd[nX] + CRLF
				EndIf

				If cTopBuild >= "20090811" .AND. TcInternal( 89 ) == "CLOB_SUPPORTED"
					TcInternal( 25, "OFF" )
				EndIf

			Next nX

			//------------------------------------
			// Atualiza o dicionário SX7
			//------------------------------------
			oProcess:IncRegua1( "Dicionário de gatilhos" + " - " + SM0->M0_CODIGO + " " + SM0->M0_NOME + " ..." )
			FSAtuSX7( @cTexto )

			//------------------------------------
			// Atualiza o dicionário SXB
			//------------------------------------
			oProcess:IncRegua1( "Dicionário de consultas padrão" + " - " + SM0->M0_CODIGO + " " + SM0->M0_NOME + " ..." )
			FSAtuSXB( @cTexto )

			//------------------------------------
			// Atualiza os helps
			//------------------------------------
			oProcess:IncRegua1( "Helps de Campo" + " - " + SM0->M0_CODIGO + " " + SM0->M0_NOME + " ..." )
			FSAtuHlp( @cTexto )

			RpcClearEnv()

		Next nI

		If MyOpenSm0(.T.)

			cAux += Replicate( "-", 128 ) + CRLF
			cAux += Replicate( " ", 128 ) + CRLF
			cAux += "LOG DA ATUALIZAÇÃO DOS DICIONÁRIOS" + CRLF
			cAux += Replicate( " ", 128 ) + CRLF
			cAux += Replicate( "-", 128 ) + CRLF
			cAux += CRLF
			cAux += " Dados Ambiente" + CRLF
			cAux += " --------------------"  + CRLF
			cAux += " Empresa / Filial...: " + cEmpAnt + "/" + cFilAnt  + CRLF
			cAux += " Nome Empresa.......: " + Capital( AllTrim( GetAdvFVal( "SM0", "M0_NOMECOM", cEmpAnt + cFilAnt, 1, "" ) ) ) + CRLF
			cAux += " Nome Filial........: " + Capital( AllTrim( GetAdvFVal( "SM0", "M0_FILIAL" , cEmpAnt + cFilAnt, 1, "" ) ) ) + CRLF
			cAux += " DataBase...........: " + DtoC( dDataBase )  + CRLF
			cAux += " Data / Hora Ínicio.: " + DtoC( Date() )  + " / " + Time()  + CRLF
			cAux += " Environment........: " + GetEnvServer()  + CRLF
			cAux += " StartPath..........: " + GetSrvProfString( "StartPath", "" )  + CRLF
			cAux += " RootPath...........: " + GetSrvProfString( "RootPath" , "" )  + CRLF
			cAux += " Versão.............: " + GetVersao(.T.)  + CRLF
			cAux += " Usuário TOTVS .....: " + __cUserId + " " +  cUserName + CRLF
			cAux += " Computer Name......: " + GetComputerName() + CRLF

			aInfo   := GetUserInfo()
			If ( nPos    := aScan( aInfo,{ |x,y| x[3] == ThreadId() } ) ) > 0
				cAux += " "  + CRLF
				cAux += " Dados Thread" + CRLF
				cAux += " --------------------"  + CRLF
				cAux += " Usuário da Rede....: " + aInfo[nPos][1] + CRLF
				cAux += " Estação............: " + aInfo[nPos][2] + CRLF
				cAux += " Programa Inicial...: " + aInfo[nPos][5] + CRLF
				cAux += " Environment........: " + aInfo[nPos][6] + CRLF
				cAux += " Conexão............: " + AllTrim( StrTran( StrTran( aInfo[nPos][7], Chr( 13 ), "" ), Chr( 10 ), "" ) )  + CRLF
			EndIf
			cAux += Replicate( "-", 128 ) + CRLF
			cAux += CRLF

			cTexto := cAux + cTexto + CRLF

			cTexto += Replicate( "-", 128 ) + CRLF
			cTexto += " Data / Hora Final.: " + DtoC( Date() ) + " / " + Time()  + CRLF
			cTexto += Replicate( "-", 128 ) + CRLF

			cFileLog := MemoWrite( CriaTrab( , .F. ) + ".log", cTexto )

			Define Font oFont Name "Mono AS" Size 5, 12

			Define MsDialog oDlg Title "Atualização concluida." From 3, 0 to 340, 417 Pixel

			@ 5, 5 Get oMemo Var cTexto Memo Size 200, 145 Of oDlg Pixel
			oMemo:bRClicked := { || AllwaysTrue() }
			oMemo:oFont     := oFont

			Define SButton From 153, 175 Type  1 Action oDlg:End() Enable Of oDlg Pixel // Apaga
			Define SButton From 153, 145 Type 13 Action ( cFile := cGetFile( cMask, "" ), If( cFile == "", .T., ;
			MemoWrite( cFile, cTexto ) ) ) Enable Of oDlg Pixel

			Activate MsDialog oDlg Center

		EndIf

	EndIf

Else

	lRet := .F.

EndIf

Return lRet


//--------------------------------------------------------------------
/*{Protheus.doc} FSAtuSX2
Função de processamento da gravação do SX2 - Arquivos

@author TOTVS Protheus
@since  29/04/2014
@obs    Gerado por EXPORDIC - V.4.19.9.2 EFS / Upd. V.4.17.9 EFS
@version 1.0
*/
//--------------------------------------------------------------------
Static Function FSAtuSX2( cTexto )
Local aEstrut   := {}
Local aSX2      := {}
Local cAlias    := ""
Local cEmpr     := ""
Local cPath     := ""
Local nI        := 0
Local nJ        := 0

cTexto  += "Ínicio da Atualização" + " SX2" + CRLF + CRLF

aEstrut := { "X2_CHAVE"  , "X2_PATH"   , "X2_ARQUIVO", "X2_NOME"  , "X2_NOMESPA", "X2_NOMEENG", ;
             "X2_DELET"  , "X2_MODO"   , "X2_TTS"    , "X2_ROTINA", "X2_PYME"   , "X2_UNICO"  , ;
             "X2_MODOEMP", "X2_MODOUN" , "X2_MODULO" }

dbSelectArea( "SX2" )
SX2->( dbSetOrder( 1 ) )
SX2->( dbGoTop() )
cPath := SX2->X2_PATH
cPath := IIf( Right( AllTrim( cPath ), 1 ) <> "\", PadR( AllTrim( cPath ) + "\", Len( cPath ) ), cPath )
cEmpr := Substr( SX2->X2_ARQUIVO, 4 )

//
// Tabela SZW
//
aAdd( aSX2, { ;
	'SZW'																	, ; //X2_CHAVE
	cPath																	, ; //X2_PATH
	'SZW'+cEmpr																, ; //X2_ARQUIVO
	'PREVISAO / ORCAMENTO DE VENDAS'										, ; //X2_NOME
	'PREVISAO / ORCAMENTO DE VENDAS'										, ; //X2_NOMESPA
	'PREVISAO / ORCAMENTO DE VENDAS'										, ; //X2_NOMEENG
	0																		, ; //X2_DELET
	'C'																		, ; //X2_MODO
	''																		, ; //X2_TTS
	''																		, ; //X2_ROTINA
	''																		, ; //X2_PYME
	''																		, ; //X2_UNICO
	'C'																		, ; //X2_MODOEMP
	'C'																		, ; //X2_MODOUN
	0																		} ) //X2_MODULO

//
// Tabela SZY
//
aAdd( aSX2, { ;
	'SZY'																	, ; //X2_CHAVE
	cPath																	, ; //X2_PATH
	'SZY'+cEmpr																, ; //X2_ARQUIVO
	'CALENDARIO DO PLANEJ. COMPRAS'											, ; //X2_NOME
	'CALENDARIO DO PLANEJ. COMPRAS'											, ; //X2_NOMESPA
	'CALENDARIO DO PLANEJ. COMPRAS'											, ; //X2_NOMEENG
	0																		, ; //X2_DELET
	'C'																		, ; //X2_MODO
	''																		, ; //X2_TTS
	''																		, ; //X2_ROTINA
	''																		, ; //X2_PYME
	''																		, ; //X2_UNICO
	'C'																		, ; //X2_MODOEMP
	'C'																		, ; //X2_MODOUN
	0																		} ) //X2_MODULO

//
// Tabela SZZ
//
aAdd( aSX2, { ;
	'SZZ'																	, ; //X2_CHAVE
	cPath																	, ; //X2_PATH
	'SZZ'+cEmpr																, ; //X2_ARQUIVO
	'CADASTRO DE REGIONAL'													, ; //X2_NOME
	'CADASTRO DE REGIONAL'													, ; //X2_NOMESPA
	'CADASTRO DE REGIONAL'													, ; //X2_NOMEENG
	0																		, ; //X2_DELET
	'C'																		, ; //X2_MODO
	''																		, ; //X2_TTS
	''																		, ; //X2_ROTINA
	''																		, ; //X2_PYME
	''																		, ; //X2_UNICO
	'C'																		, ; //X2_MODOEMP
	'C'																		, ; //X2_MODOUN
	0																		} ) //X2_MODULO

//
// Atualizando dicionário
//
oProcess:SetRegua2( Len( aSX2 ) )

dbSelectArea( "SX2" )
dbSetOrder( 1 )

For nI := 1 To Len( aSX2 )

	oProcess:IncRegua2( "Atualizando Arquivos (SX2)..." )

	If !SX2->( dbSeek( aSX2[nI][1] ) )

		If !( aSX2[nI][1] $ cAlias )
			cAlias += aSX2[nI][1] + "/"
			cTexto += "Foi incluída a tabela " + aSX2[nI][1] + CRLF
		EndIf

		RecLock( "SX2", .T. )
		For nJ := 1 To Len( aSX2[nI] )
			If FieldPos( aEstrut[nJ] ) > 0
				If AllTrim( aEstrut[nJ] ) == "X2_ARQUIVO"
					FieldPut( FieldPos( aEstrut[nJ] ), SubStr( aSX2[nI][nJ], 1, 3 ) + cEmpAnt +  "0" )
				Else
					FieldPut( FieldPos( aEstrut[nJ] ), aSX2[nI][nJ] )
				EndIf
			EndIf
		Next nJ
		MsUnLock()

	Else

		If  !( StrTran( Upper( AllTrim( SX2->X2_UNICO ) ), " ", "" ) == StrTran( Upper( AllTrim( aSX2[nI][12]  ) ), " ", "" ) )
			RecLock( "SX2", .F. )
			SX2->X2_UNICO := aSX2[nI][12]
			MsUnlock()

			If MSFILE( RetSqlName( aSX2[nI][1] ),RetSqlName( aSX2[nI][1] ) + "_UNQ"  )
				TcInternal( 60, RetSqlName( aSX2[nI][1] ) + "|" + RetSqlName( aSX2[nI][1] ) + "_UNQ" )
			EndIf

			cTexto += "Foi alterada a chave única da tabela " + aSX2[nI][1] + CRLF
		EndIf

	EndIf

Next nI

cTexto += CRLF + "Final da Atualização" + " SX2" + CRLF + Replicate( "-", 128 ) + CRLF + CRLF

Return NIL


//--------------------------------------------------------------------
/*{Protheus.doc} FSAtuSX3
Função de processamento da gravação do SX3 - Campos

@author TOTVS Protheus
@since  29/04/2014
@obs    Gerado por EXPORDIC - V.4.19.9.2 EFS / Upd. V.4.17.9 EFS
@version 1.0
*/
//--------------------------------------------------------------------
Static Function FSAtuSX3( cTexto )
Local aEstrut   := {}
Local aSX3      := {}
Local cAlias    := ""
Local cAliasAtu := ""
Local cMsg      := ""
Local cSeqAtu   := ""
Local lTodosNao := .F.
Local lTodosSim := .F.
Local nI        := 0
Local nJ        := 0
Local nOpcA     := 0
Local nPosArq   := 0
Local nPosCpo   := 0
Local nPosOrd   := 0
Local nPosSXG   := 0
Local nPosTam   := 0
Local nPosVld   := 0
Local nSeqAtu   := 0
Local nTamSeek  := Len( SX3->X3_CAMPO )

cTexto  += "Ínicio da Atualização" + " SX3" + CRLF + CRLF

aEstrut := { { "X3_ARQUIVO", 0 }, { "X3_ORDEM"  , 0 }, { "X3_CAMPO"  , 0 }, { "X3_TIPO"   , 0 }, { "X3_TAMANHO", 0 }, { "X3_DECIMAL", 0 }, ;
             { "X3_TITULO" , 0 }, { "X3_TITSPA" , 0 }, { "X3_TITENG" , 0 }, { "X3_DESCRIC", 0 }, { "X3_DESCSPA", 0 }, { "X3_DESCENG", 0 }, ;
             { "X3_PICTURE", 0 }, { "X3_VALID"  , 0 }, { "X3_USADO"  , 0 }, { "X3_RELACAO", 0 }, { "X3_F3"     , 0 }, { "X3_NIVEL"  , 0 }, ;
             { "X3_RESERV" , 0 }, { "X3_CHECK"  , 0 }, { "X3_TRIGGER", 0 }, { "X3_PROPRI" , 0 }, { "X3_BROWSE" , 0 }, { "X3_VISUAL" , 0 }, ;
             { "X3_CONTEXT", 0 }, { "X3_OBRIGAT", 0 }, { "X3_VLDUSER", 0 }, { "X3_CBOX"   , 0 }, { "X3_CBOXSPA", 0 }, { "X3_CBOXENG", 0 }, ;
             { "X3_PICTVAR", 0 }, { "X3_WHEN"   , 0 }, { "X3_INIBRW" , 0 }, { "X3_GRPSXG" , 0 }, { "X3_FOLDER" , 0 }, { "X3_PYME"   , 0 }, ;
             { "X3_AGRUP"  , 0 } }

aEval( aEstrut, { |x| x[2] := SX3->( FieldPos( x[1] ) ) } )


//
// Campos Tabela SZW
//
aAdd( aSX3, { ;
	'SZW'																	, ; //X3_ARQUIVO
	'01'																	, ; //X3_ORDEM
	'ZW_FILIAL'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	6																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Filial'																, ; //X3_TITULO
	'Sucursal'																, ; //X3_TITSPA
	'Branch'																, ; //X3_TITENG
	'Filial do Sistema'														, ; //X3_DESCRIC
	'Sucursal'																, ; //X3_DESCSPA
	'Branch of the System'													, ; //X3_DESCENG
	'@!'																	, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(254) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	'033'																	, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_PYME
	''																		} ) //X3_AGRUP

aAdd( aSX3, { ;
	'SZW'																	, ; //X3_ARQUIVO
	'02'																	, ; //X3_ORDEM
	'ZW_CODPREV'															, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	6																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Cod.Previsao'															, ; //X3_TITULO
	'Cod.Previsao'															, ; //X3_TITSPA
	'Cod.Previsao'															, ; //X3_TITENG
	'Codigo Previsao de Vendas'												, ; //X3_DESCRIC
	'Codigo Previsao de Vendas'												, ; //X3_DESCSPA
	'Codigo Previsao de Vendas'												, ; //X3_DESCENG
	'@!'																	, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	Chr(254) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	'€'																		, ; //X3_OBRIGAT
	'NaoVazio(M->ZW_CODPREV)'												, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	'Inclui'																, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_PYME
	''																		} ) //X3_AGRUP

aAdd( aSX3, { ;
	'SZW'																	, ; //X3_ARQUIVO
	'03'																	, ; //X3_ORDEM
	'ZW_DESPREV'															, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	40																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Desc. Prev.'															, ; //X3_TITULO
	'Desc. Prev.'															, ; //X3_TITSPA
	'Desc. Prev.'															, ; //X3_TITENG
	'Descricao Previsao Vendas'												, ; //X3_DESCRIC
	'Descricao Previsao Vendas'												, ; //X3_DESCSPA
	'Descricao Previsao Vendas'												, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	Chr(254) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	'€'																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_PYME
	''																		} ) //X3_AGRUP

aAdd( aSX3, { ;
	'SZW'																	, ; //X3_ARQUIVO
	'04'																	, ; //X3_ORDEM
	'ZW_ANO'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	4																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Ano Previsao'															, ; //X3_TITULO
	'Ano Previsao'															, ; //X3_TITSPA
	'Ano Previsao'															, ; //X3_TITENG
	'Ano da Previsao de Vendas'												, ; //X3_DESCRIC
	'Ano da Previsao de Vendas'												, ; //X3_DESCSPA
	'Ano da Previsao de Vendas'												, ; //X3_DESCENG
	'@9999'																	, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	'STRZERO(YEAR(DDATABASE),4)'											, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	Chr(254) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	'€'																		, ; //X3_OBRIGAT
	'NaoVazio(M->ZW_ANO).and.ExistChav("SZW",M->ZW_ANO+M->ZW_CODREG+M->ZW_CODPROD).and.M->ZW_ANO>"2010".and.M->ZW_ANO<"2030"', ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	'Inclui'																, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_PYME
	''																		} ) //X3_AGRUP

aAdd( aSX3, { ;
	'SZW'																	, ; //X3_ARQUIVO
	'05'																	, ; //X3_ORDEM
	'ZW_CODREG'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	6																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Cod.Regional'															, ; //X3_TITULO
	'Cod.Regional'															, ; //X3_TITSPA
	'Cod.Regional'															, ; //X3_TITENG
	'Codigo da Regional'													, ; //X3_DESCRIC
	'Codigo da Regional'													, ; //X3_DESCSPA
	'Codigo da Regional'													, ; //X3_DESCENG
	'@!'																	, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	'SZZ'																	, ; //X3_F3
	0																		, ; //X3_NIVEL
	Chr(254) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	'€'																		, ; //X3_OBRIGAT
	'NaoVazio().and.ExistChav("SZW",M->ZW_ANO+M->ZW_CODREG+M->ZW_CODPROD)'		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	'Inclui'																, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_PYME
	''																		} ) //X3_AGRUP

aAdd( aSX3, { ;
	'SZW'																	, ; //X3_ARQUIVO
	'06'																	, ; //X3_ORDEM
	'ZW_DESREG'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	40																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Desc.Region.'															, ; //X3_TITULO
	'Desc.Region.'															, ; //X3_TITSPA
	'Desc.Region.'															, ; //X3_TITENG
	'Descricao da Regional'													, ; //X3_DESCRIC
	'Descricao da Regional'													, ; //X3_DESCSPA
	'Descricao da Regional'													, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	'IF(INCLUI.OR.EMPTY(M->ZW_CODREG),"",POSICIONE("SZZ",1,XFILIAL("SZZ")+M->ZW_CODREG,"ZZ_DESREG"))', ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	Chr(254) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	'V'																		, ; //X3_VISUAL
	'V'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	'RetField("SZZ",1,xFilial("SZZ")+SZW->ZW_CODREG,"SZZ->ZZ_DESREG")'		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_PYME
	''																		} ) //X3_AGRUP

aAdd( aSX3, { ;
	'SZW'																	, ; //X3_ARQUIVO
	'07'																	, ; //X3_ORDEM
	'ZW_CODPROD'															, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	15																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Cod. Produto'															, ; //X3_TITULO
	'Cod. Produto'															, ; //X3_TITSPA
	'Cod. Produto'															, ; //X3_TITENG
	'Codigo do Produto'														, ; //X3_DESCRIC
	'Codigo do Produto'														, ; //X3_DESCSPA
	'Codigo do Produto'														, ; //X3_DESCENG
	'@!'																	, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	'SB1002'																, ; //X3_F3
	0																		, ; //X3_NIVEL
	Chr(254) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	'S'																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	'€'																		, ; //X3_OBRIGAT
	'NaoVazio().and.ExistChav("SZW",M->ZW_CODPREV+M->ZW_ANO+M->ZW_CODREG+M->ZW_CODPROD).and.ExistCpo("SB1")', ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_PYME
	''																		} ) //X3_AGRUP

aAdd( aSX3, { ;
	'SZW'																	, ; //X3_ARQUIVO
	'08'																	, ; //X3_ORDEM
	'ZW_DESPROD'															, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	30																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Desc. Prod.'															, ; //X3_TITULO
	'Desc. Prod.'															, ; //X3_TITSPA
	'Desc. Prod.'															, ; //X3_TITENG
	'Descricao do Produto'													, ; //X3_DESCRIC
	'Descricao do Produto'													, ; //X3_DESCSPA
	'Descricao do Produto'													, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	'IF(INCLUI.OR.ALTERA,"",POSICIONE("SB1",1,XFILIAL("SB1")+M->ZW_CODPROD,"B1_DESC"))', ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	Chr(254) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	'V'																		, ; //X3_VISUAL
	'V'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	'RetField("SB1",1,xFilial("SB1")+SZW->ZW_CODPROD,"SB1->B1_DESC")'		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_PYME
	''																		} ) //X3_AGRUP

aAdd( aSX3, { ;
	'SZW'																	, ; //X3_ARQUIVO
	'09'																	, ; //X3_ORDEM
	'ZW_MES01'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	7																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Janeiro'																, ; //X3_TITULO
	'Janeiro'																, ; //X3_TITSPA
	'Janeiro'																, ; //X3_TITENG
	'Janeiro'																, ; //X3_DESCRIC
	'Janeiro'																, ; //X3_DESCSPA
	'Janeiro'																, ; //X3_DESCENG
	'@E 9,999,999'															, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	Chr(254) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	'Positivo()'															, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_PYME
	''																		} ) //X3_AGRUP

aAdd( aSX3, { ;
	'SZW'																	, ; //X3_ARQUIVO
	'10'																	, ; //X3_ORDEM
	'ZW_MES02'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	7																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Fevereiro'																, ; //X3_TITULO
	'Fevereiro'																, ; //X3_TITSPA
	'Fevereiro'																, ; //X3_TITENG
	'Fevereiro'																, ; //X3_DESCRIC
	'Fevereiro'																, ; //X3_DESCSPA
	'Fevereiro'																, ; //X3_DESCENG
	'@E 9,999,999'															, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	Chr(254) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	'Positivo()'															, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_PYME
	''																		} ) //X3_AGRUP

aAdd( aSX3, { ;
	'SZW'																	, ; //X3_ARQUIVO
	'11'																	, ; //X3_ORDEM
	'ZW_MES03'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	7																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Marco'																	, ; //X3_TITULO
	'Marco'																	, ; //X3_TITSPA
	'Marco'																	, ; //X3_TITENG
	'Marco'																	, ; //X3_DESCRIC
	'Marco'																	, ; //X3_DESCSPA
	'Marco'																	, ; //X3_DESCENG
	'@E 9,999,999'															, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	Chr(254) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	'Positivo()'															, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_PYME
	''																		} ) //X3_AGRUP

aAdd( aSX3, { ;
	'SZW'																	, ; //X3_ARQUIVO
	'12'																	, ; //X3_ORDEM
	'ZW_MES04'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	7																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Abril'																	, ; //X3_TITULO
	'Abril'																	, ; //X3_TITSPA
	'Abril'																	, ; //X3_TITENG
	'Abril'																	, ; //X3_DESCRIC
	'Abril'																	, ; //X3_DESCSPA
	'Abril'																	, ; //X3_DESCENG
	'@E 9,999,999'															, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	Chr(254) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	'Positivo()'															, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_PYME
	''																		} ) //X3_AGRUP

aAdd( aSX3, { ;
	'SZW'																	, ; //X3_ARQUIVO
	'13'																	, ; //X3_ORDEM
	'ZW_MES05'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	7																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Maio'																	, ; //X3_TITULO
	'Maio'																	, ; //X3_TITSPA
	'Maio'																	, ; //X3_TITENG
	'Maio'																	, ; //X3_DESCRIC
	'Maio'																	, ; //X3_DESCSPA
	'Maio'																	, ; //X3_DESCENG
	'@E 9,999,999'															, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	Chr(254) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	'Positivo()'															, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_PYME
	''																		} ) //X3_AGRUP

aAdd( aSX3, { ;
	'SZW'																	, ; //X3_ARQUIVO
	'14'																	, ; //X3_ORDEM
	'ZW_MES06'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	7																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Junho'																	, ; //X3_TITULO
	'Junho'																	, ; //X3_TITSPA
	'Junho'																	, ; //X3_TITENG
	'Junho'																	, ; //X3_DESCRIC
	'Junho'																	, ; //X3_DESCSPA
	'Junho'																	, ; //X3_DESCENG
	'@E 9,999,999'															, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	Chr(254) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	'Positivo()'															, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_PYME
	''																		} ) //X3_AGRUP

aAdd( aSX3, { ;
	'SZW'																	, ; //X3_ARQUIVO
	'15'																	, ; //X3_ORDEM
	'ZW_MES07'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	7																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Julho'																	, ; //X3_TITULO
	'Julho'																	, ; //X3_TITSPA
	'Julho'																	, ; //X3_TITENG
	'Julho'																	, ; //X3_DESCRIC
	'Julho'																	, ; //X3_DESCSPA
	'Julho'																	, ; //X3_DESCENG
	'@E 9,999,999'															, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	Chr(254) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	'Positivo()'															, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_PYME
	''																		} ) //X3_AGRUP

aAdd( aSX3, { ;
	'SZW'																	, ; //X3_ARQUIVO
	'16'																	, ; //X3_ORDEM
	'ZW_MES08'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	7																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Agosto'																, ; //X3_TITULO
	'Agosto'																, ; //X3_TITSPA
	'Agosto'																, ; //X3_TITENG
	'Agosto'																, ; //X3_DESCRIC
	'Agosto'																, ; //X3_DESCSPA
	'Agosto'																, ; //X3_DESCENG
	'@E 9,999,999'															, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	Chr(254) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	'Positivo()'															, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_PYME
	''																		} ) //X3_AGRUP

aAdd( aSX3, { ;
	'SZW'																	, ; //X3_ARQUIVO
	'17'																	, ; //X3_ORDEM
	'ZW_MES09'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	7																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Setembro'																, ; //X3_TITULO
	'Setembro'																, ; //X3_TITSPA
	'Setembro'																, ; //X3_TITENG
	'Setembro'																, ; //X3_DESCRIC
	'Setembro'																, ; //X3_DESCSPA
	'Setembro'																, ; //X3_DESCENG
	'@E 9,999,999'															, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	Chr(254) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	'Positivo()'															, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_PYME
	''																		} ) //X3_AGRUP

aAdd( aSX3, { ;
	'SZW'																	, ; //X3_ARQUIVO
	'18'																	, ; //X3_ORDEM
	'ZW_MES10'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	7																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Outubro'																, ; //X3_TITULO
	'Outubro'																, ; //X3_TITSPA
	'Outubro'																, ; //X3_TITENG
	'Outubro'																, ; //X3_DESCRIC
	'Outubro'																, ; //X3_DESCSPA
	'Outubro'																, ; //X3_DESCENG
	'@E 9,999,999'															, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	Chr(254) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	'Positivo()'															, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_PYME
	''																		} ) //X3_AGRUP

aAdd( aSX3, { ;
	'SZW'																	, ; //X3_ARQUIVO
	'19'																	, ; //X3_ORDEM
	'ZW_MES11'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	7																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Novembro'																, ; //X3_TITULO
	'Novembro'																, ; //X3_TITSPA
	'Novembro'																, ; //X3_TITENG
	'Novembro'																, ; //X3_DESCRIC
	'Novembro'																, ; //X3_DESCSPA
	'Novembro'																, ; //X3_DESCENG
	'@E 9,999,999'															, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	Chr(254) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	'Positivo()'															, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_PYME
	''																		} ) //X3_AGRUP

aAdd( aSX3, { ;
	'SZW'																	, ; //X3_ARQUIVO
	'20'																	, ; //X3_ORDEM
	'ZW_MES12'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	7																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Dezembro'																, ; //X3_TITULO
	'Dezembro'																, ; //X3_TITSPA
	'Dezembro'																, ; //X3_TITENG
	'Dezembro'																, ; //X3_DESCRIC
	'Dezembro'																, ; //X3_DESCSPA
	'Dezembro'																, ; //X3_DESCENG
	'@E 9,999,999'															, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	Chr(254) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	'Positivo()'															, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_PYME
	''																		} ) //X3_AGRUP

//
// Campos Tabela SZY
//
aAdd( aSX3, { ;
	'SZY'																	, ; //X3_ARQUIVO
	'01'																	, ; //X3_ORDEM
	'ZY_FILIAL'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	6																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Filial'																, ; //X3_TITULO
	'Sucursal'																, ; //X3_TITSPA
	'Branch'																, ; //X3_TITENG
	'Filial do Sistema'														, ; //X3_DESCRIC
	'Sucursal'																, ; //X3_DESCSPA
	'Branch of the System'													, ; //X3_DESCENG
	'@!'																	, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(254) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	'033'																	, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_PYME
	''																		} ) //X3_AGRUP

aAdd( aSX3, { ;
	'SZY'																	, ; //X3_ARQUIVO
	'02'																	, ; //X3_ORDEM
	'ZY_ANO'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	4																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Ano'																	, ; //X3_TITULO
	'Ano'																	, ; //X3_TITSPA
	'Ano'																	, ; //X3_TITENG
	'Ano do Calendario'														, ; //X3_DESCRIC
	'Ano do Calendario'														, ; //X3_DESCSPA
	'Ano do Calendario'														, ; //X3_DESCENG
	'@9999'																	, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	Chr(254) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	'€'																		, ; //X3_OBRIGAT
	'NaoVazio(M->ZY_ANO).and.ExistChav("SZY",M->ZY_ANO+M->ZY_MES).and.Entre("2010","2030")', ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_PYME
	''																		} ) //X3_AGRUP

aAdd( aSX3, { ;
	'SZY'																	, ; //X3_ARQUIVO
	'03'																	, ; //X3_ORDEM
	'ZY_MES'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	2																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Mes'																	, ; //X3_TITULO
	'Mes'																	, ; //X3_TITSPA
	'Mes'																	, ; //X3_TITENG
	'Mes do Calendario'														, ; //X3_DESCRIC
	'Mes do Calendario'														, ; //X3_DESCSPA
	'Mes do Calendario'														, ; //X3_DESCENG
	'@99'																	, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	Chr(254) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	'€'																		, ; //X3_OBRIGAT
	'NaoVazio(M->ZY_MES).and.ExistChav("SZY",M->ZY_ANO+M->ZY_MES).and.Entre("01","12")', ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_PYME
	''																		} ) //X3_AGRUP

aAdd( aSX3, { ;
	'SZY'																	, ; //X3_ARQUIVO
	'04'																	, ; //X3_ORDEM
	'ZY_DTINI'																, ; //X3_CAMPO
	'D'																		, ; //X3_TIPO
	8																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Data Inicial'															, ; //X3_TITULO
	'Data Inicial'															, ; //X3_TITSPA
	'Data Inicial'															, ; //X3_TITENG
	'Data Inicial Calendario'												, ; //X3_DESCRIC
	'Data Inicial Calendario'												, ; //X3_DESCSPA
	'Data Inicial Calendario'												, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	'CTOD("  /  /    ")'													, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	Chr(254) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	'€'																		, ; //X3_OBRIGAT
	'U_AVFATE12("ZY_DTINI")'												, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_PYME
	''																		} ) //X3_AGRUP

aAdd( aSX3, { ;
	'SZY'																	, ; //X3_ARQUIVO
	'05'																	, ; //X3_ORDEM
	'ZY_DTFIM'																, ; //X3_CAMPO
	'D'																		, ; //X3_TIPO
	8																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Data Final'															, ; //X3_TITULO
	'Data Final'															, ; //X3_TITSPA
	'Data Final'															, ; //X3_TITENG
	'Data Final Calendario'													, ; //X3_DESCRIC
	'Data Final Calendario'													, ; //X3_DESCSPA
	'Data Final Calendario'													, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	'CTOD("  /  /    ")'													, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	Chr(254) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	'€'																		, ; //X3_OBRIGAT
	'U_AVFATE12("ZY_DTFIM")'												, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_PYME
	''																		} ) //X3_AGRUP

//
// Campos Tabela SZZ
//
aAdd( aSX3, { ;
	'SZZ'																	, ; //X3_ARQUIVO
	'01'																	, ; //X3_ORDEM
	'ZZ_FILIAL'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	6																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Filial'																, ; //X3_TITULO
	'Sucursal'																, ; //X3_TITSPA
	'Branch'																, ; //X3_TITENG
	'Filial do Sistema'														, ; //X3_DESCRIC
	'Sucursal'																, ; //X3_DESCSPA
	'Branch of the System'													, ; //X3_DESCENG
	'@!'																	, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(254) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	'033'																	, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_PYME
	''																		} ) //X3_AGRUP

aAdd( aSX3, { ;
	'SZZ'																	, ; //X3_ARQUIVO
	'02'																	, ; //X3_ORDEM
	'ZZ_CODREG'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	6																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Cod.Regional'															, ; //X3_TITULO
	'Cod.Regional'															, ; //X3_TITSPA
	'Cod.Regional'															, ; //X3_TITENG
	'Codigo da Regional'													, ; //X3_DESCRIC
	'Codigo da Regional'													, ; //X3_DESCSPA
	'Codigo da Regional'													, ; //X3_DESCENG
	'@!'																	, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	Chr(254) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	'€'																		, ; //X3_OBRIGAT
	'NaoVazio(M->ZZ_CODREG).and.ExistChav("SZZ",M->ZZ_CODREG)'				, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_PYME
	''																		} ) //X3_AGRUP

aAdd( aSX3, { ;
	'SZZ'																	, ; //X3_ARQUIVO
	'03'																	, ; //X3_ORDEM
	'ZZ_DESREG'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	40																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Regional'																, ; //X3_TITULO
	'Regional'																, ; //X3_TITSPA
	'Regional'																, ; //X3_TITENG
	'Descricao da Regional'													, ; //X3_DESCRIC
	'Descricao da Regional'													, ; //X3_DESCSPA
	'Descricao da Regional'													, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	Chr(254) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	'€'																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_PYME
	''																		} ) //X3_AGRUP

aAdd( aSX3, { ;
	'SZZ'																	, ; //X3_ARQUIVO
	'04'																	, ; //X3_ORDEM
	'ZZ_GERENC'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	6																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Ger.Reg.Cod.'															, ; //X3_TITULO
	'Ger.Reg.Cod.'															, ; //X3_TITSPA
	'Ger.Reg.Cod.'															, ; //X3_TITENG
	'Gerente Regional (Cod.)'												, ; //X3_DESCRIC
	'Gerente Regional (Cod.)'												, ; //X3_DESCSPA
	'Gerente Regional (Cod.)'												, ; //X3_DESCENG
	'@!'																	, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	'SA3'																	, ; //X3_F3
	0																		, ; //X3_NIVEL
	Chr(254) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	'S'																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	'U_AVFATE10()'															, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_PYME
	''																		} ) //X3_AGRUP

aAdd( aSX3, { ;
	'SZZ'																	, ; //X3_ARQUIVO
	'05'																	, ; //X3_ORDEM
	'ZZ_GEREND'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	60																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Ger.Regional'															, ; //X3_TITULO
	'Ger.Regional'															, ; //X3_TITSPA
	'Ger.Regional'															, ; //X3_TITENG
	'Gerente Regional (Nome)'												, ; //X3_DESCRIC
	'Gerente Regional (Nome)'												, ; //X3_DESCSPA
	'Gerente Regional (Nome)'												, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	'IF(INCLUI.OR.EMPTY(M->ZZ_GERENC),"",POSICIONE("SA3",1,XFILIAL("SA3")+M->ZZ_GERENC,"A3_NOME"))', ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	Chr(254) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	'V'																		, ; //X3_VISUAL
	'V'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	'RetField("SA3",1,xFilial("SA3")+SZZ->ZZ_GERENC,"SA3->A3_NOME")'		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_PYME
	''																		} ) //X3_AGRUP

//
// Atualizando dicionário
//

nPosArq := aScan( aEstrut, { |x| AllTrim( x[1] ) == "X3_ARQUIVO" } )
nPosOrd := aScan( aEstrut, { |x| AllTrim( x[1] ) == "X3_ORDEM"   } )
nPosCpo := aScan( aEstrut, { |x| AllTrim( x[1] ) == "X3_CAMPO"   } )
nPosTam := aScan( aEstrut, { |x| AllTrim( x[1] ) == "X3_TAMANHO" } )
nPosSXG := aScan( aEstrut, { |x| AllTrim( x[1] ) == "X3_GRPSXG"  } )
nPosVld := aScan( aEstrut, { |x| AllTrim( x[1] ) == "X3_VALID"   } )

aSort( aSX3,,, { |x,y| x[nPosArq]+x[nPosOrd]+x[nPosCpo] < y[nPosArq]+y[nPosOrd]+y[nPosCpo] } )

oProcess:SetRegua2( Len( aSX3 ) )

dbSelectArea( "SX3" )
dbSetOrder( 2 )
cAliasAtu := ""

For nI := 1 To Len( aSX3 )

	//
	// Verifica se o campo faz parte de um grupo e ajsuta tamanho
	//
	If !Empty( aSX3[nI][nPosSXG] )
		SXG->( dbSetOrder( 1 ) )
		If SXG->( MSSeek( aSX3[nI][nPosSXG] ) )
			If aSX3[nI][nPosTam] <> SXG->XG_SIZE
				aSX3[nI][nPosTam] := SXG->XG_SIZE
				cTexto += "O tamanho do campo " + aSX3[nI][nPosCpo] + " NÃO atualizado e foi mantido em ["
				cTexto += AllTrim( Str( SXG->XG_SIZE ) ) + "]" + CRLF
				cTexto += "   por pertencer ao grupo de campos [" + SX3->X3_GRPSXG + "]" + CRLF + CRLF
			EndIf
		EndIf
	EndIf

	SX3->( dbSetOrder( 2 ) )

	If !( aSX3[nI][nPosArq] $ cAlias )
		cAlias += aSX3[nI][nPosArq] + "/"
		aAdd( aArqUpd, aSX3[nI][nPosArq] )
	EndIf

	If !SX3->( dbSeek( PadR( aSX3[nI][nPosCpo], nTamSeek ) ) )

		//
		// Busca ultima ocorrencia do alias
		//
		If ( aSX3[nI][nPosArq] <> cAliasAtu )
			cSeqAtu   := "00"
			cAliasAtu := aSX3[nI][nPosArq]

			dbSetOrder( 1 )
			SX3->( dbSeek( cAliasAtu + "ZZ", .T. ) )
			dbSkip( -1 )

			If ( SX3->X3_ARQUIVO == cAliasAtu )
				cSeqAtu := SX3->X3_ORDEM
			EndIf

			nSeqAtu := Val( RetAsc( cSeqAtu, 3, .F. ) )
		EndIf

		nSeqAtu++
		cSeqAtu := RetAsc( Str( nSeqAtu ), 2, .T. )

		RecLock( "SX3", .T. )
		For nJ := 1 To Len( aSX3[nI] )
			If     nJ == nPosOrd  // Ordem
				SX3->( FieldPut( FieldPos( aEstrut[nJ][1] ), cSeqAtu ) )

			ElseIf aEstrut[nJ][2] > 0
				SX3->( FieldPut( FieldPos( aEstrut[nJ][1] ), aSX3[nI][nJ] ) )

			EndIf
		Next nJ

		dbCommit()
		MsUnLock()

		cTexto += "Criado o campo " + aSX3[nI][nPosCpo] + CRLF

	EndIf

	oProcess:IncRegua2( "Atualizando Campos de Tabelas (SX3)..." )

Next nI

cTexto += CRLF + "Final da Atualização" + " SX3" + CRLF + Replicate( "-", 128 ) + CRLF + CRLF

Return NIL


//--------------------------------------------------------------------
/*{Protheus.doc} FSAtuSIX
Função de processamento da gravação do SIX - Indices

@author TOTVS Protheus
@since  29/04/2014
@obs    Gerado por EXPORDIC - V.4.19.9.2 EFS / Upd. V.4.17.9 EFS
@version 1.0
*/
//--------------------------------------------------------------------
Static Function FSAtuSIX( cTexto )
Local aEstrut   := {}
Local aSIX      := {}
Local lAlt      := .F.
Local lDelInd   := .F.
Local nI        := 0
Local nJ        := 0

cTexto  += "Ínicio da Atualização" + " SIX" + CRLF + CRLF

aEstrut := { "INDICE" , "ORDEM" , "CHAVE", "DESCRICAO", "DESCSPA"  , ;
             "DESCENG", "PROPRI", "F3"   , "NICKNAME" , "SHOWPESQ" }

//
// Tabela SZW
//
aAdd( aSIX, { ;
	'SZW'																	, ; //INDICE
	'1'																		, ; //ORDEM
	'ZW_FILIAL+ZW_CODPREV+ZW_ANO+ZW_CODREG+ZW_CODPROD'						, ; //CHAVE
	'Cod.Previsao, Ano Previsao, Cod.Regional, Cod. Produto'				, ; //DESCRICAO
	'Cod.Previsao+Ano Previsao+Cod.Regional+Cod. Produto'					, ; //DESCSPA
	'Cod.Previsao+Ano Previsao+Cod.Regional+Cod. Produto'					, ; //DESCENG
	'U'																		, ; //PROPRI
	''																		, ; //F3
	'SZW001'																, ; //NICKNAME
	'N'																		} ) //SHOWPESQ

aAdd( aSIX, { ;
	'SZW'																	, ; //INDICE
	'2'																		, ; //ORDEM
	'ZW_FILIAL+ZW_ANO+ZW_CODREG+ZW_CODPROD'									, ; //CHAVE
	'Ano Previsao, Cod.Regional, Cod. Produto'								, ; //DESCRICAO
	'Ano Previsao+Cod.Regional+Cod. Produto'								, ; //DESCSPA
	'Ano Previsao+Cod.Regional+Cod. Produto'								, ; //DESCENG
	'U'																		, ; //PROPRI
	''																		, ; //F3
	'SZW002'																, ; //NICKNAME
	'N'																		} ) //SHOWPESQ

//
// Tabela SZY
//
aAdd( aSIX, { ;
	'SZY'																	, ; //INDICE
	'1'																		, ; //ORDEM
	'ZY_FILIAL+ZY_ANO+ZY_MES'												, ; //CHAVE
	'Ano+Mes'																, ; //DESCRICAO
	'Ano+Mes'																, ; //DESCSPA
	'Ano+Mes'																, ; //DESCENG
	'U'																		, ; //PROPRI
	''																		, ; //F3
	'SZY001'																, ; //NICKNAME
	'N'																		} ) //SHOWPESQ

//
// Tabela SZZ
//
aAdd( aSIX, { ;
	'SZZ'																	, ; //INDICE
	'1'																		, ; //ORDEM
	'ZZ_FILIAL+ZZ_CODREG'													, ; //CHAVE
	'Cod.Regional'															, ; //DESCRICAO
	'Cod.Regional'															, ; //DESCSPA
	'Cod.Regional'															, ; //DESCENG
	'U'																		, ; //PROPRI
	''																		, ; //F3
	'SZZ001'																, ; //NICKNAME
	'S'																		} ) //SHOWPESQ

//
// Atualizando dicionário
//
oProcess:SetRegua2( Len( aSIX ) )

dbSelectArea( "SIX" )
SIX->( dbSetOrder( 1 ) )

For nI := 1 To Len( aSIX )

	lAlt    := .F.
	lDelInd := .F.

	If !SIX->( dbSeek( aSIX[nI][1] + aSIX[nI][2] ) )
		cTexto += "Índice criado " + aSIX[nI][1] + "/" + aSIX[nI][2] + " - " + aSIX[nI][3] + CRLF
	Else
		lAlt := .T.
		aAdd( aArqUpd, aSIX[nI][1] )
		If !StrTran( Upper( AllTrim( CHAVE )       ), " ", "") == ;
		    StrTran( Upper( AllTrim( aSIX[nI][3] ) ), " ", "" )
			cTexto += "Chave do índice alterado " + aSIX[nI][1] + "/" + aSIX[nI][2] + " - " + aSIX[nI][3] + CRLF
			lDelInd := .T. // Se for alteração precisa apagar o indice do banco
		EndIf
	EndIf

	RecLock( "SIX", !lAlt )
	For nJ := 1 To Len( aSIX[nI] )
		If FieldPos( aEstrut[nJ] ) > 0
			FieldPut( FieldPos( aEstrut[nJ] ), aSIX[nI][nJ] )
		EndIf
	Next nJ
	MsUnLock()

	dbCommit()

	If lDelInd
		TcInternal( 60, RetSqlName( aSIX[nI][1] ) + "|" + RetSqlName( aSIX[nI][1] ) + aSIX[nI][2] )
	EndIf

	oProcess:IncRegua2( "Atualizando índices..." )

Next nI

cTexto += CRLF + "Final da Atualização" + " SIX" + CRLF + Replicate( "-", 128 ) + CRLF + CRLF

Return NIL


//--------------------------------------------------------------------
/*{Protheus.doc} FSAtuSX7
Função de processamento da gravação do SX7 - Gatilhos

@author TOTVS Protheus
@since  29/04/2014
@obs    Gerado por EXPORDIC - V.4.19.9.2 EFS / Upd. V.4.17.9 EFS
@version 1.0
*/
//--------------------------------------------------------------------
Static Function FSAtuSX7( cTexto )
Local aEstrut   := {}
Local aAreaSX3  := SX3->( GetArea() )
Local aSX7      := {}
Local cAlias    := ""
Local nI        := 0
Local nJ        := 0
Local nTamSeek  := Len( SX7->X7_CAMPO )

cTexto  += "Ínicio da Atualização" + " SX7" + CRLF + CRLF

aEstrut := { "X7_CAMPO", "X7_SEQUENC", "X7_REGRA", "X7_CDOMIN", "X7_TIPO", "X7_SEEK", ;
             "X7_ALIAS", "X7_ORDEM"  , "X7_CHAVE", "X7_PROPRI", "X7_CONDIC" }

//
// Campo ZW_CODPROD
//
aAdd( aSX7, { ;
	'ZW_CODPROD'															, ; //X7_CAMPO
	'001'																	, ; //X7_SEQUENC
	'RetField("SB1",1,xFilial("SB1")+M->ZW_CODPROD,"SB1->B1_DESC")'			, ; //X7_REGRA
	'ZW_DESPROD'															, ; //X7_CDOMIN
	'P'																		, ; //X7_TIPO
	'N'																		, ; //X7_SEEK
	''																		, ; //X7_ALIAS
	0																		, ; //X7_ORDEM
	''																		, ; //X7_CHAVE
	'U'																		, ; //X7_PROPRI
	''																		} ) //X7_CONDIC

//
// Campo ZZ_GERENC
//
aAdd( aSX7, { ;
	'ZZ_GERENC'																, ; //X7_CAMPO
	'001'																	, ; //X7_SEQUENC
	'RetField("SA3",1,xFilial("SA3")+M->ZZ_GERENC,"SA3->A3_NOME")'			, ; //X7_REGRA
	'ZZ_GEREND'																, ; //X7_CDOMIN
	'P'																		, ; //X7_TIPO
	'N'																		, ; //X7_SEEK
	''																		, ; //X7_ALIAS
	0																		, ; //X7_ORDEM
	''																		, ; //X7_CHAVE
	'U'																		, ; //X7_PROPRI
	''																		} ) //X7_CONDIC

//
// Atualizando dicionário
//
oProcess:SetRegua2( Len( aSX7 ) )

dbSelectArea( "SX3" )
dbSetOrder( 2 )

dbSelectArea( "SX7" )
dbSetOrder( 1 )

For nI := 1 To Len( aSX7 )

	If !SX7->( dbSeek( PadR( aSX7[nI][1], nTamSeek ) + aSX7[nI][2] ) )

		If !( aSX7[nI][1] $ cAlias )
			cAlias += aSX7[nI][1] + "/"
			cTexto += "Foi incluído o gatilho " + aSX7[nI][1] + "/" + aSX7[nI][2] + CRLF
		EndIf

		RecLock( "SX7", .T. )
		For nJ := 1 To Len( aSX7[nI] )
			If FieldPos( aEstrut[nJ] ) > 0
				FieldPut( FieldPos( aEstrut[nJ] ), aSX7[nI][nJ] )
			EndIf
		Next nJ

		dbCommit()
		MsUnLock()

		If SX3->( dbSeek( SX7->X7_CAMPO ) )
			RecLock( "SX3", .F. )
			SX3->X3_TRIGGER := "S"
			MsUnLock()
		EndIf

	EndIf
	oProcess:IncRegua2( "Atualizando Arquivos (SX7)..." )

Next nI

RestArea( aAreaSX3 )

cTexto += CRLF + "Final da Atualização" + " SX7" + CRLF + Replicate( "-", 128 ) + CRLF + CRLF

Return NIL


//--------------------------------------------------------------------
/*{Protheus.doc} FSAtuSXB
Função de processamento da gravação do SXB - Consultas Padrao

@author TOTVS Protheus
@since  29/04/2014
@obs    Gerado por EXPORDIC - V.4.19.9.2 EFS / Upd. V.4.17.9 EFS
@version 1.0
*/
//--------------------------------------------------------------------
Static Function FSAtuSXB( cTexto )
Local aEstrut   := {}
Local aSXB      := {}
Local cAlias    := ""
Local cMsg      := ""
Local lTodosNao := .F.
Local lTodosSim := .F.
Local nI        := 0
Local nJ        := 0
Local nOpcA     := 0

cTexto  += "Ínicio da Atualização" + " SXB" + CRLF + CRLF

aEstrut := { "XB_ALIAS",  "XB_TIPO"   , "XB_SEQ"    , "XB_COLUNA" , ;
             "XB_DESCRI", "XB_DESCSPA", "XB_DESCENG", "XB_CONTEM" }

//
// Consulta SB1002
//
aAdd( aSXB, { ;
	'SB1002'																, ; //XB_ALIAS
	'1'																		, ; //XB_TIPO
	'01'																	, ; //XB_SEQ
	'DB'																	, ; //XB_COLUNA
	'Produto e Descricao'													, ; //XB_DESCRI
	'Produto e Descricao'													, ; //XB_DESCSPA
	'Produto e Descricao'													, ; //XB_DESCENG
	'SB1'																	} ) //XB_CONTEM

aAdd( aSXB, { ;
	'SB1002'																, ; //XB_ALIAS
	'2'																		, ; //XB_TIPO
	'01'																	, ; //XB_SEQ
	'01'																	, ; //XB_COLUNA
	'Codigo'																, ; //XB_DESCRI
	'Codigo'																, ; //XB_DESCSPA
	'Product'																, ; //XB_DESCENG
	''																		} ) //XB_CONTEM

aAdd( aSXB, { ;
	'SB1002'																, ; //XB_ALIAS
	'2'																		, ; //XB_TIPO
	'02'																	, ; //XB_SEQ
	'03'																	, ; //XB_COLUNA
	'Descricao + Codigo'													, ; //XB_DESCRI
	'Descripcion + Codigo'													, ; //XB_DESCSPA
	'Description + Produc'													, ; //XB_DESCENG
	''																		} ) //XB_CONTEM

aAdd( aSXB, { ;
	'SB1002'																, ; //XB_ALIAS
	'4'																		, ; //XB_TIPO
	'01'																	, ; //XB_SEQ
	'01'																	, ; //XB_COLUNA
	'Codigo'																, ; //XB_DESCRI
	'Codigo'																, ; //XB_DESCSPA
	'Product'																, ; //XB_DESCENG
	'B1_COD'																} ) //XB_CONTEM

aAdd( aSXB, { ;
	'SB1002'																, ; //XB_ALIAS
	'4'																		, ; //XB_TIPO
	'01'																	, ; //XB_SEQ
	'02'																	, ; //XB_COLUNA
	'Descricao'																, ; //XB_DESCRI
	'Descripcion'															, ; //XB_DESCSPA
	'Description'															, ; //XB_DESCENG
	'B1_DESC'																} ) //XB_CONTEM

aAdd( aSXB, { ;
	'SB1002'																, ; //XB_ALIAS
	'5'																		, ; //XB_TIPO
	'01'																	, ; //XB_SEQ
	''																		, ; //XB_COLUNA
	''																		, ; //XB_DESCRI
	''																		, ; //XB_DESCSPA
	''																		, ; //XB_DESCENG
	'SB1->B1_COD'															} ) //XB_CONTEM

aAdd( aSXB, { ;
	'SB1002'																, ; //XB_ALIAS
	'5'																		, ; //XB_TIPO
	'02'																	, ; //XB_SEQ
	''																		, ; //XB_COLUNA
	''																		, ; //XB_DESCRI
	''																		, ; //XB_DESCSPA
	''																		, ; //XB_DESCENG
	'SB1->B1_DESC'															} ) //XB_CONTEM

//
// Consulta SZZ
//
aAdd( aSXB, { ;
	'SZZ'																	, ; //XB_ALIAS
	'1'																		, ; //XB_TIPO
	'01'																	, ; //XB_SEQ
	'DB'																	, ; //XB_COLUNA
	'Cadastro de Regional'													, ; //XB_DESCRI
	'Cadastro de Regional'													, ; //XB_DESCSPA
	'Cadastro de Regional'													, ; //XB_DESCENG
	'SZZ'																	} ) //XB_CONTEM

aAdd( aSXB, { ;
	'SZZ'																	, ; //XB_ALIAS
	'2'																		, ; //XB_TIPO
	'01'																	, ; //XB_SEQ
	'01'																	, ; //XB_COLUNA
	'Cod.regional'															, ; //XB_DESCRI
	'Cod.regional'															, ; //XB_DESCSPA
	'Cod.regional'															, ; //XB_DESCENG
	'SZZ001'																} ) //XB_CONTEM

aAdd( aSXB, { ;
	'SZZ'																	, ; //XB_ALIAS
	'3'																		, ; //XB_TIPO
	'01'																	, ; //XB_SEQ
	'01'																	, ; //XB_COLUNA
	'Cadastra Novo'															, ; //XB_DESCRI
	'Incluye Nuevo'															, ; //XB_DESCSPA
	'Add New'																, ; //XB_DESCENG
	'01'																	} ) //XB_CONTEM

aAdd( aSXB, { ;
	'SZZ'																	, ; //XB_ALIAS
	'4'																		, ; //XB_TIPO
	'01'																	, ; //XB_SEQ
	'01'																	, ; //XB_COLUNA
	'Cod.Regional'															, ; //XB_DESCRI
	'Cod.Regional'															, ; //XB_DESCSPA
	'Cod.Regional'															, ; //XB_DESCENG
	'ZZ_CODREG'																} ) //XB_CONTEM

aAdd( aSXB, { ;
	'SZZ'																	, ; //XB_ALIAS
	'4'																		, ; //XB_TIPO
	'01'																	, ; //XB_SEQ
	'02'																	, ; //XB_COLUNA
	'Desc.Region.'															, ; //XB_DESCRI
	'Desc.Region.'															, ; //XB_DESCSPA
	'Desc.Region.'															, ; //XB_DESCENG
	'ZZ_DESREG'																} ) //XB_CONTEM

aAdd( aSXB, { ;
	'SZZ'																	, ; //XB_ALIAS
	'5'																		, ; //XB_TIPO
	'01'																	, ; //XB_SEQ
	''																		, ; //XB_COLUNA
	''																		, ; //XB_DESCRI
	''																		, ; //XB_DESCSPA
	''																		, ; //XB_DESCENG
	'SZZ->ZZ_CODREG'														} ) //XB_CONTEM

aAdd( aSXB, { ;
	'SZZ'																	, ; //XB_ALIAS
	'5'																		, ; //XB_TIPO
	'02'																	, ; //XB_SEQ
	''																		, ; //XB_COLUNA
	''																		, ; //XB_DESCRI
	''																		, ; //XB_DESCSPA
	''																		, ; //XB_DESCENG
	'SZZ->ZZ_DESREG'														} ) //XB_CONTEM

//
// Atualizando dicionário
//
oProcess:SetRegua2( Len( aSXB ) )

dbSelectArea( "SXB" )
dbSetOrder( 1 )

For nI := 1 To Len( aSXB )

	If !Empty( aSXB[nI][1] )

		If !SXB->( dbSeek( PadR( aSXB[nI][1], Len( SXB->XB_ALIAS ) ) + aSXB[nI][2] + aSXB[nI][3] + aSXB[nI][4] ) )

			If !( aSXB[nI][1] $ cAlias )
				cAlias += aSXB[nI][1] + "/"
				cTexto += "Foi incluída a consulta padrão " + aSXB[nI][1] + CRLF
			EndIf

			RecLock( "SXB", .T. )

			For nJ := 1 To Len( aSXB[nI] )
				If !Empty( FieldName( FieldPos( aEstrut[nJ] ) ) )
					FieldPut( FieldPos( aEstrut[nJ] ), aSXB[nI][nJ] )
				EndIf
			Next nJ

			dbCommit()
			MsUnLock()

		Else

			//
			// Verifica todos os campos
			//
			For nJ := 1 To Len( aSXB[nI] )

				//
				// Se o campo estiver diferente da estrutura
				//
				If aEstrut[nJ] == SXB->( FieldName( nJ ) ) .AND. ;
					!StrTran( AllToChar( SXB->( FieldGet( nJ ) ) ), " ", "" ) == ;
					 StrTran( AllToChar( aSXB[nI][nJ]            ), " ", "" )

					cMsg := "A consulta padrão " + aSXB[nI][1] + " está com o " + SXB->( FieldName( nJ ) ) + ;
					" com o conteúdo" + CRLF + ;
					"[" + RTrim( AllToChar( SXB->( FieldGet( nJ ) ) ) ) + "]" + CRLF + ;
					", e este é diferente do conteúdo" + CRLF + ;
					"[" + RTrim( AllToChar( aSXB[nI][nJ] ) ) + "]" + CRLF +;
					"Deseja substituir ? "

					If      lTodosSim
						nOpcA := 1
					ElseIf  lTodosNao
						nOpcA := 2
					Else
						nOpcA := Aviso( "ATUALIZAÇÃO DE DICIONÁRIOS E TABELAS", cMsg, { "Sim", "Não", "Sim p/Todos", "Não p/Todos" }, 3, "Diferença de conteúdo - SXB" )
						lTodosSim := ( nOpcA == 3 )
						lTodosNao := ( nOpcA == 4 )

						If lTodosSim
							nOpcA := 1
							lTodosSim := MsgNoYes( "Foi selecionada a opção de REALIZAR TODAS alterações no SXB e NÃO MOSTRAR mais a tela de aviso." + CRLF + "Confirma a ação [Sim p/Todos] ?" )
						EndIf

						If lTodosNao
							nOpcA := 2
							lTodosNao := MsgNoYes( "Foi selecionada a opção de NÃO REALIZAR nenhuma alteração no SXB que esteja diferente da base e NÃO MOSTRAR mais a tela de aviso." + CRLF + "Confirma esta ação [Não p/Todos]?" )
						EndIf

					EndIf

					If nOpcA == 1
						RecLock( "SXB", .F. )
						FieldPut( FieldPos( aEstrut[nJ] ), aSXB[nI][nJ] )
						dbCommit()
						MsUnLock()

						If !( aSXB[nI][1] $ cAlias )
							cAlias += aSXB[nI][1] + "/"
							cTexto += "Foi alterada a consulta padrão " + aSXB[nI][1] + CRLF
						EndIf

					EndIf

				EndIf

			Next

		EndIf

	EndIf

	oProcess:IncRegua2( "Atualizando Consultas Padrões (SXB)..." )

Next nI

cTexto += CRLF + "Final da Atualização" + " SXB" + CRLF + Replicate( "-", 128 ) + CRLF + CRLF

Return NIL


//--------------------------------------------------------------------
/*{Protheus.doc} FSAtuHlp
Função de processamento da gravação dos Helps de Campos

@author TOTVS Protheus
@since  29/04/2014
@obs    Gerado por EXPORDIC - V.4.19.9.2 EFS / Upd. V.4.17.9 EFS
@version 1.0
*/
//--------------------------------------------------------------------
Static Function FSAtuHlp( cTexto )
Local aHlpPor   := {}
Local aHlpEng   := {}
Local aHlpSpa   := {}

cTexto  += "Ínicio da Atualização" + " " + "Helps de Campos" + CRLF + CRLF


oProcess:IncRegua2( "Atualizando Helps de Campos ..." )

//
// Helps Tabela SZW
//
aHlpPor := {}
aAdd( aHlpPor, 'Codigo Previsao de Vendas.' )
aAdd( aHlpPor, 'Cadastro de Previsao ou Orçamento de' )
aAdd( aHlpPor, 'Vendas, que é elaborada pelo Gerente' )
aAdd( aHlpPor, 'Regional de Vendas, e depois cadastrada' )
aAdd( aHlpPor, 'ou importada no ERP.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZW_CODPREV", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += "Atualizado o Help do campo " + "ZW_CODPREV" + CRLF

aHlpPor := {}
aAdd( aHlpPor, 'Descricao Previsao Vendas.' )
aAdd( aHlpPor, 'Cadastro de Previsao ou Orçamento de' )
aAdd( aHlpPor, 'Vendas, que é elaborada pelo Gerente' )
aAdd( aHlpPor, 'Regional de Vendas, e depois cadastrada' )
aAdd( aHlpPor, 'ou importada no ERP.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZW_DESPREV", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += "Atualizado o Help do campo " + "ZW_DESPREV" + CRLF

aHlpPor := {}
aAdd( aHlpPor, 'Informar o Ano da Previsao de Vendas com' )
aAdd( aHlpPor, 'quatro numeros.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZW_ANO    ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += "Atualizado o Help do campo " + "ZW_ANO" + CRLF

aHlpPor := {}
aAdd( aHlpPor, 'Informe o Código da da Regional ou' )
aAdd( aHlpPor, 'Região do Cadastro de Regional.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZW_CODREG ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += "Atualizado o Help do campo " + "ZW_CODREG" + CRLF

aHlpPor := {}
aAdd( aHlpPor, 'O Codigo da Regional correspondente ao' )
aAdd( aHlpPor, 'Código da Regional do Cadastro de' )
aAdd( aHlpPor, 'Regional.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZW_DESREG ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += "Atualizado o Help do campo " + "ZW_DESREG" + CRLF

aHlpPor := {}
aAdd( aHlpPor, 'Informe o Codigo do Produto relacionado' )
aAdd( aHlpPor, 'aa Previsao/Orcamento de Vendas a ser' )
aAdd( aHlpPor, 'cadastrado.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZW_CODPROD", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += "Atualizado o Help do campo " + "ZW_CODPROD" + CRLF

aHlpPor := {}
aAdd( aHlpPor, 'Descricao do Produto.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZW_DESPROD", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += "Atualizado o Help do campo " + "ZW_DESPROD" + CRLF

aHlpPor := {}
aAdd( aHlpPor, 'Quantidade da Previsão de Vendas do' )
aAdd( aHlpPor, 'respectivo Produto para o mês de' )
aAdd( aHlpPor, 'Janeiro.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZW_MES01  ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += "Atualizado o Help do campo " + "ZW_MES01" + CRLF

aHlpPor := {}
aAdd( aHlpPor, 'Quantidade da Previsão de Vendas do' )
aAdd( aHlpPor, 'respectivo Produto para o mês de' )
aAdd( aHlpPor, 'Fevereiro.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZW_MES02  ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += "Atualizado o Help do campo " + "ZW_MES02" + CRLF

aHlpPor := {}
aAdd( aHlpPor, 'Quantidade da Previsão de Vendas do' )
aAdd( aHlpPor, 'respectivo Produto para o mês de Março.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZW_MES03  ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += "Atualizado o Help do campo " + "ZW_MES03" + CRLF

aHlpPor := {}
aAdd( aHlpPor, 'Quantidade da Previsão de Vendas do' )
aAdd( aHlpPor, 'respectivo Produto para o mês de Abril.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZW_MES04  ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += "Atualizado o Help do campo " + "ZW_MES04" + CRLF

aHlpPor := {}
aAdd( aHlpPor, 'Quantidade da Previsão de Vendas do' )
aAdd( aHlpPor, 'respectivo Produto para o mês de Maio.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZW_MES05  ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += "Atualizado o Help do campo " + "ZW_MES05" + CRLF

aHlpPor := {}
aAdd( aHlpPor, 'Quantidade da Previsão de Vendas do' )
aAdd( aHlpPor, 'respectivo Produto para o mês de Junho.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZW_MES06  ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += "Atualizado o Help do campo " + "ZW_MES06" + CRLF

aHlpPor := {}
aAdd( aHlpPor, 'Quantidade da Previsão de Vendas do' )
aAdd( aHlpPor, 'respectivo Produto para o mês de Julho.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZW_MES07  ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += "Atualizado o Help do campo " + "ZW_MES07" + CRLF

aHlpPor := {}
aAdd( aHlpPor, 'Quantidade da Previsão de Vendas do' )
aAdd( aHlpPor, 'respectivo Produto para o mês de Agosto.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZW_MES08  ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += "Atualizado o Help do campo " + "ZW_MES08" + CRLF

aHlpPor := {}
aAdd( aHlpPor, 'Quantidade da Previsão de Vendas do' )
aAdd( aHlpPor, 'respectivo Produto para o mês de' )
aAdd( aHlpPor, 'Setembro.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZW_MES09  ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += "Atualizado o Help do campo " + "ZW_MES09" + CRLF

aHlpPor := {}
aAdd( aHlpPor, 'Quantidade da Previsão de Vendas do' )
aAdd( aHlpPor, 'respectivo Produto para o mês de' )
aAdd( aHlpPor, 'Outubro.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZW_MES10  ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += "Atualizado o Help do campo " + "ZW_MES10" + CRLF

aHlpPor := {}
aAdd( aHlpPor, 'Quantidade da Previsão de Vendas do' )
aAdd( aHlpPor, 'respectivo Produto para o mês de' )
aAdd( aHlpPor, 'Novembro.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZW_MES11  ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += "Atualizado o Help do campo " + "ZW_MES11" + CRLF

aHlpPor := {}
aAdd( aHlpPor, 'Quantidade da Previsão de Vendas do' )
aAdd( aHlpPor, 'respectivo Produto para o mês de' )
aAdd( aHlpPor, 'Dezembro.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZW_MES12  ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += "Atualizado o Help do campo " + "ZW_MES12" + CRLF

//
// Helps Tabela SZY
//
aHlpPor := {}
aAdd( aHlpPor, 'Ano do Calendário de Planejamento de' )
aAdd( aHlpPor, 'Compras.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZY_ANO    ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += "Atualizado o Help do campo " + "ZY_ANO" + CRLF

aHlpPor := {}
aAdd( aHlpPor, 'Mes do Calendário de Planejamento de' )
aAdd( aHlpPor, 'Compras.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZY_MES    ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += "Atualizado o Help do campo " + "ZY_MES" + CRLF

aHlpPor := {}
aAdd( aHlpPor, 'Data Inicial Calendario do Planejamento.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZY_DTINI  ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += "Atualizado o Help do campo " + "ZY_DTINI" + CRLF

aHlpPor := {}
aAdd( aHlpPor, 'Data Final Calendario.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZY_DTFIM  ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += "Atualizado o Help do campo " + "ZY_DTFIM" + CRLF

//
// Helps Tabela SZZ
//
aHlpPor := {}
aAdd( aHlpPor, 'Código da Regional.' )
aAdd( aHlpPor, 'Regional ou região é a divisão das' )
aAdd( aHlpPor, 'equipes das gerências regionais de' )
aAdd( aHlpPor, 'vendas do grupo AVANT.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZZ_CODREG ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += "Atualizado o Help do campo " + "ZZ_CODREG" + CRLF

aHlpPor := {}
aAdd( aHlpPor, 'Descricao da Regional.' )
aAdd( aHlpPor, 'Regional ou região é a divisão das' )
aAdd( aHlpPor, 'equipes das gerências regionais de' )
aAdd( aHlpPor, 'vendas do grupo AVANT.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZZ_DESREG ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += "Atualizado o Help do campo " + "ZZ_DESREG" + CRLF

aHlpPor := {}
aAdd( aHlpPor, 'Código do Gerente Regional responsável' )
aAdd( aHlpPor, 'pela Regional.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZZ_GERENC ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += "Atualizado o Help do campo " + "ZZ_GERENC" + CRLF

aHlpPor := {}
aAdd( aHlpPor, 'Gerente Regional responsável pela' )
aAdd( aHlpPor, 'Regional.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZZ_GEREND ", aHlpPor, aHlpEng, aHlpSpa, .T. )
cTexto += "Atualizado o Help do campo " + "ZZ_GEREND" + CRLF

cTexto += CRLF + "Final da Atualização" + " " + "Helps de Campos" + CRLF + Replicate( "-", 128 ) + CRLF + CRLF

Return {}


//--------------------------------------------------------------------
/*{Protheus.doc} EscEmpresa
Função genérica para escolha de Empresa, montada pelo SM0

@return aRet Vetor contendo as seleções feitas.
             Se não for marcada nenhuma o vetor volta vazio

@author Ernani Forastieri
@since  27/09/2004
@version 1.0
*/
//--------------------------------------------------------------------
Static Function EscEmpresa()

//---------------------------------------------
// Parâmetro  nTipo
// 1 - Monta com Todas Empresas/Filiais
// 2 - Monta só com Empresas
// 3 - Monta só com Filiais de uma Empresa
//
// Parâmetro  aMarcadas
// Vetor com Empresas/Filiais pré marcadas
//
// Parâmetro  cEmpSel
// Empresa que será usada para montar seleção
//---------------------------------------------
Local   aSalvAmb := GetArea()
Local   aSalvSM0 := {}
Local   aRet     := {}
Local   aVetor   := {}
Local   oDlg     := NIL
Local   oChkMar  := NIL
Local   oLbx     := NIL
Local   oMascEmp := NIL
Local   oMascFil := NIL
Local   oButMarc := NIL
Local   oButDMar := NIL
Local   oButInv  := NIL
Local   oSay     := NIL
Local   oOk      := LoadBitmap( GetResources(), "LBOK" )
Local   oNo      := LoadBitmap( GetResources(), "LBNO" )
Local   lChk     := .F.
Local   lOk      := .F.
Local   lTeveMarc:= .F.
Local   cVar     := ""
Local   cNomEmp  := ""
Local   cMascEmp := "??"
Local   cMascFil := "??"

Local   aMarcadas  := {}


If !MyOpenSm0(.F.)
	Return aRet
EndIf


dbSelectArea( "SM0" )
aSalvSM0 := SM0->( GetArea() )
dbSetOrder( 1 )
dbGoTop()

While !SM0->( EOF() )

	If aScan( aVetor, {|x| x[2] == SM0->M0_CODIGO} ) == 0
		aAdd(  aVetor, { aScan( aMarcadas, {|x| x[1] == SM0->M0_CODIGO .and. x[2] == SM0->M0_CODFIL} ) > 0, SM0->M0_CODIGO, SM0->M0_CODFIL, SM0->M0_NOME, SM0->M0_FILIAL } )
	EndIf

	dbSkip()
End

RestArea( aSalvSM0 )

Define MSDialog  oDlg Title "" From 0, 0 To 270, 396 Pixel

oDlg:cToolTip := "Tela para Múltiplas Seleções de Empresas/Filiais"

oDlg:cTitle   := "Selecione a(s) Empresa(s) para Atualização"

@ 10, 10 Listbox  oLbx Var  cVar Fields Header " ", " ", "Empresa" Size 178, 095 Of oDlg Pixel
oLbx:SetArray(  aVetor )
oLbx:bLine := {|| {IIf( aVetor[oLbx:nAt, 1], oOk, oNo ), ;
aVetor[oLbx:nAt, 2], ;
aVetor[oLbx:nAt, 4]}}
oLbx:BlDblClick := { || aVetor[oLbx:nAt, 1] := !aVetor[oLbx:nAt, 1], VerTodos( aVetor, @lChk, oChkMar ), oChkMar:Refresh(), oLbx:Refresh()}
oLbx:cToolTip   :=  oDlg:cTitle
oLbx:lHScroll   := .F. // NoScroll

@ 112, 10 CheckBox oChkMar Var  lChk Prompt "Todos"   Message  Size 40, 007 Pixel Of oDlg;
on Click MarcaTodos( lChk, @aVetor, oLbx )

@ 123, 10 Button oButInv Prompt "&Inverter"  Size 32, 12 Pixel Action ( InvSelecao( @aVetor, oLbx, @lChk, oChkMar ), VerTodos( aVetor, @lChk, oChkMar ) ) ;
Message "Inverter Seleção" Of oDlg

// Marca/Desmarca por mascara
@ 113, 51 Say  oSay Prompt "Empresa" Size  40, 08 Of oDlg Pixel
@ 112, 80 MSGet  oMascEmp Var  cMascEmp Size  05, 05 Pixel Picture "@!"  Valid (  cMascEmp := StrTran( cMascEmp, " ", "?" ), cMascFil := StrTran( cMascFil, " ", "?" ), oMascEmp:Refresh(), .T. ) ;
Message "Máscara Empresa ( ?? )"  Of oDlg
@ 123, 50 Button oButMarc Prompt "&Marcar"    Size 32, 12 Pixel Action ( MarcaMas( oLbx, aVetor, cMascEmp, .T. ), VerTodos( aVetor, @lChk, oChkMar ) ) ;
Message "Marcar usando máscara ( ?? )"    Of oDlg
@ 123, 80 Button oButDMar Prompt "&Desmarcar" Size 32, 12 Pixel Action ( MarcaMas( oLbx, aVetor, cMascEmp, .F. ), VerTodos( aVetor, @lChk, oChkMar ) ) ;
Message "Desmarcar usando máscara ( ?? )" Of oDlg

Define SButton From 111, 125 Type 1 Action ( RetSelecao( @aRet, aVetor ), oDlg:End() ) OnStop "Confirma a Seleção"  Enable Of oDlg
Define SButton From 111, 158 Type 2 Action ( IIf( lTeveMarc, aRet :=  aMarcadas, .T. ), oDlg:End() ) OnStop "Abandona a Seleção" Enable Of oDlg
Activate MSDialog  oDlg Center

RestArea( aSalvAmb )
dbSelectArea( "SM0" )
dbCloseArea()

Return  aRet


//--------------------------------------------------------------------
/*{Protheus.doc} MarcaTodos
Função auxiliar para marcar/desmarcar todos os ítens do ListBox ativo

@param lMarca  Contéudo para marca .T./.F.
@param aVetor  Vetor do ListBox
@param oLbx    Objeto do ListBox

@author Ernani Forastieri
@since  27/09/2004
@version 1.0
*/
//--------------------------------------------------------------------
Static Function MarcaTodos( lMarca, aVetor, oLbx )
Local  nI := 0

For nI := 1 To Len( aVetor )
	aVetor[nI][1] := lMarca
Next nI

oLbx:Refresh()

Return NIL


//--------------------------------------------------------------------
/*{Protheus.doc} InvSelecao
Função auxiliar para inverter a seleção do ListBox ativo

@param aVetor  Vetor do ListBox
@param oLbx    Objeto do ListBox

@author Ernani Forastieri
@since  27/09/2004
@version 1.0
*/
//--------------------------------------------------------------------
Static Function InvSelecao( aVetor, oLbx )
Local  nI := 0

For nI := 1 To Len( aVetor )
	aVetor[nI][1] := !aVetor[nI][1]
Next nI

oLbx:Refresh()

Return NIL


//--------------------------------------------------------------------
/*{Protheus.doc} RetSelecao
Função auxiliar que monta o retorno com as seleções

@param aRet    Array que terá o retorno das seleções (é alterado internamente)
@param aVetor  Vetor do ListBox

@author Ernani Forastieri
@since  27/09/2004
@version 1.0
*/
//--------------------------------------------------------------------
Static Function RetSelecao( aRet, aVetor )
Local  nI    := 0

aRet := {}
For nI := 1 To Len( aVetor )
	If aVetor[nI][1]
		aAdd( aRet, { aVetor[nI][2] , aVetor[nI][3], aVetor[nI][2] +  aVetor[nI][3] } )
	EndIf
Next nI

Return NIL


//--------------------------------------------------------------------
/*{Protheus.doc} MarcaMas
Função para marcar/desmarcar usando máscaras

@param oLbx     Objeto do ListBox
@param aVetor   Vetor do ListBox
@param cMascEmp Campo com a máscara (???)
@param lMarDes  Marca a ser atribuída .T./.F.

@author Ernani Forastieri
@since  27/09/2004
@version 1.0
*/
//--------------------------------------------------------------------
Static Function MarcaMas( oLbx, aVetor, cMascEmp, lMarDes )
Local cPos1 := SubStr( cMascEmp, 1, 1 )
Local cPos2 := SubStr( cMascEmp, 2, 1 )
Local nPos  := oLbx:nAt
Local nZ    := 0

For nZ := 1 To Len( aVetor )
	If cPos1 == "?" .or. SubStr( aVetor[nZ][2], 1, 1 ) == cPos1
		If cPos2 == "?" .or. SubStr( aVetor[nZ][2], 2, 1 ) == cPos2
			aVetor[nZ][1] := lMarDes
		EndIf
	EndIf
Next

oLbx:nAt := nPos
oLbx:Refresh()

Return NIL


//--------------------------------------------------------------------
/*{Protheus.doc} VerTodos
Função auxiliar para verificar se estão todos marcados ou não

@param aVetor   Vetor do ListBox
@param lChk     Marca do CheckBox do marca todos (referncia)
@param oChkMar  Objeto de CheckBox do marca todos

@author Ernani Forastieri
@since  27/09/2004
@version 1.0
*/
//--------------------------------------------------------------------
Static Function VerTodos( aVetor, lChk, oChkMar )
Local lTTrue := .T.
Local nI     := 0

For nI := 1 To Len( aVetor )
	lTTrue := IIf( !aVetor[nI][1], .F., lTTrue )
Next nI

lChk := IIf( lTTrue, .T., .F. )
oChkMar:Refresh()

Return NIL


//--------------------------------------------------------------------
/*{Protheus.doc} MyOpenSM0
Função de processamento abertura do SM0 modo exclusivo

@author TOTVS Protheus
@since  29/04/2014
@obs    Gerado por EXPORDIC - V.4.19.9.2 EFS / Upd. V.4.17.9 EFS
@version 1.0
*/
//--------------------------------------------------------------------
Static Function MyOpenSM0(lShared)

Local lOpen := .F.
Local nLoop := 0

For nLoop := 1 To 20
	dbUseArea( .T., , "SIGAMAT.EMP", "SM0", lShared, .F. )

	If !Empty( Select( "SM0" ) )
		lOpen := .T.
		dbSetIndex( "SIGAMAT.IND" )
		Exit
	EndIf

	Sleep( 500 )

Next nLoop

If !lOpen
	MsgStop( "Não foi possível a abertura da tabela " + ;
	IIf( lShared, "de empresas (SM0).", "de empresas (SM0) de forma exclusiva." ), "ATENÇÃO" )
EndIf

Return lOpen


/////////////////////////////////////////////////////////////////////////////
