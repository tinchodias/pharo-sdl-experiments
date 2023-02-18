Class {
	#name : #SquareDemo,
	#superclass : #BenchmarkingDemo,
	#instVars : [
		'numberOfAnimatedCircles',
		'numberOfRectangles',
		'sideLength',
		'useSpecialized'
	],
	#category : #'SDLExperiments-Demo-Demos'
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
		
		#(
			500
			5000
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
	numberOfRectangles := 1000.
	sideLength := 50

]

{ #category : #accessing }
SquareDemo >> numberOfRectangles: aNumber [

	numberOfRectangles := aNumber
]

{ #category : #running }
SquareDemo >> prepareSceneWindow [

	useSpecialized
		ifTrue: [ self prepareSceneWindowSpecialized ]
		ifFalse: [ self prepareSceneWindowGeneric ]
]

{ #category : #running }
SquareDemo >> prepareSceneWindowGeneric [

	1 to: numberOfRectangles do: [ :index |
		| from relativeTo fillColor anElement |
		from := Point
			x: (random 
					nextIntegerBetween: 0
					and: sceneWindow logicalExtent x - (sideLength*2))
			y: (random
					nextIntegerBetween: 0
					and: sceneWindow logicalExtent y - (sideLength*2)).
		relativeTo := Point
			x: (random nextIntegerBetween: -100 and: 100)
			y: (random nextIntegerBetween: -100 and: 100).
		fillColor := Color random: random.

		anElement := SceneElement new.
		sceneWindow addElement: anElement.
		
		anElement
			position: from;
			extent: sideLength asPoint;
			stepBlock: [ :deltaMS :totalMS |
				| amount |
				amount := totalMS / durationMS.
				anElement position: from + (relativeTo * amount) ];
			renderBlock: [ :cairoContext |
				cairoContext
					sourceColorRGBA: fillColor;
					rectangleTo: anElement extent;
					fill ]

		]

]

{ #category : #running }
SquareDemo >> prepareSceneWindowSpecialized [

	1 to: numberOfRectangles do: [ :index |
		| from relativeTo fillColor anElement |
		from := Point
			x: (random 
					nextIntegerBetween: 0
					and: sceneWindow logicalExtent x - (sideLength*2))
			y: (random
					nextIntegerBetween: 0
					and: sceneWindow logicalExtent y - (sideLength*2)).
		relativeTo := Point
			x: (random nextIntegerBetween: -100 and: 100)
			y: (random nextIntegerBetween: -100 and: 100).
		fillColor := Color random: random.

		anElement := SquareElement new.
		sceneWindow addElement: anElement.
		
		anElement
			color: fillColor;
			position: from;
			extent: sideLength asPoint;
			stepBlock: [ :deltaMS :totalMS |
				| amount |
				amount := totalMS / durationMS.
				anElement position: from + (relativeTo * amount) ]
		]

]

{ #category : #running }
SquareDemo >> run [
	<script: '[self new run; reportOnTranscript] fork'>

	super run
]

{ #category : #accessing }
SquareDemo >> useSpecialized: anObject [

	useSpecialized := anObject
]
