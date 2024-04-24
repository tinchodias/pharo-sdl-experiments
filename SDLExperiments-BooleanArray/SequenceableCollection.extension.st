Extension { #name : 'SequenceableCollection' }

{ #category : '*SDLExperiments-BooleanArray' }
SequenceableCollection >> atIntervalFrom: first to: last put: aBoolean [
	"Mainly for benchmarking purposes"

	self atAll: (first to: last) put: aBoolean.
	^ aBoolean
]
