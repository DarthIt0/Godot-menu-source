extends Control

var can_select = true
var select_timer = 5

var master_selected = false
var music_selected = false
var effects_selected = false

var res_id
var resolution = false
var full_id
var fullscreen = false

var sp_use = false
var sp_pause = false

var ready = true
var ready_timer = 5

# Called when the node enters the scene tree for the first time.
func _ready():
	
	$cntrl_Video/btn_Resolution.add_item("800 x 600", 0)
	$cntrl_Video/btn_Resolution.add_item("1920 x 1080", 1)
	
	$cntrl_Video/btn_Fullscreen.add_item("Fullscreen", 0)
	$cntrl_Video/btn_Fullscreen.add_item("Windowed", 1)
	
	res_id = $cntrl_Video/btn_Resolution.get_selected_id()
	full_id = $cntrl_Video/btn_Fullscreen.get_selected_id()
	
	$btn_Video.connect("pressed", self, "Video")
	$btn_Audio.connect("pressed", self, "Audio")
	$btn_Controls.connect("pressed", self, "Controls")
	$btn_Back.connect("pressed", self, "Back")
	
	$cntrl_Video/btn_Resolution.connect("item_selected", self, "Resolution")
	
	$cntrl_Video/btn_Fullscreen.connect("item_selected", self, "Fullscreen")
	
	$cntrl_Audio/btn_Master_Mute.connect("pressed", self, "Mute_Master")
	$cntrl_Audio/sldr_Master.connect("value_changed", self, "Master_Volume")
	
	$cntrl_Audio/btn_Music_Mute.connect("pressed", self, "Mute_Music")
	$cntrl_Audio/sldr_Music.connect("value_changed", self, "Music_Volume")
	
	$cntrl_Audio/btn_Effects_Mute.connect("pressed", self, "Mute_Effects")
	$cntrl_Audio/sldr_Effects.connect("value_changed", self, "Effects_Volume")
	
	$cntrl_Controls/btn_Keyboard.connect("pressed", self, "Keyboard")
	$cntrl_Controls/btn_Controller.connect("pressed", self, "Controller")
	
	$cntrl_Controls/Keyboard/btn_Use.connect("pressed", self, "Use_Button")
	$cntrl_Controls/Keyboard/btn_Pause.connect("pressed", self, "Pause_Button")
	
	$cntrl_Controls/Controller/btn_Use.connect("pressed", self, "Use_Button")
	$cntrl_Controls/Controller/btn_Pause.connect("pressed", self, "Pause_Button")
	
	$cntrl_Video/btn_Resolution.connect("pressed", self, "res_pressed")
	$cntrl_Video/btn_Fullscreen.connect("pressed", self, "full_pressed")

	
	if(Global_Options.res_width == 800 and Global_Options.res_height == 600):
		$cntrl_Video/btn_Resolution.select(0)
	elif(Global_Options.res_width == 1920 and Global_Options.res_height == 1080):
		$cntrl_Video/btn_Resolution.select(1)
	
	$btn_Video.grab_focus()
	
	if(Global_Options.fullscreen == true):
		$cntrl_Video/btn_Fullscreen.select(0)
	elif(Global_Options.fullscreen == false):
		$cntrl_Video/btn_Fullscreen.select(1)
	
	$cntrl_Audio/sldr_Master.set_value(Global_Options.Master_Volume)
	$cntrl_Audio/sldr_Music.set_value(Global_Options.Music_Volume)
	$cntrl_Audio/sldr_Effects.set_value(Global_Options.Effects_Volume)
	
	$lbl_Name.set_size(Vector2(1024,60))
	$cntrl_Video.set_size(Vector2(1024,450))
	$cntrl_Video.set_position(Vector2(0,150))
	$cntrl_Audio.set_size(Vector2(1024,450))
	$cntrl_Audio.set_position(Vector2(0,150))
	$cntrl_Controls.set_size(Vector2(1024,450))
	$cntrl_Controls.set_position(Vector2(0,150))
	
	if Global_Options.Master_Mute == true:
		$cntrl_Audio/sldr_Master.set_modulate(Color(1,1,1,0.1))
	elif Global_Options.Master_Mute == false:
		$cntrl_Audio/sldr_Master.set_modulate(Color(1,1,1,1))
		
	if Global_Options.Music_Mute == true:
		$cntrl_Audio/sldr_Music.set_modulate(Color(1,1,1,0.1))
	elif Global_Options.Music_Mute == false:
		$cntrl_Audio/sldr_Music.set_modulate(Color(1,1,1,1))
		
	if Global_Options.Effects_Mute == true:
		$cntrl_Audio/sldr_Effects.set_modulate(Color(1,1,1,0.1))
	elif Global_Options.Effects_Mute == false:
		$cntrl_Audio/sldr_Effects.set_modulate(Color(1,1,1,1))
	
	
	controller_text()
	pass # Replace with function body.
	

