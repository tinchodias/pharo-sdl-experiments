Class {
	#name : 'CrNode',
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
CrNode class >> level: aLevel size: aSize [

	^ (self basicNew: aSize)
		initializeLevel: aLevel;
		yourself
]

{ #category : 'adding' }
CrNode >> addChildBranch: aBranch [

	childrenBranchCount := childrenBranchCount + 1.
	self at: childrenBranchCount put: aBranch
]

{ #category : 'accessing' }
CrNode >> childrenBranchCount [

	^ childrenBranchCount
]

{ #category : 'enumerating' }
CrNode >> childrenBranchesDo: aBlock [

	1 to: childrenBranchCount do: [:index | aBlock value: (self at: index)]
]

{ #category : 'initialization' }
CrNode >> initializeLevel: aLevel [

	self initialize.
	
	level := aLevel.
	childrenBranchCount := 0
]

{ #category : 'testing' }
CrNode >> isLeaf [

	^ level = 0
]

{ #category : 'accessing' }
CrNode >> level [

	^ level
]

{ #category : 'printing' }
CrNode >> printOn: aStream [

	super printOn: aStream.
	aStream
		nextPutAll: ' level: ';
		print: level.
	aStream
		nextPutAll: ' size: ';
		print: childrenBranchCount
]
