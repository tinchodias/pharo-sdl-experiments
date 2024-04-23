Class {
	#name : 'BooleanArray',
	#superclass : 'Object',
	#instVars : [
		'bits',
		'size'
	],
	#classVars : [
		'ArrayClass',
		'BitMasks',
		'InversedBitMask',
		'WordOfOnes',
		'WordSize'
	],
	#category : 'SDLExperiments-BooleanArray',
	#package : 'SDLExperiments-BooleanArray'
}

{ #category : 'class initialization' }
BooleanArray class >> initialize [
	"
	self initialize
	"

	self initializeFor: ByteArray
]

{ #category : 'class initialization' }
BooleanArray class >> initializeFor: arrayedCollectionClass [

	ArrayClass := arrayedCollectionClass.
	WordSize := ArrayClass classLayout bytesPerSlot * 8 "bits per byte".

	WordOfOnes := 16rFF.
	BitMasks := ArrayClass streamContents: [ :stream |
		0 to: WordSize-1 do: [ :index |
			stream nextPut: (1 bitShift: index) ] ].
	InversedBitMask := ArrayClass streamContents: [ :stream |
		0 to: WordSize-1 do: [ :index |
			stream nextPut: (WordOfOnes bitAnd: (1 bitShift: index) bitInvert) ] ]
]

{ #category : 'instance creation' }
BooleanArray class >> new: size [

	^ self basicNew initialize: size; yourself
]

{ #category : 'accessing' }
BooleanArray >> at: i [

	| wordIndex bitIndex |
	wordIndex := self wordIndexFor: i.
	bitIndex  := self bitIndexFor: i.
	^ ((bits at: wordIndex) bitAnd: (BitMasks at: bitIndex)) > 0
]

{ #category : 'accessing' }
BooleanArray >> at: i put: newValue [

	| wordIndex bitIndex oldByte |
	wordIndex := self wordIndexFor: i.
	bitIndex  := self bitIndexFor: i.
	oldByte := bits at: wordIndex.

	bits
		at: wordIndex
		put: (newValue
			ifTrue:  [ oldByte bitOr:  (BitMasks at: bitIndex) ]
			ifFalse: [ oldByte bitAnd: (InversedBitMask at: bitIndex) ])
]

{ #category : 'accessing' }
BooleanArray >> atAllPut: aBoolean [
	
	bits atAllPut: (aBoolean ifTrue: [ WordOfOnes ] ifFalse: [ 0 ])
]

{ #category : 'accessing' }
BooleanArray >> atIntervalFrom: first to: last put: newValue [

	| indexOfFirstWord indexOfLastWord startBitIndex lastBitIndex |
	indexOfFirstWord := self wordIndexFor: first.
	indexOfLastWord  := self wordIndexFor: last.
	startBitIndex := self bitIndexFor: first.
	lastBitIndex  := self bitIndexFor: last.

	indexOfFirstWord = indexOfLastWord
		ifTrue: [
			self
				atWord: indexOfFirstWord
				fromBit: startBitIndex
				toBit: lastBitIndex
				put: newValue ]
		ifFalse: [
			self
				fromWord: indexOfFirstWord
				bit: startBitIndex
				toWord: indexOfLastWord
				bit: lastBitIndex
				put: newValue ]
]

{ #category : 'accessing' }
BooleanArray >> atWord: wordIndex fromBit: firstBitIndex toBit: lastBitIndex put: aBoolean [

	| newByte bit |
	newByte := bits at: wordIndex.
	bit := aBoolean asBit.
	
	firstBitIndex to: lastBitIndex do: [ :index |
		newByte := newByte bitAt: index put: bit ].
	
	bits at: wordIndex put: newByte
]

{ #category : 'initialization' }
BooleanArray >> bitIndexFor: i [

	^ ((i - 1) \\ WordSize) + 1
]

{ #category : 'accessing' }
BooleanArray >> bits [

	^ bits
]

{ #category : 'enumerating' }
BooleanArray >> do: aBlock [

	1 to: bits size - 1 do: [ :wordIndex |
		| word |
		word := bits at: wordIndex.
		1 to: WordSize do: [ :bitIndex |
			aBlock value: ((word bitAt: bitIndex) = 1) ] ].
	
	1 to: (self bitIndexFor: self size) do: [ :bitIndex |
		| word |
		word := bits last.
		aBlock value: ((word bitAt: bitIndex) = 1) ]
]

{ #category : 'accessing' }
BooleanArray >> fromWord: firstWordIndex bit: firstBitIndex toWord: lastWordIndex bit: lastBitIndex put: newValue [

	| fullWord |
	self
		atWord: firstWordIndex
		fromBit: firstBitIndex
		toBit: WordSize
		put: newValue.
	
	fullWord := newValue
		ifTrue: [ WordOfOnes ]
		ifFalse: [ 0 ].
	firstWordIndex + 1 to: lastWordIndex - 1 do: [ :index |
		bits at: index put: fullWord ].
	self
		atWord: lastWordIndex
		fromBit: 1
		toBit: lastBitIndex
		put: newValue
]

{ #category : 'initialization' }
BooleanArray >> initialize: bitSize [

	bits := ArrayClass new: (self wordIndexFor: bitSize).
	size := bitSize
]

{ #category : 'accessing' }
BooleanArray >> size [

	^ size
]

{ #category : 'initialization' }
BooleanArray >> wordIndexFor: i [

	^ ((i - 1) // WordSize) + 1
]
