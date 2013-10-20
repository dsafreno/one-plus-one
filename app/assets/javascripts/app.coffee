class Person
  constructor: ({@name, @email}) ->
    # Noop

class Team
  constructor: ({@id, @name}) ->
    @people = ko.observableArray()
    people = @people
    $.get("/teams/#{@id}/people").done((data) ->
      _.each(data, (datum) ->
        people.push(new Person(datum))
      )
    )

class TeamsViewModel
  constructor: ->
    @teams = ko.observableArray()
    teams = @teams
    $.get('/teams').done((data) ->
      _.each(data, (datum) ->
        teams.push(new Team(datum))
      )
    )

$ ->
  teams = new TeamsViewModel()
  ko.applyBindings(teams)

