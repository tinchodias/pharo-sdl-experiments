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
		'nodes',
		'size',
		'kMinChildren',
		'kMaxChildren',
		'rootBranch',
		'nonEmptyItemCount'
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
	
	nonEmptyItemCount := 0.
	rootBranch := CrBranch new.
	
	"These values were empirically determined to produce reasonable performance in most cases."
	kMinChildren := 6.
	kMaxChildren := 11
]

{ #category : 'initialization' }
CrRTree >> load: anItemCount boundsBlock: boundsBlock payloadBlock: payloadBlock [

	| branches |
	self assert: [ nonEmptyItemCount = 0 ].

	size := anItemCount.

	"Nothing to do with items with zero extent"
	branches := OrderedCollection new: size.
	1 to: size do: [ :i |
		| branchBounds |
		branchBounds := boundsBlock value: i.
		branchBounds isEmpty ifFalse: [
			branches addLast:
				(CrBranch
					bounds: branchBounds
					payload: (payloadBlock value: i)) ] ].
	nonEmptyItemCount := branches size.
	nonEmptyItemCount = 1
		ifTrue: [ self loadSingleBranch: branches first ]
		ifFalse: [ self loadMultipleBranches: branches ].

	"// We should've wasted at most kMinChildren nodes."
	self assert: [ (nodes capacity - nodes size) <= kMinChildren ]
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
CrRTree >> loadAll: branches count: branchCount level: level [

	| remainder sourceBranchIndex targetBranchIndex |
	branchCount = 1 ifTrue: [ ^ branches first ].
	
	remainder := branchCount % kMaxChildren.
	remainder > 0 ifTrue: [
		"If the remainder isn't enough to fill a node, we'll add
		fewer nodes to other branches."
		remainder := remainder >= kMinChildren
			ifTrue: [ 0 ]
			ifFalse: [ kMinChildren - remainder ] ].
	
	"Several branches might be inserted at this level"
	sourceBranchIndex := 1.
	targetBranchIndex := 0.
	[ sourceBranchIndex <= branchCount ] whileTrue: [ 
		| incrementBy newNode newBranch k |
		targetBranchIndex := targetBranchIndex + 1.
		
		incrementBy := kMaxChildren.
		"If need be, omit some nodes to make up for remainder"
		remainder = 0 ifFalse: [
			(remainder <= (kMaxChildren - kMinChildren))
				ifTrue: [
					incrementBy := incrementBy - remainder.
					remainder := 0 ]
				ifFalse: [
					incrementBy := kMinChildren.
					remainder := remainder - (kMaxChildren - kMinChildren) ] ].
		newNode := self newNodeAtLevel: level.
		newNode addChildBranch: (branches at: sourceBranchIndex).

		newBranch :=
			CrBranch
				bounds: (branches at: sourceBranchIndex) bounds
				subtree: newNode.
		sourceBranchIndex := sourceBranchIndex + 1.

		k := 1.
		[ k < incrementBy and: [
		sourceBranchIndex <= branchCount ] ] whileTrue: [
			newBranch bounds merge: (branches at: sourceBranchIndex) bounds.
			newNode addChildBranch: (branches at: sourceBranchIndex).
			sourceBranchIndex := sourceBranchIndex + 1.
			k := k + 1 ].

		self assert: [ targetBranchIndex < sourceBranchIndex ].
		branches at: targetBranchIndex put: newBranch ].

	"Several branches more might be inserted at the lext level"
	^ self
		loadAll: branches
		count: targetBranchIndex
		level: level + 1
]

{ #category : 'private' }
CrRTree >> loadMultipleBranches: branches [

	| branchCount depth nodeCount |
"   // Determine a reasonable upper bound on the number of nodes to prevent
    // reallocations. This is basically (n**d - 1) / (n - 1), which is the
    // number of nodes in a complete tree with n branches at each node. In the
    // code n = |branch_count|, d = |depth|. However, we normally would have
    // kMaxChildren branch factor, but that can be broken if some children
    // don't have enough nodes. That can happen for at most kMinChildren nodes
    // (since otherwise, we'd create a new node)."
	branchCount := kMaxChildren.
	depth := branches size log / branchCount log.
	nodeCount :=
		(((branchCount raisedTo: depth) - 1) /
		(branchCount - 1)) truncated + kMinChildren.

	nodes := OrderedCollection new: nodeCount.
	rootBranch := self loadAll: branches count: branches size level: 0
]

{ #category : 'private' }
CrRTree >> loadSingleBranch: aBranch [

	| node |
	nodes := OrderedCollection new: 1.

	node := self newNodeAtLevel: 0.
	node addChildBranch: aBranch.
	rootBranch
		subtree: node;
		bounds: aBranch bounds
]

{ #category : 'private' }
CrRTree >> newNodeAtLevel: level [
	
	| newNode |
" // We don't allow reallocations, since that would invalidate references to
  // existing nodes, so verify that capacity > size."
	self assert: [ nodes capacity > nodes size ].

	newNode := CrNode level: level size: kMaxChildren.
	nodes add: newNode.
	^ newNode
]

{ #category : 'accessing' }
CrRTree >> reset [

  nonEmptyItemCount := 0.
  nodes removeAll.
  rootBranch subtree: nil.
  rootBranch bounds setLeft: 0 right: 0 top: 0 bottom: 0
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
		from: rootBranch subtree
]

{ #category : 'private' }
CrRTree >> searchRecursive: aRectangle do: aBlock from: aNode [

	aNode childrenBranchesDo: [ :eachBranch |
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
						from: eachBranch subtree ] ] ]
]
