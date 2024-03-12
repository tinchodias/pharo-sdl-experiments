Extension { #name : 'SDL2Handle' }

{ #category : '*SDLExperiments-FFI' }
SDL2Handle >> signalErrorIfNull [
	"SDL2 object creation API tipically returns NULL on failure, and `SDL_GetError()` returns a string the error message."
	
	self getHandle isNull ifTrue: [ SDL2 checkForError ]
]
