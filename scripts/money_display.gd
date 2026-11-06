extends RichTextLabel

var money_display_tween: Tween

func _ready() -> void:
	MoneyManager.money_changed.connect(_on_money_changed)
	MoneyManager.passive_income_paid.connect(_on_passive_income_paid)
	MoneyManager.money_spent.connect(_on_money_spent)
	_on_money_changed(MoneyManager.money)


func _on_money_changed(new_amount: int) -> void:
	text = "$%d" % new_amount


func _on_passive_income_paid(amount: int) -> void:
	if money_display_tween and money_display_tween.is_valid():
		money_display_tween.kill()

	text = "$%d  (+%d)" % [MoneyManager.money, amount]
	modulate = Color(0.7, 1.0, 0.7, 1.0)

	money_display_tween = create_tween()
	money_display_tween.tween_interval(0.8)
	money_display_tween.tween_property(self, "modulate", Color.WHITE, 0.25)
	money_display_tween.tween_callback(func(): _on_money_changed(MoneyManager.money))


func _on_money_spent(amount: int) -> void:
	if money_display_tween and money_display_tween.is_valid():
		money_display_tween.kill()

	text = "$%d  (-%d)" % [MoneyManager.money, amount]
	modulate = Color(1.0, 0.4, 0.4, 1.0)

	money_display_tween = create_tween()
	money_display_tween.tween_interval(0.8)
	money_display_tween.tween_property(self, "modulate", Color.WHITE, 0.25)
	money_display_tween.tween_callback(func(): _on_money_changed(MoneyManager.money))
