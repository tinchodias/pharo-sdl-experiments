Extension { #name : 'SDL2' }

{ #category : '*SDLExperiments-FFI' }
SDL2 class >> convertSurface: src format: aSDLPixelFormat [
	"See: https://wiki.libsdl.org/SDL2/SDL_ConvertSurfaceFormat"

	^ self ffiCall: #(
		SDL_Surface *
		SDL_ConvertSurfaceFormat (
			SDL_Surface * src,
			Uint32 aSDLPixelFormat,
			Uint32 0 ) )

]

{ #category : '*SDLExperiments-FFI' }
SDL2 class >> createColorCursorFrom: surface hotX: hotX hotY: hotY [
	"See: https://wiki.libsdl.org/SDL2/SDL_CreateColorCursor"

	^ self ffiCall: #(
		SDL_Cursor
		SDL_CreateColorCursor (
			SDL_Surface * surface,
			int hotX,
			int hotY ) )
]

{ #category : '*SDLExperiments-FFI' }
SDL2 class >> createRGBSurfaceWithFormat: aSDLPixelFormat depth: depth width: width height: height [
	"See: https://wiki.libsdl.org/SDL_CreateRGBSurfaceWithFormat"

	^ self ffiCall: #(
		SDL_Surface*
		SDL_CreateRGBSurfaceWithFormat (
			Uint32 0, 
			int width, 
			int height, 
			int depth, 
			Uint32 aSDLPixelFormat) )

]

{ #category : '*SDLExperiments-FFI' }
SDL2 class >> ensureSuccessCode: aReturnCode description: aString [
	"SDL2 API tipically specify: 'Returns 0 on success or a negative error code on failure; call SDL_GetError() for more information.'"
	
	aReturnCode negative ifTrue: [
		| msg |
		msg := 'Failed to "{1}": "{2}"'
			format: { aString. SDL2 getErrorMessage }.
		SDL2Error signal: msg ]
]

{ #category : '*SDLExperiments-FFI' }
SDL2 class >> fromByteToFloat: anInteger [
	"Linearly map an integer number between 0 and 255 to a floating-point number between 0.0 and 1.0."

	^ (anInteger / 255.0) min: 1.0 max: 0.0
]

{ #category : '*SDLExperiments-FFI' }
SDL2 class >> fromFloatToByte: aFloat [
	"Linearly map a floating-point number between 0.0 and 1.0 to an integer number between 0 and 255."

	^ (aFloat * 255.0) rounded min: 255 max: 0
]

{ #category : '*SDLExperiments-FFI' }
SDL2 class >> getCurrentDisplayMode: displayIndex into: mode [
	"See: https://wiki.libsdl.org/SDL2/SDL_GetCurrentDisplayMode"

	^ self ffiCall: #(
		int
		SDL_GetCurrentDisplayMode(
			int displayIndex,
			SDL_DisplayMode * mode) )
]

{ #category : '*SDLExperiments-FFI' }
SDL2 class >> getHint: aName [

	^ self ffiCall: #(String SDL_GetHint(String aName))
]

{ #category : '*SDLExperiments-FFI' }
SDL2 class >> memCopy: src to: dest size: n [

	^ self ffiCall: #(
		void *
		SDL_memcpy (
			void * dest,
			const void * src,
			size_t n
			) )
]

{ #category : '*SDLExperiments-FFI' }
SDL2 class >> performanceCounter [

	^ self ffiCall: #(
		Uint64 SDL_GetPerformanceCounter() )
]

{ #category : '*SDLExperiments-FFI' }
SDL2 class >> performanceFrequency [

	^ self ffiCall: #(
		Uint64 SDL_GetPerformanceFrequency() )
]

{ #category : '*SDLExperiments-FFI' }
SDL2 class >> premultipliedAlphaBlendMode [
	"Answer the custom blend mode that corresponds to the well-known 'premultiplied alpha'.

	See: 
		https://www.adriancourreges.com/blog/2017/05/09/beware-of-transparent-pixels/
		https://www.realtimerendering.com/blog/gpus-prefer-premultiplication/
	"

	^ self
		composeCustomBlendMode_srcColorFactor: SDL_BLENDFACTOR_ONE
		dstColorFactor: SDL_BLENDFACTOR_ONE_MINUS_SRC_ALPHA
		colorOperation: SDL_BLENDOPERATION_ADD
		srcAlphaFactor: SDL_BLENDFACTOR_ONE
		dstAlphaFactor: SDL_BLENDFACTOR_ONE_MINUS_SRC_ALPHA
		alphaOperation: SDL_BLENDOPERATION_ADD

]

{ #category : '*SDLExperiments-FFI' }
SDL2 class >> primGetNumRenderDrivers [

	^ self ffiCall: #(
		int SDL_GetNumRenderDrivers ( void ) )
]

{ #category : '*SDLExperiments-FFI' }
SDL2 class >> primGetRenderDriverInfo: info at: index [

	^ self ffiCall: #( 
		int SDL_GetRenderDriverInfo(
			int index,
			SDL_RendererInfo * info) )
]

{ #category : '*SDLExperiments-FFI' }
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

{ #category : '*SDLExperiments-FFI' }
SDL2 class >> ticks [

	^ self ffiCall: #(
		Uint32 SDL_GetTicks() )
]

{ #category : '*SDLExperiments-FFI' }
SDL2 class >> ticks64 [

	^ self ffiCall: #(
		Uint64 SDL_GetTicks64() )
]
