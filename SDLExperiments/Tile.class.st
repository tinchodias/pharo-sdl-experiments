Class {
	#name : #Tile,
	#superclass : #Object,
	#category : #'SDLExperiments-Core'
}

{ #category : #enumerating }
Tile >> cairoContextToOverrideDo: aBlock [
	"Evaluate a block with a Cairo context that will override the Tile contents."

	self subclassResponsibility
]

{ #category : #enumerating }
Tile >> renderTo: dstRect [
	"Render myself on the associated SDL_Renderer, at the specified position."

	self subclassResponsibility
]
