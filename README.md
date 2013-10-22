# 1+1
-------------------------

## Instructions
-------------------------
Note that you can easily test the app by visiting http://oneplusoneifttt.herokuapp.com/

### Local Setup

Ensure you have the correct versions of rails (rails 4.0.0) and ruby (2.0.0). Clone the repo, bundle, and run **rails s** (note that this will not send emails).

### Production Setup

Deploy 1+1 to a Heroku cedar stack. Add the Scheduler (https://devcenter.heroku.com/articles/scheduler) and the SendGrid (https://devcenter.heroku.com/articles/sendgrid) plugins. From the Heroku Dashboard, navigate to the dashboard for Scheduler and add the following for every day at 5:00 pm:

    test `date +%w` -eq 5 && rake make_pairings`

This will ensure that the **make_pairings** rake task is run when the day of the week is Friday at 5:00 pm. 

### How to use

I hope this is intuitive. Hit the edit buttons to edit people/teams, use the + and x buttons to respectively create and delete people/teams, and use the dropdown with + button to add people to teams.

## Design Decisions
-------------------------

### Technologies

For my backend, I chose Rails because I have no Node.js experience. For my frontend, I chose Knockout JS because I've heard a lot about the MVVM style of development and wanted to learn about it for myself (previously, I had done all JavaScript MV* development in Backbone JS). I use Bootstrap 3 for its minimalistic aesthetic and responsiveness on mobile. I use rspec to test because of my positive experience with it.

### UX

I designed the UX to mock IFTTT's color scheme because it is designed to be the 1+1 app for IFTTT. You can switch between view-only and edit states so that the cluttered edit UI is hidden when simply inspecting the views. It is very mobile friendly - try collapsing your browser a bit.

### Algorithms

I chose to use an algorithm that attempts to ensure that as few people have poor week-over-week matchups as possible. I calculate each person's "happiness" based on a weighted average of the "happiness" of each of their previous matchups. Then, I choose the optimal matchup for the each person from least happy to most happy. Note that this does not guarantee that everyone has a matchup (this is impossible), nor that everyone is matched with each other person with equal frequency, nor that they will not be paired with the same person week over week. It does not even guarantee that happiness is maximized.

Had I more time to understand and implement a better algorithm, I would have instead reduced it to a weighted undirected graph problem in which the nodes are people, edges are to people on the same team, and weights are determined as "happiness" of the matchup as above. Then, I would've maximized happiness by solving it as a Maximum Weighted Matching problem (see http://jorisvr.nl/maximummatching.html) using the Blossom V algorithm (see http://pub.ist.ac.at/~vnk/papers/blossom5.pdf), which would have guaranteed maximum happiness.

### Testing

I tested the backend using rspec. I especially tested database validations and the algorithm for pairing people; here, testing substantally sped up development.
I ended up not testing the frontend because of the application's size. As per my TODO below, I would eventually learn the idiomatic way to test knockout js apps and then write the appropriate tests for the front end.

## TODOs
-------------------------

- Create an Error UI. Bad inputs currently fail without notifying the user as to what happened.
- Loading notification for UI while waiting for server response.
- Fix CSS issues: teams table slightly thinner then people table, + x buttons are slightly off center.
- Learn idoms for testing Knockout JS and implement them.
- Blossom V algorithm for maximizing happiness.