# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


$(document).on 'input mousemove change', '[data-range-value-changer]', ->
  _id = this.id
  document.querySelector("span[data-range-value-of=\"#{_id}\"]").innerHTML = this.value
