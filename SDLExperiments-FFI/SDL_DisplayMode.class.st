"
I'm a binding to the struct `SDL_DisplayMode`.

A structure that contains the description of a display mode.

See: https://wiki.libsdl.org/SDL2/SDL_DisplayMode
"
Class {
	#name : 'SDL_DisplayMode',
	#superclass : 'SDL2Structure',
	#classVars : [
		'OFFSET_DRIVERDATA',
		'OFFSET_FORMAT',
		'OFFSET_H',
		'OFFSET_REFRESHRATE',
		'OFFSET_W'
	],
	#category : 'SDLExperiments-FFI',
	#package : 'SDLExperiments-FFI'
}

{ #category : 'field definition' }
SDL_DisplayMode class >> fieldsDesc [
	"
	self rebuildFieldAccessors
	"
	^#(
    uint32 format;              "pixel format"
    int w;                      "width, in screen coordinates"
    int h;                      "height, in screen coordinates"
    int refreshRate;            "refresh rate (or zero for unspecified)"
    void *driverdata;           "driver-specific data, initialize to 0"
 	)
]

{ #category : 'accessing - structure variables' }
SDL_DisplayMode >> driverdata [
	"This method was automatically generated"
	^ExternalData fromHandle: (handle pointerAt: OFFSET_DRIVERDATA) type: ExternalType void asPointerType
]

{ #category : 'accessing - structure variables' }
SDL_DisplayMode >> driverdata: anObject [
	"This method was automatically generated"
	handle pointerAt: OFFSET_DRIVERDATA put: anObject getHandle.
]

{ #category : 'accessing - structure variables' }
SDL_DisplayMode >> extent [

	^ self w @ self h
]

{ #category : 'accessing - structure variables' }
SDL_DisplayMode >> format [
	"This method was automatically generated"
	^handle unsignedLongAt: OFFSET_FORMAT
]

{ #category : 'accessing - structure variables' }
SDL_DisplayMode >> format: anObject [
	"This method was automatically generated"
	handle unsignedLongAt: OFFSET_FORMAT put: anObject
]

{ #category : 'accessing - structure variables' }
SDL_DisplayMode >> h [
	"This method was automatically generated"
	^handle signedLongAt: OFFSET_H
]

{ #category : 'accessing - structure variables' }
SDL_DisplayMode >> h: anObject [
	"This method was automatically generated"
	handle signedLongAt: OFFSET_H put: anObject
]

{ #category : 'printing' }
SDL_DisplayMode >> printOn: aStream [

	super printOn: aStream.
	aStream
		nextPut: $(;
		print: self extent;
		space;
		print: self refresh_rate;
		nextPutAll: 'hz)'

]

{ #category : 'accessing - structure variables' }
SDL_DisplayMode >> refreshRate [
	"This method was automatically generated"
	^handle signedLongAt: OFFSET_REFRESHRATE
]

{ #category : 'accessing - structure variables' }
SDL_DisplayMode >> refreshRate: anObject [
	"This method was automatically generated"
	handle signedLongAt: OFFSET_REFRESHRATE put: anObject
]

{ #category : 'accessing - structure variables' }
SDL_DisplayMode >> w [
	"This method was automatically generated"
	^handle signedLongAt: OFFSET_W
]

{ #category : 'accessing - structure variables' }
SDL_DisplayMode >> w: anObject [
	"This method was automatically generated"
	handle signedLongAt: OFFSET_W put: anObject
]
