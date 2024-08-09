Class {
	#name : #SceneDragAndDropDemo,
	#superclass : #SceneInteractiveDemo,
	#instVars : [
		'sceneWindowB',
		'isDragging',
		'draggingOffset',
		'windows',
		'cursorsByName',
		'currentCursorName'
	],
	#category : #'SDLExperiments-Demo-Interactive'
}

{ #category : #initialization }
SceneDragAndDropDemo >> initialize [

	super initialize.
	
	sceneWindowB := SceneWindow new.


]

{ #category : #initialization }
SceneDragAndDropDemo >> initializeCursors [ 
	"Precondition: SDL2 is already initialized."

	| cursorsDirectory cursorInfo |
	cursorsDirectory := SDLExperimentsFilesystemResources cursorsDirectory.
	cursorInfo := { 
		{ #pointer. 'icons8-cursor-32.png'. 2@2 }.
		{ #hand. 'icons8-hand-tool-32.png'. 16@16 }.
		{ #grab. 'icons8-grab-tool-32.png'. 16@16 }.
		}.

	cursorsByName := Dictionary new.	
	cursorInfo do: [ :each |
		| cursorCairoSurface sdlCursor f s |
		f := cursorsDirectory / each second.
		cursorCairoSurface := AeCairoImageSurface
			newFromPngFileAt: f.
		s := cursorCairoSurface asSDLSurface.
		sdlCursor := SDL2
			createColorCursorFrom: s
			hotX: each third x hotY: each third y.
		cursorsByName at: each first put: {sdlCursor. s} ].
	
	self setCursorNamed: #pointer.

]

{ #category : #private }
SceneDragAndDropDemo >> newSquareElement [

	| newElement squareSide padding |
	newElement := SceneElement new.

	squareSide := 150.
	padding := 1.

	newElement
		position: 0.0 asPoint;
		opacity: 1.0;
		extent: (squareSide + (padding*2)) asPoint;
		stepBlock: [ :deltaMS :totalMS | ];
		renderBlock: [ :cairoContext |
			| aGradient |
			aGradient := (AeCairoRadialGradientPattern
				innerCenter: 0@0
				innerRadius: 0
				outerCenter: 0@0
				outerRadius: squareSide)
					addStopAt: 0.0 color: Color blue;
					addStopAt: 1.0 color: Color black;
					yourself.

			cairoContext
				source: aGradient;
				rectangleX: padding
					y: padding
					width: squareSide
					height: squareSide;
				fill ].

	^ newElement
]

{ #category : #running }
SceneDragAndDropDemo >> open [

	| initialWindowSide gap |
	initialWindowSide := 500.
	gap := 70.

	"Window and Element A"
	sceneWindow
		useCappedSteppingLoop;
		initialPosition: gap @ gap;
		logicalExtent: initialWindowSide @ initialWindowSide;
		open;
		title: self windowTitle.
	sceneWindow steppingLoop start.
	sceneWindow addElement: self newSquareElement.

	"Window and Element B"
	sceneWindowB
		useCappedSteppingLoop;
		initialPosition: (2 * gap + initialWindowSide) @ gap;
		logicalExtent: initialWindowSide @ initialWindowSide;
		open;
		title: 'Drag the square!'.
	sceneWindowB steppingLoop start.
	sceneWindowB addElement: self newSquareElement.

	isDragging := false.

	"Place element at origin of second window"
	windows := { sceneWindow. sceneWindowB }.
	self
		positionElementAt: 0@0
		relativeToWindowId: sceneWindowB sdlWindow windowID.
	
	sdlMainLoop fork.
	self initializeCursors
]

{ #category : #private }
SceneDragAndDropDemo >> positionElementAt: aPoint relativeToWindowId: id [
	"Position the elements according to a position expressed as relative to a window's coordinates origin."

	| windowScreenPosition |
	windowScreenPosition := (self sceneWindowAt: id) sdlWindow position.

	windows do: [ :each |
		| eachWindow newPosition |
		eachWindow := each sdlWindow.
		newPosition :=
			eachWindow windowID = id
				ifTrue: [ aPoint ]
				ifFalse: [ aPoint + windowScreenPosition - eachWindow position ].
		each elements anyOne position: newPosition ]

]

{ #category : #visiting }
SceneDragAndDropDemo >> sceneWindowAt: id [
	
	^ windows detect: [ :each | each sdlWindow windowID = id ]
]

{ #category : #visiting }
SceneDragAndDropDemo >> setCursorAccordingTo: aSDL_MouseMotionEvent [
		
	| currentWindow candidateElement isHoveringElement |
	isDragging ifTrue: [ ^ self setCursorNamed: #grab ].
	
	currentWindow := self sceneWindowAt: aSDL_MouseMotionEvent windowID.
	candidateElement := currentWindow elements anyOne. "There is only one element"
	isHoveringElement := candidateElement boundingRectangle
		containsPoint: aSDL_MouseMotionEvent position.

	self setCursorNamed: (isHoveringElement
		ifTrue: [ #hand ]
		ifFalse: [ #pointer ]).

]

{ #category : #initialization }
SceneDragAndDropDemo >> setCursorNamed: aSymbol [ 

	cursorsByName ifNil: [
		^ 'setCursorNamed: sent before completing initialization.' traceCr ].

	aSymbol = currentCursorName ifTrue: [ ^self ].
	(cursorsByName at: aSymbol) first setCursor.
	currentCursorName := aSymbol.

]

{ #category : #visiting }
SceneDragAndDropDemo >> visitMouseButtonDownEvent: aSDL_MouseButtonDownEvent [

	| id currentWindow cursorPosition candidateElement |
	id := aSDL_MouseButtonDownEvent windowID.
	cursorPosition := aSDL_MouseButtonDownEvent x @ aSDL_MouseButtonDownEvent y.
	currentWindow := windows
		detect: [ :each | each sdlWindow windowID = id ].
	candidateElement := currentWindow elements anyOne. "Unique element"
	(candidateElement boundingRectangle containsPoint: cursorPosition) ifFalse: [ ^ self ].

	isDragging := true.
	draggingOffset := cursorPosition - candidateElement position
]

{ #category : #visiting }
SceneDragAndDropDemo >> visitMouseButtonUpEvent: aSDL_MouseButtonUpEvent [

	| id windowScreenPosition cursorScreenPosition |
	isDragging := false.


	id := aSDL_MouseButtonUpEvent windowID.
	windowScreenPosition := (self sceneWindowAt: id) sdlWindow position.
	cursorScreenPosition := aSDL_MouseButtonUpEvent position + windowScreenPosition.
	
	windows do: [ :each |
		((each logicalRectangle containsPoint: cursorScreenPosition)
		and: [ each sdlWindow windowID ~= id ])
			ifTrue: [ each sdlWindow raise ] ]

]

{ #category : #visiting }
SceneDragAndDropDemo >> visitMouseMotionEvent: aSDL_MouseMotionEvent [

	self setCursorAccordingTo: aSDL_MouseMotionEvent.
	isDragging ifFalse: [ ^self ].

	self
		positionElementAt: aSDL_MouseMotionEvent position - draggingOffset
		relativeToWindowId: aSDL_MouseMotionEvent windowID
]
