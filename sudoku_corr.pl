

/******/

trovaElem([], _, true):-!.
trovaElem([Num|_], Num, false):-!.
trovaElem([_|T], Num, Ris):- trovaElem(T, Num, Ris).

/*es:
trovaElem([1,2,3,4,5],5,R).
trovaElem([1,2,3,4,6],5,R).

*/
/******/

creaLista([], _, []):-!.
creaLista([_|T], Val, Lris):- creaLista(T, Val, Lris2), append([Val], Lris2, Lris). 

/*es:
creaLista([1,2,3,4,5], true, R).
*/
/******/

setRowBool(L, Num, Lris):- trovaElem(L, Num, Val), creaLista(L, Val, Lris).

/*es:
setRowBool([1,2,3,4], 4, R).
*/
/******/

setRowBoolCorr([], _, _, []).
setRowBoolCorr([0|T], Num, [Hb|Tb], Lris):- setRowBoolCorr(T, Num, Tb, Lris2), append([Hb], Lris2, Lris), !.
setRowBoolCorr([_|T], Num, [_|Tb], Lris):- setRowBoolCorr(T, Num, Tb, Lris2), append([false], Lris2, Lris), !.

/*es:
setRowBoolCorr([0,1,0,3,8,0,0,0,7],3,[false, false, false, false, false, false, false, false, false], R).
setRowBoolCorr([0,1,0,3,8,0,0,0,7],2,[true, true, true, true, true, true, true, true, true], R).
*/
/*******/

setMatrix([], _, []).
setMatrix([Row|Mr], Num, Mb):- setRowBool(Row, Num, Rowb), setRowBoolCorr(Row, Num, Rowb, Rcorr), setMatrix(Mr, Num, Mb2), append([Rcorr], Mb2, Mb).

/*es: 
setMatrix([[2, 0, 0, 3, 0, 7, 0, 0, 9], [0, 1, 0, 0, 9, 0, 0, 7, 0]], 1, R).
*/

ridimMatrix([], []).
ridimMatrix([[_|[]]|_], []):-!.
ridimMatrix([[_|T1]|T2], Mris):- ridimMatrix(T2,Mris2), append([T1],Mris2,Mris).

/*es:
ridimMatrix([[2, 3, 4], [5, 6, 7]],R).
*/

trasponiStep([],[]).
trasponiStep([[H|_]|T],Mris):- trasponiStep(T,Mris2), append([H],Mris2,Mris).

/*es:
trasponiStep([[2, 3, 4], [5, 6, 7]],R).
*/

trasponi([],[]):-!.
trasponi(M,Mris):- trasponiStep(M,M2), ridimMatrix(M,M3), trasponi(M3,Mris2), append([M2],Mris2,Mris).

/*es:
trasponi([[2, 3, 4], [5, 6, 7]], R).
*/

andLog(true,true,true):-!.
andLog(_,_,false).

mergeRow([], [], []).
mergeRow([H1|T1], [H2|T2], Ris):- andLog(H1,H2,R),!, mergeRow(T1, T2, Ris2), append([R],Ris2,Ris).

/*
mergeRow([true, false, true],[false, false, true],R).
*/

mergeMatrix([],[],[]).
mergeMatrix([H1|T1],[H2|T2],Mris):- mergeRow(H1,H2,Rris), mergeMatrix(T1,T2,Mris2), append([Rris],Mris2,Mris).
/*
mergeMatrix([[true, false, true], [true, false, true]], [[false, false, true],[false, false, true]],R).
*/


spezzaFascia([], _, _, []).
spezzaFascia([H1|[H2|[H3|T]]], Num, Val, Lris):- checkBlockParz([H1, H2, H3], Num, Val, Ris), spezzaFascia(T, Num, Val, Lris2), append(Ris, Lris2, Lris). 

/***/

/*Mi dice se il numero è presente nel blocco 3 x 3, 
 *Parametri:
 * -matrice 3 x 3
 * -numero da ricercare
 * -dove memorizzare il risultato
 *Ritorna:
 * -true se il numero non è presente
 * -false altrimenti.
 */
inBlocco([], _, true).
inBlocco([H|T], Num, R):- trovaElem(H, Num, Ris), inBlocco(T, Num, R2), andLog(Ris, R2, R), !.


/*es:
inBlocco([[1, 2, 3], [1, 4, 5], [1, 2, 4]], 3, R). 
*/

