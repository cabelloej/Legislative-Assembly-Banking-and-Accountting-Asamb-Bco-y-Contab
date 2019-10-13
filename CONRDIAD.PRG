*
SELECT CONAAD
STORE ALLTRIM(WUSERCODE)+".DB1" TO WTMPFILE
STORE ALLTRIM(WUSERCODE)+".ID1" TO WTMPINDE
COPY STRU                       TO &WTMPFILE
SELECT 20
USE &WTMPFILE 
IF FILLOC()
   INDEX ON CODCTA TO &WTMPINDE
ELSE
   DO PROCNUL
ENDIF
*
STORE 0     TO WPAGINA
STORE 100   TO WLINEA
IF WSALIDA = 1
   STORE 18 TO WSALTO
   @ 0,0 CLEAR
ELSE
   SET DEVI TO PRINT
   STORE 55 TO WSALTO
ENDIF
***
SELECT CONAAG
SET ORDER TO CONAAG2
GO TOP
IF WFECCOMINI<>CTOD("  -  -    ")
   SEEK WFECCOMINI
   IF .NOT.FOUND()
      GO TOP
      DO WHILE.NOT.EOF()
         IF WFECCOMINI>=FECCOMG
            EXIT
         ENDIF
         SKIP
      ENDDO
   ENDIF
ENDIF
***
DO WHILE.NOT.EOF()
   *
   IF WFECCOMFIN<>CTOD("  -  -    ").AND.FECCOMG>WFECCOMFIN
      EXIT
   ENDIF
   *
   STORE CODCOMG TO WCODCOMR
   STORE FECCOMG TO WFECCOMR
   STORE DESCOM1 TO WDESCOMR1
   STORE DESCOM2 TO WDESCOMR2
   STORE DESCOM3 TO WDESCOMR3
   STORE DESCOM4 TO WDESCOMR4
   STORE DESCOM5 TO WDESCOMR5
   STORE DESCOM6 TO WDESCOMR6
   STORE DESCOM7 TO WDESCOMR7
   STORE DESCOM8 TO WDESCOMR8
   STORE DESCOM9 TO WDESCOMR9
   STORE DESCOM10 TO WDESCOMR10
   STORE DESCOM11 TO WDESCOMR11
   STORE DESCOM12 TO WDESCOMR12
   STORE DESCOM13 TO WDESCOMR13
   STORE DESCOM14 TO WDESCOMR14
   STORE DESCOM15 TO WDESCOMR15
   STORE 0       TO WTOTDEBE
   STORE 0       TO WTOTHABER
   STORE 0       TO WSALDO
   *
   SELECT 20
   DELETE ALL
   *
   SELECT CONAAD
   SET ORDER TO CONAAD1
   SEEK WCODCOMR
   DO WHILE.NOT.EOF().AND.CODCOMD=WCODCOMR
      DO GRADIA
      SELECT CONAAD
      SKIP
   ENDDO
   DO IMPDIA
   SELECT CONAAG
   SKIP
ENDDO
IF WSALIDA=2
   SET DEVI TO SCRE
   EJECT
ELSE
   STORE "OPRIMA (Ù) PARA FINALIZAR" TO WTEXT
   STORE CHR(13) TO WCH
   DO PREGUNTA
   @ 0,0 CLEAR
ENDIF
SHOW MENU MENUCON
RETURN
********************************************************************************
***********
PROC GRADIA
***********
select 20
seek conaad.codcta
if .not. found()
   append blank
   replace codcomd with conaad.codcomd
   replace feccomd with conaad.feccomd
   replace codcta  with conaad.codcta
