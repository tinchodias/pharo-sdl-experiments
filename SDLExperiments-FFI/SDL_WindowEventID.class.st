"
I'm a binding to the SDL2 enum named `SDL_WindowEventID`.

See: https://wiki.libsdl.org/SDL2/SDL_WindowEventID
"
Class {
	#name : 'SDL_WindowEventID',
	#superclass : 'FFIEnumeration',
	#classVars : [
		'SDL_WINDOWEVENT_CLOSE',
		'SDL_WINDOWEVENT_DISPLAY_CHANGED',
		'SDL_WINDOWEVENT_ENTER',
		'SDL_WINDOWEVENT_EXPOSED',
		'SDL_WINDOWEVENT_FOCUS_GAINED',
		'SDL_WINDOWEVENT_FOCUS_LOST',
		'SDL_WINDOWEVENT_HIDDEN',
		'SDL_WINDOWEVENT_HIT_TEST',
		'SDL_WINDOWEVENT_ICCPROF_CHANGED',
		'SDL_WINDOWEVENT_LEAVE',
		'SDL_WINDOWEVENT_MAXIMIZED',
		'SDL_WINDOWEVENT_MINIMIZED',
		'SDL_WINDOWEVENT_MOVED',
		'SDL_WINDOWEVENT_NONE',
		'SDL_WINDOWEVENT_RESIZED',
		'SDL_WINDOWEVENT_RESTORED',
		'SDL_WINDOWEVENT_SHOWN',
		'SDL_WINDOWEVENT_SIZE_CHANGED',
		'SDL_WINDOWEVENT_TAKE_FOCUS'
	],
	#category : 'SDLExperiments-FFI',
	#package : 'SDLExperiments-FFI'
}

