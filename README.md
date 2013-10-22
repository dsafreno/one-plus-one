## 1+1

### Instructions

#### Local Setup

Ensure you have the correct versions of rails (rails 4.0.0) and ruby (2.0.0). Clone the repo, bundle, and run **rails s** (note that this will not send emails).

#### Production Setup

Deploy 1+1 to a Heroku cedar stack. Add the Scheduler (https://devcenter.heroku.com/articles/scheduler) and the SendGrid (https://devcenter.heroku.com/articles/sendgrid) plugins. From the Heroku Dashboard, navigate to the dashboard for Scheduler and add the following for every day at 5:00 pm:

**test `date +%w` -eq 5 && rake make_pairings**

This will ensure that the **make_pairings** rake task is run when the day of the week is Friday at 5:00 pm. 

#### How to use

I hope this is intuitive. Hit the edit buttons to edit people/teams, use the + and x buttons to respectively create and delete people/teams, and use the dropdown with + button to add people to teams.

### Design Decisions

#### Technologies

#### UX

#### Algorithms

### Testing

I tested the backend using RSpec. I especially tested database validations and the algorithm for pairing people.
