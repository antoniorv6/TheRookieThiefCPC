#include "hero_run-sheet.h"
// Data created with Img2CPC - (c) Retroworks - 2007-2017
// Tile run_0: 8x32 pixels, 4x32x2 bytes.
// Mask data is interlaced (MASK BYTE, DATA BYTE).
const u8 run_0[2 * 4 * 32] = {
	0xff, 0x00, 0xff, 0x00, 0xff, 0x00, 0xff, 0x00,
	0xff, 0x00, 0xff, 0x00, 0xff, 0x00, 0xff, 0x00,
	0x00, 0xcc, 0x00, 0x31, 0xff, 0x00, 0xff, 0x00,
	0x00, 0xcc, 0x00, 0x31, 0xff, 0x00, 0xff, 0x00,
	0xaa, 0x44, 0x00, 0x98, 0x00, 0x31, 0xff, 0x00,
	0xaa, 0x44, 0x00, 0x98, 0x00, 0x31, 0xff, 0x00,
	0xaa, 0x44, 0x00, 0x98, 0x00, 0x30, 0x55, 0x20,
	0xaa, 0x44, 0x00, 0x98, 0x00, 0x30, 0x55, 0x20,
	0xaa, 0x44, 0x00, 0x13, 0x00, 0x13, 0x55, 0x20,
	0xaa, 0x44, 0x00, 0x13, 0x00, 0x13, 0x55, 0x20,
	0xaa, 0x44, 0x00, 0x30, 0x00, 0x30, 0x55, 0x20,
	0xaa, 0x44, 0x00, 0x30, 0x00, 0x30, 0x55, 0x20,
	0xaa, 0x10, 0x00, 0xcc, 0x00, 0x98, 0xff, 0x00,
	0xaa, 0x10, 0x00, 0xcc, 0x00, 0x98, 0xff, 0x00,
	0xaa, 0x10, 0x00, 0x64, 0x00, 0x98, 0xff, 0x00,
	0xaa, 0x10, 0x00, 0x64, 0x00, 0x98, 0xff, 0x00,
	0xff, 0x00, 0x00, 0x30, 0x00, 0x98, 0xff, 0x00,
	0xff, 0x00, 0x00, 0x30, 0x00, 0x98, 0xff, 0x00,
	0xff, 0x00, 0x00, 0x98, 0x00, 0x70, 0xff, 0x00,
	0xff, 0x00, 0x00, 0x98, 0x00, 0x70, 0xff, 0x00,
	0xff, 0x00, 0x00, 0xcc, 0x00, 0xcc, 0xff, 0x00,
	0xff, 0x00, 0x00, 0xcc, 0x00, 0xcc, 0xff, 0x00,
	0xaa, 0x44, 0x00, 0xcc, 0x00, 0xe4, 0x55, 0x88,
	0xaa, 0x44, 0x00, 0xcc, 0x00, 0xe4, 0x55, 0x88,
	0xaa, 0x44, 0x00, 0xcc, 0x00, 0x30, 0x55, 0x88,
	0xaa, 0x44, 0x00, 0xcc, 0x00, 0x30, 0x55, 0x88,
	0xaa, 0x44, 0x00, 0x64, 0x00, 0xcc, 0x55, 0x20,
	0xaa, 0x44, 0x00, 0x64, 0x00, 0xcc, 0x55, 0x20,
	0xaa, 0x10, 0xaa, 0x44, 0xff, 0x00, 0x55, 0x20,
	0xaa, 0x10, 0xaa, 0x44, 0xff, 0x00, 0x55, 0x20,
	0x55, 0x20, 0xff, 0x00, 0xff, 0x00, 0x55, 0x20,
	0x55, 0x20, 0xff, 0x00, 0xff, 0x00, 0x55, 0x20
};

