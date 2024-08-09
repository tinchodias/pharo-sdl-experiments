"
I am a RTree node that has one or more children nodes.
"
Class {
	#name : #CrNonLeafNode,
	#superclass : #CrNode,
	#type : #variable,
	#category : #'SDLExperiments-RTree'
}

{ #category : #'instance creation' }
CrNonLeafNode class >> newFrom: nodeCollection startAt: startIndex size: aSize [

	^ (self basicNew: aSize)
		initializeFrom: nodeCollection startAt: startIndex;
		yourself
]

{ #category : #accessing }
CrNonLeafNode >> childrenCount [

	^ self size
]

{ #category : #enumerating }
CrNonLeafNode >> childrenDo: aBlock [

	1 to: self size do: [ :index | aBlock value: (self at: index) ]
]

{ #category : #initialization }
CrNonLeafNode >> initializeFrom: nodeCollection startAt: startIndex [
		
	"First node"
	| firstNode |
	firstNode := nodeCollection at: startIndex.
	self at: 1 put: firstNode.
	left := firstNode left.
	right := firstNode right.
	top := firstNode top.
	bottom := firstNode bottom.

	"Remaining nodes"
	2 to: self size do: [ :index |
		| aNode |
		aNode := nodeCollection at: startIndex + index - 1.
		self at: index put: aNode.

		aNode left < left ifTrue: [ left := aNode left ].
		aNode right > right ifTrue: [ right := aNode right ].
		aNode top < top ifTrue: [ top := aNode top ].
		aNode bottom > bottom ifTrue: [ bottom := aNode bottom ] ]
]

{ #category : #enumerating }
CrNonLeafNode >> intersectionAt: aRectangle do: aBlock [
	
	(self intersects: aRectangle) ifFalse: [ ^self ].

	self childrenDo: [ :each |
		each intersectionAt: aRectangle do: aBlock ]
]

{ #category : #printing }
CrNonLeafNode >> printOn: aStream [

	super printOn: aStream.
	aStream
		nextPutAll: ' children: ';
		print: self childrenCount
]

{ #category : #enumerating }
CrNonLeafNode >> valuesAtX: x y: y do: aBlock [

	(self containsX: x y: y) ifFalse: [ ^ self ].

	self childrenDo: [ :each |
		each valuesAtX: x y: y do: aBlock ]
]
