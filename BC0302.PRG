select 1
use BCBANCOS index BCBANCOS
SAVE SCRE TO WSCRE99
store .t. to viendo
do while viendo
   RESTORE SCRE FROM WSCRE99
  * STORE 0 TO WTOTAL
   STORE WBANCO TO XBANCO
   @ 04,0 clear to 10,40
   @ 04,0 to 10,40
   @ 04,15 SAY " BANCOS "
   @ 06,1 say "BANCO       :"
   @ 08,1 say "SALIDA (M/I):"
   @ 06,14 GET XBANCO
   READ
   IF READKEY()=12 .OR. READKEY()=268
      EXIT
   ENDIF
   IF XBANCO = SPACE(4)
      STORE "TODOS" TO WBANCODES
   ELSE
      STORE "  "    TO WBANCODES
   ENDIF
   @ 06,20 SAY WBANCODES

   STORE "SELECCIONE LA SALIDA: (M)ONITOR, (I)MPRESORA" TO TEX
   STORE "MI" TO WCH
   DO PREGUNTA
   IF READKEY()=12 .OR. READKEY()=268
      LOOP
   ENDIF
   STORE WCH TO WSALIDA
   STORE 0   TO WPAGINA
   STORE 100 TO WLINEA
   IF WSALIDA = "I"
      STORE 55 TO WSALTO
      STORE "IMPRESORA" TO WSALIDES
   ELSE
      STORE 22 TO WSALTO
      STORE "MONITOR" TO WSALIDES
   ENDIF
   @ 08,20 SAY WSALIDES

   STORE "OPCIONES: (C)ONTINUAR, (S)ALIR" TO TEX
   STORE "CS" TO WCH
   DO PREGUNTA
   IF WCH = "S"
      exit
   ENDIF
   IF WSALIDA = "I"
      SET DEVI TO PRINT
   ELSE
      SET DEVI TO SCRE
   ENDIF

   SELECT 1
   GO TOP
   DO WHILE .NOT. EOF()
      *** FILTROS
      IF XBANCO <> SPACE(4) .AND. XBANCO <> BANCO
         SELECT 1
         SKIP
         LOOP
      ENDIF

      *** FIN FILTROS
      STORE WLINEA+1 TO WLINEA
      IF WLINEA >=WSALTO
         STORE WPAGINA + 1 TO WPAGINA
         IF WSALIDA = "M"
            if WPAGINA <> 1
               STORE "OPRIMA <ENTER> PARA CONTINUAR o <ESC> PARA SALIR" TO MES
               DO AVISO WITH MES
               IF READKEY()=12 .OR. READKEY()=268
                  EXIT
               ENDIF
            endif
            @ 0,0 clear
         ENDIF
         IF WSALIDA = "M"
            @ 0,0 SAY QQWW
         ELSE
            @ 0,0 SAY CHR(14)+QQWW
         ENDIF
         @ 1,60 SAY "PAGINA:"+STR(WPAGINA,4)
         @ 2,0 SAY "LISTADO DE BANCOS"
         @ 2,60 SAY "FECHA :"+DTOC(DATE())
         @ 4,0 SAY "CODIGO"
         @ 4,8 SAY "DESCRIPCION"
         @ 5,0 SAY "------"
         @ 5,8 SAY "------------------------------"
         STORE 6 TO WLINEA
      ENDIF
      @ WLINEA , 0 SAY BANCO
      @ WLINEA , 8 SAY DESCRI
      SELECT 1
      SKIP
   ENDDO
   IF WSALIDA = "M"
      STORE "OPRIMA <ENTER> PARA FINALIZAR" TO MES
      DO AVISO WITH MES
   ELSE
      EJECT
      SET DEVI TO SCRE
   ENDIF
ENDDO
close data
close index
return

