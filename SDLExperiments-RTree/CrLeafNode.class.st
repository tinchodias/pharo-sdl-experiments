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
CrLeafNode class >> bounds: aRectangle payload: anObject [

	^ self new
		payload: anObject;
		bounds: aRectangle;
		yourself
]

{ #category : 'accessing' }
CrLeafNode >> bounds [

	^ bounds
]

{ #category : 'accessing' }
CrLeafNode >> bounds: aBounds [

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

{ #category : 'accessing' }
CrLeafNode >> payload: anObject [

	payload := anObject
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
