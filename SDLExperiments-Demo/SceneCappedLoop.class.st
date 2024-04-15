Class {
	#name : 'SceneCappedLoop',
	#superclass : 'SceneLoop',
	#instVars : [
		'waitingDelay',
		'targetPeriodMS',
		'lastMS'
	],
	#category : 'SDLExperiments-Demo-Utility-Window',
	#package : 'SDLExperiments-Demo',
	#tag : 'Utility-Window'
}

{ #category : 'initialization' }
SceneCappedLoop >> initialize [

	super initialize.

	self targetHertz: 60.

	"This initializes the internal Semaphore, but the milliseconds
	to wait are set after each step."
	waitingDelay := Delay forMilliseconds: 0
]

{ #category : 'stepping' }
SceneCappedLoop >> preStep [

	"Only for initial step"
	lastMS ifNil: [
		lastMS := Time millisecondClockValue ].

	super preStep.
]

{ #category : 'api - lifecycle' }
SceneCappedLoop >> targetHertz: aNumber [

	targetPeriodMS := 1000.0 / aNumber
]

{ #category : 'api - lifecycle' }
SceneCappedLoop >> targetPeriod: aDuration [

	targetPeriodMS := aDuration asMilliSeconds

]

{ #category : 'stepping' }
SceneCappedLoop >> waitIfNeeded [
	"Wait the appropriate amount of time for the next step"

	| msToWait elapsedMS currentMS |
	currentMS := Time millisecondClockValue.
	elapsedMS := currentMS - lastMS.
	msToWait := targetPeriodMS - elapsedMS.

	msToWait > 0 ifTrue: [ waitingDelay setDelay: msToWait; wait ].

	lastMS := currentMS
]
