/* Taken from https://github.com/djpohly/dwl/issues/466 */
#define COLOR(hex)    { ((hex >> 24) & 0xFF) / 255.0f, \
                        ((hex >> 16) & 0xFF) / 255.0f, \
                        ((hex >> 8) & 0xFF) / 255.0f, \
                        (hex & 0xFF) / 255.0f }

static const float rootcolor[]             = COLOR(0x291b11ff);
static uint32_t colors[][3]                = {
	/*               fg          bg          border    */
	[SchemeNorm] = { 0xc9c6c3ff, 0x291b11ff, 0x766960ff },
	[SchemeSel]  = { 0xc9c6c3ff, 0x8D5F30ff, 0xCE3B21ff },
	[SchemeUrg]  = { 0xc9c6c3ff, 0xCE3B21ff, 0x8D5F30ff },
};
