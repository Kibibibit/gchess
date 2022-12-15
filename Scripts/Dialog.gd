class_name Dialog
extends Node2D

@onready var top_left: Sprite2D = Sprite2D.new()
@onready var top_right: Sprite2D = Sprite2D.new()
@onready var bottom_left: Sprite2D = Sprite2D.new()
@onready var bottom_right: Sprite2D = Sprite2D.new()
@onready var top: Sprite2D = Sprite2D.new()
@onready var bottom: Sprite2D = Sprite2D.new()
@onready var left: Sprite2D = Sprite2D.new()
@onready var right: Sprite2D = Sprite2D.new()
@onready var center: Sprite2D = Sprite2D.new()
@onready var texture: Texture = load("res://Sprites/ui-element.png")
const size: int = 16

var height: int
var width: int


func _init( w: int,h: int):
	height = h
	width = w

func _ready():
	set_width(top,width)
	set_width(bottom, width)
	
	set_height(left, height)
	set_height(right, height)
	
	set_width(center, width)
	set_height(center, height)
	
	top_left.position = Vector2(0,0)
	top.position = Vector2(size,0)
	top_right.position = Vector2(size+width,0)
	
	left.position = Vector2(0,size)
	center.position = Vector2(size, size)
	right.position = Vector2(size+width,size)
	
	bottom_left.position = Vector2(0,size+height)
	bottom.position = Vector2(size,size+height)
	bottom_right.position = Vector2(size+width, size+height)
	
	var sprites: Array[Sprite2D] = [top_left, top_right, top, bottom_left, bottom_right, bottom, left, right, center]
	var i = 0
	for sprite in sprites:
		sprite.centered = false
		sprite.texture = texture
		sprite.vframes = 3
		sprite.hframes = 3
		sprite.frame = i
		add_child(sprite)
		i = i + 1
		

func pixels_to_scale(pixels: int) -> float:
	return (pixels as float) / size

func set_width(sprite: Sprite2D, w:int):
	sprite.scale.x = pixels_to_scale(w)

func set_height(sprite: Sprite2D, h:int):
	sprite.scale.y = pixels_to_scale(h)
	
func _exit_tree():
	for child in get_children():
		child.queue_free()
