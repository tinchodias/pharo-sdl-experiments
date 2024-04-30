Class {
	#name : 'ToBooleanArrayShiftTest',
	#superclass : 'TestCase',
	#category : 'SDLExperiments-BooleanArray',
	#package : 'SDLExperiments-BooleanArray'
}

{ #category : 'tests' }
ToBooleanArrayShiftTest >> test01TinyPositiveGap [

	| array |
	array := BooleanArray withAll: #(true false false).

	array toploShift: 1 startingAt: 3.
	self assert: (array as: Array) equals: #(true false false).

	array toploShift: 1 startingAt: 2.
	self assert: (array as: Array) equals: #(true false false).

	array toploShift: 1 startingAt: 1.
	self assert: (array as: Array) equals: #(false true false).

	array toploShift: 2 startingAt: 2.
	self assert: (array as: Array) equals: #(false false false).
	
	array
		at: 2 put: true;
		toploShift: 200 startingAt: 2.
	self assert: (array as: Array) equals: #(false false false)
]

{ #category : 'tests' }
ToBooleanArrayShiftTest >> test02TinyNegativeGap [

	| array |
	array := BooleanArray withAll: #(false false true).

	array toploShift: -1 startingAt: 3.
	self assert: (array as: Array) equals: #(false true false).

	array toploShift: -1 startingAt: 3.
	self assert: (array as: Array) equals: #(false true false).

	array toploShift: -2 startingAt: 1.
	self assert: (array as: Array) equals: #(false false false).

	array at: 3 put: true.
	array toploShift: -2 startingAt: 1.
	self assert: (array as: Array) equals: #(true false false).

	array toploShift: -200 startingAt: 1.
	self assert: (array as: Array) equals: #(false false false)

]

{ #category : 'tests' }
ToBooleanArrayShiftTest >> test03LargerPositiveGap [

	| array |
	array := BooleanArray new: BooleanArray wordSize * 2.
	array at: 1 put: true.

	"Shift true to end of first word"
	array toploShift: BooleanArray wordSize - 1 startingAt: 1.
	self deny:   (array at: BooleanArray wordSize - 1).
	self assert: (array at: BooleanArray wordSize).

	"Shift true to second word"
	array toploShift: 3 startingAt: 1.
	self deny:   (array at: BooleanArray wordSize).
	self assert: (array at: BooleanArray wordSize + 3).

	array toploShift: BooleanArray wordSize - 3 startingAt: BooleanArray wordSize.
	self assert: (array at: BooleanArray wordSize * 2).

	array toploShift: 5 startingAt: BooleanArray wordSize * 2.
	self deny: (array at: BooleanArray wordSize * 2)
]

{ #category : 'tests' }
ToBooleanArrayShiftTest >> test04LargerNegativeGap [

	| array |
	array := BooleanArray new: BooleanArray wordSize * 2.
	array at: BooleanArray wordSize + 3 put: true.
	
	array toploShift: -1 startingAt: 1.
	self deny:   (array at: BooleanArray wordSize + 3).
	self assert: (array at: BooleanArray wordSize + 2).

	array toploShift: -2 startingAt: BooleanArray wordSize.
	self deny:   (array at: BooleanArray wordSize + 2).
	self assert: (array at: BooleanArray wordSize).

	array toploShift: 1 - BooleanArray wordSize startingAt: 1.
	self deny:   (array at: BooleanArray wordSize).
	self assert: (array at: 1).
	
	array toploShift: -10 startingAt: 1.
	self deny: (array at: 1)

]

{ #category : 'tests' }
ToBooleanArrayShiftTest >> test05FuzzyShiftRight [

	self timeLimit: 2 minutes.
	
	1 to: 10000 by: 5 do: [ :arraySize |
		| random array baseline gap start |
		random := Random seed: 0.
		baseline := Array new: arraySize streamContents: [ :stream |
			arraySize timesRepeat: [
				stream nextPut: (random nextInteger: 1000) even ] ].
		baseline	at: arraySize put: true.
		array := BooleanArray withAll: baseline.

		"Apply same operation to both collections"		
		gap := random nextIntegerBetween: arraySize negated and: arraySize.
		start := random nextInteger: arraySize.
		baseline toploShift: gap startingAt: start.
		array toploShift: gap startingAt: start.
		
		"Compare they are equal"
		1 to: arraySize do: [ :index |
			self assert: (array at: index) equals: (baseline at: index) ]
		]
]
