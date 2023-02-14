"
An AtlasTest is a test class for testing the behavior of Atlas
"
Class {
	#name : #AtlasTest,
	#superclass : #TestCase,
	#instVars : [
		'windowExtent',
		'sdlWindow',
		'sdlRenderer'
	],
	#pools : [
		'SDL2Constants',
		'SDL2Types'
	],
	#category : #'SDLExperiments-Tests'
}

{ #category : #running }
AtlasTest >> setUp [
	super setUp.
	
	windowExtent := 200 @ 100.
	sdlWindow := SDL2 createWindow: 'Test'
					x: SDL_WINDOWPOS_CENTERED
					y: SDL_WINDOWPOS_CENTERED
					width: windowExtent x
					height: windowExtent y
					flags: SDL_WINDOW_HIDDEN.
	sdlRenderer := sdlWindow createAcceleratedRenderer.


]

{ #category : #running }
AtlasTest >> tearDown [

	sdlRenderer destroy.
	sdlWindow destroy.

	super tearDown.
]

{ #category : #tests }
AtlasTest >> testAddMultipleTiles [

	| anAtlas result allocatedTiles |
	anAtlas := Atlas
		newWithRenderer: sdlRenderer
		pixelExtent: 1800 @ 900.
	anAtlas createTexture.

	"Allocate several tiles"
	allocatedTiles := OrderedCollection new.
	9 timesRepeat: [
		result := nil.
		anAtlas
			addTileOf: 600 @ 300 "(a third part)"
			ifSuccess: [ :aTile |
				result := #success.
				allocatedTiles add: aTile ]
			ifFailure: [ result := #failure ].
		self assert: result equals: #success ].

	"There is no more space"
	result := nil.
	anAtlas
		addTileOf: 3 @ 3
		ifSuccess: [ :aTile |
			result := #success ]
		ifFailure: [ result := #failure ].
	self assert: result equals: #failure.

]

{ #category : #tests }
AtlasTest >> testHiDPIDevice [

	| anAtlas aTile aDeviceScale |
	anAtlas := Atlas
		newWithRenderer: sdlRenderer
		pixelExtent: 100 asPoint.
	anAtlas createTexture.

	"Emulate HiDPI with 2x device scale"
	anAtlas deviceScalePoint: 2.0 asPoint.

	aTile := anAtlas
		addTileOf: 100 asPoint
		ifFailure: [ self fail ].

	aTile cairoContextToOverrideDo: [ :aCairoContext |
		aDeviceScale := aCairoContext surface deviceScale ].
	
	self assert: aDeviceScale equals: 2.0 asPoint
]

{ #category : #tests }
AtlasTest >> testRender [

	| anAtlas aTile tileExtent renderedForm |
	anAtlas := Atlas
		newWithRenderer: sdlRenderer
		pixelExtent: windowExtent.
	anAtlas createTexture.

	"Create a simple tile, that looks like a thin and tall column"
	tileExtent := 2 @ windowExtent y.
	aTile := anAtlas
		addTileOf: tileExtent
		ifFailure: [ self fail ].
	aTile cairoContextToOverrideDo: [ :aCairoContext |
		aCairoContext
			sourceColorRGB: Color blue;
			paint;
			sourceColorRGB: Color red;
			moveToX: 2 y: 0;
			lineToX: 2 y: tileExtent y;
			lineWidth: 2;
			stroke ].

	"Render the frame"	
	sdlRenderer clear.
	(0 to: windowExtent x - 1 by: tileExtent x) do: [ :each |
		aTile renderTo: (SDL_FRect
			autoReleasingNewOrigin: each @ 0
			extent: tileExtent) ].

	"Check it's as expected"
	renderedForm := sdlRenderer asFormARGB32.
	(0 to: windowExtent x - 1 by: tileExtent x) do: [ :each |
		self assert: (renderedForm colorAt: each  @ 0) equals: Color blue.
		self assert: (renderedForm colorAt: each+1 @0) equals: Color red ]

]
