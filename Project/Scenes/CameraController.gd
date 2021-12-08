extends Camera2D

const MAX_SPEED = 5

var playerNode = null

var velocityArray
var currPosIndex

# Called when the node enters the scene tree for the first time.
func _ready():
	playerNode = get_node("/root/LevelRoot/PlayerRoot")

	var offset = get_viewport_rect().size/2
	global_position = playerNode.global_position - offset
	
	velocityArray = []
	for _count in range(0,32):
		velocityArray.append(Vector2())
	currPosIndex = 0
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if playerNode != null:
		var offset = get_viewport_rect().size/2
		var targetPos = ( 
						playerNode.global_position
						+ playerNode.linear_velocity
						- offset
					)
		velocityArray[currPosIndex] = playerNode.linear_velocity*0.75
		currPosIndex = (currPosIndex+1) % len(velocityArray)
		
		var meanVelocity = Vector2(0,0)
		for entry in velocityArray:
			meanVelocity += entry
		meanVelocity *= 1.0/len(velocityArray)
		
		var meanTargetPos = meanVelocity*0.6 + playerNode.global_position - offset

		global_position = lerp(global_position, meanTargetPos, 0.5*50*delta)
