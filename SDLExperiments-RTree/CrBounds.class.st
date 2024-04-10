Class {
	#name : 'CrBounds',
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

{ #category : 'instance creation' }
CrBounds class >> left: aLeft top: aTop right: aRight bottom: aBottom [

	^ self new
		left: aLeft
		top: aTop
		right: aRight
		bottom: aBottom;
		yourself
]

{ #category : 'instance creation' }
CrBounds class >> origin: anOrigin corner: aCorner [

	^ self
		left: anOrigin x
		top: anOrigin y
		right: aCorner x
		bottom: aCorner y
]

{ #category : 'instance creation' }
CrBounds class >> origin: anOrigin extent: anExtent [

	^ self
		left: anOrigin x
		top: anOrigin y
		right: anOrigin x + anExtent x
		bottom: anOrigin y + anExtent y
]

{ #category : 'comparing' }
CrBounds >> = anObject [

	self == anObject ifTrue: [ ^ true ].
	self class = anObject class ifFalse: [ ^ false ].
	^ bottom = anObject bottom and: [
		left = anObject left and: [
			right = anObject right and: [
				top = anObject top ] ] ]
]

{ #category : 'accessing' }
CrBounds >> bottom [

	^ bottom
]

{ #category : 'accessing' }
CrBounds >> corner [
	
	^ right @ bottom
]

{ #category : 'accessing' }
CrBounds >> extent [

	^ (right - left) @ (bottom - top)
]

{ #category : 'comparing' }
CrBounds >> hash [

	^ bottom hash bitXor:
		(left hash bitXor:
			(right hash bitXor:
				top hash))
]

{ #category : 'accessing' }
CrBounds >> height [

	^ bottom - top
]

{ #category : 'testing' }
CrBounds >> intersects: aRectangle [
	"Answer whether aRectangle intersects the receiver anywhere."

	aRectangle right  <= left   ifTrue: [ ^ false ].
	aRectangle bottom <= top    ifTrue: [ ^ false ].
	aRectangle left   >= right  ifTrue: [ ^ false ].
	aRectangle top    >= bottom ifTrue: [ ^ false ].
	^ true
]

{ #category : 'testing' }
CrBounds >> isEmpty [

	^ left = right or: [ top = bottom ]
]

{ #category : 'accessing' }
CrBounds >> left [

	^ left
]

{ #category : 'instance creation' }
CrBounds >> left: aLeft top: aTop right: aRight bottom: aBottom [

	left := aLeft.
	top := aTop.
	right := aRight.
	bottom := aBottom
]

{ #category : 'actions' }
CrBounds >> merge: aRectangle [

	self
		mergeLeft: aRectangle left
		top: aRectangle top
		right: aRectangle right
		bottom: aRectangle bottom
]

{ #category : 'rectangle functions' }
CrBounds >> mergeLeft: aLeft top: aTop right: aRight bottom: aBottom [
	"Merge provided rectangle into me."

	aLeft < left ifTrue: [ left := aLeft ].
	aRight > right ifTrue: [ right := aRight ].
	aTop < top ifTrue: [ top := aTop ].
	aBottom > bottom ifTrue: [ bottom := aBottom ]
]

{ #category : 'accessing' }
CrBounds >> origin [

	^ left @ top
]

{ #category : 'accessing' }
CrBounds >> printOn: aStream [ 

	self origin printOn: aStream.
	aStream nextPutAll: ' corner: '.
	self corner printOn: aStream
]

{ #category : 'accessing' }
CrBounds >> right [

	^ right
]

{ #category : 'accessing' }
CrBounds >> top [

	^ top
]

{ #category : 'accessing' }
CrBounds >> width [

	^ right - left
]
