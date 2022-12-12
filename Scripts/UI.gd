class_name UI
extends Node2D

@onready var player_indicator: Sprite2D = $PlayerIndicator/PlayerIndicatorSprite
@onready var root: Root = get_parent()

func new_game():
	pass

func set_player(player: int):
	player_indicator.frame_coords.y = abs(player-1)
