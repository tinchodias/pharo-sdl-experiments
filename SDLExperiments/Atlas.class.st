Class {
	#name : #Atlas,
	#superclass : #Object,
	#instVars : [
		'sdlTexture',
		'pixelExtent',
		'packer',
		'sdlRenderer',
		'tiles',
		'deviceScalePoint'
	],
	#pools : [
		'SDL2Constants',
		'SDL2Types'
	],
	#category : #'SDLExperiments-Atlas'
}

{ #category : #'instance creation' }
Atlas class >> newWithRenderer: aSDLRenderer pixelExtent: aPoint [

	^ self basicNew
		initializeWithRenderer: aSDLRenderer pixelExtent: aPoint;
		yourself
]

{ #category : #'instance creation' }
Atlas >> addTileOf: aLogicalExtent [

	| aPixelExtent |
	aPixelExtent := aLogicalExtent * deviceScalePoint.

	packer
		allocateExtent: aPixelExtent
		ifSuccess: [ :aPixelPosition |
			| newTile |
			newTile :=
				Tile new
					atlas: self;
					srcRect: (SDL_Rect
						autoReleasingNewOrigin: aPixelPosition
						extent: aPixelExtent);
					yourself.

			tiles add: newTile.

			^ newTile ]
		ifFailure: [
			self notYetImplemented ].

	
]

{ #category : #accessing }
Atlas >> cairoContextToOverride: srcRect do: aBlock [
	
	| pitchAddress pixelsAddress aCairoSurface |
	pitchAddress := ExternalAddress newPointer.
	pixelsAddress := ExternalAddress newPointer.

	"Obtain a RAM buffer to draw on it (write-only)"
	sdlTexture
		lockRect: srcRect
		  pixels: pixelsAddress
		   pitch: pitchAddress.

	"Draw on the buffer"
	aCairoSurface := AeCairoImageSurface
		newForData: pixelsAddress
			 extent: srcRect extent
			 stride: (pitchAddress signedLongAt: 1)
			 format: AeCairoSurfaceFormat argb32.
	aCairoSurface deviceScale: deviceScalePoint.
	aBlock value: aCairoSurface newContext.

	"Flush to VRAM"
	aCairoSurface flush.
	sdlTexture unlock
]

{ #category : #'life cycle' }
Atlas >> createTexture [

	sdlTexture := 
		sdlRenderer
			createTextureFormat: SDL_PIXELFORMAT_ARGB8888
			access: SDL_TEXTUREACCESS_STREAMING
			width: pixelExtent x
			height: pixelExtent y.
	
	sdlTexture blendMode: SDL_BLENDMODE_BLEND.
]

{ #category : #'life cycle' }
Atlas >> destroyTexture [

	sdlTexture ifNil: [ ^self ].
	sdlTexture destroy
]

{ #category : #accessing }
Atlas >> deviceScalePoint: aPoint [

	deviceScalePoint := aPoint
]

{ #category : #initialization }
Atlas >> initializeWithRenderer: aSDLRenderer pixelExtent: aPoint [

	self initialize.

	sdlRenderer := aSDLRenderer.
	pixelExtent := aPoint.

	packer := SkylinePacker newWithExtent: aPoint.
	tiles := OrderedCollection new.
	deviceScalePoint := 1@1.
]

{ #category : #private }
Atlas >> renderTileAt: srcRect to: dstRect [

	sdlRenderer
		copy: sdlTexture
			srcRect: srcRect
			dstRectF: dstRect
]

{ #category : #debugging }
Atlas >> showAsBlSpace [

	| size aspect aSpace random scale |
	aspect := pixelExtent x / pixelExtent y.
	size := 500.
	scale := size / pixelExtent y.
	
	aSpace := BlSpace new.
	aSpace extent: (size * aspect) @ size.
	aSpace root background: Color paleYellow.
	aSpace root transformDo: [ :t |
		t topLeftOrigin; scaleBy: scale ].

	random := Random seed: 7.

	tiles do: [ :each |
		aSpace addChild: (BlElement new
			relocate: each srcRect origin;
			size: each srcRect extent;
			background: (Color random: random);
			yourself) ].
	
	aSpace show.
]
