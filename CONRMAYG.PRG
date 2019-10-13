DEFI WIND WINDDP FROM 03,00 TO 08,72 ;
                 TITLE " REPORTAR LIBRO MAYOR ";
                 DOUBLE NOFLOAT NOZOOM NOGROW SHADOW COLOR SCHEME 10
do while .t.
   acti wind winddp
   store space(20)          to wcodcta
   store ctod("  -  -    ") to wfeccomini
   store ctod("  -  -    ") to wfeccomfin
   store 0                  to wseparar
   @ 00,00 clear
   @ 00,02 SAY "Cuenta              :"
   @ 01,02 SAY "Desde fecha         :"
   @ 02,02 SAY "Hasta fecha         :"
   *@ 02,02 SAY "Salida              :"
   @ 03,02 SAY "Opciones            :"
   ***
   @ 00,25 GET WCODCTA
   READ
   IF LASTKEY()=27
      EXIT
   ENDIF
   ***
   @ 01,25 GET WFECCOMINI
   READ
   IF LASTKEY()=27
      LOOP
   ENDIF
   IF WFECCOMINI<>CTOD("  -  -    ")
      @ 02,25 GET WFECCOMFIN
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
   ***
   *store 1 to wop
   *do while .t.
   *   @ 02,25 get wop pict "@*H  Monitor ;Impresora" defa wop
   *   read
   *   if lastkey()=13
   *      exit
   *   endif
   *enddo
   *store wop to wsalida
   store    2 to wsalida
   ***
   store 1 to wop
   do while .t.
      @ 03,25 get wop pict "@*H  Aceptar ;Cancelar " defa wop
      read
      if lastkey()=13
         exit
      endif
   enddo
   store wop to wopciones
   ***
   if wopciones=1
      deac wind winddp
      do conrmayd
      acti wind winddp
   endif
   exit
enddo
deac wind winddp
restore scre from wscre01
return

