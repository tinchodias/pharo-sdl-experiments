Extension { #name : #AeCairoImageSurface }

{ #category : #'*SDLExperiments' }
AeCairoImageSurface >> asSDLSurface [

	| data |
	data := FFIExternalArray externalNewType: FFIUInt8 size: self byteSize.
	LibC memCopy: self data to: data size: data size.

	^ (SDL2 createRGBSurfaceFromPixels: data
			width: self width height: self height
			depth: 32 pitch: self stride
			rmask: 16r00ff0000 
			gmask: 16r000ff00
			bmask: 16r00000ff
			amask: 16rff000000)
			autoRelease;
			yourself 
]
