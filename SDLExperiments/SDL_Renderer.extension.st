Extension { #name : #'SDL_Renderer' }

{ #category : #'*SDLExperiments' }
SDL_Renderer >> asFormARGB32 [
	"Answer a Form with my pixels. Assumes the format is SDL_PIXELFORMAT_ARGB8888."

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

{ #category : #'*SDLExperiments' }
SDL_Renderer >> readPixelsInto: pixels pitch: pitch format: format rect: rect [

	^ self ffiCall: #(
		int
		SDL_RenderReadPixels (
			self,
			SDL_Rect * rect,
			Uint32 format,
			void * pixels,
			int pitch ) )

]
