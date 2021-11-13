extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const BASE_SPEED = 350
const BASE_VEL = Vector2.UP * BASE_SPEED
var vel
var fired = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

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
			hide()
			queue_free()
