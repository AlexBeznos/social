$(document).ready(function(){
    $(".carousel").slick({
        autoplay: true,
        dots: true,
        dotsClass: 'dots',
        arrows: false
    });
    $('.carousel').on('beforeChange', function(event, slick, currentSlide, nextSlide) {
        $('#how .col-sm-7 img').css('display', 'none');
        $($('#how .col-sm-7 img')[nextSlide]).fadeIn();
    });
    $(".scrollTo").click(function(event){
        //prevent the default action for the click event
        event.preventDefault();

        //get the full url - like mysitecom/index.htm#home
        var full_url = this.href;

        //split the url by # and get the anchor target name - home in mysitecom/index.htm#home
        var parts = full_url.split("#");
        var trgt = parts[1];

        //get the top offset of the target anchor
        var target_offset = $("#"+trgt).offset();
        var target_top = target_offset.top;

        //goto that anchor by setting the body scroll top to anchor top
        $('html, body').animate({scrollTop:target_top-80}, 1500, 'easeInSine');
    });
    var modalSuccess = new jBox('Modal', {
        content: 'Ваша заявка была успешно отправлена!'
    });
    $('#signup').submit(function(){
        var name = $('#signup input[name=name]').val();
        var tel = $('#signup input[name=tel]').val();
        var email = $('#signup input[name=email]').val();
        if (name == '' || tel == '' || email == '')
            return false;
        else {
            $.post("/feedback", {name: name, tel: tel, email: email});
            modalSuccess.open();
        }
        return false;
    });
});
