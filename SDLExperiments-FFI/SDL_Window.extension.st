Extension { #name : #'SDL_Window' }

{ #category : #'*SDLExperiments-FFI' }
SDL_Window >> getCurrentDisplayMode [
	"See: https://wiki.libsdl.org/SDL2/SDL_GetCurrentDisplayMode"

	| aMode |
	aMode := SDL_DisplayMode externalNew
		autoRelease;
		yourself.

	(SDL2 getCurrentDisplayMode: self getDisplayIndex into: aMode) = 0
		ifFalse: [ SDL2 checkForError ].
	
	^ aMode
]

{ #category : #'*SDLExperiments-FFI' }
SDL_Window >> getDisplayMode [

	| aMode |
	aMode := SDL_DisplayMode externalNew
		autoRelease;
		yourself.

	(self getDisplayModeInto: aMode) = 0
		ifFalse: [ SDL2 checkForError ].
	
	^ aMode
]

{ #category : #'*SDLExperiments-FFI' }
SDL_Window >> position [
	"Answer the logical position of this window."

	| x y |
	x := FFIInt32 newBuffer.
	y := FFIInt32 newBuffer.
	self getPositionX: x y: y.
	^ (x signedLongAt: 1) @ (y signedLongAt: 1)

]

{ #category : #'*SDLExperiments-FFI' }
SDL_Window >> size [
	"Answer the logical size of this window. See renderer's outputSize for the pixel size."

	| w h |
	w := FFIInt32 newBuffer.
	h := FFIInt32 newBuffer.
	self getSizeW: w h: h.
	^ (w signedLongAt: 1) @ (h signedLongAt: 1)

]
