#INCLUDE "PROTHEUS.CH"
#INCLUDE "TbiConn.ch"        

/*
/******************************************************************************************/
/* Projeto EDI de Transporte - NOTFIS					  													*/
/* Criado por: Mario Gines																						*/
/* Data: 14/12/11																									*/
/* Revisใo: 01																										*/
/******************************************************************************************/

/***********************************************************************************************************************/
// Informa็ใo importante para composi็ใo da estrutura do TXT                                                           */
/* A = Indica que o campo ้ alfanumerico e o conteudo deve ser alinhado a esquerda e completado com espa็os a direita  */
/* N = Indica que o campo ้ numerido e o conteudo deve ser alinhado a direita e preenchido com zeros a esquerda.       */
/* 9 = O numero apos a letra, indica o tamanho ocupado pelo campo. Caso o campo possua alguma casa decimal, por exemplo*/
/* campo de valor, a representa็ใo serแ 9,2, onde 9 ้ o numero de casas inteiras e 2 o numero de casas decimais.	 	  */
/***********************************************************************************************************************/
*/

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSchedNF   บAutor  ณCristiam Rossi      บ Data ณ  03/01/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Rotina para chamada da gera็ใo do arquivo de remessa EDI   บฑฑ
ฑฑบ          ณ via Schedule                                               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ LPS - Avant                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function SchedNFAv()
Local aEmpresas := {}
Local nJ

ConOut(" === SCHEDNFAV da rotina NOTFISAV.PRW ===")

	RPCSetType(3) //nใo consumir licen็a.
	dbUseArea(.T., "DBFCDX", "sigamat.emp","SIGAMAT",.T.,.T.)

	while ! Eof()
		if SIGAMAT->M0_CODIGO != "99"
			aadd(aEmpresas, {SIGAMAT->M0_CODIGO, SIGAMAT->M0_CODFIL} )
		endif
		dbSkip()
	end

	DbCloseArea()

	for nJ := 1 to len(aEmpresas)
		LjPreparaWs(aEmpresas[nJ,1], aEmpresas[nJ,2])
		SM0->(DBSEEK(aEmpresas[nJ,1] + aEmpresas[nJ,2]))
		u_NotFisAv()	// chamada da Rotina normal
	next
Return nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ NotFisAv บ Autor ณ Cristiam Rossi     บ Data ณ  03/01/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao auxiliar de usuario                                 บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ LPS - Avant                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function NotFisAv()
Private aTransp    := {}
Private cSequence  := "00"	// diferencial para nใo duplicar o nome do arquivo. Cristiam Rossi em 03/01/2012

	SA1->(dbSetOrder(1))
	SA4->(dbSetOrder(1))
	SD2->(dbSetOrder(3))
	SC5->(dbSetOrder(1))
	SB1->(dbSetOrder(1))
	SF4->(dbSetOrder(1))
	SF2->(dbSetOrder(1))

