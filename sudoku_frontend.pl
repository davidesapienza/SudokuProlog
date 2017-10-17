

/* Ricorsivamente definisce le celle (box) per riga e inserisce il risultato Sol. */
col_grid(10, _, _, _, _, _,  _):- !.
col_grid(C,CC,CT, RC, RT, [H|T], [H1|T1]):-
	send(@p, display, new(B, box(50,50)), point(CC,RC)),
	send(@p, display,new(A, text(H)), point(CT,RT)),
	send(A, font, font(times, bold, 18)),

        send(@p, display, new(_E, box(50,50)), point(CC+500,RC)),
	send(@p, display,new(D, text(H1)), point(CT+500,RT)),
	send(D, font, font(times, bold, 18)),

        C1 is C+1,
	CC1 is CC+50,
	CT1 is CT+50,
	col_grid(C1,CC1,CT1,RC,RT,T,T1)
	.

/* Ricorsivamente richiama per ogni riga il metodo col_grid per disegnare le celle. */
row_grid(10, _, _, _, _) :- !.
row_grid(R,RC,RT, [H|T], [H1|T1]) :-

        col_grid(1,10,20,RC,RT,H, H1), %posizione testo nella riga 20

	R1 is R+1,
	RC1 is RC+50,
	RT1 is RT+50,
	row_grid(R1, RC1, RT1, T, T1)
	.


scelta_sudoku(Livello) :-
        new(D, dialog('Scrivi livello')),
        send(D, append(new(LivelloItem, text_item(livello)))),
        send(D, append(button(ok, message(D, return,LivelloItem?selection)))),
        send(D, append(button(cancel, message(D, return, @nil)))),
        send(D, append(new(_Label1, text("Inserire il livello tra: Facile, Medio e Difficile.")))),
        send(D, default_button(ok)),
        get(D, confirm, Rval),
        free(D),
        Rval \== @nil,
        Livello = Rval,
        free(@q)
        .

calcola_tempo(Tempo, M, S) :-
        %write(Tempo),
        get_time(T2),
        DeltaT is T2-Tempo,
       % write("\nDelta:"),
        write(DeltaT),
        Aus is floor(DeltaT),
        write(Aus),
        M is Aus // 60, %minuti
        S is Aus mod 60, %secondi
        write(M), write(S)
        .

/* Metodo pricipale per creare le finestre grafiche e catturare la scelta dell'utente per risolvere il giusto sudoku. */
play_sudoku(Livello) :-

        consult('sudoku_corr.pl'),
        Fac = [[0, 6, 9, 5, 7, 1, 2, 4, 8], [8, 4, 5, 9, 3, 0, 6, 0, 7], [7, 0, 0, 0, 4, 6, 3, 5, 0], [0, 5, 1, 0 ,2 ,0, 9, 0 ,3],
               [9, 7, 0, 0, 6, 8, 1, 2, 0], [2, 3 ,8, 0, 0, 5, 4, 7, 6], [5, 0, 6, 4, 0, 3, 7, 0, 2], [0, 2, 7, 0, 5, 0, 8, 3, 1], [1, 0, 3, 2, 8, 7, 0, 6, 4]],
        Med = [[0, 0, 8, 6, 7, 0, 0, 0, 5], [5, 0, 2, 0, 0, 0, 0, 0, 4], [0, 6, 0, 5, 0, 0, 0, 3, 0], [8, 2, 3, 0, 6, 7, 5, 4, 9],
               [0, 0, 0, 2, 0, 0, 0, 0, 0], [0, 7, 5, 0, 0, 0, 0, 8, 6], [0, 8, 6, 0, 0, 5, 9, 7, 0], [7, 0, 0, 0, 1, 3, 0, 2, 0], [0, 0, 0, 0, 8, 0, 4, 0, 3]],
        Dif = [[8, 0, 0, 0, 0, 5, 0, 7, 1], [6, 1, 3, 4, 0, 0, 0, 2, 0], [0, 0, 0, 0, 2, 3, 0, 4, 0], [3, 0, 4, 5, 0, 9, 0, 6, 0],
               [0, 0, 7, 0, 3, 0, 8, 0, 0], [0, 2, 0, 8, 0, 7, 9, 0, 5], [0, 6, 0, 2, 9, 0, 0, 0, 0], [0, 3, 0, 0, 0, 4, 1, 8, 6], [5, 7, 0, 3, 0, 0, 0, 0, 2]],

        /* Costruisco la dialag-box iniziale per la scelta del livello */
        scelta_sudoku(Livello),

        /* Recupero il valore inserito */
        string_upper(Livello, Scelta),

        /* Definisco la finestra in cui sara' mostrata la soluzione */
        new(@p, window('Sudoku')), send(@p, size, size(970,500)), send(@p, open),

        /* CALCOLO IL TEMPO */
        get_time(T1),

        /* Casi possibili */
        (Scelta == "FACILE" -> write("Scelto sudoku Facile"), sudoku(Fac, Sol),
         row_grid(1,10,20,Fac,Sol), calcola_tempo(T1, M, S),string_concat("Tempo: ", M, TempoP),string_concat(TempoP, S, TempoF), send(@p, display, new(T,
                                     text(TempoF)), point(10,470));

        (Scelta == "MEDIO" -> write("Scelto sudoku Medio"), sudoku(Med, Sol),
         row_grid(1,10,20,Med,Sol), send(@p, display, new(_T,text("Tempo: ")), point(10,470)), calcola_tempo(T1, 0, 0);

        (Scelta == "DIFFICILE" -> write("Scelto sudoku Difficile"), sudoku(Dif, Sol),
         row_grid(1,10,20,Dif,Sol), send(@p, display, new(_T,text("Tempo: ")), point(10,470)), calcola_tempo(T1, 0, 0);

        /* Se non si effettua la scelta corretta di livello */
         free(@p),
	 new(@q, window('Sudoku')), send(@q, size, size(500,200)), send(@q, open),
         send(@q, display, new(T,text("La scelta del livello non è corretta.\nSi prega di rieffettuare l'accesso.")),
         point(10,10)), send(T, font, font(times, bold, 18))
        )))
        .


