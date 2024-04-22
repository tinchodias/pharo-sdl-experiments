Class {
	#name : 'BooleanArray',
	#superclass : 'Object',
	#instVars : [
		'bits',
		'itemBitSize',
		'arrayClass'
	],
	#category : 'SDLExperiments-BooleanArray',
	#package : 'SDLExperiments-BooleanArray'
}

{ #category : 'instance creation' }
BooleanArray class >> new: size [

	^ self basicNew initialize: size; yourself
]

{ #category : 'accessing' }
BooleanArray >> at: i [

	| byteIndex bitIndex currentByte |
	byteIndex := self byteIndexFor: i.
	bitIndex  := self bitIndexFor: i.
	currentByte := bits at: byteIndex.
	^ currentByte bitAt: bitIndex
]

{ #category : 'accessing' }
BooleanArray >> at: i put: newValue [

	| byteIndex bitIndex oldByte newByte |
	byteIndex := self byteIndexFor: i.
	bitIndex  := self bitIndexFor: i.
	oldByte := bits at: byteIndex.
	newByte := oldByte bitAt: bitIndex put: newValue.
	bits at: byteIndex put: newByte

]

{ #category : 'initialization' }
BooleanArray >> bitIndexFor: i [

	^ (i % itemBitSize) + 1
]

{ #category : 'accessing' }
BooleanArray >> bits [

	^ bits
]

{ #category : 'initialization' }
BooleanArray >> byteIndexFor: i [

	^ (i // itemBitSize) + 1
]

{ #category : 'initialization' }
BooleanArray >> initialize: size [

"	itemBitSize := 32.
	arrayClass := DoubleWordArray.
"	
	itemBitSize := 8.
	arrayClass := ByteArray.

	bits := arrayClass new: (self itemArraySizeFor: size)
]

{ #category : 'initialization' }
BooleanArray >> itemArraySizeFor: size [

	^ (size / itemBitSize) floor + 1
]
