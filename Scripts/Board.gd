extends Node2D

var mouse_tile: Vector2 = Vector2(-1,-1)
var previous_mouse_tile: Vector2 = Vector2(-1,-1)

var pieces: Dictionary = {}

func _ready():
	new_game()

func _process(_delta):
	
	var mouse: Vector2 = get_global_mouse_position()
	if (mouse.x > 480):
		mouse_tile = Vector2(-1,-1)
	else:
		mouse_tile = Vector2(floor(mouse.x/60), floor(mouse.y/60))
	
	if (mouse_tile != previous_mouse_tile):
		previous_mouse_tile = mouse_tile
		queue_redraw()
		

func _draw():
	if (mouse_tile != Vector2(-1,-1)):
		draw_rect(Rect2(Vector2(mouse_tile.x*60,mouse_tile.y*60),Vector2(60,60)),Color(1,1,0), false, 5)

func x_y_to_key(x:int, y:int):
	return (x << 3) + y

func new_game() -> void:
	pieces = {}
	for i in range(0,2):
		for x in range(0,8):
			var y: int = 6-5*i
			var p: Piece = Piece.new(i,0)
			p.position = Vector2(x*60, y*60)
			pieces[x_y_to_key(x,y)] = p
		var types: Array[int] = [1,2,3,5-i,4+i,3,2,1]
		for x in range(0,8):
			var y: int = 7-7*i
			var p: Piece =  Piece.new(i,types[x])
			p.position = Vector2(x*60, y*60)
			pieces[x_y_to_key(x,y)] = p
	
	for key in pieces:
		add_child(pieces[key])
