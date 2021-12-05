extends RigidBody2D

const BASE_GUN_IMPULSE = Vector2.UP * 20
const BASE_MOMENT_OF_INERTIA = 200

const GUN_DELAY = 0.15
var leftGunTimer = 0
var rightGunTimer = 0

var bulletTemplate = null

# Called when the node enters the scene tree for the first time.
func _ready():
	bulletTemplate = get_node("../PlyrBulletTemplate")
	inertia = BASE_MOMENT_OF_INERTIA


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if leftGunTimer > delta:
		leftGunTimer -= delta
	else:
		leftGunTimer = 0
		
	if rightGunTimer > delta:
		rightGunTimer -= delta
	else:
		rightGunTimer = 0
		
	if(leftGunTimer == 0 and Input.is_action_pressed("left_gun_fire")):
		fire_left_gun()
		leftGunTimer = GUN_DELAY
	if(rightGunTimer == 0 and Input.is_action_pressed("right_gun_fire")):
		fire_right_gun()
		rightGunTimer = GUN_DELAY
		

func fire_left_gun():
	var bulletInstance = bulletTemplate.duplicate()
	get_owner().add_child(bulletInstance)
	bulletInstance.transform = Transform2D($GunLeft.global_transform)
	bulletInstance.fire(linear_velocity)
	
	$FirePlayer.play()
	
	apply_impulse(transform.basis_xform($GunLeft.position), transform.basis_xform(BASE_GUN_IMPULSE))

func fire_right_gun():
	var bulletInstance = bulletTemplate.duplicate()
	get_owner().add_child(bulletInstance)
	bulletInstance.transform = Transform2D($GunRight.global_transform)
	bulletInstance.fire(linear_velocity)
	
	$FirePlayer.play()
	
	apply_impulse(transform.basis_xform($GunRight.position), transform.basis_xform(BASE_GUN_IMPULSE))
