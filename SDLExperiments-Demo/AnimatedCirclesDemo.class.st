"
I'm a demo where multiple circles translate, and only some of them are animated.

"
Class {
	#name : #AnimatedCirclesDemo,
	#superclass : #Object,
	#instVars : [
		'random',
		'durationMS',
		'numberOfCircles',
		'numberOfAnimatedCircles',
		'sceneWindow',
		'windowLogicalExtent'
	],
	#category : #'SDLExperiments-Demo'
}

{ #category : #running }
AnimatedCirclesDemo class >> runAlternatives [
	<script: '[ self runAlternatives ] fork'>

	| managers driverNames |
	managers := {
		AtlasTileManager new.
		TextureTileManager newStatic.
		TextureTileManager newStreaming }.

	driverNames := SDL2 renderDriverInfos collect: #nameString.
	driverNames := driverNames copyWithout: 'opengles2'.
	driverNames := driverNames copyWithout: 'software'.

	driverNames do: [ :eachDriverName |
		eachDriverName traceCr.
		managers do: [ :eachManager |
			| aDemo |
			0.5 seconds wait.
			Smalltalk garbageCollect.

			aDemo := self new.
			aDemo sceneWindow
				tileManager: eachManager;
				sdlRenderDriverName: eachDriverName.

			eachManager asString traceCr.

			[	aDemo run.
				aDemo reportOnTranscript ]
					onErrorDo: [ :e | e description traceCr. ].
			 ] ].
	'Done' traceCr.

]

{ #category : #accessing }
AnimatedCirclesDemo >> durationMS: aDuration [

	durationMS := aDuration
]

{ #category : #initialization }
AnimatedCirclesDemo >> initialize [

	super initialize.

	sceneWindow := SceneWindow new.
	
	random := Random seed: 7.
	durationMS := 10000.0.
	numberOfCircles := 200.
	numberOfAnimatedCircles := 2.

	self windowLogicalExtent: 900 asPoint.

]

{ #category : #accessing }
AnimatedCirclesDemo >> numberOfAnimatedCircles: aNumber [

	numberOfAnimatedCircles := aNumber
]

{ #category : #accessing }
AnimatedCirclesDemo >> numberOfCircles: aNumber [

	numberOfCircles := aNumber
]

{ #category : #running }
AnimatedCirclesDemo >> prepareSceneWindow [

	1 to: numberOfCircles do: [ :index |
		| circleRadius lineWidth padding from relativeTo anElement |
		circleRadius := random nextIntegerBetween: 10 and: sceneWindow logicalExtent x / 7.
		lineWidth := random nextIntegerBetween: 1 and: circleRadius/5.
		padding := lineWidth.
		from := Point
			x: (random nextIntegerBetween: 0 and: sceneWindow logicalExtent x - (circleRadius*2))
			y: (random nextIntegerBetween: 0 and: sceneWindow logicalExtent y - (circleRadius*2)).
		relativeTo := Point
			x: (random nextIntegerBetween: -100 and: 100)
			y: (random nextIntegerBetween: -100 and: 100).

		anElement := sceneWindow addElement.
		
		anElement
			isAnimated: index > (numberOfCircles - numberOfAnimatedCircles);
			position: from;
			extent: ((circleRadius + padding) *2) asPoint;
			stepBlock: [ :deltaMS :totalMS |
				| amount |
				amount := totalMS / durationMS.
				anElement position: from + (relativeTo * amount) ];
			renderBlock: [ :cairoContext |
				cairoContext
					sourceColorRGB: Color random;
					translateByX: padding y: padding;
					lineWidth: lineWidth;
					lineCap: AeCairoCapStyle square;
					dash: (AeCairoDoubleArray newFrom: { 0. (lineWidth*2) }) offset: 0;
					circleRadius: circleRadius;
					stroke ].
		]

]

{ #category : #accessing }
AnimatedCirclesDemo >> random: aRandom [

	random := aRandom
]

{ #category : #running }
AnimatedCirclesDemo >> reportOnTranscript [

	sceneWindow frameCounter reportString traceCr
]

{ #category : #running }
AnimatedCirclesDemo >> run [
	<script: '[self new run; reportOnTranscript; inspect]fork'>

	self prepareSceneWindow.

	sceneWindow open.
	(Delay forMilliseconds: durationMS) wait.
	sceneWindow close.

]

{ #category : #accessing }
AnimatedCirclesDemo >> sceneWindow [

	^ sceneWindow
]

{ #category : #accessing }
AnimatedCirclesDemo >> windowLogicalExtent: aPoint [

	sceneWindow logicalExtent: aPoint
]
