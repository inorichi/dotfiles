#include <X11/XF86keysym.h>

/* appearance */
static const char font[]            = "DejaVu Sans Mono:medium:pixelsize=14";
static const unsigned int borderpx  = 1;        /* border pixel of windows */
static const unsigned int snap      = 16;       /* snap pixel */
static const unsigned int progpx    = 50;       /* progress bar width */
static const unsigned int progh     = 2;        /* progress bar height */
static const unsigned int gap       = 2;        /* gap between windows */
static const Bool showbar           = True;     /* False means no bar */
static const Bool topbar            = True;     /* False means bottom bar */

#define BLACK  "#121212"
#define DGRAY  "#434343"
#define LGRAY  "#E0E0E0"
#define RED    "#CF4F88"
#define WHITE  "#696969"
#define ORANGE "#D64937"


static const char color[NUMCOL][ColLast][8] = {
    /* border foreground background */
    { DGRAY,   WHITE,     BLACK     }, /* 0 = unselected, unoccupied */
    { ORANGE,  LGRAY,     WHITE     }, /* 1 = selected, occupied */
    { RED,     RED,       BLACK     }, /* 2 = urgent */
    { DGRAY,   LGRAY,     BLACK     }, /* 3 = unselected, occupied */
    { DGRAY,   WHITE,     DGRAY     }, /* 4 = selected, unoccupied */
};

static const char clock_fmt[] = "%a, %I:%M %p";

/* tagging */
#define NTAGS 5

static const Rule rules[] = {
    /* xprop(1):
     *    WM_CLASS(STRING) = instance, class
     *    WM_NAME(STRING) = title
     */
    /* class     instance    title         tags mask     isfloating   monitor */
    { "Firefox", "Navigator", NULL       , 1 << 0,       False,       -1 },
    { "Firefox", "Download",  "Downloads", 0,            True,        -1 },
    { "VBoxSDL", "VBoxSDL",   NULL,        0,            True,        -1 },
};

/* layout(s) */
static const float mfact      = 0.50; /* factor of master area size [0.05..0.95] */
static const int nmaster      = 1;    /* number of clients in master area */
static const Bool resizehints = False; /* True means respect size hints in tiled resizals */

static const Layout layouts[] = {
    { tile      },    /* first entry is default */
    { bstack    },
    { grid      },
    { monocle   },
    { NULL      },    /* no layout function means floating behavior */
};

/* key definitions */
#define MODKEY Mod4Mask
#define ALTKEY Mod1Mask
#define TAGKEYS(KEY,TAG) \
    { MODKEY,                       KEY,      view,           {.ui = 1 << TAG} }, \
    { MODKEY|ControlMask,           KEY,      toggleview,     {.ui = 1 << TAG} }, \
    { MODKEY|ShiftMask,             KEY,      tag,            {.ui = 1 << TAG} }, \
    { MODKEY|ALTKEY,                KEY,      tag,            {.ui = 1 << TAG} }, \
    { MODKEY|ControlMask|ShiftMask, KEY,      toggletag,      {.ui = 1 << TAG} },

#define TERMINAL "termite"
#define BROWSER  "firefox"

/* commands */
static const char *dmenucmd[]  = { "dmenu_run", "-fn", font, "-nb", color[0][ColBG], "-nf", color[0][ColFG], "-sb", color[1][ColBG], "-sf", color[1][ColFG], NULL };
static const char *termcmd[]   = { TERMINAL, NULL };
static const char *surfcmd[]   = { BROWSER, NULL };
static const char *rangercmd[] = { TERMINAL, "-e", "ranger", NULL};
static const char *weecmd[]    = { TERMINAL, "-e", "weechat", NULL};
static const char *mute[]      = { "amixer", "-q", "set", "Master", "toggle", NULL };
static const char *volu[]      = { "amixer", "-q", "set", "Master", "5%+", "unmute", NULL };
static const char *vold[]      = { "amixer", "-q", "set", "Master", "5%-", "unmute", NULL };

