

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



/*
controlloRowCol([[0,6,9,5,7,1,2,4,8],[8,4,5,9,3,0,6,1,7],[7,0,0,0,4,6,3,5,0],[0,5,1,0,2,0,9,0,3],[9,7,0,0,6,8,1,2,0],[2,3,8,0,0,5,4,7,6],[5,0,6,4,0,3,7,0,2],[0,2,7,0,5,0,8,3,1],[1,0,3,2,8,7,0,6,4]], 1, R).

[[false,false,false,false,false,false,false,false,false],[false,false,false,false,false,false,false,false,false],[false,true,true,false,false,false,false,false,false],[false,false,false,true,false,true,false,false,false],[false,false,false,true,false,false,false,false,false],[false,false,false,true,true,false,false,false,false],[false,false,false,false,true,false,false,false,false],[false,false,false,true,false,true,false,false,false],[false,false,false,false,false,false,false,false,false]]

R = [[false, false, false, false, false, false, false, false|...], [false, false, false, false, false, false, false|...], [false, true, false, false, false, false|...], [false, false, false, false, false|...], [false, false, false, false|...], [false, false, false|...], [false, false|...], [false|...], [...|...]].

---

[[0,6,9,5,7,1,2,4,8],[8,4,5,9,3,0,6,1,7],[7,1,0,0,4,6,3,5,0],[0,5,1,0,2,0,9,0,3],[9,7,0,0,6,8,1,2,0],[2,3,8,0,0,5,4,7,6],[5,0,6,4,0,3,7,0,2],[0,2,7,0,5,0,8,3,1],[1,0,3,2,8,7,0,6,4]]

[[false,false,false,false,false,false,false,false,false],[false,false,false,false,false,false,false,false,false],[false,false,false,false,false,false,false,false,false],[false,false,false,true,false,true,false,false,false],[false,false,false,true,false,false,false,false,false],[false,false,false,true,true,false,false,false,false],[false,false,false,false,true,false,false,false,false],[false,false,false,true,false,true,false,false,false],[false,false,false,false,false,false,false,false,false]]


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
/*
risolviSudoku(_, _, _, _, _, true, _):-!.*/
/*
risolviSudoku(_, M, _, 10, _, true, M):- write(' fine '), !.

risolviSudoku(MOrig, M, _, Num, 9, Aus, Ris):- write(' fine_num '),Num1 is Num+1, controlloRowCol(M, Num1, Ris1), risolviSudoku(MOrig, M, Ris1, Num1, 0, Aus, Ris).

risolviSudoku(MOrig, M, MBool, Num, Row, Aus, Ris):- 

	write(' inizio:  '),

	
	trovaRiga(MBool, Row, RigaB), 
	contaPos(RigaB, Npos), 
	write('Num:'),
	write(Num),
	write('  Row:'),
	write(Row),
	write('  Npos:'),
	write(Npos),
	write('\n'),
	(
		Npos =:= 0 -> 
			write(' 1if-true '),write('\n'),
			trovaRiga(MOrig, Row, Riga), 
			trovaElem(Riga, Num, SECE), 
			(
				SECE==true ->
					write(' 2if-true '),
					write('\n'),
					Aus=false;
					write(' 2if-false '),write('\n'),	
					Row1 is Row+1,			
					risolviSudoku(MOrig, M, MBool, Num, Row1, Aus, Ris),
					write('qui arrivi?')
					
			); 
			write(' 1if-false '),write('\n'),

			trovaRiga(M, Row, Riga1), 
			trovaRiga(MBool, Row, RigaB1), 
			inserisciNum(0, Riga1, RigaB1, Num, NewRiga), 
			matrixChangeRow(M, NewRiga, Row, NewMatrix), 
			controlloRowCol(NewMatrix, Num, NewMatrixB), 
			Row1 is Row+1,
			risolviSudoku(MOrig, NewMatrix, NewMatrixB, Num, Row1, Aus, Ris), 
			(
				Aus==false -> 
					write(' 3if-false '),write('\n'),
					trovaRiga(MBool, Row, RigaBFalsa),
					inserisciNum(0, RigaBFalsa, RigaBFalsa, false, NewRigaBF), 
					matrixChangeRow(MBool, NewRigaBF, Row, NewMatrixBF), 
					risolviSudoku(MOrig, M, NewMatrixBF, Num, Row, Aus, Ris);

					write(' 3if-true '),write('\n'),
					true
					
				
			)
			
	),
	write('fine\n').

*/

