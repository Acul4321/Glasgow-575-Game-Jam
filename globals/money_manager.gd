extends Node

signal money_changed(new_amount: int)
signal passive_income_paid(amount: int)

var starting_money: int = 100
var passive_income_amount: int = 10
var passive_income_interval: float = 1.0

var money: int
var income_timer: Timer


func _ready() -> void:
	money = starting_money

	income_timer = Timer.new()
	income_timer.wait_time = max(passive_income_interval, 0.1)
	income_timer.one_shot = false
	income_timer.timeout.connect(_on_income_timer_timeout)
	add_child(income_timer)
	income_timer.start()


func add_money(amount: int) -> void:
	if amount <= 0:
		return

	money += amount
	money_changed.emit(money)


func spend_money(amount: int) -> bool:
	if amount <= 0 or money < amount:
		return false

	money -= amount
	money_changed.emit(money)
	return true


func can_afford(amount: int) -> bool:
	return amount >= 0 and money >= amount


func set_passive_income_interval(seconds: float) -> void:
	passive_income_interval = max(seconds, 0.1)

	if income_timer:
		income_timer.wait_time = passive_income_interval


func _on_income_timer_timeout() -> void:
	if passive_income_amount <= 0:
		return

	add_money(passive_income_amount)
	passive_income_paid.emit(passive_income_amount)
