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
BooleanArrayTest >> testAt [

	| size array |
	size := 10.
	array := BooleanArray new: size.

	"Initialized as false"
	1 to: size do: [ :index |
		self deny: (array at: index) ]
]

{ #category : 'tests' }
BooleanArrayTest >> testAtAllPut [

	| size array |
	size := 50.
	array := BooleanArray new: size.

	"Set true at all"
	array atAllPut: true.

	"Assert it's all true"
	1 to: size do: [ :index |
		self assert: (array at: index) ].

	"Set false at all positions, again."
	array atAllPut: false.

	"All false"
	1 to: size do: [ :index |
		self deny: (array at: index) ]
]

{ #category : 'tests' }
BooleanArrayTest >> testAtIntervalFromToPut [

	1 to: 100 do: [ :size |
		| array middleIndex |
		array := BooleanArray new: size.
		middleIndex := 1 max: (size // 2).
		array atIntervalFrom: 1 to: middleIndex put: true.

		1 to: middleIndex do: [ :index |
			self assert: (array at: index) ].
		middleIndex+1 to: size do: [ :index |
			self deny: (array at: index) ] ]
]

{ #category : 'tests' }
BooleanArrayTest >> testAtPut [

	| size array |
	size := 10.
	array := BooleanArray new: size.

	"It's initialized as all false"
	1 to: size do: [ :index |
		self deny: (array at: index) ].

	"Set all to true"
	1 to: size do: [ :index |
		array at: index put: true ].

	"It's all set to true"
	1 to: size do: [ :index |
		self assert: (array at: index) ].

]

{ #category : 'tests' }
BooleanArrayTest >> testCopy [

	| size original copy |
	size := 1.
	original := BooleanArray new: size.
	
	copy := original copy.

	self assert: copy size equals: 1.
	self assert: copy equals: original.
	
	copy at: 1 put: true.

	self deny: (original at: 1).
	self assert: (copy at: 1).
	self deny: copy equals: original.
]

{ #category : 'tests' }
BooleanArrayTest >> testDo [

	1 to: 100 do: [ :size |
		| array booleans |
		array := BooleanArray new: size.

		"It's all false after instance creation"
		booleans := Array streamContents: [ :stream |
			array do: [ :each | stream nextPut: each ] ].
		self assert: booleans size equals: size.
		booleans do: [ :each | self deny: each ].

		"Set true at even indices"
		1 to: size do: [ :index |
			array at: index put: index even ].
		booleans := Array streamContents: [ :stream |
			array do: [ :each | stream nextPut: each ] ].
		booleans withIndexDo: [ :each :index |
			self assert: each equals: index even ] ]
]

{ #category : 'tests' }
BooleanArrayTest >> testExtremesSize1 [

	| testItemSize testArray |
	testItemSize := 1.
	testArray := BooleanArray new: testItemSize.

	testArray at: 1 put: true.
	self assert: testArray bits equals: #[1]
]

{ #category : 'tests' }
BooleanArrayTest >> testExtremesSize15 [

	| testItemSize testArray |
	testItemSize := 15.
	testArray := BooleanArray new: testItemSize.

	testArray at: testItemSize put: true.
	self assert: testArray bits equals: #[0 64].

	testArray at: 1 put: true.
	self assert: testArray bits equals: #[1 64]

]

{ #category : 'tests' }
BooleanArrayTest >> testExtremesSize2 [

	| testItemSize testArray |
	testItemSize := 2.
	testArray := BooleanArray new: testItemSize.

	testArray at: testItemSize put: true.
	self assert: testArray bits equals: #[2].

	testArray at: 1 put: true.
	self assert: testArray bits equals: #[3]

]

{ #category : 'tests' }
BooleanArrayTest >> testSize [

	1 to: 10 do: [ :size |
		self assert: (BooleanArray new: size) size equals: size ]
]

{ #category : 'tests' }
BooleanArrayTest >> testStress [

	| testItemSize testArray r randomIndices |
	testItemSize := 10000.
	testArray := BooleanArray new: testItemSize.

	r := Random seed: 7.
	randomIndices := (1 to: testItemSize // 2)
		collect: [ :_ | r nextIntegerBetween: 1 and: testItemSize ].

	randomIndices do: [ :i | 
		testArray at: i put: true ].

	1 to: testItemSize do: [ :i |
		| actual |
		actual := testArray at: i.
		(randomIndices includes: i)
			ifTrue: [ self assert: actual ]
			ifFalse: [ self deny: actual ] ]
]
