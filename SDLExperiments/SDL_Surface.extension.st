Extension { #name : #'SDL_Surface' }

{ #category : #'*SDLExperiments' }
SDL_Surface >> asFormARGB32 [
	"Answer a Form with my pixels. Assumes my format is SDL_PIXELFORMAT_ARGB8888."

	| result theData |
	self lockSurface.
	theData := FFIExternalArray
		fromHandle: self pixels getHandle
		type: FFIUInt32
		size: (self h * self pitch) >> 2.

	result := Form
		extent: self w @ self h
		depth: 32
		bits: (Bitmap newFrom: theData).

	self unlockSurface.
	^ result
]
