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

$(document).on 'page:load/games:edit page:load/games:new', ->
    counter = 0
    $('.add-webhook').click (e) ->
        $parent = $(this).parents '.webhook-input-group'
        $input = $('input.form-control', $parent)
        # Verify the url is valid
        if $input.val() == ''
            alert 'Please enter a valid url.'
            return
        $clone = $parent.clone()
        $('input.form-control', $clone).attr 'name', "game[webhooks_attributes][#{counter--}][url]"
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
        $parent.remove() if $parent.data('id') == undefined
        $parent.append '<input type="hidden" value="1" name="game[webhooks_attributes][' + $parent.data('id') + '][_destroy]">'
    $('.remove-webhook-input-group').keypress (e) ->
        e.preventDefault()
