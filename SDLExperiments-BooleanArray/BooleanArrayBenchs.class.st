"
I know how to run benchmarks on a `BooleanArray`.
"
Class {
	#name : #BooleanArrayBenchs,
	#superclass : #Object,
	#instVars : [
		'arraySize'
	],
	#category : 'SDLExperiments-BooleanArray'
}

{ #category : #running }
BooleanArrayBenchs >> benchTag: aString with: aBlock [

	| benchResult |
	3 timesRepeat: [ Smalltalk garbageCollect ].

	benchResult := aBlock bench.

	('{1} ({2})' format: {
		benchResult frequency rounded asStringWithCommas.
		aString }) traceCr
]

{ #category : #running }
BooleanArrayBenchs >> runAll [
	<script: 'self new runAll'>

	arraySize := 5000.

	'--- size: ' trace.
	arraySize trace.
	'---' traceCr.
	
	'
Array:' traceCr.
	self runWith: Array.

"	'
BooleanArray w/DoubleWordArray (8 bytes):' traceCr.
	BooleanArray initializeFor: DoubleWordArray.
	self runWith: BooleanArray."

	'
BooleanArray w/WordArray (4 bytes):' traceCr.
	BooleanArray initializeFor: WordArray.
	self runWith: BooleanArray.

"	'
BooleanArray w/DoubleByteArray (2 bytes):' traceCr.
	BooleanArray initializeFor: DoubleByteArray.
	self runWith: BooleanArray.
"
	'
BooleanArray w/ByteArray (1 byte):' traceCr.
	BooleanArray initializeFor: ByteArray.
	self runWith: BooleanArray
]

{ #category : #running }
BooleanArrayBenchs >> runWith: anArrayedCollectionClass [

	| array source fuzzyParameters |
	array := anArrayedCollectionClass new: arraySize.
	source := Array new: arraySize withAll: true.
	1 to: arraySize do: [ :i | source at: i put: i even ].
	fuzzyParameters := Array new: arraySize streamContents: [ :stream |
		| random from to start |
		random := Random seed: 0.
		arraySize timesRepeat: [
			from := random nextIntegerBetween: 1 and: arraySize//3.
			to := random nextIntegerBetween: arraySize//3 and: arraySize//2.
			start := random nextIntegerBetween: 1 and: arraySize//3.
			stream nextPut: { from. to. start } ] ].

	self
		benchTag: #at:put:
		with: [
			1 to: arraySize do: [ :i |
				array at: i put: i even ] ].

	self
		benchTag: #at:
		with: [ 1 to: arraySize do: [ :i | array at: i ] ].

	"Assume array has true only at even positions"
	self
		benchTag: #do_heterogeneous
		with: [ array do: [ :each | ] ].

	self
		benchTag: #atAllPut:
		with: [ array atAllPut: true ].

	"Assume array has all true"
	self
		benchTag: #do_homogeneous
		with: [ array do: [ :each | ] ].

	self
		benchTag: #replaceFrom:to:withAll:
		with: [
			fuzzyParameters withIndexDo: [ :a :i |
				array
					replaceFrom: a first
					to: a second
					withAll: i even ] ].

	self
		benchTag: #replaceFrom:to:with:startingAt:
		with: [
			fuzzyParameters do: [ :a |
				array
					replaceFrom: a first
					to: a second
					with: source
					startingAt: a third ] ]

]
