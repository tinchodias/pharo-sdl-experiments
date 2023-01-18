Class {
	#name : #SameAtlasStrategy,
	#superclass : #AnimationTileStrategy,
	#instVars : [
		'transientsTile'
	],
	#category : #'SDLExperiments-Core'
}

{ #category : #initializaiton }
SameAtlasStrategy >> initializeOnOpenScene [

	transientsTile := sceneWindow addTileOf: 1000 asPoint
]

{ #category : #'as yet unclassified' }
SameAtlasStrategy >> tileOf: aPixelExtent [
	"Answer a copy of my tile with same origin but adjusted extent."

	Halt if: [ aPixelExtent > transientsTile bounds extent ].

	^ transientsTile copy
		bounds: (transientsTile bounds origin extent: aPixelExtent);
		yourself
]
