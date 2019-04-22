extends Control

const SAVE1_PATH = "res://save1.json"
var save1 = {}
var save1_file = File.new()

const SAVE2_PATH = "res://save2.json"
var save2 = {}
var save2_file = File.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	$btn_Save1.connect("pressed", self, "Save1")
	$btn_Save2.connect("pressed", self, "Save2")
	$btn_Back.connect("pressed", self, "Back")
	
	if !save1_file.file_exists(SAVE1_PATH):
		$btn_Save1.hide()
	
	if !save2_file.file_exists(SAVE2_PATH):
		$btn_Save2.hide()
		
	$lbl_Name.set_size(Vector2(1024,60))
	
	$btn_Save1.grab_focus()
	
	pass

func Save1():
	var save_file = File.new()
	if(not save_file.file_exists(SAVE1_PATH)):
		return
		
	save_file.open(SAVE1_PATH, File.READ)
	
	var data = {}
	data = parse_json(save_file.get_as_text())
	pass


func Save2():
	var save_file = File.new()
	if(not save_file.file_exists(SAVE2_PATH)):
		return
		
	save_file.open(SAVE2_PATH, File.READ)
	
	var data = {}
	data = parse_json(save_file.get_as_text())
	pass

func Back():
	if Global_Options.paused == false:
		get_tree().change_scene("res://Scenes/Menu/Main.tscn")
	elif Global_Options.paused == true:
		Global_Options.pause_menu = true
		
	pass
	