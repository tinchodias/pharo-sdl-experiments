Extension { #name : #SDL2 }

{ #category : #'*SDLExperiments-FFI' }
SDL2 class >> convertSurface: src format: aSDLPixelFormat [
	"See: https://wiki.libsdl.org/SDL2/SDL_ConvertSurfaceFormat"

	^ self ffiCall: #(
		SDL_Surface *
		SDL_ConvertSurfaceFormat (
			SDL_Surface * src,
			Uint32 aSDLPixelFormat,
			0 ) )

]

{ #category : #'*SDLExperiments-FFI' }
SDL2 class >> createRGBSurfaceWithFormat: aSDLPixelFormat depth: depth width: width height: height [
	"See: https://wiki.libsdl.org/SDL_CreateRGBSurfaceWithFormat"

	^ self ffiCall: #(
		SDL_Surface*
		SDL_CreateRGBSurfaceWithFormat (
			0, 
			int width, 
			int height, 
			int depth, 
			Uint32 aSDLPixelFormat) )

]

{ #category : #'*SDLExperiments-FFI' }
SDL2 class >> getCurrentDisplayMode: displayIndex into: mode [
	"See: https://wiki.libsdl.org/SDL2/SDL_GetCurrentDisplayMode"

	^ self ffiCall: #(
		int
		SDL_GetCurrentDisplayMode(
			int displayIndex,
			SDL_DisplayMode * mode) )
]

{ #category : #'*SDLExperiments-FFI' }
SDL2 class >> map0_1FloatTo0_255Integer: aFloat [

	^ (aFloat * 255.0) asInteger min: 255 max: 0
]

{ #category : #'*SDLExperiments-FFI' }
SDL2 class >> map0_255IntegerTo0_1Float: anInteger [

	^ (anInteger / 255.0) min: 1.0 max: 0.0
]

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
