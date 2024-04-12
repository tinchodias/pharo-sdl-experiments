"
I'm an R-Tree based on Chrome's RTree.

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
		'kMinChildren',
		'kMaxChildren',
		'rootBranch'
	],
	#category : 'SDLExperiments-RTree',
	#package : 'SDLExperiments-RTree'
}

{ #category : 'accessing' }
CrRTree >> bounds [

	^ rootBranch bounds
]

{ #category : 'initialization' }
CrRTree >> initialize [

	super initialize.
	
	"These values were empirically determined to produce
	reasonable performance in most cases."
	kMinChildren := 6.
	kMaxChildren := 11
]

{ #category : 'initialization' }
CrRTree >> load: itemCount boundsBlock: boundsBlock payloadBlock: payloadBlock [

	| branches |
	branches := OrderedCollection new: itemCount.
	1 to: itemCount do: [ :index |
		| branchBounds |
		branchBounds := boundsBlock value: index.
		"Reject items with zero extent"
		branchBounds isEmpty ifFalse: [
			branches addLast:
				(CrBranch
					bounds: branchBounds
					payload: (payloadBlock value: index)) ] ].

	rootBranch :=
		branches size = 1
			ifTrue: [
				| newNode |
				newNode := CrNode level: 0 size: 1.
				newNode addBranch: branches first.
				CrBranch
					bounds: branches first bounds
					node: newNode ]
			ifFalse: [
				self newRootBranchForAll: branches ]
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
CrRTree >> newRootBranchForAll: branches [

	| level lastIndex |
	lastIndex := branches size.
	level := 0.

	[ lastIndex = 1 ] whileFalse: [ 
		| remainder sourceIndex targetIndex |

		remainder := lastIndex % kMaxChildren.
		remainder > 0 ifTrue: [
			"If the remainder isn't enough to fill a node, we'll add
			fewer nodes to other branches."
			remainder := remainder >= kMinChildren
				ifTrue: [ 0 ]
				ifFalse: [ kMinChildren - remainder ] ].
		
		"Several branches might be inserted at this level"
		sourceIndex := 1.
		targetIndex := 0.
		[ sourceIndex <= lastIndex ] whileTrue: [ 
			| sizeOfNewNode newNode newBranch |
			targetIndex := targetIndex + 1.
			
			sizeOfNewNode := kMaxChildren.
			"If need be, omit some nodes to make up for remainder"
			remainder = 0 ifFalse: [
				(remainder <= (kMaxChildren - kMinChildren))
					ifTrue: [
						sizeOfNewNode := sizeOfNewNode - remainder.
						remainder := 0 ]
					ifFalse: [
						sizeOfNewNode := kMinChildren.
						remainder := remainder - (kMaxChildren - kMinChildren) ] ].

			"Create a new branch that will gather several input branches"
			newNode := CrNode level: level size: sizeOfNewNode.
			newNode addBranch: (branches at: sourceIndex).
			newBranch :=
				CrBranch
					bounds: (branches at: sourceIndex) bounds copy
					node: newNode.

			"First branch is already moved; now, fill node with the following."
			sourceIndex := sourceIndex + 1.
			[ newNode isFull or: [ sourceIndex > lastIndex ] ] whileFalse: [
				newBranch bounds merge: (branches at: sourceIndex) bounds.
				newNode addBranch: (branches at: sourceIndex).
				sourceIndex := sourceIndex + 1 ].

			"We're done with this new branch"
			branches at: targetIndex put: newBranch ].

		lastIndex := targetIndex.
		level := level + 1 ].
	
	^ branches first
]

{ #category : 'accessing' }
CrRTree >> reset [

  rootBranch := nil
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
		from: rootBranch node
]

{ #category : 'private' }
CrRTree >> searchRecursive: aRectangle do: aBlock from: aNode [

	aNode branchesDo: [ :eachBranch |
		(aRectangle intersects: eachBranch bounds) ifTrue: [
			aNode isLeaf
				ifTrue: [
					aBlock
						value: eachBranch payload
						value: eachBranch bounds ]
				ifFalse: [
					self
						searchRecursive: aRectangle
						do: aBlock
						from: eachBranch node ] ] ]
]
