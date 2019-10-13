
IF WTIPASI="D"
   STORE "DIFERIDOS" TO WTIPASIDES
ELSE
   STORE "ACTUALES"  TO WTIPASIDES
ENDIF
DEFI WIND WINDDP FROM 03,00 TO 11,72 ;
                 TITLE " REPORTAR ASIENTOS "+WTIPASIDES ;
                 DOUBLE NOFLOAT NOZOOM NOGROW SHADOW COLOR SCHEME 10
do while .t.
   acti wind winddp
   store 0                  to wcodcomini
   store 0                  to wcodcomfin
   store ctod("  -  -    ") to wfeccomini
   store ctod("  -  -    ") to wfeccomfin
   store 0                  to wseparar
   @ 00,00 clear
   @ 00,02 SAY "Desde comprobante No:"
   @ 01,02 SAY "Hasta comprobante No:"
   @ 02,02 SAY "Desde fecha de elab.:"
   @ 03,02 SAY "Hasta fecha de elab.:"
   @ 04,02 SAY "Separar por pagina? :"
   @ 05,02 SAY "Salida              :"
   @ 06,02 SAY "Opciones            :"
   ***
   @ 00,25 GET WCODCOMINI PICT "9999999"
   READ
   IF LASTKEY()=27
      EXIT
   ENDIF
   STORE WCODCOMINI TO WNUMERO
   DO CONNUM WITH WNUMERO
   STORE WNUMERO    TO WCODCOMINI
   IF WCODCOMINI<>REPLICATE("0",LEN(WCODCOMINI))
      @ 01,25 GET WCODCOMFIN PICT "9999999"
      READ
      IF LASTKEY()=27
         LOOP
      ENDIF
      STORE WCODCOMFIN TO WNUMERO
      DO CONNUM WITH WNUMERO
      STORE WNUMERO    TO WCODCOMFIN
      IF WCODCOMFIN<>REPLICATE("0",LEN(WCODCOMFIN)).AND.WCODCOMFIN<WCODCOMINI
         STORE "ERROR EN SELECCION DE COMPROMANTES" TO WTEXT
         DO AVISO WITH WTEXT
         LOOP
      ENDIF
   ENDIF
   ***
   IF WCODCOMINI=REPLICATE("0",LEN(WCODCOMINI))
      @ 02,25 GET WFECCOMINI
      READ
      IF LASTKEY()=27
         LOOP
      ENDIF
      IF WFECCOMINI<>CTOD("  -  -    ")
         @ 03,25 GET WFECCOMFIN
         READ
         IF LASTKEY()=27
            LOOP
         ENDIF
         IF WFECCOMFIN<>CTOD("  -  -    ").AND.WFECCOMFIN<WFECCOMINI
            STORE "ERROR EN SELECCION DE FECHAS" TO WTEXT
            DO AVISO WITH WTEXT
            LOOP
         ENDIF
      ENDIF
   ENDIF
   ***
   store 1 to wop
   do while .t.
      @ 04,25 get wop pict "@*H  No;Si" defa wop
      read
      if lastkey()=13
         exit
      endif
   enddo
   store wop to wseparar
   ***
   store 1 to wop
   do while .t.
      @ 05,25 get wop pict "@*H  Monitor ;Impresora" defa wop
      read
      if lastkey()=13
         exit
      endif
   enddo
   store wop to wsalida
   ***
   store 1 to wop
   do while .t.
      @ 06,25 get wop pict "@*H  Aceptar ;Cancelar " defa wop
      read
      if lastkey()=13
         exit
      endif
   enddo
   store wop to wopciones
   ***
   if wopciones=1
      deac wind winddp
      do conrasid
      acti wind winddp
   endif
   exit
enddo
deac wind winddp
restore scre from wscre01
return

