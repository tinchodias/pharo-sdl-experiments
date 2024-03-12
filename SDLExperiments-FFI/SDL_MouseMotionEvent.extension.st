Extension { #name : 'SDL_MouseMotionEvent' }

{ #category : '*SDLExperiments-FFI' }
SDL_MouseMotionEvent >> position [

	^ self x @ self y
]
