"
I am part of SDL2 bindings.

See: https://wiki.libsdl.org/SDL2/SDL_ThreadFunction
"
Class {
	#name : #'SDL_ThreadFunction',
	#superclass : #FFICallback,
	#pools : [
		'SDL2Constants'
	],
	#category : #'SDLExperiments-FFI'
}

{ #category : #'callback spec' }
SDL_ThreadFunction class >> fnSpec [

	^ 'int ( void *data)'
]

{ #category : #'instance creation' }
SDL_ThreadFunction class >> on: aBlock [

	^ self signature: self fnSpec block: aBlock
]