endif
replace debe   with debe+conaad.debe
replace haber  with haber+conaad.haber
***
*** CREA Y/O ACTUALIZA LOS NIVELS DE CUENTA
***
store conaad.codcta to wcodcta
store len(wcodcta)  to wlencta,wconcar
do while wconcar>0
   store substr(wcodcta,wconcar,1) to wcar
   if wcar="."
      store substr(wcodcta,1,wconcar-1)         to wsubcta
      store wsubcta+space(wlencta-len(wsubcta)) to wsubcta
      *** ver si subcta existe. sino se crea
      select 20
      seek wsubcta
      if .not. found()
         append blank
         replace codcomd with conaad.codcomd
         replace feccomd with conaad.feccomd
         replace codcta  with wsubcta
      endif
      *** actualizar subcta con monto de cta
      replace debe   with debe+conaad.debe
      replace haber  with haber+conaad.haber
   endif
   store wconcar-1 to wconcar
enddo
RETURN
***********
PROC SALTOH
***********
IF WLINEA >= WSALTO
   STORE WPAGINA + 1 TO WPAGINA
   IF WSALIDA=1 .AND. WPAGINA<>1
      STORE "OPRIMA (Ù) PARA CONTINUAR" TO WTEXT
      STORE CHR(13) TO WCH
      DO PREGUNTA
      @ 0,0 CLEAR
   ENDIF
   STORE 1 TO WLINEA
   IF WSALIDA=2
      @ 00,00  SAY CHR(18)
      @ 00,00  SAY CHR(14)+QQWW
   ELSE
      @ 00,00  SAY QQWW
   ENDIF
   @ 01,116 SAY "Fecha :"+DTOC(DATE())
   @ 02,050 SAY "L I B R O    D I A R I O"
   *@ 02,116 SAY "Pagina:"+ALLTRIM(STR(WPAGINA,3))
   @ 03,00  SAY CHR(18)
   @ 03,00  SAY "+----------+----------------------------------------+---------------+---------------+---------------+-------------------------------+"
   @ 04,00  SAY "|FECHA     |DESCRIPCION DEL ASIENTO                 |    SUBDIVISION|       DIVISION|      SUBCUENTA|        CUENTAS MAYORES        |"
   @ 05,00  SAY "|          |                                        |    ESTADISTICA|    ESTADISTICA|               |-------------------------------|"
   @ 06,00  SAY "|          |                                        |               |               |               |           DEBE|          HABER|"
   @ 07,00  SAY "+----------+----------------------------------------+---------------+---------------+---------------+---------------+---------------+"
   STORE 8 TO WLINEA
ENDIF
RETURN

***********
PROC IMPDIA
***********
STORE WLINEA+1 TO WLINEA
DO SALTOH
DO LINSEP
@ WLINEA,23              SAY "ASIENTO No. "+WCODCOMR
STORE WLINEA+1 TO WLINEA
DO LINSEP
@ WLINEA,23              SAY "-------------------"
STORE WLINEA+1 TO WLINEA
DO SALTOH
DO LINSEP
@ WLINEA,01 SAY WFECCOMR
@ WLINEA,12 SAY WDESCOMR1
IF WDESCOMR2<>SPACE(LEN(WDESCOMR2))
   STORE WLINEA+1 TO WLINEA
   DO LINSEP
   @ WLINEA,12 SAY WDESCOMR2
ENDIF
IF WDESCOMR3<>SPACE(LEN(WDESCOMR3))
   STORE WLINEA+1 TO WLINEA
   DO LINSEP
   @ WLINEA,12 SAY WDESCOMR3
ENDIF
IF WDESCOMR4<>SPACE(LEN(WDESCOMR4))
   STORE WLINEA+1 TO WLINEA
   DO LINSEP
   @ WLINEA,12 SAY WDESCOMR4
ENDIF
IF WDESCOMR5<>SPACE(LEN(WDESCOMR5))
   STORE WLINEA+1 TO WLINEA
   DO LINSEP
   @ WLINEA,12 SAY WDESCOMR5
ENDIF
IF WDESCOMR6<>SPACE(LEN(WDESCOMR6))
   STORE WLINEA+1 TO WLINEA
   DO LINSEP
   @ WLINEA,12 SAY WDESCOMR6
ENDIF
IF WDESCOMR7<>SPACE(LEN(WDESCOMR7))
   STORE WLINEA+1 TO WLINEA
   DO LINSEP
   @ WLINEA,12 SAY WDESCOMR7
