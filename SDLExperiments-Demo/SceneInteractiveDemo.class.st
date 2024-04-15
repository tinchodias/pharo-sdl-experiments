Class {
	#name : 'SceneInteractiveDemo',
	#superclass : 'Object',
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
	#category : 'SDLExperiments-Demo-Interactive',
	#package : 'SDLExperiments-Demo',
	#tag : 'Interactive'
}

{ #category : 'running' }
SceneInteractiveDemo >> close [

	sceneWindow steppingLoop stop.
	sceneWindow close

]

{ #category : 'initialization' }
SceneInteractiveDemo >> initialize [

	super initialize.
	
	sceneWindow := SceneWindow new.

	sdlMainLoop := SDLMainLoop new
		eventHandler: self;
		yourself
]

{ #category : 'running' }
SceneInteractiveDemo >> open [

	sdlMainLoop fork.

	self prepareSceneWindow.

	sceneWindow useCappedSteppingLoop. "Interaction doesn't need max fps"
	sceneWindow open.
	sceneWindow title: self windowTitle.
	sceneWindow steppingLoop start.

]

{ #category : 'initialization' }
SceneInteractiveDemo >> prepareSceneWindow [

	self subclassResponsibility
]

{ #category : 'private' }
SceneInteractiveDemo >> quitNow [

	Smalltalk snapshot: false andQuit: true
]

{ #category : 'accessing' }
SceneInteractiveDemo >> sceneWindow [

	^ sceneWindow
]

{ #category : 'accessing' }
SceneInteractiveDemo >> sdlMainLoop [

	^ sdlMainLoop
]

{ #category : 'visiting' }
SceneInteractiveDemo >> visitKeyDownEvent: aSDL_KeyDownEvent [

	"Escape"
	aSDL_KeyDownEvent keysym sym = SDLK_ESCAPE ifTrue: [ self quitNow ].

	"Mac's cmd+w or cmd+q"
	(({KMOD_LGUI. KMOD_GUI} includes: aSDL_KeyDownEvent keysym mod) and: [
		{SDLK_w. SDLK_q} includes: aSDL_KeyDownEvent keysym sym ]) ifTrue: [
		self quitNow ]
]

{ #category : 'visiting' }
SceneInteractiveDemo >> visitQuitEvent: aSDL2MappedEvent [

	self quitNow
]

{ #category : 'initialization' }
SceneInteractiveDemo >> windowTitle [

	^ sceneWindow sdlRenderer info nameString, '; Interactive Demo'
]
