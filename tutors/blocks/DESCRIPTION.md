Блок это физический не движимый прямыми действиями игрока объект. Блоком управляет контроллер

# Настройка блока
Сам по себе блок ничего не умеет, и по сути является связующим между действиями игрока и планами геймдизайнера. Контроллер прописывает геймдизайнер и вот список вещей, которые нужно будет прописать. Для начала файле конфигурации. 
## Конфигуратор
Файл конфигурации находится по пути res://Props/Configurations/blocks.json. Добавить новый блок можно создав новое поле в корне. Имя этого поля будет именем блока. Теперь что нужно прописать на примере.
```json
"test_block":{
		"width":100,
		"height":100,
		"animated":"true",
		"script":"res://Props/Scripts/test_block.gd",
		"action_area":{
			"action":"true",
			"width":150,
			"height":150,
			"x":0,
			"y":0
		},
		"destroy":"none"
	}
```

| Поле        | Описание                                                                                                                                                                                                                                                                                                                          |
| ----------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| width       | Ширина блока                                                                                                                                                                                                                                                                                                                      |
| height      | Высота блока                                                                                                                                                                                                                                                                                                                      |
| animated    | Если true, то блок будет анимированным. Если блок анимированный, то файл анимации должен храниться по пути res://Props/Animations/название_блока.tres. Иначе спрайт блока должен хранится по пути res://Props/Sprites/название_блока/название_блока.png. У анимации должна быть анимация "default", которая и будет проигрываться |
| script      | Здесь хранится путь до скрипта контроллера блока, если указать "-", то следующие поля можно не указывать                                                                                                                                                                                                                          |
| action_area | Блок с данными о взаимодействии с блоком                                                                                                                                                                                                                                                                                          |
| action      | Если указано не "true", то взаимойдествия с блоком не будет с следующие поля блока данных указывать не нужно                                                                                                                                                                                                                      |
| width       | Ширина поля взаимодействия                                                                                                                                                                                                                                                                                                        |
| height      | Высота поля взаимодействия                                                                                                                                                                                                                                                                                                        |
| x           | Сдвиг поля взаимодействия относительно блока по x координате                                                                                                                                                                                                                                                                      |
| y           | Сдвиг поля взаимодействия относительно блока по y координате                                                                                                                                                                                                                                                                      |
| destroy     | Если указан hit, то у блока появляется некоторое количество здоровья. Он может быть разрушен                                                                                                                                                                                                                                      |
## Скрипт контроллер

Далее будет представлен код шаблон, с комментариями.
```python
extends TestBlockController

class TestBlockController:
	#Конструктор, в который передаётся объект блока
	func _init(block):
		pass
	
	#Функция, которая нужна если в поле destroy указан hit
	#Она вызывается тогда, когда по блоку проходит удар с уроном damage и материал оружия material
	func hit(damage, material):
		pass
	
	#Функция, вызываемая циклически 
	func process(delta):
		pass

	#Функция, вызываемая если блок может быть разрушен ударом
	#Здесь можно либо прописать какие-то заготовки для разрущения
	#Либо оставить pass (Если hit был указан, то функция должна присутствовать)
	func set_hittable():
		pass
	
	#Функция, вызываемая при взаимодействии с блоком
	#Вызывается если в поле action_area/action указано true
	#player - объект игрока
	func action(player):
		pass
	
```

## Добавление на сцену
После проделанных в прошлых пунктах шагах нужно добавить сцену Block.tscn на нужную вам сцену. В инспекторе указать в поле Title название блока, которое указывалось в файле конфигураций.