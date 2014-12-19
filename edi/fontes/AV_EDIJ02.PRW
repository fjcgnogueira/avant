#INCLUDE "PROTHEUS.CH"           
#INCLUDE "Totvs.ch"
#INCLUDE "FILEIO.ch"
#INCLUDE "TbiConn.ch"
#INCLUDE "AP5MAIL.CH"

//--------------------------------------------------------------
/*/{Protheus.doc} Avant - PROJETO EDI TRANSPORTE
CONHECIMENTO DE TRANSPORTE RODOVIÁRIO
Description : rotina para importar o EDI - DOCCOB

@param xParam Parameter Description
@return xRet Return Description
@author  - cristian_werneck@hotmail.com
@since 23/05/2011
/*/
//--------------------------------------------------------------

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AV_EDIJ02 ºAutor  ³Cristian Werneck    º Data ³  12-20-11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina para a importacao do arquivo EDI - documento de cobr.º±±
±±º          ³transporte para uma tabela temporaria ZZ4, gerar a nota fis-º±±
±±º          ³cal de entrada e o documento de conhecimento de transporte  º±±
±±º          ³SF1-SD1-SF7                                                 º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Avant                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

//Chamava via Schedule
User Function AV_EDIJ2()
	U_AV_EDIJB(.T.)
Return Nil

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Chamada de Usuario (Nao Setar para abrir Empresa)               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
User Function AV_EDIJB(lSchedule)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local cTipo    		:= "Arquivos EDI (*.edi)    | *.EDI |"
Local cArqEDI  		:= ""
Local cEOL       	:= ( CHR( 13 ) + CHR( 10 ) )
Local lRetorno		:= .T.
Local lErro			:= .F.
Local cHTML			:= "" 
Local lCritico		:= .F.
Local cFileLog		:= ""

Private aLogs    	:= {} // Array utilizado para gerar um LOG de inconsistencia
Private cCaption 	:= "importacao do arquivo EDI-DocCob"

Private lRead	 := .F.

Default lSchedule	:= .F.

AutoGrLog('Importacao do arquivo EDI para o documento de cobranca - DOCCOB')
AutoGrLog( 'Rotina executada via scheduler automatico' )
                                                          
ConOut(" === AV_EDIJ02.PRW ===")
	
If lSchedule
	ConOut(" === Rotina sendo Executada Via Schedule ===")
	PREPARE ENVIRONMENT EMPRESA ( "01" ) FILIAL ( "010101" ) MODULO "COM"
	ConOut("Aberto Empresa...: " + SM0->M0_NOME)
	ConOut("Aberto Filial....: " + SM0->M0_FILIAL)
Else
	ConOut(" === Rotina sendo Executada por Usuário ===")
EndIf

__aFiles   	:= {}
cPathIni   	:= Alltrim(GetPvProfString(GetEnvServer(),"Rootpath","",GetADV97()))
cTargetDir 	:= cPathIni+GetSrvProfString("Startpath","")
cPathEDI 	:= GETNEWPAR("AV_DIRCNH", cTargetDir) // definição do diretório onde se encontram os arquivos EDI para o conhecimento de transporte

AutoGrLog( "Variaveis de controle" )
AutoGrLog( "Patch de captura dos arquivos: " + cPathEDI )
AutoGrLog( "GetEnvServer                 : " + GetEnvServer() )
AutoGrLog( "Módulos abertos              : " + "SIGACOM" )
AutoGrLog( Replicate('-', 160) )

ConOut( cPathEDI + "doccob*.edi" )
ADir(cPathEDI + "doccob*.edi", __aFiles)
ConOut('Processar ' + StrZero(Len(__aFiles),6) + ' arquivos')

AutoGrLog( 'Processar ' + StrZero(Len(__aFiles),6) + ' arquivos'  )
AutoGrLog( Replicate('-', 160) )
AutoGrLog( "Carregando definições das empresas registradas no SIGAMAT" )

For __i := 1 to Len(__aFiles)
	ConOut( "Importando arquivo EDI-DOCCOB..." + cPathEDI + __aFiles[__i]		)
	AutoGrLog( "Importando arquivo EDI-DOCCOB..." + cPathEDI+__aFiles[__i] 	)
	lRetorno := U_AV_IMPCB(cPathEDI + __aFiles[__i], @cFileLog, @lCritico, __i, .f.)
	If !lRetorno
		lErro := .T.
	EndIf
Next

cFileLog := NomeAutoLog()

If lErro
	U_SENDMAEDI(GetSrvProfString("Startpath","") + cFileLog, "Leitura de Arquivo de Transporte")
EndIf

If lSchedule
	RESET ENVIRONMENT
EndIf

Return Nil