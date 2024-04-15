Extension { #name : 'SDL_Window' }

{ #category : '*SDLExperiments-FFI' }
SDL_Window >> currentDisplayMode [
	"See: https://wiki.libsdl.org/SDL2/SDL_GetCurrentDisplayMode"

	| aMode |
	aMode := SDL_DisplayMode externalNew
		autoRelease;
		yourself.

	(SDL2 getCurrentDisplayMode: self getDisplayIndex into: aMode) = 0
		ifFalse: [ SDL2 checkForError ].
	
	^ aMode
]

{ #category : '*SDLExperiments-FFI' }
SDL_Window >> displayMode [

	| aMode |
	aMode := SDL_DisplayMode externalNew
		autoRelease;
		yourself.

	(self getDisplayModeInto: aMode) = 0
		ifFalse: [ SDL2 checkForError ].
	
	^ aMode
]

{ #category : '*SDLExperiments-FFI' }
SDL_Window >> extent [
	"Answer the logical size of this window. See renderer's outputSize for the pixel size."

	| w h |
	w := FFIInt32 newBuffer.
	h := FFIInt32 newBuffer.
	self getSizeW: w h: h.
	^ (w signedLongAt: 1) @ (h signedLongAt: 1)

]

{ #category : '*SDLExperiments-FFI' }
SDL_Window >> extent: aPoint [
	"Set the logical size of this window. See renderer's outputSize for the pixel size."

	self setSizeW: aPoint x h: aPoint y
]

{ #category : '*SDLExperiments-FFI' }
SDL_Window >> getDisplayModeInto: mode [
	"See: https://wiki.libsdl.org/SDL2/SDL_GetWindowDisplayMode"

	^ self ffiCall: #(
		int
		SDL_GetWindowDisplayMode(
			self,
			SDL_DisplayMode * mode ) )
]

{ #category : '*SDLExperiments-FFI' }
SDL_Window >> position [
	"Answer the logical position of this window."

	| x y |
	x := FFIInt32 newBuffer.
	y := FFIInt32 newBuffer.
	self getPositionX: x y: y.
	^ (x signedLongAt: 1) @ (y signedLongAt: 1)

]

{ #category : '*SDLExperiments-FFI' }
SDL_Window >> position: aPoint [

	self setPositionX: aPoint x y: aPoint y
]

{ #category : '*SDLExperiments-FFI' }
SDL_Window >> setInputFocus [
	"Explicitly set input focus to the window.
	
	You almost certainly want `SDL_RaiseWindow()` instead of this function. Use this with caution, as you might give focus to a window that is completely obscured by other windows.
	
	See: https://wiki.libsdl.org/SDL2/SDL_SetWindowInputFocus"

	^ self ffiCall: #( int SDL_SetWindowInputFocus ( self ) )
]
