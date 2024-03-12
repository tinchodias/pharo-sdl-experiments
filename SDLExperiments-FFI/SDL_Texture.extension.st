Extension { #name : 'SDL_Texture' }

{ #category : '*SDLExperiments-FFI' }
SDL_Texture >> lockRect: rect pixels: pixelsAddress pitch: pitchAddress [
	"See: https://wiki.libsdl.org/SDL2/SDL_UpdateTexture"

	^ self ffiCall: #(
		int
		SDL_LockTexture (
			self,
			SDL_Rect* rect,
			void** pixelsAddress,
			int* pitchAddress ) )
]

{ #category : '*SDLExperiments-FFI' }
SDL_Texture >> setScaleModeNearest [
	"Set the scale mode `SDL_ScaleModeNearest` for texture scale operations.
	
	Returns 0 on success, or -1 if the texture is not valid.
	
	See: https://wiki.libsdl.org/SDL2/SDL_SetTextureScaleMode"

	^ self ffiCall: #(
		int
		SDL_SetTextureScaleMode (
			self,
			"SDL_ScaleMode" 0 ) )
]
