extends Node

const pawn: int = 0
const rook: int = 1
const knight: int = 2
const bishop: int = 3
const queen: int = 4
const king: int = 5

const rook_directions: Array[Vector2] = [
	Vector2(0,1),Vector2(0,-1), Vector2(1,0), Vector2(-1,0)
]

const knight_directions: Array[Vector2] = [
	Vector2(1,2),
	Vector2(-1,2),
	Vector2(1,-2),
	Vector2(-1,-2),
	Vector2(2,1),
	Vector2(2,-1),
	Vector2(-2,1),
	Vector2(-2,-1)
]

const bishop_directions: Array[Vector2] = [
	Vector2(1,1),Vector2(-1,1),Vector2(1,-1),Vector2(-1,-1)
]

const all_directions: Array[Vector2] = [
	Vector2(0,1),
	Vector2(0,-1), 
	Vector2(1,0), 
	Vector2(-1,0),
	Vector2(1,1),
	Vector2(-1,1),
	Vector2(1,-1),
	Vector2(-1,-1)
]
