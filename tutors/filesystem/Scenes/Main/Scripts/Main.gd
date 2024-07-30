extends Node2D

@onready var text_edit = $TextEdit
@onready var text_read = $RichTextLabel

func _write_file():#функция обработки сигнала с кнопки записи
	var file = FileAccess.open("user://file.txt", FileAccess.WRITE)
	file.store_string(text_edit.text)


func _read_file():#функция обработки сигнала с кнопки чтения
	var file = FileAccess.open("user://file.txt", FileAccess.READ)
	text_read.text = file.get_as_text()
