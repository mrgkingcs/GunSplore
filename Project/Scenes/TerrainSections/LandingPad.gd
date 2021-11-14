extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

const ANIM_RED = 0
const ANIM_AMBER = 1
const ANIM_GREEN = 2

export var colourFrame = 0

var colourFrameAnims = [ "Red", "Amber", "Green"]

# Called when the node enters the scene tree for the first time.
func _ready():
	$StaticBody2D/Sprite.animation = colourFrameAnims[colourFrame]

func setColourFrame(newFrameIndex):
	colourFrame = newFrameIndex
	$StaticBody2D/Sprite.animation = colourFrameAnims[colourFrame]
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
