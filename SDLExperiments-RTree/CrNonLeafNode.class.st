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

{ #category : 'instance creation' }
CrNonLeafNode class >> newFrom: nodeCollection startAt: startIndex size: aSize [

	^ (self basicNew: aSize)
		initializeFrom: nodeCollection startAt: startIndex;
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

{ #category : 'initialization' }
CrNonLeafNode >> initializeFrom: nodeCollection startAt: startIndex [
		
	self initialize.

	"Replace first node"
	self at: 1 put: (nodeCollection at: startIndex).
	childrenBounds := (self at: 1) bounds copy.

	"Replace remaining nodes"
	2 to: self size do: [ :index |
		| sourceNode |
		sourceNode := nodeCollection at: startIndex + index - 1.
		self at: index put: sourceNode.
		childrenBounds merge: sourceNode bounds ].

	childrenCount := self size
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
		nextPutAll: ' bounds: ';
		print: childrenBounds.
	aStream
		nextPutAll: ' children: ';
		print: childrenCount
]