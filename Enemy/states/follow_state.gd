extends State

@export var enemy: Enemy
var player

func _ready():
	player = get_tree().get_first_node_in_group("Player")

func physics_update(_delta: float):
	
	var direction = player.global_position - enemy.global_position

	if direction.length() > enemy.distance_threshold:
		enemy.velocity = direction.normalized() * enemy.speed
	else:
		enemy.velocity = Vector2()
		transitioned.emit(self, "attack")
		return
	
