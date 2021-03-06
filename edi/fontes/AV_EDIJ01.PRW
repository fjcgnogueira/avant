#INCLUDE "PROTHEUS.CH"
#INCLUDE "Totvs.ch"
#INCLUDE "FILEIO.ch"
#INCLUDE "TbiConn.ch"
#INCLUDE "AP5MAIL.CH"
                            
//--------------------------------------------------------------
/*/{Protheus.doc} Avant - PROJETO EDI TRANSPORTE
CONHECIMENTO DE TRANSPORTE RODOVI�RIO
Description : rotina para importar o EDI

@param xParam Parameter Description
@return xRet Return Description
@author  - cristian_werneck@hotmail.com
@since 23/05/2011
/*/
//--------------------------------------------------------------

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �AV_EDIJ01 �Autor  �Cristian Werneck    � Data �  12-20-11   ���
�������������������������������������������������������������������������͹��
���Desc.     �Rotina para a importacao do arquivo EDI - conhecimento de   ���
���          �transporte para uma tabela temporaria ZZ3                   ���
���          �Ap�s a importa��o, outro scheduler ser� respons�vel para    ���
���          �converter a tabela ZZ3 para ZZ5. Isso foi obrigatorio por   ���
���          �causa da separa��o por filial                               ���
�������������������������������������������������������������������������͹��
���Uso       � Avant                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

//Chamava via Schedule
User Function AV_EDIJ01(aParam)
	//������������������������������Ŀ
	//�aParam     |  [01]   |  [02]  |
	//�           | Empresa | Filial |
	//��������������������������������
	U_AV_EDIJA(.T.)
Return Nil

//�������������������������������������������������������������������
//� Chamada de Usuario (Nao Setar para abrir Empresa)                �
//�������������������������������������������������������������������
User Function AV_EDIJA(lSchedule)

//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������
//Local cTipo    		:= "Arquivos EDI (*.edi)    | *.EDI |"
//Local cArqEDI  		:= ""
Local cArqTxt  		:= "\neogrid\LOGS\log_"+CriaTrab(nil, .f. )+".Log"
Local cEOL       	:= ( CHR( 13 ) + CHR( 10 ) )
Local lRetorno		:= .T.
Local lErro			:= .F.
//Local cHTML			:= ""
Local __i
Local _x

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
	ConOut(" === Rotina sendo Executada por Usu�rio ===")
EndIf

__aFiles   	:= {}
cPathIni   	:= Alltrim(GetPvProfString(GetEnvServer(),"Rootpath","",GetADV97()))
cTargetDir 	:= cPathIni+GetSrvProfString("Startpath","")
cPathEDI 	:= GETNEWPAR("AV_DIRCNH", cTargetDir) // defini��o do diret�rio onde se encontram os arquivos EDI para o conhecimento de transporte

AADD( aLogs, "Variaveis de controle" )
AADD( aLogs, "Patch de captura dos arquivos: " + cPathEDI )
AADD( aLogs, "GetEnvServer                 : " + GetEnvServer() )
AADD( aLogs, "M�dulos abertos              : " + "SIGACOM" )
AADD( aLogs, Replicate('-', 160) )

ConOut( cPathEDI + "conemb*.edi" )
ADir(cPathEDI + "conemb*.edi", __aFiles)
ConOut('Processar ' + StrZero(Len(__aFiles),6) + ' arquivos')

AADD( aLogs, 'Processar ' + StrZero(Len(__aFiles),6) + ' arquivos'  )
AADD( aLogs, Replicate('-', 160) )
AADD( aLogs, "Carregando defini��es das empresas registradas no SIGAMAT" )

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
ConOut( "erro na cria��o do arquivo de LOG..." + cArqTxt )
	For _x := 1 to Len(aLogs)
		ConOut( aLogs[_x] )
	Next
EndIf

If lErro
	U_SENDMAEDI(cArqTxt, "Leitura de Arquivo de Transporte")
EndIf

If lSchedule
	RESET ENVIRONMENT
EndIf

Return Nil

/*
�������������������������������������������������������������������������������������
�������������������������������������������������������������������������������������
���������������������������������������������������������������������������������ͻ��
���Programa  � SENDMAEDI   � Autor � Amedeo D. P. Filho         � Data �16/02/2012���
���������������������������������������������������������������������������������͹��
���Desc.     � Envia e-mail do erro na Leitura do Arquivo.                        ���
���������������������������������������������������������������������������������͹��
���Uso       � Especifico AVANT.                   	                              ���
���������������������������������������������������������������������������������͹��
���Analista Responsavel�   Data   � Manutencao Efetuada                           ���
���������������������������������������������������������������������������������͹��
���Fernando Nogueira   �24/08/2017� Troca do Connect SMTP pelo WorkFlow           ���
���������������������������������������������������������������������������������ͼ��
�������������������������������������������������������������������������������������
�������������������������������������������������������������������������������������
*/
User Function SENDMAEDI(cAnexo, cAssunto)

Local cPara		:= SuperGetMV("AV_MAILEDI", Nil,"tecnologia@avantlux.com.br")
Local cArquivo	:= "\MODELOS\AVISOCONEMB.HTM"

Private oProcess
Private oHtml

ConOut(" ==== Enviando E-Mail ==== ")
ConOut("Para : " + cPara)
ConOut("Arquivo anexo: " + cAnexo +" Existe?: "+cValToChar(File(cAnexo)))

oProcess := TWFProcess():New("AVISOCONEMB","AVISO CONEMB")
oProcess:NewTask("Enviando Aviso",cArquivo)
oHtml := oProcess:oHTML
oProcess:cSubject := cAssunto + " ["+AllTrim(SM0->M0_CODFIL)+" / "+AllTrim(SM0->M0_FILIAL)+"]"
oProcess:USerSiga := "000000"
oProcess:cTo  := cPara
oProcess:cCC  := ""
oProcess:cBCC := ""
oProcess:AttachFile(cAnexo)
oProcess:Start()
oProcess:Finish()
 
Return