# Activity Log Service

An API application that captures activites logs from a csv file and adds
ability to view the exact state of an object on a given timestamp

Application is hosted on heroku and accessible at https://dry-bayou-14717.herokuapp.com

## API Doc

```
GET /api/activity_logs                  List all available logs sorted by timestamp
GET /api/activity_logs/state            Fetch the state of an object on a given time
  PARAMS: object_id, object_state, timestamp(optional)
POST /api/activity_logs/upload          Imports a csv file passed as multipart/form-data in body
```

Initial data set is seeded already, via `rake db:seed`
