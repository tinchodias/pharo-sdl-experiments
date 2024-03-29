Class {
	#name : #TextureTileManager,
	#superclass : #TileManager,
	#instVars : [
		'sceneWindow',
		'directTileClass',
		'tiles'
	],
	#category : #'SDLExperiments-Manager-Texture'
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

{ #category : #'tile creation' }
TextureTileManager >> addTileOf: aPixelExtent [

	| newTile |
	newTile := directTileClass
		newWithSDLRenderer: sceneWindow sdlRenderer
		pixelExtent: aPixelExtent
		deviceScalePoint: sceneWindow deviceScalePoint.
	newTile createTexture.

	tiles add: newTile.

	^ newTile
]

{ #category : #lifecycle }
TextureTileManager >> finalize [

	tiles do: [ :each | each destroyTexture ]
]

{ #category : #lifecycle }
TextureTileManager >> prepareOn: aSceneWindow [

	sceneWindow := aSceneWindow.
	
	tiles := OrderedCollection new.

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

{ #category : #initialization }
TextureTileManager >> useSDLPixelatedStaticTile [
	
	directTileClass := SDLPixelatedStaticTile
]

{ #category : #initialization }
TextureTileManager >> useSDLRenderGeometryStaticTile [
	
	directTileClass := SDLRenderGeometryStaticTile
]

{ #category : #initialization }
TextureTileManager >> useStaticTexture [
	
	directTileClass := StaticTextureTile
]

{ #category : #initialization }
TextureTileManager >> useStreamingTexture [
	
	directTileClass := StreamingTextureTile
]
