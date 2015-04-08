streams = { }

$(document).on 'page:load/games:show', ->
    gameId = $('.game-page-show').data('gameId').toString()
    if streams[gameId]
        $('.stream').css('display', 'block')
    else
        streams[gameId] = false

    $('.stream-icon').click (e) ->
        $('.stream').slideToggle()
        streams[gameId] = !streams[gameId]
        e.preventDefault()

$(document).on 'page:load/games:edit', ->
    $('.chosen-select').chosen()
