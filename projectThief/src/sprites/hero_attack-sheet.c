#include "hero_attack-sheet.h"
// Data created with Img2CPC - (c) Retroworks - 2007-2017
// Tile attack_0: 8x32 pixels, 4x32x2 bytes.
// Mask data is interlaced (MASK BYTE, DATA BYTE).
const u8 attack_0[2 * 4 * 32] = {
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
	0x00, 0x64, 0x00, 0xcc, 0x00, 0x12, 0xff, 0x00,
	0x00, 0x64, 0x00, 0xcc, 0x00, 0x12, 0xff, 0x00,
	0x00, 0x30, 0x00, 0xcc, 0x00, 0x12, 0xff, 0x00,
	0x00, 0x30, 0x00, 0xcc, 0x00, 0x12, 0xff, 0x00,
	0xaa, 0x10, 0x00, 0x64, 0x00, 0x12, 0x00, 0x70,
	0xaa, 0x10, 0x00, 0x64, 0x00, 0x12, 0x00, 0x70,
	0xaa, 0x44, 0x00, 0x30, 0x00, 0x70, 0xff, 0x00,
	0xaa, 0x44, 0x00, 0x30, 0x00, 0x70, 0xff, 0x00,
	0xaa, 0x44, 0x00, 0xcc, 0x00, 0x12, 0xff, 0x00,
	0xaa, 0x44, 0x00, 0xcc, 0x00, 0x12, 0xff, 0x00,
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

// Tile attack_1: 8x32 pixels, 4x32x2 bytes.
// Mask data is interlaced (MASK BYTE, DATA BYTE).
const u8 attack_1[2 * 4 * 32] = {
	0xff, 0x00, 0xff, 0x00, 0xff, 0x00, 0xff, 0x00,
	0xff, 0x00, 0xff, 0x00, 0xff, 0x00, 0xff, 0x00,
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
	0x00, 0x30, 0x00, 0xcc, 0x00, 0x12, 0xff, 0x00,
	0x00, 0x30, 0x00, 0xcc, 0x00, 0x12, 0xff, 0x00,
	0x00, 0x30, 0x00, 0x70, 0x00, 0x12, 0x00, 0x70,
	0x00, 0x30, 0x00, 0x70, 0x00, 0x12, 0x00, 0x70,
	0xaa, 0x44, 0x00, 0xcc, 0x00, 0x12, 0xff, 0x00,
	0xaa, 0x44, 0x00, 0xcc, 0x00, 0x12, 0xff, 0x00,
	0xaa, 0x44, 0x00, 0xcc, 0x00, 0x12, 0xff, 0x00,
	0xaa, 0x44, 0x00, 0xcc, 0x00, 0x12, 0xff, 0x00,
	0xaa, 0x44, 0x00, 0xcc, 0x00, 0xe4, 0x55, 0x88,
	0xaa, 0x44, 0x00, 0xcc, 0x00, 0xe4, 0x55, 0x88,
	0xaa, 0x44, 0x00, 0xcc, 0x00, 0x30, 0x55, 0x88,
	0xaa, 0x44, 0x00, 0xcc, 0x00, 0x30, 0x55, 0x88,
	0xaa, 0x44, 0x00, 0x64, 0x00, 0xcc, 0x55, 0x20,
	0xaa, 0x44, 0x00, 0x64, 0x00, 0xcc, 0x55, 0x20,
	0x00, 0x30, 0x00, 0x64, 0xff, 0x00, 0x55, 0x20,
	0x00, 0x30, 0x00, 0x64, 0xff, 0x00, 0x55, 0x20
};

// Tile attack_2: 8x32 pixels, 4x32x2 bytes.
// Mask data is interlaced (MASK BYTE, DATA BYTE).
const u8 attack_2[2 * 4 * 32] = {
	0xff, 0x00, 0xff, 0x00, 0xff, 0x00, 0xff, 0x00,
	0xff, 0x00, 0xff, 0x00, 0xff, 0x00, 0xff, 0x00,
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
	0x00, 0x64, 0x00, 0xcc, 0x00, 0x12, 0xff, 0x00,
	0x00, 0x64, 0x00, 0xcc, 0x00, 0x12, 0xff, 0x00,
	0x00, 0x70, 0x00, 0xcc, 0x00, 0x12, 0x00, 0x70,
	0x00, 0x70, 0x00, 0xcc, 0x00, 0x12, 0x00, 0x70,
	0xaa, 0x44, 0x00, 0xcc, 0x00, 0x12, 0xff, 0x00,
	0xaa, 0x44, 0x00, 0xcc, 0x00, 0x12, 0xff, 0x00,
	0xaa, 0x44, 0x00, 0xcc, 0x00, 0x12, 0xff, 0x00,
	0xaa, 0x44, 0x00, 0xcc, 0x00, 0x12, 0xff, 0x00,
	0xaa, 0x44, 0x00, 0xcc, 0x00, 0xe4, 0x55, 0x88,
	0xaa, 0x44, 0x00, 0xcc, 0x00, 0xe4, 0x55, 0x88,
	0xaa, 0x44, 0x00, 0xcc, 0x00, 0x30, 0x55, 0x88,
	0xaa, 0x44, 0x00, 0xcc, 0x00, 0x30, 0x55, 0x88,
	0xaa, 0x44, 0x00, 0x64, 0x00, 0xcc, 0x55, 0x20,
	0xaa, 0x44, 0x00, 0x64, 0x00, 0xcc, 0x55, 0x20,
	0x00, 0x30, 0x00, 0x64, 0xff, 0x00, 0x55, 0x20,
	0x00, 0x30, 0x00, 0x64, 0xff, 0x00, 0x55, 0x20
};

// Tile attack_3: 8x32 pixels, 4x32x2 bytes.
// Mask data is interlaced (MASK BYTE, DATA BYTE).
const u8 attack_3[2 * 4 * 32] = {
	0xff, 0x00, 0xff, 0x00, 0xff, 0x00, 0xff, 0x00,
	0xff, 0x00, 0xff, 0x00, 0xff, 0x00, 0xff, 0x00,
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
	0x00, 0x30, 0x00, 0xcc, 0x00, 0x12, 0xff, 0x00,
	0x00, 0x30, 0x00, 0xcc, 0x00, 0x12, 0xff, 0x00,
	0x00, 0x30, 0x00, 0x70, 0x00, 0x12, 0x00, 0x70,
	0x00, 0x30, 0x00, 0x70, 0x00, 0x12, 0x00, 0x70,
	0xaa, 0x44, 0x00, 0xcc, 0x00, 0x12, 0xff, 0x00,
	0xaa, 0x44, 0x00, 0xcc, 0x00, 0x12, 0xff, 0x00,
	0xaa, 0x44, 0x00, 0xcc, 0x00, 0x12, 0xff, 0x00,
	0xaa, 0x44, 0x00, 0xcc, 0x00, 0x12, 0xff, 0x00,
	0xaa, 0x44, 0x00, 0xcc, 0x00, 0xe4, 0x55, 0x88,
	0xaa, 0x44, 0x00, 0xcc, 0x00, 0xe4, 0x55, 0x88,
	0xaa, 0x44, 0x00, 0xcc, 0x00, 0x30, 0x55, 0x88,
	0xaa, 0x44, 0x00, 0xcc, 0x00, 0x30, 0x55, 0x88,
	0xaa, 0x44, 0x00, 0x64, 0x00, 0xcc, 0x55, 0x20,
	0xaa, 0x44, 0x00, 0x64, 0x00, 0xcc, 0x55, 0x20,
	0x00, 0x30, 0x00, 0x64, 0xff, 0x00, 0x55, 0x20,
	0x00, 0x30, 0x00, 0x64, 0xff, 0x00, 0x55, 0x20
};

// Tile attack_4: 8x32 pixels, 4x32x2 bytes.
// Mask data is interlaced (MASK BYTE, DATA BYTE).
const u8 attack_4[2 * 4 * 32] = {
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
	0x00, 0x64, 0x00, 0xcc, 0x00, 0x12, 0xff, 0x00,
	0x00, 0x64, 0x00, 0xcc, 0x00, 0x12, 0xff, 0x00,
	0x00, 0x30, 0x00, 0x30, 0x00, 0xb0, 0xff, 0x00,
	0x00, 0x30, 0x00, 0x30, 0x00, 0xb0, 0xff, 0x00,
	0xaa, 0x44, 0x00, 0xcc, 0x00, 0x12, 0x55, 0xa0,
	0xaa, 0x44, 0x00, 0xcc, 0x00, 0x12, 0x55, 0xa0,
	0xaa, 0x44, 0x00, 0xcc, 0x00, 0x12, 0xff, 0x00,
	0xaa, 0x44, 0x00, 0xcc, 0x00, 0x12, 0xff, 0x00,
	0xaa, 0x44, 0x00, 0xcc, 0x00, 0x12, 0xff, 0x00,
	0xaa, 0x44, 0x00, 0xcc, 0x00, 0x12, 0xff, 0x00,
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

// Tile attack_5: 8x32 pixels, 4x32x2 bytes.
// Mask data is interlaced (MASK BYTE, DATA BYTE).
const u8 attack_5[2 * 4 * 32] = {
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
	0x00, 0x30, 0x00, 0x30, 0x00, 0x30, 0x00, 0x70,
	0x00, 0x30, 0x00, 0x30, 0x00, 0x30, 0x00, 0x70,
	0x00, 0x64, 0x00, 0xcc, 0x00, 0x12, 0xff, 0x00,
	0x00, 0x64, 0x00, 0xcc, 0x00, 0x12, 0xff, 0x00,
	0xaa, 0x44, 0x00, 0xcc, 0x00, 0x12, 0xff, 0x00,
	0xaa, 0x44, 0x00, 0xcc, 0x00, 0x12, 0xff, 0x00,
	0xaa, 0x44, 0x00, 0xcc, 0x00, 0x12, 0xff, 0x00,
	0xaa, 0x44, 0x00, 0xcc, 0x00, 0x12, 0xff, 0x00,
	0xaa, 0x44, 0x00, 0xcc, 0x00, 0x12, 0xff, 0x00,
	0xaa, 0x44, 0x00, 0xcc, 0x00, 0x12, 0xff, 0x00,
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

// Tile attack_6: 8x32 pixels, 4x32x2 bytes.
// Mask data is interlaced (MASK BYTE, DATA BYTE).
const u8 attack_6[2 * 4 * 32] = {
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
	0x00, 0x64, 0x00, 0xcc, 0x00, 0x12, 0xff, 0x00,
	0x00, 0x64, 0x00, 0xcc, 0x00, 0x12, 0xff, 0x00,
	0x00, 0x30, 0x00, 0x30, 0x00, 0xb0, 0xff, 0x00,
	0x00, 0x30, 0x00, 0x30, 0x00, 0xb0, 0xff, 0x00,
	0xaa, 0x44, 0x00, 0xcc, 0x00, 0x12, 0x55, 0xa0,
	0xaa, 0x44, 0x00, 0xcc, 0x00, 0x12, 0x55, 0xa0,
	0xaa, 0x44, 0x00, 0xcc, 0x00, 0x12, 0xff, 0x00,
	0xaa, 0x44, 0x00, 0xcc, 0x00, 0x12, 0xff, 0x00,
	0xaa, 0x44, 0x00, 0xcc, 0x00, 0x12, 0xff, 0x00,
	0xaa, 0x44, 0x00, 0xcc, 0x00, 0x12, 0xff, 0x00,
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

// Tile attack_7: 8x32 pixels, 4x32x2 bytes.
// Mask data is interlaced (MASK BYTE, DATA BYTE).
const u8 attack_7[2 * 4 * 32] = {
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
	0x00, 0x64, 0x00, 0xcc, 0x00, 0x12, 0xff, 0x00,
	0x00, 0x64, 0x00, 0xcc, 0x00, 0x12, 0xff, 0x00,
	0x00, 0x30, 0x00, 0xcc, 0x00, 0x12, 0xff, 0x00,
	0x00, 0x30, 0x00, 0xcc, 0x00, 0x12, 0xff, 0x00,
	0x00, 0x30, 0x00, 0x70, 0x00, 0x12, 0x00, 0x70,
	0x00, 0x30, 0x00, 0x70, 0x00, 0x12, 0x00, 0x70,
	0xaa, 0x44, 0x00, 0xcc, 0x00, 0x12, 0xff, 0x00,
	0xaa, 0x44, 0x00, 0xcc, 0x00, 0x12, 0xff, 0x00,
	0xaa, 0x44, 0x00, 0xcc, 0x00, 0x12, 0xff, 0x00,
	0xaa, 0x44, 0x00, 0xcc, 0x00, 0x12, 0xff, 0x00,
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

// Tile attack_8: 8x32 pixels, 4x32x2 bytes.
// Mask data is interlaced (MASK BYTE, DATA BYTE).
const u8 attack_8[2 * 4 * 32] = {
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
	0x00, 0x64, 0x00, 0xcc, 0x00, 0x12, 0xff, 0x00,
	0x00, 0x64, 0x00, 0xcc, 0x00, 0x12, 0xff, 0x00,
	0x00, 0x30, 0x00, 0xcc, 0x00, 0x12, 0xff, 0x00,
	0x00, 0x30, 0x00, 0xcc, 0x00, 0x12, 0xff, 0x00,
	0xaa, 0x10, 0x00, 0x64, 0x00, 0x12, 0x00, 0x70,
	0xaa, 0x10, 0x00, 0x64, 0x00, 0x12, 0x00, 0x70,
	0xaa, 0x44, 0x00, 0x30, 0x00, 0x70, 0xff, 0x00,
	0xaa, 0x44, 0x00, 0x30, 0x00, 0x70, 0xff, 0x00,
	0xaa, 0x44, 0x00, 0xcc, 0x00, 0x12, 0xff, 0x00,
	0xaa, 0x44, 0x00, 0xcc, 0x00, 0x12, 0xff, 0x00,
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

