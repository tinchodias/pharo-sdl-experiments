Extension { #name : #'SDL_Renderer' }

{ #category : #'*SDLExperiments' }
SDL_Renderer >> asFormARGB32 [
	"Answer a Form with my pixels. Tip: use it before present.
	Assumes the format is SDL_PIXELFORMAT_ARGB8888."

	| pixelExtent aSurface |
	pixelExtent := self outputExtent.
	aSurface := SDL2
		            createRGBSurfaceWithFormat: SDL_PIXELFORMAT_ARGB8888
		            depth: 32
		            width: pixelExtent x
		            height: pixelExtent y.

	self
		readPixelsInto: aSurface pixels
		pitch: aSurface pitch
		format: SDL_PIXELFORMAT_ARGB8888
		rect: nil.

	^ aSurface asFormARGB32
]
