/* The height of the bar (in pixels) */
#define BAR_HEIGHT  20
/* The width of the bar. Set to -1 to fit screen */
#define BAR_WIDTH   1920
/* Offset from the left. Set to 0 to have no effect */
#define BAR_OFFSET 0
/* Choose between an underline or an overline */
#define BAR_UNDERLINE 1
/* The thickness of the underline (in pixels). Set to 0 to disable. */
#define BAR_UNDERLINE_HEIGHT 2
/* Default bar position, overwritten by '-b' switch */
#define BAR_BOTTOM 0
/* The fonts used for the bar, comma separated. Only the first 2 will be used. */
#define BAR_FONT       "Roboto-10", "sm4tik-9", "Koruri-9"
/* Some fonts don't set the right width for some chars, pheex it */
#define BAR_FONT_FALLBACK_WIDTH 6
/* Define the opacity of the bar (requires a compositor such as compton) */
#define BAR_OPACITY 1.0 /* 0 is invisible, 1 is opaque */
/* Color palette */
#define BACKGROUND 0x111111
#define COLOR0 0xa3a6ab // default text
#define COLOR1 0x78a4ff // icon color
#define COLOR2 0xf6f9ff // active desktop
#define COLOR3 0x6d561c // urgent
#define COLOR4 0x6a9fb5  
#define COLOR5 0xaa759f
#define COLOR6 0x75b5aa
#define COLOR7 0x6c7a80
#define COLOR8 0x425059
#define COLOR9 0xcc6666
#define FOREGROUND 0xc5c8c6
