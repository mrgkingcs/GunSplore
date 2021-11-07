extends Camera2D

const MAX_SPEED = 5

var playerNode = null
var velocity = Vector2(0,0)

# Called when the node enters the scene tree for the first time.
func _ready():
	playerNode = get_node("/root/LevelRoot/PlayerRoot")

	var offset = get_viewport_rect().size/2
	global_position = playerNode.global_position - offset
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var offset = get_viewport_rect().size/2
	var targetPos = ( 
					playerNode.global_position
					+ playerNode.linear_velocity
					- offset
				)
	
	var movementNeeded = targetPos - global_position
	if movementNeeded.length() > 2:
		velocity = lerp(velocity, movementNeeded, 0.15)
		if velocity.length() > MAX_SPEED:
			velocity = velocity.normalized()*MAX_SPEED
	else:
		velocity = Vector2(0,0)

	global_position += velocity
