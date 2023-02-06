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

{ #category : #'tile creation' }
AtlasTileManager >> staticTileOf: aPixelExtent [

	| aLogicalExtent |
	self flag: #todo. "Too messy"
	aLogicalExtent := aPixelExtent / sceneWindow deviceScalePoint.

	^ atlas
		addTileOf: aLogicalExtent
		ifNoSpaceDo: [
			self notYetImplemented ]
]