//	Processa( {|| GeraTXT() },"Aguarde" ,"Gerando arquivo TXT...")
	GeraTXT()
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ GeraTXT  บ Autor ณ Cristiam Rossi     บ Data ณ  03/01/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao auxiliar                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ LPS - Avant                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function GeraTXT()
Local nI

	If Select("TMP") > 0
		TEMP->(dbCloseArea())
	EndIf

	cQuery := "SELECT A4_COD FROM "+RetSQLName("SA4")+" WHERE A4_FILIAL='"+xFilial("SA4")+"' "
	cQuery += "AND D_E_L_E_T_ = '' AND A4_VIAEDI = 'S' ORDER BY A4_COD"
	dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"TEMP", .F., .T.)
	
	While !TEMP->(Eof())
		aadd(aTransp, TEMP->A4_COD)
		TEMP->(DbSkip())
	End
	TEMP->(dbCloseArea())
	
	
	For nI := 1 To Len(aTransp)
		SA4->(DBSEEK(XFILIAL('SA4') + aTransp[nI], .T.))
		
		//Gera layout para a NeoGrid se o mesmo contiver dados.
 		fGerLayout(aTransp[nI])
	Next
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfGerLayoutบ Autor ณ Cristiam Rossi     บ Data ณ  03/01/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao auxiliar                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ LPS - Avant                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
//Gera o layout em cima da nota que foi escolhida pelo usuario, apenas para as Transportadoras
Static Function fGerLayout(cTransp)
Local nIdTp000			:= ""
Local cCxPosRem		:= ""				//Nome da caixa postal do remetente
Local cCxPosDes		:= ""				//Nome da caixa postal do destinatario
Local cNomeArq			:= ""
Local cData				:= 0
Local cHora				:= 0
Local cIdInter			:= ""				//Identifica็ใo do Intercambio.
Local cFilTp000		:= Space(145)
Local cCabec000		:= Space(240)
Local nIdTp310			:= ""
Local cFilTp310		:= Space(223)
Local cCabec310		:= Space(240)
Local nIdTp311			:= ""
Local nCNPJEmb			:= 0	 		// CNPJ da embarcadora
Local cIEEmb			:= "" 		// IE da embarcadora
Local cEndEmb			:= ""			// Endere็o da embarcadora
Local cCidEmb			:= ""			// Cidade da embarcadora
Local cCepEmb			:= ""			// Cep da embarcadora
Local cEstEmb			:= ""			// Estado da embarcadora
Local nDtEmb			:= 0			// Data do embarque das mercadorias
Local cRazEmb 			:= ""			// Razใo social da empresa embarcadora
Local cFilTp311		:= Space(067)
Local cDados311		:= Space(240)
Local nIdTp312			:= ""
Local cRazDest			:= ""			// Razao social do destinatario
Local nCNPJDest		:= 0			// CNPJ do destinatario
Local cIEDest			:= ""			// IE do destinatario
Local cEndDest			:= ""			// Endere็o do destinatario
Local cBairDest		:= ""			// Bairro do destinatario
Local cCidDest			:= ""			// Cidade do destinatario
Local cCepDest			:= ""			// Cep do destinatario
Local cCodMun			:= ""
Local cEstDest			:= ""			// Estado do destinatario
Local cArefret			:= ""			// Area do frente (Tabela acordada entre embarcadora e transportadora)
Local cTelDest			:= ""			// Numero de comunica็ใo ("Telefone, Fax, Telex e etc.)
Local cTpDest			:= ""			// Tipo de Identifica็ใo (1=CGC;2=CPF)
Local cTpEDest			:= ""			// Tipo de Estabelecimento do destino da mercadoria.
Local cFilTp312		:= Space(005)
Local cDados312		:= Space(240)
Local nIdTp313			:= ""
Local cNumRom			:= ""				//Numero de Romaneio
Local cCodRota			:= ""				//Codigo da Rota
Local nMeioTran		:= 0				//Meio de Transporte
Local nTpTraCar		:= 0				//Tipo de Transporte de Carga
Local nTpCar			:= 0				//Tipo de Carga
Local cCondFre			:= ""				//Condi็ใo de Frete
Local cSerie			:= ""				//Serie Nota Fiscal
Local nNumNF			:= 0				//Numero da Nota Fiscal
Local nDtEmis			:= 0				//Data de emissao
Local cTpNatur			:= ""				//Tipo de natureza
Local cEspecie			:= ""				//Especie de Adicionamento
Local nQtdVol			:= 0				//Qtde de volumes
Local nVltTot			:= 0				//Valor Total da Nota
Local nPesTotM			:= 0				//Valor Total das mercadorias
Local nPesoDens		:= 0				//Peso da Densidade
Local nIncIcms			:= ""				//S=Sim;N=Nao;I=Isento
Local cSegEfet			:= ""				//S=Sim;N=Nao
Local nVlrSeg			:= 0				//Valor do Seguro
Local nVlrCob			:= 0				//Valor a ser cobrado
Local cPlaca			:= ""				//Placa do caminhao
Local cPlanoCar		:= ""				//Plano de carga (S=Sim;N=Nao)
Local nVlrFretP		:= 0				//Valor do frete Peso-Volume
Local nVlrAd			:= 0				//Valor Adicional
Local nVlrTxs			:= 0				//Valor das taxas envolvidas no transporte
Local nVlrFret			:= 0 				//Valor total do frete
Local cAcaoDoc			:= ""				//A็ใo do Documento (I=Inclusao;E=Exclusใo)
Local nVlrIcms			:= 0				//Valor do ICMS da Nota
Local nVlIcmRet 		:= 0				//Valor do ICMS Retido
Local cIndBonf			:= ""				//Indica็ใo de Bonifica็ใo (S=Sim;N=Nao)
Local cModFret			:= ""				//Modalidade de Frete
Local nIdTp314			:= ""
Local nQtdVol			:= 0				//Quantidade de volumes
Local cEspAcond		:= ""				//Especie de acondicionamento
Local cCodProd			:= ""				//Codigo do produto ou nome da mercadoria
Local cFilTp314 		:= Space(029)
Local nIdTp315			:= ""
Local cRazao			:= ""					//Razao Social
Local nCNPJ				:= 0					//CNPJ
Local cIE				:= ""					//Inscri็ใo Estadual
Local cEnd				:= ""					//Endere็o
Local cBairro			:= ""					//Bairro
Local cCidade			:= ""					//Cidade
Local cCep				:= ""					//Cep
Local cCodMun			:= ""					//Codigo do municipio
Local cEst				:= ""					//Estado
Local cTel				:= ""					//Telefone
Local cFilTp315		:= Space(11)
Local nIdTp316			:= ""
Local cRazao			:= ""					//Razao Social
Local nCNPJ				:= 0					//CNPJ
Local cIE				:= ""					//Inscri็ใo Estadual
Local cEnd				:= ""					//Endere็o
Local cBairro			:= ""					//Bairro
Local cCidade			:= ""					//Cidade
Local cCep				:= ""					//Cep
Local cCodMun			:= ""					//Codigo do municipio
Local cEst				:= ""					//Estado
Local cAreaFret		:= ""					//Area Teste
Local cTel				:= ""					//Telefone
Local cFilTp316		:= Space(11)
Local nIdTp317			:= ""
Local cRazao			:= ""					//Razao Social
Local nCNPJ				:= 0					//CNPJ
Local cIE				:= ""					//Inscri็ใo Estadual
Local cEnd				:= ""					//Endere็o
Local cBairro			:= ""					//Bairro
Local cCidade			:= ""					//Cidade
Local cCep				:= ""					//Cep
Local cCodMun			:= ""					//Codigo do municipio
Local cEst				:= ""					//Estado
Local cTel				:= ""					//Telefone
Local cFilTp317		:= Space(11)
Local nIdTp318			:= ""
Local nVlrTotal		:= 0					//Valor total das notas fiscais (somatoria do dados reg. 313")
Local nPesoTot			:= 0					//Peso total das notas fiscais  (somatoria do dados reg. 313")
Local nPesTotD			:= 0					//Peso total densidade/cubagem  (somatoria do dados reg. 313")
Local nQtdTotV			:= 0					//Quantidade total de volumas (somatoria do dados reg. 313")
Local nVlrTotC			:= 0					//Valor total a ser cobrado (somatoria do dados reg. 313")
Local nVlrTotS			:= 0					//Valor total do seguro (somatoria do dados reg. 313")
Local cFilTp318		:= Space(147)
Local cTotal318		:=Space(240)
Private aLinha 		:= {}

	cQuery := " SELECT * FROM "+RetSQLName("SF2")+" "
	cQuery += " WHERE F2_FILIAL='"+xFilial("SF2")+"' "
	cQuery += " AND D_E_L_E_T_ = '' "
	cQuery += " AND F2_TRANSP  = '"+cTransp+"' "
	cQuery += " AND F2_EDIEMIT = '' "
	cQuery += " AND (F2_FIMP = 'S' OR F2_FIMP = 'T') " //Amedeo (So NF que teve a DANFE Impressa ou Transmitida)
	cQuery += " ORDER BY F2_CLIENTE, F2_LOJA"
	cAlias := CriaTrab(,.F.)
	dbUseArea(.t.,'TOPCONN',tcGenQry(,,cQuery),cAlias,.T.,.F.)
	
	If Select(cAlias) > 0 .AND. (cAlias)->(!EOF())
		SA1->(dbSeek(xFilial("SA1")+(cAlias)->F2_CLIENTE+(cAlias)->F2_LOJA))
		SF2->(dbSeek(xFilial("SF2")+(cAlias)->F2_DOC+(cAlias)->F2_SERIE))
		SD2->(dbSeek(xFilial("SD2")+SF2->F2_DOC+SF2->F2_SERIE))
		SC5->(dbSeek(xFilial("SC5")+SD2->D2_PEDIDO))
		
		cAno   := SubStr(DTOS(dDataBase),3,2)
		cAnoInt:= SubStr(DTOS(dDataBase),1,4)
		cMes   := SubStr(DTOS(dDataBase),5,2)
		cDia   := SubStr(DTOS(dDataBase),7,2)
		cAnoNF := SubStr(DTOS(SF2->F2_EMISSAO),1,4)
		cMesNF := SubStr(DTOS(SF2->F2_EMISSAO),5,2)
		cDiaNF := SubStr(DTOS(SF2->F2_EMISSAO),7,2)
		cHora  := SubStr(Time(),1,2)
		cMin   := SubStr(Time(),4,2)
		
		cSequence := Soma1(cSequence)

		//Inicio da estrutura Mod. "000"
		/************************************************************************************************************************/
		//Campo 										Formato	Posi็ใo Inicial	Posi็ใo Final	Status	Nota
		//Identifica็ใo do Registro						N 			001					003			M			"000"
		//Identifica็ใo do Remetente					A			004					038			M			Nome da caixa postal do remetente
		//Identifica็ใo do Destinatario					A			039					073			M			Nome da caixa postal do Destinatario
		//Data											N 			074					079			M			DDMMAA
		//Hora											N 			080					083			M			HHMM
		//Identifica็ใo do Intercambio					A			084					143			M			"NOTDDMMHHMMS" onde:
		//																										"NOT" : Constante Nota Fiscal
		//																										"DDMM": Dia/M๊s
		//																										"HHMM": Hora / Minuto
		//																										"S": Sequencia de 0 a 9
		/*************************************************************************************************************************/
		nIdTp000		:= '000'
		PADL(ALLTRIM(SM0->M0_CGC),35,"0")
		cCxPosRem	:= Substr(Alltrim(SM0->M0_CGC)+Replicate(' ',35-Len(Alltrim(SM0->M0_CGC))),1,35) 		//Nome da caixa postal do remetente
		cCxPosDes	:= Substr(Alltrim(SA4->A4_CGC)+Replicate(' ',35-Len(Alltrim(SA4->A4_CGC))),1,35)  			//Nome da caixa postal do destinatario
		cData			:= Alltrim(cDia+cMes+cAno)
		cHora			:= SubStr(Time(),1,2)
		cMin			:= SubStr(Time(),4,2)		
		cIdInter		:= Alltrim("NOT"+cDia+cMes+cHora+cMin+"0")
		cFilTp000	:= Space(145)
		cCabec000	:= Space(240)
		
		cCabec000:=TiraAcento(nIdTp000+cCxPosRem+cCxPosDes+cData+cHora+cMin+cIdInter+cFilTp000)
		aadd(aLinha,{cCabec000})
		//Encerrando conteudo do registro 000 do arquivo TXT
		
		
		//Inicio da estrutura Mod. "310"
		/************************************************************************************************************************/
		//Campo 										Formato	Posi็ใo Inicial	Posi็ใo Final	Status	Nota
		//Identifica็ใo do Registro				N 			001					003			M			"310"
		//Identifica็ใo do Documento				A			004					017			M			"NOTFIDDMMHHMMS" onde:
		//																													"NOTFI"  : Constante Nota Fiscal
		//																													"DDMM"	: Dia/M๊s
		//																													"HHMM"	: Hora / Minuto
		//																													"S"		: Sequencia de 0 a 9
		//Filler											A			018					240			C			"Preencher com Brancos"
		/*************************************************************************************************************************/
		
		nIdTp310:='310'
		cIdInter:=Alltrim('NOTFI'+cDia+cMes+cHora+cMin+'0')
		cFilTp310:=Space(223)
		
		
		cCabec310 :=TiraAcento(nIdTp310+cIdInter+cFilTp310)
		aadd(aLinha,{cCabec310})
		//Encerrando conteudo do registro 310 do arquivo TXT



		//Inicio da estrutura Mod. "311"
		/************************************************************************************************************************/
		//Campo 											Formato	Posi็ใo Inicial	Posi็ใo Final	Status	Nota
		//Identifica็ใo do Registro					N 			001					003				M		"311"
		//CNPJ (CGC)										N			004					017				M
		//Inscri็ใo estadual embarc.					A			018					032				C
		//Endere็o(Lagradouro)							A			033					072				C
		//Cidade (Municipio								A			073					107				C
		//C๓digo Postal									A			108					116				C   	"CEP"
		//Subentidade de PAIS							A			117					125				C		"ESTADO="SP","RJ","MG",....
		//																														"CAMPO ALINHADO A ESQUERDA"
		//Data do embarque da Merc.					N			126					133				C
		//Nome da empresa Embarcadora					A			134					173				C
		//Filler												A			174					240				C		"Preencher com Brancos"
		/*************************************************************************************************************************/
		
		nIdTp311		:='311'
		nCNPJEmb		:=PADL(ALLTRIM(SM0->M0_CGC),14,"0")
		cIEEmb		:=Substr(Alltrim(SM0->M0_INSC)+Replicate(' ',15-Len(Alltrim(SM0->M0_INSC))),1,15)
		cEndEmb		:=Substr(Alltrim(SM0->M0_ENDENT)+Replicate(' ',40-Len(Alltrim(SM0->M0_ENDENT))),1,40)
		cCidEmb		:=Substr(Alltrim(SM0->M0_CIDENT)+Replicate(' ',35-Len(Alltrim(SM0->M0_CIDENT))),1,35)
		cCepEmb		:=Alltrim(SM0->M0_CEPENT)+Replicate(' ',9-Len(Alltrim(SM0->M0_CEPENT)))
		cEstEmb		:=Alltrim(SM0->M0_ESTENT)+Replicate(' ',9-Len(Alltrim(SM0->M0_ESTENT)))
		nDtEmb		:=Alltrim(cDia+cMes+cAnoInt)
		cRazEmb		:=Substr(Alltrim(SA4->A4_NOME)+Replicate(' ',40-Len(Alltrim(SA4->A4_NOME))),1,40)
		cFilTp311	:=Space(67)
		
		cDados311 :=TiraAcento(nIdTp311+nCNPJEmb+cIEEmb+cEndEmb+cCidEmb+cCepEmb+cEstEmb+nDtEmb+cRazEmb+cFilTp311)
		aadd(aLinha,{cDados311})
		//Encerrando conteudo do registro 311 do arquivo TXT
		
		
		nTotVal := nPsTot := nTotVol := nTotSeg := 0
		While (cAlias)->(!EOF())

			cCliente:= (cAlias)->F2_CLIENTE
			cLoja	:= (cAlias)->F2_LOJA
			While !(cAlias)->(EOF()) .and. cCliente == (cAlias)->F2_CLIENTE

			SF2->(dbSeek(xFilial("SF2")+(cAlias)->F2_DOC+(cAlias)->F2_SERIE))
			SD2->(dbSeek(xFilial("SD2")+SF2->F2_DOC+SF2->F2_SERIE))
			SC5->(dbSeek(xFilial("SC5")+SD2->D2_PEDIDO))
			SA1->(dbSeek(xFilial("SA1")+(cAlias)->F2_CLIENTE+(cAlias)->F2_LOJA))
