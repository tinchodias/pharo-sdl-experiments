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

{ #category : #enumerating }
SDLColorFloodTile >> renderTo: aSDLFRect opacity: alphaByte [
	"Render myself on the associated SDL_Renderer, at the specified position (a SDL_FRect) and opacity (0..255 value)."
	
" Assumes redundant:
	sdlRenderer drawBlendMode: SDL_BLENDMODE_BLEND."
	
	| finalColor |
	finalColor := alphaByte = 255
		ifTrue: [ color ]
		ifFalse: [
			| alphaFloat |
			alphaFloat := SDL2 fromByteToFloat: alphaByte.
			color alpha: color alpha * alphaFloat ].
	
	sdlRenderer setDrawColor: finalColor.
	sdlRenderer fillRectF: aSDLFRect
]

{ #category : #initialization }
SDLColorFloodTile >> sdlRenderer: aRenderer [

	sdlRenderer := aRenderer
]
