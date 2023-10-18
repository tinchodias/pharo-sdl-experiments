"
I'm a texture tile that uses `SDL_SetTextureScaleMode()` to set SDL_ScaleModeNearest, and other tricks to draw with cairo in a low-resolution surface and afterwards copy the texture with a pixelated appeareance.

Accidentally, I also use a static-access SDL texture, but that's not the point of myself.
"
Class {
	#name : #SDLPixelatedStaticTile,
	#superclass : #StaticTextureTile,
	#category : #'SDLExperiments-Manager-Texture'
}

{ #category : #'life cycle' }
SDLPixelatedStaticTile >> createTexture [

	"Texture will have reduced physical extent, as initialization specified."
	super createTexture.

	"Sample pixelated"
	sdlTexture setScaleModeNearest
]

{ #category : #initialization }
SDLPixelatedStaticTile >> initializeSDLRenderer: aRenderer pixelExtent: aPoint deviceScalePoint: anotherPoint [

	super initializeSDLRenderer: aRenderer pixelExtent: aPoint deviceScalePoint: anotherPoint.

	deviceScalePoint := deviceScalePoint / self pixalationLevel.
	pixelExtent := aPoint // self pixalationLevel
]

{ #category : #initialization }
SDLPixelatedStaticTile >> pixalationLevel [

	^ 8
]
