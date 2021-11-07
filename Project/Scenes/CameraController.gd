extends Camera2D

const MAX_SPEED = 5

var playerNode = null

var targetPosArray
var currPosIndex

# Called when the node enters the scene tree for the first time.
func _ready():
	playerNode = get_node("/root/LevelRoot/PlayerRoot")

	var offset = get_viewport_rect().size/2
	global_position = playerNode.global_position - offset
	
	targetPosArray = [ global_position, global_position, global_position, global_position, global_position ] 
	currPosIndex = 0
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var offset = get_viewport_rect().size/2
	var targetPos = ( 
					playerNode.global_position
					+ playerNode.linear_velocity
					- offset
				)
	targetPosArray[currPosIndex] = targetPos
	currPosIndex = (currPosIndex+1) % len(targetPosArray)
	
	var meanTargetPos = Vector2(0,0)
	for entry in targetPosArray:
		meanTargetPos += entry
	meanTargetPos *= 1.0/len(targetPosArray)

	global_position = lerp(global_position, meanTargetPos, 0.75)
