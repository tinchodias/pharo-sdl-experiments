Extension { #name : #SDL2 }

{ #category : #'*SDLExperiments-FFI' }
SDL2 class >> primGetNumRenderDrivers [

	^ self ffiCall: #(
		int SDL_GetNumRenderDrivers ( void ) )
]

{ #category : #'*SDLExperiments-FFI' }
SDL2 class >> primGetRenderDriverInfo: info at: index [

	^ self ffiCall: #( 
		int SDL_GetRenderDriverInfo(
			int index,
			SDL_RendererInfo * info) )
]

{ #category : #'*SDLExperiments-FFI' }
SDL2 class >> renderDriverInfos [
	"Get a collection of `SDL_RendererInfo` objects for the number of 2D rendering drivers available for the current display.

	Inspect:
		SDL2 renderDriverInfos
	"

	^ (1 to: self primGetNumRenderDrivers) collect: [:index |
		| info |
		info := SDL_RendererInfo externalNew
			autoRelease;
			yourself.
		self primGetRenderDriverInfo: info at: index-1.
		info ]
]
