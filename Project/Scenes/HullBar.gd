extends HBoxContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func setHull(fraction):
	$BarContainer/BarFill.anchor_right = fraction
	if fraction <= 0:
		$BarContainer/BarFill.visible = false
