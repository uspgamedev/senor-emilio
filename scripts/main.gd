
extends Node

const GamePlay = preload("res://resources/states/gameplay.tscn")

var current_state

func _ready():
    current_state = GamePlay.instance()
    get_node("gameplay").replace_by(current_state)

func go_to_scene(name):
  var scene = load("res://resources/maps/" + name + ".tscn")
  get_node("gameplay").remove_child(get_node("gameplay/stage"))
  yield(get_tree(), "fixed_frame")
  get_node("gameplay").add_child(scene.instance())
  #scene.show()
  #get_tree().change_scene_to(scene.instance())


func go_to_credits():
  var scene = preload("res://resources/maps/credits.tscn")
  get_node("gameplay").remove_child(get_node("gameplay/ending_scene"))
  yield(get_tree(), "fixed_frame")
  get_node("gameplay").add_child(scene.instance())
  #scene.show()
  #get_tree().change_scene_to(scene.instance())
