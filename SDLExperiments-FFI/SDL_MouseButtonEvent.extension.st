Extension { #name : #'SDL_MouseButtonEvent' }

{ #category : #'*SDLExperiments-FFI' }
SDL_MouseButtonEvent >> position [

	^ self x @ self y
]
