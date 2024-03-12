Extension { #name : 'SDL_Renderer' }

{ #category : '*SDLExperiments-FFI' }
SDL_Renderer >> copy: texture srcRect: srcRect dstRectF: dstRect [
	"See: https://wiki.libsdl.org/SDL_RenderCopyF"

	^ self ffiCall: #( 
		int 
		SDL_RenderCopyF (
			self,
			SDL_Texture texture,
			SDL_Rect * srcRect,
			SDL_FRect * dstRect) )

]

{ #category : '*SDLExperiments-FFI' }
SDL_Renderer >> disableVSync [
	"See: https://wiki.libsdl.org/SDL2/SDL_RenderSetVSync"

	^ self ffiCall: #(
		int
		SDL_RenderSetVSync (
			self,
			0 ) )
]

{ #category : '*SDLExperiments-FFI' }
SDL_Renderer >> enableVSync [
	"See: https://wiki.libsdl.org/SDL2/SDL_RenderSetVSync"

	^ self ffiCall: #(
		int
		SDL_RenderSetVSync (
			self,
			1 ) )
]

{ #category : '*SDLExperiments-FFI' }
SDL_Renderer >> fillRectF: rect [
	"See: https://wiki.libsdl.org/SDL2/SDL_RenderFillRectF"

	^ self ffiCall: #(
		int
		SDL_RenderFillRectF (
			self,
			SDL_FRect * rect ) )
]

{ #category : '*SDLExperiments-FFI' }
SDL_Renderer >> readPixelsInto: pixels pitch: pitch format: format rect: rect [
	"See: https://wiki.libsdl.org/SDL2/SDL_RenderReadPixels"

	^ self ffiCall: #(
		int
		SDL_RenderReadPixels (
			self,
			SDL_Rect * rect,
			Uint32 format,
			void * pixels,
			int pitch ) )

]

{ #category : '*SDLExperiments-FFI' }
SDL_Renderer >> renderGeometryRawXY: xy xyStride: xy_stride color: color colorStride: color_stride uv: uv uvStride: uv_stride numVertices: num_vertices indices: indices numIndices: num_indices sizeIndices: size_indices texture: texture [
	"See: https://wiki.libsdl.org/SDL2/SDL_RenderGeometryRaw"

	^ self ffiCall: #(
		int
		SDL_RenderGeometryRaw (
			self,
			SDL_Texture texture,
			float *xy, int xy_stride,
			SDL_Color *color, int color_stride,
			float *uv, int uv_stride,
			int num_vertices,
			void *indices, int num_indices, int size_indices) )
]

{ #category : '*SDLExperiments-FFI' }
SDL_Renderer >> renderGeometryVertices: vertices numVertices: num_vertices indices: indices numIndices: num_indices texture: texture [
	"See: https://wiki.libsdl.org/SDL2/SDL_RenderGeometry"

	^ self ffiCall: #(
		int
		SDL_RenderGeometry(
			self,
			SDL_Texture texture,
			SDL_Vertex *vertices, int num_vertices,
			void *indices, int num_indices ) )
]

{ #category : '*SDLExperiments-FFI' }
SDL_Renderer >> setDrawColor: aColor [

	^ self
		drawColorR: (SDL2 fromFloatToByte: aColor red)
		         g: (SDL2 fromFloatToByte: aColor green)
		         b: (SDL2 fromFloatToByte: aColor blue)
		         a: (SDL2 fromFloatToByte: aColor alpha)
	
]

{ #category : '*SDLExperiments-FFI' }
SDL_Renderer >> setVSync: vsync [
	"See: https://wiki.libsdl.org/SDL2/SDL_RenderSetVSync"

	^ self ffiCall: #(
		int
		SDL_RenderSetVSync (
			self,
			int vsync ) )
]
