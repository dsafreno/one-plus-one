class Person
  constructor: ({@name, @email}) ->
    self = @
    @listing = ko.computed(->
      return "#{self.name} (#{self.email})"
    )


class Team
  constructor: ({@id, @name}) ->
    @people = ko.observableArray()
    people = @people
    $.get("/teams/#{@id}/people").done((data) ->
      _.each(data, (datum) ->
        people.push(new Person(datum))
      )
    )

class AppViewModel
  constructor: ->
    @people = ko.observableArray()
    people = @people
    $.get('/people').done((data) ->
      _.each(data, (datum) ->
        people.push(new Person(datum))
      )
    )
    @teams = ko.observableArray()
    teams = @teams
    $.get('/teams').done((data) ->
      _.each(data, (datum) ->
        teams.push(new Team(datum))
      )
    )

$ ->
  app = new AppViewModel()
  ko.applyBindings(app)

