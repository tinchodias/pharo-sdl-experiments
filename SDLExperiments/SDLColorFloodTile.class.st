Class {
	#name : #SDLColorFloodTile,
	#superclass : #ColorFloodTile,
	#instVars : [
		'sdlRenderer',
		'pixelExtent'
	],
	#pools : [
		'SDL2Constants',
		'SDL2Types'
	],
	#category : #'SDLExperiments-ColorFlood'
}

{ #category : #initialization }
SDLColorFloodTile >> initializeSDLRenderer: aRenderer pixelExtent: aPoint [

	self initialize.
	sdlRenderer := aRenderer.
	pixelExtent := aPoint.
]

{ #category : #enumerating }
SDLColorFloodTile >> renderTo: aSDLFRect opacity: alphaByte [
	"Render myself on the associated SDL_Renderer, at the specified position (a SDL_FRect) and opacity (0..255 value)."
	
"	sdlRenderer drawBlendMode: SDL_BLENDMODE_BLEND."
	sdlRenderer setDrawColor: color.
	sdlRenderer fillRectF: aSDLFRect

]
