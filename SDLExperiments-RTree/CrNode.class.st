"
I'm an abstract RTree node that has rectangular bounds, and may have children nodes.
"
Class {
	#name : 'CrNode',
	#superclass : 'Object',
	#category : 'SDLExperiments-RTree',
	#package : 'SDLExperiments-RTree'
}

{ #category : 'accessing' }
CrNode >> bounds [

	^ self subclassResponsibility
]

{ #category : 'enumerating' }
CrNode >> children [

	^ Array new: self childrenCount streamContents: [ :stream |
		self childrenDo: [ :each | stream nextPut: each ]]
]

{ #category : 'enumerating' }
CrNode >> childrenCount [

	^ self subclassResponsibility
]

{ #category : 'enumerating' }
CrNode >> childrenDo: aBlock [

	^ self subclassResponsibility
]

{ #category : 'testing' }
CrNode >> isLeaf [

	^ self subclassResponsibility
]
