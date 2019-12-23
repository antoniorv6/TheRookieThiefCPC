#include "cash.h"
// Data created with Img2CPC - (c) Retroworks - 2007-2017
// Tile cash: 8x16 pixels, 4x16x2 bytes.
// Mask data is interlaced (MASK BYTE, DATA BYTE).
const u8 cash[2 * 4 * 16] = {
	0xaa, 0x40, 0x00, 0x03, 0x00, 0x33, 0x55, 0x22,
	0xaa, 0x40, 0x00, 0x03, 0x00, 0x33, 0x55, 0x22,
	0xff, 0x00, 0x00, 0x13, 0x00, 0x33, 0xff, 0x00,
	0xff, 0x00, 0x00, 0x13, 0x00, 0x33, 0xff, 0x00,
	0xaa, 0x40, 0x00, 0x03, 0x00, 0x13, 0x55, 0x22,
	0xaa, 0x40, 0x00, 0x03, 0x00, 0x13, 0x55, 0x22,
	0x00, 0x81, 0x00, 0x13, 0x00, 0x23, 0x00, 0x33,
	0x00, 0x81, 0x00, 0x13, 0x00, 0x23, 0x00, 0x33,
	0x00, 0x81, 0x00, 0x33, 0x00, 0x33, 0x00, 0x13,
	0x00, 0x81, 0x00, 0x33, 0x00, 0x33, 0x00, 0x13,
	0x00, 0x81, 0x00, 0x33, 0x00, 0x33, 0x00, 0x13,
	0x00, 0x81, 0x00, 0x33, 0x00, 0x33, 0x00, 0x13,
	0x00, 0x81, 0x00, 0x13, 0x00, 0x23, 0x00, 0x13,
	0x00, 0x81, 0x00, 0x13, 0x00, 0x23, 0x00, 0x13,
	0xaa, 0x40, 0x00, 0x03, 0x00, 0x03, 0x55, 0x22,
	0xaa, 0x40, 0x00, 0x03, 0x00, 0x03, 0x55, 0x22
};

