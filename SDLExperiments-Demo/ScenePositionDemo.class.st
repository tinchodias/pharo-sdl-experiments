Class {
	#name : #ScenePositionDemo,
	#superclass : #SceneInteractiveDemo,
	#instVars : [
		'theElement',
		'mouseWheelScale'
	],
	#category : #'SDLExperiments-Demo-Standalone'
}

{ #category : #initialization }
ScenePositionDemo >> initialize [

	super initialize.
	
	mouseWheelScale := 0.1
]

{ #category : #running }
ScenePositionDemo >> prepareSceneWindow [

	| squareSide lineWidth |
	theElement := SceneElement new.
	sceneWindow addElement: theElement.

	squareSide := 100.
	lineWidth := 1.

	theElement
		position: 0.0 asPoint;
		extent: ((squareSide + lineWidth) *2) asPoint;
		stepBlock: [ :deltaMS :totalMS | ];
		renderBlock: [ :cairoContext |
			cairoContext
				sourceColorRGB: Color black;
				lineWidth:  lineWidth;
				rectangleX: lineWidth
					y: lineWidth
					width:  squareSide
					height: squareSide;
				stroke ]

]

{ #category : #visiting }
ScenePositionDemo >> visitKeyDownEvent: aSDL_KeyDownEvent [

	(({KMOD_LGUI. KMOD_RGUI} includes: aSDL_KeyDownEvent keysym mod) and: [
		{SDLK_w. SDLK_q} includes: aSDL_KeyDownEvent keysym sym ]) ifTrue: [
		self quitNow ].
	
	aSDL_KeyDownEvent keysym sym = SDLK_UP ifTrue: [
		^ theElement position: (theElement position x @ (theElement position y - mouseWheelScale)) ].

	aSDL_KeyDownEvent keysym sym = SDLK_DOWN ifTrue: [
		^ theElement position: (theElement position x @ (theElement position y + mouseWheelScale)) ].

	aSDL_KeyDownEvent keysym sym = SDLK_LEFT ifTrue: [
		^ theElement position: ((theElement position x - mouseWheelScale) @ theElement position y) ].

	aSDL_KeyDownEvent keysym sym = SDLK_RIGHT ifTrue: [
		^ theElement position: ((theElement position x + mouseWheelScale) @ theElement position y) ].

]

{ #category : #visiting }
ScenePositionDemo >> visitMouseWheelEvent: aSDL_MouseWheelEvent [

	theElement position:
		(theElement position x + (aSDL_MouseWheelEvent preciseX * mouseWheelScale)) @
		(theElement position y + (aSDL_MouseWheelEvent preciseY negated * mouseWheelScale))
]
