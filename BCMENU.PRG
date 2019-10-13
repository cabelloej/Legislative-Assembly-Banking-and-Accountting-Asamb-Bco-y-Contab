SET PROC TO BCPROC
SELECT 20
USE SYSUSERD INDEX SYSUSERD
*** INI CONTROL DE ACCESO
STORE "BCMENU " TO WPROGRAMA
STORE SPACE(1)  TO WACCESO
STORE SPACE(1)  TO WFILTRO
DO CHKACC WITH WUSERCODE,WPROGRAMA,WACCESO,WFILTRO
IF WACCESO=" "
   RETURN
ENDIF
USE
*** FIN CONTROL DE ACCESO

store "Bancos" to wmodulo
@ 1,45 say space(34)
@ 01,80-len(wmodulo) say wmodulo
*
STORE SPACE(4)  TO WBANCO
STORE SPACE(4)  TO WSUCURSAL
STORE SPACE(4)  TO WCUENTA
STORE SPACE(4)  TO WSUBCUENTA
STORE SPACE(2)  TO WTIPO
*
STORE SPACE(1) TO T7
STORE .T. TO WJUMPING
*
define menu menuban bar at line 3 shadow
*      define pad padban00 of menuban prompt "\<Sistema" skip
       define pad padban01 of menuban prompt "\<Instala" skip
       define pad padban02 of menuban prompt "\<Modulo " skip
       define pad padban03 of menuban prompt "\<Tabla  "
       define pad padban04 of menuban prompt "\<Accion "
       define pad padban05 of menuban prompt "\<Reporte"
       define pad padban06 of menuban prompt "\<Proceso"
       define pad padban07 of menuban prompt "ma\<Ntto."
       define pad padban08 of menuban prompt "\<Salir  "
       on pad padban03 of menuban activate popup subban03
       on pad padban04 of menuban activate popup subban04
       on pad padban05 of menuban activate popup subban05
       on pad padban06 of menuban activate popup subban06
       on pad padban07 of menuban activate popup subban07
       on sele pad padban08 of menuban return
       DEFINE POPUP subban03 FROM 4,30 shadow
              DEFINE BAR 01 OF subban03 PROMPT "\<Bancos                    "
              DEFINE BAR 02 OF subban03 PROMPT "\<Sucursales                "
              DEFINE BAR 03 OF subban03 PROMPT "\<Tipos de cuentas          "
              DEFINE BAR 04 OF subban03 PROMPT "\<Clasificacion de cuentas  "
              DEFINE BAR 05 OF subban03 PROMPT "c\<Uentas                  "
              DEFINE BAR 06 OF subban03 PROMPT "subcu\<Entas                "
              DEFINE BAR 07 OF subban03 PROMPT "\<Referncias de operaciones "           
              DEFINE BAR 08 OF subban03 PROMPT "bene\<Ficiarios de cheques  "
              DEFINE BAR 09 OF subban03 PROMPT "\<Operadores x cuenta       "           
              ON SELECTION POPUP subban03 DO subban03 WITH BAR()
       DEFINE POPUP subban04 FROM 4,40 shadow
              DEFINE BAR 01 OF subban04 PROMPT "\<Movimientos         "
              DEFINE BAR 02 OF subban04 PROMPT "\<Conciliacion        "
              ON SELECTION POPUP subban04 DO subban04 WITH BAR()
       DEFINE POPUP subban05 FROM 4,50 shadow
              DEFINE BAR 01 OF subban05 PROMPT "TABLAS DE CODIGOS           " SKIP
              DEFINE BAR 02 OF subban05 PROMPT "\<Bancos                    "
              DEFINE BAR 03 OF subban05 PROMPT "\<Sucursales                "
              DEFINE BAR 04 OF subban05 PROMPT "\<Tipos de cuentas          "
              DEFINE BAR 05 OF subban05 PROMPT "\<Clasificacion de cuentas  "
              DEFINE BAR 06 OF subban05 PROMPT "c\<Uentas                   "
              DEFINE BAR 07 OF subban05 PROMPT "subcu\<Entas                "
              DEFINE BAR 08 OF subban05 PROMPT "\<Referencia de operaciones "
              DEFINE BAR 09 OF subban05 PROMPT "bene\<Ficiarios de cheques  "
              DEFINE BAR 10 OF subban05 PROMPT "\<Operadores x cuenta       "
              DEFINE BAR 11 OF subban05 PROMPT "OTROS                       " SKIP
              DEFINE BAR 12 OF subban05 PROMPT "o\<Peraciones               "
              DEFINE BAR 13 OF subban05 PROMPT "sa\<Ldos                    "
              DEFINE BAR 14 OF subban05 PROMPT "est\<Ados de cuenta         "
              DEFINE BAR 15 OF subban05 PROMPT "sal\<Dos por clasificacion  "
              DEFINE BAR 16 OF subban05 PROMPT "co\<Nciliacion              "
              ON SELECTION POPUP subban05 DO subban05 WITH BAR()
       DEFINE POPUP subban06 FROM 4,60 shadow
              DEFINE BAR 01 OF subban06 PROMPT "\<Emitir cheque             "
              DEFINE BAR 02 OF subban06 PROMPT "\<Conformar cheques         "
              DEFINE BAR 03 OF subban06 PROMPT "\<Reconstruir saldos        "
              ON SELECTION POPUP subban06 DO subban06 WITH BAR()
       DEFINE POPUP subban07 FROM 4,70 shadow
              DEFINE BAR 01 OF subban07 PROMPT "\<Reorganizar indices       "
              DEFINE BAR 02 OF subban07 PROMPT "\<Compactar tablas de datos "
              ON SELECTION POPUP subban07 DO subban07 WITH BAR()
