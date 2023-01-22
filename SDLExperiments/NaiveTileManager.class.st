Class {
	#name : #NaiveTileManager,
	#superclass : #TileManager,
	#instVars : [
		'soleTile',
		'atlas'
	],
	#category : #'SDLExperiments-Core'
}

{ #category : #initialization }
NaiveTileManager >> initializeOnOpenScene [

	| aLogicalExtent aPixelExtent |
	aLogicalExtent := 1000 asPoint.
	aPixelExtent := aLogicalExtent * sceneWindow deviceScalePoint.

	atlas := sceneWindow newAtlasOf: aPixelExtent.
	soleTile := 
		atlas
			addTileOf: aLogicalExtent
			ifNoSpaceDo: [ self error: 'cant happen' ]
]

{ #category : #'as yet unclassified' }
NaiveTileManager >> tileOf: aPixelExtent [
	"Answer a tile with adjusted extent."

	Halt if: [ aPixelExtent > atlas pixelExtent ].

	^ soleTile
		pixelBounds: (0@0 extent: aPixelExtent);
		yourself
]
