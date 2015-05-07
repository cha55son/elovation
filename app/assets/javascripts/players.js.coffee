$(document).on 'page:load/players:edit', ->
    $('a[data-toggle="tab"]').on 'shown.bs.tab', (e) ->
        return if $(e.target).attr('href') != '#preview'
        $textarea = $('#player_bio')
        val = $textarea.val()
        return if !val || $textarea.data('text') == val
        $textarea.data('text', val)
        $.ajax 
            url: '/markdown',
            method: 'POST',
            data:
                text: val
            success: (data, status) ->
                return unless status == 'success'
                $('#player_bio_preview').html(data)

$(document).on 'page:load/players:show', ->
    $bio = $('.bio-well')
    $bio_wrapper = $('.markdown-wrapper')
    $bio_more_btn = $('.markdown-show-more')
    return unless $bio_wrapper.height() > 200
    $bio_wrapper.height(200 + $bio_more_btn.outerHeight())
    $bio_more_btn.show()
    $bio_more_btn.click (e) ->
        $bio_wrapper.css('height', 'auto')
        $bio_more_btn.hide()

