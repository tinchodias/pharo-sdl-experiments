"
I'm an Atlas based on a Skyline Bin Pack algorithm.

For further information, please read Jukka Jylänki's article titled ""A Thousand Ways to Pack the Bin - A Practical Approach to Two-Dimensional Rectangle Bin Packing"".

"
Class {
	#name : #SkylinePacker,
	#superclass : #Object,
	#instVars : [
		'nodes',
		'extent'
	],
	#category : #'SDLExperiments-Skyline'
}

{ #category : #'instance creation' }
SkylinePacker class >> newWithExtent: aPoint [

	^ self newWithExtent: aPoint numberOfNodes: 10

]

{ #category : #'instance creation' }
SkylinePacker class >> newWithExtent: aPoint numberOfNodes: anInteger [

	^ self basicNew
		initializeWithExtent: aPoint
			numberOfNodes: anInteger;
		yourself
]

{ #category : #private }
SkylinePacker >> addSkylineLevel: index position: xy extent: wh [

	| insertedNode |
	insertedNode := self
		insertNodeAt: index
		x: xy x
		y: xy y + wh y
		width: wh x.
	
	self shrinkOrDeleteToTheRightOf: insertedNode at: index.
	
	self mergeContiguousNodesWithSameHeight.
]

{ #category : #public }
SkylinePacker >> allocateExtent: desiredExtent ifSuccess: packedBlock ifFailure: noSpaceBlock [
	"Use bottom-left fit heuristic."

	| bestHeight bestWidth bestIndex bestPosition |
	bestWidth := extent x.
	bestHeight := extent y.
	bestIndex := nil.
	bestPosition := nil.

	nodes withIndexDo: [ :eachNode :index |
		self
			tryToFit: desiredExtent
			at: index
			maxHeightDo: [ :y |
				((y + desiredExtent y) < bestHeight or: [
					y + desiredExtent y = bestHeight and: [
					eachNode width <= bestWidth ] ]) ifTrue: [ 
						bestIndex := index.
						bestWidth := eachNode width.
						bestHeight := y + desiredExtent y.
						bestPosition := eachNode x @ y ] ]
			ifNoSpaceDo: [ "Skip" ] ].

	bestIndex ifNil: [ ^ noSpaceBlock value ].

	self
		addSkylineLevel: bestIndex
		position: bestPosition
		extent: desiredExtent.

	packedBlock value: bestPosition
]

{ #category : #public }
SkylinePacker >> expandExtent: aPoint [

	aPoint x > extent x ifTrue: [

		nodes add: 
			(SkylinePackerNode
				newWithPosition: extent x @ 0
				width: aPoint x - extent x) ].

	extent := aPoint

]

{ #category : #initialization }
SkylinePacker >> initializeWithExtent: aPoint numberOfNodes: anInteger [

	self initialize.
	
	"Allocate space for skyline nodes"
	nodes := OrderedCollection new: anInteger.

	self resetExtent: aPoint.
]

{ #category : #private }
SkylinePacker >> insertNodeAt: index x: x y: y width: w [

	^ nodes
		add: (SkylinePackerNode new
					x: x;
					y: y;
					width: w;
					yourself)
		beforeIndex: index
]

{ #category : #private }
SkylinePacker >> mergeContiguousNodesWithSameHeight [
	"Merge same height skyline segments that are next to each other."

	| indexOfNextNode currentNode |
	currentNode := nodes first.
	indexOfNextNode := 2.

	[ indexOfNextNode <= nodes size ] whileTrue: [
		| nextNode |
		nextNode := nodes at: indexOfNextNode.

		currentNode y = nextNode y
			ifTrue: [
				currentNode addWidth: nextNode width.
				nodes removeAt: indexOfNextNode ]
			ifFalse: [
				indexOfNextNode := indexOfNextNode + 1.
				currentNode := nextNode ] ]
]

{ #category : #private }
SkylinePacker >> nodes [
	^ nodes
]

{ #category : #public }
SkylinePacker >> resetExtent: aPoint [
	
	nodes
		removeAll;
		add: (SkylinePackerNode
			newWithPosition: 0@0
			width: aPoint x).
	
	extent := aPoint
]

{ #category : #private }
SkylinePacker >> shrinkOrDeleteToTheRightOf: insertedNode at: indexOfInsertedNode [
	"After insertion, we may need to shrink or remove following nodes."

	| indexOfNextNode |
	indexOfNextNode := indexOfInsertedNode + 1.

	"Contrary to usual intuition, what is subject to change on
	each iteration is the size of the nodes collection."
	[ indexOfNextNode <= nodes size ] whileTrue: [
		| nextNode widthToShrink |

		"Take next node and calculate how much to shrink it."
		nextNode := nodes at: indexOfNextNode.
		widthToShrink := insertedNode right - nextNode x.

		"If next node doesn't need to be shrinked, return here."
		widthToShrink <= 0 ifTrue: [ ^ self ].
		nextNode shrinkLeft: widthToShrink.

		"If next node is valid after shrinking, return here."
		nextNode width > 0 ifTrue: [ ^ self ]. 

		"Else, remove the invalid node and loop"
		nodes removeAt: indexOfNextNode ]

]

{ #category : #private }
SkylinePacker >> tryToFit: anExtent at: startIndex maxHeightDo: fitBlock ifNoSpaceDo: noSpaceBlock [
	"Checks if there is enough space at the location of a skyline span,
	and return the max height of all skyline spans under that at that location,
	(think tetris block being dropped at that position)."

	| index currentNode y spaceLeft |

	index := startIndex.
	currentNode := nodes at: index.
	spaceLeft := anExtent x.
	
	(currentNode x + spaceLeft) > extent x
		ifTrue: [ ^ noSpaceBlock value ].
	
	y := currentNode y.
	
	[ spaceLeft > 0 ] whileTrue: [ 

		index > nodes size
			ifTrue: [ ^ noSpaceBlock value ].

		currentNode := nodes at: index.
		y := y max: currentNode y.

		(y + anExtent y) > extent y
			ifTrue: [ ^ noSpaceBlock value ].

		spaceLeft := spaceLeft - currentNode width.
		index := index + 1 ].

	fitBlock value: y
]
