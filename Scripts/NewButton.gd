class_name NewButton
extends Dialog

const new_width = 54*2
const new_height = 16*2

var mouse_in: bool = false
var last_mouse_in: bool = false
@onready var text: Sprite2D = Sprite2D.new()

func _init():
	super(new_width,new_height)
	

func _ready():
	super()
	text.texture = load("res://Sprites/player.png")
	text.vframes = 4
	text.frame_coords.y = 3
	text.centered = false
	text.position = Vector2(Dialog.size, Dialog.size)
	add_child(text)

func _input(event):
	if (event is InputEventMouseButton):
		if (!event.pressed && event.button_index == MOUSE_BUTTON_LEFT):
			if (mouse_in):
				get_parent().get_parent().new_game()

func _process(_delta):
	var mouse = get_local_mouse_position()
	mouse.x -= Dialog.size
	mouse.y -= Dialog.size
	if (mouse.x >= 0 && mouse.x <= new_width && mouse.y >= 0 && mouse.y <= new_height):
		mouse_in = true
	else:
		mouse_in = false
	if (mouse_in != last_mouse_in):
		queue_redraw()
	last_mouse_in = mouse_in
	
func _draw():
	if (mouse_in):
		var off = Dialog.size*0.5
		var r_p = Vector2(off, off)
		var r_s = Vector2(new_width + Dialog.size, new_height + Dialog.size)
		draw_rect(Rect2(r_p,r_s),Color(1,0,0))
