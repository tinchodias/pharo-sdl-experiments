Class {
	#name : #FadingDemo,
	#superclass : #BenchmarkingDemo,
	#instVars : [
		'numberOfCircles'
	],
	#category : #'SDLExperiments-Demo-Benchmarks'
}

{ #category : #running }
FadingDemo class >> runAlternatives [
	<script: '[ self runAlternatives ] fork'>

	| managers driverNames |
	managers := {
"		TextureTileManager newStatic."
		TextureTileManager newStreaming.
"		CairoDirectTileManager new" }.

	driverNames := SDL2 renderDriverInfos collect: #nameString.
	driverNames := driverNames copyWithout: 'opengles2'.
	driverNames := driverNames copyWithout: 'software'.
"	driverNames := #(metal)."
"	driverNames := #(opengl)."

	driverNames do: [ :eachDriverName |
		
'
=== Driver name: ' trace.
		eachDriverName trace.
		' ===' traceCr.
		
		#(
			"50"
			400
		) do: [ :circleData |

			'
--- ' trace.
			circleData trace.
			' ---' traceCr.

			managers do: [ :eachManager |
				| aDemo |
				aDemo := self new.
				aDemo
					durationMS: 3000;
					numberOfCircles: circleData.
				aDemo sceneWindow
					tileManager: eachManager;
					sdlRenderDriverName: eachDriverName.

				0.5 seconds wait.
				Smalltalk garbageCollect.

				aDemo run.
				'' traceCr.
				eachManager asString traceCr.
				aDemo reportOnTranscript ] ] ].
'
=== Done ===' traceCr.

]

{ #category : #initialization }
FadingDemo >> initialize [

	super initialize.

	numberOfCircles := 75

]

{ #category : #accessing }
FadingDemo >> numberOfCircles: aNumber [

	numberOfCircles := aNumber
]

{ #category : #running }
FadingDemo >> prepareSceneWindow [

	1 to: numberOfCircles do: [ :index |
		| circleRadius position initialColor anElement |
		circleRadius := random
			nextIntegerBetween: 10
			and: sceneWindow logicalExtent x / 7.
		position := Point
			x: (random 
					nextIntegerBetween: 0
					and: sceneWindow logicalExtent x - (circleRadius*2))
			y: (random
					nextIntegerBetween: 0
					and: sceneWindow logicalExtent y - (circleRadius*2)).
		initialColor := Color random: random.

		anElement := sceneWindow addElement.
		
		anElement
			isAnimated: false;
			position: position;
			extent: (circleRadius*2) asPoint;
			stepBlock: [ :deltaMS :totalMS |
				| progress |
				progress := totalMS / durationMS.
				anElement opacityAsByte: (255 - (255.0 * progress) asInteger max: 0) ];
			renderBlock: [ :cairoContext |
				cairoContext
					sourceColorRGB: initialColor;
					circleRadius: circleRadius;
					fill ]
		]

]

{ #category : #running }
FadingDemo >> run [
	<script: '[self new run; reportOnTranscript] fork'>

	super run
]
