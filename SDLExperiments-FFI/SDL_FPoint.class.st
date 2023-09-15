"
I'm a binding to the struct `SDL_FPoint`.

A point that uses float as coordinates.

See: https://wiki.libsdl.org/SDL2/SDL_FPoint
"
Class {
	#name : #'SDL_FPoint',
	#superclass : #SDL2Structure,
	#classVars : [
		'OFFSET_X',
		'OFFSET_Y'
	],
	#category : #'SDLExperiments-FFI'
}

{ #category : #'instance creation' }
SDL_FPoint class >> autoReleasingNewFrom: aPoint [

	^ (self unownedNewX: aPoint x y: aPoint y)
		autoRelease;
		yourself
]

{ #category : #'instance creation' }
SDL_FPoint class >> autoReleasingNewX: x y: y [

	^ (self unownedNewX: x y: y)
		  autoRelease;
		  yourself
]

{ #category : #'field definition' }
SDL_FPoint class >> fieldsDesc [
	"
	self rebuildFieldAccessors
	"

	^ #(
		float x;
		float y;
 		)
]

{ #category : #'instance creation' }
SDL_FPoint class >> unownedNewFrom: aPoint [

	^ self unownedNewX: aPoint x y: aPoint y

]

{ #category : #'instance creation' }
SDL_FPoint class >> unownedNewX: x y: y [

	^ self new
		  x: x;
		  y: y;
		  yourself
]

{ #category : #converting }
SDL_FPoint >> asPoint [

	^ self x @ self y
]

{ #category : #printing }
SDL_FPoint >> printOn: aStream [

	super printOn: aStream.
	aStream print: self asPoint
]

{ #category : #accessing }
SDL_FPoint >> updateFrom: aPharoPoint [

	self
		x: aPharoPoint x asFloat;
		y: aPharoPoint y asFloat
]

{ #category : #'accessing - structure variables' }
SDL_FPoint >> x [
	"This method was automatically generated"
	^handle floatAt: OFFSET_X
]

{ #category : #'accessing - structure variables' }
SDL_FPoint >> x: anObject [
	"This method was automatically generated"
	handle floatAt: OFFSET_X put: anObject
]

{ #category : #'accessing - structure variables' }
SDL_FPoint >> y [
	"This method was automatically generated"
	^handle floatAt: OFFSET_Y
]

{ #category : #'accessing - structure variables' }
SDL_FPoint >> y: anObject [
	"This method was automatically generated"
	handle floatAt: OFFSET_Y put: anObject
]
