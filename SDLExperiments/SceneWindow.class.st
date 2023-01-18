Class {
	#name : #SceneWindow,
	#superclass : #Object,
	#instVars : [
		'windowExtent',
		'sdlWindow',
		'sdlRenderer',
		'atlas',
		'elements',
		'session',
		'steppingProcess',
		'lastMS',
		'deltaMS',
		'listOfDeltaMS',
		'startMS',
		'transientsTile',
		'totalMS',
		'deviceScalePoint',
		'animationTileStrategy'
	],
	#pools : [
		'SDL2Constants',
		'SDL2Types'
	],
	#category : #'SDLExperiments-Core'
}

{ #category : #examples }
SceneWindow class >> example1 [

	| windowExtent sceneWindow random durationMS numberOfCircles numberOfAnimatedCircles |
	windowExtent := 900 asPoint.
	sceneWindow := SceneWindow new
		windowExtent: windowExtent;
		yourself.

	random := Random new.
	durationMS := 10000.0.

	numberOfCircles := 200.
	numberOfAnimatedCircles := 5.
	1 to: numberOfCircles do: [ :index |
		| circleRadius lineWidth padding from relativeTo anElement |
		circleRadius := random nextIntegerBetween: 10 and: windowExtent x / 7.
		lineWidth := random nextIntegerBetween: 1 and: circleRadius/5.
		padding := lineWidth.
		from := Point
			x: (random nextIntegerBetween: 0 and: windowExtent x - (circleRadius*2))
			y: (random nextIntegerBetween: 0 and: windowExtent y - (circleRadius*2)).
		relativeTo := Point
			x: (random nextIntegerBetween: -100 and: 100)
			y: (random nextIntegerBetween: -100 and: 100).

		anElement := sceneWindow addElement.
		
		anElement
			isAnimated: index >= (numberOfCircles - numberOfAnimatedCircles);
			position: from;
			extent: ((circleRadius + padding) *2) asPoint;
			stepBlock: [ :deltaMS :totalMS |
				| amount |
				amount := totalMS / durationMS.
				anElement position: from + (relativeTo * amount) ];
			renderBlock: [ :cairoContext |
				cairoContext
					sourceColorRGB: Color random;
					translateByX: padding y: padding;
					lineWidth: lineWidth;
					lineCap: AeCairoCapStyle square;
					dash: (AeCairoDoubleArray newFrom: { 0. (lineWidth*2) }) offset: 0;
					circleRadius: circleRadius;
					stroke ].
		].

	sceneWindow open.
	(Delay forMilliseconds: durationMS) wait.
	sceneWindow close.

	(String streamContents: [ :stream |
		stream << 'Frames: '.
"		MeanConfidenceIntervalPrinter new
			unitString: 'ms';
			print: sceneWindow listOfDeltaMS
				on: stream.
		stream << ' ('."

		sceneWindow fps
			printOn: stream
			showingDecimalPlaces: 1.
		stream << ' per second'.

		 ]) traceCr "] fork"
]

{ #category : #accessing }
SceneWindow >> addElement [

	| newElement |
	newElement := SceneElement new
		sceneWindow: self;
		yourself.

	elements add: newElement.

	^ newElement 
]

{ #category : #'tile management' }
SceneWindow >> addTileOf: aLogicalExtent [

	^ atlas
		addTileOf: aLogicalExtent
		ifNoSpaceDo: [
			"Should handle this case, maybe try
			creation of another atlas"
			self notYetImplemented ]
]

{ #category : #accessing }
SceneWindow >> atlas [
	^ atlas
]

{ #category : #'life cycle' }
SceneWindow >> close [

	self stopSteppingProcess.
	
	atlas destroyTexture.
	sdlRenderer destroy.
	sdlWindow destroy.

]

{ #category : #accessing }
SceneWindow >> deviceScalePoint [
	^ deviceScalePoint
]

{ #category : #accessing }
SceneWindow >> elements: aCollection [

	elements := aCollection
]

{ #category : #'accessing stats' }
SceneWindow >> fps [

	^ listOfDeltaMS size / self totalSeconds
]

{ #category : #initialization }
SceneWindow >> initialize [

	super initialize.

	windowExtent := 800 @ 600.

	elements := OrderedCollection new.

	self useSameAtlasStrategy.
]

{ #category : #'accessing stats' }
SceneWindow >> listOfDeltaMS [

	^ listOfDeltaMS
]

{ #category : #'tile management' }
SceneWindow >> newAtlasOf: aPixelExtent [

	| newAtlas |
	newAtlas := Atlas
		newWithRenderer: sdlRenderer
		pixelExtent: aPixelExtent.
	newAtlas createTexture.
	newAtlas deviceScalePoint: deviceScalePoint.
	^ newAtlas

]

{ #category : #'life cycle' }
SceneWindow >> open [

	| info |
	SDL2 initVideo.
	SDL2 setHint: 'SDL_RENDER_BATCHING' value: '1'.
	SDL2 setHint: 'SDL_FRAMEBUFFER_ACCELERATION' value: '1'.
"	SDL2 setHint: 'SDL_RENDER_DRIVER' value: 'metal'."

	sdlWindow := SDL2 createWindow: 'Tiles'
					x: 0
					y: 0
					width: windowExtent x
					height: windowExtent y
					flags: SDL_WINDOW_SHOWN | SDL_WINDOW_ALLOW_HIGHDPI.
	sdlRenderer := sdlWindow
		createRenderer: -1
		flags: SDL_RENDERER_ACCELERATED.
	info := sdlRenderer info.

	sdlWindow title: 'Atlas Prototype Demo - ', info nameString.

	deviceScalePoint := sdlRenderer outputExtent / sdlWindow size.

	atlas := self newAtlasOf: info max_texture_width @ info max_texture_height.

	"Backgorund color"
	sdlRenderer drawColorR: 255 g: 255 b: 255 a: 255.

	animationTileStrategy initializeOnOpenScene.

	self startSteppingProcess.
]

{ #category : #stepping }
SceneWindow >> startSteppingProcess [

	[	session := Smalltalk session.
		steppingProcess := Processor activeProcess.
		
		[ steppingProcess == Processor activeProcess
			and: [ session == Smalltalk session ] ]
		
				whileTrue: [ self step  ] ]

			forkAt: Processor userSchedulingPriority
			named: 'Step Loop ', self asString

]

{ #category : #stepping }
SceneWindow >> step [

	self
		stepTimeCounters;
		stepElements;
		stepRender;
		stepWait
]

{ #category : #stepping }
SceneWindow >> stepElements [
	
	elements do: [ :each |
		each stepBlock cull: deltaMS cull: totalMS ]
]

{ #category : #stepping }
SceneWindow >> stepRender [

	sdlRenderer clear.

	elements do: [ :each | each render ].

	sdlRenderer present.

]

{ #category : #stepping }
SceneWindow >> stepTimeCounters [

	lastMS
		ifNil: [
			startMS := Time millisecondClockValue.
			deltaMS := 0.
			lastMS := startMS.
			totalMS := 0.

			listOfDeltaMS := OrderedCollection new: 10 * 250 ]
		ifNotNil: [ 
			| currentMS |
			currentMS := Time millisecondClockValue.
			deltaMS := currentMS - lastMS.
			lastMS := currentMS.
			totalMS := lastMS - startMS.

			listOfDeltaMS add: deltaMS ]

]

{ #category : #stepping }
SceneWindow >> stepWait [

	"1 milliSecond wait"
	Processor yield
]

{ #category : #stepping }
SceneWindow >> stopSteppingProcess [

	steppingProcess ifNil: [ ^self ].
	steppingProcess terminate.
	steppingProcess := nil.
]

{ #category : #'accessing stats' }
SceneWindow >> totalSeconds [

	^ (lastMS - startMS) / 1000.0
]

{ #category : #'tile management' }
SceneWindow >> transientTileOf: aLogicalExtent [

	| aPixelExtent |
	aPixelExtent := aLogicalExtent * deviceScalePoint.

	^ animationTileStrategy tileOf: aPixelExtent
]

{ #category : #initialization }
SceneWindow >> useOtherAtlasStrategy [

	animationTileStrategy := OtherAtlasStrategy new sceneWindow: self; yourself.
]

{ #category : #initialization }
SceneWindow >> useSameAtlasStrategy [

	animationTileStrategy := SameAtlasStrategy new sceneWindow: self; yourself.
]

{ #category : #accessing }
SceneWindow >> windowExtent [

	^ windowExtent
]

{ #category : #accessing }
SceneWindow >> windowExtent: aPoint [

	windowExtent := aPoint
]
