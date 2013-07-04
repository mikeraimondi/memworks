class Memworks.Views.ChallengesShow extends Backbone.View

  template: HandlebarsTemplates['challenges/show']

  events:
    'submit #text-response-form': 'submitAnswer'
    'click #position-submit':     'submitAnswer'
    'click #next':                'advanceCard'
    'click .click-response':      'snippetClick'

  initialize: ->
    @collection.on('sync', @render)
    @collection.on('sync', @resetCurrentCard)
    @collection.on('showNewCard', @cardChanged)
    @logs = new Memworks.Collections.CardSubmissionLogs()
    @logs.on('add', @displayFeedback)
    setInterval(@incrementElapsedTime, 1000)
    @cardChanged()

  render: =>
    $(@el).html(@template(card: @card.toJSON(), score: @model.get('score')))
    @elapsedTime = 0
    this

  snippetClick: (event) ->
    @card.set({'responded': true})
    index = $(event.currentTarget).attr("id").substring(8)
    @card.clickPosition(index)

  incrementElapsedTime: =>
    @elapsedTime++

  displayFeedback: (cardSubmissionLog) =>
    @card.set({'submitted': true})
    if cardSubmissionLog.get('correct')
      @card.set({'correct_answer': true})
    else
      @card.set({'correct_answer': false})

  getAnswer: =>
    if @card.get('kind') == "type"
      $("#string-response").val()
    else
      @card.selectedPositions()

  submitAnswer: (event) ->
    event.preventDefault()
    attributes =
      answer: @getAnswer()
      card_submission_log:
        time_taken: @elapsedTime
    @logs.cardID = @card.id
    @logs.create attributes,
      wait: true
      error: -> @handleError

  handleError: (log, response) ->
    if response.status == 422
      errors = $.parseJSON(response.responseText).errors
      for attribute, messages of errors
        $(@el).append("#{attribute} #{message}") for message in messages
    else
      $(@el).html("An error has occurred")

  advanceCard: (event) ->
    event.preventDefault()
    @collection.nextCard()

  cardChanged: =>
    @card = @collection.at(@collection.currentCard)
    @card.on('change:correct_answer', @render)
    @card.on('change:submitted', @render)
    @card.on('change:responded', @render)
    @card.on('change:tokenized_snippet', @render)
    @render()

  resetCurrentCard: =>
    if @collection?
      @collection.resetCardIndex