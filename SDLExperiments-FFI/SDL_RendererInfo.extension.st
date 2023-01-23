Extension { #name : #'SDL_RendererInfo' }

{ #category : #'*SDLExperiments-FFI' }
SDL_RendererInfo >> isARGB8888Supported [

	^ self texture_formats includes: 372645892 "SDL_PIXELFORMAT_ARGB8888"
]

{ #category : #'*SDLExperiments-FFI' }
SDL_RendererInfo >> isXRGB8888Supported [
 
	^ self texture_formats includes: 370546692 "SDL_PIXELFORMAT_XRGB8888"
]

{ #category : #'*SDLExperiments-FFI' }
SDL_RendererInfo >> maxTextureExtent [
	
	^ self max_texture_width @ self max_texture_height
]

{ #category : #'*SDLExperiments-FFI' }
SDL_RendererInfo >> nameString [

	^ self name bytesFromCString utf8Decoded
]

{ #category : #'*SDLExperiments-FFI' }
SDL_RendererInfo >> printOn: aStream [

	super printOn: aStream.

	aStream
		nextPutAll: '(';
		nextPutAll: self nameString;
		nextPutAll: ' '.
	
	(#(isSoftware
	isAccelerated
	isSupportRenderTexture
	isSynchronizedWithRefreshRate)
		select:[ :each | (self perform: each) ])
			do: [ :each | aStream nextPutAll: each  ]
			separatedBy: [ aStream nextPutAll: ' ' ].

	aStream nextPutAll: ')'
]
