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
Tile >> renderTo: aSDLFRect opacity: alphaByte [
	"Render myself on the associated SDL_Renderer, at the specified position (a SDL_FRect) and opacity (0..255 value)."

	self subclassResponsibility
]
