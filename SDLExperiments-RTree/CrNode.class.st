Class {
	#name : 'CrNode',
	#superclass : 'Object',
	#instVars : [
		'children',
		'level'
	],
	#category : 'SDLExperiments-RTree',
	#package : 'SDLExperiments-RTree'
}

{ #category : 'instance creation' }
CrNode class >> level: aLevel size: aSize [

	^ self basicNew
		initializeLevel: aLevel size: aSize;
		yourself
]

{ #category : 'accessing' }
CrNode >> addChildBranch: aBranch [

	children add: aBranch
]

{ #category : 'accessing' }
CrNode >> childrenBranchCount [

	^ children size
]

{ #category : 'accessing' }
CrNode >> childrenBranchesDo: aBlock [

	children do: aBlock
]

{ #category : 'initialization' }
CrNode >> initializeLevel: aLevel size: aSize [

	self initialize.
	
	level := aLevel.
	children := OrderedCollection new: aSize
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
		print: children size
]
