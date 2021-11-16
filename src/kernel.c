
#include <stddef.h>
#include <stdint.h>

typedef struct {
	void* BaseAddress;
	size_t BufferSize;
	unsigned int Width;
	unsigned int Height;
	unsigned int PixelsPerScanLine;
} Framebuffer;

void _start(Framebuffer* framebuffer){
    unsigned int y = 50;
	unsigned int B8P = 4;

	for(unsigned int x = 0; x < framebuffer->Width / 2 * B8P; x+=B8P){
		*(unsigned int*)(x + (y * framebuffer->PixelsPerScanLine * B8P) + framebuffer->BaseAddress) = 0xff00ffff;
	}
    return;
}