func _process(delta):
	if select_timer > 0:
		select_timer -= 1
		can_select = false
	else:
		can_select = true
		if fullscreen == false:
			$cntrl_Video/btn_Fullscreen.disabled = false
		if resolution == false:
			$cntrl_Video/btn_Resolution.disabled = false
		
	if ready_timer > 0:
		ready_timer -= 1
		ready = true
	else:
		ready = false
	
	if $cntrl_Audio/sldr_Master.has_focus():
		if Input.is_action_just_pressed("ui_accept"):
			if master_selected == false:
				master_selected = true
			elif master_selected == true:
				master_selected = false
				
		if master_selected == true:
			if Input.is_action_just_pressed("ui_left"):
				$cntrl_Audio/sldr_Master.set_value($cntrl_Audio/sldr_Master.get_value() - 20)
				Master_Volume($cntrl_Audio/sldr_Master.get_value())
			
			if Input.is_action_just_pressed("ui_right"):
				$cntrl_Audio/sldr_Master.set_value($cntrl_Audio/sldr_Master.get_value() + 20)
				Master_Volume($cntrl_Audio/sldr_Master.get_value())
		elif master_selected == false:
			if Input.is_action_just_pressed("ui_left"):
				$cntrl_Audio/sldr_Master.release_focus()
				$cntrl_Audio/btn_Master_Mute.grab_focus()
				
	elif !$cntrl_Audio/sldr_Master.has_focus():
		master_selected = false
	
	if $cntrl_Audio/sldr_Music.has_focus():
		if Input.is_action_just_pressed("ui_accept"):
			if music_selected == false:
				music_selected = true
			elif music_selected == true:
				music_selected = false
				
		if music_selected == true:
			if Input.is_action_just_pressed("ui_left"):
				$cntrl_Audio/sldr_Music.set_value($cntrl_Audio/sldr_Music.get_value() - 20)
				Music_Volume($cntrl_Audio/sldr_Music.get_value())
			
			if Input.is_action_just_pressed("ui_right"):
				$cntrl_Audio/sldr_Music.set_value($cntrl_Audio/sldr_Music.get_value() + 20)
				Music_Volume($cntrl_Audio/sldr_Music.get_value())
		elif music_selected == false:
			if Input.is_action_just_pressed("ui_left"):
				$cntrl_Audio/sldr_Music.release_focus()
				$cntrl_Audio/btn_Music_Mute.grab_focus()
				
	elif !$cntrl_Audio/sldr_Music.has_focus():
		music_selected = false
		
	if $cntrl_Audio/sldr_Effects.has_focus():
		if Input.is_action_just_pressed("ui_accept"):
			if effects_selected == false:
				effects_selected = true
			elif effects_selected == true:
				effects_selected = false
				
		if effects_selected == true:
			if Input.is_action_just_pressed("ui_left"):
				$cntrl_Audio/sldr_Effects.set_value($cntrl_Audio/sldr_Effects.get_value() - 20)
				Effects_Volume($cntrl_Audio/sldr_Effects.get_value())
			
			if Input.is_action_just_pressed("ui_right"):
				$cntrl_Audio/sldr_Effects.set_value($cntrl_Audio/sldr_Effects.get_value() + 20)
				Effects_Volume($cntrl_Audio/sldr_Effects.get_value())
		elif effects_selected == false:
			if Input.is_action_just_pressed("ui_left"):
				$cntrl_Audio/sldr_Effects.release_focus()
				$cntrl_Audio/btn_Effects_Mute.grab_focus()
				
	elif !$cntrl_Audio/sldr_Effects.has_focus():
		effects_selected = false
		
	if resolution == true:
		res_change()
	
	if fullscreen == true:
		full_change()
	
	
	pass

