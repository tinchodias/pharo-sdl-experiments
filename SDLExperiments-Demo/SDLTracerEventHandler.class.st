Class {
	#name : #SDLTracerEventHandler,
	#superclass : #Object,
	#traits : 'TSDL2MappedEventHandler',
	#classTraits : 'TSDL2MappedEventHandler classTrait',
	#category : #'SDLExperiments-Demo-Standalone'
}

{ #category : #visiting }
SDLTracerEventHandler >> visitEvent: aSDL2MappedEvent [

	aSDL2MappedEvent traceCr
]
