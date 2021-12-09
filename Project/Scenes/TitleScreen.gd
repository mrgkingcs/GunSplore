extends CanvasLayer


const FLASH_DURATION = 0.75
var flashTimer = FLASH_DURATION

const STATE_INTRO = 0
const STATE_MAIN = 1
const STATE_OUTRO = 2
var state = null

const FADE_DURATION = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	state = STATE_INTRO
	$Fader.fade_in(FADE_DURATION)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	match state:
		STATE_INTRO:
			if $Fader.is_finished():
				state = STATE_MAIN
				
		STATE_MAIN:
			if flashTimer > delta:
				flashTimer -= delta
			else:
				$StartPrompt.visible = !$StartPrompt.visible
				flashTimer = FLASH_DURATION

			if Input.is_key_pressed(KEY_SPACE):
				$Fader.fade_out(FADE_DURATION)
				state = STATE_OUTRO
		
		STATE_OUTRO:
			if $Fader.is_finished():
				get_tree().change_scene_to(load('res://Scenes/LevelRoot.tscn'))
