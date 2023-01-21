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
Tile class >> newFor: anAtlas pixelBounds: aPixelRectangle [ 
	
	^ self basicNew
		initializeIn: anAtlas pixelBounds: aPixelRectangle;
		yourself
]

{ #category : #enumerating }
Tile >> cairoContextToOverrideDo: aBlock [

	atlas cairoContextToOverride: boundsAsSdlRect do: aBlock
]

{ #category : #initialization }
Tile >> initializeIn: anAtlas pixelBounds: aPixelRectangle [ 

	self initialize.
	
	atlas := anAtlas.
	self pixelBounds: aPixelRectangle

]

{ #category : #accessing }
Tile >> pixelBounds [
	^ bounds
]

{ #category : #initialization }
Tile >> pixelBounds: aPixelRectangle [

	bounds := aPixelRectangle.
	boundsAsSdlRect :=
		SDL_Rect
			autoReleasingNewOrigin: aPixelRectangle origin
			extent: aPixelRectangle extent

]

{ #category : #rendering }
Tile >> renderTo: dstRect [

	atlas renderTileAt: boundsAsSdlRect to: dstRect
]
