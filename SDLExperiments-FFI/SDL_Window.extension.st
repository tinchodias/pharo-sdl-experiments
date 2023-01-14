Extension { #name : #'SDL_Window' }

{ #category : #'*SDLExperiments-FFI' }
SDL_Window >> size [
	"Answer the logical size of this window. See renderer's outputSize for the pixel size."

	| w h |
	w := FFIInt32 newBuffer.
	h := FFIInt32 newBuffer.
	self getSizeW: w h: h.
	^ (w signedLongAt: 1) @ (h signedLongAt: 1)

]
