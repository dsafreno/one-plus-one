class Person
  constructor: ({@id, @name, @email}) ->
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
    @peopleEdit = ko.observable(true)
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

  createPerson: =>
    people = @people
    $.post("/people", { person: {name: @newName, email: @newEmail} }).success((datum) ->
      people.push(new Person(datum))
    )
    @newName('')
    @newEmail('')

  deletePerson: (person) =>
    reloadData = @reloadData
    people = @people
    $.ajax({
      type: "DELETE"
      url: "/people/#{person.id}"
    }).success(->
      reloadData()
    )

$ ->
  app = new AppViewModel()
  ko.applyBindings(app)

