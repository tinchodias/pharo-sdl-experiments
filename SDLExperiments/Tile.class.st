"
I represent a rectangular portion of a texture.

I could bacame outdated and if the texture has any issue. This must be managed externally (I don't know if I'm invalid).

I may be applied zero or more times on a scene refresh.
"
Class {
	#name : #Tile,
	#superclass : #Object,
	#instVars : [
		'srcRect',
		'atlas'
	],
	#category : #'SDLExperiments-Atlas'
}

{ #category : #accessing }
Tile >> atlas: anAtlas [

	atlas := anAtlas
]

{ #category : #enumerating }
Tile >> cairoContextToOverrideDo: aBlock [

	atlas cairoContextToOverride: srcRect do: aBlock
]

{ #category : #rendering }
Tile >> renderTo: dstRect [

	atlas renderTileAt: srcRect to: dstRect
]

{ #category : #accessing }
Tile >> srcRect [

	^ srcRect
]

{ #category : #accessing }
Tile >> srcRect: aSDLRect [

	srcRect := aSDLRect
]