{ #category : 'accessing enum' }
SDL_WindowEventID class >> SDL_WINDOWEVENT_CLOSE [
	"This method was automatically generated"
	^ SDL_WINDOWEVENT_CLOSE
]

{ #category : 'accessing enum' }
SDL_WindowEventID class >> SDL_WINDOWEVENT_DISPLAY_CHANGED [
	"This method was automatically generated"
	^ SDL_WINDOWEVENT_DISPLAY_CHANGED
]

{ #category : 'accessing enum' }
SDL_WindowEventID class >> SDL_WINDOWEVENT_ENTER [
	"This method was automatically generated"
	^ SDL_WINDOWEVENT_ENTER
]

{ #category : 'accessing enum' }
SDL_WindowEventID class >> SDL_WINDOWEVENT_EXPOSED [
	"This method was automatically generated"
	^ SDL_WINDOWEVENT_EXPOSED
]

{ #category : 'accessing enum' }
SDL_WindowEventID class >> SDL_WINDOWEVENT_FOCUS_GAINED [
	"This method was automatically generated"
	^ SDL_WINDOWEVENT_FOCUS_GAINED
]

{ #category : 'accessing enum' }
SDL_WindowEventID class >> SDL_WINDOWEVENT_FOCUS_LOST [
	"This method was automatically generated"
	^ SDL_WINDOWEVENT_FOCUS_LOST
]

{ #category : 'accessing enum' }
SDL_WindowEventID class >> SDL_WINDOWEVENT_HIDDEN [
	"This method was automatically generated"
	^ SDL_WINDOWEVENT_HIDDEN
]

{ #category : 'accessing enum' }
SDL_WindowEventID class >> SDL_WINDOWEVENT_HIT_TEST [
	"This method was automatically generated"
	^ SDL_WINDOWEVENT_HIT_TEST
]

{ #category : 'accessing enum' }
SDL_WindowEventID class >> SDL_WINDOWEVENT_ICCPROF_CHANGED [
	"This method was automatically generated"
	^ SDL_WINDOWEVENT_ICCPROF_CHANGED
]

{ #category : 'accessing enum' }
SDL_WindowEventID class >> SDL_WINDOWEVENT_LEAVE [
	"This method was automatically generated"
	^ SDL_WINDOWEVENT_LEAVE
]

{ #category : 'accessing enum' }
SDL_WindowEventID class >> SDL_WINDOWEVENT_MAXIMIZED [
	"This method was automatically generated"
	^ SDL_WINDOWEVENT_MAXIMIZED
]

{ #category : 'accessing enum' }
SDL_WindowEventID class >> SDL_WINDOWEVENT_MINIMIZED [
	"This method was automatically generated"
	^ SDL_WINDOWEVENT_MINIMIZED
]

{ #category : 'accessing enum' }
SDL_WindowEventID class >> SDL_WINDOWEVENT_MOVED [
	"This method was automatically generated"
	^ SDL_WINDOWEVENT_MOVED
]

{ #category : 'accessing enum' }
SDL_WindowEventID class >> SDL_WINDOWEVENT_NONE [
	"This method was automatically generated"
	^ SDL_WINDOWEVENT_NONE
]

{ #category : 'accessing enum' }
SDL_WindowEventID class >> SDL_WINDOWEVENT_RESIZED [
	"This method was automatically generated"
	^ SDL_WINDOWEVENT_RESIZED
]

{ #category : 'accessing enum' }
SDL_WindowEventID class >> SDL_WINDOWEVENT_RESTORED [
	"This method was automatically generated"
	^ SDL_WINDOWEVENT_RESTORED
]

{ #category : 'accessing enum' }
SDL_WindowEventID class >> SDL_WINDOWEVENT_SHOWN [
	"This method was automatically generated"
	^ SDL_WINDOWEVENT_SHOWN
]

{ #category : 'accessing enum' }
SDL_WindowEventID class >> SDL_WINDOWEVENT_SIZE_CHANGED [
	"This method was automatically generated"
	^ SDL_WINDOWEVENT_SIZE_CHANGED
]

{ #category : 'accessing enum' }
SDL_WindowEventID class >> SDL_WINDOWEVENT_TAKE_FOCUS [
	"This method was automatically generated"
	^ SDL_WINDOWEVENT_TAKE_FOCUS
]

{ #category : 'enum declaration' }
SDL_WindowEventID class >> enumDecl [
	"
	self rebuildEnumAccessors
	"
	^ #(
    SDL_WINDOWEVENT_NONE             0 "Never used"
    SDL_WINDOWEVENT_SHOWN            1 "Window has been shown"
    SDL_WINDOWEVENT_HIDDEN           2 "Window has been hidden"
    SDL_WINDOWEVENT_EXPOSED          3 "Window has been exposed and should be redrawn"
    SDL_WINDOWEVENT_MOVED            4 "Window has been moved to data1 data2"
    SDL_WINDOWEVENT_RESIZED          5 "Window has been resized to data1xdata2"
    SDL_WINDOWEVENT_SIZE_CHANGED     6 "The window size has changed either as
                                          a result of an API call or through the
                                          system or user changing the window size."
    SDL_WINDOWEVENT_MINIMIZED        7 "Window has been minimized"
    SDL_WINDOWEVENT_MAXIMIZED        8 "Window has been maximized"
    SDL_WINDOWEVENT_RESTORED         9 "Window has been restored to normal size and position"
    SDL_WINDOWEVENT_ENTER           10 "Window has gained mouse focus"
    SDL_WINDOWEVENT_LEAVE           11 "Window has lost mouse focus"
    SDL_WINDOWEVENT_FOCUS_GAINED    12 "Window has gained keyboard focus"
    SDL_WINDOWEVENT_FOCUS_LOST      13 "Window has lost keyboard focus"
    SDL_WINDOWEVENT_CLOSE           14 "The window manager requests that the window be closed"
    SDL_WINDOWEVENT_TAKE_FOCUS      15 "Window is being offered a focus (should SetWindowInputFocus() on itself or a subwindow or ignore)"
    SDL_WINDOWEVENT_HIT_TEST        16 "Window had a hit test that wasn't SDL_HITTEST_NORMAL."
    SDL_WINDOWEVENT_ICCPROF_CHANGED 17 "The ICC profile of the window's display has changed."
    SDL_WINDOWEVENT_DISPLAY_CHANGED 18 "Window has been moved to display data1."
	)
]

{ #category : 'initialization' }
SDL_WindowEventID class >> initialize [
	self initializeEnumeration
]
