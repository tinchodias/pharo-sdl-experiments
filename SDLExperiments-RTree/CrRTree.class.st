"
I'm an RTree that is not mutable.

Inspired on Chrome's C++ implementation in rtree.h:
```
// The following description and most of the implementation is borrowed from
// Skia's SkRTree implementation.
//
// An R-Tree implementation. In short, it is a balanced n-ary tree containing a
// hierarchy of bounding rectangles.
//
// It only supports bulk-loading, i.e. creation from a batch of bounding
// rectangles. This performs a bottom-up bulk load using the STR
// (sort-tile-recursive) algorithm.
//
// Things to do: Experiment with other bulk-load algorithms (in particular the
// Hilbert pack variant, which groups rects by position on the Hilbert curve, is
// probably worth a look). There also exist top-down bulk load variants
// (VAMSplit, TopDownGreedy, etc).
//
// For more details see:
//
//  Beckmann, N.; Kriegel, H. P.; Schneider, R.; Seeger, B. (1990).
//  ""The R*-tree: an efficient and robust access method for points and
//  rectangles""
```

"
Class {
	#name : #CrRTree,
	#superclass : #Object,
	#instVars : [
		'root',
		'minChildren',
		'maxChildren'
	],
	#category : #'SDLExperiments-RTree'
}

{ #category : #'instance creation' }
CrRTree class >> new: itemCount boundsBlock: boundsBlock valueBlock: valueBlock [

	^ self basicNew
		initializeWith: itemCount
			boundsBlock: boundsBlock
			valueBlock: valueBlock;
		yourself
]

{ #category : #'instance creation' }
CrRTree class >> withAll: aCollection [

	^ self
		new: aCollection size 
		boundsBlock: [ :index | aCollection at: index ]
		valueBlock: [ :index | index ]
]

{ #category : #accessing }
CrRTree >> allNodes [

	| result |
	result := OrderedCollection new.
	root childrenDepthFirstDo: [ :each | result add: each ].
	^ result
]

{ #category : #accessing }
CrRTree >> bounds [

	^ root bounds
]

{ #category : #initialization }
CrRTree >> bulkLoad: leaves until: lastIndex [

	| remainder sourceIndex targetIndex |
	remainder := lastIndex % maxChildren.
	remainder > 0 ifTrue: [
		"If the remainder isn't enough to fill a node, we'll add
		fewer children to other nodes."
		remainder := remainder >= minChildren
			ifTrue: [ 0 ]
			ifFalse: [ minChildren - remainder ] ].

	sourceIndex := 1.
	targetIndex := 0.
	[ sourceIndex <= lastIndex ] whileTrue: [ 
		| size |
		targetIndex := targetIndex + 1.
		
		size := maxChildren.
		"If need be, omit some nodes to make up for remainder"
		remainder = 0 ifFalse: [
			(remainder <= (maxChildren - minChildren))
				ifTrue: [
					size := size - remainder.
					remainder := 0 ]
				ifFalse: [
					size := minChildren.
					remainder := remainder - (maxChildren - minChildren) ] ].
		size := size min: (lastIndex - sourceIndex + 1).

		leaves
			at: targetIndex
			put:
				(CrNonLeafNode
					newFrom: leaves
					startAt: sourceIndex
					size: size).

		sourceIndex := sourceIndex + size ].
	
	^ targetIndex
]

{ #category : #initialization }
CrRTree >> initializeWith: itemCount boundsBlock: boundsBlock valueBlock: valueBlock [
	"Create the structure from the leaves. Override the input
	collection with new non-leaf nodes."

	| leaves lastIndex |
	"These values were empirically determined to produce reasonable
	performance in most cases."
	minChildren := 6.
	maxChildren := 11.

	leaves :=
		(1 to: itemCount)
			collect: [ :index |
				(CrLeafNode
					bounds: (boundsBlock value: index)
					value: (valueBlock value: index)) ].

	lastIndex := leaves size.

	[ lastIndex > 1 ] whileTrue: [
	 	lastIndex := self bulkLoad: leaves until: lastIndex ].

	root := leaves first
]

{ #category : #inspector }
CrRTree >> inspectionTree: aBuilder [
	<inspectorPresentationOrder: 1 title: 'Nodes'>

	^ aBuilder newTree
		roots: { root };
		children: [ :each | each children ];
		expandRoots;
		yourself

]

{ #category : #searching }
CrRTree >> intersectionAt: aRectangle [ 
	
	^ Array streamContents: [ :stream |
		self
			intersectionAt: aRectangle
			do: [ :each | stream nextPut: each ] ]
]

{ #category : #searching }
CrRTree >> intersectionAt: aRectangle do: aBlockClosure [

	^ root
		intersectionAt: aRectangle
		do: aBlockClosure
]

{ #category : #accessing }
CrRTree >> nodeCount [

	| count |
	count := 0.
	root childrenDepthFirstDo: [ :each | count := count + 1 ].
	^ count
]

{ #category : #accessing }
CrRTree >> reset [

  root := nil
]

{ #category : #searching }
CrRTree >> valuesAtPoint: aPoint [
	
	^ Array streamContents: [ :stream |
		self
			valuesAtPoint: aPoint
			do: [ :each | stream nextPut: each ] ]
]

{ #category : #searching }
CrRTree >> valuesAtPoint: aPoint do: aBlock [

	^ root valuesAtX: aPoint x y: aPoint y do: aBlock
]
