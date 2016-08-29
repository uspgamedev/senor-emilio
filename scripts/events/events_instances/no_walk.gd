
extends "res://scripts/events/event.gd"

signal dialogue_end

const HERO = preload("res://scripts/classes/hero.gd")
const DIR = preload("res://scripts/utility/directions.gd")

var interactor = null

func _init(actor).(actor):
    pass

func _action(body):
    if body.get_script() == HERO:
        self.interactor = body
        var reader = node.get_node("/root/main/HUD")
        reader.connect("dialogue_end", self, "_on_dialogue_end")
        reader.init_dialog(node.get_node("Text"))

func _on_dialogue_end():
    var reader = node.get_node("/root/main/HUD")
    print("DIALOGUE HAS ENDED")
    interactor.move(Vector2(0,-32))
    interactor.face(DIR.UP)
    reader.disconnect("dialogue_end", self, "_on_dialogue_end")
