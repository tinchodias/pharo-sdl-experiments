Class {
	#name : 'SDLExperimentsFilesystemResources',
	#superclass : 'Object',
	#category : 'SDLExperiments-Demo',
	#package : 'SDLExperiments-Demo'
}

{ #category : 'accessing' }
SDLExperimentsFilesystemResources class >> cursorsDirectory [

	^ self repositoryDirectory / 'cursors'
]

{ #category : 'accessing' }
SDLExperimentsFilesystemResources class >> repositoryDirectory [

	| expectedName myRepository |
	expectedName := 'pharo-sdl-experiments'.

	myRepository := IceRepository registry
		detect: [ :each | each name asLowercase = expectedName ]
		ifNone: [ self error: ('Did not find any repository named ''{1}'' in Iceberg (case insensitive). Alexandrie tests require it to access resources.' format: { expectedName }) ].
	
	^ myRepository location
]