/*Se viene dall'inseirmento di un nuovo numero -> 3*/
/*
risolviSudoku(MOrig, M, MBool, Num, Row, 3, false, Ris):-
	write(' 3if-false con 3 '),write('\n'),
	trovaRiga(MBool, Row, RigaBFalsa),
	inserisciNum(0, RigaBFalsa, RigaBFalsa, false, NewRigaBF), 
	matrixChangeRow(MBool, NewRigaBF, Row, NewMatrixBF), 
	risolviSudoku(MOrig, M, NewMatrixBF, Num, Row, 1, true, Ris).
*/
/*Se viene da una riga con già il numero: deve tornare alla riga ancora precedente e il tipo deve essere quello precedente.. quale?
Se il numero è presente nella riga precedente nella matrice originale, allora era 2, 
altrimenti non può avere fatto altro che inserirlo, allora 3.*/
/*
risolviSudoku(MOrig, M, MBool, Num, Row, 2, false, Ris):-
	write(' 3if-false con 2 '),write('\n'),
	NewRow is Row-1,
	trovaRiga(MOrig, NewRow, NewRiga), 
	trovaElem(NewRiga, Num, SECE),
	(
		SECE==false->
			(
				Num=:=1 ->
					(
						Row=:=0 ->
							NewTipo is 3,
							Val = true;
							
							NewTipo is 2,
							Val = false
					);
					
					NewTipo is 2,
					Val = false
			);
			NewTipo is 3,
			Val = false
	),
	risolviSudoku(MOrig, M, MBool, Num, NewRow, NewTipo, Val, Ris).
*/
/*Se deve tornare sopra nei numeri precedenti, allora deve se la riga e il numero precedenti contengono in MOrig il numero allora il 2, altrimenti il 3.*/
/*
risolviSudoku(MOrig, M, MBool, Num, _, 4, false, Ris):-
	write(' 3if-false con 4 '),write('\n'),
	trovaRiga(MOrig, 8, NewRiga),
	NewNum is Num, 
	trovaElem(NewRiga, NewNum, SECE),
	(
		SECE==false->
			NewTipo is 2;
			NewTipo is 3
	),
	risolviSudoku(MOrig, M, MBool, NewNum, 8, NewTipo, false, Ris).


risolviSudoku(_, M, _, 10, _, _, true, M):- write(' fine '), !.

risolviSudoku(MOrig, M, _, Num, 9, _, Aus, Ris):- 
	write(' fine_num '),
	Num1 is Num+1, 
	controlloRowCol(M, Num1, Ris1), 
	risolviSudoku(MOrig, M, Ris1, Num1, 0, 4, Aus, Ris).

risolviSudoku(MOrig, M, MBool, Num, Row, Tipo, Aus, Ris):- 

	write(' inizio:  '),
	OldTipo is Tipo, 
	
	trovaRiga(MBool, Row, RigaB), 
	contaPos(RigaB, Npos), 
	write('Num:'),
	write(Num),
	write('  Row:'),
	write(Row),
	write('  Npos:'),
	write(Npos),
	write('  Tipo:'),
	write(Tipo),
	write('\n'),
	(
		Npos =:= 0 -> 
			write(' 1if-true '),write('\n'),
			trovaRiga(MOrig, Row, Riga), 
			trovaElem(Riga, Num, SECE), 
			(
				SECE==true ->
					write(' 2if-true '),
					write('\n'),
					NewAus=false,
					NewR is Row-1,
					NewM=M,
					NewMB=MBool,
					NewTipo is OldTipo;

					write(' 2if-false '),write('\n'),	
					NewAus=Aus,
					NewR is Row+1,			
					NewM=M,
					NewMB=MBool,
					NewTipo is 2
			); 
			write(' 1if-false '),write('\n'),
			trovaRiga(M, Row, Riga1), 
			trovaRiga(MBool, Row, RigaB1), 
			inserisciNum(0, Riga1, RigaB1, Num, NewRiga), 
			matrixChangeRow(M, NewRiga, Row, NewMatrix), 
			controlloRowCol(NewMatrix, Num, NewMatrixB), 
			NewM=NewMatrix,
			NewMB=NewMatrixB, 	
			NewR is Row+1,
			NewAus = Aus,
			NewTipo is 3
					
	),
	risolviSudoku(MOrig, NewM, NewMB, Num, NewR, NewTipo, NewAus, Ris).
	
*/
/*
settaFalso(0, true, false):-write(' settaFalso '),!.
settaFalso(_, _, true).
*/
/*es:
settaFalso(0,true, S).
settaFalso(1, true, S).
settaFalso(0, false, S).
settaFalso(1, false, S).
settaFalso(10, true, S).
settaFalso(10, false, S).
*/
/*
incRow(Row, 0, false, RowOut):- write(' incRow '),write(Row), RowOut is 1+Row,!.
incRow(Row, _, _, Row):-!.
*/
/*es:
incRow(0, 0, false, R).
incRow(0, 1, false, R).
incRow(0, 0, true, R).
incRow(0, 1, true, R).
incRow(10, 0, false, R).
incRow(10, 2, false, R).
incRow(10, 3, true, R).
incRow(10, 0, true, R).
*/
/*
insNum(M, MBool, _, Row, 0, Row, M, MBool):-!.
insNum(M, MBool, Num, Row, _, NewRow, NewM, NewMB):-
	write(' insNum '),
	write(Num),
	trovaRiga(M, Row, Riga),
	trovaRiga(MBool, Row, RigaB),
	write(Riga),
	write('\n'),
	write(RigaB),
	write('\n'),
	inserisciNum(0, Riga, RigaB, Num, NewRiga),
	matrixChangeRow(M, NewRiga, Row, NewMatrix), 
	controlloRowCol(NewMatrix, Num, NewMatrixB),
	NewM = NewMatrix,	
	NewMB = NewMatrixB,
	NewRow is Row+1,
	write('\n'),
	write(NewM),
	write('\n'),
	write(NewMB),
	write('\n'),
	write(NewRow),
	write('\n'),
	!.*/
