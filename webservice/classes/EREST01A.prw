#include 'protheus.ch'
#include 'totvs.ch'

User Function EREST01A()
Return

/*/{Protheus.doc} EREST_01A
Classe de produtos para realizar a serialização do objeto de produto
@author Victor Andrade
@since 14/04/2017
@version 1.0
@example
(examples)
@see (links_or_references)
/*/
Class Produtos
	
	Data cCodigo	As String
	Data cUM	  	As String
	Data cStatus 	As String 
	
	Method New(cCodigo, cUM, cStatus) Constructor 
EndClass

/*/{Protheus.doc} new
Metodo construtor
@author Victor Andrade
@since 14/04/2017 
@version 1.0
@example
(examples)
@see (links_or_references)
/*/
Method New(cCodProd, cUnidMed, cStatusPrd) Class Produtos

::cCodigo := cCodProd
::cUM 	  := cUnidMed
::cStatus := cStatusPrd

Return(Self)