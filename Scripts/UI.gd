class_name UI
extends Node2D

@onready var player_indicator: Sprite2D = $PlayerIndicator/PlayerIndicatorSprite
@onready var root: Root = get_parent()
@onready var dialog: Dialog = Dialog.new(640-Game.board_size-Dialog.size*2, Game.board_size-Dialog.size*2)

func _ready():
	dialog.z_index = -10
	add_child(dialog)

func new_game():
	pass

func set_player(player: int):
	player_indicator.frame_coords.y = abs(player-1)
