Extension { #name : #'SDL_FPoint' }

{ #category : #'*SDLExperiments-FFI' }
SDL_FPoint >> asPoint [

	^ self x @ self y
]
