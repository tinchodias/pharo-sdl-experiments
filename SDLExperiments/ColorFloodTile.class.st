Class {
	#name : #ColorFloodTile,
	#superclass : #Tile,
	#instVars : [
		'color'
	],
	#category : #'SDLExperiments-ColorFlood'
}

{ #category : #enumerating }
ColorFloodTile >> cairoContextToOverrideDo: aBlock [
	"Nothing to do"
]

{ #category : #accessing }
ColorFloodTile >> color [

	^ color
]

{ #category : #accessing }
ColorFloodTile >> color: aColor [

	color := aColor
]
