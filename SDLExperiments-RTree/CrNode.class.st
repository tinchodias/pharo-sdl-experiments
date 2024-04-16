"
I'm an abstract RTree node that has rectangular bounds, and may have children nodes and a payload value.
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

{ #category : 'enumerating' }
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

	^ self subclassResponsibility
]

{ #category : 'testing' }
CrNode >> intersects: aRectangle [
	"Answer whether aRectangle intersects the receiver anywhere."

	aRectangle right  <= left   ifTrue: [ ^ false ].
	aRectangle bottom <= top    ifTrue: [ ^ false ].
	aRectangle left   >= right  ifTrue: [ ^ false ].
	aRectangle top    >= bottom ifTrue: [ ^ false ].
	^ true
]

{ #category : 'testing' }
CrNode >> isLeaf [

	^ self subclassResponsibility
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
