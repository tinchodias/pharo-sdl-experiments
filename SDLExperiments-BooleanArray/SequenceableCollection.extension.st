Extension { #name : 'SequenceableCollection' }

{ #category : '*SDLExperiments-BooleanArray' }
SequenceableCollection >> includesTrueStartingAt: index [

	self indexOf: true startingAt: index ifAbsent: [ ^ false ].
	^ true
]

{ #category : '*SDLExperiments-BooleanArray' }
SequenceableCollection >> replaceFrom: first to: last withAll: aBoolean [
	"Mainly for benchmarking purposes"

	self atAll: (first to: last) put: aBoolean.
	^ aBoolean
]

{ #category : '*SDLExperiments-BooleanArray' }
SequenceableCollection >> shiftLeftBy: gap startingAt: start fillWithAll: fill [

	"Copy items some positions to the left"
	(start max: gap + 1) to: self size do: [ :index |
		self at: index - gap put: (self at: index) ].

	"Fill old positions with the received object"
	self
		replaceFrom: (self size - gap + 1 max: 1)
		to: self size
		withAll: fill
]

{ #category : '*SDLExperiments-BooleanArray' }
SequenceableCollection >> shiftRightBy: gap startingAt: start fillWithAll: fill [

	"Copy items some positions to the right"
	self size - gap to: start by: -1 do: [ :index |
		self at: index + gap put: (self at: index) ].

	"Fill old positions with the received object"
	self
		replaceFrom: start
		to: (start + gap - 1 min: self size)
		withAll: fill
]

{ #category : '*SDLExperiments-BooleanArray' }
SequenceableCollection >> toploShift: gap startingAt: start [
	"For testing and benchmarking purposes only"

	self isEmpty ifTrue: [ ^ self ].
	gap = 0 ifTrue: [ ^ self ].
	gap > 0
		ifTrue: [ self shiftRightBy: gap startingAt: start fillWithAll: false ]
		ifFalse: [
			"Special behavior when there isn't any true"
			(self includesTrueStartingAt: start) ifFalse: [ ^self ].
			self shiftLeftBy: gap negated startingAt: start fillWithAll: false ]
]
