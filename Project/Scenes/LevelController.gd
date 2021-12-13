extends Node2D


# Declare member variables here. Examples:
const FADE_DURATION = 1

var smallExplosion = preload("res://Scenes/ExplosionSmall.tscn")
var bigExplosion = preload("res://Scenes/ExplosionBig.tscn")

var player = null

var playerHullBar = null
var enemyCounter = null
var lifeCounter = null
var fader = null

var enemyContainer = null
var numEnemies = -1

var finishLandingPad = null

const STATE_PLAYING = 0
const STATE_WIN = 1
const STATE_DEAD = 2
var state

# Called when the node enters the scene tree for the first time.
func _ready():
	enemyContainer = get_node("../LevelData/EnemyContainer")
	numEnemies = enemyContainer.get_child_count()
	
	player = get_node("../PlayerRoot")
	
	playerHullBar = get_node("../CanvasLayer/HullBar")
	enemyCounter = get_node("../CanvasLayer/EnemyCounter")
	enemyCounter.setNumEnemies(numEnemies)
	lifeCounter = get_node("../CanvasLayer/LifeCounter")
	lifeCounter.setNumLives(GameController.getNumLives())
	fader = get_node("../CanvasLayer/Fader")
	fader.fade_in(FADE_DURATION)
	
	finishLandingPad = get_node("/root/LevelRoot/LevelData/Cave/FinishLandingPad")
	
	state = STATE_PLAYING

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	match state:
		STATE_PLAYING:
			var newNumEnemies = enemyContainer.get_child_count()
			if numEnemies != newNumEnemies:
				numEnemies = newNumEnemies
				enemyCounter.setNumEnemies(numEnemies)
				if numEnemies == 0:
					finishLandingPad.unlock()

		STATE_WIN:
			if fader.is_finished():
				#get_tree().change_scene_to(load("res://Scenes/TitleScreen.tscn"))
				GameController.levelComplete()

		STATE_DEAD:
			if fader.is_finished():
				#get_tree().change_scene_to(load("res://Scenes/TitleScreen.tscn"))
				GameController.playerDied()

func spawnSmallExplosion(position):
	var explosion = smallExplosion.instance()
	explosion.set_global_position(position)
	add_child(explosion)

func spawnBigExplosion(position):
	var explosion = bigExplosion.instance()
	explosion.set_global_position(position)
	add_child(explosion)

func doDamage(object, damage):
	if object.has_method("takeDamage"):
		object.takeDamage(damage)

func setPlayerHull(hull):
	playerHullBar.setHull(hull)
	if(hull <= 0):
		handlePlayerDead()

func handlePlayerLanded():
	player.disable()
	fader.fade_out(FADE_DURATION)
	state = STATE_WIN

func handlePlayerDead():
	get_node("../Camera2D").playerNode = null
	player.disable()
	fader.fade_out(FADE_DURATION)
	state = STATE_DEAD