ENDIF
IF WDESCOMR8<>SPACE(LEN(WDESCOMR8))
   STORE WLINEA+1 TO WLINEA
   DO LINSEP
   @ WLINEA,12 SAY WDESCOMR8
ENDIF
IF WDESCOMR9<>SPACE(LEN(WDESCOMR9))
   STORE WLINEA+1 TO WLINEA
   DO LINSEP
   @ WLINEA,12 SAY WDESCOMR9
ENDIF
IF WDESCOMR10<>SPACE(LEN(WDESCOMR10))
   STORE WLINEA+1 TO WLINEA
   DO LINSEP
   @ WLINEA,12 SAY WDESCOMR10
ENDIF
IF WDESCOMR11<>SPACE(LEN(WDESCOMR11))
   STORE WLINEA+1 TO WLINEA
   DO LINSEP
   @ WLINEA,12 SAY WDESCOMR11
ENDIF
IF WDESCOMR12<>SPACE(LEN(WDESCOMR12))
   STORE WLINEA+1 TO WLINEA
   DO LINSEP
   @ WLINEA,12 SAY WDESCOMR12
ENDIF
IF WDESCOMR13<>SPACE(LEN(WDESCOMR13))
   STORE WLINEA+1 TO WLINEA
   DO LINSEP
   @ WLINEA,12 SAY WDESCOMR13
ENDIF
IF WDESCOMR14<>SPACE(LEN(WDESCOMR14))
   STORE WLINEA+1 TO WLINEA
   DO LINSEP
   @ WLINEA,12 SAY WDESCOMR14
ENDIF
IF WDESCOMR15<>SPACE(LEN(WDESCOMR15))
   STORE WLINEA+1 TO WLINEA
   DO LINSEP
   @ WLINEA,12 SAY WDESCOMR15
ENDIF
SELECT 20
GO TOP
DO WHILE .NOT.EOF()
   STORE WLINEA+1 TO WLINEA
   DO SALTOH
   DO LINSEP
   *** DETERMINA EL NUMERO DE PUNTOS DEL CODIGO
   store codcta        to wcodcta
   store len(wcodcta)  to wlencta,wconcar
   store 0             to wnumpun
   do while wconcar>0
      store substr(wcodcta,wconcar,1) to wcar
      if wcar="."
         store wnumpun+1 to wnumpun
      endif
      store wconcar-1 to wconcar
   enddo
   *** DESCRIPCION DE LA CUENTA
   SELECT CONCTAS
   SEEK  WCODCTA
   ***
   select 20
   store debe-haber to wsalmov
   if wnumpun=0
      *** datos de la cuenta principal
      @ wlinea,12  say codcta
      @ wlinea,15  say " - "+conctas.descta1
      if wsalmov>0
         @ wlinea,102 say abs(wsalmov) picture "@z 999,999,999.99"
      else
         @ wlinea,118 say abs(wsalmov) picture "@z 999,999,999.99"
      endif
   else
      *** datos de las subctas y divisiones
      if wnumpun=1
         store " - " to wseparador
      else
        if wnumpun=2
           store " = " to wseparador
        else
           store " . " to wseparador
        endif
     endif
     @ wlinea,15+(wnumpun*2)           say wseparador+conctas.descta1
     @ wlinea,102-(15*wnumpun)-wnumpun say abs(wsalmov) picture "@z 999,999,999.99"
   endif
   SELECT 20
   SKIP
ENDDO
STORE WLINEA+1 TO WLINEA
DO LINSEP
@ WLINEA,101 SAY REPLICATE("=",31)
STORE WLINEA+1 TO WLINEA
DO LINFIN
RETURN
***********
PROC LINSEP
***********
@ WLINEA,00  SAY "|          |                                        |               |               |               |               |               |"
RETURN
***********
PROC LINFIN
***********
@ WLINEA,00  SAY "+----------+----------------------------------------+---------------+---------------+---------------+---------------+---------------+"
RETURN
