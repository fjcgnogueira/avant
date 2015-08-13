#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AlteraGerenº Autor ³ Rogerio Machado    º Data ³ 08/05/2014  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Altera Vendedor de um grupo de clientes mediante selecao    º±±
±±º          ³ Chamado: 000000                                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Avant                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function AlteraGeren()

Local bGerenAtu := {|_x|oSayNomeAtu:=Posicione("SA3",1,xFilial("SA3")+oSayNomeAtu,"A3_NOME"),.T.}
Local bGerenNov := {|_x|oSayNomeNov:=Posicione("SA3",1,xFilial("SA3")+oSayNomeNov,"A3_NOME"),.T.}

Local oFntAr10	:= TFont():New("Arial",10,14,,.F.,,,,.T.,.F.)

Private cGetGerAtu  := Space(TamSx3("A3_COD")[1])
Private cGetGerNov  := Space(TamSx3("A3_COD")[1])
Private oSayNomeAtu := Space(TamSx3("A3_NOME")[1])
Private oSayNomeNov := Space(TamSx3("A3_NOME")[1])

SetPrvt("oDlgGeren","oGrpGeren","oSayGerAtu","oSayGerNov","oSayNomeAtu","oSayNomeNov")
SetPrvt("cGetGerAtu","cGetGerNov","cGetNomeAtu","cGetNomeNov","oBtnCancel","oBtnTransf")

oDlgGeren    := MSDialog():New( 091,232,247,737,"Substitui Gerente Regional",,,.F.,,,,,,.T.,,,.T. )
oGrpGeren    := TGroup():New( 004,004,056,244,"",oDlgGeren,CLR_BLACK,CLR_WHITE,.T.,.F. )
oSayGerAtu  := TSay():New( 024,008,{||"Gerente Atual:"},oGrpGeren,,        ,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,052,008)
oSayGerNov  := TSay():New( 036,008,{||"Gerente Novo:"} ,oGrpGeren,,        ,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,052,008)
oSayGerAtu := TSay():New( 024,144,{||"Nome:"}               ,oGrpGeren,,        ,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,017,008)
oSayGerNov := TSay():New( 036,144,{||"Nome:"}               ,oGrpGeren,,        ,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,017,008)
cGetGerAtu  := TGet():New( 024,066,{|u| If(PCount()>0,cGetGerAtu:=u,cGetGerAtu)}  ,oGrpGeren,075,008,'',bGerenAtu,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SA3","cGetGerAtu",,)
cGetGerNov  := TGet():New( 036,066,{|u| If(PCount()>0,cGetGerNov:=u,cGetGerNov)}  ,oGrpGeren,075,008,'',bGerenNov,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SA3","cGetGerNov",,)
oSayNomeAtu := TGet():New( 024,164,{|u| If(PCount()>0,oSayNomeAtu:=u,oSayNomeAtu)},oGrpGeren,075,008,'',         ,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,""   ,"oSayNomeAtu",,)
oSayNomeNov := TGet():New( 036,164,{|u| If(PCount()>0,oSayNomeNov:=u,oSayNomeNov)},oGrpGeren,075,008,'',         ,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,""   ,"oSayNomeNov",,)
//oBtnTransf  := TButton():New( 059,170,"Transferir",oDlgGeren,{ || GeraArqTRB(cGetGerAtu,cGetGerNov) },032,011,,,,.T.,,"",,,,.F. )
oBtnCancel  := TButton():New( 059,205,"Cancelar"  ,oDlgGeren,{ || oDlgGeren:End() },032,011,,,,.T.,,"",,,,.F. )

oDlgGeren:Activate(,,,.T.)

//LjMsgRun("Montando massa de dados ...",,{|| CursorWait(),GeraArqTRB(),CursorArrow()})


Return

