Extension { #name : #'SDL_FRect' }

{ #category : #'*SDLExperiments-FFI' }
SDL_FRect >> extent [

	^ self w @ self h
]

{ #category : #'*SDLExperiments-FFI' }
SDL_FRect >> extent: aPoint [

	self w: aPoint x.
	self h: aPoint y
]

{ #category : #'*SDLExperiments-FFI' }
SDL_FRect >> origin [

	^ self x @ self y
]

{ #category : #'*SDLExperiments-FFI' }
SDL_FRect >> origin: aPoint [

	self x: aPoint x.
	self y: aPoint y
]
