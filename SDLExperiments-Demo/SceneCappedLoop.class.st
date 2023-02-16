Class {
	#name : #SceneCappedLoop,
	#superclass : #SceneLoop,
	#instVars : [
		'waitingDelay',
		'targetPeriodMS',
		'msToYield',
		'latestStepMS'
	],
	#category : #'SDLExperiments-Demo-Scene'
}

{ #category : #initialization }
SceneCappedLoop >> defaultTargetPeriod [

	^ 15 milliSeconds
]

{ #category : #initialization }
SceneCappedLoop >> initialize [

	super initialize.

	self targetPeriod: self defaultTargetPeriod.

	"This initializes the internal Semaphore, but the milliseconds
	to wait are set after each pulse."
	waitingDelay := Delay forMilliseconds: 0
]

{ #category : #stepping }
SceneCappedLoop >> postStep [
	"Wait the appropriate amount of time for the next pulse"

	| msToWait shouldForceDelay minWaitMS |
	"msToWait is the amount of time to wait for the next pulse.
	Since a pulse can take longer than #pulsePeriod, msToWait may be negative here
	(meaning that we shouldn't wait for the next pulse)"
	msToWait := targetPeriodMS - (Time millisecondClockValue - latestStepMS).

	"But also ensure that background processes get some execution time.
	If the nextReadyProcess has more priority than the IDLE process"
	shouldForceDelay :=
		Processor nextReadyProcess priority > Processor lowestPriority.
	minWaitMS :=
		shouldForceDelay
			ifTrue: [ msToYield ]
			ifFalse: [ 0 ].

	msToWait := msToWait min: targetPeriodMS max: minWaitMS.

	msToWait = 0 ifFalse: [ waitingDelay setDelay: msToWait; wait ]

]

{ #category : #stepping }
SceneCappedLoop >> step [

	latestStepMS := Time millisecondClockValue.
	super step.
]

{ #category : #'api - lifecycle' }
SceneCappedLoop >> targetPeriod: aDuration [

	targetPeriodMS := aDuration asMilliSeconds.
	msToYield := (targetPeriodMS // 2) min: 1.
]
