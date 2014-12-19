#INCLUDE 'PROTHEUS.CH'
#INCLUDE "FILEIO.CH"
#include 'apwebex.ch'
#Define ENTER Chr(13)+Chr(10)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ acr_upload()º Autor ³ Fernando Nogueira  º Data ³23/10/2013º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Efetua UpLoad do anexo do chamado...					    	  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico AVANT.                   	                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÏÍÍÍÑÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAnalista Resp.³  Data  ³ Manutencao Efetuada                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º              ³  /  /  ³                                               º±±
±±º              ³  /  /  ³                                               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function acr_upload()

	Local nH   := FOpen( httpPost->cFile, 64 )
	Local nLi  := 1
	Local cHtml:= ""
	Local cOk  := ''
	Local cArqNv := ''

	Private LengthFile := 0
	Private cArquivo   := HttpPost->CFILE
	Private cArqDest   := '\web\ws\anexos\'+HttpPost->CCHAMADO+'\'
	Private cEmpAnt    := '01'
	Private cFilAnt    := '010104'

	MakeDir(cArqDest) //Cria pasta com o numero do chamado
    LengthFile := fSeek( nH, 0, FS_END )
    fClose(nH)
    
	WEB EXTENDED INIT cHtml

		// Seta job para nao consumir licensas
		RpcSetType(3)

		// Seta job para empresa filial desejadas
		RPCSetEnv(cEmpAnt,cFilAnt,,,'FAT')

		DbSelectArea("SZV")
		DbSetOrder(1)
		If DbSeek( xFilial("SZV") + HttpPost->CCHAMADO)
			While !SZV->(Eof()) .And. SZV->ZV_FILIAL+SZV->ZV_CHAMADO == xFilial("SZV")+HttpPost->CCHAMADO
				nLi ++
				DbSelectArea("SZV")
				DbSkip()
			End
		Endif

		cArqDest += StrZero(nLi++,3)

	    If File(cArquivo)
		    MakeDir(cArqDest) //Cria pasta com o item do chamado
			COPY FILE &cArquivo To &(cArqDest+HttpPost->CFILE)
			Delete File &cArquivo

			_cArqZip := cArqDest+'\'+HttpPost->CCHAMADO+'.zip'
			GzCompress(cArqDest+HttpPost->CFILE,_cArqZip,"")

			If !File(_cArqZip) //Caso nao tenha sucesso na compactacao do arquivo, anexa arquivo assim mesmo
				cArqNv := NoAcento(RemoveAcento(cArqDest+HttpPost->CFILE))

			    If at(' ',cArqNv) <> 0
			    	cArqNv := lower(StrTran(alltrim(cArqNv), " " ,"_" ))
			    EndIf

			    FRename((cArqDest+HttpPost->CFILE),cArqNv)
			Else
				Ferase(cArqDest+HttpPost->CFILE)
				cArqNv := cArqDest+'\'+HttpPost->CCHAMADO+'.zip'
			EndIf
						
		Else
			cOk += '					  <p align="center" class="titulo"><img src="images\alert.png" border="0">N&atilde;o foi poss&iacute;vel localizar o arquivo. Por favor, tente mais tarde.</p>
		EndIf

		cHtml += '<html>
		cHtml += '<head>
		cHtml += '		<link rel="stylesheet" type="text/css" href="bti.css">
		cHtml += '<!--
		cHtml += '		<style type="text/css">
		cHtml += '            #tooltip{
		cHtml += '                background:#FFF;
		cHtml += '                border:1px solid #000;
		cHtml += '                display:none;
		cHtml += '                padding:3px;
		cHtml += '            }
		cHtml += '        </style>
		cHtml += '        <script src="tooltip.js" type="text/javascript"></script>
		cHtml += '        <script language="JavaScript" type="text/javascript">
		cHtml += '            window.onload = function(){
		cHtml += '                tooltip.init();
		cHtml += '            }
		cHtml += '        </script>
		cHtml += '-->
		cHtml += '<style type="text/css">
		cHtml += '<!--
		cHtml += '.style5 {color: #FFFFFF}
		cHtml += '.style6 {font-size: 12}
		cHtml += '.style11 {font-size: 12px}
		cHtml += '.style15 {font-size: 18px; font-weight: bold; }
		cHtml += '.style22 {font-size: 8px}
		cHtml += '.style26 {font-size: 18px}
		cHtml += '-->
		cHtml += '</style>
		cHtml += '</head>
		cHtml += '<body>
		cHtml += '<script language="JavaScript">
		cHtml += '	if (document.all)
		cHtml += '		document.body.style.cssText="background:white url(images2/BTI_A_02.gif) no-repeat fixed center top"
		cHtml += '</script>
		cHtml += '<div align="center">
		cHtml += '	<table width="100%" height="401" border="0" align="Center" cellpadding="0" cellspacing="0" bordercolor="#333333" id="table1">
		cHtml += '		<tr>
		cHtml += '			<td width="100%" height="399"> 

		If !Empty(cOk)
			cHtml += cOk
		ElseIf !File(cArqNv)
			cHtml += '					  <p align="center" class="titulo"><img src="images\alert.png" border="0">N&atilde;o foi poss&iacute;vel localizar arquivo. Por favor, tente mais tarde.</p>	
		Else
			cHtml += '					  <p align="center" class="titulo"><img src="images\success.png" border="0">Arquivo enviada com sucesso.</p>
		
			DbSelectArea("SZV")  
			RecLock( "SZV" , .T. )
				SZV->ZV_FILIAL	:= xFilial("SZV")
				SZV->ZV_CHAMADO	:= HttpPost->CCHAMADO
				SZV->ZV_DATA	:= ddatabase
				SZV->ZV_TIPO	:= "024"
				SZV->ZV_CODSYP	:= u_GrvMemo( 'Foi enviado o anexo '+'<a href="http://192.168.0.8:8088/'+StrTran(alltrim(substr(cArqNv,12,300)), "\" ,"/" )+'" target="_blank">'+Substr(Alltrim(HttpPost->CFILE),2,200)+'</a>'+ENTER+ENTER+'[Contato: '+alltrim(httpSession->__cNome)+']' , "ZV_CODSYP" )
				SZV->ZV_NUMSEQ	:= u_RetZVNum( HttpPost->CCHAMADO )
				SZV->ZV_HORA	:= Time()
				SZV->ZV_TECNICO	:= "AUTO"
			MsUnLock()

			u_OpenProc(HttpPost->CCHAMADO,'C')
			
		EndIf
		
		cHtml += '			<p align="center" class="titulo">&nbsp;</p>
		cHtml += '			<p align="center" class="titulo">&nbsp;</p>
		cHtml += '			<p align="center" class="titulo">&nbsp;</p>
		cHtml += '			<form method="POST" action="" name="form1">
		cHtml += '				<table width="100%" border="0" cellspacing="0" id="table2">
		cHtml += '                    <tr>
		cHtml += '						<td width="67" align="left" bgcolor="#FFFFFF" class="news style5 style6">&nbsp;</td>
		cHtml += '			        </tr>
		cHtml += '					<tr>
		cHtml += '					  <td>&nbsp;</td>
		cHtml += '				  </tr>
		cHtml += '				  <tr>
		cHtml += '					  <td align="right" valign="top">
		cHtml += '					    <p align="right">
		cHtml += '					  <font color="#000080" size="2" face="Tahoma">
		cHtml += '					  <a href="paginaprincipal.htm">Voltar</a></font></td>
		cHtml += '				  </tr>
		cHtml += '			  </table>
		cHtml += '			</form>
		cHtml += '		  </td>
		cHtml += '		</tr>
		cHtml += '  </table>
		cHtml += '</div>
		cHtml += '</body>
		cHtml += '</html>

		//-- Encerra Ambiente
		RpcClearEnv(.T.)

	WEB EXTENDED END

Return(cHtml)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³ RemoveAcentoº Autor ³ Fernando Nogueira  º Data ³23/10/2013º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Remove acentos/caracteres especiais... 			    		  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function RemoveAcento(cString)

	Local nX        := 0 
	Local nY        := 0 
	Local cSubStr   := ""
	Local cRetorno  := ""
	
	Local cStrEsp	:= "ÁÃÂÀáàâãÓÕÔóôõÇçÉÊéêºíìÍÌúùÚÙ"  
	Local cStrEqu   := "AAAAaaaaOOOoooCcEEeeriiIIuuUU" //char equivalente ao char especial
	
	For nX:= 1 To Len(cString)
		cSubStr := SubStr(cString,nX,1)
		nY := At(cSubStr,cStrEsp)
		If nY > 0 
			cSubStr := SubStr(cStrEqu,nY,1)
		EndIf
	    
		cRetorno += cSubStr
	Next nX
	
Return cRetorno