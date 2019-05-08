/*
 Lab P2: Smallest k sets revisited
 Course: D7012E Declarative languages
 Student: William Wennerström <wenwil-5@student.ltu.se>
*/

% Calculates the sum of a list.
% sum :: List -> Int
sum([], 0).
sum([N], Sum) :- Sum is N, !. % Do not return 2 solutions w/ & w/o empty list.
sum([N|Tail], Sum) :-
	sum(Tail, NextSum),
	Sum is N + NextSum.

% Returns the sublist between two indices (inclusive).
% sublist :: List -> I -> J -> List
sublist([_Skip|Tail], I, J, NewList) :-
	I > 0, I =< J,
	NextI is I - 1, NextJ is J - 1,
	sublist(Tail, NextI, NextJ, NewList).
sublist([Include|Tail], 0, J, NewList) :-
	0 =< J,
	NextJ is J - 1,
	NewList = [Include|Rest],
	sublist(Tail, 0, NextJ, Rest).
sublist([Include|_], _, 0, [Include]). % Inclusive.

% Produces all possible subsets with their corresponding sum and indices.
% sets :: List -> Sets
sets([], []).
sets(List, Sets) :- aux(List, 0, 0, Sets).

% Auxiliary function for sets that increments I and J to every valid range of
% sublists.
% aux :: List -> Int -> Int -> Sets
aux(List, I, J, Sets) :- % When J < Length(List).
	sublist(List, I, J, Sublist),
	sum(Sublist, Sum),
	NextJ is J+1,
	aux(List, I, NextJ, NextSets), !,
	Sets = [set(Sum, I, J, Sublist)|NextSets].
aux(List, I, _J, NextSets) :-
	length(List, Length), I < Length,
	NextI is I+1,
	aux(List, NextI, NextI, NextSets), !.
aux(_List, Same, Same, []).

% The sum of a set.
% setSum :: Set -> Int
setSum(set(Sum, _, _, _), Sum).

% Quicksort a list of sum(Sum, I, J, Sublist).
% quicksort :: Sets -> Sets
quicksort([], []).
quicksort([Pivot|Rest], SortedList) :-
	partition(Pivot, Rest, Left, Right),
	quicksort(Left, SortedLeft),
	quicksort(Right, SortedRight),
	append(SortedLeft, [Pivot|SortedRight], SortedList).

% Partition a list of sum(Sum, I, J, Sublist) into two recursively at a pivot.
% partition :: Set -> Sets -> Sets -> Sets
partition(_Pivot, [], [], []).
partition(Pivot, [Head|Tail], [Head|SortedLeft], SortedRight) :-
	setSum(Pivot, PivotSum), setSum(Head, HeadSum),
	HeadSum =< PivotSum,
	partition(Pivot, Tail, SortedLeft, SortedRight).
partition(Pivot, [Head|Tail], SortedLeft, [Head|SortedRight]) :-
	setSum(Pivot, PivotSum), setSum(Head, HeadSum),
	HeadSum  > PivotSum,
	partition(Pivot, Tail, SortedLeft, SortedRight).

% kSmallestSets :: Int -> List -> Sets
kSmallestSets(_K, List, KSets) :-
	sets(List, Sets),
	quicksort(Sets, SortedSets),
	KSets = SortedSets.

/* vim: set syntax=prolog */
