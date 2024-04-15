Class {
	#name : 'BenchmarkingDemo',
	#superclass : 'Object',
	#instVars : [
		'sceneWindow',
		'random',
		'durationMS',
		'executionError'
	],
	#category : 'SDLExperiments-Demo-Benchmarks',
	#package : 'SDLExperiments-Demo',
	#tag : 'Benchmarks'
}

{ #category : 'accessing' }
BenchmarkingDemo >> durationMS: aDuration [

	durationMS := aDuration
]

{ #category : 'initialization' }
BenchmarkingDemo >> initialize [

	super initialize.

	sceneWindow := SceneWindow new.
	
	random := Random seed: 7.
	durationMS := 5000.0.

	self windowLogicalExtent: 1300 @ 700

]

{ #category : 'running' }
BenchmarkingDemo >> prepareSceneWindow [

	self subclassResponsibility 
]

{ #category : 'accessing' }
BenchmarkingDemo >> random: aRandom [

	random := aRandom
]

{ #category : 'running' }
BenchmarkingDemo >> reportOnTranscript [

	sceneWindow steppingLoop hasStoppingError
		ifTrue: [ sceneWindow steppingLoop stoppingError traceCr ]
		ifFalse: [ sceneWindow timeCounter reportString traceCr ]
]

{ #category : 'running' }
BenchmarkingDemo >> run [

	self prepareSceneWindow.

	sceneWindow open.
	sceneWindow title: self windowTitle.
	sceneWindow steppingLoop start.

	(Delay forMilliseconds: durationMS) wait.

	sceneWindow steppingLoop stop.
	sceneWindow close.

]

{ #category : 'accessing' }
BenchmarkingDemo >> sceneWindow [

	^ sceneWindow
]

{ #category : 'accessing' }
BenchmarkingDemo >> tileManager: aTileManager [

	sceneWindow tileManager: aTileManager
]

{ #category : 'accessing' }
BenchmarkingDemo >> windowLogicalExtent: aPoint [

	sceneWindow logicalExtent: aPoint
]

{ #category : 'running' }
BenchmarkingDemo >> windowTitle [

	^ sceneWindow sdlRenderer info nameString, ';', sceneWindow tileManager asString
]
