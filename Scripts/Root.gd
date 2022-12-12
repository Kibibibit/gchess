class_name Root
extends Node2D

@onready var board: Board = $Board
@onready var ui: UI = $UI

var player: int
var game_state: int = GameState.piece


func _ready():
	new_game()


func new_game():
	player = 1
	switch_player()
	board.new_game()
	ui.new_game()

func switch_player():
	player = abs(player-1)
	ui.set_player(player)
