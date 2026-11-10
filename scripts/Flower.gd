
extends Area2D

# Signals tell the GameBoard when a flower starts or stops being dragged.
# The GameBoard can use these to handle merging.
signal drag_started(flower)
signal drag_ended(flower, drop_position)


# Determines the flower's current level.
# 0 = Seedling, 1 = Daisy, 2 = Tulip, etc.
# The Inspector only allows values between 0 and 6.
@export_range(0, 6) var flower_level: int = 0

# Stores the textures for all seven flower types.
# Assign these in the Inspector in the same order as flower_types.
@export var flower_textures: Array[Texture2D] = []


# Lists the flower types in their merging order.
# The index of each flower matches its flower_level.
var flower_types = [
	"seedling", # 0
	"tulip", # 1
	"rose", # 2
	"sunflower", # 3
	"orchid", # 4
	"Poppy", # 5
	"Lily" # 6
]


# Tracks whether the player is currently dragging this flower.
var is_dragging: bool = false

# Saves the flower's position before dragging begins.
# The GameBoard can use this to return an invalid drop.
var original_position: Vector2


# References to the child nodes in Flower.tscn.
# @onready waits until the node is ready before accessing them.
@onready var sprite = $Sprite2D
@onready var collision = $CollisionShape2D


# Runs automatically when the flower enters the scene tree.
func _ready():
	update_appearance()


# Updates the flower's image based on its current level.
# CALL THIS AFTER MERGE HAPPENS
func update_appearance():

	# Make sure the level has a corresponding texture.
	# This prevents errors if a texture is missing.
	if flower_level >= 0 and flower_level < flower_textures.size():

		# Assign the correct texture to the Sprite2D.
		sprite.texture = flower_textures[flower_level]


# Called when an input event occurs on this flower's collision area.
# Used to detect when the player clicks or taps the flower.
func _input_event(viewport, event, shape_idx):

	# Check whether the input is a mouse button event.
	if event is InputEventMouseButton:

		# Only start dragging when the left mouse button is pressed.
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:

			# Mark this flower as currently being dragged.
			is_dragging = true

			# Remember where the flower started.
			original_position = global_position

			# Notify the GameBoard that dragging has started.
			drag_started.emit(self)

			# Mark the event as handled.
			get_viewport().set_input_as_handled()


# Called whenever an input event happens.
# Handles moving the flower and detecting when it is released.
func _input(event):

	# Ignore input unless this flower is being dragged.
	if not is_dragging:
		return

	# If the mouse moves while dragging, move the flower with it.
	if event is InputEventMouseMotion:

		# Use global coordinates so the flower follows the mouse.
		global_position = get_global_mouse_position()

	# Check whether the player released the mouse button.
	elif event is InputEventMouseButton:

		if event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:

			# Stop dragging the flower.
			is_dragging = false

			# Notify the GameBoard where the flower was dropped.
			# The GameBoard will decide whether to merge or reset it.
			drag_ended.emit(self, global_position)

# Returns the flower's type based on its current level.
# Used by the order system to check which flower was delivered.
func get_flower_type() -> String:
	return flower_types[flower_level]
	
