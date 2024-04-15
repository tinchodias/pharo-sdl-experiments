Class {
	#name : 'ClipDemo',
	#superclass : 'BenchmarkingDemo',
	#instVars : [
		'numberOfRectangles'
	],
	#category : 'SDLExperiments-Demo-Benchmarks',
	#package : 'SDLExperiments-Demo',
	#tag : 'Benchmarks'
}

{ #category : 'running' }
ClipDemo class >> runAlternatives [
	<script: '[ self runAlternatives ] fork'>

	| managers driverNames durationMS |
	durationMS := 7000.
	managers := {
"		AtlasTileManager new
			atlasPixelExtent: 2048 asPoint;
			yourself.
		TextureTileManager newStatic.
"		TextureTileManager newStreaming }.

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
		) do: [ :demoData |
				| aDemo |

			'
--- ' trace.
			demoData trace.
			' ---' traceCr.									
			managers do: [ :eachManager |
				aDemo := self new.
				aDemo
					durationMS: durationMS;
					numberOfRectangles: demoData.
				aDemo sceneWindow
					tileManager: eachManager;
					sdlRenderDriverName: eachDriverName.

				3 timesRepeat: [
					0.2 seconds wait.
					Smalltalk garbageCollect ].

				aDemo run.
				'' traceCr.
				eachManager asString traceCr.
				aDemo reportOnTranscript ] ] ].
'
=== Done ===' traceCr.

]

{ #category : 'running' }
ClipDemo >> addNewElement [

	| sideLength from relativeTo anElement |
	sideLength :=
		random
			nextIntegerBetween: 50
			and: 300.
	from :=
		Point
			x: (random 
				nextIntegerBetween: 0
				and: sceneWindow logicalExtent x - sideLength)
			y: (random
				nextIntegerBetween: 0
				and: sceneWindow logicalExtent y - sideLength).
	relativeTo :=
		Point
			x: (random nextIntegerBetween: -100 and: 100)
			y: (random nextIntegerBetween: -100 and: 100).

	anElement := self
		newGradientSquareElement: sideLength
		innerColor: Color blue"(Color random: random)"
		outerColor: Color red"(Color random: random)".
	anElement
		position: from;
		stepBlock: [ :deltaMS :totalMS |
			| amount |
			amount := totalMS / durationMS.
			anElement position: from + (relativeTo * amount) ].

	sceneWindow addElement: anElement
]

{ #category : 'initialization' }
ClipDemo >> initialize [

	super initialize.

	numberOfRectangles := 300.
	durationMS := 10000.
"	self windowLogicalExtent: 800 asPoint"

]

{ #category : 'running' }
ClipDemo >> newGradientSquareElement: squareSide innerColor: aColor outerColor: anotherColor [

	| padding cornerRadius |
	padding := 1.
	cornerRadius := squareSide / 5.0.
	
	^ ClippedElement new
		position: 0.0 asPoint;
		opacity: 0.25;
		extent: (squareSide + (padding*2)) asPoint;
		
		clipPathBlock: [ :cairoContext |
			cairoContext
				roundedRectangleLeft: padding
					top: padding
					right: squareSide
					bottom: squareSide
					tl: cornerRadius
					tr: cornerRadius
					br: cornerRadius
					bl: cornerRadius ];
		
		renderBlock: [ :cairoContext |
			| aGradient |
			aGradient := (AeCairoRadialGradientPattern
				innerCenter: 0@0
				innerRadius: 0
				outerCenter: 0@0
				outerRadius: squareSide * 1.5)
					addStopAt: 0.0 color: aColor;
					addStopAt: 1.0 color: anotherColor;
					yourself.
			cairoContext
				source: aGradient;
				rectangleX: padding
					y: padding
					width: squareSide
					height: squareSide;
				fill ];
		yourself
]

{ #category : 'accessing' }
ClipDemo >> numberOfRectangles: anInteger [

	numberOfRectangles := anInteger
]

{ #category : 'running' }
ClipDemo >> prepareSceneWindow [

	numberOfRectangles timesRepeat: [ self addNewElement ]
]

{ #category : 'running' }
ClipDemo >> run [
	<script: '[self new run; reportOnTranscript] fork'>

	super run
]
