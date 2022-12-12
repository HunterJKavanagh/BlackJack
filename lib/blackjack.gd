class_name BlackJack

var deck = []


func _init():
	for i in range(52):
		deck.append(i)

func rest_deck():
	deck = []
	for i in range(52):
		deck.append(i)

# shuffels deck
func shuffle():
	randomize()
	deck.shuffle()

func draw() -> int:
	return deck.pop_front()

# Calcautes the value of the sum of all the cards
# if the total + 11 > 21 then aces are counted as a 1
# else the are counted as a 11
func hand_value(hand: Array) -> int:
	if hand.size() > 0:
		var values: PoolIntArray = []
		var value: int = 0
		for card in hand:
			values.append(card%13+1)
		values.sort()
		values.invert()
		for card in values:
			if card == 1:
				if value+11 > 21:
					value += 1
				else:
					value += 11
			else:
				value += clamp(card, 1, 10)
		return value
	else:
		return 0
