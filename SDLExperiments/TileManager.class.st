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

{ #category : #'tile creation' }
TileManager >> staticTileOf: aPixelExtent [

	^ self subclassResponsibility
]

{ #category : #'tile creation' }
TileManager >> transientTileOf: aPixelExtent [

	^ self subclassResponsibility
]
