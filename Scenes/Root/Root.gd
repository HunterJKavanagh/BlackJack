extends Node2D


var bj = load('res://lib/blackjack.gd').new()
var points = 9
var bet = 1


# Called when the node enters the scene tree for the first time.
func _ready():
	start_round()


# Resets and shuffles the deck, give the player and dealer there starting hand.
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


func update_UI():
	$'UI/Center/TotalPoints/VBoxContainer/Points'.text = str(points)
	$'UI/Center/Bet/VBoxContainer/Bet'.text = str(bet)
	$Node2D/Result.visible = false


# Computes wether the player got a Win, Draw, or Loss and returns the result
func round_result(player_hand, dealer_hand) -> String:
	var player_value = bj.hand_value(player_hand)
	var dealer_value = bj.hand_value(dealer_hand)
	
	if player_value > 21:
		if dealer_value > 21: # draw
			return 'Draw'
		else: # loss
			return 'Loss'
	elif player_value > dealer_value or dealer_value > 21: # win
		return 'Win'
	elif player_value == dealer_value: # draw
		return 'Draw'
	else: # loss
		return 'Loss'


# disables all buttons
func game_over():
	$'UI/Center/BetControll/plus'.disabled = true
	$'UI/Center/BetControll/minus'.disabled = true
	$'UI/Center/BetControll/One'.disabled = true
	$'UI/Center/Hand Controll/Hit'.disabled = true
	$'UI/Center/Hand Controll/Stand'.disabled = true


# Is called when the Hit/Start button is pressed
func _on_Hit_pressed():
	# When the button is in hit mode, a new card is drawn form the deck and
	# add to the players hand if their hand value is less the 21.
	# It Will also disables the BetControll buttons
	if $'UI/Center/Hand Controll/Hit'.text  == 'Hit':
		if bj.hand_value($PlayerHand.hand) < 21:
			$PlayerHand.add_card(bj.draw())
		$UI/Player/Label.text = str(bj.hand_value($PlayerHand.hand))
		
		$'UI/Center/BetControll/plus'.disabled = true
		$'UI/Center/BetControll/minus'.disabled = true
		$'UI/Center/BetControll/One'.disabled = true
	# When the button is in Start mode, teh points total is computed,
	# the UI is updated, and the BetControll buttons are enabled.
	elif $'UI/Center/Hand Controll/Hit'.text  == 'Start':
		var result = round_result($PlayerHand.hand, $DealerHand.hand)
		
		match result:
			'Win':
				points += bet*2 - 1
				bet = 1
			'Draw':
				points += bet - 1
				bet = 1
			'Loss':
				points -= 1
				bet = 1
		update_UI()
		
		start_round()
		$'UI/Center/Hand Controll/Stand'.disabled = false
		$'UI/Center/Hand Controll/Hit'.text  = 'Hit'
		
		$'UI/Center/BetControll/plus'.disabled = false
		$'UI/Center/BetControll/minus'.disabled = false
		$'UI/Center/BetControll/One'.disabled = false
	else:
		printerr('UI/Center/Hand Controll/Hit\'.text does != Hit or Start')


# Is called when the Stand button is pressed
func _on_Stand_pressed():
	# Revels the deals hand 
	$DealerHand.reveal_all()
	while bj.hand_value($DealerHand.hand) < 17:
		$DealerHand.add_card(bj.draw())
	$UI/Dealer/Label.text = str(bj.hand_value($DealerHand.hand))
	
	$'UI/Center/Hand Controll/Stand'.disabled = true
	$'UI/Center/Hand Controll/Hit'.text = 'Start'
	
	# Disaplyes wether the player Won, Draw, or Loss
	# If the player got a Loss and has 0 points left then Game Over
	var result = round_result($PlayerHand.hand, $DealerHand.hand)
	if result == 'Loss' and points == 0:
		$Node2D/Result.text = 'Game Over'
		$Node2D/Result.visible = true
		game_over()
	else:
		$Node2D/Result.text = result
		$Node2D/Result.visible = true


# adds one to bet
func _on_plus_pressed():
	if points > 0:
		points -= 1
		bet += 1
	update_UI()


# subtracts 1 from bet. minimum bet is 1
func _on_minus_pressed():
	if bet > 1:
		points += 1
		bet -= 1
	update_UI()


# rest set the bet to 1
func _on_One_pressed():
	points += bet - 1
	bet = 1
	update_UI()
