extends Control

const SAVE1_PATH = "res://save1.json"
var save1 = {}
var save1_file = File.new()

const SAVE2_PATH = "res://save2.json"
var save2 = {}
var save2_file = File.new()

#temporary
var test = "test"

func _ready():
	$btn_Save1.connect("pressed", self, "Save1")
	$btn_Save2.connect("pressed", self, "Save2")
	$btn_Back.connect("pressed", self, "Back")
	
	$lbl_Name.set_size(Vector2(1024,60))
	
	$btn_Save1.grab_focus()
	
	pass

func Save1():
	
	var save1 = {
		test = test
	}
	
	var save_file = File.new()
	save_file.open(SAVE1_PATH, File.WRITE)
	save_file.store_line(to_json(save1))
	save_file.close()
	
	pass


func Save2():
	
	var save2 = {
		test = test
	}
	
	var save_file = File.new()
	save_file.open(SAVE2_PATH, File.WRITE)
	save_file.store_line(to_json(save2))
	save_file.close()
	
	pass

func Back():
	
	Global_Options.pause_menu = true
		
	pass