func _input(event):
	
	if event is InputEventKey:
		if sp_use == true:
			Global_Options.key_use = event.scancode
			sp_use = false
			select_timer = 5
			can_select = false
			$cntrl_Controls/Key.hide()
			controller_text()
			
		if sp_pause == true:
			Global_Options.key_pause = event.scancode
			sp_pause = false
			select_timer = 5
			can_select = false
			$cntrl_Controls/Key.hide()
			controller_text()
			
	if event is InputEventJoypadButton:
		
		if Input.is_action_just_pressed("ui_accept"):
			if fullscreen == true and can_select == true:
				$cntrl_Video/btn_Fullscreen.select(full_id)
				Fullscreen(full_id)
				fullscreen = false
				can_select = false
				select_timer = 5
				$cntrl_Video/btn_Fullscreen.get_popup().hide()
				
			if resolution == true and can_select == true:
				$cntrl_Video/btn_Resolution.select(res_id)
				Resolution(res_id)
				resolution = false
				can_select = false
				select_timer = 5
				$cntrl_Video/btn_Resolution.get_popup().hide()
		
		if Input.is_action_just_pressed("ui_cancel"):
			if fullscreen == true:
				fullscreen = false
				can_select = false
				select_timer = 5
				
			if resolution == true:
				resolution = false
				can_select = false
				select_timer = 5
				
		if sp_use == true:
			Global_Options.con_use_pad = true
			Global_Options.con_use = event.get_button_index()
			sp_use = false
			select_timer = 5
			can_select = false
			$cntrl_Controls/Key.hide()
			Global_Options.controller()
			controller_text()
			
		if sp_pause == true:
			Global_Options.con_pause_pad = true
			Global_Options.con_pause = event.get_button_index()
			sp_pause = false
			select_timer = 5
			can_select = false
			$cntrl_Controls/Key.hide()
			Global_Options.controller()
			controller_text()
			
	if event is InputEventJoypadMotion:
		if sp_use == true:
			Global_Options.con_use_pad = false
			Global_Options.con_use_axis = event.get_axis()
			sp_use = false
			select_timer = 5
			can_select = false
			$cntrl_Controls/Key.hide()
			Global_Options.controller()
			controller_text()
			
		if sp_pause == true:
			Global_Options.con_pause_pad = false
			Global_Options.con_pause_axis = event.get_axis()
			sp_pause = false
			select_timer = 5
			can_select = false
			$cntrl_Controls/Key.hide()
			Global_Options.controller()
			controller_text()
			
	pass

func Video():
	$cntrl_Video.show()
	$cntrl_Audio.hide()
	$cntrl_Controls.hide()
	pass
	

func Audio():
	$cntrl_Video.hide()
	$cntrl_Audio.show()
	$cntrl_Controls.hide()
	pass
	

func Controls():
	$cntrl_Video.hide()
	$cntrl_Audio.hide()
	$cntrl_Controls.show()
	pass
	

func Back():
	if Global_Options.paused == false:
		get_tree().change_scene("res://Scenes/Menu/Main.tscn")
	elif Global_Options.paused == true:
		Global_Options.pause_menu = true
		
	pass
	

