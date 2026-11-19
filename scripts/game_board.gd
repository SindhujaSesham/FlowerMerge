extends Node2D

#Game Board Properties
const BOARD_SIZE = 5
const STARTING_FLOWERS = 8
const MIN_FLOWERS = 6
const FLOWER_SCENE = preload("res://scenes/Flower.tscn")

var flowers_by_cell: Dictionary = {}

@onready var grass_layer = $Node2D/GrassLayer
@onready var flowers_container = $Node2D/Flowers

@export var orders_area: Control
@export var order_label: Label
@export var completed_orders_label: Label

#Variables 
var random_x = randi_range(0, BOARD_SIZE - 1)
var random_y = randi_range(0, BOARD_SIZE - 1)

#Game Board Set-Up
func _spawn_random_flower_types() -> void:
	var available_cells = grass_layer.get_valid_cells()
	
	available_cells = available_cells.filter(
		func(cell): return not flowers_by_cell.has(cell)
	)
	
	if available_cells.is_empty():
		return
	var random_cell = available_cells.pick_random()
	
	spawn_flower(0, random_cell)

func _ready()-> void:
	_initialize_game_board()
	
	for i in range(STARTING_FLOWERS):
		_spawn_random_flower_types()
	
	if orders_area != null:
		print("OrdersArea connected successfully!")
	else:
		print("OrdersArea is not connected.")
	
	generate_new_order()
	
func _initialize_game_board() -> void:
	flowers_by_cell.clear()
	#flowers_by_cell = {}
	#flowers_by_cell[Vector2i(x, y)] = flower
	
#Game Play
#Game Play Variables
signal flower_move(flower)
signal merge_end(flower, player_spot)
var merging: bool = false
var touch := -1 #Nothing is Currently Moved 
var merged_flower = null
var org_pos = [0,0]
var x
var y

#Set Up for Flower Location
func _merge_start(flower):
	merged_flower = flower

#Player Merging Flowers
#func _input(event) -> void:
	#if event is InputEventScreenDrag and event.pressed:
		#if merged_flower:
			#merged_flower.global_position = event.position
			
#Add Flower to the Empty Spot 
#func _empty_spots(flower):
	#if flowers_by_cell[Vector2i(x, y)] == null:
		#flowers_by_cell[Vector2i(x, y)]= flower

#Flower Dragging		
func _on_flower_drag_ended(flower, drop_position: Vector2) -> void:
	print("FLOWER DRAG ENDED")
	print("Drop position: ", drop_position)

	if orders_area == null:
		print("ERROR: OrdersArea is not connected!")
	else:
		print("Order area position: ", orders_area.get_global_rect())
		print("Mouse position: ", orders_area.get_global_mouse_position())

	if is_flower_dropped_on_order(drop_position):
		print("SUCCESS: Flower dropped on order!")

		if try_deliver_flower_to_order(flower, drop_position):
			return

	handle_flower_drop(flower, drop_position)
	
	#if is_flower_dropped_on_order(drop_position):
		#if try_deliver_flower_to_order(flower, drop_position):
			#return
	#handle_flower_drop(flower, drop_position)
	
#Flower Placement
func handle_flower_drop(flower, world_position: Vector2) -> void:
	var target_cell = grass_layer.world_position_to_cell(world_position)
	var current_cell = get_cell_of_flower(flower)
	var other_flower = get_flower_at_cell(target_cell)
	if not grass_layer.is_valid_cell(target_cell):
		return_flower_to_previous_cell(flower)
		return
	if current_cell == target_cell:
		return_flower_to_previous_cell(flower)
		return
	if not is_cell_occupied(target_cell):
		place_flower_in_cell(flower, target_cell)
		return
	if can_merge(flower, other_flower):
		merge_flowers(flower, other_flower, target_cell)
		return
		
	return_flower_to_previous_cell(flower)
	
# Places a flower into a specific grid cell.
func place_flower_in_cell(flower, cell: Vector2i) -> void:
	if flowers_by_cell.has(cell):
		return
		
	var old_cell = get_cell_of_flower(flower)
	
	if old_cell != null:
		flowers_by_cell.erase(old_cell)
	
	flowers_by_cell[cell] = flower
	
	flower.global_position = grass_layer.cell_to_world_position(cell)
	
# Returns true if a cell contains a flower
func is_cell_occupied(cell: Vector2i) -> bool:
	return flowers_by_cell.has(cell)
	
# Returns null if the cell is empty	
func get_flower_at_cell(cell: Vector2i):
	return flowers_by_cell.get(cell)
	
