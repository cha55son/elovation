streams = { }

$(document).on 'page:load/games:show', ->
    gameId = $('.game-page-show').data('gameId').toString()
    if streams[gameId]
        $('.stream').css 'display', 'block'
    else
        streams[gameId] = false

    $('.stream-icon').click (e) ->
        $('.stream').slideToggle()
        streams[gameId] = !streams[gameId]
        e.preventDefault()

$(document).on 'page:load/games:edit', ->
    $('.chosen-select').chosen()
    $('a[data-toggle="tab"]').on 'shown.bs.tab', (e) ->
        return if $(e.target).attr('href') != '#preview'
        $textarea = $('#game_description')
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
                $('#game_description_preview').html(data)

# Handle webhooks on the edit page
$(document).on 'page:update/games:update page:load/games:edit page:load/games:new', ->
    counter = 100
    $('.add-webhook').click (e) ->
        $parent = $(this).parents '.webhook-input-group'
        $input = $('input.form-control', $parent)
        # Verify the url is valid
        if $input.val() == ''
            alert 'Please enter a valid url.'
            return
        $clone = $parent.clone()
        $('input.form-control', $clone).attr 'name', "game[webhooks_attributes][#{counter++}][url]"
        $clone.removeClass 'add-webhook-input-group'
              .addClass 'remove-webhook-input-group'
              .css 'display', 'none'
              .insertAfter $parent
              .fadeIn()
        $('.webhook-btn', $clone).removeClass 'btn-success add-webhook' 
                                 .addClass 'btn-danger remove-webhook'
        $input.val ''
    $('.add-webhook-input-group').keypress (e) ->
        return if e.which != 13
        e.preventDefault()
        $('.add-webhook', $(this)).click()

    $(document).on 'click', '.remove-webhook', (e) ->
        $parent = $(this).parents '.webhook-input-group'
        $parent.fadeOut()
        if $parent.data('id') == undefined
            $parent.remove() 
        else
            $parent.append '<input type="hidden" value="1" name="game[webhooks_attributes][' + $parent.data('index') + '][_destroy]">'
    $('.remove-webhook-input-group').keypress (e) ->
        e.preventDefault() if e.which == 13
