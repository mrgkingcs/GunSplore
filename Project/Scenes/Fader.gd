extends ColorRect


# Declare member variables here. Examples:
var fadeDuration
var fadeTimer = 0
var destAlpha
var startAlpha

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if fadeTimer > 0:
		fadeTimer -= delta
		if fadeTimer <= 0:
			color.a = destAlpha
			fadeTimer = 0
		else:
			var fadeFraction = 1 - (fadeTimer / float(fadeDuration))
			color.a = lerp(startAlpha, destAlpha, fadeFraction)


func fade_in(duration):
	startAlpha = 1
	destAlpha = 0
	fadeDuration = duration
	fadeTimer = duration

func fade_out(duration):
	startAlpha = 0
	destAlpha = 1
	fadeDuration = duration
	fadeTimer = duration

func is_finished():
	return (fadeTimer == 0)
