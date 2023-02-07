"
I provide a kind of tiles that redraw every time using Cairo.

"
Class {
	#name : #CairoDirectTileManager,
	#superclass : #TileManager,
	#instVars : [
		'sceneWindow',
		'mainTile',
		'sceneWindowFRect'
	],
	#category : #SDLExperiments
}

{ #category : #'tile creation' }
CairoDirectTileManager >> addStaticTileOf: aPixelExtent [

	^ self newLazyTile
]

{ #category : #lifecycle }
CairoDirectTileManager >> finalize [

	mainTile destroyTexture
]

{ #category : #'tile creation' }
CairoDirectTileManager >> newLazyTile [

	^ CairoLazyTile new
		cairoContext: mainTile cairoContext;
		deviceScalePoint: sceneWindow deviceScalePoint;
		yourself
]

{ #category : #lifecycle }
CairoDirectTileManager >> prepareOn: aSceneWindow [

	| aPixelExtent |
	sceneWindow := aSceneWindow.
	
	aPixelExtent := sceneWindow logicalExtent * sceneWindow deviceScalePoint.

	mainTile := StaticTextureTile
		newWithSDLRenderer: sceneWindow sdlRenderer
		pixelExtent: aPixelExtent
		deviceScalePoint: sceneWindow deviceScalePoint.
	mainTile createTexture.
	
	sceneWindowFRect := SDL_FRect
		autoReleasingNewOrigin: 0.0 @ 0.0
		extent: aPixelExtent.

]

{ #category : #'rendering cycle' }
CairoDirectTileManager >> renderTilesWith: aBlock [

	mainTile cairoContextToOverrideDo: [ :_ |
		aBlock value.
		mainTile renderTo: sceneWindowFRect ]
]
