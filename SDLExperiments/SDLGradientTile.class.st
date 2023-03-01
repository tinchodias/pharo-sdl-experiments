Class {
	#name : #SDLGradientTile,
	#superclass : #Tile,
	#instVars : [
		'sdlRenderer',
		'verticesExternalArray',
		'topLeftPosition',
		'bottomLeftPosition',
		'topRightPosition',
		'indicesExternalArray',
		'bottomRightPosition',
		'color'
	],
	#category : #'SDLExperiments-ColorFlood'
}

{ #category : #enumerating }
SDLGradientTile >> cairoContextToOverrideDo: aBlock [
	"Nothing to do"
]

{ #category : #rendering }
SDLGradientTile >> color: aColor [

	color := aColor.
	verticesExternalArray do: [ :each | each color updateFrom: color ]
]

{ #category : #finalization }
SDLGradientTile >> finalize [

	verticesExternalArray free.
	indicesExternalArray free.
]

{ #category : #initialization }
SDLGradientTile >> initialize [

	super initialize.

	verticesExternalArray := FFIExternalArray externalNewType: SDL_Vertex size: 4.
	topLeftPosition := verticesExternalArray first position.
	topRightPosition := verticesExternalArray second position.
	bottomRightPosition := verticesExternalArray third position.
	bottomLeftPosition := verticesExternalArray fourth position.

	indicesExternalArray := FFIExternalArray externalNewType: 'int' size: 6.
	indicesExternalArray at: 1 put: 0.
	indicesExternalArray at: 2 put: 1.
	indicesExternalArray at: 3 put: 2.
	indicesExternalArray at: 4 put: 2.
	indicesExternalArray at: 5 put: 3.
	indicesExternalArray at: 6 put: 0
]

{ #category : #rendering }
SDLGradientTile >> prepareToRenderTo: aSDLFRect [

	| dstRectangle |
	dstRectangle := aSDLFRect asRectangle.

	topLeftPosition x: dstRectangle left.
	topLeftPosition y: dstRectangle top.
	topRightPosition x: dstRectangle right.
	topRightPosition y: dstRectangle top.
	bottomRightPosition x: dstRectangle right.
	bottomRightPosition y: dstRectangle bottom.
	bottomLeftPosition x: dstRectangle left.
	bottomLeftPosition y: dstRectangle bottom
]

{ #category : #rendering }
SDLGradientTile >> prepareToRenderWithOpacity: alphaByte [

	| alphaFloat |
	alphaFloat := SDL2 map0_255IntegerTo0_1Float: alphaByte.

	verticesExternalArray do: [ :each |
		each color a: (SDL2 map0_1FloatTo0_255Integer: color alpha * alphaFloat) ]
]

{ #category : #rendering }
SDLGradientTile >> renderTo: aSDLFRect opacity: alphaByte [

	self prepareToRenderTo: aSDLFRect.
	self prepareToRenderWithOpacity: alphaByte.

	sdlRenderer
		renderGeometryVertices: verticesExternalArray
		numVertices: verticesExternalArray size
		indices: indicesExternalArray
		numIndices: indicesExternalArray size
		texture: ExternalAddress null.

]

{ #category : #accessing }
SDLGradientTile >> sdlRenderer: aSDLRenderer [

	sdlRenderer := aSDLRenderer
]