func Resolution(item):
	
	res_id = $cntrl_Video/btn_Resolution.get_selected_id()
	full_id = $cntrl_Video/btn_Fullscreen.get_selected_id()
	
	resolution = false
	can_select = false
	select_timer = 5
	
	if item == 0:
		Global_Options.res_width = 800
		Global_Options.res_height = 600
		Global_Options.resolution()
		Global_Options.save_game()
	elif item == 1:
		Global_Options.res_width = 1920
		Global_Options.res_height = 1080
		Global_Options.resolution()
		Global_Options.save_game()
	
#	match item:
#		0:
#			Global_Options.res_width = 800
#			Global_Options.res_height = 600
#			Global_Options.resolution()
#			Global_Options.save_game()
#		1:
#			Global_Options.res_width = 1920
#			Global_Options.res_height = 1080
#			Global_Options.resolution()
#			Global_Options.save_game()
	
	#if $cntrl_Video/btn_Resolution.disabled == true:
	#	$cntrl_Video/btn_Resolution.disabled = false
	
	
	pass


func Fullscreen(item):
	
	res_id = $cntrl_Video/btn_Resolution.get_selected_id()
	full_id = $cntrl_Video/btn_Fullscreen.get_selected_id()
	
	fullscreen = false
	can_select = false
	select_timer = 5
	
	if item == 0:
		Global_Options.fullscreen = true
		Global_Options.resolution()
		Global_Options.save_game()
	elif item == 1:
		Global_Options.fullscreen = false
		Global_Options.resolution()
		Global_Options.save_game()
	
#	match item:
#		0:
#			Global_Options.fullscreen = true
#			Global_Options.resolution()
#			Global_Options.save_game()
#		1:
#			Global_Options.fullscreen = false
#			Global_Options.resolution()
#			Global_Options.save_game()
	
	#if $cntrl_Video/btn_Fullscreen.disabled == true:
	#	$cntrl_Video/btn_Fullscreen.disabled = false
	
		
	
	pass
	

func Mute_Master():
	if ready == false:
		if(Global_Options.Master_Mute == false):
			Global_Options.Master_Mute = true
			$cntrl_Audio/sldr_Master.set_modulate(Color(1,1,1,0.1))
		elif(Global_Options.Master_Mute == true):
			Global_Options.Master_Mute = false
			$cntrl_Audio/sldr_Master.set_modulate(Color(1,1,1,1))
		
	Global_Options.choose_music()
	Global_Options.save_game()
	pass

func Master_Volume(value):
	if ready == false:
		if(Global_Options.Master_Mute == true):
			Global_Options.Master_Mute = false
			$cntrl_Audio/sldr_Master.set_modulate(Color(1,1,1,1))
			
	Global_Options.Master_Volume = $cntrl_Audio/sldr_Master.get_value()
	Global_Options.save_game()
	pass

func Mute_Music():
	if ready == false:
		if(Global_Options.Music_Mute == false):
			Global_Options.Music_Mute = true
			$cntrl_Audio/sldr_Music.set_modulate(Color(1,1,1,0.1))
		elif(Global_Options.Music_Mute == true):
			Global_Options.Music_Mute = false
			$cntrl_Audio/sldr_Music.set_modulate(Color(1,1,1,1))
	
	Global_Options.choose_music()
	Global_Options.save_game()
	pass

func Music_Volume(value):
	if ready == false:
		if(Global_Options.Music_Mute == true):
			Global_Options.Music_Mute = false
			$cntrl_Audio/sldr_Music.set_modulate(Color(1,1,1,1))
			
	Global_Options.Music_Volume = $cntrl_Audio/sldr_Music.get_value()
	Global_Options.save_game()
	pass

func Mute_Effects():
	if ready == false:
		if(Global_Options.Effects_Mute == false):
			Global_Options.Effects_Mute = true
			$cntrl_Audio/sldr_Effects.set_modulate(Color(1,1,1,0.1))
		elif(Global_Options.Effects_Mute == true):
			Global_Options.Effects_Mute = false
			$cntrl_Audio/sldr_Effects.set_modulate(Color(1,1,1,1))
	
	Global_Options.choose_music()
	Global_Options.save_game()
	pass

