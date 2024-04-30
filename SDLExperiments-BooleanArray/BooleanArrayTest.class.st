"
A BooleanArrayTest is a test class for testing the behavior of BooleanArray
"
Class {
	#name : #BooleanArrayTest,
	#superclass : #TestCase,
	#category : #'SDLExperiments-BooleanArray'
}

{ #category : #tests }
BooleanArrayTest >> testAt [

	| size array |
	size := 10.
	array := BooleanArray new: size.

	"Initialized as false"
	1 to: size do: [ :index |
		self deny: (array at: index) ]
]

{ #category : #tests }
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

{ #category : #tests }
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

{ #category : #tests }
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

{ #category : #tests }
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

{ #category : #tests }
BooleanArrayTest >> testGroupByRuns [

	| array groups |
	array := BooleanArray new: 5.
	array at: 1 put: true.
	array at: 2 put: true.
	array at: 3 put: false.
	array at: 4 put: false.
	array at: 5 put: true.
	
	groups := array groupByRuns: [ :each | each ].
	
	self assert: groups equals: #(#(true true) #(false false) #(true))
]

{ #category : #tests }
BooleanArrayTest >> testIncludesTrueStartingAt [

	| array |
	array := BooleanArray withAll: #(false true false).
	self assert: (array includesTrueStartingAt: 1).
	self assert: (array includesTrueStartingAt: 2).
	self deny: (array includesTrueStartingAt: 3).

	array := BooleanArray new: BooleanArray wordSize + 2.
	1 to: BooleanArray wordSize do: [ :index |
		self deny: (array includesTrueStartingAt: index) ].
	self deny: (array includesTrueStartingAt: BooleanArray wordSize + 1).
	self deny: (array includesTrueStartingAt: BooleanArray wordSize + 2).

	array at: 5 put: true.
	1 to: 5 do: [ :index |
		self assert: (array includesTrueStartingAt: index) ].
	6 to: BooleanArray wordSize do: [ :index |
		self deny: (array includesTrueStartingAt: index) ].


	array at: BooleanArray wordSize + 1 put: true.
	1 to: BooleanArray wordSize do: [ :index |
		self assert: (array includesTrueStartingAt: index) ].
	self assert: (array includesTrueStartingAt: BooleanArray wordSize + 1).
	self deny:   (array includesTrueStartingAt: BooleanArray wordSize + 2)

]

{ #category : #tests }
BooleanArrayTest >> testIndexOfTrueIfAbsent [

	| size array absent result |
	size := 50.
	array := BooleanArray new: size.

	absent := false.
	result := array indexOfTrueIfAbsent: [ absent := true. #no ].
	self assert: absent.
	self assert: result equals: #no.

	absent := false.
	array at: 7 put: true.
	array at: 49 put: true.
	result := array indexOfTrueIfAbsent: [ absent := true ].
	self deny: absent.
	self assert: result equals: 7.

	array at: 7 put: false.
	result := array indexOfTrueIfAbsent: [ absent := true ].
	self deny: absent.
	self assert: result equals: 49
]

{ #category : #tests }
BooleanArrayTest >> testIsEmpty [

	self assert: (BooleanArray new: 0) isEmpty.
	self deny:   (BooleanArray new: 1) isEmpty.
]

{ #category : #tests }
BooleanArrayTest >> testLastIndexOfTrueIfAbsent [

	| size array absent result |
	size := 50.
	array := BooleanArray new: size.

	absent := false.
	result := array lastIndexOfTrueIfAbsent: [ absent := true. #hi ].
	self assert: absent.
	self assert: result equals: #hi.

	absent := false.
	array at: 7 put: true.
	array at: 49 put: true.
	result := array lastIndexOfTrueIfAbsent: [ absent := true ].
	self deny: absent.
	self assert: result equals: 49.

	array at: 49 put: false.
	result := array lastIndexOfTrueIfAbsent: [ absent := true ].
	self deny: absent.
	self assert: result equals: 7
]

{ #category : #tests }
BooleanArrayTest >> testReplaceFromToWithAll [

	0 to: 100 by: 7 do: [ :size |
		| array middleIndex |
		array := BooleanArray new: size.
		middleIndex := 1 max: (size // 2).
		array replaceFrom: 1 to: middleIndex withAll: true.

		1 to: middleIndex do: [ :index |
			self assert: (array at: index) ].
		middleIndex+1 to: size do: [ :index |
			self deny: (array at: index) ] ]
]

{ #category : #tests }
BooleanArrayTest >> testReplaceFromToWithStartingAt [

	| multiplesOf5 booleans size baseline random |
	size := 5000.

	multiplesOf5 := Array new: size.
	1 to: multiplesOf5 size do: [ :index |
		multiplesOf5 at: index put: ((index % 5) = 0) ].

	baseline := Array 	new: size withAll: false.
	booleans := BooleanArray new: size.

	"Test a simple and concrete case"
	baseline replaceFrom: 2 to: 50 with: multiplesOf5 startingAt: 3.
	booleans replaceFrom: 2 to: 50 with: multiplesOf5 startingAt: 3.
	baseline with: booleans do: [ :a :b | self assert: a equals: b ].

	"Test with some fuzziness"
	random := Random seed: 0.
	500 timesRepeat: [ 
		| from to start |
		from  := random nextIntegerBetween: 1 and: size//2.
		to    := random nextIntegerBetween: 1 and: size//2.
		start := random nextIntegerBetween: 1 and: size//2.

		baseline
			replaceFrom: from
			to: to
			with: multiplesOf5
			startingAt: start.
		booleans
			replaceFrom: from
			to: to
			with: multiplesOf5
			startingAt: start.

		baseline
			with: booleans
			do: [ :a :b | self assert: a equals: b ] ].	

]

{ #category : #tests }
BooleanArrayTest >> testSize [

	0 to: 10 do: [ :size |
		self assert: (BooleanArray new: size) size equals: size ]
]

{ #category : #tests }
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

{ #category : #tests }
BooleanArrayTest >> testWithAll [

	| array |
	array := BooleanArray withAll: #().
	self assert: array size equals: 0.

	array := BooleanArray withAll: #(true false false true false).
	self assert: array size equals: 5.
	self assert: (array at: 1).
	self deny:   (array at: 2).
	self deny:   (array at: 3).
	self assert: (array at: 4).
	self deny:   (array at: 5).
	
	"Test with a pattern that doesn't match with word size"
	array := BooleanArray withAll: ((1 to: 100) collect: [ :i | (i % 5) = 0 ]).
	1 to: 100 do: [ :i | self assert: (array at: i) equals: (i % 5) = 0 ].

	array := BooleanArray withAll: (Array new: 1000 withAll: true).
	1 to: 1000 do: [ :i | self assert: (array at: i) ]
]

{ #category : #tests }
BooleanArrayTest >> testWithStartStopAndValueDo [

	| array booleans indexIntervals |
	array :=
		BooleanArray withAll:
			#(true false false true true true false false).

	booleans := OrderedCollection new.
	indexIntervals := OrderedCollection new.
	array withStartStopAndValueDo: [ :start :stop :value |
		booleans add: value.
		indexIntervals add: (start to: stop)].

	self
		assert: booleans asArray
		equals: #(true false true false).
	self
		assert: indexIntervals asArray
		equals: {
			1 to: 1.
			2 to: 3.
			4 to: 6.
			7 to: 8 }
]
