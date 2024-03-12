Extension { #name : 'SDL2MappedEvent' }

{ #category : '*SDLExperiments-FFI' }
SDL2MappedEvent class >> accessorsToPrint [

	^ (self selectors select: #isUnary) sorted
]

{ #category : '*SDLExperiments-FFI' }
SDL2MappedEvent >> printOn: aStream [

	super printOn: aStream.
	
	self class accessorsToPrint do: [ :each |
		aStream
			space;
			nextPutAll: each;
			nextPutAll: ': ';
			print: (self perform: each) ]

]
