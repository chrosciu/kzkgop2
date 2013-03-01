class Stop

  constructor: ->
    @observeAllDirectionsLink()

  observeAllDirectionsLink: ->
    $(document).on 'click', 'a#all_directions', @checkAllDirections

  checkAllDirections: (e) ->
    e.preventDefault()
    e.stopPropagation()
    $("input#direction_ids_").attr('checked', true)

$ -> new Stop
