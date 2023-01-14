Class {
	#name : #SceneWindowDemo,
	#superclass : #Object,
	#instVars : [
		'windowExtent',
		'random',
		'durationMS',
		'numberOfCircles',
		'numberOfAnimatedCircles',
		'sceneWindow'
	],
	#category : #'SDLExperiments-Demo'
}

{ #category : #accessing }
SceneWindowDemo >> durationMS: anObject [

	durationMS := anObject
]

{ #category : #initialization }
SceneWindowDemo >> initialize [

	super initialize.
	
	windowExtent := 900 asPoint.
	random := Random new.
	durationMS := 10000.0.
	numberOfCircles := 200.
	numberOfAnimatedCircles := 5.

]

{ #category : #accessing }
SceneWindowDemo >> numberOfAnimatedCircles: anObject [

	numberOfAnimatedCircles := anObject
]

{ #category : #accessing }
SceneWindowDemo >> numberOfCircles: anObject [

	numberOfCircles := anObject
]

{ #category : #accessing }
SceneWindowDemo >> random: anObject [

	random := anObject
]

{ #category : #running }
SceneWindowDemo >> reportOnTranscript [

	(String streamContents: [ :stream |
		stream << 'Frames: '.

"(From BlocBenchs)	

		MeanConfidenceIntervalPrinter new
			unitString: 'ms';
			print: sceneWindow listOfDeltaMS
				on: stream.
		stream << ' ('."

		sceneWindow fps
			printOn: stream
			showingDecimalPlaces: 1.
		stream << ' per second'.

		 ]) traceCr
]

{ #category : #running }
SceneWindowDemo >> run [
	<script: 'self new run; reportOnTranscript; inspect'>

	sceneWindow := SceneWindow new
		windowExtent: windowExtent;
		yourself.

	1 to: numberOfCircles do: [ :index |
		| circleRadius lineWidth padding from relativeTo anElement |
		circleRadius := random nextIntegerBetween: 10 and: windowExtent x / 7.
		lineWidth := random nextIntegerBetween: 1 and: circleRadius/5.
		padding := lineWidth.
		from := Point
			x: (random nextIntegerBetween: 0 and: windowExtent x - (circleRadius*2))
			y: (random nextIntegerBetween: 0 and: windowExtent y - (circleRadius*2)).
		relativeTo := Point
			x: (random nextIntegerBetween: -100 and: 100)
			y: (random nextIntegerBetween: -100 and: 100).

		anElement := sceneWindow addElement.
		
		anElement
			isAnimated: index >= (numberOfCircles - numberOfAnimatedCircles);
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
		].

	sceneWindow open.
	(Delay forMilliseconds: durationMS) wait.
	sceneWindow close.

]

{ #category : #accessing }
SceneWindowDemo >> sceneWindow [

	^ sceneWindow
]

{ #category : #accessing }
SceneWindowDemo >> windowExtent: anObject [

	windowExtent := anObject
]
