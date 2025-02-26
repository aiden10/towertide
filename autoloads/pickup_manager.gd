extends Node

var gold_pool = []
var xp_pool = []

var max_gold_pool_size = 100
var max_xp_pool_size = 100

func spawn_item(spawn_position: Vector2) -> Pickup:
	var item
	item = Scenes.item_pickup_scene.instantiate()
	## Don't add if there no available items
	if not item.item:
		item.queue_free()
		return
	add_child(item)
	item.position = spawn_position
	
	return item

func spawn_gold(spawn_position: Vector2) -> void:
	if gold_pool.size() >= max_gold_pool_size:
		var oldest_gold = gold_pool.pop_front()
		if is_instance_valid(oldest_gold):
			oldest_gold.queue_free()

	var gold = Scenes.gold_scene.instantiate()
	gold.position = spawn_position
	gold_pool.push_back(gold)
	add_child(gold)

func spawn_xp(spawn_position: Vector2) -> void:
	if xp_pool.size() >= max_xp_pool_size:
		var oldest_xp = xp_pool.pop_front()
		if is_instance_valid(oldest_xp):
			oldest_xp.queue_free()

	var xp = Scenes.xp_scene.instantiate()
	xp.position = spawn_position
	xp_pool.push_back(xp)
	add_child(xp)
