class_name UI
extends Node2D

@onready var player_indicator: Sprite2D = $PlayerIndicator/PlayerIndicatorSprite
@onready var root: Root = get_parent()
@onready var dialog: Dialog = Dialog.new(640-Game.board_size-Dialog.size*2, Game.board_size-Dialog.size*2)

@onready var piece_white_pawn: PieceSlot = $PieceSlots/PieceSlotWP
@onready var piece_white_other: PieceSlot = $PieceSlots/PieceSlotWO
@onready var piece_black_pawn: PieceSlot = $PieceSlots/PieceSlotBP
@onready var piece_black_other: PieceSlot = $PieceSlots/PieceSlotBO

func _ready():
	dialog.z_index = -10
	add_child(dialog)

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
