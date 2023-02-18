Extension { #name : #'SDL_Renderer' }

{ #category : #'*SDLExperiments-FFI' }
SDL_Renderer >> copy: texture srcRect: srcRect dstRectF: dstRect [
	"See: https://wiki.libsdl.org/SDL_RenderCopyF"

	^ self ffiCall: #( 
		int 
		SDL_RenderCopyF (
			self,
			SDL_Texture texture,
			SDL_Rect * srcRect,
			SDL_FRect * dstRect) )

]

{ #category : #'*SDLExperiments-FFI' }
SDL_Renderer >> disableVSync [

	^ self ffiCall: #(
		int
		SDL_RenderSetVSync (
			self,
			0 ) )
]

{ #category : #'*SDLExperiments-FFI' }
SDL_Renderer >> enableVSync [

	^ self ffiCall: #(
		int
		SDL_RenderSetVSync (
			self,
			1 ) )
]

{ #category : #'*SDLExperiments-FFI' }
SDL_Renderer >> fillRectF: rect [
	"See: https://wiki.libsdl.org/SDL2/SDL_RenderFillRectF"

	^ self ffiCall: #(
		int
		SDL_RenderFillRectF (
			self,
			SDL_FRect * rect ) )
]

{ #category : #'*SDLExperiments-FFI' }
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

{ #category : #'*SDLExperiments-FFI' }
SDL_Renderer >> setDrawColor: aColor [

	^ self
		drawColorR: (SDL2 map0_1FloatTo0_255Integer: aColor red)
		         g: (SDL2 map0_1FloatTo0_255Integer: aColor green)
		         b: (SDL2 map0_1FloatTo0_255Integer: aColor blue)
		         a: (SDL2 map0_1FloatTo0_255Integer: aColor alpha)
	
]

{ #category : #'*SDLExperiments-FFI' }
SDL_Renderer >> setVSync: vsync [
	"See: https://wiki.libsdl.org/SDL2/SDL_RenderSetVSync"

	^ self ffiCall: #(
		int
		SDL_RenderSetVSync (
			self,
			int vsync ) )
]