func Effects_Volume(value):
	if ready == false:
		if(Global_Options.Effects_Mute == true):
			Global_Options.Effects_Mute = false
			$cntrl_Audio/sldr_Effects.set_modulate(Color(1,1,1,1))
			
	Global_Options.Effects_Volume = $cntrl_Audio/sldr_Effects.get_value()
	Global_Options.save_game()
	pass

func Use_Button():
	if can_select == true:
		sp_use = true
		$cntrl_Controls/Key.show()
	pass
	

func Pause_Button():
	if can_select == true:
		sp_pause = true
		$cntrl_Controls/Key.show()
	pass

func controller_text():
	
	if $cntrl_Controls/Keyboard.is_visible():
		$cntrl_Controls/Keyboard/lbl_Use.set_text(OS.get_scancode_string(Global_Options.key_use))
		$cntrl_Controls/Keyboard/lbl_Pause.set_text(OS.get_scancode_string(Global_Options.key_pause))
		
	if $cntrl_Controls/Controller.is_visible():
		$cntrl_Controls/Controller/spr_Use.set_texture(Global_Options.con_use_image)
		$cntrl_Controls/Controller/spr_Pause.set_texture(Global_Options.con_pause_image)
		
	pass

func Keyboard():
	$cntrl_Controls/Keyboard.show()
	$cntrl_Controls/Controller.hide()
	pass
	

func Controller():
	$cntrl_Controls/Keyboard.hide()
	$cntrl_Controls/Controller.show()
	Global_Options.controller()
	pass
	

func res_pressed():
	if resolution == false:
		if can_select == true:
			resolution = true
			can_select = false
			select_timer = 5
			if $cntrl_Video/btn_Resolution.disabled == false:
				$cntrl_Video/btn_Resolution.disabled = true
	elif resolution == true:
		if can_select == true:
			resolution = false
			can_select = false
			select_timer = 5
			if $cntrl_Video/btn_Resolution.disabled == false:
				$cntrl_Video/btn_Resolution.disabled = true
				
	pass

func res_change():
	if Input.is_action_just_pressed("ui_down"):
		res_id += 1
		if res_id > 1:
			res_id = 0
	elif Input.is_action_just_pressed("ui_up"):
		res_id -= 1
		if res_id < 0:
			res_id = 1
			
	if res_id == 0:
		$cntrl_Video/btn_Resolution.get_popup().set_item_checked(0,true)
		$cntrl_Video/btn_Resolution.get_popup().set_item_checked(1,false)
	elif res_id == 1:
		$cntrl_Video/btn_Resolution.get_popup().set_item_checked(0,false)
		$cntrl_Video/btn_Resolution.get_popup().set_item_checked(1,true)
	
	pass


func ful_pressed():
	if fullscreen == false:
		if can_select == true:
			fullscreen = true
			can_select = false
			select_timer = 5
			if $cntrl_Video/btn_Fullscreen.disabled == false:
				$cntrl_Video/btn_Fullscreen.disabled = true
	elif fullscreen == true:
		if can_select == true:
			fullscreen = false
			can_select = false
			select_timer = 5
			if $cntrl_Video/btn_Fullscreen.disabled == false:
				$cntrl_Video/btn_Fullscreen.disabled = true
				
	pass

func full_change():
	if Input.is_action_just_pressed("ui_down"):
		full_id += 1
		if full_id > 1:
			full_id = 0
	elif Input.is_action_just_pressed("ui_up"):
		full_id -= 1
		if full_id < 0:
			full_id = 1
		
	if full_id == 0:
		$cntrl_Video/btn_Fullscreen.get_popup().set_item_checked(0,true)
		$cntrl_Video/btn_Fullscreen.get_popup().set_item_checked(1,false)
	elif full_id == 1:
		$cntrl_Video/btn_Fullscreen.get_popup().set_item_checked(0,false)
		$cntrl_Video/btn_Fullscreen.get_popup().set_item_checked(1,true)
	
	pass