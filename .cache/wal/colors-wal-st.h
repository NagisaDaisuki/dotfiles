const char *colorname[] = {

  /* 8 normal colors */
  [0] = "#291b11", /* black   */
  [1] = "#CE3B21", /* red     */
  [2] = "#8D5F30", /* green   */
  [3] = "#8B6F4C", /* yellow  */
  [4] = "#768F33", /* blue    */
  [5] = "#B3A657", /* magenta */
  [6] = "#EAD59E", /* cyan    */
  [7] = "#c9c6c3", /* white   */

  /* 8 bright colors */
  [8]  = "#766960",  /* black   */
  [9]  = "#CE3B21",  /* red     */
  [10] = "#8D5F30", /* green   */
  [11] = "#8B6F4C", /* yellow  */
  [12] = "#768F33", /* blue    */
  [13] = "#B3A657", /* magenta */
  [14] = "#EAD59E", /* cyan    */
  [15] = "#c9c6c3", /* white   */

  /* special colors */
  [256] = "#291b11", /* background */
  [257] = "#c9c6c3", /* foreground */
  [258] = "#c9c6c3",     /* cursor */
};

/* Default colors (colorname index)
 * foreground, background, cursor */
 unsigned int defaultbg = 0;
 unsigned int defaultfg = 257;
 unsigned int defaultcs = 258;
 unsigned int defaultrcs= 258;
