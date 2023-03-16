Class {
	#name : #TileManager,
	#superclass : #Object,
	#category : #'SDLExperiments-Core'
}

{ #category : #'tile creation' }
TileManager >> addTileOf: aPixelExtent [

	^ self subclassResponsibility
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
