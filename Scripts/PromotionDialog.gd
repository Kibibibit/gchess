class_name PromotionDialog
extends Dialog

signal on_selected(type: int)
const promo_width: float = Game.tile_size * 4.0

const pieces: Array[int] = [Pieces.rook, Pieces.knight, Pieces.bishop, Pieces.queen]

var player: int
var invalid_pos: Vector2 = Vector2(-1,-1)
var last_mouse: Vector2 = invalid_pos
var mouse_pos: Vector2 = invalid_pos
func _init(p: int):
	super(promo_width as int,Game.tile_size)
	player = p

func _ready():
	super()
	var i: int = 0
	for piece in pieces:
		var s: Sprite2D = Sprite2D.new()
		s.texture = load("res://Sprites/pieces.png")
		s.hframes = 6
		s.vframes = 2
		s.frame_coords = Vector2(piece, player)
		s.position.x = (i * Game.tile_size) + Dialog.size
		s.position.y = Dialog.size
		s.z_index = 10
		s.centered = false
		i += 1
		add_child(s)

func _process(_delta):
	var mouse = get_local_mouse_position()
	mouse.x -= Dialog.size
	mouse.y -= Dialog.size
	
	mouse.x = floor(mouse.x/Game.tile_size)
	mouse.y = floor(mouse.y/Game.tile_size)
	
	if (mouse.x < 0 || mouse.x >= 4 || mouse.y != 0):
		mouse = invalid_pos
	mouse_pos = mouse
	if (mouse != last_mouse):
		queue_redraw()
	last_mouse = mouse
	
func _draw():
	if (mouse_pos != invalid_pos):
		var v1 = Vector2(Dialog.size + (Game.tile_size*mouse_pos.x), Dialog.size)
		var v2 = Vector2(Game.tile_size, Game.tile_size)
		
		draw_rect(Rect2(v1,v2),Color(1,0,0))

	
func _input(event):
	if event is InputEventMouseButton && mouse_pos != invalid_pos:
		emit_signal("on_selected",pieces[mouse_pos.x as int])

