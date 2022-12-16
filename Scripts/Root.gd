class_name Root
extends Node2D

@onready var board: Board = $Board
@onready var ui: UI = $UI

var player: int
var game_state: int = GameState.piece
var winner: int


func _ready():
	new_game()

func new_game():
	player = 1
	game_state = GameState.piece
	switch_player()
	board.new_game()
	ui.new_game()
	for child in get_children():
		if (child is Dialog):
			remove_child(child)
			child.queue_free()

func switch_player():
	player = abs(player-1)
	ui.set_player(player)
	board.clear_jumps()

func capture(p: Piece):
	ui.capture_piece(p)
