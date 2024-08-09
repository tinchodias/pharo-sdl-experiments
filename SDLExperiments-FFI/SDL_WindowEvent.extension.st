Extension { #name : #'SDL_WindowEvent' }

{ #category : #'*SDLExperiments-FFI' }
SDL_WindowEvent >> printOn: aStream [

	aStream
		<< self className;
		nextPut: $(;
		print: (SDL_WindowEventID fromInteger: self event) item;
		nextPut: $)

]
