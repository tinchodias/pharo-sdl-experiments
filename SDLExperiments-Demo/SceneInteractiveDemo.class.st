Class {
	#name : #SceneInteractiveDemo,
	#superclass : #Object,
	#traits : 'TSDL2MappedEventHandler',
	#classTraits : 'TSDL2MappedEventHandler classTrait',
	#instVars : [
		'sceneWindow',
		'sdlMainLoop'
	],
	#pools : [
		'SDL2Constants',
		'SDL2Types'
	],
	#category : #'SDLExperiments-Demo-Interactive'
}

{ #category : #running }
SceneInteractiveDemo >> close [

	sceneWindow steppingLoop stop.
	sceneWindow close

]

{ #category : #initialization }
SceneInteractiveDemo >> initialize [

	super initialize.
	
	sceneWindow := SceneWindow new.

	sdlMainLoop := SDLMainLoop new
		eventHandler: self;
		yourself
]

{ #category : #running }
SceneInteractiveDemo >> open [

	sdlMainLoop fork.

	self prepareSceneWindow.

	sceneWindow open.
	sceneWindow title: self windowTitle.
	sceneWindow steppingLoop start.

]

{ #category : #initialization }
SceneInteractiveDemo >> prepareSceneWindow [

	self subclassResponsibility
]

{ #category : #private }
SceneInteractiveDemo >> quitNow [

	Smalltalk snapshot: false andQuit: true
]

{ #category : #accessing }
SceneInteractiveDemo >> sceneWindow [

	^ sceneWindow
]

{ #category : #visiting }
SceneInteractiveDemo >> visitQuitEvent: aSDL2MappedEvent [

	self quitNow
]

{ #category : #initialization }
SceneInteractiveDemo >> windowTitle [

	^ 'Interactive Demo'
]
