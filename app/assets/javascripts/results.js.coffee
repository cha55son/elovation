chosenInit = ->
    $(".players").chosen()

# Needed for loading the page directly
$(document).on 'page:ready/results:new', chosenInit
# Needed for an error on submission
$(document).on 'page:ready/results:create', chosenInit
$(document).on 'page:load/results:new', chosenInit
