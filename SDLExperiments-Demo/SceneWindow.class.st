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
		'steppingLoop'
	],
	#pools : [
		'SDL2Constants',
		'SDL2Types'
	],
	#category : #'SDLExperiments-Demo-Scene'
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

{ #category : #initialization }
SceneWindow >> initialize [

	super initialize.

	logicalExtent := 800 @ 600.
	elements := OrderedCollection new.
	tileManager := CairoDirectTileManager new.

	timeCounter := SceneTimeCounter new.
	steppingLoop := SceneLoop new
		stepBlock: [ self step ];
		yourself.

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

"	SDL2 initVideo."
	sdlRenderDriverName ifNotNil: [
		SDL2 setHint: 'SDL_RENDER_DRIVER' value: sdlRenderDriverName ].

	sdlWindow := SDL2 createWindow: 'Tiles'
					x: 5
					y: 25
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
SceneWindow >> sdlRenderDriverName: aString [

	sdlRenderDriverName := aString
]

{ #category : #accessing }
SceneWindow >> sdlRenderer [

	^ sdlRenderer
]

{ #category : #stepping }
SceneWindow >> step [

	timeCounter step.
	self
		stepElements;
		stepRender
]

{ #category : #stepping }
SceneWindow >> stepElements [
	
	elements do: [ :each |
		each stepBlock cull: timeCounter deltaMS cull: timeCounter totalMS ]
]

{ #category : #stepping }
SceneWindow >> stepRender [

	sdlRenderer clear.

	tileManager renderTilesWith: [
		elements do: [ :each | each render ] ].

	sdlRenderer present.

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
