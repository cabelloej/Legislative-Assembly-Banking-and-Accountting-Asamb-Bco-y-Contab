***
*** BALANCE COMPROBACION PROG. DETALLE
***
STORE 3     TO WLENMAY
STORE 0     TO WPAGINA
STORE 100   TO WLINEA
SET DEVI    TO PRINT
STORE 55    TO WSALTO
*
STORE 0 TO WTOTINID
STORE 0 TO WTOTINIH
STORE 0 TO WTOTLAPD
STORE 0 TO WTOTLAPH
STORE 0 TO WTOTTOTD
STORE 0 TO WTOTTOTH
*
STORE 0 TO WTGINID
STORE 0 TO WTGINIH
STORE 0 TO WTGLAPD
STORE 0 TO WTGLAPH
STORE 0 TO WTGTOTD
STORE 0 TO WTGTOTH
STORE 0 TO WTGSALD
STORE 0 TO WTGSALH
*
STORE "*"   TO WRUPCTA
STORE " "   TO WDESCTA1
STORE "D"   TO WTIPCOL
DO CICLO
STORE "*"   TO WRUPCTA
STORE " "   TO WDESCTA1
STORE "H"   TO WTIPCOL
DO CICLO
DO TOTALES
DO SALIDA
RETURN
*
*******************************************************************************
**********
PROC CICLO
**********
SELECT CONAAD
SET ORDER TO CONAAD3
GO TOP
DO WHILE.NOT.EOF()
   IF SUBSTR(CODCTA,1,WLENMAY)<>WRUPCTA
      DO LINDAT
      DO RUPTURA
   ENDIF
   DO ACUMULA
   SKIP
ENDDO
DO LINDAT
RETURN
************
PROC RUPTURA
************
STORE SUBSTR(CODCTA,1,WLENMAY) TO WRUPCTA
SELECT CONCTAS
SEEK WRUPCTA
IF FOUND()
   STORE DESCTA1   TO WDESCTA1
   STORE INIDEBE   TO WTOTINID
   STORE INIHABER  TO WTOTINIH
   STORE 0         TO WTOTLAPD
   STORE 0         TO WTOTLAPH
   STORE 0         TO WTOTTOTD
   STORE 0         TO WTOTTOTH
ELSE
   STORE ""        TO WDESCTA1
   STORE 0         TO WTOTINID
   STORE 0         TO WTOTINIH
   STORE 0         TO WTOTLAPD
   STORE 0         TO WTOTLAPH
   STORE 0         TO WTOTTOTD
   STORE 0         TO WTOTTOTH
ENDIF
RETURN
************
PROC ACUMULA
************
SELECT CONAAD
IF FECCOMD<WFECINI
   STORE WTOTINID  +  DEBE        TO WTOTINID
   STORE WTOTINIH  +  HABER       TO WTOTINIH
ELSE
   IF  FECCOMD<=WFECFIN
      STORE WTOTLAPD   +  DEBE        TO WTOTLAPD
      STORE WTOTLAPH   +  HABER       TO WTOTLAPH
   ENDIF
ENDIF
RETURN
***********
PROC LINDAT
***********
*** Calculos finales
***
*** saldos iniciales
***
store wtotinid-wtotinih          to wsaldoini
if wsaldoini>=0
   store wtginid+wsaldoini       to wtginid
else
   store wtginih+(wsaldoini*-1)  to wtginih
endif
***
*** movimientos del lapso
***
store wtglapd +wtotlapd          to wtglapd
store wtglaph +wtotlaph          to wtglaph
***
*** totales
***
if wsaldoini>=0
   store wsaldoini+wtotlapd      to wtottotd
   store 0        +wtotlaph      to wtottoth
   store wtgtotd+wtottotd        to wtgtotd
   store wtgtoth+wtottoth        to wtgtoth
else
   store 0        +wtotlapd      to wtottotd
   store (wsaldoini*-1)+wtotlaph to wtottoth
   store wtgtotd+wtottotd        to wtgtotd
   store wtgtoth+wtottoth        to wtgtoth
endif
***
*** saldo final
***
store wtottotd-wtottoth          to wsaldofin
if wsaldofin>=0
   store wtgsald+wsaldofin       to wtgsald
