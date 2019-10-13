DEFI WIND WINDDP FROM 03,00 TO 08,72 ;
                 TITLE " REPORTAR BALANCE DE COMPROBACION ";
                 DOUBLE NOFLOAT NOZOOM NOGROW SHADOW COLOR SCHEME 10
do while .t.
   acti wind winddp
   store DATE() to wfecini
   store DATE() to wfecfin
   @ 00,00 clear
   @ 01,02 SAY "Fecha de inic. corte:"
   @ 02,02 SAY "Fecha de cier. corte:"
   @ 03,02 SAY "Opciones            :"
   ***
   @ 01,25 GET WFECINI
   READ
   IF LASTKEY()=27
      EXIT
   ENDIF
   IF WFECINI<>CTOD("  -  -    ")
      @ 02,25 GET WFECFIN
      READ
      IF LASTKEY()=27
         LOOP
      ENDIF
      IF WFECFIN<>CTOD("  -  -    ").AND.WFECFIN<WFECINI
         STORE "ERROR EN SELECCION DE FECHAS, VERIFIQUE" TO WTEXT
         DO AVISO WITH WTEXT
         LOOP
      ENDIF
   ELSE
      STORE "ERROR EN SELECCION DE FECHAS, VERIFIQUE" TO WTEXT
      DO AVISO WITH WTEXT
      LOOP
   ENDIF
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
      do conrbgd
      acti wind winddp
   endif
   exit
enddo
deac wind winddp
restore scre from wscre01
return

