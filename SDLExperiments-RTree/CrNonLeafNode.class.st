"
I am an RTree node that has one or mode children.
"
Class {
	#name : 'CrNonLeafNode',
	#superclass : 'CrNode',
	#type : 'variable',
	#instVars : [
		'childrenBounds'
	],
	#category : 'SDLExperiments-RTree',
	#package : 'SDLExperiments-RTree'
}

{ #category : 'instance creation' }
CrNonLeafNode class >> newFrom: nodeCollection startAt: startIndex size: aSize [

	^ (self basicNew: aSize)
		initializeFrom: nodeCollection startAt: startIndex;
		yourself
]

{ #category : 'accessing' }
CrNonLeafNode >> bounds [

	^ childrenBounds
]

{ #category : 'accessing' }
CrNonLeafNode >> childrenCount [

	^ self size
]

{ #category : 'enumerating' }
CrNonLeafNode >> childrenDo: aBlock [

	1 to: self size do: [:index | aBlock value: (self at: index) ]
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
		childrenBounds merge: sourceNode bounds ]
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
		print: self bounds.
	aStream
		nextPutAll: ' children: ';
		print: self childrenCount
]
