"
I handle frame stepping, provide time information, and know how to report.

"
Class {
	#name : 'SceneTimeCounter',
	#superclass : 'Object',
	#instVars : [
		'lastMS',
		'deltaMS',
		'listOfDeltaMS',
		'startMS',
		'totalMS'
	],
	#category : 'SDLExperiments-Demo-Utility-Window',
	#package : 'SDLExperiments-Demo',
	#tag : 'Utility-Window'
}

{ #category : 'accessing' }
SceneTimeCounter >> deltaMS [
	^ deltaMS
]

{ #category : 'accessing' }
SceneTimeCounter >> fps [

	^ listOfDeltaMS size / self totalSeconds
]

{ #category : 'accessing' }
SceneTimeCounter >> fpsExceptFirst [

	^ (listOfDeltaMS size - 1) / (self totalSeconds - (listOfDeltaMS first/1000))
]

{ #category : 'accessing' }
SceneTimeCounter >> listOfDeltaMS [

	^ listOfDeltaMS
]

{ #category : 'printing' }
SceneTimeCounter >> reportString [

	listOfDeltaMS ifEmpty: [ ^ 'Frame stats: no data' ].

	^ String streamContents: [ :stream |
		| deltaMSallButFirst |
		deltaMSallButFirst := listOfDeltaMS allButFirst.
		stream
			<< 'Frame stats:'; cr;
			<< '   * first:       ';
			<< listOfDeltaMS first asString;
			<< 'ms';
			cr;
			<< '   * allButFirst: '.
		
		MeanConfidenceIntervalPrinter new
			unitString: 'ms';
			print: deltaMSallButFirst
				on: stream.
		stream << ' ('.

		self fpsExceptFirst
			printOn: stream
			showingDecimalPlaces: 1.
		stream
			<< ' per second) - Top 1%: ';
			print: (deltaMSallButFirst sorted asArray
				last: (deltaMSallButFirst size * 0.01) ceiling)
		
		 ]
]

{ #category : 'stepping' }
SceneTimeCounter >> step [

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

{ #category : 'accessing' }
SceneTimeCounter >> totalMS [
	^ totalMS
]

{ #category : 'accessing' }
SceneTimeCounter >> totalSeconds [

	^ totalMS / 1000.0
]
