
extends Control

# Replace with the actual path to your main menu scene.
const MAIN_MENU_SCENE = "res://scenes/menu.tscn"

@onready var resume_button = $PausePanel/VBoxContainer/ResumeButton
@onready var main_menu_button = $PausePanel/VBoxContainer/MainMenuButton


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	hide()

	resume_button.pressed.connect(resume_game)
	main_menu_button.pressed.connect(exit_to_menu)


func pause_game() -> void:
	show()
	get_tree().paused = true


func resume_game() -> void:
	get_tree().paused = false
	hide()


func exit_to_menu() -> void:
	# Unpause before changing scenes.
	get_tree().paused = false
	get_tree().change_scene_to_file(MAIN_MENU_SCENE)


func _on_pause_button_pressed() -> void:
	pause_game()
