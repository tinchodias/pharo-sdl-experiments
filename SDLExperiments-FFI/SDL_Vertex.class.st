"
I'm a binding to the struct `SDL_Vertex`.

A vertex for rendering geometries.

See: https://wiki.libsdl.org/SDL2/SDL_Vertex
"
Class {
	#name : 'SDL_Vertex',
	#superclass : 'SDL2Structure',
	#classVars : [
		'OFFSET_COLOR',
		'OFFSET_POSITION',
		'OFFSET_TEXCOORD'
	],
	#category : 'SDLExperiments-FFI',
	#package : 'SDLExperiments-FFI'
}

{ #category : 'field definition' }
SDL_Vertex class >> fieldsDesc [
	"
	self rebuildFieldAccessors
	"

	^ #(
		SDL_FPoint position;        "Vertex position, in SDL_Renderer coordinates"
		SDL_Color  color;           "Vertex color"
		SDL_FPoint texCoord;        "Normalized texture coordinates, if needed"
 		)
]

{ #category : 'accessing - structure variables' }
SDL_Vertex >> color [
	"This method was automatically generated"
	^ SDL_Color fromHandle: (handle referenceStructAt: OFFSET_COLOR length: SDL_Color byteSize)
]

{ #category : 'accessing - structure variables' }
SDL_Vertex >> color: anObject [
	"This method was automatically generated"
	handle structAt: OFFSET_COLOR put: anObject getHandle length: SDL_Color byteSize
]

{ #category : 'accessing - structure variables' }
SDL_Vertex >> position [
	"This method was automatically generated"
	^ SDL_FPoint fromHandle: (handle referenceStructAt: OFFSET_POSITION length: SDL_FPoint byteSize)
]

{ #category : 'accessing - structure variables' }
SDL_Vertex >> position: anObject [
	"This method was automatically generated"
	handle structAt: OFFSET_POSITION put: anObject getHandle length: SDL_FPoint byteSize
]

{ #category : 'printing' }
SDL_Vertex >> printOn: aStream [

	super printOn: aStream.
	aStream
		nextPut: $(;
		print: self position;
		space;
		print: self color;
		nextPut: $)
]

{ #category : 'accessing - structure variables' }
SDL_Vertex >> texCoord [
	"This method was automatically generated"
	^ SDL_FPoint fromHandle: (handle referenceStructAt: OFFSET_TEXCOORD length: SDL_FPoint byteSize)
]

{ #category : 'accessing - structure variables' }
SDL_Vertex >> texCoord: anObject [
	"This method was automatically generated"
	handle structAt: OFFSET_TEXCOORD put: anObject getHandle length: SDL_FPoint byteSize
]
