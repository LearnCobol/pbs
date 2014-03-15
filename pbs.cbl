      **********************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID. pbs.
      *
      * Authors: Peter B, Bertil K and Sergejs S.
      * Purpose: Manage an invoice print company (PBS)
      * Initial Version Created: 2014-03-11
      *
      **********************************************************
       ENVIRONMENT DIVISION.
      *---------------------------------------------------------
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
      **********************************************************
       DATA DIVISION.
      *---------------------------------------------------------
       FILE SECTION.
      **********************************************************
       WORKING-STORAGE SECTION.

           EXEC SQL INCLUDE SQLCA END-EXEC.

           EXEC SQL INCLUDE DEBTOR END-EXEC.

           EXEC SQL INCLUDE INVOICE END-EXEC.

           EXEC SQL INCLUDE INVITEM END-EXEC.

           EXEC SQL INCLUDE ITEM END-EXEC.

           EXEC SQL INCLUDE ADDR END-EXEC.

           EXEC SQL INCLUDE CUSTOMER END-EXEC.

           EXEC SQL INCLUDE INLOG END-EXEC.

           EXEC SQL INCLUDE SRV END-EXEC.

           EXEC SQL INCLUDE FINDATA END-EXEC.


      *    switches
       01  menu-switches.
           05 is-exit-application-switch      PIC X(1) VALUE 'N'.
               88  is-exit-application                 VALUE 'Y'.
           05 is-exit-load-file-menu-switch   PIC X(1) VALUE 'N'.
               88  is-exit-load-file-menu              VALUE 'Y'.
           05 is-exit-print-menu-switch       PIC X(1) VALUE 'N'.
               88  is-exit-print-menu                  VALUE 'Y'.
           05 is-exit-pbs-rpt-menu-switch     PIC X(1) VALUE 'N'.
               88  is-exit-pbs-rpt-menu                VALUE 'Y'.
           05 is-exit-customer-menu-switch    PIC X(1) VALUE 'N'.
               88  is-exit-customer-menu               VALUE 'Y'.
           05 is-exit-product-menu-switch     PIC X(1) VALUE 'N'.
               88  is-exit-product-menu                VALUE 'Y'.
           05 is-exit-admin-menu-switch       PIC X(1) VALUE 'N'.
               88  is-exit-maintenance-menu            VALUE 'Y'.
           05 is-exit-statistics-menu-switch  PIC X(1) VALUE 'N'.
               88  is-exit-statistics-menu             VALUE 'Y'.

      *    Various generic variables
       01  wc-accept                    PIC X(2)    VALUE SPACE.
       
      *    Various constants
       01  HEADLINE                     PIC X(72)   VALUE ALL '-'.
       
           
      **********************************************************
       PROCEDURE DIVISION.
       0000-main.

           PERFORM A0100-init
           PERFORM B0100-show-main-menu UNTIL is-exit-application
           PERFORM Z0100-exit-application

           GOBACK
           .

      **********************************************************
       A0100-init.

           CONTINUE
           .

      **********************************************************
       B0100-show-main-menu.

           PERFORM UNTIL is-exit-application

               PERFORM B100-diplay-main-menu-list
               EVALUATE wc-accept

                   WHEN '10'
                       PERFORM C0100-load-invoices
                   WHEN '20'
                       PERFORM E0100-submit-invoices
                   WHEN '30'
                       PERFORM G0100-statistics
                   WHEN '40'
                       PERFORM I0100-company-reports
                   WHEN '50'
                       PERFORM K0100-update-customers
                   WHEN '60'
                       PERFORM M0100-update-products
                   WHEN '70'
                       PERFORM X0100-maintenance
                   WHEN '99'
                       SET is-exit-application TO TRUE
                       CONTINUE
                   WHEN OTHER
                       DISPLAY 'Ogiltigt meny val!'
               END-EVALUATE

           END-PERFORM
           .

      **********************************************************
       B100-diplay-main-menu-list.
       
           DISPLAY HEADLINE
           DISPLAY '*** PBS HUVUDMENY ***'
           DISPLAY HEADLINE
           DISPLAY '(10) Processa inkommande fakturafil'
           DISPLAY '(20) Skriv g�lden�rsfakturor'
           DISPLAY '(30) Processtatestik'
           DISPLAY '(40) PBS f�retagsrapporter'
           DISPLAY '(50) Kundregister'
           DISPLAY '(60) Tj�nster'
           DISPLAY '(70) Underh�ll'
           DISPLAY SPACE
           DISPLAY '(99) Avsluta programmet'
           DISPLAY HEADLINE
           DISPLAY ': ' WITH NO ADVANCING
           ACCEPT wc-accept
           .     

      **********************************************************
       C0100-load-invoices.

           MOVE 'N' TO is-exit-load-file-menu-switch
           PERFORM UNTIL is-exit-load-file-menu

               PERFORM C110-diplay-load-invoices-menu
               EVALUATE wc-accept

                   WHEN '11'
      *                PERFORM C0120-process-import-file
                       MOVE SPACE TO wc-accept
                   WHEN '99'
                       SET is-exit-load-file-menu TO TRUE
                       CONTINUE
                   WHEN OTHER
                       DISPLAY 'Ogiltigt meny val!'
               END-EVALUATE

           END-PERFORM
           .

      **********************************************************
       C110-diplay-load-invoices-menu.

           DISPLAY HEADLINE
           DISPLAY '*** G�LDEN�RSFAKTUROR ***'
           DISPLAY HEADLINE
           DISPLAY '(11) Importera mottagna g�lden�rsfakturor'
           DISPLAY SPACE
           DISPLAY '(99) Tillbaka till huvudmenyn'
           DISPLAY HEADLINE
           DISPLAY ': ' WITH NO ADVANCING
           ACCEPT wc-accept
           .

      **********************************************************
       E0100-submit-invoices.

           MOVE 'N' TO is-exit-print-menu-switch
           PERFORM UNTIL is-exit-print-menu

               PERFORM E110-diplay-print-menu
               EVALUATE wc-accept

                   WHEN '21'
      *                PERFORM E0120-process-all-out-invoices
                       MOVE SPACE TO wc-accept
                   WHEN '22'
      *                PERFORM E0130-process-one-out-invoice
                       MOVE SPACE TO wc-accept
                   WHEN '27'
      *                PERFORM E0140-submit-customer-invoice
                       MOVE SPACE TO wc-accept
                   WHEN '99'
                       SET is-exit-print-menu TO TRUE
                       CONTINUE
                   WHEN OTHER
                       DISPLAY 'Ogiltigt meny val!'
               END-EVALUATE

           END-PERFORM
           .

      **********************************************************
       E110-diplay-print-menu.

           DISPLAY HEADLINE
           DISPLAY '*** SKRIVA UT FAKTUROR ***'
           DISPLAY HEADLINE
           DISPLAY '(21) Skriv ut alla v�ntande g�lden�rsfakturor'
           DISPLAY '(22) Skriv ut enskild g�lden�rsfakturor'
           DISPLAY SPACE
           DISPLAY '(27) Processa och skicka kundfaktura'
           DISPLAY SPACE
           DISPLAY '(99) Tillbaka till huvudmenyn'
           DISPLAY HEADLINE
           DISPLAY ': ' WITH NO ADVANCING
           ACCEPT wc-accept
           .


      **********************************************************
       G0100-statistics.

           MOVE 'N' TO is-exit-statistics-menu-switch
           PERFORM UNTIL is-exit-statistics-menu

               PERFORM G110-diplay-statistics-menu
               EVALUATE wc-accept

                   WHEN '31'
      *                PERFORM G0120-display-in-process-logs
                       MOVE SPACE TO wc-accept
                   WHEN '32'
      *                PERFORM G0130-display-out-process-logs
                       MOVE SPACE TO wc-accept
                   WHEN '99'
                       SET is-exit-statistics-menu TO TRUE
                       CONTINUE
                   WHEN OTHER
                       DISPLAY 'Ogiltigt meny val!'
               END-EVALUATE

           END-PERFORM
           .

      **********************************************************
       G110-diplay-statistics-menu.

           DISPLAY HEADLINE
           DISPLAY '*** PROCESS RAPPORTER ***'
           DISPLAY HEADLINE
           DISPLAY '(31) Rapport inkontroll av fakturafiler'
           DISPLAY '(32) Rapport utprocess av g�lden�rsfakturor'
           DISPLAY SPACE
           DISPLAY '(99) Tillbaka till huvudmenyn'
           DISPLAY HEADLINE
           DISPLAY ': ' WITH NO ADVANCING
           ACCEPT wc-accept
           .

      **********************************************************
       I0100-company-reports.

           MOVE 'N' TO is-exit-pbs-rpt-menu-switch
           PERFORM UNTIL is-exit-pbs-rpt-menu

               PERFORM I110-diplay-cmp-report-menu
               EVALUATE wc-accept

                   WHEN '41'
      *                PERFORM I0120-display-monthly-rpt
                       MOVE SPACE TO wc-accept
                   WHEN '42'
      *                PERFORM I0130-display-accumulated-rpt
                       MOVE SPACE TO wc-accept
                   WHEN '99'
                       SET is-exit-pbs-rpt-menu TO TRUE
                       CONTINUE
                   WHEN OTHER
                       DISPLAY 'Ogiltigt meny val!'
               END-EVALUATE

           END-PERFORM
           .

      **********************************************************
       I110-diplay-cmp-report-menu.

           DISPLAY HEADLINE
           DISPLAY '*** PBS INTERNA RAPPORTER ***'
           DISPLAY HEADLINE
           DISPLAY '(41) Rapport int�kter denna m�nad'
           DISPLAY '(42) Rapport int�kter ackumulerat i �r'
           DISPLAY SPACE
           DISPLAY '(99) Tillbaka till huvudmenyn'
           DISPLAY HEADLINE
           DISPLAY ': ' WITH NO ADVANCING
           ACCEPT wc-accept
           .

      **********************************************************
       K0100-update-customers.

           MOVE 'N' TO is-exit-customer-menu-switch
           PERFORM UNTIL is-exit-customer-menu

               PERFORM K110-diplay-customer-menu
               EVALUATE wc-accept

                   WHEN '51'
                       PERFORM K0120-display-customer-list
                       MOVE SPACE TO wc-accept
                   WHEN '52'
      *                PERFORM K0130-update-customer
                       MOVE SPACE TO wc-accept
                   WHEN '53'
      *                PERFORM K0140-add-new-customer
                       MOVE SPACE TO wc-accept
                   WHEN '54'
      *                PERFORM K0150-inactivate-customer
                       MOVE SPACE TO wc-accept
                   WHEN '99'
                       SET is-exit-customer-menu TO TRUE
                       CONTINUE
                   WHEN OTHER
                       DISPLAY 'Ogiltigt meny val!'
               END-EVALUATE

           END-PERFORM
           .

      **********************************************************
       K110-diplay-customer-menu.

           DISPLAY HEADLINE
           DISPLAY '*** KUNDREGISTER ***'
           DISPLAY HEADLINE
           DISPLAY '(51) Visa kundregister'
           DISPLAY '(52) Uppdatera kundregistret'
           DISPLAY '(53) L�gg till ny kund'
           DISPLAY '(54) Inaktivera kund'
           DISPLAY SPACE
           DISPLAY '(99) Tillbaka till huvudmenyn'
           DISPLAY HEADLINE
           DISPLAY ': ' WITH NO ADVANCING
           ACCEPT wc-accept
           .

      **********************************************************
       K0120-display-customer-list.

      *    list defined customers
           EXEC SQL
               DECLARE CURS1 CURSOR FOR
               SELECT C.CUST_ID, C.ORGNO
               FROM TUTORIAL.CUSTOMER C
               ORDER BY C.CUST_ID
           END-EXEC

           DISPLAY '-----------------'
           DISPLAY 'BEFINTLIGA KUNDER'
           DISPLAY '-----------------'

           EXEC SQL
               OPEN CURS1
           END-EXEC

           EXEC SQL
               FETCH CURS1
                   INTO :CUSTOMER-CUST-ID, :CUSTOMER-ORGNO
           END-EXEC

           PERFORM UNTIL SQLCODE NOT = ZERO

               DISPLAY CUSTOMER-CUST-ID  '|' CUSTOMER-ORGNO

      *        fetch next row
               EXEC SQL
               FETCH CURS1
                   INTO :CUSTOMER-CUST-ID, :CUSTOMER-ORGNO
               END-EXEC

           END-PERFORM

      *    end of data
           IF SQLCODE NOT = 100
              DISPLAY 'SQL Error'
           END-IF

      *    close cursor sum up revenue
           EXEC SQL
               CLOSE CURS1
           END-EXEC

           .

      **********************************************************
       M0100-update-products.

           MOVE 'N' TO is-exit-product-menu-switch
           PERFORM UNTIL is-exit-product-menu

               PERFORM M110-diplay-product-menu
               EVALUATE wc-accept

                   WHEN '61'
      *                PERFORM M0120-display-product-list
                       MOVE SPACE TO wc-accept
                   WHEN '62'
      *                PERFORM M0130-update-product
                       MOVE SPACE TO wc-accept
                   WHEN '63'
      *                PERFORM M0140-add-new-product
                       MOVE SPACE TO wc-accept
                   WHEN '64'
      *                PERFORM M0150-inactivate-product
                       MOVE SPACE TO wc-accept
                   WHEN '99'
                       SET is-exit-product-menu TO TRUE
                       CONTINUE
                   WHEN OTHER
                       DISPLAY 'Ogiltigt meny val!'
               END-EVALUATE

           END-PERFORM
           .


      **********************************************************
       M110-diplay-product-menu.

           DISPLAY HEADLINE
           DISPLAY '*** PBS TJ�NSTER ***'
           DISPLAY HEADLINE
           DISPLAY '(61) Visa tj�nsteprodukter'
           DISPLAY '(62) Uppdatera tj�nsteprodukt'
           DISPLAY '(63) L�gg till ny tj�nsteprodukt'
           DISPLAY '(64) Inaktivera tj�nsteprodukt'
           DISPLAY SPACE
           DISPLAY '(99) Tillbaka till huvudmenyn'
           DISPLAY HEADLINE
           DISPLAY ': ' WITH NO ADVANCING
           ACCEPT wc-accept
           .

      **********************************************************
       X0100-maintenance.

           MOVE 'N' TO is-exit-admin-menu-switch
           PERFORM UNTIL is-exit-maintenance-menu

               PERFORM X110-diplay-maintenance-menu
               EVALUATE wc-accept

                   WHEN '71'
      *                PERFORM X0120-display-company-data
                       MOVE SPACE TO wc-accept
                   WHEN '72'
      *                PERFORM X0130-update-company-data
                       MOVE SPACE TO wc-accept
                   WHEN '73'
      *                PERFORM X0140-print-copy-of-invoice
                       MOVE SPACE TO wc-accept
                   WHEN '99'
                       SET is-exit-maintenance-menu TO TRUE
                       CONTINUE
                   WHEN OTHER
                       DISPLAY 'Ogiltigt meny val!'
               END-EVALUATE

           END-PERFORM
           .

      **********************************************************
       X110-diplay-maintenance-menu.

           DISPLAY HEADLINE
           DISPLAY '*** PROGRAM UNDERH�LL ***'
           DISPLAY HEADLINE
           DISPLAY '(71) Visa PBS f�retagsinformation'
           DISPLAY '(72) Uppdatera PBS f�retagsinformation'
           DISPLAY '(73) Skriv ut kopia av g�lden�rsfaktura'
           DISPLAY SPACE
           DISPLAY '(99) Tillbaka till huvudmenyn'
           DISPLAY HEADLINE
           DISPLAY ': ' WITH NO ADVANCING
           ACCEPT wc-accept
           .

      **********************************************************
       Z0100-exit-application.
       
      *    other terminating actions




           DISPLAY HEADLINE
           DISPLAY '*** Avslutar Programmet ***'
           DISPLAY SPACE
           DISPLAY 'Tryck <Enter> f�r att avsluta...'
               WITH NO ADVANCING
           ACCEPT wc-accept
           .

      **********************************************************
           