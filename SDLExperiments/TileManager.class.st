Class {
	#name : #TileManager,
	#superclass : #Object,
	#category : #'SDLExperiments-Core'
}

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

{ #category : #'tile creation' }
TileManager >> staticTileOf: aPixelExtent [

	^ self subclassResponsibility
]

{ #category : #'tile creation' }
TileManager >> transientTileOf: aPixelExtent [

	^ self subclassResponsibility
]
