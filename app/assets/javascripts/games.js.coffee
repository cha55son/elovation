init = ->
    $('.stream-icon').click (e) ->
        $('.stream').slideToggle()
        e.preventDefault()

$(document).on 'page:ready/games:show', init
$(document).on 'page:load/games:show', init

