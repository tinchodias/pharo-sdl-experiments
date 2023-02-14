Class {
	#name : #SceneLoop,
	#superclass : #Object,
	#instVars : [
		'session',
		'stepBlock',
		'process',
		'stoppingError'
	],
	#category : #'SDLExperiments-Demo-Scene'
}

{ #category : #testing }
SceneLoop >> hasStoppingError [

	^ stoppingError notNil
]

{ #category : #testing }
SceneLoop >> isRunning [

	^ process notNil and: [ process isRunning ]
]

{ #category : #stepping }
SceneLoop >> postStep [

	"1 milliSecond wait"
	Processor yield
]

{ #category : #stepping }
SceneLoop >> start [

	[[	session := Smalltalk session.
		process := Processor activeProcess.
		stoppingError := nil.
		
		[ process == Processor activeProcess
			and: [ session == Smalltalk session ] ]
				whileTrue: [ self step; postStep ] ]
					
					onErrorDo: [ :anError |
						"Remember the reason for stopping."
						anError freeze.
						stoppingError := anError ].

			self stop ]

				forkAt: Processor userSchedulingPriority
				named: 'Step Loop ', self asString

]

{ #category : #stepping }
SceneLoop >> step [

	stepBlock value
]

{ #category : #accessing }
SceneLoop >> stepBlock: aFullBlockClosure [ 
	stepBlock := aFullBlockClosure
]

{ #category : #stepping }
SceneLoop >> stop [

	process ifNil: [ ^self ].
	process terminate.
	process := nil.
]

{ #category : #accessing }
SceneLoop >> stoppingError [

	^ stoppingError
]
