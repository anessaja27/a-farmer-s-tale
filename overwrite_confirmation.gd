extends Control

signal confirmed
signal cancelled

@onready var title_label: Label = $PopupPanel/Content/Title
@onready var message_label: Label = $PopupPanel/Content/Message


func show_confirmation(title_text: String, message_text: String) -> void:
	title_label.text = title_text
	message_label.text = message_text
	show()


func close_dialog() -> void:
	hide()
	cancelled.emit()


func _on_confirm_pressed() -> void:
	hide()
	confirmed.emit()


func _on_cancel_pressed() -> void:
	close_dialog()
