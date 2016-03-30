$('#scratchpad').wScratchPad({
  size        : 5,          // The size of the brush/scratch.
  bg          : '#cacaca',  // Background (image path or hex color).
  fg          : '#6699ff',  // Foreground (image path or hex color).
  realtime    : true,       // Calculates percentage in realitime.
  scratchDown : null,       // Set scratchDown callback.
  scratchUp   : null,       // Set scratchUp callback.
  scratchMove : null,       // Set scratcMove callback.
  cursor      : 'crosshair' // Set cursor.
});