// Tile run_1: 8x32 pixels, 4x32x2 bytes.
// Mask data is interlaced (MASK BYTE, DATA BYTE).
const u8 run_1[2 * 4 * 32] = {
	0x55, 0x88, 0xff, 0x00, 0xff, 0x00, 0xff, 0x00,
	0x55, 0x88, 0xff, 0x00, 0xff, 0x00, 0xff, 0x00,
	0x00, 0xcc, 0x00, 0x31, 0xff, 0x00, 0xff, 0x00,
	0x00, 0xcc, 0x00, 0x31, 0xff, 0x00, 0xff, 0x00,
	0xaa, 0x44, 0x00, 0x98, 0x00, 0x31, 0xff, 0x00,
	0xaa, 0x44, 0x00, 0x98, 0x00, 0x31, 0xff, 0x00,
	0xaa, 0x44, 0x00, 0x98, 0x00, 0x30, 0x55, 0x20,
	0xaa, 0x44, 0x00, 0x98, 0x00, 0x30, 0x55, 0x20,
	0xaa, 0x44, 0x00, 0x13, 0x00, 0x13, 0x55, 0x20,
	0xaa, 0x44, 0x00, 0x13, 0x00, 0x13, 0x55, 0x20,
	0xaa, 0x44, 0x00, 0x30, 0x00, 0x30, 0x55, 0x20,
	0xaa, 0x44, 0x00, 0x30, 0x00, 0x30, 0x55, 0x20,
	0x00, 0x64, 0x00, 0xcc, 0x00, 0x12, 0xff, 0x00,
	0x00, 0x64, 0x00, 0xcc, 0x00, 0x12, 0xff, 0x00,
	0x00, 0x30, 0x00, 0xe4, 0x00, 0x12, 0xff, 0x00,
	0x00, 0x30, 0x00, 0xe4, 0x00, 0x12, 0xff, 0x00,
	0xaa, 0x44, 0x00, 0xcc, 0x00, 0x12, 0x00, 0x70,
	0xaa, 0x44, 0x00, 0xcc, 0x00, 0x12, 0x00, 0x70,
	0xaa, 0x44, 0x00, 0xcc, 0x00, 0x12, 0xff, 0x00,
	0xaa, 0x44, 0x00, 0xcc, 0x00, 0x12, 0xff, 0x00,
	0xaa, 0x44, 0x00, 0xcc, 0x00, 0x12, 0xff, 0x00,
	0xaa, 0x44, 0x00, 0xcc, 0x00, 0x12, 0xff, 0x00,
	0x00, 0xcc, 0x00, 0xcc, 0x00, 0xcc, 0x55, 0x88,
	0x00, 0xcc, 0x00, 0xcc, 0x00, 0xcc, 0x55, 0x88,
	0x00, 0xcc, 0x00, 0xcc, 0x00, 0xcc, 0x55, 0x88,
	0x00, 0xcc, 0x00, 0xcc, 0x00, 0xcc, 0x55, 0x88,
	0x00, 0xcc, 0x00, 0x64, 0x00, 0xcc, 0xff, 0x00,
	0x00, 0xcc, 0x00, 0x64, 0x00, 0xcc, 0xff, 0x00,
	0xaa, 0x44, 0xaa, 0x44, 0x55, 0x20, 0xff, 0x00,
	0xaa, 0x44, 0xaa, 0x44, 0x55, 0x20, 0xff, 0x00,
	0xff, 0x00, 0xff, 0x00, 0x55, 0x20, 0xff, 0x00,
	0xff, 0x00, 0xff, 0x00, 0x55, 0x20, 0xff, 0x00
};

// Tile run_2: 8x32 pixels, 4x32x2 bytes.
// Mask data is interlaced (MASK BYTE, DATA BYTE).
const u8 run_2[2 * 4 * 32] = {
	0x55, 0x88, 0xff, 0x00, 0xff, 0x00, 0xff, 0x00,
	0x55, 0x88, 0xff, 0x00, 0xff, 0x00, 0xff, 0x00,
	0x00, 0xcc, 0x00, 0x31, 0xff, 0x00, 0xff, 0x00,
	0x00, 0xcc, 0x00, 0x31, 0xff, 0x00, 0xff, 0x00,
	0xaa, 0x44, 0x00, 0x98, 0x00, 0x31, 0xff, 0x00,
	0xaa, 0x44, 0x00, 0x98, 0x00, 0x31, 0xff, 0x00,
	0xaa, 0x44, 0x00, 0x98, 0x00, 0x30, 0x55, 0x20,
	0xaa, 0x44, 0x00, 0x98, 0x00, 0x30, 0x55, 0x20,
	0xaa, 0x44, 0x00, 0x13, 0x00, 0x13, 0x55, 0x20,
	0xaa, 0x44, 0x00, 0x13, 0x00, 0x13, 0x55, 0x20,
	0xaa, 0x44, 0x00, 0x30, 0x00, 0x30, 0x55, 0x20,
	0xaa, 0x44, 0x00, 0x30, 0x00, 0x30, 0x55, 0x20,
	0xaa, 0x10, 0x00, 0xcc, 0x00, 0xcc, 0xff, 0x00,
	0xaa, 0x10, 0x00, 0xcc, 0x00, 0xcc, 0xff, 0x00,
	0xaa, 0x10, 0x00, 0x64, 0x00, 0xcc, 0xff, 0x00,
	0xaa, 0x10, 0x00, 0x64, 0x00, 0xcc, 0xff, 0x00,
	0xff, 0x00, 0x00, 0x30, 0x00, 0xe4, 0xff, 0x00,
	0xff, 0x00, 0x00, 0x30, 0x00, 0xe4, 0xff, 0x00,
	0xff, 0x00, 0x00, 0xcc, 0x00, 0xcc, 0xff, 0x00,
	0xff, 0x00, 0x00, 0xcc, 0x00, 0xcc, 0xff, 0x00,
	0xaa, 0x44, 0x00, 0xcc, 0x00, 0x46, 0xff, 0x00,
	0xaa, 0x44, 0x00, 0xcc, 0x00, 0x46, 0xff, 0x00,
	0xaa, 0x44, 0x00, 0xcc, 0x00, 0xe4, 0x55, 0x88,
	0xaa, 0x44, 0x00, 0xcc, 0x00, 0xe4, 0x55, 0x88,
	0xaa, 0x44, 0x00, 0xcc, 0x00, 0x64, 0x55, 0x88,
	0xaa, 0x44, 0x00, 0xcc, 0x00, 0x64, 0x55, 0x88,
	0x00, 0xcc, 0x00, 0x64, 0x00, 0x98, 0x55, 0x88,
	0x00, 0xcc, 0x00, 0x64, 0x00, 0x98, 0x55, 0x88,
	0x55, 0x88, 0x00, 0x64, 0xff, 0x00, 0x55, 0x20,
	0x55, 0x88, 0x00, 0x64, 0xff, 0x00, 0x55, 0x20,
	0xaa, 0x10, 0xff, 0x00, 0xff, 0x00, 0x55, 0x20,
	0xaa, 0x10, 0xff, 0x00, 0xff, 0x00, 0x55, 0x20
};

