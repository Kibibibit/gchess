class_name PromotionDialog
extends Dialog

signal on_selected(type: int)

const promo_width: float = 240.0

func _init():
	super(promo_width as int,160)

func _input(event):
	if event is InputEventMouseButton:
		emit_signal("on_selected",Pieces.queen)
