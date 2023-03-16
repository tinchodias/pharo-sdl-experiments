"
I provide a kind of tiles that redraw every time using Cairo.

"
Class {
	#name : #CairoDirectTileManager,
	#superclass : #TileManager,
	#instVars : [
		'sceneWindow',
		'wholeWindowTile'
	],
	#category : #'SDLExperiments-Manager-Cairo'
}

{ #category : #'tile creation' }
CairoDirectTileManager >> addTileOf: aPixelExtent [

	^ CairoLazyTile new
		cairoContext: wholeWindowTile cairoContext;
		deviceScalePoint: sceneWindow deviceScalePoint;
		yourself
]

{ #category : #lifecycle }
CairoDirectTileManager >> finalize [

	wholeWindowTile destroyTexture
]

{ #category : #lifecycle }
CairoDirectTileManager >> prepareOn: aSceneWindow [

	| aPixelExtent |
	sceneWindow := aSceneWindow.
	aPixelExtent := (sceneWindow logicalExtent * sceneWindow deviceScalePoint) asIntegerPoint.

	wholeWindowTile := WholeWindowTile
		newWithSDLRenderer: sceneWindow sdlRenderer
		pixelExtent: aPixelExtent
		deviceScalePoint: sceneWindow deviceScalePoint.
	wholeWindowTile createTexture.

]

{ #category : #'rendering cycle' }
CairoDirectTileManager >> renderTilesWith: aBlock [

	wholeWindowTile renderWith: aBlock

]
