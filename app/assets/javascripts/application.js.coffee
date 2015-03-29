# This is a manifest file that'll be compiled into application.js, which will include all the files
# listed below.
#
# Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
# or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
#
# It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
# compiled file.
#
# Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
# about supported directives.
#
#= require jquery
#= require jquery_ujs
#= require turbolinks
#= require lumen/loader
#= require lumen/bootswatch
#= require chosen.min
#= require_tree .

Turbolinks.enableTransitionCache()
Turbolinks.enableProgressBar()

# CoffeeScript routing based on the data-controller & data-action attributes on the body.
# Use the following to trigger JS for a specific page:
#
# $(document).on 'turbolinks:event controller:action', ->
#     console.log 'I made it to controller:action!'
#
ready = (event) ->
    $body = $('body')
    $(document).trigger event + '/' + $body.data('controller') + ':' + $body.data('action')

# May only be called once while a client views different pages
$(document).on('ready', ready.bind(this, 'page:ready'))
# Will be called when different pages are loaded.
$(document).on('page:load', ready.bind(this, 'page:load'))
# Will be called when a page is restored from the client cache.
$(document).on('page:restore', ready.bind(this, 'page:restore'))
