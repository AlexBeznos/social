$(document).ready(function (){
  var element = document.getElementById('scrcard');

  var painter = new Scratchcard.Painter({ color:'#afc928' });



  painter.reset = function reset(ctx, width, height) {
    ctx.fillStyle = this.options.color;
		ctx.globalCompositeOperation = 'source-over';

		ctx.fillRect(0, 0, width, height);
    ctx.textAlign = 'center';
		ctx.font = '16px Comic Sans';
		ctx.fillStyle = '#000000';
		ctx.fillText('Подотрите, чтобі віиграть', width/2, height/2);

	};


  var scratchcard = new Scratchcard(element, painter);

});