checkBlockParz(M, Num, 0, Lris):- trasponi(M, Mris), spezzaFascia(Mris, Num, 1, Lris), !.
checkBlockParz(M, Num, 1, Lris):- inBlocco(M, Num, Ris), creaLista([1, 2, 3], Ris, Lris).

/*es:
caso 0: checkBlockParz([[1, 2, 3, 4, 5, 6, 7, 8, 9], [1, 4, 5, 2, 3, 6, 7, 8, 9], [1, 2, 4, 3, 5, 6, 7, 8, 9]], 3, 0, LR).
caso 1: checkBlockParz([[1, 2, 3], [1, 4, 5], [1, 2, 4]], 3, 1, LR).
*/

/***/

checkBlock([], _, []).
checkBlock([H1|[H2|[H3|T]]], Num, Mris):- checkBlockParz([H1,H2,H3], Num, 0, L1), checkBlockParz([H1,H2,H3], Num, 0, L2), checkBlockParz([H1,H2,H3], Num, 0, L3), checkBlock(T, Num, Mris2), append([L1], [L2], L12), append(L12, [L3], L123), append(L123, Mris2, Mris).
/*es:
checkBlock([[2, 0, 0, 3, 0, 7, 0, 0, 9], [0, 1, 0, 0, 9, 0, 0, 7, 0], [3, 0, 9, 0, 8, 2, 0, 0, 5], [2, 0, 0, 3, 0, 7, 0, 0, 9], [0, 1, 0, 0, 9, 0, 0, 7, 0], [3, 0, 9, 0, 8, 2, 0, 0, 5]], 1, R).	
*/
/***/

controlloRowCol(M, Num, Mris):- trasponi(M,M1), setMatrix(M1, Num, M2), trasponi(M2, M3), setMatrix(M, Num, M4), mergeMatrix(M3, M4, Mris1), checkBlock(M, Num, Mris2), mergeMatrix(Mris1, Mris2, Mris).

/*es:
controlloRowCol([[2, 0, 0, 3, 0, 7, 0, 0, 9], [0, 1, 0, 0, 9, 0, 0, 7, 0], [3, 0, 9, 0, 8, 2, 0, 0, 5], [2, 0, 0, 3, 0, 7, 0, 0, 9], [0, 1, 0, 0, 9, 0, 0, 7, 0], [3, 0, 9, 0, 8, 2, 0, 0, 5]], 1, R).	
controlloRowCol([[ 0, 6, 9, 5, 7, 1, 2, 4, 8], [8, 4, 5, 9, 3, 0, 6, 0, 7], [7, 0, 0, 0, 4, 6, 3, 5, 0], [0, 5, 1, 0, 2, 0, 9, 0, 3], [9, 7, 0, 0, 6, 8, 1, 2, 0],[2, 3, 8, 0, 0, 5, 4, 7, 6], [5, 0, 6, 4, 0, 3, 7, 0, 2], [0, 2, 7, 0, 5, 0, 8, 3, 1], [1, 0, 3, 2, 8, 7, 0, 6, 4]], 1, R).	
*/


/***/



/*******************************************************************************/

contaPos([], 0).
contaPos([true|T], R):- contaPos(T,R2),!, R is R2+1.
contaPos([false|T], R):- contaPos(T,R).

/*es:
contaPos([true, false, true, true, false], R).
*/
/*
contaIndice(0, [true|_], 0).
contaIndice(0, [false|T], Ris):- contaIndice(0, T, Ris1), Ris is Ris1+1.
contaIndice(Val, [true|T], Ris):- Val1 is Val-1, contaIndice(Val1, T, Ris1), Ris is Ris1+1.
contaIndice(Val, [false|T], Ris):- contaIndice(Val, T, Ris1), Ris is Ris1+1.
*/
/*es:
contaIndice(4, [true, true, false, false, true, true], R).
*/

inserisciNum(0, [_|T], [true|_], Num, Ris):-append([Num],T,Ris).
inserisciNum(0, [H|T], [false|Tb], Num, Ris):- inserisciNum(0, T, Tb, Num, Ris1), append([H], Ris1, Ris).
inserisciNum(Val, [H|T], [true|Tb], Num, Ris):- Val1 is Val-1, inserisciNum(Val1, T, Tb, Num, Ris1), append([H],Ris1, Ris),!.
inserisciNum(Val, [H|T], [false|Tb], Num, Ris):- inserisciNum(Val, T, Tb, Num, Ris1), append([H], Ris1, Ris),!.

