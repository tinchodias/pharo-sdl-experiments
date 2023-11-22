"
I'm a texture tile that uses `SDL_RenderGeometry()` to copy the texture into the renderer target.

Accidentally, I also use a static-access SDL texture, but that's not the point of myself.
"
Class {
	#name : #SDLRenderGeometryStaticTile,
	#superclass : #StaticTextureTile,
	#instVars : [
		'verticesExternalArray',
		'topLeftPosition',
		'bottomLeftPosition',
		'topRightPosition',
		'indicesExternalArray',
		'bottomRightPosition'
	],
	#category : #'SDLExperiments-Manager-Texture'
}

{ #category : #finalization }
SDLRenderGeometryStaticTile >> destroyTexture [

	super destroyTexture.
	verticesExternalArray free.
	indicesExternalArray free.
]

{ #category : #initialization }
SDLRenderGeometryStaticTile >> initialize [

	super initialize.

	verticesExternalArray := FFIExternalArray externalNewType: SDL_Vertex size: 4.

	topLeftPosition := verticesExternalArray first position.
	verticesExternalArray first texCoord updateFrom: 0@0.

	topRightPosition := verticesExternalArray second position.
	verticesExternalArray second texCoord updateFrom: 1@0.

	bottomRightPosition := verticesExternalArray third position.
	verticesExternalArray third texCoord updateFrom: 1@1.

	bottomLeftPosition := verticesExternalArray fourth position.
	verticesExternalArray fourth texCoord updateFrom: 0@1.

	verticesExternalArray do: [ :each | each color updateFrom: Color white ].

	indicesExternalArray := FFIExternalArray externalNewType: FFIInt32 size: 6.
	indicesExternalArray at: 1 put: 0.
	indicesExternalArray at: 2 put: 1.
	indicesExternalArray at: 3 put: 2.
	indicesExternalArray at: 4 put: 2.
	indicesExternalArray at: 5 put: 3.
	indicesExternalArray at: 6 put: 0

]

{ #category : #rendering }
SDLRenderGeometryStaticTile >> prepareToRenderTo: aSDLFRect [

	| top left right bottom |
	left := aSDLFRect x.
	top := aSDLFRect y.
	right := left + aSDLFRect w.
	bottom := top + aSDLFRect h.

	topLeftPosition x: left.
	topLeftPosition y: top.
	topRightPosition x: right.
	topRightPosition y: top.
	bottomRightPosition x: right.
	bottomRightPosition y: bottom.
	bottomLeftPosition x: left.
	bottomLeftPosition y: bottom
]

{ #category : #rendering }
SDLRenderGeometryStaticTile >> prepareToRenderWithOpacity: alphaByte [

	verticesExternalArray do: [ :each |
		each color
			r: alphaByte;
			g: alphaByte;
			b: alphaByte;
			a: alphaByte ]
]

{ #category : #rendering }
SDLRenderGeometryStaticTile >> renderTo: aSDLFRect opacity: alphaByte [

	self prepareToRenderTo: aSDLFRect.
	self prepareToRenderWithOpacity: alphaByte.

	sdlRenderer
		renderGeometryVertices: verticesExternalArray
		numVertices: verticesExternalArray size
		indices: indicesExternalArray
		numIndices: indicesExternalArray size
		texture: sdlTexture
]
