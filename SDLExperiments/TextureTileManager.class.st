Class {
	#name : #TextureTileManager,
	#superclass : #TileManager,
	#instVars : [
		'transientTilePixelExtent',
		'staticTiles',
		'sceneWindow',
		'directTileClass',
		'sharedTextureTile'
	],
	#category : #'SDLExperiments-Texture'
}

{ #category : #'instance creation' }
TextureTileManager class >> newStatic [

	^ self new
		  useStaticTexture;
		  yourself
]

{ #category : #'instance creation' }
TextureTileManager class >> newStreaming [

	^ self new
		  useStreamingTexture;
		  yourself
]

{ #category : #lifecycle }
TextureTileManager >> finalize [

	sharedTextureTile destroyTexture.
	staticTiles do: [ :each | each destroyTexture ].
]

{ #category : #lifecycle }
TextureTileManager >> prepareOn: aSceneWindow [

	| aLogicalExtent |
	sceneWindow := aSceneWindow.
	
	aLogicalExtent := 1000 asPoint.
	transientTilePixelExtent := aLogicalExtent * sceneWindow deviceScalePoint.

	staticTiles := OrderedCollection new.

	sharedTextureTile := StreamingTextureTile
		newWithSDLRenderer: sceneWindow sdlRenderer
		pixelExtent: transientTilePixelExtent
		deviceScalePoint: sceneWindow deviceScalePoint.
	sharedTextureTile createTexture.
	

]

{ #category : #printing }
TextureTileManager >> printOn: aStream [
	"Generate a string representation of the receiver based on its instance variables."

	super printOn: aStream.
	aStream
		nextPut: $(;
		print: directTileClass;
		nextPut: $)
]

{ #category : #'tile creation' }
TextureTileManager >> staticTileOf: aPixelExtent [

	| newTile |
	newTile := directTileClass
		newWithSDLRenderer: sceneWindow sdlRenderer
		pixelExtent: aPixelExtent
		deviceScalePoint: sceneWindow deviceScalePoint.
	newTile createTexture.

	staticTiles add: newTile.

	^ newTile
]

{ #category : #'tile creation' }
TextureTileManager >> transientTileOf: aPixelExtent [
	"Answer a tile with adjusted extent."

	aPixelExtent > transientTilePixelExtent ifTrue: [
		self notYetImplemented ].

	^ sharedTextureTile
		pixelExtent: aPixelExtent;
		yourself
]

{ #category : #initialization }
TextureTileManager >> useStaticTexture [
	
	directTileClass := StaticTextureTile
]

{ #category : #initialization }
TextureTileManager >> useStreamingTexture [
	
	directTileClass := StreamingTextureTile
]
