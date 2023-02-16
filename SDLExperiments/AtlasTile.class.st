"
I represent a rectangular portion of a texture.

I could bacame outdated and if the texture has any issue. This must be managed externally (I don't know if I'm invalid).

I may be applied zero or more times on a scene refresh.
"
Class {
	#name : #AtlasTile,
	#superclass : #Tile,
	#instVars : [
		'atlas',
		'bounds',
		'boundsAsSdlRect'
	],
	#category : #'SDLExperiments-Manager-Atlas'
}

{ #category : #'instance creation' }
AtlasTile class >> newFor: anAtlas pixelBounds: aPixelRectangle [ 
	
	^ self basicNew
		initializeIn: anAtlas pixelBounds: aPixelRectangle;
		yourself
]

{ #category : #enumerating }
AtlasTile >> cairoContextToOverrideDo: aBlock [

	atlas cairoContextToOverride: boundsAsSdlRect do: aBlock
]

{ #category : #initialization }
AtlasTile >> initializeIn: anAtlas pixelBounds: aPixelRectangle [ 

	self initialize.
	
	atlas := anAtlas.
	self pixelBounds: aPixelRectangle

]

{ #category : #accessing }
AtlasTile >> pixelBounds [
	^ bounds
]

{ #category : #initialization }
AtlasTile >> pixelBounds: aPixelRectangle [

	bounds := aPixelRectangle.
	boundsAsSdlRect :=
		SDL_Rect
			autoReleasingNewOrigin: aPixelRectangle origin
			extent: aPixelRectangle extent

]

{ #category : #rendering }
AtlasTile >> renderTo: aSDLFRect opacity: alphaByte [

	atlas renderTileAt: boundsAsSdlRect to: aSDLFRect opacity: alphaByte
]
