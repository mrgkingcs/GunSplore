extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var smallExplosion = preload("res://Scenes/ExplosionSmall.tscn")
var bigExplosion = preload("res://Scenes/ExplosionBig.tscn")

var enemyContainer = null
var numEnemies = -1

var finishLandingPad = null

# Called when the node enters the scene tree for the first time.
func _ready():
	enemyContainer = get_node("../EnemyContainer")
	numEnemies = enemyContainer.get_child_count()
	
	finishLandingPad = get_node("/root/LevelRoot/Cave/FinishLandingPad")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var newNumEnemies = enemyContainer.get_child_count()
	if numEnemies != newNumEnemies:
		numEnemies = newNumEnemies
		if numEnemies == 0:
			finishLandingPad.unlock()

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
