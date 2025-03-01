extends Node

var gold_pool = []
var xp_pool = []
var item_pool = []

var max_gold_pool_size = 250
var max_xp_pool_size = 250
var max_item_pool_size = 25

var xp_scenes = {
	1: Scenes.xp_scene,
	2: Scenes.xp2_scene
}

func _ready() -> void:
	EventBus.level_exited.connect(clear_pools)

func clear_pools() -> void:
	for pickup in gold_pool + xp_pool + item_pool:
		if is_instance_valid(pickup):
			pickup.queue_free()
		
	gold_pool = []
	xp_pool = []
	item_pool = []
	
func spawn_item(spawn_position: Vector2) -> void:
			
	if Items.unique_items.size() > 0:
		if item_pool.size() >= max_item_pool_size:
			var oldest_item = item_pool.pop_front()
			if is_instance_valid(oldest_item):
				oldest_item.queue_free()

		var item = Scenes.item_pickup_scene.instantiate()
		item.position = spawn_position
		item_pool.push_back(item)
		call_deferred("add_child", item)

func spawn_gold(spawn_position: Vector2) -> void:
	if gold_pool.size() >= max_gold_pool_size:
		var oldest_gold = gold_pool.pop_front()
		if is_instance_valid(oldest_gold):
			oldest_gold.queue_free()

	var gold = Scenes.gold_scene.instantiate()
	gold.position = spawn_position
	gold_pool.push_back(gold)
	call_deferred("add_child", gold)

func spawn_xp(spawn_position: Vector2, xp_type: int) -> void:
	if xp_pool.size() >= max_xp_pool_size:
		var oldest_xp = xp_pool.pop_front()
		if is_instance_valid(oldest_xp):
			oldest_xp.queue_free()
	
	var xp_scene = xp_scenes[xp_type]
	var xp = xp_scene.instantiate()
	xp.position = spawn_position
	xp_pool.push_back(xp)
	call_deferred("add_child", xp)
