class_name WinnerDialog
extends Dialog


@onready var player_sprite: Sprite2D = Sprite2D.new()
@onready var win_sprite: Sprite2D = Sprite2D.new()
var player: int

const winner_width = 54*2
const winner_height = 32*2

func _init(winner: int):
	super(winner_width,winner_height)
	player = winner

func _ready():
	super()
	configure_sprite(player_sprite)
	configure_sprite(win_sprite)
	player_sprite.frame_coords.y = player
	win_sprite.frame_coords.y = 2
	win_sprite.position.y += 32
	

func configure_sprite(sprite: Sprite2D):
	sprite.texture = load("res://Sprites/player.png")
	sprite.centered= false
	sprite.hframes = 1
	sprite.vframes = 3
	sprite.z_index = 10
	sprite.position.x = Dialog.size
	sprite.position.y = Dialog.size
	add_child(sprite)
