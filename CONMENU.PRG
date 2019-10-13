set proc to CONPROC
*** INI CONTROL DE ACCESO
SELECT 20
USE SYSUSERD INDEX SYSUSERD
STORE "CONMENU " TO WPROGRAMA
STORE SPACE(1)  TO WACCESO
STORE SPACE(1)  TO WFILTRO
DO CHKACC WITH WUSERCODE,WPROGRAMA,WACCESO,WFILTRO
IF WACCESO=" "
   RETURN
ENDIF
USE
*** FIN CONTROL DE ACCESO

store "Contabilidad" to wmodulo
@ 1,45 say space(34)
@ 01,80-len(wmodulo) say wmodulo

store space(1)       to wtipasi
SELECT 1
USE CONCONF
STORE MASKCTA               TO WMASKCTA
STORE LEN(ALLTRIM(MASKCTA)) TO WMASKLAR
*** PLAN DE CUENTAS
SELECT 2
USE CONCTAS INDEX CONCTAS1, CONCTAS2
*** ASIENTOS DIFERIDOS
SELECT 3
USE CONADG INDEX CONADG1, CONADG2
SELECT 4
USE CONADD INDEX CONADD1, CONADD2, CONADD3
*** ASIENTOS ACTUALES
SELECT 5
USE CONAAG INDEX CONAAG1, CONAAG2
SELECT 6
USE CONAAD INDEX CONAAD1, CONAAD2, CONAAD3


STORE SPACE(1) TO T7
STORE .T. TO WJUMPING
***************************************
define menu menucon bar at line 3 shadow
*      define pad padcon00 of menucon prompt "\<Sistema" skip
       define pad padcon01 of menucon prompt "\<Instala" skip
       define pad padcon02 of menucon prompt "\<Modulo " skip
       define pad padcon03 of menucon prompt "\<Tabla  "
       define pad padcon04 of menucon prompt "\<Accion "
       define pad padcon05 of menucon prompt "\<Reporte"
       define pad padcon06 of menucon prompt "\<Proceso"
       define pad padcon07 of menucon prompt "ma\<Ntto."
       define pad padcon08 of menucon prompt "\<Salir  "
       on pad padcon03 of menucon activate popup subcon03
       on pad padcon04 of menucon activate popup subcon04
       on pad padcon05 of menucon activate popup subcon05
       on pad padcon06 of menucon activate popup subcon06
       on pad padcon07 of menucon activate popup subcon07
       on sele pad padcon08 of menucon RETURN
       DEFINE POPUP subcon03 FROM 4,30 shadow
              DEFINE BAR 01 OF subcon03 PROMPT "\<Configuracion             "
              DEFINE BAR 02 OF subcon03 PROMPT "\<Plan de cuentas           "
              ON SELECTION POPUP subcon03 DO subcon03 WITH BAR()
       DEFINE POPUP subcon04 FROM 4,40 shadow
              DEFINE BAR 01 OF subcon04 PROMPT "asientos \<Diferidos        "
              DEFINE BAR 02 OF subcon04 PROMPT "asientos \<Actuales         "
              ON SELECTION POPUP subcon04 DO subcon04 WITH BAR()
       DEFINE POPUP subcon05 FROM 4,50 shadow
              DEFINE BAR 01 OF subcon05 PROMPT "\<Cuentas                   "
              DEFINE BAR 02 OF subcon05 PROMPT "asientos \<Diferidos        "
              DEFINE BAR 03 OF subcon05 PROMPT "asientos \<Actuales         "
              DEFINE BAR 04 OF subcon05 PROMPT "libro dia\<Rio              "
              DEFINE BAR 05 OF subcon05 PROMPT "libro ma\<Yor               "
              DEFINE BAR 06 OF subcon05 PROMPT "\<Balance de comprobacion   "
              DEFINE BAR 07 OF subcon05 PROMPT "balance \<General           "
              ON SELECTION POPUP subcon05 DO subcon05 WITH BAR()
       DEFINE POPUP subcon06 FROM 4,60 shadow
              DEFINE BAR 01 OF subcon06 PROMPT "renumerar \<Asientos        "
              DEFINE BAR 02 OF subcon06 PROMPT "reconstruir \<Saldos        "
              ON SELECTION POPUP subcon06 DO subcon06 WITH BAR()
       DEFINE POPUP subcon07 FROM 4,70 shadow
              DEFINE BAR 01 OF subcon07 PROMPT "\<Reorganizar indices       "
              DEFINE BAR 02 OF subcon07 PROMPT "\<Compactar tablas de datos "
              ON SELECTION POPUP subcon07 DO subcon07 WITH BAR()
