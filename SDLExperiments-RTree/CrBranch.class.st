"
Migrated from Chromium's rtree.h

```
    // When the node level is 0, then the node is a leaf and the branch has a
    // valid index pointing to an element in the vector that was used to build
    // this rtree. When the level is not 0, it's an internal node and it has a
    // valid subtree pointer.
```

"
Class {
	#name : 'CrBranch',
	#superclass : 'Object',
	#instVars : [
		'payload',
		'bounds',
		'node'
	],
	#category : 'SDLExperiments-RTree',
	#package : 'SDLExperiments-RTree'
}

{ #category : 'instance creation' }
CrBranch class >> bounds: aRectangle node: aNode [

	^ self new
		node: aNode;
		bounds: aRectangle;
		yourself
]

{ #category : 'instance creation' }
CrBranch class >> bounds: aRectangle payload: anObject [

	^ self new
		payload: anObject;
		bounds: aRectangle;
		yourself
]

{ #category : 'accessing' }
CrBranch >> bounds [

	^ bounds
]

{ #category : 'accessing' }
CrBranch >> bounds: aBounds [

	bounds := aBounds
]

{ #category : 'accessing' }
CrBranch >> node [

	^ node
]

{ #category : 'accessing' }
CrBranch >> node: aNode [

	node := aNode
]

{ #category : 'accessing' }
CrBranch >> payload [

	^ payload
]

{ #category : 'accessing' }
CrBranch >> payload: anObject [

	payload := anObject
]

{ #category : 'printing' }
CrBranch >> printOn: aStream [

	super printOn: aStream.
	payload ifNotNil: [
		aStream
			nextPutAll: ' payload: ';
			print: payload ].
	aStream
		nextPutAll: ' bounds: ';
		print: bounds
]
