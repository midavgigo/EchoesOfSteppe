extends CharacterBody2D #Наследуем скрипт

const SPEED = 100 #Выбираем значение скорости

func _ready():#Функция вызываемая в начале скрипта
	velocity = velocity.limit_length(SPEED)#Ограничиваем длину вектора скорости объекта
											#Нужно чтобы движение по диагонали не было быстрее
											#чем движение вдоль осей

func _process(delta):#Функция вызываемая много раз. Разница между вызывами записана в параметре delta
	var velocity_coef = [0, 0]#Создаем массив для коэфициентов, на которые будет умножаться скорость
	if Input.is_action_pressed("player_left"):#Если было событие "player_left" 
		velocity_coef[0] = -1#Устанавливаем коэфициент для x
	if Input.is_action_pressed("player_right"):#Аналогично
		velocity_coef[0] = 1
	if Input.is_action_pressed("player_up"):
		velocity_coef[1] = -1
	if Input.is_action_pressed("player_down"):
		velocity_coef[1] = 1
	velocity.x = velocity_coef[0]*SPEED#Устанавливаем значение скорости игрока
	velocity.y = velocity_coef[1]*SPEED
	move_and_slide()#Вызывав эту функцию, мы сдвинем игрока