*** ACTIVACION DEL MENU DE bancos
do while .t.
   ACTIVATE MENU menucon 
enddo
RELEASE menucon
RETURN

******************
PROCEDURE subcon03
******************
PARAMETERS SELBAR
save scre to wscre01
hide menu menucon
push key clear
@ 4,0 CLEAR
DO CASE
   CASE SELBAR = 1
        do conconf
   CASE SELBAR = 2
        do conacta
ENDCASE
pop key
show menu menucon
restore scre from wscre01
RETURN

******************
PROCEDURE subcon04
******************
PARAMETERS SELBAR
save scre to wscre01
hide menu menucon
push key clear
DO CASE
   CASE SELBAR = 1
        store "D" to wtipasi
        store "CONADG"  to warcgen
        store "CONADG1" to windgen1
        store "CONADG2" to windgen2
        store "CONADD"  to warcdet
        store "CONADD1" to winddet1
        store "CONADD2" to winddet2
        store "CONADD3" to winddet3
        do CONAASI
   CASE SELBAR = 2
        store "A" to wtipasi
        store "CONAAG"  to warcgen
        store "CONAAG1" to windgen1
        store "CONAAG2" to windgen2
        store "CONAAD"  to warcdet
        store "CONAAD1" to winddet1
        store "CONAAD2" to winddet2
        store "CONAAD3" to winddet3
        do CONAASI
ENDCASE
pop key
show menu menucon
restore scre from wscre01
RETURN

******************
PROCEDURE subcon05
******************
PARAMETERS SELBAR
save scre to wscre01
hide menu menumain
hide menu menucon
push key clear
DO CASE
   CASE SELBAR = 1
        DO conrctag
   CASE SELBAR = 2
        store "D" to wtipasi
        store "CONADG"  to warcgen
        store "CONADG1" to windgen1
        store "CONADG2" to windgen2
        store "CONADD"  to warcdet
        store "CONADD1" to winddet1
        store "CONADD2" to winddet2
        store "CONADD3" to winddet3
        do CONRASIG
   CASE SELBAR = 3
        store "A" to wtipasi
        store "CONAAG"  to warcgen
        store "CONAAG1" to windgen1
        store "CONAAG2" to windgen2
        store "CONAAD"  to warcdet
        store "CONAAD1" to winddet1
        store "CONAAD2" to winddet2
        store "CONAAD3" to winddet3
        do CONRASIG
   CASE SELBAR = 4
        DO conrdiag
   CASE SELBAR = 5
        DO conrmayg
   CASE SELBAR = 6
        *DO conrbgg
   CASE SELBAR = 6
        DO conrbcg
ENDCASE
restore scre from wscre01
show menu menumain
show menu menucon
pop key
RETURN

******************
PROCEDURE subcon06
******************
PARAMETERS SELBAR
save scre to wscre01
hide menu menucon
push key clear
DO CASE
   CASE SELBAR = 1
        *DO conrenu
   CASE SELBAR = 2
        *DO conreco
ENDCASE
save scre to wscre01
hide menu menucon
push key clear
RETURN

******************
PROCEDURE subcon07
******************
PARAMETERS SELBAR
save scre to wscre01
hide menu menucon
push key clear
DO CASE
   CASE SELBAR = 1
        DO INDICES
   CASE SELBAR = 2
        DO COMPACTA
ENDCASE
save scre to wscre01
hide menu menucon
push key clear
RETURN
***



