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
	payload ifNotNil: [
		aStream
			nextPutAll: ' payload: ';
			print: payload ].
	aStream
		nextPutAll: ' bounds: ';
		print: bounds
]
