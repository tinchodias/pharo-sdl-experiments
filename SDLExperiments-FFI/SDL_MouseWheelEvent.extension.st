Extension { #name : #'SDL_MouseWheelEvent' }

{ #category : #'*SDLExperiments-FFI' }
SDL_MouseWheelEvent class >> fieldsDesc2 [
	" --> REMOVE the 2 and rebuild <--

	self rebuildFieldAccessors
	"
	^ #(
    Uint32 type;
    Uint32 timestamp;
    Uint32 windowID;
    Uint32 which;
    Sint32 x;
    Sint32 y;
    Uint32 direction;
    float preciseX;
    float preciseY;
 	)
]
