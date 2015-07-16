$.ajax({
    url: "https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/js/bootstrap.min.js",
    dataType: "script"
});

var form = '<form id="edit-message" action="/auth/edit_message">' +
                '<div class="form-group">' +
                    '<label class="control-label" for="message_message">Текст сообщения</label><br>' +
                    '<textarea class="form-control" id="message_message" name="message[message]" type="text" value=""></textarea>' +
                    '<span class="help-block"></span>' +
                '</div>' +
                '<div class="form-group">' +
                    '<label class="control-label" for="message_message_link">Ссылка</label><br>' +
                    '<input class="form-control" id="message_message_link" name="message[message_link]" type="text" value="">' +
                    '<span class="help-block"></span>' +
                '</div>' +
                '<div class="form-group">' +
                    '<label class="control-label" for="message_image_file_name">Ссылка на изображение</label><br>' +
                    '<input class="form-control" id="message_image_file_name" name="message[image_file_name]" type="text" value="">' +
                    '<span class="help-block"></span>' +
                '</div>' +
                '<div class="actions">' +
                    '<input class="btn btn-primary" name="commit" type="submit" value="Submit">' +
                '</div>' +
            '</form>';

$('<div class="modal fade" id="edit_message_modal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">' +
        '<div class="modal-dialog">' +
            '<div class="modal-content">' +
                '<div class="modal-header">' +
                    '<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>' +
                    '<h4 class="modal-title text-primary" id="myModalLabel">Введите сообщение, и оно появится на Вашей стене!</h4>' +
                '</div>' +
                '<div class="modal-body">' +
                    form +
                '</div>' +
                '<div class="modal-footer">' +
                    '<button type="button" class="btn btn-primary" data-dismiss="modal">Close</button>' +
                '</div>' +
            '</div>' +
        '</div>' +
    '</div>').appendTo('body');

$('img[alt=Facebook]').on('click', function(e) {
    $('#edit_message_modal').modal('show');
    e.preventDefault();
});

$("#edit-message").submit(function(e) {

    var actionurl = e.currentTarget.action;

    $.ajax({
        url: actionurl,
        type: 'post',
        dataType: 'html',
        data: $("#edit-message").serialize(),
        complete: function(){
            $('#edit_message_modal').modal('hide');
            $(location).attr('href', '/auth/facebook');
        }
    });

    e.preventDefault();
});