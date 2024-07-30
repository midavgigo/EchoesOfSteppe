extends Node2D

@onready var animated_sprite = $AS2D #Загружаем в переменную объект по имени

var play = false #Переменная для проигрывания анимации

func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):#Автоматически добавленное событие, срабатывает на пробел и ентер
		play = not play#Меняем переменную
	if play:
		animated_sprite.play("animation")#Запускаем анимацию "animation"
	else:
		animated_sprite.stop()#Останавливаем
