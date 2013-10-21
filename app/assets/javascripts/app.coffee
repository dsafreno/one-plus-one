class Person
  constructor: ({@id, @name, @email}) ->
    self = @
    @listing = ko.computed(->
      return "#{self.name} (#{self.email})"
    )

class Team
  constructor: ({@id, @name}) ->
    @people = ko.observableArray()
    @edit = ko.observable(false)
    people = @people
    $.get("/teams/#{@id}/people").done((data) ->
      _.each(data, (datum) ->
        people.push(new Person(datum))
      )
    )

  toggleEdit: =>
    @edit(!@edit())

  add: (person) =>
    people = @people
    $.post("teams/#{@id}/add", { person_id: person.id }).success(->
      people.push(person)
    )

  remove: (person) =>
    people = @people
    $.post("teams/#{@id}/remove", { person_id: person.id }).success(->
      people.remove(person)
    )

class AppViewModel
  constructor: ->
    @newName = ko.observable('')
    @newEmail = ko.observable('')
    @newTeamName = ko.observable('')
    @peopleEdit = ko.observable(false)
    @teamAdd = ko.observable(false)
    @people = ko.observableArray()
    @reloadData()

  reloadData: =>
    people = @people
    $.get('/people').done((data) ->
      people.removeAll()
      _.each(data, (datum) ->
        people.push(new Person(datum))
      )
    )
    @teams = ko.observableArray()
    teams = @teams
    $.get('/teams').success((data) ->
      teams.removeAll()
      _.each(data, (datum) ->
        teams.push(new Team(datum))
      )
    )

  togglePeopleEdit: =>
    @peopleEdit(!@peopleEdit())

  createTeam: =>
    teams = @teams
    $.post("/teams", { team: {name: @newTeamName}}).success((datum) ->
      teams.unshift(new Team(datum))
    )
    @newTeamName('')

  createPerson: =>
    people = @people
    $.post("/people", { person: {name: @newName, email: @newEmail} }).success((datum) ->
      people.unshift(new Person(datum))
    )
    @newName('')
    @newEmail('')

  toggleTeamAdd: =>
    @teamAdd(!@teamAdd())

  deletePerson: (person) =>
    reloadData = @reloadData
    people = @people
    $.ajax({
      type: "DELETE"
      url: "/people/#{person.id}"
    }).success(->
      reloadData()
    )

  deleteTeam: (team) =>
    reloadData = @reloadData
    teams = @teams
    $.ajax({
      type: "DELETE"
      url: "/teams/#{team.id}"
    }).success(->
      reloadData()
    )

$ ->
  app = new AppViewModel()
  ko.applyBindings(app)

