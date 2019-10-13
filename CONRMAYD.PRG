STORE ALLTRIM(WCODCTA) TO WCODCTA
STORE LEN(WCODCTA)     TO WLENCTA
SELECT CONAAD
SET ORDER TO CONAAD3
GO TOP
IF WLENCTA<>0
   SEEK WCODCTA
   IF .NOT.FOUND()
      STORE "NO HAY MOVIMIENTOS PARA ESTA CUENTA" TO WTEXT
      DO AVISO WITH WTEXT
      RETURN
   ENDIF
ENDIF
***
*
STORE 0     TO WPAGINA
STORE 100   TO WLINEA
STORE .F.   TO WFLAGSALTO
IF WSALIDA = 1
   STORE 18 TO WSALTO
   @ 0,0 CLEAR
ELSE
   SET DEVI TO PRINT
   STORE 55 TO WSALTO
ENDIF
*
STORE "*"   TO WRUPCTA
IF WLENCTA=0
   STORE 3 TO WLENRUP
ELSE
   STORE WLENCTA TO WLENRUP
ENDIF
***
SELECT CONAAD
DO WHILE.NOT.EOF()
   *
   IF WLENCTA<>0
      IF WCODCTA<>SUBSTR(CODCTA,1,WLENCTA)
         EXIT
      ENDIF
   ENDIF
   *
   IF SUBSTR(CODCTA,1,WLENRUP)<>WRUPCTA
      STORE SUBSTR(CODCTA,1,WLENRUP) TO WRUPCTA
      SELECT CONCTAS
      SEEK WRUPCTA
      IF FOUND()
         STORE DESCTA1   TO WDESCTA1
         STORE INIDEBE   TO WTOTDEBE
         STORE INIHABER  TO WTOTHABER
      ELSE
         STORE "NO REG. EN PLAN DE CTAS." TO WDESCTA1
         STORE 0         TO WTOTDEBE
         STORE 0         TO WTOTHABER
      ENDIF
      IF WPAGINA<>0
         STORE WLINEA+1 TO WLINEA
         DO LINFIN
      ENDIF
      STORE .T.   TO WFLAGSALTO
      DO SALTO
   ENDIF
   *
   SELECT CONAAD
   IF WFECCOMINI<>CTOD("  -  -    ").AND.FECCOMD<WFECCOMINI
      SELECT CONAAD
      SKIP
      LOOP
   ENDIF
   IF WFECCOMFIN<>CTOD("  -  -    ").AND.FECCOMD>WFECCOMFIN
      SELECT CONAAD
      SKIP
      LOOP
   ENDIF
   *
   STORE WLINEA+1 TO WLINEA
   DO SALTO
   DO LINSEP
   @ WLINEA,01 SAY FECCOMD
   @ WLINEA,12 SAY DETCTA1
   IF DETCTA2<>SPACE(LEN(DETCTA2))
      STORE WLINEA+1 TO WLINEA
      DO LINSEP
      @ WLINEA,12 SAY DETCTA2
   ENDIF
   @ WLINEA,53 SAY CODCOMD
   @ wlinea,63 say DEBE  picture "@z 999,999,999.99"
   @ wlinea,79 say HABER picture "@z 999,999,999.99"
   STORE WTOTDEBE+DEBE   TO WTOTDEBE
   STORE WTOTHABER+HABER TO WTOTHABER
   @ wlinea,95 say WTOTDEBE-WTOTHABER picture "@z 999,999,999.99"
   SELECT CONAAD
   SKIP
ENDDO
STORE WLINEA+1 TO WLINEA
DO LINFIN
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
**********
PROC SALTO
**********
IF WLINEA >= WSALTO .OR. WFLAGSALTO
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
   @ 01,93  SAY "Fecha: "+DTOC(DATE())
   @ 03,42  SAY "L I B R O    M A Y O R"
   @ 04,00  SAY "+------------------------------------------------------------------------------------------------------------+"
   @ 05,00  SAY "|                                                                                                            |"
   @ 06,00  SAY "|           CUENTA DE MAYOR:                                                                                       |"
   @ 06,29  SAY WRUPCTA+" - "+WDESCTA1
   @ 07,00  SAY "|                                                                                                            |"
   @ 08,00  SAY "+----------+----------------------------------------+--------+---------------+---------------+---------------+"
   @ 09,00  SAY "|FECHA     |DESCRIPCION                             |ASIENTO |           DEBE|          HABER|          SALDO|"
   @ 10,00  SAY "+----------+----------------------------------------+--------+---------------+---------------+---------------+"
   STORE 10 TO WLINEA
   STORE .F. TO WFLAGSALTO
ENDIF
RETURN
***********
PROC LINSEP
***********
@ WLINEA,00  SAY "|          |                                        |        |               |               |               |"
RETURN
***********
PROC LINFIN
***********
@ WLINEA,00  SAY "+----------+----------------------------------------+--------+---------------+---------------+---------------+"
RETURN
