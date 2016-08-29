
extends "res://scripts/classes/prop.gd"

var _key_required

var stored

func _ready():
  if get_node("Storage").get_child_count() <= 0:
    return
  stored = get_node("Storage").get_children()[0]
  _key_required = get_node("Storage").get_child(1).get_name()
  assert(_key_required != null and _key_required != "")
  printt("CHEST:", _key_required)

func is_full():
  return stored != null

func remove():
  if !is_full():
    return
  printt(get_name(), "removing item")
  stored.show()
  get_node("open").show()
  stored = null

func get_item():
  return stored

func interact(body):
  #printt("tried to open chest 2", is_full(), body.get_pocket_item().get_name() == _key_required)
  if is_full() and body.get_pocket_item() != null and body.get_pocket_item().get_name() == _key_required:
    body.drop()
    yield(body, "drop")
    var item = get_item()
    item.set_layer_mask(body.get_layer_mask())
    body.grab(item)
    remove()
    printt(get_name(), "requesting grab")
