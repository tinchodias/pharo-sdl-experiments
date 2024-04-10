Class {
	#name : 'CrNode2',
	#superclass : 'Object',
	#type : 'variable',
	#instVars : [
		'level',
		'childrenBranchCount'
	],
	#category : 'SDLExperiments-RTree',
	#package : 'SDLExperiments-RTree'
}

{ #category : 'instance creation' }
CrNode2 class >> level: aLevel size: aSize [

	^ (self basicNew: aSize)
		initializeLevel: aLevel;
		yourself
]

{ #category : 'adding' }
CrNode2 >> addChildBranch: aBranch [

	childrenBranchCount := childrenBranchCount + 1.
	self at: childrenBranchCount put: aBranch
]

{ #category : 'accessing' }
CrNode2 >> childrenBranchCount [

	^ childrenBranchCount
]

{ #category : 'enumerating' }
CrNode2 >> childrenBranchesDo: aBlock [

	1 to: childrenBranchCount do: [:index | aBlock value: (self at: index)]
]

{ #category : 'initialization' }
CrNode2 >> initializeLevel: aLevel [

	self initialize.
	
	level := aLevel.
	childrenBranchCount := 0
]

{ #category : 'testing' }
CrNode2 >> isLeaf [

	^ level = 0
]

{ #category : 'accessing' }
CrNode2 >> level [

	^ level
]

{ #category : 'printing' }
CrNode2 >> printOn: aStream [

	super printOn: aStream.
	aStream
		nextPutAll: ' level: ';
		print: level.
	aStream
		nextPutAll: ' size: ';
		print: childrenBranchCount
]
