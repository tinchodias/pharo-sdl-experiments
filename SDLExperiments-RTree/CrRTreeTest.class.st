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

	rtree := CrRTree new.
	rtree loadAll: { aRectangle }.
	
	self assert: rtree bounds equals: aRectangle.
	self
		assert: (rtree search: (CrBounds origin: 5@4 extent: 1@1))
		equals: #().
	self
		assert: (rtree search: (CrBounds origin: 1@2 extent: 1@1))
		equals: #(1).

]

{ #category : 'tests' }
CrRTreeTest >> test02TwoNodes [

	| rtree rectangleA rectangleB |
	rectangleA := CrBounds origin: 1@2 corner: 3@4.
	rectangleB := CrBounds origin: 3@4 corner: 5@6.

	rtree := CrRTree new.
	rtree loadAll: { rectangleA. rectangleB }.
	
	self assert: rtree bounds equals: (rectangleA merge: rectangleB).
	self
		assert: (rtree search: (CrBounds origin: 1@2 extent: 1@1))
		equals: #(1).
	self
		assert: (rtree search: (CrBounds origin: 3@4 corner: 5@6))
		equals: #(1 2)

]

{ #category : 'tests' }
CrRTreeTest >> test03NoOverlap [

	| rectangles rtree results |
	rectangles := OrderedCollection new.
	1 to: 50 do: [ :y |
		1 to: 50 do: [ :x |
			rectangles add: (CrBounds origin: (x-1)@(y-1) extent: 1@1) ] ].

	rtree := CrRTree new.
	rtree loadAll: rectangles.

	"Note: The results have to be sorted"
	results := rtree search: (Rectangle origin: 0@0 corner: 50@50).
	self assert: results size equals: 2500.
	self assert: results equals: (1 to: results size).

	results := rtree search: (Rectangle origin: 0@0 corner: 50@49).
	self assert: results size equals: 2450.
	self assert: results equals: (1 to: results size).

	results := rtree search: (Rectangle origin: 5@6 extent: 1@1).
	self assert: results size equals: 1.
	self assert: results first equals: (6*50) + 5
]

{ #category : 'tests' }
CrRTreeTest >> test04Overlap [

	| rectangles rtree results |
	rectangles := OrderedCollection new.
	1 to: 50 do: [ :h |
		1 to: 50 do: [ :w |
			rectangles add: (CrBounds origin: 0@0 extent: w@h) ] ].

	rtree := CrRTree new.
	rtree loadAll: rectangles.

	"Both the checks for the elements assume elements are sorted."
	results := rtree search: (Rectangle origin: 0@0 extent: 1@1).
	self assert: results size equals: 2500.
	self assert: results equals: (1 to: results size).

	results := rtree search: (Rectangle origin: 0@49 extent: 1@1).
	self assert: results size equals: 50.
	self assert: results equals: (2450 to: results size)
]

{ #category : 'tests' }
CrRTreeTest >> test05Add100kNodesIsFast [
	
	| rectangles rtree |
	self timeLimit: 2 second.
	
	rectangles := OrderedCollection new.
	1 to: 1000 do: [ :x |
		1 to: 1000 do: [ :y |
			rectangles add: (CrBounds origin: x@y extent: 1@1) ] ].

	rtree := CrRTree new.
	rtree loadAll: rectangles.
	
	self assert: rtree bounds equals: (CrBounds origin: 1@1 extent: 1000@1000)
]
