"
I'm polymorphic with `Tile` but don't have an associated `Atlas`.
"
Class {
	#name : #StreamingTextureTile,
	#superclass : #TextureTile,
	#category : #'SDLExperiments-Texture'
}

{ #category : #enumerating }
StreamingTextureTile >> cairoContextToOverrideDo: aBlock [

	| pitchAddress pixelsAddress aCairoSurface |
	pitchAddress := ExternalAddress newPointer.
	pixelsAddress := ExternalAddress newPointer.

	"Obtain a RAM buffer to draw on it (write-only)"
	sdlTexture
		lockRect: SDL_Rect null
		  pixels: pixelsAddress
		   pitch: pitchAddress.

	"Draw on the buffer"
	aCairoSurface := AeCairoImageSurface
		newForData: pixelsAddress
			 extent: pixelExtent
			 stride: (pitchAddress signedLongAt: 1)
			 format: AeCairoSurfaceFormat argb32.
	aCairoSurface deviceScale: deviceScalePoint.
	aBlock value: aCairoSurface newContext.

	"Flush to VRAM"
	aCairoSurface flush.
	sdlTexture unlock
]

{ #category : #'life cycle' }
StreamingTextureTile >> createTexture [

	sdlTexture := 
		sdlRenderer
			createTextureFormat: SDL_PIXELFORMAT_ARGB8888
			access: SDL_TEXTUREACCESS_STREAMING
			width: pixelExtent x
			height: pixelExtent y.
	
	sdlTexture blendMode: SDL_BLENDMODE_BLEND.
]
