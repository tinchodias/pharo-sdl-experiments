Class {
	#name : 'ClippedElement',
	#superclass : 'SceneElement',
	#instVars : [
		'clipPathBlock',
		'clipTile',
		'clippedTargetTile'
	],
	#pools : [
		'SDL2Constants'
	],
	#category : 'SDLExperiments-Demo-Benchmarks',
	#package : 'SDLExperiments-Demo',
	#tag : 'Benchmarks'
}

{ #category : 'accessing' }
ClippedElement >> clipPathBlock: aUnaryBlockClosure [

	clipPathBlock := aUnaryBlockClosure
]

{ #category : 'private' }
ClippedElement >> ensureReadyToRender [

	super ensureReadyToRender.
	
	clipTile ifNotNil: [ ^ self ].

	self flag: #todo. "Ignores tile manager + leaking"
	clippedTargetTile := TargetTextureTile
		newWithSDLRenderer: sceneWindow sdlRenderer
		pixelExtent: pixelExtent
		deviceScalePoint: sceneWindow deviceScalePoint.
	clippedTargetTile
		createTexture;
		setBlendModeBlend "premultipliedAlpha?".

	clipTile := sceneWindow tileManager addTileOf: pixelExtent.
	clipTile
		createTexture;
		cairoContextToOverrideDo: [ :cairoContext |
			cairoContext
				in: clipPathBlock;
				sourceColor: Color white;
				fill ].
	
	clippedTargetTile beTargetDuring: [
		sceneWindow sdlRenderer
			drawColorR: 0 g: 0 b: 0 a: 0;
			clear.
		clipTile
			setBlendModeNone;
			renderTo: ExternalAddress null opacity: 255.
		tile
			setBlendModeMod; "SDL2 srcColorDstAlphaBlendMode?"
			renderTo: ExternalAddress null opacity: 255 ]
]

{ #category : 'rendering' }
ClippedElement >> render [

	clippedTargetTile renderTo: dstFRect opacity: opacityAsByte

]
