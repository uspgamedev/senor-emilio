extends CanvasLayer

var actual_speech = null

onready var reader = get_node("DialogReader")
onready var speech_label = get_node("DialogReader/TextPanel/Text")
onready var button_panel = get_node("DialogReader/ButtonPanel")
onready var timer = get_node("DialogReader/Timer")
var player

func _ready():
  reader.hide()

func _unhandled_key_input(key_event):
  if key_event.type == InputEvent.KEY and key_event.is_action_pressed("ui_accept"):
    _on_answer_button_selected(0)
    get_tree().set_input_as_handled()


func init_dialog(speech):
  if not reader.is_hidden():
    return
  player = get_node("/root/main/gameplay").get_current_char()
  actual_speech = speech
  update_dialog()
  reader.show()
  get_tree().set_input_as_handled()
  set_process_unhandled_key_input(true)
  

func update_dialog():
  speech_label.clear()
  speech_label.add_text(actual_speech.speech)
  generate_buttons()

func generate_buttons():
  button_panel.clear()
  for answer in actual_speech.get_answers():
    if answer.text != null and answer.text != "":
      button_panel.add_button(answer.text)

func _on_answer_button_selected( button_idx ):
  if actual_speech.get_answers().size() <= 0:
    set_process_unhandled_key_input(false)
    reader.hide()
    return
  var answer = actual_speech.get_answers()[button_idx]
  if not answer.is_answer_action():
    actual_speech = answer.get_next_speech()
    update_dialog()
  else:
    answer.run_action(actual_speech.get_actor(), player)
    set_process_unhandled_key_input(false)
    reader.hide()
