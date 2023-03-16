Class {
	#name : #SquareDemo,
	#superclass : #BenchmarkingDemo,
	#instVars : [
		'numberOfRectangles',
		'sideLength',
		'useSpecialized',
		'useTranslucent'
	],
	#category : #'SDLExperiments-Demo-Benchmarks'
}

{ #category : #running }
SquareDemo class >> runAlternatives [
	<script: '[ self runAlternatives ] fork'>

	| managers driverNames durationMS |
	durationMS := 2000.
	managers := {
"		AtlasTileManager new
			atlasPixelExtent: 2048 asPoint;
			yourself.
		TextureTileManager newStatic.
"		TextureTileManager newStreaming.
		CairoDirectTileManager new }.

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
		
		#(  "10"
			100
		) do: [ :circleData |
				| aDemo |

			'
--- ' trace.
			circleData trace.
			' ---' traceCr.

			'
Specialized' traceCr.	
			aDemo := self new.
			aDemo
				durationMS: durationMS;
				numberOfRectangles: circleData;
				useSpecialized: true.
			aDemo sceneWindow
				sdlRenderDriverName: eachDriverName.
			aDemo run.
			aDemo reportOnTranscript.
									
			managers do: [ :eachManager |
				aDemo := self new.
				aDemo
					durationMS: durationMS;
					numberOfRectangles: circleData;
					useSpecialized: false.
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
SquareDemo >> initialize [

	super initialize.

	useSpecialized := true.
	useTranslucent := false.
	numberOfRectangles := 100.
	sideLength := 500

]

{ #category : #accessing }
SquareDemo >> numberOfRectangles: aNumber [

	numberOfRectangles := aNumber
]

{ #category : #running }
SquareDemo >> prepareSceneWindow [

	1 to: numberOfRectangles do: [ :index |
		| from relativeTo fillColor anElement |
		from := Point
			x: (random 
					nextIntegerBetween: 0
					and: sceneWindow logicalExtent x - (sideLength))
			y: (random
					nextIntegerBetween: 0
					and: sceneWindow logicalExtent y - (sideLength)).
		relativeTo := Point
			x: (random nextIntegerBetween: -100 and: 100)
			y: (random nextIntegerBetween: -100 and: 100).
		fillColor := Color random: random.

		anElement := useSpecialized
			ifTrue: [
				SquareElement new
					color: fillColor;
					yourself ]
			ifFalse: [
				SceneElement new
					renderBlock: [ :cairoContext |
						cairoContext
							sourceColorRGBA: fillColor;
							rectangleX: 0.0
								y: 0.0
								width: sideLength
								height: sideLength;
							fill ];
					yourself ].

		useTranslucent ifTrue: [
			anElement opacityAsByte: 200 ].

		anElement
			position: from;
			extent: sideLength asPoint;
			stepBlock: [ :deltaMS :totalMS |
				| amount |
				amount := totalMS / durationMS.
				anElement position: from + (relativeTo * amount) ].

		sceneWindow addElement: anElement ]

]

{ #category : #running }
SquareDemo >> run [
	<script: '[self new run; reportOnTranscript] fork'>

	super run
]

{ #category : #accessing }
SquareDemo >> useSpecialized: aBoolean [

	useSpecialized := aBoolean
]

{ #category : #running }
SquareDemo >> windowTitle [

	^ useSpecialized
		ifTrue: [ sceneWindow sdlRenderer info nameString, '; useSpecialized (tileManager ignored)' ]
		ifFalse: [ super windowTitle ]
]
