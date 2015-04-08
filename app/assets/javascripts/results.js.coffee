chosenInit = ->
    $(".players").chosen()

$(document).on 'page:load/results:create', chosenInit
$(document).on 'page:load/results:new', chosenInit
