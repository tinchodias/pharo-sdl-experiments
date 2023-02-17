Class {
	#name : #TextureTile,
	#superclass : #Tile,
	#instVars : [
		'sdlRenderer',
		'sdlTexture',
		'deviceScalePoint',
		'pixelExtent',
		'srcRect',
		'sdlTextureOpacity'
	],
	#pools : [
		'SDL2Constants',
		'SDL2Types'
	],
	#category : #'SDLExperiments-Manager-Texture'
}

{ #category : #'instance creation' }
TextureTile class >> newWithSDLRenderer: aRenderer pixelExtent: aPoint deviceScalePoint: anotherPoint [

	^ self basicNew
		  initializeSDLRenderer: aRenderer
		  pixelExtent: aPoint
		  deviceScalePoint: anotherPoint;
		  yourself
]

{ #category : #'life cycle' }
TextureTile >> destroyTexture [

	sdlTexture ifNil: [ ^self ].
	sdlTexture destroy
]

{ #category : #initialization }
TextureTile >> initializeSDLRenderer: aRenderer pixelExtent: aPoint deviceScalePoint: anotherPoint [

	self initialize.
	sdlRenderer := aRenderer.
	deviceScalePoint := anotherPoint.
	
	pixelExtent := aPoint.
	srcRect := SDL_Rect autoReleasingNewOrigin: 0@0 extent: aPoint

]

{ #category : #rendering }
TextureTile >> renderTo: aSDLFRect opacity: alphaByte [

	"Can save a lot of time, e.g. in opengl"
	sdlTextureOpacity = alphaByte ifFalse: [
		sdlTextureOpacity := alphaByte.
		sdlTexture
			colorModR: alphaByte
				g: alphaByte
				b: alphaByte;
			alphaMod: alphaByte ].
		
	sdlRenderer
		copy: sdlTexture
			srcRect: srcRect
			dstRectF: aSDLFRect
]
