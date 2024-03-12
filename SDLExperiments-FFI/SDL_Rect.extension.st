Extension { #name : 'SDL_Rect' }

{ #category : '*SDLExperiments-FFI' }
SDL_Rect >> asRectangle [

	^ self origin extent: self extent
]

{ #category : '*SDLExperiments-FFI' }
SDL_Rect class >> autoReleasingNewOrigin: origin extent: extent [

	^ self
		  autoReleasingNewX: origin x
		  y: origin y
		  w: extent x
		  h: extent y
]

{ #category : '*SDLExperiments-FFI' }
SDL_Rect class >> autoReleasingNewX: x y: y w: w h: h [

	^ self new
		  x: x;
		  y: y;
		  w: w;
		  h: h;
		  autoRelease;
		  yourself
]

{ #category : '*SDLExperiments-FFI' }
SDL_Rect >> extent [

	^ self w @ self h
]

{ #category : '*SDLExperiments-FFI' }
SDL_Rect >> extent: aPoint [

	self w: aPoint x.
	self h: aPoint y
]

{ #category : '*SDLExperiments-FFI' }
SDL_Rect >> origin [

	^ self x @ self y
]

{ #category : '*SDLExperiments-FFI' }
SDL_Rect >> origin: aPoint [

	self x: aPoint x.
	self y: aPoint y
]

{ #category : '*SDLExperiments-FFI' }
SDL_Rect >> printOn: aStream [

	super printOn: aStream.
	aStream
		nextPut: $(;
		print: self asRectangle;
		nextPut: $)
]
