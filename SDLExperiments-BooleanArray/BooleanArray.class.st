"
I'm an arrayed collection of Boolean values with a compact representation where each boolean value maps to a bit.
"
Class {
	#name : 'BooleanArray',
	#superclass : 'Object',
	#instVars : [
		'size',
		'words'
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

	^ self basicNew
		initialize: size;
		yourself
]

{ #category : 'instance creation' }
BooleanArray class >> withAll: aCollection [

	| result |
	result := self new: aCollection size.
	aCollection withIndexDo: [ :each :index |
		result at: index put: each ].
	^ result
]

{ #category : 'comparing' }
BooleanArray >> = anObject [
	"Answer whether the receiver and anObject represent the same object."

	self == anObject ifTrue: [ ^ true ].
	self class = anObject class ifFalse: [ ^ false ].
	^ words = anObject words
]

{ #category : 'accessing' }
BooleanArray >> at: index [

	| wordIndex bitIndex |
	wordIndex := self wordIndexFor: index.
	bitIndex := self bitIndexFor: index wordIndex: wordIndex.
	^ self valueOf: (words at: wordIndex) at: bitIndex
]

{ #category : 'accessing' }
BooleanArray >> at: index put: newValue [

	| wordIndex bitIndex word |
	wordIndex := self wordIndexFor: index.
	bitIndex  := self bitIndexFor: index wordIndex: wordIndex.
	word := words at: wordIndex.

	words
		at: wordIndex
		put: (newValue
			ifTrue:  [ word bitOr:  (BitMasks at: bitIndex) ]
			ifFalse: [ word bitAnd: (InversedBitMask at: bitIndex) ])
]

{ #category : 'accessing' }
BooleanArray >> atAllPut: aBoolean [
	
	words atAllPut: (aBoolean ifTrue: [ WordOfOnes ] ifFalse: [ 0 ])
]

{ #category : 'private' }
BooleanArray >> atLastWordDo: aBlock [
	"Enumerate all booleans in the last word of the internal representation (some bits may be ignored)."

	| word |
	word := words last.
	(self bitIndexFor: self size wordIndex: words size) timesRepeat: [
		aBlock value: (word bitAnd: 1) ~= 0.
		word := (word bitShift: -1) ]
]

{ #category : 'enumerating' }
BooleanArray >> atNonLastWord: wordIndex do: aBlock [
	"Enumerate all booleans in certain word of the internal representation (assuming it's not last word)."

	| word |
	word := words at: wordIndex.

	word = 0 ifTrue: [
		WordSize timesRepeat: [ aBlock value: false ]. ^self ].

	word = WordOfOnes ifTrue: [
		WordSize timesRepeat: [ aBlock value: true ]. ^self ].

	WordSize timesRepeat: [
		aBlock value: (word bitAnd: 1) ~= 0.
		word := (word bitShift: -1) ]
]

{ #category : 'private' }
BooleanArray >> atWord: wordIndex fromBit: firstBitIndex toBit: lastBitIndex put: aBoolean [

	| newByte |
	newByte := words at: wordIndex.
	
	aBoolean
		ifTrue: [
			firstBitIndex to: lastBitIndex do: [ :index |
				newByte := newByte bitOr: (BitMasks at: index) ] ]
		ifFalse: [
			firstBitIndex to: lastBitIndex do: [ :index |
				newByte := newByte bitAnd: (InversedBitMask at: index) ] ].
	
	words at: wordIndex put: newByte
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

{ #category : 'enumerating' }
BooleanArray >> do: aBlock [

	1 to: words size - 1 do: [ :index |
		self atNonLastWord: index do: aBlock ].

	self atLastWordDo: aBlock
]

{ #category : 'private' }
BooleanArray >> fromWord: firstWordIndex bit: firstBitIndex toWord: lastWordIndex bit: lastBitIndex put: aBoolean [

	| fullWord |
	"Replace first word"
	self
		atWord: firstWordIndex
		fromBit: firstBitIndex
		toBit: WordSize
		put: aBoolean.

	"Fast replace words in the middle"
	fullWord := aBoolean ifTrue: [ WordOfOnes ] ifFalse: [ 0 ].
	firstWordIndex + 1 to: lastWordIndex - 1 do: [ :index |
		words at: index put: fullWord ].

	"Replace last word"
	self
		atWord: lastWordIndex
		fromBit: 1
		toBit: lastBitIndex
		put: aBoolean
]

{ #category : 'enumerating' }
BooleanArray >> groupByRuns: selectBlock [

	^ Array streamContents: [ :stream |
		self
			groupByRuns: selectBlock
			do: [ :group | stream nextPut: group ] ]
]

{ #category : 'enumerating' }
BooleanArray >> groupByRuns: aBlock do: outputBlock [

	| buffer r |
	r := nil.
	buffer := Array new writeStream.

	self do: [ :e |
		| t |
		t := aBlock value: e.
		t = r ifFalse: [
			r := t.
			buffer isEmpty ifFalse: [
				outputBlock value: buffer contents.
				buffer reset ] ].
		buffer nextPut: e ].

	"There may be a last group to output"
	buffer isEmpty ifFalse: [ outputBlock value: buffer contents ]
]

{ #category : 'comparing' }
BooleanArray >> hash [
	"Answer an integer value that is related to the identity of the receiver."

	^ words hash
]

{ #category : 'initialization' }
BooleanArray >> initialize: bitSize [

	"To avoid checks, ensure the array has at least one word"
	words := ArrayClass new: ((self wordIndexFor: bitSize) max: 1).
	size := bitSize
]

{ #category : 'copying' }
BooleanArray >> postCopy [

	words := words copy
]

{ #category : 'accessing' }
BooleanArray >> replaceFrom: start to: stop withAll: aBoolean [
	"Dstructively replace with a boolean from start to stop."

	| indexOfFirstWord indexOfLastWord startBitIndex lastBitIndex |
	indexOfFirstWord := self wordIndexFor: start.
	startBitIndex := self bitIndexFor: start wordIndex: indexOfFirstWord.

	indexOfLastWord  := self wordIndexFor: stop.
	lastBitIndex  := self bitIndexFor: stop wordIndex: indexOfLastWord.

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

{ #category : 'private' }
BooleanArray >> words [
	"Answer an array that is my internal representation for booleans."

	^ words
]
