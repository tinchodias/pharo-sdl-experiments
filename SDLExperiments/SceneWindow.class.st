Class {
	#name : #SceneWindow,
	#superclass : #Object,
	#instVars : [
		'sdlWindow',
		'sdlRenderer',
		'elements',
		'session',
		'steppingProcess',
		'deviceScalePoint',
		'logicalExtent',
		'frameCounter',
		'tileManager',
		'sdlRenderDriverName'
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

	| aPixelExtent |
	aPixelExtent := aLogicalExtent * deviceScalePoint.
	
	^ tileManager staticTileOf: aPixelExtent
]

{ #category : #'life cycle' }
SceneWindow >> close [
	
	tileManager finalize.
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

	tileManager := AtlasTileManager new.
	
	frameCounter := SceneFrameCounter new.
]

{ #category : #accessing }
SceneWindow >> logicalExtent [

	^ logicalExtent
]

{ #category : #accessing }
SceneWindow >> logicalExtent: aPoint [

	logicalExtent := aPoint
]

{ #category : #'life cycle' }
SceneWindow >> open [

	SDL2 initVideo.
	SDL2 setHint: 'SDL_RENDER_BATCHING' value: '1'.
	SDL2 setHint: 'SDL_FRAMEBUFFER_ACCELERATION' value: '1'.
	sdlRenderDriverName ifNotNil: [
		SDL2 setHint: 'SDL_RENDER_DRIVER' value: sdlRenderDriverName ].

	sdlWindow := SDL2 createWindow: 'Tiles'
					x: 20
					y: 20
					width: logicalExtent x
					height: logicalExtent y
					flags: SDL_WINDOW_SHOWN | SDL_WINDOW_ALLOW_HIGHDPI.
	sdlRenderer := sdlWindow
		createRenderer: -1
		flags: SDL_RENDERER_ACCELERATED.

	deviceScalePoint := sdlRenderer outputExtent / sdlWindow size.

	"Backgorund color"
	sdlRenderer drawColorR: 255 g: 255 b: 255 a: 255.

	
	tileManager prepareOn: self.

	sdlWindow title: (sdlRenderer info nameString, ';', tileManager asString).
]

{ #category : #accessing }
SceneWindow >> sdlRenderDriverName: anObject [

	sdlRenderDriverName := anObject
]

{ #category : #accessing }
SceneWindow >> sdlRenderer [
	^ sdlRenderer
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

	tileManager renderTilesWith: [
		elements do: [ :each | each render ] ].

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

{ #category : #accessing }
SceneWindow >> tileManager: aTileManager [ 
	
	tileManager := aTileManager
]

{ #category : #accessing }
SceneWindow >> title: aString [

	sdlWindow title: aString
]

{ #category : #'tile management' }
SceneWindow >> transientTileOf: aLogicalExtent [

	| aPixelExtent |
	aPixelExtent := aLogicalExtent * deviceScalePoint.

	^ tileManager transientTileOf: aPixelExtent
]
