Class {
	#name : 'SDL2Test',
	#superclass : 'TestCase',
	#instVars : [
		'sdlWindow',
		'windowPosition',
		'windowExtent'
	],
	#pools : [
		'SDL2Constants',
		'SDL2Types'
	],
	#category : 'SDLExperiments-Tests',
	#package : 'SDLExperiments-Tests'
}

{ #category : 'running' }
SDL2Test >> setUp [

	super setUp.

	OSSDL2Driver current. "Ensure SDL2 is initialized"
	
	windowPosition := 200 @ 300.
	windowExtent := 400 @ 500.
	sdlWindow :=
		SDL2 createWindow: 'Test'
			x: windowPosition x
			y: windowPosition y
			width: windowExtent x
			height: windowExtent y
			flags: SDL_WINDOW_HIDDEN
]

{ #category : 'running' }
SDL2Test >> tearDown [

	sdlWindow destroy.

	super tearDown
]

{ #category : 'tests' }
SDL2Test >> testCurrentDisplayMode [

	| mode |
	mode := sdlWindow currentDisplayMode.

	self assert: mode refreshRate isInteger.
	self assert: mode extent isPoint.
	self assert: mode w isInteger.
	self assert: mode h isInteger
]

{ #category : 'tests' }
SDL2Test >> testDisplayMode [

	| mode |
	mode := sdlWindow displayMode.
	
	self assert: mode refreshRate isInteger.
	self assert: mode extent isPoint.
	self assert: mode w isInteger.
	self assert: mode h isInteger
]

{ #category : 'tests' }
SDL2Test >> testExtent [

	self assert: sdlWindow extent equals: windowExtent.
	sdlWindow extent: 500 @ 600.
	self assert: sdlWindow extent equals: 500 @ 600
]

{ #category : 'tests' }
SDL2Test >> testFromByteToFloat [

	self assert: (SDL2 fromByteToFloat: 1) closeTo: 1/255.0.
	self assert: (SDL2 fromByteToFloat: 255) closeTo: 1.
	self assert: (SDL2 fromByteToFloat: -1) closeTo: 0.
	self assert: (SDL2 fromByteToFloat: 256) closeTo: 1.
]

{ #category : 'tests' }
SDL2Test >> testFromFloatToByte [

	self assert: (SDL2 fromFloatToByte: 1.0/255.0) equals: 1.
	self assert: (SDL2 fromFloatToByte: 0.999) equals: 255.
	self assert: (SDL2 fromFloatToByte: 0.99)  equals: 252.
	self assert: (SDL2 fromFloatToByte: -0.5) equals: 0.
	self assert: (SDL2 fromFloatToByte:  1.5) equals: 255.
]

{ #category : 'tests' }
SDL2Test >> testPosition [

	sdlWindow position: 200@300.
	self assert: sdlWindow position equals: 200@300.
]

{ #category : 'tests' }
SDL2Test >> testRect [

	| sdlRect aRectangle |
	sdlRect :=
		SDL_Rect
			newX: 1
			y: 2
			w: 3
			h: 4.
	
	aRectangle := sdlRect asRectangle.
	self assert: aRectangle origin equals: 1@2.
	self assert: aRectangle extent equals: 3@4
]

{ #category : 'tests' }
SDL2Test >> testRenderDriverInfos [

	| infos |
	infos := SDL2 renderDriverInfos.
	
	self deny: infos isEmpty.
	
	self assert: infos first nameString isString.
	self assert: infos first maxTextureExtent isPoint
]

{ #category : 'tests' }
SDL2Test >> testRendererAndVSync [
	"Smoke test"

	| sdlRenderer |
	sdlRenderer := sdlWindow createAcceleratedRenderer.
	sdlRenderer enableVSync.
	sdlRenderer disableVSync.
	sdlRenderer destroy.

	sdlRenderer := sdlWindow createSoftwareRenderer.
	sdlRenderer enableVSync.
	sdlRenderer disableVSync.
	sdlRenderer destroy
]

{ #category : 'tests' }
SDL2Test >> testTicks [

	| t1 t2 |
	t1 := SDL2 ticks.
	5 milliSeconds wait.
	t2 := SDL2 ticks.

	self assert: t1 < t2
]

{ #category : 'tests' }
SDL2Test >> testTicks64 [

	| t1 t2 |
	t1 := SDL2 ticks64.
	5 milliSeconds wait.
	t2 := SDL2 ticks64.

	self assert: t1 < t2
]
