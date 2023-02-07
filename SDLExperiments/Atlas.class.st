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
Atlas >> addTileOf: aPixelExtent ifNoSpaceDo: noSpaceBlock [

	packer
		allocateExtent: aPixelExtent
		ifSuccess: [ :aPixelPosition |
			| newTile |
			newTile :=
				AtlasTile
					newFor: self
					pixelBounds: (aPixelPosition extent: aPixelExtent).

			tiles add: newTile.

			^ newTile ]
		ifFailure: [
			^ noSpaceBlock value ].

	
]

{ #category : #accessing }
Atlas >> cairoContextToOverride: srcRect do: aBlock [
	
	| pitchAddress pixelsAddress aCairoSurface aCairoContext |
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

	aCairoContext := aCairoSurface newContext.
	aCairoContext clearTransparent.
	aBlock value: aCairoContext.
	aCairoSurface flush.

	sdlTexture unlock "Flush to VRAM"
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

{ #category : #accessing }
Atlas >> pixelExtent [
	^ pixelExtent
]

{ #category : #printing }
Atlas >> printOn: aStream [
	"Generate a string representation of the receiver based on its instance variables."

	super printOn: aStream.
	aStream
		nextPutAll: ' pixelExtent: ';
		print: pixelExtent.
	aStream
		nextPutAll: ' tiles: ';
		print: tiles size.

]

{ #category : #private }
Atlas >> renderTileAt: srcRect to: aSDLFRect [

	sdlRenderer
		copy: sdlTexture
			srcRect: srcRect
			dstRectF: aSDLFRect
]
