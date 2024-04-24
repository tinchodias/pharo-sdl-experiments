"
I'm an Array of Boolean values.
"
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

	WordOfOnes := 0.
	WordSize timesRepeat: [
		WordOfOnes := WordOfOnes bitShift: 1.
		WordOfOnes := WordOfOnes bitOr: 1 ].
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
BooleanArray >> at: index [

	| wordIndex bitIndex |
	wordIndex := self wordIndexFor: index.
	bitIndex := self bitIndexFor: index wordIndex: wordIndex.
	^ self valueOf: (bits at: wordIndex) at: bitIndex
]

{ #category : 'accessing' }
BooleanArray >> at: index put: newValue [

	| wordIndex bitIndex word |
	wordIndex := self wordIndexFor: index.
	bitIndex  := self bitIndexFor: index wordIndex: wordIndex.
	word := bits at: wordIndex.

	bits
		at: wordIndex
		put: (newValue
			ifTrue:  [ word bitOr:  (BitMasks at: bitIndex) ]
			ifFalse: [ word bitAnd: (InversedBitMask at: bitIndex) ])
]

{ #category : 'accessing' }
BooleanArray >> atAllPut: aBoolean [
	
	bits atAllPut: (aBoolean ifTrue: [ WordOfOnes ] ifFalse: [ 0 ])
]

{ #category : 'accessing' }
BooleanArray >> atIntervalFrom: first to: last put: aBoolean [

	| indexOfFirstWord indexOfLastWord startBitIndex lastBitIndex |
	indexOfFirstWord := self wordIndexFor: first.
	startBitIndex := self bitIndexFor: first wordIndex: indexOfFirstWord.

	indexOfLastWord  := self wordIndexFor: last.
	lastBitIndex  := self bitIndexFor: last wordIndex: indexOfLastWord.

	indexOfFirstWord = indexOfLastWord
		ifTrue: [
			self
				atWord: indexOfFirstWord
				fromBit: startBitIndex
				toBit: lastBitIndex
				put: aBoolean ]
		ifFalse: [
			self
				fromWord: indexOfFirstWord
				bit: startBitIndex
				toWord: indexOfLastWord
				bit: lastBitIndex
				put: aBoolean ]
]

{ #category : 'private' }
BooleanArray >> atWord: wordIndex fromBit: firstBitIndex toBit: lastBitIndex put: aBoolean [

	| newByte |
	newByte := bits at: wordIndex.
	
	aBoolean
		ifTrue: [
			firstBitIndex to: lastBitIndex do: [ :index |
				newByte := newByte bitOr: (BitMasks at: index) ] ]
		ifFalse: [
			firstBitIndex to: lastBitIndex do: [ :index |
				newByte := newByte bitAnd: (InversedBitMask at: index) ] ].
	
	bits at: wordIndex put: newByte
]

{ #category : 'private' }
BooleanArray >> bitIndexFor: index [
	"Answer the bit index that corresponds to an index of this boolean array."

	^ ((index - 1) \\ WordSize) + 1
]

{ #category : 'private' }
BooleanArray >> bitIndexFor: index wordIndex: wordIndex [
	"Same as bitIndexFor: but faster."

	^ index - ((wordIndex - 1) * WordSize)
]

{ #category : 'private' }
BooleanArray >> bits [

	^ bits
]

{ #category : 'enumerating' }
BooleanArray >> do: aBlock [

	| word |
	1 to: bits size - 1 do: [ :wordIndex |
		word := bits at: wordIndex.
		1 to: WordSize do: [ :bitIndex |
			aBlock value: (self valueOf: word at: bitIndex) ] ].

	word := bits last.
	1 to: (self bitIndexFor: self size wordIndex: bits size)
		do: [ :bitIndex |
			aBlock value: (self valueOf: word at: bitIndex) ]
]

{ #category : 'private' }
BooleanArray >> fromWord: firstWordIndex bit: firstBitIndex toWord: lastWordIndex bit: lastBitIndex put: aBoolean [

	| fullWord |
	self
		atWord: firstWordIndex
		fromBit: firstBitIndex
		toBit: WordSize
		put: aBoolean.
	
	fullWord := aBoolean ifTrue: [ WordOfOnes ] ifFalse: [ 0 ].
	firstWordIndex + 1 to: lastWordIndex - 1 do: [ :index |
		bits at: index put: fullWord ].

	self
		atWord: lastWordIndex
		fromBit: 1
		toBit: lastBitIndex
		put: aBoolean
]

{ #category : 'initialization' }
BooleanArray >> initialize: bitSize [

	bits := ArrayClass new: (self wordIndexFor: bitSize).
	size := bitSize
]

{ #category : 'copying' }
BooleanArray >> postCopy [

	bits := bits copy
]

{ #category : 'accessing' }
BooleanArray >> size [

	^ size
]

{ #category : 'private' }
BooleanArray >> valueOf: word at: bitIndex [

	^ ((word bitShift: 1 - bitIndex) bitAnd: 1) ~= 0
]

{ #category : 'private' }
BooleanArray >> wordIndexFor: i [

	^ ((i - 1) // WordSize) + 1
]
