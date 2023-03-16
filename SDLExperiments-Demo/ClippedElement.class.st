Class {
	#name : #ClippedElement,
	#superclass : #SceneElement,
	#instVars : [
		'maskTile',
		'maskedTargetTile',
		'clipPathBlock'
	],
	#pools : [
		'SDL2Constants'
	],
	#category : #'SDLExperiments-Demo-Benchmarks'
}

{ #category : #accessing }
ClippedElement >> clipPathBlock: aUnaryBlockClosure [

	clipPathBlock := aUnaryBlockClosure
]

{ #category : #private }
ClippedElement >> ensureReadyToRender [

	super ensureReadyToRender.
	
	maskTile ifNotNil: [ ^ self ].

	self flag: #todo. "Ignores tile manager + leaking"
	maskedTargetTile := TargetTextureTile
		newWithSDLRenderer: sceneWindow sdlRenderer
		pixelExtent: pixelExtent
		deviceScalePoint: sceneWindow deviceScalePoint.
	maskedTargetTile
		createTexture;
		setBlendModeBlend "premultipliedAlpha?".

	maskTile := sceneWindow tileManager addStaticTileOf: pixelExtent.
	maskTile
		createTexture;
		cairoContextToOverrideDo: [ :cairoContext |
			cairoContext
				in: clipPathBlock;
				sourceColorRGB: Color white;
				fill ].
	
	maskedTargetTile beTargetDuring: [
		sceneWindow sdlRenderer
			drawColorR: 0 g: 0 b: 0 a: 0;
			clear.
		maskTile
			setBlendModeNone;
			renderTo: ExternalAddress null opacity: 255.
		tile
			setBlendModeMod; "SDL2 srcColorDstAlphaBlendMode?"
			renderTo: ExternalAddress null opacity: 255 ]
]

{ #category : #rendering }
ClippedElement >> render [

	maskedTargetTile renderTo: dstFRect opacity: opacityAsByte

]
