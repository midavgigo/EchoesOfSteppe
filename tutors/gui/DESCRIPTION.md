# Графический интерфейс

## Подготовка

Создаём сцену.

Добавляем AnimatedSprite2D и делаем с ним всё тоже самое, что и в предыдущем гайде.

Добавляем **Button** и **Label** 4 штуки.

Делаем такую конструкцию что в одной строке идут 3 лейбла |Анимация проигрывалась|0|раз

Лейбел, в который записали 0, обзываем. (В моём случае Count)

Снизу добавляем лейбел и обызываем его тоже. (В моём случае Status)

Создаём скрипт для корня сцены

## Сигналы

Выбираем кнопку и в правой части меняем вкладку **Инспектор** на **Узел**.

Выбираем вкладку **Сигналы**

По названию можно понять, когда эти сигналы работают.

Выбираем **pressed()**, нажимаем привязать, привязываем к созданному скрипту

Выбираем анимацию и делаем такие же действия, только для сигнала **animation_finished()**

Пишем этот код, думаю в нём нет ничего сложного

```
extends Node2D

@onready var count_text = $Count
@onready var status_text = $Status
@onready var animated_sprite = $AS2D

var count = 0

func _on_button_pressed():
	animated_sprite.play("animation")
	status_text.text = "Анимация проигрывается"

func _on_as_2d_animation_finished():
	count+=1
	count_text.text = str(count)
	status_text.text = "Анимация завершилась"
```
