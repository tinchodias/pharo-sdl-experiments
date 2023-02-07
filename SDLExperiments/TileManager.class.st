Class {
	#name : #TileManager,
	#superclass : #Object,
	#category : #'SDLExperiments-Core'
}

{ #category : #'tile creation' }
TileManager >> addAnimatedTileOf: aPixelExtent [
	"Answer a Tile that is prepared to change frequently."

	^ self addStaticTileOf: aPixelExtent
]

{ #category : #'tile creation' }
TileManager >> addStaticTileOf: aPixelExtent [

	^ self subclassResponsibility
]

{ #category : #lifecycle }
TileManager >> finalize [

	self subclassResponsibility
]

{ #category : #lifecycle }
TileManager >> prepareOn: aSceneWindow [

	self subclassResponsibility
]

{ #category : #'rendering cycle' }
TileManager >> renderTilesWith: aBlock [
	"Prepare and finish rendering before and after executing aBlock (a frame is being rendered).
	The block may draw in Tiles and update textures."

	aBlock value

]
