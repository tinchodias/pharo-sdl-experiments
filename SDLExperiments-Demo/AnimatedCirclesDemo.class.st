"
I'm a demo where multiple circles translate, and only some of them are animated.

"
Class {
	#name : #AnimatedCirclesDemo,
	#superclass : #BenchmarkingDemo,
	#instVars : [
		'numberOfCircles',
		'numberOfAnimatedCircles'
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
		TextureTileManager newStreaming.
		CairoDirectTileManager new }.

	driverNames := SDL2 renderDriverInfos collect: #nameString.
	driverNames := driverNames copyWithout: 'opengles2'.
	driverNames := driverNames copyWithout: 'software'.
"	driverNames := #(metal)."
"	driverNames := #(opengl)."

	driverNames do: [ :eachDriverName |
		
		'' traceCr.
		eachDriverName traceCr.
		
		#(
			(200 0 '200 static')
			(50 50 '50 animated')
		) do: [ :circleData |

			'' traceCr.
			circleData third traceCr.

			managers do: [ :eachManager |
				| aDemo |
				aDemo := self new.
				aDemo
					durationMS: 5000;
					numberOfCircles: circleData first;
					numberOfAnimatedCircles: circleData second.
				aDemo sceneWindow
					tileManager: eachManager;
					sdlRenderDriverName: eachDriverName.

				0.5 seconds wait.
				Smalltalk garbageCollect.

				[	aDemo run.
					eachManager asString traceCr.
					aDemo reportOnTranscript ]
						onErrorDo: [ :e |
							e description traceCr.
							aDemo sceneWindow
								stopSteppingProcess;
								close ].
			 ] ] ].
	'
Done' traceCr.

]

{ #category : #initialization }
AnimatedCirclesDemo >> initialize [

	super initialize.

	numberOfCircles := 200.
	numberOfAnimatedCircles := 3.

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
		| circleRadius lineWidth padding from relativeTo isAnimated initialColor anElement |
		circleRadius := random
			nextIntegerBetween: 10
			and: sceneWindow logicalExtent x / 7.
		lineWidth := random
			nextIntegerBetween: 1
			and: circleRadius/5.
		padding := lineWidth.
		from := Point
			x: (random 
					nextIntegerBetween: 0
					and: sceneWindow logicalExtent x - (circleRadius*2))
			y: (random
					nextIntegerBetween: 0
					and: sceneWindow logicalExtent y - (circleRadius*2)).
		relativeTo := Point
			x: (random nextIntegerBetween: -100 and: 100)
			y: (random nextIntegerBetween: -100 and: 100).
		isAnimated := index > (numberOfCircles - numberOfAnimatedCircles).
		initialColor := Color random: random.

		anElement := sceneWindow addElement.
		
		anElement
			isAnimated: isAnimated;
			position: from;
			extent: ((circleRadius + padding) *2) asPoint;
			stepBlock: [ :deltaMS :totalMS |
				| amount |
				amount := totalMS / durationMS.
				anElement position: from + (relativeTo * amount) ];
			renderBlock: [ :cairoContext |
				cairoContext
"					saveState;"
					sourceColorRGB: (isAnimated
						ifTrue: [ Color random: random ]
						ifFalse: [ initialColor ]);
					translateByX: padding y: padding;
					lineWidth: lineWidth;
"					lineCap: AeCairoCapStyle square;
					dash: (AeCairoDoubleArray
						newFrom: { 0. (lineWidth*2) })
						offset: 0;"
					circleRadius: circleRadius;
					stroke";
					restoreState" ]
		]

]

{ #category : #running }
AnimatedCirclesDemo >> run [
	<script: '[self new run; reportOnTranscript] fork'>

	super run
]
