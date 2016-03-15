app = Framer.Importer.load("imported/appExample@2x")

# define initial positions
app.appView.scale = 0
app.appView.originX = 0.361
app.appView.originY = 0.17
app.springboard.originX = 0.365
app.springboard.originY = 0.2

app.star1.scale = 0
app.star2.scale = 0
app.star3.scale = 0

app.star1.opacity = 0
app.star2.opacity = 0
app.star3.opacity = 0

app.check1.scale = 0
app.check2.scale = 0
app.check3.scale = 0

app.check1.opacity = 0
app.check2.opacity = 0
app.check3.opacity = 0

app.cell1.scale = 0
app.cell2.scale = 0
app.cell3.scale = 0
app.cell4.scale = 0
app.cell5.scale = 0
app.cell6.scale = 0
app.cell7.scale = 0
app.cell8.scale = 0
app.cell9.scale = 0
app.cell10.scale = 0
app.cell11.scale = 0

app.cell1.opacity = 0
app.cell2.opacity = 0
app.cell3.opacity = 0
app.cell4.opacity = 0
app.cell5.opacity = 0
app.cell6.opacity = 0
app.cell7.opacity = 0
app.cell8.opacity = 0
app.cell9.opacity = 0
app.cell10.opacity = 0
app.cell11.opacity = 0

app.completeTitle.opacity = 0
app.complete.scale = 0
app.complete.opacity = 0

app.closeButton.scale = 0

# define draggables and scrollable
app.card1.draggable = true
app.card2.draggable = false
app.card3.draggable = false

scroll = ScrollComponent.wrap(app.cells)
scroll.scrollHorizontal = false
scroll.contentInset =
	bottom: 40
app.cells.scale = 0

# define springs
cardLift = "spring(160,40,10)"
cardPull = "spring(200,26,10)"
cardSpring = "spring(400,22,20)"
cardFill = "spring(400,22,30)"
cardReturn = "spring(160,30,10)"
cellSpring = "spring(320,30,0)"

# define animations
cardExitLeft = (layer) ->
	layer.animate
		properties:
			x: -750
		curve: cardPull

cardExitRight = (layer) ->
	layer.animate
		properties:
			x: 750
		curve: cardPull
		
completeCards = (onoff, delay) ->
	app.complete.animate
		properties:
			scale: onoff
			opacity: onoff
		curve: cardSpring
		delay: delay
	app.completeTitle.animate
		properties:
			opacity: onoff
		time: 0.3
		delay: 2 * delay
		
cellScale = (layer, scaleValue, opacityValue, delayValue) ->
	layer.animate
		properties:
			scale: scaleValue
			opacity: opacityValue
		curve: cellSpring
		delay: delayValue

# define conditionals
currentCard = 1

# open app
app.appIcon.on Events.Click, ->
	app.appView.animate
		properties:
			scale: 1
		time: 0.55
	app.springboard.animate
		properties:
			scale: 8.4
		time: 0.55
	app.appIcon.animate
		properties:
			opacity: 0
		time: 0.05
	app.springboardIcons.animate
		properties:
			opacity: 0
		time: 0.55

# create array for cards in Sketch file
cardsArray = [app.card1, app.card2, app.card3]

# apply actions and style to cards in a loop
for card in cardsArray
	# card shadow style
	card.shadowY = 4
	card.shadowBlur = 12
	card.shadowColor = "rgba(0,0,0,0.16)"
	card.borderRadius = 12
	
	# card position states
	card.states.add
		card1:
			scale: 1
			midY: card.midY
			midX: card.midX
		card2:
			scale: 0.9
			midY: card.midY - 60
			midX: card.midX
		card3:
			scale: 0.8
			midY: card.midY - 120
			midX: card.midX
	card.states.animationOptions =
	    curve: cardPull
	    
	# cards set to initial position
	card.states.switchInstant(card.name)
	
	# on drag scale card
	card.on Events.DragStart, ->
		this.animate
			properties:
				scale: 1.1
			curve: cardLift
			
	# while dragging show overlay
	card.on Events.Drag, ->
		if this.name == "card1"
			if app.card1.x > 75
				app.star1.scale = (app.card1.x-50)/400
				app.star1.opacity = (app.card1.x-50)/400
				currentCard = 2
			else if app.card1.x < -75
				app.check1.scale = -(app.card1.x+50)/400
				app.check1.opacity = -(app.card1.x-50)/400
				currentCard = 2
			else
				app.star1.scale = 0
				app.check1.scale = 0
		if this.name == "card2"
			if app.card2.x > 75
				app.star2.scale = (app.card2.x-50)/400
				app.star2.opacity = (app.card2.x-50)/400
				currentCard = 3
			else if app.card2.x < -75
				app.check2.scale = -(app.card2.x+50)/400
				app.check2.opacity = -(app.card2.x-50)/400
				currentCard = 3
			else
				app.star2.scale = 0
				app.check2.scale = 0
		if this.name == "card3"
			if app.card3.x > 75
				app.star3.scale = (app.card3.x-50)/400
				app.star3.opacity = (app.card3.x-50)/400
				currentCard = 0
			else if app.card3.x < -75
				app.check3.scale = -(app.card3.x+50)/400
				app.check3.opacity = -(app.card3.x-50)/400
				currentCard = 0
			else
				app.star3.scale = 0
				app.check3.scale = 0
				
	# on drag end decide where card should go
	card.on Events.DragEnd, ->
		if this.name == "card1"
			if this.x > 150
				cardExitRight(this)
				app.card2.states.switch("card1")
				app.card3.states.switch("card2")
				app.card1.draggable = false
				app.card2.draggable = true
			else if this.x < -150
				cardExitLeft(this)
				app.card2.states.switch("card1")
				app.card3.states.switch("card2")
				app.card1.draggable = false
				app.card2.draggable = true
			else
				this.states.switch("card1")
				app.star1.scale = 0
				app.check1.scale = 0
		else if this.name == "card2"
			if this.x > 150
				cardExitRight(this)
				app.card3.states.switch("card1")
				app.card2.draggable = false
				app.card3.draggable = true
			else if this.x < -150
				cardExitLeft(this)
				app.card3.states.switch("card1")
				app.card2.draggable = false
				app.card3.draggable = true
			else
				this.states.switch("card1")
				app.star2.scale = 0
				app.check2.scale = 0
		else if this.name == "card3"
			if this.x > 150
				cardExitRight(this)
				completeCards(1, 0.2)
				app.card1.draggable = true
				app.card3.draggable = false
			else if this.x < -150
				cardExitLeft(this)
				completeCards(1, 0.2)
				app.card1.draggable = true
				app.card3.draggable = false
			else
				this.states.switch("card1")
				app.star3.scale = 0
				app.check3.scale = 0

