"
I'm an abstract R-Tree node that has rectangular bounds. 

My subclasses represent specific nodes that either have children nodes (non-leaf nodes) or an associated value (leaf nodes).
"
Class {
	#name : 'CrNode',
	#superclass : 'Object',
	#instVars : [
		'left',
		'top',
		'right',
		'bottom'
	],
	#category : 'SDLExperiments-RTree',
	#package : 'SDLExperiments-RTree'
}

{ #category : 'accessing' }
CrNode >> bottom [

	^ bottom
]

{ #category : 'accessing' }
CrNode >> bounds [

	^ Rectangle left: left right: right top: top bottom: bottom
]

{ #category : 'enumerating' }
CrNode >> children [

	^ Array new: self childrenCount streamContents: [ :stream |
		self childrenDo: [ :each | stream nextPut: each ]]
]

{ #category : 'accessing' }
CrNode >> childrenCount [

	^ self subclassResponsibility
]

{ #category : 'enumerating' }
CrNode >> childrenDepthFirstDo: aBlock [

	self childrenDo: [ :each |
		each childrenDepthFirstDo: aBlock ].
	aBlock value: self
]

{ #category : 'enumerating' }
CrNode >> childrenDo: aBlock [

	self subclassResponsibility
]

{ #category : 'enumerating' }
CrNode >> intersectionAt: aRectangle do: aBlock [

	self subclassResponsibility
]

{ #category : 'testing' }
CrNode >> intersects: aRectangle [
	"Answer whether aRectangle intersects the receiver anywhere."

	^ self
		intersectsLeft: aRectangle left
		top: aRectangle top
		right: aRectangle right
		bottom: aRectangle bottom
]

{ #category : 'testing' }
CrNode >> intersectsLeft: aLeft top: aTop right: aRight bottom: aBottom [

	aRight  <= left   ifTrue: [ ^ false ].
	aBottom <= top    ifTrue: [ ^ false ].
	aLeft   >= right  ifTrue: [ ^ false ].
	aTop    >= bottom ifTrue: [ ^ false ].
	^ true
]

{ #category : 'accessing' }
CrNode >> left [

	^ left
]

{ #category : 'printing' }
CrNode >> printOn: aStream [

	super printOn: aStream.
	aStream
		nextPutAll: ' bounds: ';
		print: self bounds
]

{ #category : 'accessing' }
CrNode >> right [

	^ right
]

{ #category : 'accessing' }
CrNode >> top [

	^ top
]
