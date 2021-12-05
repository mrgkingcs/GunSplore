extends KinematicBody2D


# Declare member variables here. Examples:
const BULLET_DAMAGE = 1

const BASE_SPEED = 350
const BASE_VEL = Vector2.UP * BASE_SPEED
var vel
var fired = false

const LEVEL_CONTROLLER_PATH = "/root/LevelRoot/LevelController"
var levelController = null

# Called when the node enters the scene tree for the first time.
func _ready():
	levelController = get_node(LEVEL_CONTROLLER_PATH)
	
func fire(gunVel):
	fired = true
	vel = transform.basis_xform(BASE_VEL) + gunVel
	show()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _physics_process(delta):
	if(fired):
		var frameMove = vel * delta;
		var collision = move_and_collide(frameMove);
		if collision != null:
			levelController.spawnSmallExplosion(get_global_transform().get_origin())
			levelController.doDamage(collision.collider, BULLET_DAMAGE)
			hide()
			queue_free()
