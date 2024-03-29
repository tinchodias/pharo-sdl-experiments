Class {
	#name : #CairoLazyTile,
	#superclass : #Tile,
	#instVars : [
		'drawingBlock',
		'cairoContext',
		'deviceScalePoint'
	],
	#category : #'SDLExperiments-Manager-Cairo'
}

{ #category : #accessing }
CairoLazyTile >> cairoContext: aCairoContext [

	cairoContext := aCairoContext
]

{ #category : #enumerating }
CairoLazyTile >> cairoContextToOverrideDo: aBlock [
	"Evaluate a block with a Cairo context that will override the Tile contents."

	drawingBlock := aBlock
]

{ #category : #accessing }
CairoLazyTile >> deviceScalePoint: aPoint [

	deviceScalePoint := aPoint
]

{ #category : #enumerating }
CairoLazyTile >> renderTo: aSDLFRect opacity: alphaByte [
	"Render myself on the associated SDL_Renderer, at the specified position."

	cairoContext restoreStateAfter: [ 

		cairoContext
			translateByX: aSDLFRect x / deviceScalePoint x
			y: aSDLFRect y / deviceScalePoint y.

		alphaByte = 255
			ifTrue: [ drawingBlock value: cairoContext ]
			ifFalse: [
				cairoContext
					paintGroupWith: [ drawingBlock value: cairoContext ]
					alpha: (SDL2 fromByteToFloat: alphaByte) ] ]
]
