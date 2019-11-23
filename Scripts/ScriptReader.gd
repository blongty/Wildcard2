extends "res://Scenes/LoadableScene.gd"

# Declare member variables here. Examples:
var textEngine
var script
var readLine	#Individual line read
var semiColon	#Index of semicolon
var charName	#Name of character speaking
var afterSC		#Text after the semicolon
#var image		#Image to load
export(String) var scriptPath = "res://Assets/scriptTester.txt"
export(String) var nextScene = "res://Scenes/levels/base_level_new.tscn"

# Called when the node enters the scene tree for the first time.
func _ready():
	textEngine = find_node("Text_Engine")
	readScript(scriptPath)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func readScript(scriptFile):
	script = File.new()
	script.open(scriptFile,File.READ)
	textEngine.reset()
	textEngine.set_state(textEngine.STATE_OUTPUT)
# warning-ignore:unused_variable
#	for i in range(GlobalVariables.scriptLine):		#Skip to the right line
#		script.get_line()
	readNextLine()
		
func readNextLine():
#	GlobalVariables.scriptLine += 1
	if(script.eof_reached() != true):
		readLine = script.get_line()
		semiColon = readLine.find(";")
		afterSC = readLine.substr(semiColon+1,readLine.length()-semiColon)
		if readLine.begins_with("Prompt"):
			textEngine.buff_input()
			textEngine.buff_text("\n",0)
			textEngine.buff_break()
		elif readLine.begins_with("Image"):
			textEngine.buff_break()	
		else:
			charName = readLine.substr(0,semiColon)
			if charName != "Narrator":
				textEngine.buff_text(charName+"\n",0)
			textEngine.buff_text(afterSC,0.04)
			textEngine.buff_break()
			textEngine.buff_text("\n",0)
	else:
		emit_signal("end_level", nextScene)

func _on_Text_Engine_resume_break():
	readNextLine()

func _input(ev):
	if ev is InputEventKey and ev.scancode == KEY_SPACE and not ev.echo:
        textEngine.set_buff_speed(0)