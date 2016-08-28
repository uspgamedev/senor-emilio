extends Node

export(String, MULTILINE) var speech= "..."

func get_actor():
  return get_node("../..")

func get_answers():
  return get_children()
