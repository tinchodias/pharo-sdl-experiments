"
An AeSkylineAllocatorTest is a test class for testing the behavior of AeSkylineAllocator
"
Class {
	#name : #SkylinePackerTest,
	#superclass : #TestCase,
	#category : #'SDLExperiments-Tests'
}

{ #category : #tests }
SkylinePackerTest >> allocatedRandomRectanglesWith: random [

	| aPacker allocatedRectangles done |
	aPacker := SkylinePacker newWithExtent: 10000 asPoint.
	allocatedRectangles := OrderedCollection new.
	done := false.
	[	| w h extent |
		w := random nextIntegerBetween: 5 and: 1000.
		h := random nextIntegerBetween: 5 and: 500.
		extent := w @ h.

		aPacker
			allocateExtent: extent
			ifSuccess: [ :aPoint |
				allocatedRectangles add: (aPoint extent: extent) ]
			ifFailure: [
				done := true ].

		] doWhileFalse: [ done ].
	
	^ allocatedRectangles
]

{ #category : #tests }
SkylinePackerTest >> testAddDifferentHeightDoesNotMergeNodes [

	| aPacker allocatedPosition |
	aPacker := SkylinePacker newWithExtent: 50 @ 50.

	aPacker
		allocateExtent: 10@5
		ifSuccess: [ :aPoint | allocatedPosition := aPoint ]
		ifFailure: [ self fail ].
	aPacker
		allocateExtent: 20@6
		ifSuccess: [ :aPoint | allocatedPosition := aPoint ]
		ifFailure: [ self fail ].

	self assert: allocatedPosition equals: 10@0.
	self assert: aPacker nodes size equals: 3.
	"There was a merge due to same height (internal stuff)"

]

{ #category : #tests }
SkylinePackerTest >> testAddSameHeightDoesMergeNodes [

	| aPacker allocatedPosition |
	aPacker := SkylinePacker newWithExtent: 50 @ 50.

	aPacker
		allocateExtent: 10@5
		ifSuccess: [ :aPoint | allocatedPosition := aPoint ]
		ifFailure: [ self fail ].
	aPacker
		allocateExtent: 20@5
		ifSuccess: [ :aPoint | allocatedPosition := aPoint ]
		ifFailure: [ self fail ].

	self assert: allocatedPosition equals: 10@0.
	self assert: aPacker nodes size equals: 2.
	"There was a merge due to same height (internal stuff)"

]

{ #category : #tests }
SkylinePackerTest >> testAllocateEverything [

	| aPacker atlasExtent |
	atlasExtent := 50 @ 50.
	aPacker := SkylinePacker newWithExtent: atlasExtent.

	aPacker
		allocateExtent: atlasExtent
		ifSuccess: [ :aPoint |
			self assert: aPoint equals: 0@0 ]
		ifFailure: [ self fail ]

]

{ #category : #tests }
SkylinePackerTest >> testFillAllTall [

	| aPacker allocatedPosition |
	aPacker := SkylinePacker newWithExtent: 50 @ 100.

	aPacker
		allocateExtent: 50 asPoint
		ifSuccess: [ :aPoint | allocatedPosition := aPoint ]
		ifFailure: [ self fail ].

	self assert: allocatedPosition equals: 0@0.

	aPacker
		allocateExtent: 50 asPoint
		ifSuccess: [ :aPoint | allocatedPosition := aPoint ]
		ifFailure: [ self fail ].

	self assert: allocatedPosition equals: 0@50.

	aPacker
		allocateExtent: 1 asPoint
		ifSuccess: [ :aPoint | self fail ]
		ifFailure: [ allocatedPosition := #noSpace ].

	self assert: allocatedPosition equals: #noSpace
]

{ #category : #tests }
SkylinePackerTest >> testFillAllWide [

	| aPacker allocatedPosition |
	aPacker := SkylinePacker newWithExtent: 100 @ 50.

	aPacker
		allocateExtent: 50 asPoint
		ifSuccess: [ :aPoint | allocatedPosition := aPoint ]
		ifFailure: [ self fail ].

	self assert: allocatedPosition equals: 0@0.

	aPacker
		allocateExtent: 50 asPoint
		ifSuccess: [ :aPoint | allocatedPosition := aPoint ]
		ifFailure: [ self fail ].

	self assert: allocatedPosition equals: 50@0.

	aPacker
		allocateExtent: 1 asPoint
		ifSuccess: [ :aPoint | self fail ]
		ifFailure: [ allocatedPosition := #noSpace ].

	self assert: allocatedPosition equals: #noSpace
]

{ #category : #tests }
SkylinePackerTest >> testFuzzyAllocationsDoesNotIntersect [

	| rectangles aRandom |
	aRandom := Random new.
	'Random seed: ' trace.
	aRandom seed traceCr.

	rectangles := self allocatedRandomRectanglesWith: aRandom.
	
	rectangles
		combinations: 2
		atATimeDo: [:each |
			self deny: (each first intersects: each second) ]
]

{ #category : #tests }
SkylinePackerTest >> testNoSpace [

	| aPacker atlasExtent noSpace |
	atlasExtent := 50 @ 50.
	aPacker := SkylinePacker newWithExtent: atlasExtent.

	noSpace := false.
	aPacker
		allocateExtent: atlasExtent + (0 @ 1)
		ifSuccess: [ :aPoint | self fail ]
		ifFailure: [ noSpace := true ].
	self assert: noSpace.

	noSpace := false.
	aPacker
		allocateExtent: atlasExtent + (1 @ 0)
		ifSuccess: [ :aPoint | self fail ]
		ifFailure: [ noSpace := true ].
	self assert: noSpace.

]

{ #category : #tests }
SkylinePackerTest >> testSimpleAllocate [

	| aPacker allocatedPosition |
	aPacker := SkylinePacker newWithExtent: 50 @ 50.

	aPacker
		allocateExtent: 10@5
		ifSuccess: [ :aPoint | allocatedPosition := aPoint ]
		ifFailure: [ self fail ].

	self assert: allocatedPosition equals: 0@0.

]
