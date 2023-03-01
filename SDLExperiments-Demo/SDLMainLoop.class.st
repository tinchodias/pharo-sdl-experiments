Class {
	#name : #SDLMainLoop,
	#superclass : #Object,
	#instVars : [
		'delay',
		'priority',
		'eventHandler'
	],
	#category : #'SDLExperiments-Demo-Standalone'
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
	eventHandler := SDLTracerEventHandler new
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
