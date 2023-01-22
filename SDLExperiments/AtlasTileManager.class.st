Class {
	#name : #AtlasTileManager,
	#superclass : #TileManager,
	#instVars : [
		'transientsTile'
	],
	#category : #'SDLExperiments-Core'
}

{ #category : #initializaiton }
AtlasTileManager >> initializeOnOpenScene [

	transientsTile := sceneWindow addTileOf: 1000 asPoint
]

{ #category : #'as yet unclassified' }
AtlasTileManager >> tileOf: aPixelExtent [
	"Answer a copy of my tile with same origin but adjusted extent."

	Halt if: [ aPixelExtent > transientsTile pixelBounds extent ].

	^ transientsTile copy
		pixelBounds: (transientsTile pixelBounds origin extent: aPixelExtent);
		yourself
]
