Class {
	#name : #TextureTile,
	#superclass : #Tile,
	#instVars : [
		'sdlRenderer',
		'sdlTexture',
		'deviceScalePoint',
		'pixelExtent',
		'srcRect'
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
	srcRect := SDL_Rect autoReleasingNewOrigin: 0@0 extent: aPoint.

]

{ #category : #accessing }
TextureTile >> pixelExtent [

	^ pixelExtent
]

{ #category : #initialization }
TextureTile >> pixelExtent: aPoint [
	
	pixelExtent := aPoint.
	srcRect extent: aPoint
]

{ #category : #rendering }
TextureTile >> renderTo: aSDLFRect [

	sdlRenderer
		copy: sdlTexture
			srcRect: srcRect
			dstRectF: aSDLFRect
]
