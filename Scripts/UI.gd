class_name UI
extends Node2D

@onready var player_indicator: Sprite2D = $PlayerIndicator/PlayerIndicatorSprite
@onready var root: Root = get_parent()
@onready var dialog: Dialog = Dialog.new(640-Game.board_size-Dialog.size*2, Game.board_size-Dialog.size*2)

@onready var piece_white_pawn: PieceSlot = $PieceSlots/PieceSlotWP
@onready var piece_white_other: PieceSlot = $PieceSlots/PieceSlotWO
@onready var piece_black_pawn: PieceSlot = $PieceSlots/PieceSlotBP
@onready var piece_black_other: PieceSlot = $PieceSlots/PieceSlotBO

@onready var new_button: NewButton = NewButton.new()

func _ready():
	dialog.z_index = -10
	add_child(dialog)
	new_button.position.y = Game.board_size - NewButton.new_height - (Dialog.size*2) - 10
	new_button.position.x = (160.0/2) - (NewButton.new_width as float /2) - Dialog.size
	new_button.z_index = 10
	add_child(new_button)

func new_game():
	piece_white_pawn.new_game()
	piece_white_other.new_game()
	piece_black_pawn.new_game()
	piece_black_other.new_game()

func set_player(player: int):
	player_indicator.frame_coords.y = player

func capture_piece(p: Piece):
	if (p.player == 0):
		if (p.type == Pieces.pawn):
			piece_white_pawn.add_piece(p.type)
		else:
			piece_white_other.add_piece(p.type)
	else:
		if (p.type == Pieces.pawn):
			piece_black_pawn.add_piece(p.type)
		else:
			piece_black_other.add_piece(p.type)
