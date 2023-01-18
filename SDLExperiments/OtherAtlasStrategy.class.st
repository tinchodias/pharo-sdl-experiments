Class {
	#name : #OtherAtlasStrategy,
	#superclass : #AnimationTileStrategy,
	#instVars : [
		'soleTile'
	],
	#category : #'SDLExperiments-Core'
}

{ #category : #initialization }
OtherAtlasStrategy >> initializeOnOpenScene [

	sceneWindow newAtlasOf: 1000 asPoint.
	soleTile := sceneWindow addTileOf: 1000 asPoint.
]

{ #category : #'as yet unclassified' }
OtherAtlasStrategy >> tileOf: aPixelExtent [
	"Answer a tile with adjusted extent."

	^ soleTile
		bounds: (0@0 extent: aPixelExtent);
		yourself
]
