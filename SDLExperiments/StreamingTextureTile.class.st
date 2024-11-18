"
I am a `TextureTile` that uses `SDL_LockTexture`/`SDL_UnlockTexture` API to update pixel contents.

See:
* https://wiki.libsdl.org/SDL2/SDL_LockTexture
* https://wiki.libsdl.org/SDL2/SDL_UnlockTexture
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
	aCairoSurface :=
		AeCairoImageSurface
			unownedNewForData: pixelsAddress
			           format: AeCairoSurfaceFormat argb32
			            width: pixelExtent x
			           height: pixelExtent y
			           stride: (pitchAddress signedLongAt: 1).
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
	"Cairo objects are created and freed on each draw."
]

{ #category : #initialization }
StreamingTextureTile >> initialize [

	super initialize.

	pitchAddress := ExternalAddress newPointer.
	pixelsAddress := ExternalAddress newPointer

]

{ #category : #'life cycle' }
StreamingTextureTile >> sdlTextureAccess [ 

	^ SDL_TEXTUREACCESS_STREAMING
]
