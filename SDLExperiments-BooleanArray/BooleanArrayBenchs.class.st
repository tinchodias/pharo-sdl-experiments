"
I know how to run benchmarks on a `BooleanArray`.
"
Class {
	#name : #BooleanArrayBenchs,
	#superclass : #Object,
	#instVars : [
		'arraySize',
		'arrayedCollectionClass'
	],
	#category : #'SDLExperiments-BooleanArray'
}

{ #category : #running }
BooleanArrayBenchs >> benchAll [

	| array source fuzzyParameters |
	array := arrayedCollectionClass new: arraySize.
	source := Array new: arraySize.
	1 to: arraySize do: [ :i | source at: i put: i even ].
	fuzzyParameters := Array streamContents: [ :stream |
		| random |
		random := Random seed: 0.
		50 timesRepeat: [
			| from to start |
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
					startingAt: a third ] ].

	self
		benchTag: #shift
		with: [
			array
				shiftRightBy: 65
				startingAt: 1
				fillWithAll: false.
			array
				shiftLeftBy: 65
				startingAt: 1
				fillWithAll: false ]
]

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

	arraySize := 100000.

	'--- size: ' trace.
	arraySize trace.
	'---' traceCr.
	
	'
Array:' traceCr.
	arrayedCollectionClass := Array.
	self benchAll.

	'
BooleanArray w/WordArray:' traceCr.
	BooleanArray initializeFor: WordArray.
	arrayedCollectionClass := BooleanArray.
	self benchAll.

]
