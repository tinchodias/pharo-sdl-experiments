Class {
	#name : #SquareElement,
	#superclass : #SceneElement,
	#instVars : [
		'color'
	],
	#category : #'SDLExperiments-Demo'
}

{ #category : #accessing }
SquareElement >> color [

	^ color
]

{ #category : #accessing }
SquareElement >> color: aColor [

	color := aColor.
	tile ifNotNil: [ tile color: aColor ]
]

{ #category : #private }
SquareElement >> ensureReadyToRender [

	self ensureDeviceScaledProperties.

	isAnimated ifTrue: [
		 self notYetImplemented  ].

	tile ifNil: [
		tile :=
			"SDLGradientTile" SDLColorFloodTile new
				sdlRenderer: sceneWindow sdlRenderer;
				color: color;
				yourself ]
]
