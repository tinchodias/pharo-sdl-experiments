Class {
	#name : #ScenePositionDemo,
	#superclass : #SceneInteractiveDemo,
	#instVars : [
		'theElement',
		'mouseWheelScale'
	],
	#category : #'SDLExperiments-Demo-Interactive'
}

{ #category : #initialization }
ScenePositionDemo >> initialize [

	super initialize.
	
	mouseWheelScale := 0.1
]

{ #category : #running }
ScenePositionDemo >> prepareSceneWindow [

	| squareSide lineWidth padding |
	theElement := SceneElement new.
	sceneWindow addElement: theElement.

	squareSide := 50.
	lineWidth := 0.5.
	padding := 1.

	theElement
		position: 0.0 asPoint;
		opacity: 1.0;
		extent: ((squareSide + padding) *2 + lineWidth) asPoint;
		stepBlock: [ :deltaMS :totalMS | ];
		renderBlock: [ :cairoContext |
			cairoContext
				sourceColorRGB: Color black;
				lineWidth:  lineWidth;
				translateByX: padding y: padding;
				rectangleX: lineWidth
					y: lineWidth
					width:  squareSide
					height: squareSide;
				stroke ]

]

{ #category : #visiting }
ScenePositionDemo >> visitKeyDownEvent: aSDL_KeyDownEvent [

	aSDL_KeyDownEvent keysym sym = SDLK_UP ifTrue: [
		^ theElement position: (theElement position x @ (theElement position y - mouseWheelScale)) ].

	aSDL_KeyDownEvent keysym sym = SDLK_DOWN ifTrue: [
		^ theElement position: (theElement position x @ (theElement position y + mouseWheelScale)) ].

	aSDL_KeyDownEvent keysym sym = SDLK_LEFT ifTrue: [
		^ theElement position: ((theElement position x - mouseWheelScale) @ theElement position y) ].

	aSDL_KeyDownEvent keysym sym = SDLK_RIGHT ifTrue: [
		^ theElement position: ((theElement position x + mouseWheelScale) @ theElement position y) ].

	super visitKeyDownEvent: aSDL_KeyDownEvent
]

{ #category : #visiting }
ScenePositionDemo >> visitMouseWheelEvent: aSDL_MouseWheelEvent [

	theElement position:
		(theElement position x + (aSDL_MouseWheelEvent preciseX * mouseWheelScale)) @
		(theElement position y + (aSDL_MouseWheelEvent preciseY negated * mouseWheelScale))
]
