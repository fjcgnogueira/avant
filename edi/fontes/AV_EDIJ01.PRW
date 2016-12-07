#INCLUDE "PROTHEUS.CH"
#INCLUDE "Totvs.ch"
#INCLUDE "FILEIO.ch"
#INCLUDE "TbiConn.ch"
#INCLUDE "AP5MAIL.CH"
                            
//--------------------------------------------------------------
/*/{Protheus.doc} Avant - PROJETO EDI TRANSPORTE
CONHECIMENTO DE TRANSPORTE RODOVIมRIO
Description : rotina para importar o EDI

@param xParam Parameter Description
@return xRet Return Description
@author  - cristian_werneck@hotmail.com
@since 23/05/2011
/*/
//--------------------------------------------------------------

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAV_EDIJ01 บAutor  ณCristian Werneck    บ Data ณ  12-20-11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRotina para a importacao do arquivo EDI - conhecimento de   บฑฑ
ฑฑบ          ณtransporte para uma tabela temporaria ZZ3                   บฑฑ
ฑฑบ          ณAp๓s a importa็ใo, outro scheduler serแ responsแvel para    บฑฑ
ฑฑบ          ณconverter a tabela ZZ3 para ZZ5. Isso foi obrigatorio por   บฑฑ
ฑฑบ          ณcausa da separa็ใo por filial                               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Avant                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

//Chamava via Schedule
User Function AV_EDIJ01(aParam)
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณaParam     |  [01]   |  [02]  |
	//ณ           | Empresa | Filial |
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	U_AV_EDIJA(.T.)
Return Nil

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Chamada de Usuario (Nao Setar para abrir Empresa)               ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
User Function AV_EDIJA(lSchedule)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local cTipo    		:= "Arquivos EDI (*.edi)    | *.EDI |"
Local cArqEDI  		:= ""
Local cArqTxt  		:= "log_"+CriaTrab(nil, .f. )+".Log"
Local cEOL       	:= ( CHR( 13 ) + CHR( 10 ) )
Local lRetorno		:= .T.
Local lErro			:= .F.
Local cHTML			:= ""

Private aLogs    	:= {} // Array utilizado para gerar um LOG de inconsistencia
Private cCaption 	:= "importacao do arquivo EDI"
Private _aArrEmp 	:= {} //Carregar um array com o codigo, filial, cgc e nome das empresas

Default lSchedule	:= .F.

AADD( aLogs, 'Importacao do arquivo EDI para o conhecimento de transporte' )
AADD( aLogs, 'Rotina executada via scheduler automatico' )
                                                          
ConOut(" === AV_EDIJ01.PRW ===")

ConOut( "Arquivo de LOG..." + cArqTxt )
	
If lSchedule
	ConOut(" === Rotina sendo Executada Via Schedule ===")
	PREPARE ENVIRONMENT EMPRESA ( aParam[01] ) FILIAL ( aParam[02] ) MODULO "COM"
	ConOut("Aberto Empresa...: " + SM0->M0_NOME)
	ConOut("Aberto Filial....: " + SM0->M0_FILIAL)
Else
	ConOut(" === Rotina sendo Executada por Usuแrio ===")
EndIf

__aFiles   	:= {}
cPathIni   	:= Alltrim(GetPvProfString(GetEnvServer(),"Rootpath","",GetADV97()))
cTargetDir 	:= cPathIni+GetSrvProfString("Startpath","")
cPathEDI 	:= GETNEWPAR("AV_DIRCNH", cTargetDir) // defini็ใo do diret๓rio onde se encontram os arquivos EDI para o conhecimento de transporte

AADD( aLogs, "Variaveis de controle" )
AADD( aLogs, "Patch de captura dos arquivos: " + cPathEDI )
AADD( aLogs, "GetEnvServer                 : " + GetEnvServer() )
AADD( aLogs, "M๓dulos abertos              : " + "SIGACOM" )
AADD( aLogs, Replicate('-', 160) )

ConOut( cPathEDI + "conemb*.edi" )
ADir(cPathEDI + "conemb*.edi", __aFiles)
ConOut('Processar ' + StrZero(Len(__aFiles),6) + ' arquivos')

AADD( aLogs, 'Processar ' + StrZero(Len(__aFiles),6) + ' arquivos'  )
AADD( aLogs, Replicate('-', 160) )
AADD( aLogs, "Carregando defini็๕es das empresas registradas no SIGAMAT" )