/*
insNum([[0,2,3],[0,5,7],[0,0,6]],[[true, false, false],[true, false, false],[true, true, true]], 1, 1, 4, R, M, MB).
insNum([[0,2,3],[0,5,7],[0,0,6]],[[true, false, false],[true, false, false],[true, true, true]], 1, 1, 0, R, M, MB).
*/
/*
risolviSudoku(MOrig, M, MBool, Num, Row, false, Sol):-
	write('  falso  '),
	trovaRiga(MBool, Row, RigaB),
	inserisciNum(0, RigaB, RigaB, false, NewRigaB),
	matrixChangeRow(MBool, NewRigaB, Row, NewMatrixB),
	risolviSudoku(MOrig, M, NewMatrixB, Num, Row, true, Sol).

risolviSudoku(_, M, _, 10, _, _, M):-write('arrivato'), !.

risolviSudoku(MOrig, M, _, Num, 9, SolP, Sol):- 
	write(' fine riga '),
	Num1 is Num+1, 
	write(Num1), 
	controlloRowCol(M, Num1, R1), 
	risolviSudoku(MOrig, M, R1, Num1, 0, SolP, Sol).

risolviSudoku(MOrig, M, MBool, Num, Row, SolP, Sol):-
	write(' giusto '),
	trovaRiga(MBool, Row, Riga),
	contaPos(Riga, Npos),
	trovaRiga(MOrig, Row, RigaO),
	trovaElem(RigaO, Num, SECE),*/
/*SECE é false se nella riga c'è il numero, false altrimenti*/
/*	write('\n'),
	write(' Npos '),	
	write(Npos),
	write(' Row '),	
	write(Row),
	write('\n'),
	settaFalso(Npos, SECE, SolP1),
	(SolP1 -> write(' SolP1vero '); write('SolP1falso')), 
	incRow(Row, Npos, SECE, NewRow),*/
/*se SolP1 è false, allora non devo fare niente.. devo aspettare che torni nella chiamata precedente
poi dovrò chiamare*/
/*	insNum(M, MBool, Num, NewRow, Npos, NewRow1, NewM, NewMB),

	risolviSudoku(MOrig, NewM, NewMB, Num, NewRow1, SolP1, Sol).*/


/*prova(_, _, _, _, _, false, _, 0, true).*/



/*------------------------------------------------------------------------------------------*/

/*risolviSudoku
*/
/*Per Debug!!!
risolviSudoku(_, M, _, 10, _, _, Sol):-write(M),Sol=M.
*/
risolviSudoku(_, M, _, 10, _, _, Sol):-Sol=M.
/*
risolviSudoku(_, M, _, 10, _, SolP, Sol):-*/
/*write('arrivato!! fine!!'),write('\n'), */
/*write('\nciao\n'),write(M),write('\n'),write('bo1\n'),Sol=M, SolP = true, write('bo2\n'), write(Sol), write('\noks\n'),!.
*/
risolviSudoku(MOrig, M, _, Num, 9, SolP, Sol):- 
/*	write('cambio riga! '),
	write(Num),write('\n'),*/
	Num1 is Num+1, 
	controlloRowCol(M, Num1, NewMBool), 
	risolviSudoku(MOrig, M, NewMBool, Num1, 0, SolP, Sol),
	/*Sol is Sol1,*/
/*
write('\n1\n'),
	write(Sol),*/!
.

