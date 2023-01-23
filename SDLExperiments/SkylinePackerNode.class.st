"
I'm a node for SkylinePacker.
"
Class {
	#name : #SkylinePackerNode,
	#superclass : #Object,
	#instVars : [
		'width',
		'x',
		'y'
	],
	#category : #'SDLExperiments-Atlas-Skyline'
}

{ #category : #'instance creation' }
SkylinePackerNode class >> newWithPosition: aPoint width: aNumber [

	^ self new
		x: aPoint x;
		y: aPoint y;
		width: aNumber;
		yourself
]

{ #category : #accessing }
SkylinePackerNode >> addWidth: aNumber [

	width := width + aNumber
]

{ #category : #printing }
SkylinePackerNode >> printOn: aStream [

	super printOn: aStream.
	aStream
		nextPut: $(;
		print: x;
		nextPut: $@;
		print: y;
		nextPutAll: ' width: ';
		print: width;
		nextPut: $)

]

{ #category : #accessing }
SkylinePackerNode >> right [

	^ x + width
]

{ #category : #accessing }
SkylinePackerNode >> shrinkLeft: shrink [

	x := x + shrink.
	width := width - shrink.

]

{ #category : #accessing }
SkylinePackerNode >> width [

	^ width
]

{ #category : #accessing }
SkylinePackerNode >> width: aNumber [

	width := aNumber
]

{ #category : #accessing }
SkylinePackerNode >> x [

	^ x
]

{ #category : #accessing }
SkylinePackerNode >> x: aNumber [

	x := aNumber
]

{ #category : #accessing }
SkylinePackerNode >> y [

	^ y
]

{ #category : #accessing }
SkylinePackerNode >> y: aNumber [

	y := aNumber
]
