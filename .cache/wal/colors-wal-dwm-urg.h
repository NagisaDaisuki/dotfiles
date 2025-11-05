static const char norm_fg[] = "#c9c6c3";
static const char norm_bg[] = "#291b11";
static const char norm_border[] = "#766960";

static const char sel_fg[] = "#c9c6c3";
static const char sel_bg[] = "#8D5F30";
static const char sel_border[] = "#c9c6c3";

static const char urg_fg[] = "#c9c6c3";
static const char urg_bg[] = "#CE3B21";
static const char urg_border[] = "#CE3B21";

static const char *colors[][3]      = {
    /*               fg           bg         border                         */
    [SchemeNorm] = { norm_fg,     norm_bg,   norm_border }, // unfocused wins
    [SchemeSel]  = { sel_fg,      sel_bg,    sel_border },  // the focused win
    [SchemeUrg] =  { urg_fg,      urg_bg,    urg_border },
};
