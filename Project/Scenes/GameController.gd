extends Node


var levelList = [
	"res://Scenes/Level1.tscn",
	"res://Scenes/Level2.tscn",
	"res://Scenes/Level3.tscn",
	"res://Scenes/Level4.tscn",
	"res://Scenes/Level5.tscn",
	"res://Scenes/Level6.tscn"
]

var currentLevel = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func startGame():
	currentLevel = 0
	startLevel()

func gameOver():
	get_tree().change_scene_to(load("res://Scenes/TitleScreen.tscn"))
	
func levelComplete():
	currentLevel += 1
	if currentLevel < len(levelList):
		startLevel()
	else:
		gameComplete()

func startLevel():
	get_tree().change_scene_to(load(levelList[currentLevel]))

func gameComplete():
	get_tree().change_scene_to(load("res://Scenes/TitleScreen.tscn"))
