#INCLUDE "Protheus.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MA030TOK  º Autor ³ Rodrigo Leite      º Data ³  08/12/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Validaçao do campo CNPJ e Cod.Mun                          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function MA030TOK ()

valida   := .F. 
Private nCliente :=M->A1_NOME 
Private cCliente :=M->A1_COD


IF !EMPTY (M->A1_CGC)
	IF M->A1_TIPO <> "X"
		valida:= .T.
    ELSE                         
        ALERT("O campo CNPJ não deve ser preenchido para Cliente tipo Exportaçao")
        valida:= .F.
    ENDIF    
ELSE 
	IF M->A1_TIPO = "X"
		valida:= .T.
    ELSE 
        ALERT("O Campo CNPJ não foi preenchido")
        valida:= .F.
    ENDIF
ENDIF
                         

IF valida 
   If EMPTY(M->A1_COD_MUN) .and. M->A1_TIPO != "X"
	   ALERT("O Campo Cod. Municipio não esta preenchido")
        valida:= .F.
    EndIf
ENDIF



If M->A1_XREGESP = "S"
	If M->A1_TIPO <> "R" .OR. M->A1_GRPTRIB <> "060" .OR. M->A1_INSCR = " " .OR. M->A1_INSCR = "ISENTO"
		valida := .F.
		Msginfo("Cliente com Regime Especial. Verifique os campos de: Tipo, Grupo Trib. e Inscrição Estadual.")
	EndIf
Else
	If Empty(M->A1_XREGESP)
		valida := .F.
		MsgInfo("Campo Regime Especial vazio.")
	EndIf
EndIf


Return(valida)