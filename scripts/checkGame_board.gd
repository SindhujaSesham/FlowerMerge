extends TileMapLayer

#Game Board Properties
const BOARD := 5
var flower_types = {}
const BOARD_SIZE = 5
var flowers_by_cell: Dictionary = {}
var random_flower = flower_types.pick_random()
var flower
const FLOWER_SCENE = preload("res://scenes/Flower.tscn")

@onready var grass_layer = $GrassLayer
@onready var flowers_container = $Flowers

#Variables 
var random_x = randi_range(0, BOARD_SIZE - 1)
var random_y = randi_range(0, BOARD_SIZE - 1)

#Game Board Set-Up
func _spawn_random_flower_types() -> void:
	flowers_by_cell[Vector2i(x, y)] = random_flower

func _ready()-> void:
	_initialize_game_board()
	_spawn_random_flower_types()
	_spawn_random_flower_types()
	
func _initialize_game_board() -> void:
	flowers_by_cell = {}
	flowers_by_cell[Vector2i(x, y)] = flower
	
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
	org_pos = [x,y]

#Player Merging Flowers
func _input(event) -> void:
	if event is InputEventScreenDrag and event.pressed:
		if merged_flower:
			merged_flower.global_position = event.position
			
#Add Flower to the Empty Spot 
func _empty_spots(flower):
	if flowers_by_cell[Vector2i(x, y)] == null:
		flowers_by_cell[Vector2i(x, y)]= flower

#Flower Dragging		
func _on_flower_drag_ended(flower, drop_position: Vector2) -> void:
	if is_flower_dropped_on_order(drop_position):
		if try_deliver_flower_to_order(flower, drop_position):
			return
	handle_flower_drop(flower, drop_position)
	
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
	if not is_cell_occupied(target_cell):
		place_flower_in_cell(flower, target_cell)
		return
	if can_merge(flower, other_flower):
		merge_flowers(flower, other_flower, target_cell)
	return_flower_to_previous_cell(flower)
	
# Places a flower into a specific grid cell.
func place_flower_in_cell(flower, cell: Vector2i) -> void:
	if flowers_by_cell.has(cell):
		return
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
		if first_cell != null:
			flowers_by_cell.erase(first_cell)
			if second_cell != null:
				flowers_by_cell.erase(second_cell)
				first_flower.queue_free()
				second_flower.queue_free()
				spawn_flower(upgraded_level, target_cell)
		
# Creates a new flower in the specified grid cell.
func spawn_flower(flower_level: int, cell: Vector2i) -> void:
	var flower = FLOWER_SCENE.instantiate()

	flowers_container.add_child(flower)

	flower.flower_level = flower_level
	flower.update_appearance()

	flowers_by_cell[cell] = flower
	flower.global_position = grass_layer.cell_to_world_position(cell)
		
#Merging Logic	
func _game_play(flower, x, y):
	if flower == null or merged_flower == null:
		return false
	if flower != merged_flower:
		return false
	return true
		
#Dropping Logic
func _drop_flower() -> void:
	if merged_flower == null:
		return
	
#Order System 
var order
var drop_area
func is_flower_dropped_on_order(drop_position: Vector2) -> bool:
	if order == null:
		return false
	drop_area = order
	return true
	
# Deliver a flower to an active order
func try_deliver_flower_to_order(flower, drop_position: Vector2) -> bool:
	return false
	#TODO
	
func get_cell_of_flower(flower):
	for x in range(BOARD):
		for y in range(BOARD):
			if flowers_by_cell[Vector2i(x, y)] == flower:
				return Vector2i(x,y)
	return null

func remove_flower_from_cell(cell: Vector2i) -> void:
	flowers_by_cell.erase(cell)
	
func return_flower_to_previous_cell(flower) -> void:
	flower.global_position = Vector2(org_pos[0], org_pos[1])

#Removes Flower After Successful Delivery
func remove_delivered_flower(flower) -> void:
	var cell = get_cell_of_flower(flower)
	if cell != null:
		remove_flower_from_cell(cell)
	flower.queue_free()
