Class {
	#name : #BenchmarkingDemo,
	#superclass : #Object,
	#instVars : [
		'sceneWindow',
		'random',
		'durationMS'
	],
	#category : #'SDLExperiments-Demo'
}

{ #category : #accessing }
BenchmarkingDemo >> durationMS: aDuration [

	durationMS := aDuration
]

{ #category : #initialization }
BenchmarkingDemo >> initialize [

	super initialize.

	sceneWindow := SceneWindow new.
	
	random := Random seed: 7.
	durationMS := 5000.0.
	
	self windowLogicalExtent: 1200 @ 800.

]

{ #category : #running }
BenchmarkingDemo >> prepareSceneWindow [

	self subclassResponsibility 
]

{ #category : #accessing }
BenchmarkingDemo >> random: aRandom [

	random := aRandom
]

{ #category : #running }
BenchmarkingDemo >> reportOnTranscript [

	sceneWindow frameCounter reportString traceCr
]

{ #category : #running }
BenchmarkingDemo >> run [

	self prepareSceneWindow.

	sceneWindow
		open;
		startSteppingProcess.

	(Delay forMilliseconds: durationMS) wait.

	sceneWindow
		stopSteppingProcess;
		close.

]

{ #category : #accessing }
BenchmarkingDemo >> sceneWindow [

	^ sceneWindow
]

{ #category : #accessing }
BenchmarkingDemo >> tileManager: aTileManager [

	sceneWindow tileManager: aTileManager
]

{ #category : #accessing }
BenchmarkingDemo >> windowLogicalExtent: aPoint [

	sceneWindow logicalExtent: aPoint
]
