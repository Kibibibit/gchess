class_name PieceSlot
extends Node2D

@export var black: bool = false

@onready var sprite = $Sprite2D

var player: int = 0
var i: int = 0

func _ready():
	if (black):
		player = 1
	sprite.queue_free()
	remove_child(sprite)

func add_piece(p: int):
	var s = Sprite2D.new()
	s.centered = false
	s.position.x = i*((Game.tile_size as float)/4)
	s.texture =  load("res://Sprites/pieces.png")
	s.hframes = 6
	s.vframes = 2
	s.z_index = 1000+i
	s.frame_coords = Vector2(p,player)
	i += 1
	add_child(s)
	
