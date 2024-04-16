"
I am a leaf RTree node that knows a payload value.
"
Class {
	#name : 'CrLeafNode',
	#superclass : 'CrNode',
	#instVars : [
		'payload'
	],
	#category : 'SDLExperiments-RTree',
	#package : 'SDLExperiments-RTree'
}

{ #category : 'instance creation' }
CrLeafNode class >> bounds: aBounds payload: anObject [

	^ self basicNew
		initializeWith: anObject bounds: aBounds;
		yourself
]

{ #category : 'accessing' }
CrLeafNode >> childrenCount [

	^ 0
]

{ #category : 'enumerating' }
CrLeafNode >> childrenDo: aBlock [
]

{ #category : 'initialization' }
CrLeafNode >> initializeWith: anObject bounds: aBounds [

	payload := anObject.

	left := aBounds left.
	right := aBounds right.
	top := aBounds top.
	bottom := aBounds bottom
]

{ #category : 'enumerating' }
CrLeafNode >> intersectionAt: aRectangle do: aBlock [

	(self intersects: aRectangle) ifFalse: [ ^self ].

	aBlock value: payload
]

{ #category : 'accessing' }
CrLeafNode >> payload [

	^ payload
]

{ #category : 'printing' }
CrLeafNode >> printOn: aStream [

	super printOn: aStream.
	aStream
		nextPutAll: ' payload: ';
		print: payload
]
