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
		'logicalPosition'
	],
	#category : #'SDLExperiments-Demo-Scene'
}

{ #category : #private }
SceneElement >> ensureUpdatedTile [

	tile
		ifNil: [
			| aPixelExtent |
			aPixelExtent := logicalExtent * sceneWindow deviceScalePoint.
			tile := isAnimated
				ifTrue:  [ sceneWindow tileManager addAnimatedTileOf: aPixelExtent ]
				ifFalse: [ sceneWindow tileManager addStaticTileOf: aPixelExtent ].
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
	self sdlDstFRectReset.

]

{ #category : #initialization }
SceneElement >> initialize [

	super initialize.
	
	isAnimated := false.
	logicalPosition := 0 asPoint.
	logicalExtent := 50 asPoint.
	stepBlock := [ :deltaMS :totalMS | ].

	dstFRect := SDL_FRect new autoRelease; yourself.
	self sdlDstFRectReset.
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

{ #category : #accessing }
SceneElement >> position [

	^ logicalPosition
]

{ #category : #accessing }
SceneElement >> position: aPoint [

	logicalPosition := aPoint.
	self sdlDstFRectReset.

]

{ #category : #public }
SceneElement >> render [

	self sdlDstFRectEnsure.
	self ensureUpdatedTile.
	tile renderTo: dstFRect

]

{ #category : #accessing }
SceneElement >> renderBlock: aBlock [

	renderBlock := aBlock
]

{ #category : #accessing }
SceneElement >> sceneWindow: aSceneWindow [

	sceneWindow := aSceneWindow
]

{ #category : #accessing }
SceneElement >> sdlDstFRectEnsure [

	dstFRect w = 0.0 ifFalse: [ ^self ].
	dstFRect x: logicalPosition x * sceneWindow deviceScalePoint x.
	dstFRect y: logicalPosition y * sceneWindow deviceScalePoint y.
	dstFRect w: logicalExtent x * sceneWindow deviceScalePoint x.
	dstFRect h: logicalExtent y * sceneWindow deviceScalePoint y.
 
]

{ #category : #accessing }
SceneElement >> sdlDstFRectReset [

	dstFRect w: 0.0
]

{ #category : #accessing }
SceneElement >> stepBlock [

	^ stepBlock
]

{ #category : #accessing }
SceneElement >> stepBlock: aBlock [

	stepBlock := aBlock
]
