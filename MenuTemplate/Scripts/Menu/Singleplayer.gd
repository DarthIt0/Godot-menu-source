extends Control

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	$btn_New_Game.connect("pressed", self, "New_Game")
	$btn_Load_Game.connect("pressed", self, "Load_Game")
	$btn_Back.connect("pressed", self, "Back")
	
	$btn_New_Game.grab_focus()
	pass
	

func New_Game():
	get_tree().change_scene("res://Scenes/Menu/HUD.tscn")
	pass
	

func Load_Game():
	get_tree().change_scene("res://Scenes/Menu/Load.tscn")
	pass
	

func Back():
	get_tree().change_scene("res://Scenes/Menu/Main.tscn")
	pass