/*es:
inserisciNum(3, [1, 2, 3, 4, 5, 6, 7], [false, true, true, true, false, true, false], 10, R).
*/

trovaRiga([H|_], 0, H).
trovaRiga([_|T], Id, Ris):- Id1 is Id-1, trovaRiga(T, Id1, Ris),!.

/*es:
trovaRiga([[2, 3, 4], [1, 2, 3], [6, 5, 4]], 2, R).
*/

matrixChangeRow([_|T], R, 0, Ris):- append([R], T, Ris),!.
matrixChangeRow([H|T], R, Idr, Ris):- Idr1 is Idr-1, matrixChangeRow(T, R, Idr1, Ris2), append([H], Ris2, Ris),!.

/*es:
matrixChangeRow([[1, 2, 3], [4, 5, 6], [7, 8, 9]], [1, 1, 1], 2, R).
*/

/*------------------------------------------------------------------------------------------*/

/*risolviSudoku
*/

/*Per Debug!!!
risolviSudoku(_, M, _, 10, _, _, Sol):-write(M),Sol=M.
*/
risolviSudoku(_, M, _, 10, _, _, Sol):-Sol=M.

risolviSudoku(MOrig, M, _, Num, 9, SolP, Sol):- 
	Num1 is Num+1, 
	controlloRowCol(M, Num1, NewMBool), 
	risolviSudoku(MOrig, M, NewMBool, Num1, 0, SolP, Sol),!.

risolviSudoku(MOrig, M, MBool, Num, Row, SolP, Sol):-
	trovaRiga(MBool, Row, RigaB),
	contaPos(RigaB, Npos),
	( Npos =:= 0->
		trovaRiga(MOrig, Row, RigaO),
		trovaElem(RigaO, Num, SECE),
		( SECE == false ->
			Row1 is Row+1,			
			risolviSudoku(MOrig, M, MBool, Num, Row1, SolP, Sol),!
			;
						
			SolP=false
		);

		trovaRiga(M, Row, Riga),
		trovaRiga(MBool, Row, RigaB1),
		inserisciNum(0, Riga, RigaB1, Num, NewRiga),
		matrixChangeRow(M, NewRiga, Row, NewMatrix),
		controlloRowCol(NewMatrix, Num, NewMatrixBool),
		Row2 is Row+1,
		risolviSudoku(MOrig, NewMatrix, NewMatrixBool, Num, Row2, SolP, Sol),!,
		(SolP == false ->
			trovaRiga(MBool, Row, RigaB2),
			inserisciNum(0, RigaB2, RigaB2, false, NewRigaB),
			matrixChangeRow(MBool, NewRigaB, Row, NewMatrixBool2),
			risolviSudoku(MOrig, M, NewMatrixBool2, Num, Row, SolP, Sol),!
			;

			true

		)
	).





/*
risolviSudoku([], [[ 0, 6, 9, 5, 7, 1, 2, 4, 8], [8, 4, 5, 9, 3, 0, 6, 0, 7], [7, 0, 0, 0, 4, 6, 3, 5, 0], [0, 5, 1, 0, 2, 0, 9, 0, 3], [9, 7, 0, 0, 6, 8, 1, 2, 0],[2, 3, 8, 0, 0, 5, 4, 7, 6], [5, 0, 6, 4, 0, 3, 7, 0, 2], [0, 2, 7, 0, 5, 0, 8, 3, 1], [1, 0, 3, 2, 8, 7, 0, 6, 4]], _, 10, _, S).
*/


sudoku(S, Sol):-
	controlloRowCol(S, 1, Sbool), 
	risolviSudoku(S, S, Sbool, 1, 0, SolP, Sol),
	write('\nsol:\n'),
	write(Sol).


/*
sudoku([[ 0, 6, 9, 5, 7, 1, 2, 4, 8], [8, 4, 5, 9, 3, 0, 6, 0, 7], [7, 0, 0, 0, 4, 6, 3, 5, 0], [0, 5, 1, 0, 2, 0, 9, 0, 3], [9, 7, 0, 0, 6, 8, 1, 2, 0],[2, 3, 8, 0, 0, 5, 4, 7, 6], [5, 0, 6, 4, 0, 3, 7, 0, 2], [0, 2, 7, 0, 5, 0, 8, 3, 1], [1, 0, 3, 2, 8, 7, 0, 6, 4]], Sol).
*/

