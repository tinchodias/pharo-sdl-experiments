Class {
	#name : #SceneWindow,
	#superclass : #Object,
	#instVars : [
		'sdlWindow',
		'sdlRenderer',
		'elements',
		'deviceScalePoint',
		'logicalExtent',
		'tileManager',
		'sdlRenderDriverName',
		'timeCounter',
		'steppingLoop',
		'initialPosition'
	],
	#pools : [
		'SDL2Constants',
		'SDL2ConstantsHint',
		'SDL2Types'
	],
	#category : #'SDLExperiments-Demo-Utility-Window'
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

{ #category : #adding }
SceneWindow >> addElement: anElement [ 

	anElement sceneWindow: self.
	elements add: anElement

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
SceneWindow >> elements [

	^ elements
]

{ #category : #accessing }
SceneWindow >> initialPosition [

	^ initialPosition
]

{ #category : #accessing }
SceneWindow >> initialPosition: aPoint [

	initialPosition := aPoint
]

{ #category : #initialization }
SceneWindow >> initialize [

	super initialize.

	logicalExtent := 800 @ 600.
	initialPosition := 5 @ 25.

	elements := OrderedCollection new.
	tileManager := TextureTileManager newStreaming.

	self resetTimeCounter.
	self useUncappedSteppingLoop.
]

{ #category : #accessing }
SceneWindow >> logicalExtent [

	^ logicalExtent
]

{ #category : #accessing }
SceneWindow >> logicalExtent: aPoint [

	logicalExtent := aPoint
]

{ #category : #accessing }
SceneWindow >> logicalRectangle [

	^ sdlWindow position extent: logicalExtent

	
]

{ #category : #'life cycle' }
SceneWindow >> open [

	sdlRenderDriverName ifNotNil: [
		SDL2 setHint: 'SDL_RENDER_DRIVER' value: sdlRenderDriverName ].

	SDL2 setHint: 'SDL_RENDER_SCALE_QUALITY' value: '2'.
	SDL2 setHint: 'SDL_RENDER_LINE_METHOD' value: '3'.

	sdlWindow := SDL2 createWindow: 'Tiles'
					x: initialPosition x
					y: initialPosition y
					width: logicalExtent x
					height: logicalExtent y
					flags: SDL_WINDOW_ALLOW_HIGHDPI | SDL_WINDOW_SHOWN.
	sdlWindow signalErrorIfNull.
	sdlWindow raise. "Place it on top"

	sdlRenderer := sdlWindow
		createRenderer: -1
		flags: SDL_RENDERER_ACCELERATED.
	sdlRenderer signalErrorIfNull.

	sdlRenderer drawBlendMode: SDL_BLENDMODE_BLEND.
"	sdlRenderer drawBlendMode: SDL2 premultipliedAlphaBlendMode."

	deviceScalePoint := sdlRenderer outputExtent / sdlWindow extent.

	
	tileManager prepareOn: self
]

{ #category : #accessing }
SceneWindow >> refreshRate [
	"Answer the window display's refresh rate, in Hertz."

	^ sdlWindow displayMode refreshRate
]

{ #category : #initialization }
SceneWindow >> resetTimeCounter [
	
	timeCounter := SceneTimeCounter new
]

{ #category : #accessing }
SceneWindow >> sdlRenderDriverName: aString [

	sdlRenderDriverName := aString
]

{ #category : #accessing }
SceneWindow >> sdlRenderer [

	^ sdlRenderer
]

{ #category : #accessing }
SceneWindow >> sdlWindow [

	^ sdlWindow
]

{ #category : #stepping }
SceneWindow >> step [

	timeCounter step.

	elements do: [ :each |
		each stepBlock
			cull: timeCounter deltaMS
			cull: timeCounter totalMS.
		each ensureReadyToRender ].


	sdlRenderer
		drawColorR: 255 g: 255 b: 255 a: 255;
		clear.
	
	tileManager renderTilesWith: [
		elements do: [ :each | each render ] ].
	sdlRenderer present
]

{ #category : #accessing }
SceneWindow >> steppingLoop [

	^ steppingLoop
]

{ #category : #accessing }
SceneWindow >> tileManager [
	
	^ tileManager
]

{ #category : #accessing }
SceneWindow >> tileManager: aTileManager [ 
	
	tileManager := aTileManager
]

{ #category : #accessing }
SceneWindow >> timeCounter [

	^ timeCounter
]

{ #category : #accessing }
SceneWindow >> title: aString [

	sdlWindow title: aString
]

{ #category : #initialization }
SceneWindow >> useCappedSteppingLoop [

	steppingLoop := SceneCappedLoop new
		stepBlock: [ self step ];
		yourself.

]

{ #category : #initialization }
SceneWindow >> useUncappedSteppingLoop [

	steppingLoop := SceneLoop new
		stepBlock: [ self step ];
		yourself.

]
