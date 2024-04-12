Class {
	#name : 'CrRTreeTest',
	#superclass : 'TestCase',
	#category : 'SDLExperiments-RTree',
	#package : 'SDLExperiments-RTree'
}

{ #category : 'tests' }
CrRTreeTest >> test01SingleNode [

	| rtree aRectangle |
	aRectangle := CrBounds origin: 1@2 extent: 3@4.

	rtree := CrRTree withAll: { aRectangle }.
	
	self assert: rtree bounds equals: aRectangle.
	self
		assert: (rtree search: (CrBounds origin: 5@4 extent: 1@1))
		equals: #().
	self
		assert: (rtree search: (CrBounds origin: 1@2 extent: 1@1))
		equals: #(1).

]

{ #category : 'tests' }
CrRTreeTest >> test02SomeNodes [

	| rectangles rtree |
	rectangles := OrderedCollection new.
	1 to: 4 do: [ :y |
		1 to: 4 do: [ :x |
			rectangles add: (CrBounds origin: x@y extent: 1@1) ] ].

	rtree := CrRTree withAll: rectangles.
	
	self assert: rtree bounds equals: (CrBounds origin: 1@1 extent: 4@4).
	self
		assert: (rtree search: (CrBounds origin: 1@1 extent: 2@1))
		equals: #(1 2).
	self
		assert: (rtree search: (CrBounds origin: 3@3 extent: 2@2))
		equals: #(11 12 15 16)
]

{ #category : 'tests' }
CrRTreeTest >> test03NonOverlappingNodes [

	| rectangles rtree results |
	rectangles := OrderedCollection new.
	1 to: 50 do: [ :y |
		1 to: 50 do: [ :x |
			rectangles add: (CrBounds origin: (x-1)@(y-1) extent: 1@1) ] ].

	rtree := CrRTree withAll: rectangles.

	"Note: The results have to be sorted"
	results := rtree search: (Rectangle origin: 0@0 corner: 50@50).
	self assert: results size equals: 2500.
	self assert: results equals: (1 to: results size).

	results := rtree search: (Rectangle origin: 0@0 corner: 50@49).
	self assert: results size equals: 2450.
	self assert: results equals: (1 to: results size).

	results := rtree search: (Rectangle origin: 5@6 extent: 1@1).
	self assert: results size equals: 1.
	self assert: results first equals: 1 + (6*50) + 5
]

{ #category : 'tests' }
CrRTreeTest >> test04OverlappingNodes [

	| rectangles rtree results |
	rectangles := OrderedCollection new.
	1 to: 50 do: [ :h |
		1 to: 50 do: [ :w |
			rectangles add: (CrBounds origin: 0@0 extent: w@h) ] ].

	rtree := CrRTree withAll: rectangles.

	"Both the checks for the elements assume elements are sorted."
	results := rtree search: (Rectangle origin: 0@0 extent: 1@1).
	self assert: results size equals: 2500.
	self assert: results equals: (1 to: results size).

	results := rtree search: (Rectangle origin: 0@49 extent: 1@1).
	self assert: results size equals: 50.
	self assert: results equals: (2451 to: 2500)
]
