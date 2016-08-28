
extends "res://scripts/classes/prop.gd"

var stored

func _ready():
  if get_node("Storage").get_child_count() <= 0:
    return
  stored = get_node("Storage").get_children()[0]

func is_full():
  return stored != null

func store(item):
  if is_full():
    return
  printt(get_name(), "storing item")
  stored = item
  item.hide()

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
  if is_full():
    var item = get_item()
    item.set_layer_mask(body.get_layer_mask())
    body.grab(item)
    remove()
    printt(get_name(), "requesting grab")
