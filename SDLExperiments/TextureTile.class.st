"
I'm a `Tile` on a `SDL_Texture`. There are multiple alternative implementations that are expressed on my subclasses.
"
Class {
	#name : #TextureTile,
	#superclass : #Tile,
	#instVars : [
		'sdlRenderer',
		'sdlTexture',
		'deviceScalePoint',
		'pixelExtent',
		'sdlTextureOpacity'
	],
	#pools : [
		'SDL2Constants'
	],
	#category : #'SDLExperiments-Manager-Texture'
}

{ #category : #testing }
TextureTile class >> isAbstract [

	^ self == TextureTile
]

{ #category : #'instance creation' }
TextureTile class >> newWithSDLRenderer: aRenderer pixelExtent: aPoint deviceScalePoint: anotherPoint [

	^ self basicNew
		  initializeSDLRenderer: aRenderer
		  pixelExtent: aPoint
		  deviceScalePoint: anotherPoint;
		  yourself
]

{ #category : #'life cycle' }
TextureTile >> createCairoObjects [

	self subclassResponsibility
]

{ #category : #'life cycle' }
TextureTile >> createTexture [

	sdlTexture := 
		sdlRenderer
			createTextureFormat: self sdlTextureFormat
			access: self sdlTextureAccess
			width: pixelExtent x
			height: pixelExtent y.
	sdlTexture signalErrorIfNull.
	sdlTexture blendMode: self sdlTextureBlendMode.
	sdlTextureOpacity := 255.

	self createCairoObjects
]

{ #category : #'life cycle' }
TextureTile >> destroyTexture [

	sdlTexture ifNil: [ ^self ].
	sdlTexture destroy
]

{ #category : #initialization }
TextureTile >> initializeSDLRenderer: aRenderer pixelExtent: aPoint deviceScalePoint: anotherPoint [

	self initialize.

	sdlRenderer := aRenderer.
	deviceScalePoint := anotherPoint.
	pixelExtent := aPoint
]

{ #category : #rendering }
TextureTile >> renderTo: aSDLFRect opacity: alphaByte [

	"Could save time if alpha didn't change"
	sdlTextureOpacity = alphaByte ifFalse: [
		sdlTextureOpacity := alphaByte.
		sdlTexture
			colorModR: alphaByte
				g: alphaByte
				b: alphaByte;
			alphaMod: alphaByte ].
		
	sdlRenderer
		copy: sdlTexture
			srcRect: ExternalAddress null
			dstRectF: aSDLFRect
]

{ #category : #accessing }
TextureTile >> sdlTexture [

	^ sdlTexture
]

{ #category : #'life cycle' }
TextureTile >> sdlTextureAccess [

	^ self subclassResponsibility
]

{ #category : #'life cycle' }
TextureTile >> sdlTextureBlendMode [

	^ SDL2 premultipliedAlphaBlendMode
]

{ #category : #accessing }
TextureTile >> sdlTextureFormat [

	^ SDL_PIXELFORMAT_ARGB8888
]

{ #category : #initialization }
TextureTile >> setBlendModeAdd [

	sdlTexture blendMode: SDL_BLENDMODE_ADD
]

{ #category : #initialization }
TextureTile >> setBlendModeBlend [

	sdlTexture blendMode: SDL_BLENDMODE_BLEND
]

{ #category : #initialization }
TextureTile >> setBlendModeMod [

	sdlTexture blendMode: SDL_BLENDMODE_MOD
]

{ #category : #initialization }
TextureTile >> setBlendModeNone [

	sdlTexture blendMode: SDL_BLENDMODE_NONE
]

{ #category : #initialization }
TextureTile >> setBlendModePremultipliedAlpha [

	sdlTexture blendMode: SDL2 premultipliedAlphaBlendMode 
]
