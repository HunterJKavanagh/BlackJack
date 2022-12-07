extends Node2D


var bj = load('res://blackjack.gd').new()
var points = 10
var bet = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	start_round()


func _process(delta):
	pass


func start_round():
	bj.rest_deck()
	bj.shuffle()
	$DealerHand.clear_hand()
	$DealerHand.add_card(bj.draw())
	$UI/Dealer/Label.text = str(bj.hand_value($DealerHand.hand))
	$DealerHand.add_card(bj.draw(), true)
	$PlayerHand.clear_hand()
	$PlayerHand.add_card(bj.draw())
	$PlayerHand.add_card(bj.draw())
	$UI/Player/Label.text = str(bj.hand_value($PlayerHand.hand))
	$'UI/Center/TotalPoints/VBoxContainer/Points'.text = str(points)
	$'UI/Center/Bet/VBoxContainer/Bet'.text = str(bet)

func update_BetControll():
	$'UI/Center/TotalPoints/VBoxContainer/Points'.text = str(points)
	$'UI/Center/Bet/VBoxContainer/Bet'.text = str(bet)


func _on_Hit_pressed():
	if $'UI/Center/Hand Controll/Hit'.text  == 'Hit':
		if bj.hand_value($PlayerHand.hand) < 21:
			$PlayerHand.add_card(bj.draw())
		else:
			pass
		$UI/Player/Label.text = str(bj.hand_value($PlayerHand.hand))
		
		$'UI/Center/BetControll/plus'.disabled = true
		$'UI/Center/BetControll/minus'.disabled = true
		$'UI/Center/BetControll/zero'.disabled = true
	else:
		var player_value = bj.hand_value($PlayerHand.hand)
		var dealer_value = bj.hand_value($DealerHand.hand)
		
		if player_value > 21:
			if dealer_value > 21: # draw
				points += bet
				bet = 0
			else: # loss
				bet = 0
		elif player_value > dealer_value or dealer_value > 21: # win
			points += bet*2
			bet = 0
		elif player_value == dealer_value: # draw
			points += bet
			bet = 0
		else: # loss
			bet = 0
		update_BetControll()
		
		start_round()
		$'UI/Center/Hand Controll/Stand'.disabled = false
		$'UI/Center/Hand Controll/Hit'.text  = 'Hit'
		
		$'UI/Center/BetControll/plus'.disabled = false
		$'UI/Center/BetControll/minus'.disabled = false
		$'UI/Center/BetControll/zero'.disabled = false


func _on_Stand_pressed():
	$DealerHand.reval_all()
	while bj.hand_value($DealerHand.hand) < 17:
		$DealerHand.add_card(bj.draw())
	$UI/Dealer/Label.text = str(bj.hand_value($DealerHand.hand))
	$'UI/Center/Hand Controll/Stand'.disabled = true
	$'UI/Center/Hand Controll/Hit'.text = 'Start'


func _on_plus_pressed():
	if points > 0:
		points -= 1
		bet += 1
	update_BetControll()


func _on_minus_pressed():
	if bet > 0:
		points += 1
		bet -= 1
	update_BetControll()


func _on_zero_pressed():
	points += bet
	bet = 0
	update_BetControll()
