#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAlteraVendบ Autor ณ Rogerio Machado    บ Data ณ 07/05/2014  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Altera Vendedor de um grupo de clientes mediante filtro    บฑฑ
ฑฑบ          ณ Chamado: 000000                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico Avant                                           บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function AlteraVend()

Local bVendedor := {|_x|cGetNomeAtu:=Posicione("SA3",1,xFilial("SA3")+cGetRepAtu,"A3_NOME"),.T.}
Local bVendedor2 := {|_x|cGetNomeNov:=Posicione("SA3",1,xFilial("SA3")+cGetRepNov,"A3_NOME"),.T.}
Local bEstado := {|_x|cGetNomeEst:=Posicione("SX5",1,xFilial("SX5")+"12"+cGetEst,"X5_DESCRI"),.T.}

Local oFntAr10	:= TFont():New("Arial",10,14,,.F.,,,,.T.,.F.)

Private cGetEst     := Space(TamSx3("A3_EST")[1])
Private cGetRepAtu  := Space(TamSx3("A3_COD")[1])
Private cGetRepNov  := Space(TamSx3("A3_COD")[1])
Private cGetNomeEst := Space(TamSx3("A3_MUN")[1])
Private cGetNomeAtu := Space(TamSx3("A3_NOME")[1])
Private cGetNomeNov := Space(TamSx3("A3_NOME")[1])

SetPrvt("oDlgVend","oGrpVend","oSayEst","oSayRepAtu","oSayRepNov","oSayNomeEst","oSayNomeAtu","oSayNomeNov","oGetEst")
SetPrvt("oGetRepAtu","oGetRepNov","oGetNomeEst","oGetNomeAtu","oGetNomeNov","oBtnCancel","oBtnTransf")

oDlgVend    := MSDialog():New( 091,232,247,737,"Alterar Vendedor",,,.F.,,,,,,.T.,,,.T. )
oGrpVend    := TGroup():New( 004,004,056,244,"",oDlgVend,CLR_BLACK,CLR_WHITE,.T.,.F. )
oSayEst     := TSay():New( 011,008,{||"Estado:"}             ,oGrpVend,,			 ,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,052,008)
oSayRepAtu  := TSay():New( 024,008,{||"Representante Atual:"},oGrpVend,,        ,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,052,008)
oSayRepNov  := TSay():New( 036,008,{||"Novo Representante:"} ,oGrpVend,,        ,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,052,008)
oSayNomeEst := TSay():New( 011,144,{||"Nome:"}               ,oGrpVend,,        ,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,017,008)
oSayNomeAtu := TSay():New( 024,144,{||"Nome:"}               ,oGrpVend,,        ,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,017,008)
oSayNomeNov := TSay():New( 036,144,{||"Nome:"}               ,oGrpVend,,        ,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,017,008)
oGetEst     := TGet():New( 011,066,{|u| If(PCount()>0,cGetEst:=u,cGetEst)}        ,oGrpVend,075,008,'',bEstado,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"12" ,"cGetEst",,)
oGetRepAtu  := TGet():New( 024,066,{|u| If(PCount()>0,cGetRepAtu:=u,cGetRepAtu)}  ,oGrpVend,075,008,'',bVendedor,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SA3","cGetRepAtu",,)
oGetRepNov  := TGet():New( 036,066,{|u| If(PCount()>0,cGetRepNov:=u,cGetRepNov)}  ,oGrpVend,075,008,'',bVendedor2,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SA3","cGetRepNov",,)
oGetNomeEst := TGet():New( 011,164,{|u| If(PCount()>0,cGetNomeEst:=u,cGetNomeEst)},oGrpVend,075,008,'',         ,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,""   ,"cGetNomeEst",,)
oGetNomeAtu := TGet():New( 024,164,{|u| If(PCount()>0,cGetNomeAtu:=u,cGetNomeAtu)},oGrpVend,075,008,'',         ,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,""   ,"cGetNomeAtu",,)
oGetNomeNov := TGet():New( 036,164,{|u| If(PCount()>0,cGetNomeNov:=u,cGetNomeNov)},oGrpVend,075,008,'',         ,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,""   ,"cGetNomeNov",,)
//oBtnTransf  := TButton():New( 059,170,"Transferir",oDlgVend,{ || ApMsgAlert("Em Desenvolvimento") },032,011,,,,.T.,,"",,,,.F. )
oBtnTransf  := TButton():New( 059,170,"Transferir",oDlgVend,{ || GeraArqTRB(cGetEst,cGetRepAtu,cGetRepNov) },032,011,,,,.T.,,"",,,,.F. )
oBtnCancel  := TButton():New( 059,205,"Cancelar"  ,oDlgVend,{ || oDlgVend:End() },032,011,,,,.T.,,"",,,,.F. )

oDlgVend:Activate(,,,.T.)

LjMsgRun("Montando massa de dados ...",,{|| CursorWait(),GeraArqTRB(),CursorArrow()})

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGeraArqTRBบAutor  ณ Rogerio Machado    บ Data ณ 07/05/2014  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFuncao Auxiliar                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*//*
Static Function GeraArqTRB()

//	Local cCampo := "%%"
//	Local cWhere := "%%"
//	Local cOrder := "%%"
	
	BeginSql alias 'TRB'
	
		UPDATE %table:SA1% SA1 SET A1_VEND = cGetRepNov WHERE A1_VEND = cGetRepAtu AND A1_EST = cGetEst AND SA1.%notDel%

	EndSql
	
Return()*/