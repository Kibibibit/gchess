class_name Piece
extends Node2D

@onready var sprite: Sprite2D = Sprite2D.new()
@onready var texture: Texture = load("res://Sprites/pieces.png")
@onready var board: Board = get_parent()
var player: int
var type: int
var moved: bool = false

func _init(_player: int, _type: int):
	self.player = _player
	self.type = _type
	
func valid_moves(x: int, y: int):
	var positions: Array[Vector2] = []
	var mult = -1+(player*2)
	for direction in directions():
		var d = Vector2(direction.x, direction.y)
		for i in range(0,distance()):
			var pos = Vector2(x+d.x*((i+1)),y+d.y*(i+1)*mult)
			if (_valid_move_filter(pos)):
				positions.append(pos)
				if (tile_has_enemy(pos)):
					break
			else:
				break
	if (type == Pieces.pawn):
		for i in range(0,2):
			var pos = Vector2(x-1+(i*2),y*mult)
			if (tile_has_enemy(pos)):
				positions.append(pos)
			
		
	return positions

func valid_moves_v(vector: Vector2):
	return valid_moves(vector.x as int, vector.y as int)

func distance() -> int:
	match type:
		Pieces.pawn:
			if (moved):
				return 1
			return 2
		Pieces.knight, Pieces.king:
			return 1
		_:
			return 8

func directions() -> Array[Vector2]:
	match type:
		Pieces.pawn:
			return [Vector2(0,1)]
		Pieces.rook:
			return [Vector2(0,1),Vector2(0,-1), Vector2(1,0), Vector2(-1,0)]
		Pieces.knight:
			return [
				Vector2(1,2),
				Vector2(-1,2),
				Vector2(1,-2),
				Vector2(-1,-2),
				Vector2(2,1),
				Vector2(2,-1),
				Vector2(-2,1),
				Vector2(-2,-1)
			]
		Pieces.bishop:
			return [Vector2(1,1),Vector2(-1,1),Vector2(1,-1),Vector2(-1,-1)]
		Pieces.queen,Pieces.king:
			return [
				Vector2(0,1),
				Vector2(0,-1), 
				Vector2(1,0), 
				Vector2(-1,0),
				Vector2(1,1),
				Vector2(-1,1),
				Vector2(1,-1),
				Vector2(-1,-1)
			]
		_:
			return []

func _valid_move_filter(pos: Vector2):
	if (in_bounds(pos)):
		var p = board.get_piece_v(pos)
		if (p == null):
			return true
		else:
			return tile_has_enemy(pos)
	return false
func in_bounds(pos: Vector2):
	return pos.x < 8 && pos.x >= 0 && pos.y < 8 && pos.y >= 0

func tile_has_enemy(pos: Vector2):
	if (!in_bounds(pos)):
		return false
	var p = board.get_piece_v(pos)
	if (p != null):
		return p.player != player
	return false

func _ready():
	sprite.texture = texture
	sprite.centered = false
	sprite.hframes = 6
	sprite.vframes = 2
	sprite.frame_coords = Vector2(type,player)
	add_child(sprite)

func _exit_tree():
	sprite.queue_free()
