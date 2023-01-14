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
