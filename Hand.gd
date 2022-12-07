tool

extends Node2D

var Card = load("res://Card.tscn")
var hand: Array = []

func _ready():
	pass

func add_card(card: int, hidden: bool = false):
	self.hand.append(card)
	var tmp_card: AnimatedSprite = Card.instance()
	tmp_card.scale = Vector2(6,6)
	if hidden:
		tmp_card.animation = 'face_down'
	else:
		tmp_card.animation = 'face_up'
	tmp_card.frame = card
	tmp_card.position.x += 6*20*(hand.size()-1)
	self.add_child(tmp_card)

func reval_all():
	var tmp_hand = self.hand
	self.clear_hand()
	set_hand(tmp_hand)

func set_hand(hand: Array):
	self.clear_hand()
	for i in range(hand.size()):
		add_card(hand[i])

func clear_hand():
	self.hand = []
	for child in self.get_children():
		self.remove_child(child)


func _process(delta):
	pass
