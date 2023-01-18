"
I represent a rectangular portion of a texture.

I could bacame outdated and if the texture has any issue. This must be managed externally (I don't know if I'm invalid).

I may be applied zero or more times on a scene refresh.
"
Class {
	#name : #Tile,
	#superclass : #Object,
	#instVars : [
		'atlas',
		'bounds',
		'boundsAsSdlRect'
	],
	#category : #'SDLExperiments-Atlas'
}

{ #category : #'instance creation' }
Tile class >> newFor: anAtlas bounds: aRectangle [ 
	
	^ self basicNew
		initializeIn: anAtlas bounds: aRectangle;
		yourself
]

{ #category : #accessing }
Tile >> bounds [
	^ bounds
]

{ #category : #initialization }
Tile >> bounds: aRectangle [

	bounds := aRectangle.
	boundsAsSdlRect :=
		SDL_Rect
			autoReleasingNewOrigin: aRectangle origin
			extent: aRectangle extent

]

{ #category : #enumerating }
Tile >> cairoContextToOverrideDo: aBlock [

	atlas cairoContextToOverride: boundsAsSdlRect do: aBlock
]

{ #category : #initialization }
Tile >> initializeIn: anAtlas bounds: aRectangle [ 

	self initialize.
	
	atlas := anAtlas.
	self bounds: aRectangle

]

{ #category : #rendering }
Tile >> renderTo: dstRect [

	atlas renderTileAt: boundsAsSdlRect to: dstRect
]
