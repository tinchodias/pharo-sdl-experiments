Class {
	#name : #SDLMainLoop,
	#superclass : #Object,
	#instVars : [
		'delay',
		'priority',
		'eventHandler'
	],
	#category : #'SDLExperiments-Demo-Utility-Interactive'
}

{ #category : #accessing }
SDLMainLoop >> eventHandler [

	^ eventHandler
]

{ #category : #accessing }
SDLMainLoop >> eventHandler: anObject [
	"Set as handler an object that responds to `process:` with a `SDL_Event` as argument."

	eventHandler := anObject
]

{ #category : #running }
SDLMainLoop >> fork [

	[ self run ] forkAt: priority
]

{ #category : #running }
SDLMainLoop >> initialize [

	super initialize.
	
	priority := Processor lowIOPriority.
	delay := Delay forMilliseconds: 5.
	self useNullEventHandler
]

{ #category : #running }
SDLMainLoop >> run [

	| event session |
	SDL2 initVideo.
	event := SDL_Event new.
	session := Smalltalk session.
	
	[ session == Smalltalk session ] whileTrue: [
		[ (SDL2 pollEvent: event) > 0 ] whileTrue: [
			eventHandler process: event ].
			delay wait ]
]

{ #category : #running }
SDLMainLoop >> useNullEventHandler [

	eventHandler := NullSDLEventHandler new
]

{ #category : #running }
SDLMainLoop >> useTracerEventHandler [

	eventHandler := TracerSDLEventHandler new
]
