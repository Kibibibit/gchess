class_name Piece
extends Node2D

@onready var sprite: Sprite2D = Sprite2D.new()
@onready var texture: Texture = load("res://Sprites/pieces.png")
var player: int
var type: int

func _init(_player: int, _type: int):
	self.player = _player
	self.type = _type

func _ready():
	sprite.texture = texture
	sprite.centered = false
	sprite.hframes = 6
	sprite.vframes = 2
	sprite.frame_coords = Vector2(type,player)
	add_child(sprite)


func _exit_tree():
	sprite.queue_free()
