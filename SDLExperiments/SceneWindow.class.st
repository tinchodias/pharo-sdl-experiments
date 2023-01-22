Class {
	#name : #SceneWindow,
	#superclass : #Object,
	#instVars : [
		'sdlWindow',
		'sdlRenderer',
		'elements',
		'session',
		'steppingProcess',
		'transientsTile',
		'deviceScalePoint',
		'animationTileStrategy',
		'atlases',
		'logicalExtent',
		'frameCounter'
	],
	#pools : [
		'SDL2Constants',
		'SDL2Types'
	],
	#category : #'SDLExperiments-Core'
}

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

	| aPixelExtent anAtlas |
	aPixelExtent := aLogicalExtent * deviceScalePoint.
	"anAtlas := self newAtlasOf: aPixelExtent.
	atlases add: anAtlas."
	anAtlas := atlases last.

	^ anAtlas
		addTileOf: aLogicalExtent
		ifNoSpaceDo: [
			"Should handle this case, maybe try
			creation of another atlas"
			self notYetImplemented ]
]

{ #category : #'life cycle' }
SceneWindow >> close [

	self stopSteppingProcess.
	
	atlases do: [ :each | each destroyTexture ].
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

{ #category : #accessing }
SceneWindow >> frameCounter [
	^ frameCounter
]

{ #category : #initialization }
SceneWindow >> initialize [

	super initialize.

	logicalExtent := 800 @ 600.

	elements := OrderedCollection new.
	atlases := OrderedCollection new.

	self useAtlasTileStrategy.
	
	frameCounter := SceneFrameCounter new.
]

{ #category : #accessing }
SceneWindow >> logicalExtent: aPoint [

	logicalExtent := aPoint
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
					width: logicalExtent x
					height: logicalExtent y
					flags: SDL_WINDOW_SHOWN | SDL_WINDOW_ALLOW_HIGHDPI.
	sdlRenderer := sdlWindow
		createRenderer: -1
		flags: SDL_RENDERER_ACCELERATED.
	info := sdlRenderer info.

	sdlWindow title: 'Atlas Prototype Demo - ', info nameString.

	deviceScalePoint := sdlRenderer outputExtent / sdlWindow size.

	atlases add: (self newAtlasOf: info max_texture_width @ info max_texture_height).

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

	frameCounter step.
	self
		stepElements;
		stepRender;
		stepWait
]

{ #category : #stepping }
SceneWindow >> stepElements [
	
	elements do: [ :each |
		each stepBlock cull: frameCounter deltaMS cull: frameCounter totalMS ]
]

{ #category : #stepping }
SceneWindow >> stepRender [

	sdlRenderer clear.

	elements do: [ :each | each render ].

	sdlRenderer present.

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

{ #category : #'tile management' }
SceneWindow >> transientTileOf: aLogicalExtent [

	| aPixelExtent |
	aPixelExtent := aLogicalExtent * deviceScalePoint.

	^ animationTileStrategy tileOf: aPixelExtent
]

{ #category : #initialization }
SceneWindow >> useAtlasTileStrategy [

	animationTileStrategy := AtlasTileManager new sceneWindow: self; yourself.
]

{ #category : #initialization }
SceneWindow >> useNaiveTileStrategy [

	animationTileStrategy := NaiveTileManager new sceneWindow: self; yourself.
]