else
   store wtgsalh+(wsaldofin*-1)  to wtgsalh
endif

*** Valida si debe imprimir o no
if (wtipcol="D".and.wsaldofin>=0).or.(wtipcol="H".and.wsaldofin<0)
else
   return
endif
*** inicio impresion
store wlinea + 1 to wlinea
do salto
do linsep
* Datos ident.
@ wlinea,01 say wrupcta
@ wlinea,06 say wdescta1
*** Saldo inicial
if wsaldoini>=0
   @ wlinea,47 say wsaldoini                picture "@z 9999,999,999.99"
else
   @ wlinea,63 say wsaldoini*-1             picture "@z 9999,999,999.99"
endif
*** Lapso de corte
@ wlinea,79 say wtotlapd                    picture "@z 9999,999,999.99"
@ wlinea,95 say wtotlaph                    picture "@z 9999,999,999.99"
**** Total cta
@ wlinea,111 say wtottotd                   picture "@z 9999,999,999.99"
@ wlinea,127 say wtottoth                   picture "@z 9999,999,999.99"
*** Saldo final
if wsaldofin>=0
   @ wlinea,143 say wsaldofin               picture "@z 9999,999,999.99"
else
   @ wlinea,159 say wsaldofin*-1            picture "@z 9999,999,999.99"
endif
RETURN
**********
PROC SALTO
**********
IF WLINEA >= WSALTO
   STORE WPAGINA + 1 TO WPAGINA
   @ 00,00  SAY CHR(18)
   @ 00,00  SAY CHR(14)+QQWW
   @ 01,85  SAY "Fecha: "+DTOC(DATE())
   @ 03,00  SAY "BALANCE DE COMPROBACION DEL "+DTOC(WFECINI)+" AL "+DTOC(WFECFIN)
   @ 04,00  SAY CHR(15)
   @ 05,00  SAY "                                              +-------------------------------+-------------------------------+-------------------------------+-------------------------------+"
   @ 06,00  SAY "                                              |       SALDOS ANTERIORES       |    MOVIMIENTOS DEL LAPSO      |            TOTALES            |             SALDOS            |"
   @ 07,00  SAY "+----+----------------------------------------+---------------+---------------+---------------+---------------+---------------+---------------+---------------+---------------+"
   @ 08,00  SAY "|COD.|CUENTA                                  |           DEBE|          HABER|           DEBE|          HABER|           DEBE|          HABER|           DEBE|          HABER|"
   @ 09,00  SAY "+----+----------------------------------------+---------------+---------------+---------------+---------------+---------------+---------------+---------------+---------------+"
   STORE 10 TO WLINEA
ENDIF
RETURN
***********
PROC LINSEP
***********
@ wlinea,00  SAY "|    |                                        |               |               |               |               |               |               |               |               |"
RETURN
***********
PROC LINFIN
***********
@ WLINEA,00 SAY "+----+----------------------------------------+---------------+---------------+---------------+---------------+---------------+---------------+---------------+---------------+"
RETURN
************
PROC TOTALES
************
STORE WLINEA+1 TO WLINEA
DO LINFIN
STORE WLINEA+1 TO WLINEA
DO LINFIN
STORE WLINEA+1 TO WLINEA
DO LINSEP
@ wlinea,47  say wtginid   picture "@z 9999,999,999.99"
@ wlinea,63  say wtginih   picture "@z 9999,999,999.99"
@ wlinea,79  say wtglapd   picture "@z 9999,999,999.99"
@ wlinea,95  say wtglaph   picture "@z 9999,999,999.99"
@ wlinea,111 say wtgtotd   picture "@z 9999,999,999.99"
@ wlinea,127 say wtgtoth   picture "@z 9999,999,999.99"
@ wlinea,143 say wtgsald   picture "@z 9999,999,999.99"
@ wlinea,159 say wtgsalh   picture "@z 9999,999,999.99"
RETURN
***********
PROC SALIDA
***********
STORE WLINEA+1 TO WLINEA
DO LINFIN
@ WLINEA,00 SAY CHR(18)
EJECT
SET DEVI TO SCRE
SHOW MENU MENUCON
RETURN
