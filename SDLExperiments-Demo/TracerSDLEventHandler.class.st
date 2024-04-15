Class {
	#name : 'TracerSDLEventHandler',
	#superclass : 'Object',
	#traits : 'TSDL2MappedEventHandler',
	#classTraits : 'TSDL2MappedEventHandler classTrait',
	#category : 'SDLExperiments-Demo-Utility-Interactive',
	#package : 'SDLExperiments-Demo',
	#tag : 'Utility-Interactive'
}

{ #category : 'visiting' }
TracerSDLEventHandler >> visitEvent: aSDL2MappedEvent [

	aSDL2MappedEvent traceCr
]
