
extends "res://scripts/classes/prop.gd"

var _key_required = null

onready var view = get_node("Sprite")

signal activated

func _ready():
  _key_required = get_child(2).get_name()
  assert(_key_required != null and _key_required != "")

func interact(body):
  if body.get_pocket_item() != null and body.get_pocket_item().get_name() == _key_required:
    body.drop()
    yield(body, "drop")
    view.set_frame(0)
    emit_signal("activated")
