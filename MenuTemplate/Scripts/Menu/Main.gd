extends Control

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	$btn_Singleplayer.connect("pressed", self, "SinglePlayer")
	$btn_Options.connect("pressed", self, "Options")
	$btn_Quit.connect("pressed", self, "Quit")
	
	$btn_Singleplayer.grab_focus()
	pass

func SinglePlayer():
	get_tree().change_scene("res://Scenes/Menu/Singleplayer.tscn")
	pass

func Options():
	get_tree().change_scene("res://Scenes/Menu/Options.tscn")
	pass

func Quit():
	get_tree().quit()
	pass
