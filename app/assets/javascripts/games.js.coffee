initShow = ->
    $('.stream-icon').click (e) ->
        $('.stream').slideToggle()
        e.preventDefault()

initEdit = ->
    $('.chosen-select').chosen()

$(document).on 'page:ready/games:show page:load/games:show', initShow
$(document).on 'page:ready/games:edit page:load/games:edit', initEdit
