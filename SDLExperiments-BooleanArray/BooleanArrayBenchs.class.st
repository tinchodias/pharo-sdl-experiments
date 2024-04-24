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
Array:' traceCr.
	self runWith: Array.

	'
BooleanArray w/DoubleWordArray:' traceCr.
	BooleanArray initializeFor: DoubleWordArray.
	self runWith: BooleanArray.

	'
BooleanArray w/WordArray:' traceCr.
	BooleanArray initializeFor: WordArray.
	self runWith: BooleanArray.

	'
BooleanArray w/DoubleByteArray:' traceCr.
	BooleanArray initializeFor: DoubleByteArray.
	self runWith: BooleanArray.

	'
BooleanArray w/ByteArray:' traceCr.
	BooleanArray initialize. "ByteArray by default"
	self runWith: BooleanArray
]

{ #category : 'running' }
BooleanArrayBenchs >> runWith: anArrayedCollectionClass [

	| array |
	array := anArrayedCollectionClass new: arraySize.
	
	self
		benchTag: #atAllPut:
		with: [
			array atAllPut: true.
			array atAllPut: false ].

	self
		benchTag: #at:put:
		with: [
			1 to: arraySize do: [ :i | array at: i put: i even ] ].

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