*** ACTIVACION DEL MENU DE bancos
do while .t.
   ACTIVATE MENU menuban 
enddo
*RELEASE menuban
CLOSE DATA
CLOSE INDEX
SET PROC TO SYSPROC
RETURN
*********************************
*** RUTINAS
***
PROCEDURE subban03
PARAMETERS SELBAR
DO CASE
   CASE SELBAR = 1
        save scre to wscre01
        do bc0101
        restore scre from wscre01
   CASE SELBAR = 2
        save scre to wscre01
        do bc0102
        restore scre from wscre01
   CASE SELBAR = 3
        save scre to wscre01
        do bc0103
        restore scre from wscre01
   CASE SELBAR = 4
        save scre to wscre01
        do bc0104
        restore scre from wscre01
   CASE SELBAR = 5
        save scre to wscre01
        do bc0105
        restore scre from wscre01
   CASE SELBAR = 6
        save scre to wscre01
        do bc0106
        restore scre from wscre01
   CASE SELBAR = 7
        save scre to wscre01
        do bc0107
        restore scre from wscre01
   CASE SELBAR = 8
        save scre to wscre01
        SELECT 5
        USE PRBENEF INDEX PRBENEF1,PRBENEF2
        do bc0108
        CLOSE DATA
        CLOSE INDEX
        restore scre from wscre01
   CASE SELBAR = 9
        save scre to wscre01
        do bc0109
        restore scre from wscre01
ENDCASE
ON KEY LABEL F1
ON KEY LABEL F2
ON KEY LABEL F3
ON KEY LABEL F4
RETURN
*** 
PROCEDURE subban04
PARAMETERS SELBAR
DO CASE
   CASE SELBAR = 1
        HIDE MENU MENUBAN
        save scre to wscre01
        STORE .F. TO WCONCI
        SET CENT OFF
        DO bc0201
        SET CENT ON
        restore scre from wscre01
        SHOW MENU MENUBAN
        restore scre from wscre01
   CASE SELBAR = 2
        HIDE MENU MENUBAN
        save scre to wscre01
        DO bc0202
        restore scre from wscre01
        SHOW MENU MENUBAN