//			cCliente:= (cAlias)->F2_CLIENTE
//			cLoja	:= (cAlias)->F2_LOJA
			cCNPJ	:= SA1->A1_CGC
			cInscri := Str(Val(SA1->A1_INSCR))
			While .T.
				nPos   := AT(".",cInscri)
				If nPos > 0
					cInscri := SubStr(cInscri,1,nPos-1)+SubStr(cInscri,nPos+1,Len(cInscri))
				EndIf
				If nPos==0
					Exit
				EndIf
			EndDo
			
			
			//Inicio da estrutura Mod. "312"
			/************************************************************************************************************************/
			//Campo 											Formato	Posi็ใo Inicial	Posi็ใo Final	Status		Nota
			//Identifica็ใo do Registro					N 				001				003			M		"312"
			//Razao Social										C				004				043			C
			//CNPJ												N				044				057			M		"Numero do CGC ou CPF do Destinatario
			//Inscri็ใo Estadual								A				058				072			C
			//Endere็o											A				073				112			C
			//Bairro												A				113				132			C
			//Cidade												A				133				167			C
			//CEP													A				168				176			M   	"CEP"
			//Cod. Municipio									A				177				185			C		"Tabela Acordada entre embarcadora e transportadora
			//Estado												A				186				194			C   	"ESTADO="SP","RJ","MG",....
			//																													"CAMPO ALINHADO A ESQUERDA"
			//Area de frete				  					A				195				198			C		"Tabela Acordada entre embarcadora e transportadora
			//Telefone											A				199				233			C		"Telefones, Fax, Telex, Etc....
			//Tipo de Indent. Destinatario  				A				234				234			C		"1=CGC;2=CPF"
			//Tipo de Estab. Destino Merc.  				A				235				235			C		"C=Comercial;I=Industrial;N=Nใo Contribuinte"
			//Filler												A				236				240			C		"Preencher com Brancos"
			/*************************************************************************************************************************/
			
			nIdTp312		:='312'
			cRazDest		:=Substr(Alltrim(SA1->A1_NOME)+Replicate(' ',40-Len(Alltrim(SA1->A1_NOME))),1,40)
			nCNPJDest	:=PADL(ALLTRIM(SA1->A1_CGC),14,"0")
			cIEDest		:=Substr(Alltrim(cInscri)+Replicate(' ',15-Len(Alltrim(cInscri))),1,15)
			cEndDest		:=Substr(Alltrim(SA1->A1_END)+Replicate(' ',40-Len(Alltrim(SA1->A1_END))),1,40)
			cBairDest	:=Substr(Alltrim(SA1->A1_BAIRRO)+Replicate(' ',20-Len(Alltrim(SA1->A1_BAIRRO))),1,20)
			cCidDest		:=Substr(Alltrim(SA1->A1_MUN)+Replicate(' ',35-Len(Alltrim(SA1->A1_MUN))),1,35)
			cCepDest		:=Alltrim(SA1->A1_CEP)+Replicate(' ',9-Len(Alltrim(SA1->A1_CEP)))
			cCodMun		:=Alltrim(SA1->A1_CODMUN)+Replicate(' ',9-Len(Alltrim(SA1->A1_CODMUN)))
			cEstDest		:=Alltrim(SA1->A1_EST)+Replicate(' ',9-Len(Alltrim(SA1->A1_EST)))
			cArefret		:="DOCA"  // Locar dentor do sistema locar para gerar a informa็ใo desse campo.
			cTelDest		:=Alltrim(SA1->A1_TEL)+Replicate(' ',35-Len(Alltrim(SA1->A1_TEL)))
			cTpDest		:=IIF(SA1->A1_PESSOA=="J","1","2")
			cTpEDest		:=IIF(Empty(SA1->A1_TPEST),"C",SA1->A1_TPEST) //Novo campo criado, retorno do cadastro de cleintes.
			cFilTp312	:=Space(5)
			
			
			cDados312  :=TiraAcento(nIdTp312+cRazDest+nCNPJDest+cIEDest+cEndDest+cBairDest+cCidDest+cCepDest+cCodMun+cEstDest+cArefret+cTelDest+cTpDest+cTpEDest+cFilTp312)
			aadd(aLinha,{cDados312})
			//Encerrando conteudo do registro 312 do arquivo TXT
			
