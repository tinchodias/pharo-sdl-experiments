Class {
	#name : 'SDLMainLoop',
	#superclass : 'Object',
	#instVars : [
		'delay',
		'priority',
		'eventHandler',
		'process'
	],
	#pools : [
		'SDL2Constants'
	],
	#category : 'SDLExperiments-Demo-Utility-Interactive',
	#package : 'SDLExperiments-Demo',
	#tag : 'Utility-Interactive'
}

{ #category : 'accessing' }
SDLMainLoop >> eventHandler [

	^ eventHandler
]

{ #category : 'accessing' }
SDLMainLoop >> eventHandler: anObject [
	"Set as handler an object that responds to `process:` with a `SDL_Event` as argument."

	eventHandler := anObject
]

{ #category : 'running' }
SDLMainLoop >> fork [

	process := [ self run ] forkAt: priority
]

{ #category : 'initialization' }
SDLMainLoop >> initialize [

	super initialize.
	
	priority := Processor lowIOPriority.
	delay := Delay forMilliseconds: 5.
	self useNullEventHandler
]

{ #category : 'running' }
SDLMainLoop >> initializeSDL2 [

	| subsystemsFlag |
	subsystemsFlag := SDL_INIT_VIDEO | SDL_INIT_EVENTS.

"	(SDL2 wasInit: subsystemsFlag) = 0 ifFalse: [
		self error: 'SDL2 subsystems already initialized.' ]."
	SDL2 initLibrary.
	SDL2
		ensureSuccessCode: (SDL2 initSubSystem: subsystemsFlag)
		description: 'Initialize SDL2'
]

{ #category : 'testing' }
SDLMainLoop >> isRunning [

	^ process notNil and: [ process isTerminated not ]
]

{ #category : 'running' }
SDLMainLoop >> run [

	| event session |
	self initializeSDL2.
	event := SDL_Event new.
	session := Smalltalk session.
	
	[ session == Smalltalk session ] whileTrue: [
		[ (SDL2 pollEvent: event) > 0 ] whileTrue: [
			eventHandler process: event ].
			delay wait ]
]

{ #category : 'accessing' }
SDLMainLoop >> useNullEventHandler [

	eventHandler := NullSDLEventHandler new
]

{ #category : 'accessing' }
SDLMainLoop >> useTracerEventHandler [

	eventHandler := TracerSDLEventHandler new
]
