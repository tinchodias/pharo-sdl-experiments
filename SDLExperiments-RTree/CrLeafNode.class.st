"
I am a leaf RTree node that knows an associated value.
"
Class {
	#name : #CrLeafNode,
	#superclass : #CrNode,
	#instVars : [
		'value'
	],
	#category : #'SDLExperiments-RTree'
}

{ #category : #'instance creation' }
CrLeafNode class >> bounds: aBounds value: anObject [

	^ self basicNew
		initializeWith: anObject bounds: aBounds;
		yourself
]

{ #category : #accessing }
CrLeafNode >> childrenCount [

	^ 0
]

{ #category : #enumerating }
CrLeafNode >> childrenDo: aBlock [
]

{ #category : #initialization }
CrLeafNode >> initializeWith: anObject bounds: aBounds [

	value := anObject.

	left := aBounds left.
	right := aBounds right.
	top := aBounds top.
	bottom := aBounds bottom
]

{ #category : #enumerating }
CrLeafNode >> intersectionAt: aRectangle do: aBlock [

	(self intersects: aRectangle) ifFalse: [ ^self ].

	aBlock value: value
]

{ #category : #printing }
CrLeafNode >> printOn: aStream [

	super printOn: aStream.
	aStream
		nextPutAll: ' value: ';
		print: value
]

{ #category : #accessing }
CrLeafNode >> value [

	^ value
]

{ #category : #enumerating }
CrLeafNode >> valuesAtX: x y: y do: aBlock [

	(self containsX: x y: y) ifFalse: [ ^ self ].

	aBlock value: value
]
