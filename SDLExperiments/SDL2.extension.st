Extension { #name : #SDL2 }

{ #category : #'*SDLExperiments' }
SDL2 class >> premultipliedAlphaBlendMode [
	"Answer the custom blend mode that corresponds to the well-known 'premultiplied alpha'.

	See: 
		https://www.adriancourreges.com/blog/2017/05/09/beware-of-transparent-pixels/
		https://www.realtimerendering.com/blog/gpus-prefer-premultiplication/
	"

	^ self
		composeCustomBlendMode_srcColorFactor: SDL_BLENDFACTOR_ONE
		dstColorFactor: SDL_BLENDFACTOR_ONE_MINUS_SRC_ALPHA
		colorOperation: SDL_BLENDOPERATION_ADD
		srcAlphaFactor: SDL_BLENDFACTOR_ONE
		dstAlphaFactor: SDL_BLENDFACTOR_ONE_MINUS_SRC_ALPHA
		alphaOperation: SDL_BLENDOPERATION_ADD

]
