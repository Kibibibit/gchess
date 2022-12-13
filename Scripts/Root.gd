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
	switch_player()
	board.new_game()
	ui.new_game()

func switch_player():
	player = abs(player-1)
	ui.set_player(player)
	
func _exit_tree():
	cleanup(self)
	self.queue_free()

func cleanup(node: Node):
	for child in node.get_children():
		cleanup(child)
		child.queue_free()