U_AV_EDIEMP(@_aArrEmp)	//Carregar um array com o codigo, filial, cgc e nome das empresas

For __i := 1 to Len(__aFiles)
	ConOut( "Importando arquivo EDI..." + cPathEDI + __aFiles[__i]		)
	AADD( aLogs, "Importando arquivo EDI..." + cPathEDI+__aFiles[__i] 	)
	lRetorno := U_AV_EDIPRC(cPathEDI + __aFiles[__i], .F.)
	If !lRetorno
		lErro := .T.
	EndIf
Next

nHdl := fCreate( cArqTxt )
If ( nHdl <> -1 ) // Se nao houve erro na criacao do texto no sistema operacional.
ConOut( "aberto o arquivo de LOG..." + cArqTxt )
	For _x := 1 to Len(aLogs)
		cLin := aLogs[_x] + cEOL
		fWrite( nHdl, cLin, Len( cLin ) )
	Next
	fClose( nHdl ) // Fechando arquivo texto aos geracao.
Else
ConOut( "erro na cria็ใo do arquivo de LOG..." + cArqTxt )
	For _x := 1 to Len(aLogs)
		ConOut( aLogs[_x] )
	Next
EndIf

If lErro
	U_SENDMAEDI(GetSrvProfString("Startpath","") + cArqTxt, "Leitura de Arquivo de Transporte")
EndIf

If lSchedule
	RESET ENVIRONMENT
EndIf

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSENDMAEDI บAutor  ณ Amedeo D. P. Filho บ Data ณ  16/02/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Envia e-mail do erro na Leitura do Arquivo.                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AVAN                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function SENDMAEDI(cAnexo, cAssunto)
	Local cError    := ""
	Local cCorpo	:= ""
	Local cSubject	:= cAssunto
	Local cTo		:= SuperGetMV("AV_MAILEDI", Nil, "it2@avantsp.com.br;helpdesk@avantsp.com.br")
//	Local cTo		:= SuperGetMV("AV_MAILEDI", Nil, "cristian.verneque@mpsiga.com.br")
	Local cPassword	:= Trim(GetMV("MV_RELPSW"))
	Local cServer	:= Trim(GetMV("MV_RELSERV"))
	Local cAccount	:= Trim(GetMV("MV_RELACNT"))
	Local cFrom		:= Trim(GetMV("MV_RELACNT"))
	Local lAuth    	:= GetNewPar("MV_RELAUTH",.F.)
	Local lEnviado	:= .T.
	Local lConnect	:= .T.

	CONNECT SMTP SERVER cServer ACCOUNT cAccount PASSWORD cPassword RESULT lConnect
	
	If lAuth
	  lRetAuth := MailAuth(cAccount,cPassword)
	Else
	  lRetAuth := .T.
	EndIf

	ConOut(" ==== Enviando E-Mail ==== ")
	ConOut("De   : " + cFrom	)
	ConOut("Para : " + cTo		)
	
	cCorpo +=" <!DOCTYPE html PUBLIC '-//W3C//DTD XHTML 1.0 Transitional//EN' 'http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd'>
	cCorpo +="  <html xmlns='http://www.w3.org/1999/xhtml'>
	cCorpo +="  <head>
	cCorpo +="  <meta http-equiv='Content-Type' content='text/html; charset=iso-8859-1' />
	cCorpo +="  <title>Untitled Document</title>
	cCorpo +="  </head>
	cCorpo +="  <body>
	cCorpo +="  <div>
	cCorpo +="  <table width='1000' border='0' align='center'>
	cCorpo +="    <tr>
	cCorpo +="      <td><div align='left'>Erro ao Processar Arquivo de Transportadora, Verifique arquivo Anexo.</div></td>
	cCorpo +="    </tr>
	cCorpo +="  </table>
	cCorpo +="  </div>
	cCorpo +="  </body>
	cCorpo +="  </html>

	If lRetAuth 
		SEND MAIL FROM cFrom TO cTO SUBJECT cSubject BODY cCorpo ATTACHMENT cAnexo RESULT lEnviado
		If !lEnviado
			GET MAIL ERROR cError
			ConOut("Erro ao Enviar E-Mail : " + cError)
		Else
			ConOut("E-Mail enviado com Sucesso")
		EndIf
	Else
		ConOut("Erro ao autenticar no servidor de e-mail")
	EndIf
	
	DISCONNECT SMTP SERVER
 
Return