//			While !(cAlias)->(EOF()) .and. cCliente == (cAlias)->F2_CLIENTE
				
				SD2->(dbSeek(xFilial("SD2")+(cAlias)->F2_DOC+(cAlias)->F2_SERIE))
				SC5->(dbSeek(xFilial("SC5")+SD2->D2_PEDIDO))
				SB1->(dbSeek(xFilial("SB1")+SD2->D2_COD))
				cEspecie := (cAlias)->F2_ESPECI1
				nVolume  := (cAlias)->F2_VOLUME1
				//			cNatProd := SA1->A1_NATUREZ
				//			cNatProd := Posicione("SED",1,xFilial("SED")+cNatProd,"ED_DESCRIC")
				cNat     := ""
				
				While SD2->D2_DOC+SD2->D2_SERIE==(cAlias)->F2_DOC+(cAlias)->F2_SERIE .and. SD2->(!EOF())
					//				cNat += cNatProd+","
					SF4->(dbSeek(xFilial("SF4")+SD2->D2_TES))
					SB1->(dbSeek(xFilial("SB1")+SD2->D2_COD))
					cICM := If(SF4->F4_LFICM=='T'.OR.SF4->F4_LFICM=="O",'S',If(SF4->F4_LFICM=="I","I",If(SF4->F4_LFICM=="N".or.SF4->F4_LFICM=="Z","N","S")))
					SD2->(dbSkip())
					//				cNatProd := SA1->A1_NATUREZ
					// 				cNatProd := Posicione("SED",1,xFilial("SED")+cNatProd,"ED_DESCRIC")
					
				EndDo
				//			cNat := SubStr(cNat,1,Len(cNat)-1)
				cVolume  := nVolume
				cValFat  := (cAlias)->F2_VALBRUT		// F2_VALFAT
				cPesLiqui:= (cAlias)->F2_PLIQUI
				cValSeg  := (cAlias)->F2_SEGURO
				
				//Inicio da estrutura Mod. "313"
				/************************************************************************************************************************/
				//Campo 											Formato	Posi็ใo Inicial	Posi็ใo Final	Status	Nota
				//Identifica็ใo do Registro					N 				001					003			M			"313"
				//Num. do Romaneio								A				004					018			C			"Identificacao interna da embarcadora"
				//Codigo da Rota									A				019					025			C			"Tabela acordada entre embarcadora e transportadora"
				//Meio de Transporte								N				026					026			C			"1=Rodoviario;2=Aereo;3=Maritimo;4=Fluvial;5=Ferroviario"
				//Tipo de Transp. de Carga						N				027					027			C			"1=Carga Fechada;2=Carga Fracionada"
				//Tipo de carga									N				028					028			C			"1=Fria;2=Seca;3=Mista"
				//Condicao do frente								A				029					029			M			"C=CIF;F=FOB"
				//Serie Nota fiscal								A				030					032			C			"Serie da nota fiscal"
				//Numero da Nota fiscal							N				033					040			M			"Numero da nota fiscal"
				//Data de Emissao									N				041					048			M			"DDMMAAAA"
				//Natureza da mercadoria						A				049					063			M			"EX.:Cal็ados, Confec็oes, Abrasivos, Etc...
				//Especie de acondicionamento					A				064					078			M			"Ex.:Fardos, Amarrados, Caixas, Etc....
				//Qtd de volumes									N				079					085			M
				//Valor total da nota fiscal					N				086					100			M
				//Peso total da mercadoria						N				101					107			M
				//Peso densidade									N				108					112			C
				//Incidencia ICMS									A				113					113			M			"S=Sim;N=Nao;I=Isento"
				//Seguro ja efetuado								A				114					114			M			"S=Sim;N=Nao"
				//Valor do Seguro									N				115					129			C
				//Valor a ser cobrado							N				130					144			C
				//Nบ da placa do caminhao						A				145					151			C
				//Plano de carga rapido							A				152					152			C			"S=Sim;N=Nao"
				//Valor do Frete Peso-Volume					N				153					167			C
				//Valor Adicional									N				168					182			C
				//Valor Total das Taxas							N				183					197			C			"Soma de todas as taxas envolvidas"
				//Valor total do frete							N				198					212			C			"Somatoria dos campos de valores: Frete + Peso-Volume + Ad Valorem e total taxas"
				//Acao do documento								A				213					213			C			"I=Inclusao / E=Exclusao"
				//Valor do ICMS									N				214					225			C			"Valor do ICMS da Nota"
				//Valor ICMS Retido								N  	     	226					237			C			"Valor do ICMS retido"
				//Indica็ใo de Bonificacao						A				238					238			C			"S=Sim;N=Nao"
				//Modalidade de frete							A				239					240			C			"01=Distribui็ใo;
				//																							 								 03=Distr. Fora Perimetro;
				//																															 04=Distr. Pulverizada;
				//																															 05=Frete Pago;
				//																															 06=Viagem;
				//																															 07=Retira;
				//												   																		 08=Maquinas Tintometricas;
				//																															 09=Materia Prima;
				//																															 10=Frete a pagar;
				//																															 11=Exportacao;
				//																															 12=Armazenamento;
				//																															 13=Tracerco;
				//																															 14=Mensal;
				//																															 15=Transferencia;
				//																															 16=Carga Direta
				//																															 99=Sinistro/Roubo de carga
				/*************************************************************************************************************************/
				
				nIdTp313		:='313'
				cNumRom		:=space(15)
				cCodRota		:="ROTA"+space(03)
				//			cCodRota		:=Substr(Alltrim(cCodRota)+Replicate(' ',7-Len(Alltrim(cCodRota))),1,4)
				nMeioTran	:=IIF(Empty(SC5->C5_TPVIA),"1",SC5->C5_TPVIA)  			// Campo no pedido de vendas
				nTpTraCar	:=IIF(Empty(SC5->C5_TPTRA),"1",SC5->C5_TPTRA)			// Campo no pedido de vendas
				nTpCar		:=IIF(Empty(SC5->C5_TPCAR),"1",SC5->C5_TPCAR)			// Campo no pedido de vendas
				cCondFre		:=IIF(Empty(SC5->C5_TPFRETE),"C",SC5->C5_TPFRETE) 		// Campo no pedido de vendas
				cSerie		:=Substr(Alltrim((cAlias)->F2_SERIE)+Replicate(' ',3-Len(Alltrim((cAlias)->F2_SERIE))),1,3)
				nNumNF		:=StrZero(Val((cAlias)->F2_DOC),8)
				nDtEmis		:=Alltrim(cDiaNF+cMesNF+cAnoNF)
				cNat			:="MATERL ELETRICO"
				cTpNatur		:=Substr(Alltrim(cNat)+Replicate(' ',15-Len(Alltrim(cNat))),1,15)
				cEspecie		:="CAIXAS"
				cEspecie		:=Substr(Alltrim(cEspecie)+Replicate(' ',15-Len(Alltrim(cEspecie))),1,15)
				nQtdVol		:=Strzero(cVolume,7)
				nTotVol		+=Val(nQtdVol)
				nVltTot		:=Strzero(cValFat*100,15)
				nPesTotM		:=Strzero(cPesLiqui*100,7)
				nPesoDens	:=STRZERO(0,5)
				nIncIcms		:=If(SC5->C5_TPFRETE=='C','N','S')
				cSegEfet		:=IIF(Empty(SC5->C5_SEGEFT),"N",SC5->C5_SEGEFT)		//Campo criado no pedido de vendas
				nVlrSeg		:=Strzero(cValSeg*100,15)
				nVlrCob		:=STRZERO(0,15)
				cPlaca		:=Substr(Alltrim((cAlias)->F2_VEICUL1)+Replicate(' ',7-Len(Alltrim((cAlias)->F2_VEICUL1))),1,15)
				cPlanoCar	:=IIF(Empty(SC5->C5_PLCARG),"N",SC5->C5_PLCARG)	   //Campo criado no pedido de vendas
				nVlrFretP	:=STRZERO(0,15)
				nVlrAd		:=STRZERO(0,15)
				nVlrTxs		:=STRZERO(0,15)
				nVlrFret		:=STRZERO(0,15)
				cAcaoDoc		:="I"
				nVlrIcms		:=STRZERO( (cAlias)->F2_VALICM * 100 ,12)
				nVlIcmRet	:=STRZERO(0,12)
				cIndBonf		:=IIF(Empty(SC5->C5_BONIFIC),"N",SC5->C5_BONIFIC)    //Campo criado no pedido de vendas
				cModFret		:=IIF(Empty(SC5->C5_MODFRE),"01",SC5->C5_MODFRE)	  //Campo criado no pedido de vendas
				
				cDados313 :=TiraAcento(nIdTp313+cNumRom+cCodRota+nMeioTran+nTpTraCar+nTpCar+cCondFre+cSerie+nNumNF+nDtEmis+cTpNatur+cEspecie+nQtdVol+nVltTot+nPesTotM+nPesoDens+nIncIcms+cSegEfet+nVlrSeg+nVlrCob+cPlaca+cPlanoCar+nVlrFretP+nVlrAd+nVlrTxs+nVlrFret+cAcaoDoc+nVlrIcms+nVlIcmRet+cIndBonf+cModFret)
				aadd(aLinha,{cDados313})
				//Encerrando conteudo do registro 313 do arquivo TXT
				
				//Inicio da estrutura Mod. "314"
				/************************************************************************************************************************/
				//Campo 											Formato	Posi็ใo Inicial	Posi็ใo Final	Status	Nota
				//Identifica็ใo do Registro					N	 			001			003			M	"314"
				//Qtd de Volumes									N				004			010			M
				//Especie de Acondicionamento					A				011			025			M	"Ex.: Fardos, Amarrados, Caixas, Etc."
				//Mercadoria da Nota Fiscal					A				026			055			C
				//Qtd de Volumes									N				056			062			M
				//Especie de Acondicionamento					A				063			077			M	"Ex.: Fardos, Amarrados, Caixas, Etc."
				//Mercadoria da Nota Fiscal					A				078			107			C
				//Qtd de Volumes									N				108			114			M
				//Especie de Acondicionamento					A				115			129			M	"Ex.: Fardos, Amarrados, Caixas, Etc."
				//Mercadoria da Nota Fiscal					A				130			159			C
				//Qtd de Volumes									N				160			166			M
				//Especie de Acondicionamento					A				167			181			M	"Ex.: Fardos, Amarrados, Caixas, Etc."
				//Mercadoria da Nota Fiscal					A				182			211			C
				//Filler												A				212			240			C	"Preencher com Brancos"
				/*************************************************************************************************************************/
				
				nIdTp314		:='314'
				nQtdVol		:=Strzero(nTotVol,7)
				cEspAcond	:=Substr(Alltrim(cEspecie)+Replicate(' ',15-Len(Alltrim(cEspecie))),1,15)
				cCodProd		:=Substr(Alltrim(SD2->D2_COD)+Replicate(' ',30-Len(Alltrim(SD2->D2_COD))),1,30)
				cEspAcond	:=Substr(Alltrim(cEspecie)+Replicate(' ',15-Len(Alltrim(cEspecie))),1,15)
				cCodProd		:=Substr(Alltrim(SD2->D2_COD)+Replicate(' ',30-Len(Alltrim(SD2->D2_COD))),1,30)
				cEspAcond	:=Substr(Alltrim(cEspecie)+Replicate(' ',15-Len(Alltrim(cEspecie))),1,15)
				cCodProd		:=Substr(Alltrim(SD2->D2_COD)+Replicate(' ',30-Len(Alltrim(SD2->D2_COD))),1,30)
				cEspAcond	:=Substr(Alltrim(cEspecie)+Replicate(' ',15-Len(Alltrim(cEspecie))),1,15)
				cCodProd		:=Substr(Alltrim(SD2->D2_COD)+Replicate(' ',30-Len(Alltrim(SD2->D2_COD))),1,30)
				cFilTp314	:=Space(29)
				
				//PROCESSO NรO USADO PELO CLIENTE
				//cDados314 :=TiraAcento(nIdTp314+nQtdVol+cEspAcond+cCodProd+nQtdVol+cEspAcond+cCodProd+nQtdVol+cEspAcond+cCodProd+nQtdVol+cEspAcond+cCodProd+cFilTp314)
				//aadd(aLinha,{cDados314})
				//DESATIVADO ROTINA CDADOS314
				//Encerrando conteudo do registro 314 do arquivo TXT
				
				
				//Inicio da estrutura Mod. "315"
				/************************************************************************************************************************/
				//Campo 											Formato	Posi็ใo Inicial	Posi็ใo Final	Status	Nota
				//Identifica็ใo do Registro					N 			001				003			M	"315"
				//Razao Social										A			004				043			M
				//CNPJ												N			044				057			M
				//Inscricao Estadual								A			058				072			C
				//Endere็o											A			073				112			M
				//Bairro												A			113				132			M
				//Cidade												A			133				167			M
				//CEP													A			168				176			M
				//Codigo de Municipio							A			177				185			C
				//Estado												A			186				194			M
				//Telefone											A			195				229
				//Filler												A			230				240			C	"Preencher com Brancos"
				/*************************************************************************************************************************/
				
				nIdTp315		:='315'
				cRazao		:=Substr(Alltrim(cCliente)+Replicate(' ',40-Len(Alltrim(cCliente))),1,40)
				nCNPJ			:=PADL(ALLTRIM(cCNPJ),14,"0")
				cIE			:=Substr(Alltrim(cInscri)+Replicate(' ',15-Len(Alltrim(cInscri))),1,15)
				cEnd			:=Substr(Alltrim(SA1->A1_END)+Replicate(' ',40-Len(Alltrim(SA1->A1_END))),1,40)
				cBairro		:=Substr(Alltrim(SA1->A1_BAIRRO)+Replicate(' ',20-Len(Alltrim(SA1->A1_BAIRRO))),1,20)
				cCidade		:=Substr(Alltrim(SA1->A1_MUN)+Replicate(' ',35-Len(Alltrim(SA1->A1_MUN))),1,35)
				cCep			:=Alltrim(SA1->A1_CEP)+Replicate(' ',9-Len(Alltrim(SA1->A1_CEP)))
				cCodMun		:=Alltrim(SA1->A1_CODMUN)+Replicate(' ',9-Len(Alltrim(SA1->A1_CODMUN)))
				cEst			:=Alltrim(SA1->A1_EST)+Replicate(' ',9-Len(Alltrim(SA1->A1_EST)))
				cTel			:=Alltrim(SA1->A1_TEL)+Replicate(' ',35-Len(Alltrim(SA1->A1_TEL)))
				cFilTp315	:=Space(11)
				
				
				//PROCESSO NรO USADO PELO CLIENTE
				//cDados315 :=TiraAcento(nIdTp315+cRazao+nCNPJ+cIE+cEnd+cBairro+cCidade+cCep+cCodMun+cEst+cTel+cFilTp315)
				//aadd(aLinha,{cDados315})
				//DESATIVADO ROTINA CDADOS315
				//Encerrando conteudo do registro 315 do arquivo TXT
				
				
				//Inicio da estrutura Mod. "316"
				/************************************************************************************************************************/
				//Campo 						  					Formato	Posi็ใo Inicial	Posi็ใo Final	Status	Nota
				//Identifica็ใo do Registro					N 			001				003			M	"316"
				//Razao Social										A			004				043			M
				//CNPJ												N			044				057			M
				//Inscricao Estadual								A			058				072			C
				//Endere็o											A			073				112			M
				//Bairro												A			113				132			M
				//Cidade												A			133				167			M
				//CEP													A			168				176			M
				//Codigo de Municipio							A			177				185			C
				//Estado												A			186				194			M
				//Area de Frete									A			195				198			C
				//Telefone											A			199				233			C
				//Filler												A			234				240			C	"Preencher com Brancos"
				/*************************************************************************************************************************/
				
				
				nIdTp316		:='316'
				cRazao		:=Substr(Alltrim(cCliente)+Replicate(' ',40-Len(Alltrim(cCliente))),1,40)
				nCNPJ			:=PADL(ALLTRIM(cCNPJ),14,"0")
				cIE			:=Substr(Alltrim(cInscri)+Replicate(' ',15-Len(Alltrim(cInscri))),1,15)
				cEnd			:=Substr(Alltrim(SA1->A1_END)+Replicate(' ',40-Len(Alltrim(SA1->A1_END))),1,40)
				cBairro		:=Substr(Alltrim(SA1->A1_BAIRRO)+Replicate(' ',20-Len(Alltrim(SA1->A1_BAIRRO))),1,20)
				cCidade		:=Substr(Alltrim(SA1->A1_MUN)+Replicate(' ',35-Len(Alltrim(SA1->A1_MUN))),1,35)
				cCep			:=Alltrim(SA1->A1_CEP)+Replicate(' ',9-Len(Alltrim(SA1->A1_CEP)))
				cCodMun		:=Alltrim(SA1->A1_CODMUN)+Replicate(' ',9-Len(Alltrim(SA1->A1_CODMUN)))
				cEst			:=Alltrim(SA1->A1_EST)+Replicate(' ',9-Len(Alltrim(SA1->A1_EST)))
				cArefret		:="DOCA" // verificar
				cTel			:=Alltrim(SA1->A1_TEL)+Replicate(' ',35-Len(Alltrim(SA1->A1_TEL)))
				cFilTp316	:=Space(07)
				
				//PROCESSO NรO USADO PELO CLIENTE
				//cDados316 :=TiraAcento(nIdTp316+cRazao+nCNPJ+cIE+cEnd+cBairro+cCidade+cCep+cCodMun+cEst+cArefret+cTel+cFilTp316)
				//aadd(aLinha,{cDados316})
				//DESATIVADO ROTINA CDADOS316
				//Encerrando yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyv  do registro 316 do arquivo TXT
				
				//Inicio da estrutura Mod. "317"
				/************************************************************************************************************************/
				//Campo 			   								Formato	Posi็ใo Inicial	Posi็ใo Final	Status	Nota
				//Identifica็ใo do Registro						N 			001					003				M		"317"
				//Razao Social											A				004					043				M
				//CNPJ													N				044					057				M
				//Inscricao Estadual									A				058					072				C
				//Endere็o												A				073					112				M
				//Bairro										 			A				113					132				M
				//Cidade													A				133					167				M
				//CEP														A				168					176				M
				//Codigo de Municipio								A				177					185				C
				//Estado													A				186					194				M
				//Telefone												A				195					229
				//Filler													A				230					240				C		"Preencher com Brancos"
				/*************************************************************************************************************************/
				nIdTp317		:='317'
				cRazao		:=Substr(Alltrim(SM0->M0_NOMECOM)+Replicate(' ',40-Len(Alltrim(SM0->M0_NOMECOM))),1,40)
				nCNPJ			:=PADL(ALLTRIM(SM0->M0_CGC),14,"0")
				cIE			:=Substr(Alltrim(SM0->M0_INSC)+Replicate(' ',15-Len(Alltrim(SM0->M0_INSC))),1,15)
				cEnd			:=Substr(Alltrim(SM0->M0_ENDENT)+Replicate(' ',40-Len(Alltrim(SM0->M0_ENDENT))),1,40)
				cBairro		:=Substr(Alltrim(SM0->M0_BAIRENT)+Replicate(' ',20-Len(Alltrim(SM0->M0_BAIRENT))),1,20)
				cCidade		:=Substr(Alltrim(SM0->M0_CIDENT)+Replicate(' ',35-Len(Alltrim(SM0->M0_CIDENT))),1,35)
				cCep			:=Alltrim(SM0->M0_CEPENT)+Replicate(' ',9-Len(Alltrim(SM0->M0_CEPENT)))

				cCodMun		:=Alltrim(SM0->M0_CODMUN)+Replicate(' ',9-Len(Alltrim(SM0->M0_CODMUN)))
