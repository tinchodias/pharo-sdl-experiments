Class {
	#name : #BaselineOfSDLExperiments,
	#superclass : #BaselineOf,
	#category : #BaselineOfSDLExperiments
}

{ #category : #baseline }
BaselineOfSDLExperiments >> baseline: spec [
	<baseline>
	spec
		for: #common
		do: [ 
			self
				declareAlexandrieOn: spec.

			spec
				package: 'SDLExperiments' with: [ spec requires: #('Alexandrie' 'SDLExperiments-FFI') ];
				package: 'SDLExperiments-Demo' with: [ spec requires: #('Alexandrie' 'SDLExperiments') ];
				package: 'SDLExperiments-FFI';
				package: 'SDLExperiments-Tests' with: [ spec requires: #('SDLExperiments') ];
				package: 'SDLExperiments-RTree';
				package: 'SDLExperiments-BooleanArray'
			]
]

{ #category : #'external projects' }
BaselineOfSDLExperiments >> declareAlexandrieOn: spec [
	spec 
		baseline: 'Alexandrie'
		with: [ spec repository: 'github://pharo-graphics/Alexandrie:master/src' ]
]
