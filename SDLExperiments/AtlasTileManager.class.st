Class {
	#name : #AtlasTileManager,
	#superclass : #TileManager,
	#instVars : [
		'transientsTile',
		'sceneWindow',
		'atlasPixelExtent',
		'atlases'
	],
	#category : #'SDLExperiments-Manager-Atlas'
}

{ #category : #'tile creation' }
AtlasTileManager >> addStaticTileOf: aPixelExtent [

	| newAtlas |
	atlases do: [ :eachAtlas |
		eachAtlas
			addTileOf: aPixelExtent
			ifSuccess: [ :aTile | ^ aTile ]
			ifFailure: [  ] ].
	
	newAtlas := self newAtlasOf: self atlasPixelExtent.
	atlases add: newAtlas.
	newAtlas
		addTileOf: aPixelExtent
		ifSuccess: [ :aTile | ^ aTile ]
		ifFailure: [ self notYetImplemented ]
]

{ #category : #accessing }
AtlasTileManager >> atlasPixelExtent [

	^ atlasPixelExtent ifNil: [ atlasPixelExtent := sceneWindow sdlRenderer info maxTextureExtent ]
]

{ #category : #accessing }
AtlasTileManager >> atlasPixelExtent: aPoint [

	atlasPixelExtent := aPoint
]

{ #category : #lifecycle }
AtlasTileManager >> finalize [

	atlases do: #destroyTexture
]

{ #category : #lifecycle }
AtlasTileManager >> newAtlasOf: aPixelExtent [
	
	| newAtlas |
	newAtlas := Atlas
		newWithRenderer: sceneWindow sdlRenderer
		pixelExtent: aPixelExtent.
	newAtlas createTexture.
	newAtlas deviceScalePoint: sceneWindow deviceScalePoint.
	^ newAtlas

]

{ #category : #lifecycle }
AtlasTileManager >> prepareOn: aSceneWindow [

	sceneWindow := aSceneWindow.

	atlases := OrderedCollection new
]

{ #category : #printing }
AtlasTileManager >> printOn: aStream [
	"Generate a string representation of the receiver based on its instance variables."

	super printOn: aStream.
	
	sceneWindow ifNotNil: [
		aStream print: self atlasPixelExtent]
]
