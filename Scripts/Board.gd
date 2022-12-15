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
var king_positions: Array[Vector2] = []

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
	return get_grid(x,y,pieces)
	
func get_grid(x:int,y:int,dict: Dictionary)->Piece:
	if (x < 8 && x >= 0 && y < 8 && y >= 0):
		if (dict.has(x_y_to_key(x,y))):
			var p = dict[x_y_to_key(x,y)] 
			if (p != null):
				return p as Piece
	return null

func draw_tile_border(pos: Vector2, color: Color):
	draw_rect(Rect2(Vector2(pos.x*Game.tile_size,pos.y*Game.tile_size),Vector2(Game.tile_size,Game.tile_size)),color, false, 5)

func _input(event):
	if (root.game_state == GameState.awaiting):
		return
	if !(event is InputEventMouseButton):
		return
	if event.pressed:
		return
	if (root.game_state == GameState.piece):
		_input_piece_state(event as InputEventMouseButton)
	elif(root.game_state == GameState.move):
		await _input_move_state(event as InputEventMouseButton)
		

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
func deselect():
	selected_piece = null
	selected_piece_pos = invalid_tile
	valid_moves = []
	root.game_state = GameState.piece
	queue_redraw()

func _input_move_state(event: InputEventMouseButton):
	if ((event.button_index == MOUSE_BUTTON_RIGHT || mouse_tile == invalid_tile) && selected_piece != null):
		deselect()
		return
	if (mouse_tile == invalid_tile):
		return
	if (valid_moves.find(mouse_tile) != -1):
		var mouse_key = x_y_to_key(mouse_tile.x as int, mouse_tile.y as int)
		if (pieces.has(mouse_key)):
			remove_child(pieces[mouse_key])
			pieces[mouse_key].queue_free()
			pieces.erase(mouse_key)
		pieces.erase(x_y_to_key(selected_piece_pos.x as int, selected_piece_pos.y as int))
		pieces[mouse_key] = selected_piece
		if (selected_piece.type == Pieces.king):
			king_positions[root.player] = mouse_tile
		selected_piece.position.x = mouse_tile.x * Game.tile_size
		selected_piece.position.y = mouse_tile.y * Game.tile_size
		selected_piece.moved = true
		if (selected_piece.type == Pieces.pawn && (mouse_tile.y as int == 7 || mouse_tile.y as int == 0)):
			await promote_pawn(mouse_tile)
		selected_piece = null
		selected_piece_pos = invalid_tile
		valid_moves = []
		root.switch_player()
		
		if (!check_checkmate(root.player)):
			root.game_state = GameState.piece
		else:
			root.winner = abs(root.player - 1)
			print("Checkmate! ",["White","Black"][root.winner]," wins!") 
			root.game_state = GameState.checkmate
		queue_redraw()
	else:
		deselect()
		

func promote_pawn(at: Vector2) -> void:
	root.game_state = GameState.awaiting
	var dialog: PromotionDialog = PromotionDialog.new(root.player)
	dialog.position.x = (Game.board_size as float/2)-((PromotionDialog.promo_width-Dialog.size)/2)
	root.add_child(dialog)
	var new_piece = await dialog.on_selected
	root.remove_child(dialog)
	var key = x_y_to_key(at.x as int,at.y as int)
	pieces[key].type = new_piece
	pieces[key].update_sprite()
	
	return 

func _draw():
	match root.game_state:
		GameState.piece:
			if (mouse_tile == invalid_tile):
				return
			var p: Piece = get_piece_v(mouse_tile)
			if (p != null):
				if (p.player == root.player):
					draw_tile_border(mouse_tile,Color(1,1,0))
		GameState.move:
			if (selected_piece_pos != invalid_tile):
				draw_tile_border(selected_piece_pos,Color(0,1,0))
			for move in valid_moves:
				if (mouse_tile == move):
					draw_tile_border(move,Color(1,1,0))
				elif (get_piece_v(move) != null):
					draw_tile_border(move,Color(1,0,0))
				else:
					draw_tile_border(move,Color(0,0,1))
			
		

func x_y_to_key(x:int, y:int):
	return (x << 3) + y

func new_game() -> void:
	pieces = {}
	king_positions = []
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
			if (p.type == Pieces.king):
				king_positions.append(Vector2(x,y))
			pieces[x_y_to_key(x,y)] = p
	
	for key in pieces:
		add_child(pieces[key])

func would_be_in_check(x:int, y:int,piece: Piece, pos: Vector2) -> bool:
	var player = piece.player
	var king_pos = king_positions[player]
	if (piece.type == Pieces.king):
		king_pos = pos
	var board_state = pieces.duplicate()
	board_state.erase(x_y_to_key(x,y))
	board_state[x_y_to_key(pos.x as int,pos.y as int)] = piece
	return king_in_check(player,board_state,king_pos)
	
func king_in_check(player: int, board_state:Dictionary, king_pos: Vector2) -> bool:
	
	### Check if pawns could capture king
	var y = -1+(player*2)
	for i in range(0,2):
		var x = -1+(i*2)
		var p = get_grid((king_pos.x+x) as int,(king_pos.y+y) as int,board_state)
		if (p != null):
			if (p.type == Pieces.pawn && p.player != player):
				return true
	### Check if knights could capture king
	for d in Pieces.knight_directions:
		var p = get_grid((king_pos.x+d.x) as int,(king_pos.y+d.y) as int,board_state)
		if (p != null):
			if (p.type == Pieces.knight && p.player != player):
				return true
				
	### Check if king could capture king (Not going to happen but it prevents a king moving adjacent
	### to another king
	for d in Pieces.all_directions:
		var p = get_grid((king_pos.x+d.x) as int, (king_pos.y+d.y) as int, board_state)
		if (p != null):
			if (p.type == Pieces.king && p.player != player):
				return true
	
	### Check if queen, bishop or rook could capture king
	var direction_list = [Pieces.all_directions, Pieces.rook_directions, Pieces.bishop_directions]
	var piece_list = [Pieces.queen, Pieces.rook, Pieces.bishop]
	for i in range(0,direction_list.size()):
		var directions = direction_list[i]
		var piece = piece_list[i]
		for d in directions:
			var mult = 1
			while mult < 8:
				var p = get_grid((king_pos.x+(d.x*mult)) as int, (king_pos.y+(d.y*mult)) as int, board_state)
				if (p != null):
					if (p.type == piece && p.player != player):
						return true
					elif (p.type != piece):
						break
				mult += 1
				
			
	
	return false

func check_checkmate(player: int):
	for key in pieces.keys():
		var p = pieces[key]
		if (p.player == player):
			if (p.valid_moves(p.position.x/Game.tile_size as int, p.position.y/Game.tile_size as int).size() > 0):
				return false
	return true
