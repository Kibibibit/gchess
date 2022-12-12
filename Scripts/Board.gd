class_name Board
extends Node2D

const invalid_tile: Vector2 = Vector2(-1,-1)
var mouse_tile: Vector2 = invalid_tile
var previous_mouse_tile: Vector2 = invalid_tile

var selected_piece: Piece
var selected_piece_pos: Vector2
var valid_moves: Array[Vector2] = []

@onready var root: Root = get_parent()

var pieces: Dictionary = {}

func _process(_delta):
	var mouse: Vector2 = get_global_mouse_position()
	if (mouse.x > Game.board_size):
		mouse_tile = invalid_tile
	else:
		mouse_tile = Vector2(floor(mouse.x/Game.tile_size), floor(mouse.y/Game.tile_size))
	
	if (mouse_tile != previous_mouse_tile):
		previous_mouse_tile = mouse_tile
		queue_redraw()

func get_piece_v(pos: Vector2) -> Piece:
	return get_piece(pos.x as int,pos.y as int)
func get_piece(x: int, y: int) -> Piece:
	if (pieces.has(x_y_to_key(x,y))):
		var p = pieces[x_y_to_key(x,y)] 
		if (p != null):
			return p as Piece
	return null

func draw_tile_border(pos: Vector2, color: Color):
	draw_rect(Rect2(Vector2(pos.x*Game.tile_size,pos.y*Game.tile_size),Vector2(Game.tile_size,Game.tile_size)),color, false, 5)

func _input(event):
	if !(event is InputEventMouseButton):
		return
	if event.pressed:
		return
	if (root.game_state == GameState.piece):
		_input_piece_state(event as InputEventMouseButton)
	elif(root.game_state == GameState.move):
		_input_move_state(event as InputEventMouseButton)
		

func _input_piece_state(event: InputEventMouseButton):
	if (mouse_tile == invalid_tile || event.button_index != MOUSE_BUTTON_LEFT):
		return
	var p: Piece = get_piece_v(mouse_tile)
	if (p == null):
		return
	if (p.player == root.player):
		if (p.valid_moves_v(mouse_tile).size() > 0):
			selected_piece = p
			selected_piece_pos = mouse_tile
			valid_moves = p.valid_moves_v(mouse_tile)
			root.game_state = GameState.move
			queue_redraw()
	
func _input_move_state(event: InputEventMouseButton):
	if (event.button_index == MOUSE_BUTTON_RIGHT && selected_piece != null):
		selected_piece = null
		selected_piece_pos = invalid_tile
		valid_moves = []
		root.game_state = GameState.piece
		queue_redraw()
		return
	if (mouse_tile == invalid_tile):
		return

func _draw():
	
	if (mouse_tile == invalid_tile):
		return
	
	match root.game_state:
		GameState.piece:
			var p: Piece = get_piece_v(mouse_tile)
			if (p != null):
				if (p.player == root.player):
					draw_tile_border(mouse_tile,Color(1,1,0))
		GameState.move:
			if (selected_piece_pos != invalid_tile):
				draw_tile_border(selected_piece_pos,Color(0,1,0))
			
		

func x_y_to_key(x:int, y:int):
	return (x << 3) + y

func new_game() -> void:
	pieces = {}
	for i in range(0,2):
		for x in range(0,8):
			var y: int = 6-5*i
			var p: Piece = Piece.new(i,Pieces.pawn)
			p.position = Vector2(x*Game.tile_size, y*Game.tile_size)
			pieces[x_y_to_key(x,y)] = p
		var types: Array[int] = [Pieces.rook,Pieces.knight,Pieces.bishop,Pieces.king,Pieces.queen,Pieces.bishop,Pieces.knight,Pieces.rook]
		for x in range(0,8):
			var y: int = 7-7*i
			var p: Piece =  Piece.new(i,types[x])
			p.position = Vector2(x*Game.tile_size, y*Game.tile_size)
			pieces[x_y_to_key(x,y)] = p
	
	for key in pieces:
		add_child(pieces[key])