ENDCASE
ON KEY LABEL F1
ON KEY LABEL F2
ON KEY LABEL F3
ON KEY LABEL F4
RETURN
***
PROCEDURE subban05
PARAMETERS SELBAR
DO CASE
   CASE SELBAR = 2
        save scre to wscre01
        HIDE MENU MENUBAN
        DO bc0302
        SHOW MENU MENUBAN
        restore scre from wscre01
   CASE SELBAR = 3
        save scre to wscre01
        HIDE MENU MENUBAN
        DO bc0303
        SHOW MENU MENUBAN
        restore scre from wscre01
   CASE SELBAR = 4
        save scre to wscre01
        HIDE MENU MENUBAN
        DO bc0304
        SHOW MENU MENUBAN
        restore scre from wscre01
   CASE SELBAR = 5
        save scre to wscre01
        HIDE MENU MENUBAN
        DO bc0305
        SHOW MENU MENUBAN
        restore scre from wscre01
   CASE SELBAR = 6
        save scre to wscre01
        HIDE MENU MENUBAN
        DO bc0306
        SHOW MENU MENUBAN
        restore scre from wscre01
   CASE SELBAR = 7
        save scre to wscre01
        HIDE MENU MENUBAN
        DO bc0307
        SHOW MENU MENUBAN
        restore scre from wscre01
   CASE SELBAR = 8
        save scre to wscre01
        HIDE MENU MENUBAN
        DO bc0308
        SHOW MENU MENUBAN
        restore scre from wscre01
   CASE SELBAR = 9
        save scre to wscre01
        HIDE MENU MENUBAN
        SELECT 1
        USE PRBENEF INDEX PRBENEF1,PRBENEF2
        DO bc0309
        CLOSE DATA
        CLOSE INDEX
        SHOW MENU MENUBAN
        restore scre from wscre01
   CASE SELBAR = 10
        save scre to wscre01
        HIDE MENU MENUBAN
        DO bc0310
        SHOW MENU MENUBAN
        restore scre from wscre01
   CASE SELBAR = 12
        save scre to wscre01
        HIDE MENU MENUBAN
        DO bc0312
        SHOW MENU MENUBAN
        restore scre from wscre01
   CASE SELBAR = 13
        save scre to wscre01
        HIDE MENU MENUBAN
        DO bc0313
        SHOW MENU MENUBAN
        restore scre from wscre01
   CASE SELBAR = 14
        save scre to wscre01
        HIDE MENU MENUBAN
        DO bc0314
        SHOW MENU MENUBAN
        restore scre from wscre01
   CASE SELBAR = 15
        save scre to wscre01
        HIDE MENU MENUBAN
        DO bc0315
        SHOW MENU MENUBAN
        restore scre from wscre01
   CASE SELBAR = 16
        save scre to wscre01
        HIDE MENU MENUBAN
        DO bc0316
        SHOW MENU MENUBAN
        restore scre from wscre01
ENDCASE
ON KEY LABEL F1
ON KEY LABEL F2
ON KEY LABEL F3
ON KEY LABEL F4
RETURN
***
PROCEDURE subban06
PARAMETERS SELBAR
DO CASE
   CASE SELBAR = 1
        save scre to wscre01
        DO bc0401
        restore scre from wscre01
   CASE SELBAR = 2
        save scre to wscre01
        DO bc0402
        restore scre from wscre01
   CASE SELBAR = 3
        save scre to wscre01
        DO bc0403
        restore scre from wscre01
ENDCASE
ON KEY LABEL F1
ON KEY LABEL F2
ON KEY LABEL F3
ON KEY LABEL F4
RETURN
***
PROCEDURE subban07
PARAMETERS SELBAR
DO CASE
   CASE SELBAR = 1
        save scre to wscre01
        DO INDICES
        restore scre from wscre01
   CASE SELBAR = 2
        save scre to wscre01
        DO COMPACTA
        restore scre from wscre01
ENDCASE
ON KEY LABEL F1
ON KEY LABEL F2
ON KEY LABEL F3
ON KEY LABEL F4
RETURN
***

