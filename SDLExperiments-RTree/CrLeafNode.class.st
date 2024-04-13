"
I am a leaf RTree node that knows a payload value.
"
Class {
	#name : 'CrLeafNode',
	#superclass : 'CrNode',
	#instVars : [
		'payload',
		'bounds'
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
CrLeafNode >> bounds [

	^ bounds
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

	self initialize.
	payload := anObject.
	bounds := aBounds
]

{ #category : 'testing' }
CrLeafNode >> isLeaf [

	^ true
]

{ #category : 'accessing' }
CrLeafNode >> payload [

	^ payload
]

{ #category : 'printing' }
CrLeafNode >> printOn: aStream [

	super printOn: aStream.
	aStream
		nextPutAll: ' bounds: ';
		print: bounds.
	aStream
		nextPutAll: ' payload: ';
		print: payload
]