static Key keys[] = {
    /* modifier                     key        function        argument */
    { MODKEY,                       XK_p,      spawn,          {.v = dmenucmd } },
    { MODKEY,                       XK_n,      togglebar,      {-1} },
    { MODKEY,                       XK_j,      focusstack,     {.i = +1 } },
    { MODKEY,                       XK_k,      focusstack,     {.i = -1 } },
    { MODKEY|ShiftMask,             XK_j,      movestack,      {.i = +1 } },
    { MODKEY|ShiftMask,             XK_k,      movestack,      {.i = -1 } },
    { MODKEY|ALTKEY,                XK_j,      movestack,      {.i = +1 } },
    { MODKEY|ALTKEY,                XK_k,      movestack,      {.i = -1 } },
    { MODKEY,                       XK_i,      incnmaster,     {.i = +1 } },
    { MODKEY,                       XK_d,      incnmaster,     {.i = -1 } },
    { MODKEY,                       XK_h,      setmfact,       {.f = -0.05} },
    { MODKEY,                       XK_l,      setmfact,       {.f = +0.05} },
    { MODKEY,                       XK_Return, zoom,           {0} },
    { MODKEY,                       XK_Tab,    focusstack,     {.i = +1} },
    { MODKEY|ShiftMask,             XK_c,      killclient,     {0} },
    { MODKEY,                       XK_c,      killclient,     {0} },
    { MODKEY,                       XK_t,      setlayout,      {.i = 0} },
    { MODKEY,                       XK_b,      setlayout,      {.i = 1} },
    { MODKEY,                       XK_g,      setlayout,      {.i = 2} },
    { MODKEY,                       XK_m,      setlayout,      {.i = 3} },
    { MODKEY,                       XK_f,      setlayout,      {.i = 4} },
    { MODKEY,                       XK_space,  setlayout,      {.i = -1} },
    { MODKEY|ShiftMask,             XK_space,  togglefloating, {0} },
    { MODKEY,                       XK_0,      view,           {.ui = ~0 } },
    { MODKEY|ShiftMask,             XK_0,      tag,            {.ui = ~0 } },
    { MODKEY,                       XK_comma,  focusmon,       {.i = -1 } },
    { MODKEY,                       XK_period, focusmon,       {.i = +1 } },
    { MODKEY|ShiftMask,             XK_comma,  tagmon,         {.i = -1 } },
    { MODKEY|ShiftMask,             XK_period, tagmon,         {.i = +1 } },
    { MODKEY,                       XK_q,      spawn,          {.v = surfcmd } },
    { MODKEY,                       XK_w,      spawn,          {.v = termcmd } },
    { MODKEY,                       XK_e,      spawn,          {.v = rangercmd } },
    { MODKEY,                       XK_r,      spawn,          {.v = weecmd } },
    { MODKEY,                       XK_F10,    spawn,          {.v = mute } },
    { MODKEY,                       XK_F11,    spawn,          {.v = vold } },
    { MODKEY,                       XK_F12,    spawn,          {.v = volu } },
    TAGKEYS(                        XK_1,                      0)
    TAGKEYS(                        XK_2,                      1)
    TAGKEYS(                        XK_3,                      2)
    TAGKEYS(                        XK_4,                      3)
    TAGKEYS(                        XK_5,                      4)
    { MODKEY|ShiftMask,             XK_q,      quit,           {0} },
};

/* button definitions */
/* click can be ClkLtSymbol, ClkStatusText, ClkWinTitle, ClkClientWin, or ClkRootWin */
static Button buttons[] = {
    /* click                event mask      button          function        argument */
    { ClkClientWin,         MODKEY,         Button1,        movemouse,      {0} },
    { ClkClientWin,         MODKEY,         Button2,        togglefloating, {0} },
    { ClkClientWin,         MODKEY,         Button3,        resizemouse,    {0} },
};
