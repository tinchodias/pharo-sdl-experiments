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
AtlasTileManager >> prepareOn: aSceneWindow [

	sceneWindow := aSceneWindow.

	atlas := sceneWindow
		newAtlasOf: sceneWindow sdlRenderer info maxTextureExtent.

	transientsTile := self staticTileOf: 1000 asPoint
]

{ #category : #'tile creation' }
AtlasTileManager >> staticTileOf: aPixelExtent [

"	atlases add: anAtlas."
"	anAtlas := atlases last."

	| aLogicalExtent |
	self flag: #todo. "Too messy"
	aLogicalExtent := aPixelExtent / sceneWindow deviceScalePoint.

	^ atlas
		addTileOf: aLogicalExtent
		ifNoSpaceDo: [
			self notYetImplemented ]
]

{ #category : #'tile creation' }
AtlasTileManager >> transientTileOf: aPixelExtent [
	"Answer a copy of my tile with same origin but adjusted extent."

	(aPixelExtent > transientsTile pixelBounds extent) ifTrue: [
		self notYetImplemented ].

	^ transientsTile copy
		pixelBounds: (transientsTile pixelBounds origin extent: aPixelExtent);
		yourself
]
