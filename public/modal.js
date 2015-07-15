$.ajax({
    url: "https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/js/bootstrap.min.js",
    dataType: "script"
});

$.ajax({
    method: "GET",
    url: "/wifi/supercafe/login.json"
})
    .done(function(data) {
        var form = '<form id="edit-message" action="/auth/edit_message">' +
            '<div class="form-group">' +
            '<label class="control-label" for="message_message">Message</label><br>' +
            '<input class="form-control" id="message_message" name="message[message]" type="text" value="' + data.message + '">' +
            '<span class="help-block"></span>' +
            '</div>' +
            '<div class="form-group">' +
            '<label class="control-label" for="message_message_link">Message link</label><br>' +
            '<input class="form-control" id="message_message_link" name="message[message_link]" type="text" value="' + data.message_link + '">' +
            '<span class="help-block"></span>' +
            '</div>' +
            '<div class="actions">' +
            '<input class="btn btn-default" name="commit" type="submit" value="Submit">' +
            '</div>' +
            '</form>';

        $('<div class="modal fade" id="edit_message_modal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">' +
            '<div class="modal-dialog">' +
            '<div class="modal-content">' +
            '<div class="modal-header">' +
            '<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>' +
            '<h4 class="modal-title" id="myModalLabel">Edit message</h4>' +
            '</div>' +
            '<div class="modal-body">' +
            form +
            '</div>' +
            '<div class="modal-footer">' +
            '<button type="button" class="btn btn-default" data-dismiss="modal">Close</button>' +
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

    });