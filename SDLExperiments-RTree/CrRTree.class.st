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
	#name : 'CrRTree',
	#superclass : 'Object',
	#instVars : [
		'root',
		'minChildren',
		'maxChildren'
	],
	#category : 'SDLExperiments-RTree',
	#package : 'SDLExperiments-RTree'
}

{ #category : 'instance creation' }
CrRTree class >> withAll: aCollection [

	^ self new
		loadAll: aCollection;
		yourself
]

{ #category : 'accessing' }
CrRTree >> bounds [

	^ root bounds
]

{ #category : 'initialization' }
CrRTree >> initialize [

	super initialize.
	
	"These values were empirically determined to producereasonable
	performance in most cases."
	minChildren := 6.
	maxChildren := 11
]

{ #category : 'inspector' }
CrRTree >> inspectionTree: aBuilder [
	<inspectorPresentationOrder: 1 title: 'Nodes'>

	^ aBuilder newTree
		roots: { root };
		children: [ :each | each children ];
		display: [ :each |
			each isLeaf
				ifTrue: [ '{1} [payload: {2}]' format: { each bounds. each payload } ]
				ifFalse: [ '{1} [children: {2}]' format: { each bounds. each childrenCount } ] ];
		expandRoots;
		yourself

]

{ #category : 'initialization' }
CrRTree >> load: itemCount boundsBlock: boundsBlock payloadBlock: payloadBlock [

	| leaves |
	leaves := OrderedCollection new: itemCount.
	1 to: itemCount do: [ :index |
		| eachBounds |
		eachBounds := boundsBlock value: index.
		"Reject items with zero extent"
		eachBounds isEmpty ifFalse: [
			leaves addLast:
				(CrLeafNode
					bounds: eachBounds
					payload: (payloadBlock value: index)) ] ].

	root :=
		leaves size = 1
			ifTrue: [
				CrNonLeafNode new: 1 firstChild: leaves first ]
			ifFalse: [
				self newRootForAll: leaves ]
]

{ #category : 'initialization' }
CrRTree >> loadAll: aCollection [ 
	"Mostly for testing purposes"

	self
		load: aCollection size
		boundsBlock: [ :index | aCollection at: index ]
		payloadBlock: [ :index | index ]
]

{ #category : 'private' }
CrRTree >> newRootForAll: leaves [
	"Structure leaves in a tree structure. Override the input collection
	from end to start, writing new non-leaf nodes."

	| lastIndex |
	lastIndex := leaves size.

	[ lastIndex = 1 ] whileFalse: [ 
		| remainder sourceIndex targetIndex |
		remainder := lastIndex % maxChildren.
		remainder > 0 ifTrue: [
			"If the remainder isn't enough to fill a node, we'll add
			fewer children to other nodes."
			remainder := remainder >= minChildren
				ifTrue: [ 0 ]
				ifFalse: [ minChildren - remainder ] ].

		"Insert nodes at this tree level"
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

			"Create a new node that will gather multiple leaf nodes"
			leaves
				at: targetIndex
				put: (CrNonLeafNode newFrom: leaves startAt: sourceIndex size: size).

			sourceIndex := sourceIndex + size ].

		lastIndex := targetIndex ].
	
	^ leaves first
]

{ #category : 'accessing' }
CrRTree >> reset [

  root := nil
]

{ #category : 'searching' }
CrRTree >> search: aRectangle [ 
	
	^ Array streamContents: [ :stream |
		self
			search: aRectangle
			do: [ :eachPayload :eachBounds |
				stream nextPut: eachPayload ] ]
]

{ #category : 'searching' }
CrRTree >> search: aRectangle do: aBlockClosure [

	^ self
		searchRecursive: aRectangle
		do: aBlockClosure
		from: root
]

{ #category : 'private' }
CrRTree >> searchRecursive: aRectangle do: aBlock from: aNode [

	aNode isLeaf
		ifTrue: [
			aBlock
				value: aNode payload
				value: aNode bounds ]
		ifFalse: [
			aNode childrenDo: [ :eachChild |
				(aRectangle intersects: eachChild bounds) ifTrue: [
					self
						searchRecursive: aRectangle
						do: aBlock
						from: eachChild ]]]
]
