DEFI WIND WINDDP FROM 03,00 TO 09,72 ;
                 TITLE " REPORTAR CUENTAS ";
                 DOUBLE NOFLOAT NOZOOM NOGROW SHADOW COLOR SCHEME 10

do while .t.
   acti wind winddp
   @ 0,0 clear
   @ 01,02 SAY "Clave de busqueda   :"
   @ 02,02 SAY "Salida              :"
   @ 03,02 SAY "Opciones            :"
   STORE SPACE(20) TO WCLAVE
   @ 01,25 GET WCLAVE
   READ
   IF LASTKEY()=27
      EXIT
   ENDIF
   store 1 to wop
   do while .t.
      @ 02,25 get wop pict "@*H  Monitor ;Impresora" defa wop
      read
      if lastkey()=13
         exit
      endif
   enddo
   store wop to wsalida
   store 1 to wop
   do while .t.
      @ 03,25 get wop pict "@*H  Aceptar ;Cancelar " defa wop
      read
      if lastkey()=13
         exit
      endif
   enddo
   store wop to wopciones
   if wopciones=1
      deac wind winddp
      do conrctad
      acti wind winddp
   endif
   exit
enddo
deac wind winddp
restore scre from wscre01
return


