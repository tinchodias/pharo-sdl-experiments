"
I am an RTree node that has one or mode children.
"
Class {
	#name : 'CrNonLeafNode',
	#superclass : 'CrNode',
	#type : 'variable',
	#instVars : [
		'childrenCount',
		'childrenBounds'
	],
	#category : 'SDLExperiments-RTree',
	#package : 'SDLExperiments-RTree'
}

{ #category : 'instance creation' }
CrNonLeafNode class >> new: aSize firstChild: aNode [

	^ (self basicNew: aSize)
		initializeFirstChild: aNode;
		yourself
]

{ #category : 'accessing' }
CrNonLeafNode >> addChild: aNode [

	childrenCount := childrenCount + 1.
	self at: childrenCount put: aNode.
	
	childrenBounds merge: aNode bounds
]

{ #category : 'accessing' }
CrNonLeafNode >> bounds [

	^ childrenBounds
]

{ #category : 'accessing' }
CrNonLeafNode >> childrenCount [

	^ childrenCount
]

{ #category : 'enumerating' }
CrNonLeafNode >> childrenDo: aBlock [

	1 to: childrenCount do: [:index | aBlock value: (self at: index) ]
]

{ #category : 'initialization' }
CrNonLeafNode >> initializeFirstChild: aNode [
		
	self initialize.
	
	childrenCount := 1.
	self at: 1 put: aNode.
	childrenBounds := aNode bounds copy
]

{ #category : 'accessing' }
CrNonLeafNode >> isFull [

	^ self size = childrenCount
]

{ #category : 'testing' }
CrNonLeafNode >> isLeaf [

	^ false
]

{ #category : 'printing' }
CrNonLeafNode >> printOn: aStream [

	super printOn: aStream.
	aStream
		nextPutAll: ' children: ';
		print: childrenCount
]