risolviSudoku(MOrig, M, MBool, Num, Row, SolP, Sol):-
/*	write('\nParametri:\n'),
	write(' M '),	
	write(M),
	write('\n'),	
	write(' MB '),	
	write(MBool),
	write('\n'),
	write('Num '),
	write(Num),
	write('  Row '),
	write(Row),*/
	trovaRiga(MBool, Row, RigaB),
	contaPos(RigaB, Npos),
/*	write(' Npos '),
	write(Npos),

	write('\n'),
*/
	( Npos =:= 0->
		trovaRiga(MOrig, Row, RigaO),
		trovaElem(RigaO, Num, SECE),
		( SECE == false ->
			Row1 is Row+1,			
			risolviSudoku(MOrig, M, MBool, Num, Row1, SolP, Sol),
			/*Sol is Sol1,*/
/*write('\n2\n'),write(Sol),
*/
!
/*,
			(Sol1 == false ->
				Sol=false;
				!,
				true
			)*/;
						
			SolP=false
		);

		trovaRiga(M, Row, Riga),
		trovaRiga(MBool, Row, RigaB1),
		inserisciNum(0, Riga, RigaB1, Num, NewRiga),
		matrixChangeRow(M, NewRiga, Row, NewMatrix),
		controlloRowCol(NewMatrix, Num, NewMatrixBool),
		Row2 is Row+1,
		risolviSudoku(MOrig, NewMatrix, NewMatrixBool, Num, Row2, SolP, Sol),
		/*Sol is Sol2,*/
/*write('\n3\n'),write(Sol),*/!,
		(SolP == false ->
			trovaRiga(MBool, Row, RigaB2),
			inserisciNum(0, RigaB2, RigaB2, false, NewRigaB),
			matrixChangeRow(MBool, NewRigaB, Row, NewMatrixBool2),
			risolviSudoku(MOrig, M, NewMatrixBool2, Num, Row, SolP, Sol),
			/*Sol is Sol3,*/
/*write('\n4\n'),write(Sol),*/!
/*,
			(Sol3 == false ->
				Sol=false;
				!,
				true
			)*/;
			true

		)
	).





/*
risolviSudoku([], [[ 0, 6, 9, 5, 7, 1, 2, 4, 8], [8, 4, 5, 9, 3, 0, 6, 0, 7], [7, 0, 0, 0, 4, 6, 3, 5, 0], [0, 5, 1, 0, 2, 0, 9, 0, 3], [9, 7, 0, 0, 6, 8, 1, 2, 0],[2, 3, 8, 0, 0, 5, 4, 7, 6], [5, 0, 6, 4, 0, 3, 7, 0, 2], [0, 2, 7, 0, 5, 0, 8, 3, 1], [1, 0, 3, 2, 8, 7, 0, 6, 4]], _, 10, _, S).
*/
/*
*/	
/*
sudoku(S, Sol):-
	controlloRowCol(S, 1, Sbool), 
	risolviSudoku(S, S, Sbool, 1, 0, 0, true, Sol).

*/

sudoku(S, Sol):-
	controlloRowCol(S, 1, Sbool), 
	risolviSudoku(S, S, Sbool, 1, 0, SolP, Sol),
	write(SolP),
	write('\nsol:\n'),
	write(Sol).


/*sudoku(S, Sol):-controlloRowCol(S, 1, Sbool), risolviSudoku(S, S, Sbool, 1, 0, true, Sol).*/
/*, b_getval(Soluzione). 
*/
/*
prova(Num, Ris):- (Num > 10 -> write('ciao '), (Num > 15 -> write('ciao!'); write('bo!')); write('niente'), Ris = false), write('ecco '),Ris == false -> write('falso').
*/

/*prova(Val, Ris):- Val=true, write(true), Val==false -> Ris=true; Ris=false.
*/
/***/

/*
sudoku([[ 0, 6, 9, 5, 7, 1, 2, 4, 8], [8, 4, 5, 9, 3, 0, 6, 0, 7], [7, 0, 0, 0, 4, 6, 3, 5, 0], [0, 5, 1, 0, 2, 0, 9, 0, 3], [9, 7, 0, 0, 6, 8, 1, 2, 0],[2, 3, 8, 0, 0, 5, 4, 7, 6], [5, 0, 6, 4, 0, 3, 7, 0, 2], [0, 2, 7, 0, 5, 0, 8, 3, 1], [1, 0, 3, 2, 8, 7, 0, 6, 4]], Sol).
*/

prova([],Sol):-Sol = 1,!.
prova([H|T],Sol):-
(H==0 -> 
	prova(T,Sol);
	(H1 is H-1,
	prova([H1|T],Sol))
).

prova1(Num,Sol):-Sol=Num.