/*
				cQuery := " SELECT CC2_CODMUN FROM "+RetSQLName("CC2")
				cQuery += " WHERE D_E_L_E_T_ <> '*'"
				cQuery += " AND CC2_EST = '"+SM0->M0_ESTENT+"'"
				cQuery += " AND CC2_MUN = '"+Alltrim(SM0->M0_CIDENT)+"'"
				cTrab := CriaTrab(,.F.)
				dbUseArea(.t.,'TOPCONN',tcGenQry(,,cQuery),cTrab,.T.,.F.)

				if ! EOF()
					cCodMun	:=Alltrim((cTrab)->CC2_CODMUN)+Replicate(' ',9-Len(Alltrim(SM0->M0_CODMUN)))
				endif
				
				dbCloseArea()
				dbSelectArea(cAlias)
*/
				cEst			:=Alltrim(SM0->M0_ESTENT)+Replicate(' ',9-Len(Alltrim(SM0->M0_ESTENT)))
				cTel			:=Alltrim(SM0->M0_TEL)+Replicate(' ',35-Len(Alltrim(SM0->M0_TEL)))
				cFilTp317	:=SPACE(11)

				cDados317 :=TiraAcento(nIdTp317+cRazao+nCNPJ+cIE+cEnd+cBairro+cCidade+cCep+cCodMun+cEst+cTel+cFilTp317)
				aadd(aLinha,{cDados317})
				//Encerrando conteudo do registro 317 do arquivo TXT
				
				nTotVal += (cAlias)->F2_VALBRUT		//F2_VALFAT
				nPsTot  += (cAlias)->F2_PLIQUI
				//		nTotVol += nVolume
				nTotSeg += (cAlias)->F2_SEGURO
				
				SF2->(dbSeek(xFilial("SF2")+(cAlias)->F2_DOC+(cAlias)->F2_SERIE))
				Reclock("SF2",.F.)
				SF2->F2_EDIEMIT := 'S'
				SF2->(msUnlock())
				
				(cAlias)->(dbSkip())
			EndDo
		EndDo
		
		cTotVal := nTotVal
		cPsTot  := nPsTot
		cTotVol := nTotVol
		cTotSeg:= nTotSeg
		
		//Inicio da estrutura Mod. "318"
		/************************************************************************************************************************/
		//Campo 											Formato	Posi็ใo Inicial	Posi็ใo Final	Status	Nota
		//Identifica็ใo do Registro					N 			001				003			M	"317"
		//Valor Total das notas fiscais				N			004				018			M	"somatoria do dados reg. 313"
		//Peso total das notas fiscais  				N			019				033			M	"somatoria do dados reg. 313"
		//Peso total densidade/cubagem				N			034				048			C	"somatoria do dados reg. 313"
		//Quantidade total de volumes					N			049				063			C	"somatoria do dados reg. 313"
		//Valor total a ser cobrado					N			064				078			C	"somatoria do dados reg. 313"
		//Valor total do seguro							N			079				093			C	"somatoria do dados reg. 313"
		//Filler												A			094				240			C	"Preencher com Brancos"
		/*************************************************************************************************************************/
		
		
		nIdTp318		:='318'
		nVlrTotal	:=Strzero(cTotVal*100,15)
		nPesoTot		:=Strzero(cPsTot*100,15)
		nPesTotD		:=STRZERO(0,15)
		nQtdTotV		:=Strzero(cTotVol,15)
		nVlrTotC		:=STRZERO(0,15)
		nVlrTotS		:=Strzero(cTotSeg,15)
		cFilTp318	:=Space(147)
		
		cTotal318	:=TiraAcento(nIdTp318+nVlrTotal+nPesoTot+nPesTotD+nQtdTotV+nVlrTotC+nVlrTotS+cFilTp318)
		
		aadd(aLinha,{cTotal318})
		cNomeArq:= "NOTFIS_"+ALLTRIM(SM0->M0_CODFIL) + "_" + cData + cHora + cMin + cSequence + ".EDI"
		
		U_fGeraTXT(aLinha,240,AllTrim(cNomeArq))
	EndIf

	dbSelectArea(cAlias)
	dbCloseArea()

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ fGeraTxt บ Autor ณ Cristiam Rossi     บ Data ณ  03/01/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Gera o arquivo texto para conferencia                      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ LPS - Avant                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function fGeraTxt(aLinha,nTamLin, cNomeArq)
/*
Parametros da Funcao fGeratxt()
[01] aLinha  - Array com o conteudo a gerar no arquivo texto.
[02] nTamLin - Qtde de caracteres por linha
*/
Private nHdl
Private cEOL    := "CHR(13)+CHR(10)"

	If Empty(cEOL)
		cEOL := CHR(13)+CHR(10)
	Else
		cEOL := Trim(cEOL)
		cEOL := &cEOL
	EndIf
	
	//cStartPath := GetSrvProfString("Startpath","")
	cStartPath := SuperGetMV("MV_EDIARQ",nil, GetSrvProfString("Startpath","") )	// Cristiam Rossi em 02/01/2012
	
	nHdl := fCreate(AllTrim(cStartPath) + AllTrim(Upper(cNomeArq)))
	If nHdl == -1
