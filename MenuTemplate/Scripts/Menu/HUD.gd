extends Control

var scene

# Called when the node enters the scene tree for the first time.
func _ready():
	$Pause/btn_Resume.connect("pressed", self, "Resume")
	$Pause/btn_Load.connect("pressed", self, "Load")
	$Pause/btn_Save.connect("pressed", self, "Save")
	$Pause/btn_Options.connect("pressed", self, "Options")
	$Pause/btn_Quit.connect("pressed", self, "Quit")
	
	#temporary
	Global_Options.paused = true
	
	$Pause/btn_Resume.grab_focus()
	
	pass # Replace with function body.

func _process(delta):
	
	if(Global_Options.pause_menu == true):
		get_tree().root.get_children()[1].show()
		Global_Options.pause_menu = false
		for node in get_tree().get_nodes_in_group("temporary"):
			node.queue_free()
	
	pass

func Resume():
	Global_Options.paused = false
	$Pause.hide()
	pass
	

func Load():
	get_tree().root.get_children()[1].hide()
	scene = load("res://Scenes/Menu/Load.tscn").instance()
	get_tree().root.get_children()[0].add_child(scene)
	scene.add_to_group("temporary")
	pass
	

func Save():
	get_tree().root.get_children()[1].hide()
	scene = load("res://Scenes/Menu/Save.tscn").instance()
	get_tree().root.get_children()[0].add_child(scene)
	scene.add_to_group("temporary")
	pass
	

func Options():
	get_tree().root.get_children()[1].hide()
	scene = load("res://Scenes/Menu/Options.tscn").instance()
	get_tree().root.get_children()[0].add_child(scene)
	scene.add_to_group("temporary")
	pass
	

func Quit():
	get_tree().change_scene("res://Scenes/Menu/Main.tscn")
	pass
	