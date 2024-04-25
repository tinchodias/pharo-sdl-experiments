Extension { #name : 'SequenceableCollection' }

{ #category : '*SDLExperiments-BooleanArray' }
SequenceableCollection >> replaceFrom: first to: last withAll: aBoolean [
	"Mainly for benchmarking purposes"

	self atAll: (first to: last) put: aBoolean.
	^ aBoolean
]
