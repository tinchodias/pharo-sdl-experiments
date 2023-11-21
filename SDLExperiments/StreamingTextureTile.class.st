"
I'm polymorphic with `Tile` but don't have an associated `Atlas`.
"
Class {
	#name : #StreamingTextureTile,
	#superclass : #TextureTile,
	#instVars : [
		'pixelsAddress',
		'pitchAddress'
	],
	#category : #'SDLExperiments-Manager-Texture'
}

{ #category : #enumerating }
StreamingTextureTile >> cairoContextToOverrideDo: aBlock [

	| aCairoSurface aCairoContext |

	"Obtain a RAM buffer to draw on it, that is
	write-only and needs to be cleaned."
	sdlTexture
		lockRect: SDL_Rect null
		  pixels: pixelsAddress
		   pitch: pitchAddress.

	"Draw on the buffer"
	aCairoSurface := AeCairoImageSurface
		unownedNewForData: pixelsAddress
			         width: pixelExtent x
		           height: pixelExtent y
		           stride: (pitchAddress signedLongAt: 1)
		 format: AeCairoSurfaceFormat argb32.
	aCairoSurface deviceScale: deviceScalePoint.

	aCairoContext := AeCairoContext unownedNewFor: aCairoSurface.
	aCairoContext clearTransparent.
	aBlock value: aCairoContext.

	"Flush to VRAM and free"
	aCairoSurface flush.
	sdlTexture unlock.
	aCairoContext externallyFree.
	aCairoSurface externallyFree.
]

{ #category : #'life cycle' }
StreamingTextureTile >> createCairoObjects [

	pitchAddress := ExternalAddress newPointer.
	pixelsAddress := ExternalAddress newPointer

]

{ #category : #'life cycle' }
StreamingTextureTile >> sdlTextureAccess [ 

	^ SDL_TEXTUREACCESS_STREAMING
]