//		MsgAlert("O arquivo de nome " +  cArqTxt + " nao pode ser executado ! Verifique os parametros.", "Atencao!")
		Return
	EndIf
	
//	Processa({|| RunCont(aLinha,nTamLin) }, "Gerando TXT ...")
	RunCont(aLinha,nTamLin)
	
	//fRename( AllTrim(cStartPath)+AllTrim(Upper(cNomeArq)) , Upper(AllTrim(cStartPath)+AllTrim(Upper(cNomeArq))) )
	fClose(nHdl)
	//MsgInfo("Arquivo Texto Gerado !")
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ RunCont  บ Autor ณ Cristiam Rossi     บ Data ณ  03/01/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao auxiliar                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ LPS - Avant                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function RunCont(aLinha, nTamLin)
Local cLin, cCpo

//	ProcRegua(len(aLinha)) // Numero de registros a processar
	
	For I:=1 to len(aLinha)
//		IncProc()
		cCpo := aLinha[I][1]
		fGrvLin(nTamLin, cCpo)
	Next
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ fGrvLin  บ Autor ณ Cristiam Rossi     บ Data ณ  03/01/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao auxiliar                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ LPS - Avant                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fGrvLin(nTamLin, cCpo)
	cLin := Space(nTamLin)+cEOL
	cLin := Stuff(cLin,01,nTamLin,cCpo)
	If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
