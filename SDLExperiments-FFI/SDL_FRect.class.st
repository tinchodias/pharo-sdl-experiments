"
I'm a binding to the struct `SDL_FRect`.

A rectangle, with the origin at the upper left (floating point).

"
Class {
	#name : #'SDL_FRect',
	#superclass : #SDL2Structure,
	#classVars : [
		'OFFSET_H',
		'OFFSET_W',
		'OFFSET_X',
		'OFFSET_Y'
	],
	#category : #'SDLExperiments-FFI'
}

{ #category : #'field definition' }
SDL_FRect class >> fieldsDesc [
	"
	self rebuildFieldAccessors
	"
	^#(
    float x;
    float y;
    float w;
    float h;
 	)
]

{ #category : #'accessing - structure variables' }
SDL_FRect >> h [
	"This method was automatically generated"
	^handle floatAt: OFFSET_H
]

{ #category : #'accessing - structure variables' }
SDL_FRect >> h: anObject [
	"This method was automatically generated"
	handle floatAt: OFFSET_H put: anObject
]

{ #category : #'accessing - structure variables' }
SDL_FRect >> w [
	"This method was automatically generated"
	^handle floatAt: OFFSET_W
]

{ #category : #'accessing - structure variables' }
SDL_FRect >> w: anObject [
	"This method was automatically generated"
	handle floatAt: OFFSET_W put: anObject
]

{ #category : #'accessing - structure variables' }
SDL_FRect >> x [
	"This method was automatically generated"
	^handle floatAt: OFFSET_X
]

{ #category : #'accessing - structure variables' }
SDL_FRect >> x: anObject [
	"This method was automatically generated"
	handle floatAt: OFFSET_X put: anObject
]

{ #category : #'accessing - structure variables' }
SDL_FRect >> y [
	"This method was automatically generated"
	^handle floatAt: OFFSET_Y
]

{ #category : #'accessing - structure variables' }
SDL_FRect >> y: anObject [
	"This method was automatically generated"
	handle floatAt: OFFSET_Y put: anObject
]
