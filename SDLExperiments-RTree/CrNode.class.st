Class {
	#name : 'CrNode',
	#superclass : 'Object',
	#type : 'variable',
	#instVars : [
		'level',
		'branchCount'
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

{ #category : 'accessing' }
CrNode >> addBranch: aBranch [

	branchCount := branchCount + 1.
	self at: branchCount put: aBranch
]

{ #category : 'accessing' }
CrNode >> branchCount [

	^ branchCount
]

{ #category : 'enumerating' }
CrNode >> branchesDo: aBlock [

	1 to: branchCount do: [:index | aBlock value: (self at: index)]
]

{ #category : 'initialization' }
CrNode >> initializeLevel: aLevel [

	self initialize.
	
	level := aLevel.
	branchCount := 0
]

{ #category : 'accessing' }
CrNode >> isFull [

	^ self size = branchCount
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
		nextPutAll: ' branchCount: ';
		print: branchCount
]
