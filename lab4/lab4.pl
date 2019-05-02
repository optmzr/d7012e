% State:
% 	* Location of:
% 		brassKey, steelKey, package, robot.
% 	* Items in hand, at most 2.
%
% Moves:
% 	* Pick item,
% 	* Drop item,
% 	* Enter room.
%
% Locations:
% 	* inventory (only items),
% 	* room1,
% 	* room2,
% 	* room3.
%
% Goal:
% 	state(room1, _, _, inventory)
%
% 	Where `state`:
% 		state(RobotLocation, BrassKeyLocation, SteelKeyLocation,
% 			PackageLocation)

fullInventory(X, X, X) :- X = inventory.

% move(State, Move, NextState)

% Enter `room2` from `room1` if steel key is in the inventory.
move(	state(room1, B, inventory, P),
	enter(room2),
	state(room2, B, inventory, P)).

% Enter `room1` from `room2` if steel key is in the inventory.
move(	state(room2, B, inventory, P),
	enter(room1),
	state(room1, B, inventory, P)).

% Enter `room3` from `room1` if brass key is in the inventory.
move(	state(room1, inventory, S, P),
	enter(room3),
	state(room3, inventory, S, P)).

% Enter `room1` from `room3` if brass key is in the inventory.
move(	state(room3, inventory, S, P),
	enter(room1),
	state(room1, inventory, S, P)).

% Pick up `package` if the robot is in the same room.
move(	state(R, B, S, P), Move, NextState) :-
	R = P, % `package` and robot must be in the same room.
	\+(fullInventory(B, S, inventory)), % Inventory must not be full.
	Move = pick(package),
	NextState = state(R, B, S, inventory).

% Pick up `steelKey` if the robot is in the same room.
move(	state(R, B, S, P), Move, NextState) :-
	R = S, % `steelKey` and robot must be in the same room.
	\+(fullInventory(B, inventory, P)), % Inventory must not be full.
	Move = pick(steelKey),
	NextState = state(R, B, inventory, P).

% Pick up `brassKey` if the robot is in the same room.
move(	state(R, B, S, P), Move, NextState) :-
	R = B, % `brassKey` and robot must be in the same room.
	\+(fullInventory(inventory, S, P)), % Inventory must not be full.
	Move = pick(brassKey),
	NextState = state(R, inventory, S, P).

% Drop `package` in the same room as the robot.
move(	state(R, B, S, inventory), % Only allow drop if it's in the inventory
	drop(package),
	state(R, B, S, R)).

% Drop `steelKey` in the same room as the robot.
move(	state(R, B, inventory, P), % Only allow drop if it's in the inventory
	drop(steelKey),
	state(R, B, R, P)).

% Drop `brassKey` in the same room as the robot.
move(	state(R, inventory, S, P), % Only allow drop if it's in the inventory.
	drop(brassKey),
	state(R, R, S, P)).

% solveR(State, N, Trace)
solveR(	state(_, _, _, room2), _, [done | []]).
solveR(	State, N, [Move | Trace]) :-
	N > 0,
	move(State, Move, NextState),
	solveR(NextState, N-1, Trace).

% Run with:
% 	solveR(state(room1, room2, room1, room3), 50, T).

/* vim: set syntax=prolog */
