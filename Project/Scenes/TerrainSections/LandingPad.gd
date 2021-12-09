extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

const ANIM_RED = 0
const ANIM_AMBER = 1
const ANIM_GREEN = 2

export var colourFrame = 0

var colourFrameAnims = [ "Red", "Amber", "Green"]

var landingBody = null
var landingTimer = -1

var levelController = null

# Called when the node enters the scene tree for the first time.
func _ready():
	$StaticBody2D/Sprite.animation = colourFrameAnims[colourFrame]
	levelController = get_node("/root/LevelRoot/LevelController")

func setColourFrame(newFrameIndex):
	colourFrame = newFrameIndex
	$StaticBody2D/Sprite.animation = colourFrameAnims[colourFrame]
	

func unlock():
	setColourFrame(ANIM_AMBER)
	$LandingArrows.visible = true
	var hintNode = get_node("Hint")
	if hintNode != null:
		hintNode.visible = false

func body_is_landed(body):
	if body.linear_velocity.length() > 2:
		return false
	if body.angular_velocity > 0.1:
		return false
	if body.transform.get_rotation() > 0.1:
		return false
	return true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if colourFrame != ANIM_RED and landingBody != null:
		if body_is_landed(landingBody):
			setColourFrame(ANIM_GREEN)
			if landingTimer < 0:
				landingTimer = 0.5
			else:
				landingTimer -= delta
				if landingTimer < 0:
					landingBody = null
					handle_landed()
		else:
			setColourFrame(ANIM_AMBER)
			landingTimer = -1


func _on_LandingArea_body_entered(body):
	if body.has_method("is_player") and body.is_player():
		landingBody = body


func _on_LandingArea_body_exited(body):
	if landingBody == body:
		landingBody = null

func handle_landed():
	levelController.handlePlayerLanded()
