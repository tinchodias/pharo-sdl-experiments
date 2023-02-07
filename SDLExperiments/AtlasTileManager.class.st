Class {
	#name : #AtlasTileManager,
	#superclass : #TileManager,
	#instVars : [
		'transientsTile',
		'atlas',
		'sceneWindow'
	],
	#category : #'SDLExperiments-Atlas'
}

{ #category : #'tile creation' }
AtlasTileManager >> addStaticTileOf: aPixelExtent [

	^ atlas
		addTileOf: aPixelExtent
		ifNoSpaceDo: [
			self notYetImplemented ]
]

{ #category : #lifecycle }
AtlasTileManager >> finalize [

	atlas destroyTexture
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

	atlas := self newAtlasOf: sceneWindow sdlRenderer info maxTextureExtent

]

{ #category : #printing }
AtlasTileManager >> printOn: aStream [
	"Generate a string representation of the receiver based on its instance variables."

	super printOn: aStream.
	aStream
		nextPut: $(;
		print: atlas;
		nextPut: $)
]
