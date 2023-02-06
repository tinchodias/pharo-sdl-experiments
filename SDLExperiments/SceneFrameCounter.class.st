"
I handle frame stepping, provide time information, and know how to report.

"
Class {
	#name : #SceneFrameCounter,
	#superclass : #Object,
	#instVars : [
		'lastMS',
		'deltaMS',
		'listOfDeltaMS',
		'startMS',
		'totalMS'
	],
	#category : #'SDLExperiments-Core'
}

{ #category : #accessing }
SceneFrameCounter >> deltaMS [
	^ deltaMS
]

{ #category : #accessing }
SceneFrameCounter >> fps [

	^ listOfDeltaMS size / self totalSeconds
]

{ #category : #accessing }
SceneFrameCounter >> fpsExceptFirst [

	^ (listOfDeltaMS size - 1) / (self totalSeconds - (listOfDeltaMS first/1000))
]

{ #category : #accessing }
SceneFrameCounter >> listOfDeltaMS [

	^ listOfDeltaMS
]

{ #category : #printing }
SceneFrameCounter >> reportString [

	^ String streamContents: [ :stream |
		stream << '--- Frames ---'; cr.

		stream
			<< 'first: ';
			<< listOfDeltaMS first asString;
			<< 'ms';
			cr.

		stream
			<< 'general: '.
			
		MeanConfidenceIntervalPrinter new
			unitString: 'ms';
			print: listOfDeltaMS allButFirst
				on: stream.
		stream << ' ('.

		self fpsExceptFirst
			printOn: stream
			showingDecimalPlaces: 1.
		stream << ' per second)' ]
]

{ #category : #stepping }
SceneFrameCounter >> step [

	lastMS
		ifNil: [
			startMS := Time millisecondClockValue.
			deltaMS := 0.
			lastMS := startMS.
			totalMS := 0.

			listOfDeltaMS := OrderedCollection new: 10 * 250 ]
		ifNotNil: [ 
			| currentMS |
			currentMS := Time millisecondClockValue.
			deltaMS := currentMS - lastMS.
			lastMS := currentMS.
			totalMS := lastMS - startMS.

			listOfDeltaMS add: deltaMS ]

]

{ #category : #accessing }
SceneFrameCounter >> totalMS [
	^ totalMS
]

{ #category : #accessing }
SceneFrameCounter >> totalSeconds [

	^ totalMS / 1000.0
]