# reload cards			
app.reloadButton.on Events.Click, ->
	app.card1.draggable = true
	app.card2.draggable = false
	app.card3.draggable = false
	app.card1.animateStop()
	app.card2.animateStop()
	app.card3.animateStop()
	app.card1.x = 0
	app.card2.x = 0
	app.card3.x = 0
	app.card1.y = -780
	app.card2.y = -780
	app.card3.y = -780
	app.card1.scale = 1
	app.card2.scale = 1
	app.card3.scale = 1
	app.star1.scale = 0
	app.star2.scale = 0
	app.star3.scale = 0
	app.check1.scale = 0
	app.check2.scale = 0
	app.check3.scale = 0
	completeCards(0, 0)
	currentCard = 1
	Utils.delay 0.05, ->
		app.card1.states.switch("card1")
	Utils.delay 0.1, ->
		app.card2.states.switch("card2")
	Utils.delay 0.15, ->
		app.card3.states.switch("card3")
	    
# open current card			
app.openButton.on Events.Click, ->
	app.cells.scale = 1
	if currentCard != 0
		if currentCard == 1
			app.card1.animate
				properties:
					scale: 3
				time: 0.4
		if currentCard == 2
			app.card2.animate
				properties:
					scale: 3
				time: 0.4
		if currentCard == 3
			app.card3.animate
				properties:
					scale: 3
				time: 0.4
		app.navBar.animate
			properties:
				y: -128
			curve: cardSpring
		app.bottomBar.animate
			properties:
				y: 1334
			curve: cardSpring
		cellScale(app.cell1, 1, 1, 0.2)
		cellScale(app.cell2, 1, 1, 0.3)
		cellScale(app.cell3, 1, 1, 0.4)
		cellScale(app.cell4, 1, 1, 0.5)
		cellScale(app.cell5, 1, 1, 0.6)
		cellScale(app.cell6, 1, 1, 0.7)
		cellScale(app.cell7, 1, 1, 0.8)
		cellScale(app.cell8, 1, 1, 0.9)
		cellScale(app.cell9, 1, 1, 1)
		cellScale(app.cell10, 1, 1, 1.1)
		cellScale(app.cell11, 1, 1, 1.2)
		cellScale(app.closeButton, 1, 1, 1.1)
	
# close open card			
app.closeButton.on Events.Click, ->
	scroll.animate
		properties: 
			scrollY: 0
		time: 0.5
	cellScale(app.closeButton, 0, 0, 0)
	cellScale(app.cell11, 0, 0, 0)
	cellScale(app.cell10, 0, 0, 0)
	cellScale(app.cell9, 0, 0, 0)
	cellScale(app.cell8, 0, 0, 0)
	cellScale(app.cell7, 0, 0, 0)
	cellScale(app.cell6, 0, 0, 0)
	cellScale(app.cell5, 0, 0, 0.05)
	cellScale(app.cell4, 0, 0, 0.1)
	cellScale(app.cell3, 0, 0, 0.15)
	cellScale(app.cell2, 0, 0, 0.2)
	cellScale(app.cell1, 0, 0, 0.25)
	if currentCard == 1
		app.card1.animate
			properties:
				scale: 1
			curve: cardReturn
			delay: 0.3
	if currentCard == 2
		app.card2.animate
			properties:
				scale: 1
			curve: cardReturn
			delay: 0.3
	if currentCard == 3
		app.card3.animate
			properties:
				scale: 1
			curve: cardReturn
			delay: 0.3
	app.navBar.animate
		properties:
			y: 0
		curve: cardLift
		delay: 0.3
	app.bottomBar.animate
		properties:
			y: 1236
		curve: cardLift
		delay: 0.3
	app.cells.animate
		properties:
			scale: 0
		time: 0
		delay: 0.8