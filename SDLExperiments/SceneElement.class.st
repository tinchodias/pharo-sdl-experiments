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
		'extent',
		'position',
		'tile',
		'isAnimated',
		'dstFRect'
	],
	#category : #'SDLExperiments-Core'
}

{ #category : #private }
SceneElement >> ensureUpdatedTile [

	tile
		ifNil: [
			tile := isAnimated
				ifTrue:  [ sceneWindow transientTileOf: extent ]
				ifFalse: [ sceneWindow addTileOf: extent ].
			tile cairoContextToOverrideDo: renderBlock ]
		ifNotNil: [
			isAnimated ifTrue: [
				tile cairoContextToOverrideDo: renderBlock ] ].

]

{ #category : #accessing }
SceneElement >> extent [

	^ extent
]

{ #category : #accessing }
SceneElement >> extent: aLogicalPoint [

	extent := aLogicalPoint.
	self sdlDstRectReset.

]

{ #category : #initialization }
SceneElement >> initialize [

	super initialize.
	
	isAnimated := false.
	position := 0 asPoint.
	extent := 50 asPoint.
	stepBlock := [ :deltaMS :totalMS | ].

	dstFRect := SDL_FRect new autoRelease; yourself.
	self sdlDstRectReset.
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

	^ position
]

{ #category : #accessing }
SceneElement >> position: aPoint [

	position := aPoint.
	self sdlDstRectReset.

]

{ #category : #public }
SceneElement >> render [

	self sdlDstRectEnsure.
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
SceneElement >> sdlDstRectEnsure [

	dstFRect w = 0.0 ifFalse: [ ^self ].
	dstFRect x: position x * sceneWindow deviceScalePoint x.
	dstFRect y: position y * sceneWindow deviceScalePoint y.
	dstFRect w: extent x * sceneWindow deviceScalePoint x.
	dstFRect h: extent y * sceneWindow deviceScalePoint y.
 
]

{ #category : #accessing }
SceneElement >> sdlDstRectReset [

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
