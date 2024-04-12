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
	self assert: [ rootBranch isNil ].

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

	| level branchCount |
	branchCount := branches size.
	level := 0.

	[ branchCount > 1 ] whileTrue: [ 
		| remainder sourceBranchIndex targetBranchIndex |

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

			"Create a new branch that will gather several input branches"
			newNode := CrNode level: level size: kMaxChildren.
			newNode addBranch: (branches at: sourceBranchIndex).
			newBranch :=
				CrBranch
					bounds: (branches at: sourceBranchIndex) bounds copy
					node: newNode.

			sourceBranchIndex := sourceBranchIndex + 1.

			k := 1.
			[ k < incrementBy and: [
			sourceBranchIndex <= branchCount ] ] whileTrue: [
				newBranch bounds merge: (branches at: sourceBranchIndex) bounds.
				newNode addBranch: (branches at: sourceBranchIndex).
				sourceBranchIndex := sourceBranchIndex + 1.
				k := k + 1 ].

			"We're done with this new branch"
			self assert: [ targetBranchIndex < sourceBranchIndex ].
			branches at: targetBranchIndex put: newBranch ].

		branchCount := targetBranchIndex.
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
