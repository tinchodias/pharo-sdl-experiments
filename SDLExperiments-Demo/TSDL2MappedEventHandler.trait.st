Trait {
	#name : 'TSDL2MappedEventHandler',
	#category : 'SDLExperiments-Demo-Utility-Interactive',
	#package : 'SDLExperiments-Demo',
	#tag : 'Utility-Interactive'
}

{ #category : 'accessing' }
TSDL2MappedEventHandler >> process: aRawSDLEvent [

	aRawSDLEvent mapped accept: self
]

{ #category : 'visiting' }
TSDL2MappedEventHandler >> visitCommonEvent: aSDL_CommonEvent [

	^ self visitEvent: aSDL_CommonEvent
]

{ #category : 'visiting' }
TSDL2MappedEventHandler >> visitDropEvent: aSDL_DropEvent [

	^ self visitEvent: aSDL_DropEvent
]

{ #category : 'visiting' }
TSDL2MappedEventHandler >> visitEvent: aSDL2MappedEvent [
	"Default"
]

{ #category : 'visiting' }
TSDL2MappedEventHandler >> visitKeyDownEvent: aSDL_KeyDownEvent [

	^ self visitEvent: aSDL_KeyDownEvent
]

{ #category : 'visiting' }
TSDL2MappedEventHandler >> visitKeyUpEvent: aSDL_KeyUpEvent [

	^ self visitEvent: aSDL_KeyUpEvent
]

{ #category : 'visiting' }
TSDL2MappedEventHandler >> visitMouseButtonDownEvent: aSDL_MouseButtonDownEvent [

	^ self visitEvent: aSDL_MouseButtonDownEvent
]

{ #category : 'visiting' }
TSDL2MappedEventHandler >> visitMouseButtonUpEvent: aSDL_MouseButtonUpEvent [

	^ self visitEvent: aSDL_MouseButtonUpEvent
]

{ #category : 'visiting' }
TSDL2MappedEventHandler >> visitMouseMotionEvent: aSDL_MouseMotionEvent [

	^ self visitEvent: aSDL_MouseMotionEvent
]

{ #category : 'visiting' }
TSDL2MappedEventHandler >> visitMouseWheelEvent: aSDL_MouseWheelEvent [

	^ self visitEvent: aSDL_MouseWheelEvent
]

{ #category : 'visiting' }
TSDL2MappedEventHandler >> visitQuitEvent: aSDL_QuitEvent [

	^ self visitEvent: aSDL_QuitEvent
]

{ #category : 'visiting' }
TSDL2MappedEventHandler >> visitTextEditingEvent: aSDL_TextEditingEvent [

	^ self visitEvent: aSDL_TextEditingEvent
]

{ #category : 'visiting' }
TSDL2MappedEventHandler >> visitTextInputEvent: aSDL_TextInputEvent [

	^ self visitEvent: aSDL_TextInputEvent
]

{ #category : 'visiting' }
TSDL2MappedEventHandler >> visitWindowEvent: aSDL2MappedEvent [

	^ self visitEvent: aSDL2MappedEvent
]