#Flower Merging
func can_merge(first_flower, second_flower) -> bool:
	if first_flower == null or second_flower == null:
		return false
	if first_flower == second_flower:
		return false
	if first_flower.flower_level != second_flower.flower_level:
		return false
	if first_flower.flower_level == 6:
		return false
	return true
	
	#Merges two flowers into one upgraded flower
func merge_flowers(first_flower, second_flower, target_cell: Vector2i) -> void:
		var upgraded_level = first_flower.flower_level + 1
		
		var first_cell = get_cell_of_flower(first_flower)
		var second_cell = get_cell_of_flower(second_flower)
		
		if first_cell == null or second_cell == null:
			return
		
		flowers_by_cell.erase(first_cell)
		flowers_by_cell.erase(second_cell)
		
		first_flower.queue_free()
		second_flower.queue_free()
		
		spawn_flower(upgraded_level, target_cell)
		
		refill_flowers()
# Creates a new flower in the specified grid cell.
func spawn_flower(flower_level: int, cell: Vector2i) -> void:
	#print("Spawning flower at: ", cell)
	
	var flower = FLOWER_SCENE.instantiate()

	flower.flower_level = flower_level
	
	flowers_container.add_child(flower)
	
	#print("Spawned flower script: ", flower.get_script().resource_path)
	#print("Flower inside scene tree: ", flower.is_inside_tree())
	#print("Flower ready: ", flower.is_node_ready())
	
	flower.global_position = grass_layer.cell_to_world_position(cell)
	
	flowers_by_cell[cell] = flower
	
	flower.drag_started.connect(_merge_start)
	flower.drag_ended.connect(_on_flower_drag_ended)
	#print("Flower cell: ", cell)
	#print("Flower global position: ", flower.global_position)
	#print("GrassLayer global position: ", grass_layer.global_position)
	#print("Flower visible: ", flower.visible)
	#print("Flower level: ", flower.flower_level)
	#print("Sprite texture: ", flower.sprite.texture)
	#print("Expected tile center: ", grass_layer.cell_to_world_position(cell))
	#print("Actual sprite center: ", flower.sprite.global_position)
#Merging Logic	
#func _game_play(flower, x, y):
	#if flower == null or merged_flower == null:
		#return false
	#if flower != merged_flower:
		#return false
	#return true
		
func refill_flowers() -> void:
	while flowers_by_cell.size() < MIN_FLOWERS:
		_spawn_random_flower_types()
#Order System 
var requested_flower_level: int = 1
var requested_amount: int = 1
var completed_orders: int = 0
var delivered_amount: int = 0

const FLOWER_NAMES = [
	"Seedling", # 0
	"Tulip", # 1
	"Rose", # 2
	"Sunflower", # 3
	"Orchid", # 4
	"Poppy", # 5
	"Lily" # 6
]


func generate_new_order() -> void:
	requested_flower_level = randi_range(0, 2)
	requested_amount = randi_range(1, 3)
	delivered_amount = 0

	update_order_ui()



func is_flower_dropped_on_order(drop_position: Vector2) -> bool:
	if orders_area == null:
		return false
	
	return orders_area.get_global_rect().has_point(
		orders_area.get_global_mouse_position()
	)
	
# Deliver a flower to an active order
func try_deliver_flower_to_order(flower, drop_position: Vector2) -> bool:
	if flower.flower_level != requested_flower_level:
		print("Wrong flower level")
		return false
	
	delivered_amount += 1
	update_order_ui()
	print("Order progress: ", delivered_amount, "/", requested_amount)
	
	remove_delivered_flower(flower)
	refill_flowers()
	if delivered_amount >= requested_amount:
		complete_order()
	return true

func complete_order() -> void:
	completed_orders += 1
	print("ORDER COMPLETE!")

	# Start another order
	generate_new_order()
	print("New order started!")
	
func get_cell_of_flower(flower):
	
	for cell in flowers_by_cell:
		if flowers_by_cell[cell] == flower:
			return cell
	return null
	
func remove_flower_from_cell(cell: Vector2i) -> void:
	flowers_by_cell.erase(cell)
	
func return_flower_to_previous_cell(flower) -> void:
	flower.global_position = flower.original_position

#Removes Flower After Successful Delivery
func remove_delivered_flower(flower) -> void:
	var cell = get_cell_of_flower(flower)
	if cell != null:
		remove_flower_from_cell(cell)
	flower.queue_free()
	

func update_order_ui() -> void:
	var flower_name = FLOWER_NAMES[requested_flower_level]
	
	order_label.text = str(requested_amount - delivered_amount) + " " + flower_name + " Please!"
	completed_orders_label.text = "Orders completed: " + str(completed_orders)
