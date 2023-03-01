"
I'm a node to be rendered in a scene window.

I have a pluggable block closure that receives a Cairo context to render on it.

I know a rectangle that represents my position and extent on the scene.

My tile variable may store a previously rendered tile, which can be used to save time if no changes happened.
"
Class {
	#name : #SceneElement,
	#superclass : #Object,
	#instVars : [
		'sceneWindow',
		'renderBlock',
		'stepBlock',
		'tile',
		'isAnimated',
		'dstFRect',
		'logicalExtent',
		'logicalPosition',
		'pixelExtent',
		'opacityAsByte'
	],
	#category : #'SDLExperiments-Demo-Utility-Window'
}

{ #category : #private }
SceneElement >> ensureDeviceScaledProperties [

	pixelExtent ifNotNil: [ ^self ].

	pixelExtent := (logicalExtent * sceneWindow deviceScalePoint) asIntegerPoint.

	dstFRect x: logicalPosition x * sceneWindow deviceScalePoint x.
	dstFRect y: logicalPosition y * sceneWindow deviceScalePoint y.
	dstFRect w: pixelExtent x.
	dstFRect h: pixelExtent y.
 
]

{ #category : #private }
SceneElement >> ensureReadyToRender [

	self ensureDeviceScaledProperties.

	tile
		ifNil: [
			tile := isAnimated
				ifTrue:  [ sceneWindow tileManager addAnimatedTileOf: pixelExtent ]
				ifFalse: [ sceneWindow tileManager addStaticTileOf: pixelExtent ].
			tile cairoContextToOverrideDo: renderBlock ]
		ifNotNil: [
			isAnimated ifTrue: [
				tile cairoContextToOverrideDo: renderBlock ] ].

]

{ #category : #accessing }
SceneElement >> extent [

	^ logicalExtent
]

{ #category : #accessing }
SceneElement >> extent: aLogicalPoint [

	logicalExtent := aLogicalPoint.
	self resetDeviceScaledProperties.

]

{ #category : #initialization }
SceneElement >> initialize [

	super initialize.
	
	isAnimated := false.

	logicalPosition := 0 asPoint.
	logicalExtent := 50 asPoint.

	stepBlock := [ :deltaMS :totalMS | ].
	renderBlock := [ :cairoContext | ].

	self opacity: 1.0.

	dstFRect := SDL_FRect new autoRelease; yourself.
	self resetDeviceScaledProperties.
]

{ #category : #accessing }
SceneElement >> isAnimated [

	^ isAnimated
]

{ #category : #accessing }
SceneElement >> isAnimated: aBoolean [

	isAnimated := aBoolean.
	tile := nil.
]

{ #category : #initialization }
SceneElement >> opacity: aFloat [
	"Set a value in the [0..1] interval."
	
	opacityAsByte := SDL2 map0_1FloatTo0_255Integer: aFloat 

]

{ #category : #initialization }
SceneElement >> opacityAsByte: aSmallInteger [
	"Set an integer value in the [0..255] interval."
	
	opacityAsByte := aSmallInteger
]

{ #category : #accessing }
SceneElement >> position [

	^ logicalPosition
]

{ #category : #accessing }
SceneElement >> position: aPoint [

	logicalPosition := aPoint.
	self resetDeviceScaledProperties.

]

{ #category : #public }
SceneElement >> render [

	tile renderTo: dstFRect opacity: opacityAsByte

]

{ #category : #accessing }
SceneElement >> renderBlock [

	^ renderBlock
]

{ #category : #accessing }
SceneElement >> renderBlock: aBlock [

	renderBlock := aBlock
]

{ #category : #private }
SceneElement >> resetDeviceScaledProperties [

	pixelExtent := nil
]

{ #category : #accessing }
SceneElement >> sceneWindow: aSceneWindow [

	sceneWindow := aSceneWindow
]

{ #category : #accessing }
SceneElement >> stepBlock [

	^ stepBlock
]

{ #category : #accessing }
SceneElement >> stepBlock: aBlock [

	stepBlock := aBlock
]
