Class {
	#name : 'BooleanArrayBenchs',
	#superclass : 'Object',
	#instVars : [
		'arraySize'
	],
	#category : 'SDLExperiments-BooleanArray',
	#package : 'SDLExperiments-BooleanArray'
}

{ #category : 'running' }
BooleanArrayBenchs >> benchTag: aString with: aBlock [

	| benchResult |
	benchResult := aBlock bench.

	('{1} ({2})' format: {
		benchResult frequency rounded asStringWithCommas.
		aString }) traceCr
]

{ #category : 'running' }
BooleanArrayBenchs >> runAll [
	<script: 'self new runAll'>

	arraySize := 1000.

	'--- size: ' trace.
	arraySize trace.
	'---' traceCr.
	
	'
Array (8 bytes):' traceCr.
	self runWith: Array.

	'
BooleanArray w/DoubleWordArray (8 bytes):' traceCr.
	BooleanArray initializeFor: DoubleWordArray.
	self runWith: BooleanArray.

	'
BooleanArray w/WordArray (4 bytes):' traceCr.
	BooleanArray initializeFor: WordArray.
	self runWith: BooleanArray.

	'
BooleanArray w/DoubleByteArray (2 bytes):' traceCr.
	BooleanArray initializeFor: DoubleByteArray.
	self runWith: BooleanArray.

	'
BooleanArray w/ByteArray (1 byte):' traceCr.
	BooleanArray initialize. "ByteArray by default"
	self runWith: BooleanArray
]

{ #category : 'running' }
BooleanArrayBenchs >> runWith: anArrayedCollectionClass [

	| array |
	array := anArrayedCollectionClass new: arraySize.

	"Assume array has all false"
	self
		benchTag: #do_homogeneous
		with: [
			| count |
			count := 0.
			array do: [ :each | count := count + 1 ].
			self assert: count = arraySize ].
	
	self
		benchTag: #atAllPut:
		with: [
			array atAllPut: true.
			array atAllPut: false ].

	self
		benchTag: #at:put:
		with: [
			1 to: arraySize do: [ :i | array at: i put: i even ] ].

	"Assume array has true only at even positions"
	self
		benchTag: #do_heterogeneous
		with: [
			| count |
			count := 0.
			array do: [ :each | each ifTrue: [count := count + 1] ].
			self assert: count = (arraySize // 2) ].

	self
		benchTag: #at:
		with: [
			1 to: arraySize do: [ :i | array at: i ] ].

	self
		benchTag: #atIntervalFrom:to:put:
		with: [
			1 to: arraySize // 2 do: [ :i |
				array
					atIntervalFrom: i
					to: i + (arraySize // 2)
					put: i even ] ]
]
