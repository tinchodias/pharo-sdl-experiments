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

{ #category : 'testing' }
CrNode >> isLeaf [

	^ self subclassResponsibility
]
