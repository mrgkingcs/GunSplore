extends KinematicBody2D


const LEVEL_CONTROLLER_PATH = "/root/LevelRoot/LevelController"
var levelController = null

const DEATH_DELAY = 0.25
var deathTimer = -1

# Called when the node enters the scene tree for the first time.
func _ready():
	levelController = get_node(LEVEL_CONTROLLER_PATH)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if deathTimer > 0:
		deathTimer -= delta
		if deathTimer <= 0:
			get_parent().remove_child(self)
			queue_free()
			
func takeDamage(damage):
	levelController.spawnBigExplosion(get_global_transform().get_origin())
	deathTimer = DEATH_DELAY
