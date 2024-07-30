# Генерация игрового мира

Здесь будет небольшой гайд, в котором будет рассказано про группы и добавление сцен на игровую сцену кодом.

## Группы

Если откроете Сцену Scenes/Platform/Platform.tscn и перейдёте туда же, где была вкладка сигналы, только выберите вкладку группы, то увидите созданную группу.

Каждый объект можно заносить в какую-то группу, чтобы потом в коде можно было работать не с конкретным объектом, а с любым из группы.

## Добавление сцены

В принципе в коде всё описано

```
extends Node2D

@onready var platform_scene = load("res://Scenes/Platform/Platform.tscn")#Загрузка сцены платформы

func generate():#Функция генерации мира
	for x in range(10):
		for y in range(10):
			var platform = platform_scene.instantiate()#Функция instantiate делает из ресурса объект
			platform.position.x = x*100
			platform.position.y = y*100
			if randi()%2:
				add_child(platform)#Функция добавления объекта на сцену

func _ready():
	generate()

func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		var platforms = get_tree().get_nodes_in_group("platform")#Получение всех объектов группы на сцене
		for i in platforms:
			i.queue_free()#Функция удаления объекта со сцены
		generate()

```
