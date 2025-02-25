extends State

var player

func _ready():
	player = get_tree().get_first_node_in_group("Player")

func physics_update(_delta: float):
	var direction = player.global_position - enemy.global_position
	enemy.velocity = direction.normalized() * enemy.speed
