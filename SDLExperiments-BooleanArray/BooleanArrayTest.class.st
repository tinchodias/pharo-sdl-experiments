"
A BooleanArrayTest is a test class for testing the behavior of BooleanArray
"
Class {
	#name : 'BooleanArrayTest',
	#superclass : 'TestCase',
	#category : 'SDLExperiments-BooleanArray',
	#package : 'SDLExperiments-BooleanArray'
}

{ #category : 'tests' }
BooleanArrayTest >> test1 [

	| testItemSize testArray r randomIndices |
	testItemSize := 10000.
	testArray := BooleanArray new: testItemSize.

	r := Random seed: 7.
	randomIndices := (1 to: testItemSize // 2)
		collect: [ :_ | r nextIntegerBetween: 1 and: testItemSize ].

	randomIndices do: [ :i | 
		testArray at: i put: 1 ].

	1 to: testItemSize do: [ :i |
		| actual |
		actual := testArray at: i.
		(randomIndices includes: i)
			ifTrue: [ self assert: actual = 1 ]
			ifFalse: [ self assert: actual = 0 ] ]
]

{ #category : 'tests' }
BooleanArrayTest >> testExtremes [

	| testItemSize testArray |
	testItemSize := 1.
	testArray := BooleanArray new: testItemSize.

	testArray at: 1 put: 1.
	self assert: testArray bits equals: #[2]
]

{ #category : 'tests' }
BooleanArrayTest >> testExtremes2 [

	| testItemSize testArray |
	testItemSize := 2.
	testArray := BooleanArray new: testItemSize.

	testArray at: testItemSize put: 1.
	self assert: testArray bits equals: #[4].

	testArray at: 1 put: 1.
	self assert: testArray bits equals: #[6]

]

{ #category : 'tests' }
BooleanArrayTest >> testExtremes3 [

	| testItemSize testArray |
	testItemSize := 15.
	testArray := BooleanArray new: testItemSize.

	testArray at: testItemSize put: 1.
	self assert: testArray bits equals: #[0 128].

	testArray at: 1 put: 1.
	self assert: testArray bits equals: #[2 128]

]