//		MsgAlert("Ocorreu um erro na gravacao do arquivo","Atencao!")
	Endif

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTiraAcentoบ Autor ณ Cristiam Rossi     บ Data ณ  03/01/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao auxiliar                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ LPS - Avant                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function TiraAcento( cTexto )
Local cRet  := ""
Local aChr  := {}
Local i     := 0
Local cChar := ""
Local nElem := 0

/* Maiusculo */
	aadd( aChr, { "ม","A" } )
	aadd( aChr, { "ษ","E" } )
	aadd( aChr, { "อ","I" } )
	aadd( aChr, { "ำ","O" } )
	aadd( aChr, { "ฺ","U" } )
	aadd( aChr, { "ว","C" } )
	aadd( aChr, { "ร","A" } )
	aadd( aChr, { "ย","A" } )
	aadd( aChr, { "ส","E" } )
	aadd( aChr, { "ฮ","I" } )
	aadd( aChr, { "ิ","O" } )
	aadd( aChr, { "Û","U" } )
	aadd( aChr, { "ภ","A" } )
	aadd( aChr, { "ศ","E" } )
	aadd( aChr, { "ฬ","I" } )
	aadd( aChr, { "า","O" } )
	aadd( aChr, { "ู","U" } )
	aadd( aChr, { "'"," " } )
	aadd( aChr, { "-"," " } )
	aadd( aChr, { "."," " } )
	aadd( aChr, { "**"," "} )
	aadd( aChr, { "/"," " } )
	aadd( aChr, { "*"," " } )
	aadd( aChr, { "="," " } )
	aadd( aChr, { ".."," "} )
	aadd( aChr, { "#"," " } )
	aadd( aChr, { "("," " } )
	aadd( aChr, { ")"," " } )
	aadd( aChr, { "{"," " } )
	aadd( aChr, { "}"," " } )
	aadd( aChr, { "\"," " } )
	aadd( aChr, { "@"," " } )
	aadd( aChr, { "+"," " } )
	aadd( aChr, { "<"," " } )
	aadd( aChr, { ">"," " } )
	aadd( aChr, { ":"," " } )
	aadd( aChr, { ";"," " } )
	
	/* Minusculo */
	aadd( aChr, { "แ","a" } )
	aadd( aChr, { "้","e" } )
	aadd( aChr, { "ํ","i" } )
	aadd( aChr, { "๓","o" } )
	aadd( aChr, { "๚","u" } )
	aadd( aChr, { "็","c" } )
	aadd( aChr, { "ใ","a" } )
	aadd( aChr, { "โ","a" } )
	aadd( aChr, { "๊","e" } )
	aadd( aChr, { "๎","i" } )
	aadd( aChr, { "๔","o" } )
	aadd( aChr, { "๛","u" } )
	aadd( aChr, { "เ","a" } )
	aadd( aChr, { "่","e" } )
	aadd( aChr, { "์","i" } )
	aadd( aChr, { "๒","o" } )
	aadd( aChr, { "๙","u" } )
	
	For i := 1 to len( cTexto )
		
		cChar := Subst( cTexto, i, 1 )
		nElem := aScan( aChr,{ |x| Upper(x[1]) == Upper(cChar)} )
		If nElem > 0
			cChar := aChr[ nElem, 2]
		Endif
		cRet += cChar
	Next

Return( cRet )