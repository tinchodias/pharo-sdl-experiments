Extension { #name : #'SDL_Color' }

{ #category : #'*SDLExperiments-FFI' }
SDL_Color class >> autoReleasingNewFrom: aPharoColor [

	^ self unownedNewFrom: aPharoColor

]

{ #category : #'*SDLExperiments-FFI' }
SDL_Color class >> unownedNewFrom: aPharoColor [

	^ self new
		updateFrom: aPharoColor;
		yourself
]

{ #category : #'*SDLExperiments-FFI' }
SDL_Color class >> unownedNewR: r g: g b: b a: a [

	^ self new
		r: r;
		g: g;
		b: b;
		a: a;
		yourself
]

{ #category : #'*SDLExperiments-FFI' }
SDL_Color >> updateFrom: aPharoColor [
	
	self
		r: (SDL2 map0_1FloatTo0_255Integer: aPharoColor red);
		g: (SDL2 map0_1FloatTo0_255Integer: aPharoColor green);
		b: (SDL2 map0_1FloatTo0_255Integer: aPharoColor blue);
		a: (SDL2 map0_1FloatTo0_255Integer: aPharoColor alpha)

]
