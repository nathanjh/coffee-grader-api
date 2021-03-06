[![Build Status](https://travis-ci.org/nathanjh/coffee-grader-api.svg?branch=development)](https://travis-ci.org/nathanjh/coffee-grader-api)
[![codecov](https://codecov.io/gh/nathanjh/coffee-grader-api/branch/development/graph/badge.svg)](https://codecov.io/gh/nathanjh/coffee-grader-api)
# coffee-grader-api
back-end api for 'coffee-grader' coffee cupping app

:coffee: :coffee: :coffee: :coffee: :coffee: :coffee: :coffee: :coffee: :coffee: :coffee: :coffee: :coffee: :coffee: :coffee: :coffee: :coffee: :coffee: :coffee:

###### Built on RAILS 5
    bundle install
    rails db:migrate
    rails db:seed
    rails server
###### Run Tests
    bundle exec rspec


## Documentation

coffees have the following properties:

Field | Description
------|------------
**name** | Name of coffee as string
**origin** | Origin of coffee as string
**procucer** | Coffee producer as string
**variety** | Type of coffee as string


cupped_coffees have the following properties:

Field | Description
------|------------
**roast_date** | Date of coffee roast as datetime
**coffee_alias** | Alternate identifier for coffee as string
**coffee_id** | Integer reference to associated coffee
**roaster_id** | Integer reference to associated roaster
**cupping_id** | Integer reference to associated cupping event


cuppings have the following properties:

Field | Description
------|------------
**location** | Location of cupping event as string
**cup_date** | Date of cupping event as datetime
**host_id** | Integer reference to associated user hosting the event
**cups_per_sample** | Integer number of cups per coffee being cupped


invites have the following properties:

Field | Description
------|------------
**cupping_id** | Integer reference to associated cupping event
**grader_id** | Integer reference to user being invited
**status** | Integer indication of whether invitee has accepted invite


roasters have the following properties:

Field | Description
------|------------
**name** | Name of the roaster as string
**location** | Roaster's location as string
**website** | Website of roaster as string


scores have the following properties:

Field | Description
------|------------
**cupped_coffee_id** | Integer reference to associated cupped coffee
**cupping_id** | Integer reference to associated cupping event
**roast_level** | Integer indicating roast level, determined by grader
**aroma** | Decimal indicating aroma, determined by grader
**aftertaste** | Decimal indicating aftertaste, determined by grader
**acidity** | Decimal indicating acidity, deterimed by grader
**body** | Decimal indicating body, determined by grader
**uniformity** | Decimal indicating uniformity, determined by grader
**balance** | Decimal indicating balance, deterimed by grader
**clean_cup** | Decimal indicating level of cup cleanliness, determined by grader
**sweetness** | Decimal indicating sweetness, determined by grader
**overall** | Decimal indicating overall impression, deterimed by grader
**defects** | Integer indicating number of defects, determined by grader
**total_score** | Decimal indicating sum of all scores
**notes** | Text notes regarding cupped coffee, entered by grader
**grader_id** | Integer reference to associated grader
**final_score** | Decimal indicating final score attributed to cupped coffee
**flavor** | Decimal indicating flavor, determined by grader


users have the following properties:

Field | Description
------|------------
**name** | Name of user as string
**username** | User determined alias as string
**email** | Email address of user as string


### Coffees Endpoints
    GET /coffees
    GET /coffees/:id
    POST /coffees
    PATCH /coffees/:id
    DELETE /coffees/:id

#### Sample Response from GET /coffees
```JSON
[
{
  "name":"Evening Delight",
  "origin":"Kayanza, Burundi",
  "producer":"Nigel Schaefer",
  "variety":"Mundo Novo"
},
{
  "name":"Hello America",
  "origin":"Rivas, Nicaragua",
  "producer":"Vidal Lemke",
  "variety":"Dilla"
},
...
]
```

### Cupped Coffees Endpoints
    GET /cuppings/:cupping_id/cupped_coffees
    GET /cuppings/:cupping_id/cupped_coffees/:id
    POST /cuppings/:cupping_id/cupped_coffees
    PATCH /cuppings/:cupping_id/cupped_coffees/:id
    DELETE /cuppings/:cupping_id/cupped_coffees/:id

#### Sample Response from GET /cuppings/:cupping_id/cupped_coffees
```JSON
[
{
  "roast_date":"2017-03-30 01:30:31",
  "coffee_alias":"n15on",
  "coffee_id":"1269",
  "roaster_id":"1077",
  "cupping_id":"1450"
},
{
  "roast_date":"2017-03-31 01:30:31",
  "coffee_alias":"a26i8",
  "coffee_id":"1270",
  "roaster_id":"1078",
  "cupping_id":"1450"
},
...
]
```

### Cuppings Endpoints
    GET /cuppings
    GET /cuppings/:id
    POST /cuppings
    PATCH /cuppings/:id
    DELETE /cuppings/:id

#### Sample Response from GET /cuppings
```JSON
[
{
  "location":"58490 Patience Point",
  "cup_date":"2017-02-27 10:56:43",
  "host_id":"3543",
  "cups_per_sample":"4"
},
{
  "location":"602 Matilda Village",
  "cup_date":"2017-02-27 10:56:43",
  "host_id":"3544",
  "cups_per_sample":"4"
},
...
]
```

### Invites Endpoints
    GET /cuppings/:cupping_id/invites
    GET /cuppings/:cupping_id/invites/:id
    POST /cuppings/:cupping_id/invites
    PATCH /cuppings/:cupping_id/invites/:id
    DELETE /cuppings/:cupping_id/invites/:id

#### Sample Response from GET /cuppings/:cupping_id/invites
```JSON
[
{
  "cupping_id":"2246",
  "grader_id":"4323",
  "status":"pending"
},
{
  "cupping_id":"2246",
  "grader_id":"4324",
  "status":"pending"
},
...
]
```
#### On Invite Creation
When sending `POST` requests to `cuppings/:id/invites`, the typical request params
need only include an `invite` object with a valid `grader_id`.  A notification email
will be sent to the corresponding user.
- Want to invite a friend without an account?  No problem!  Just send along any valid email address eg.
`
{
  "invite": {
    "grader_email": "your@coffee.friend"
  }
}
`
and we'll send an email to the provided address containing a custom link to sign-up,
which passes along (as a query string) a unique invite token which needs to be
`POST`ed, along with required account registration params, to `/auth`.  We take it
from there, and update your invite with the new user.

### Roasters Endpoints
    GET /roasters
    GET /roasters/:id
    POST /roasters
    PATCH /roasters/:id
    DELETE /roasters/:id

#### Sample Response from GET /roasters
```JSON
[
{
  "name":"Godard Cafe",
  "location":"Spinkastad",
  "website":"http://fisher.biz/greyson_cole"
},
{
  "name":"Slow-carb Cafe",
  "location":"Lake Mary",
  "website":"http://johns.name/cecilia_leffler"
},
...
]
```

### Scores Endpoints
    GET /scores
    GET /scores/:id
    POST /scores
    POST /scores/submit_scores
    PATCH /scores/:id
    DELETE /scores/:id

#### Sample Response from GET /scores
```JSON
[
{
  "cupped_coffee_id":"1039",
  "cupping_id":"2925",
  "roast_level":"4",
  "aroma":"9.25",
  "aftertaste":"7.5",
  "acidity":"8.75",
  "body":"7",
  "uniformity":"8.5",
  "balance":"8.25",
  "clean_cup":"7.75",
  "sweetness":"7",
  "overall":"9.25",
  "defects":"4",
  "total_score":"67",
  "notes":"bright, full, clementine, molasses, cream",
  "grader_id":"5748",
  "final_score":"65",
  "flavor":"8.5"
},
...
]
```

#### Batch create for scores
`POST` `/scores/submit_scores` allows for the addition of multiple scores with a single call.
```JSON
Example POST data (JSON):
{
  "scores": [
    {
      "roast_level": "3",
      "aroma": "8.5",
      "aftertaste": "9.25",
      "acidity": "9.0",
      "body": "8.75",
      ...
      "cupped_coffee_id": "123"
    },
    {
      "roast_level": "4",
      "aroma": "7.25",
      "aftertaste": "8.25",
      "acidity": "7.5",
      "body": "8.0",
      ...
      "cupped_coffee_id": "456"
    }
  ]
}

```
Please note that **any errors in a single score will prevent the entire batch of scores from processing**.
The server returns a 204 No Content response on success, and a 400 Bad Request response--along with an error message--on failure.

### Users Endpoints
    GET /users/:id
    GET /users/search

#### Users search
Queries for users by both `email` and `username`. Please send search term with
key `term`, eg. `{ "term": "your_search" }`.  Also supports optional pagination
parameters: `limit`, the number of records per page, and `page`, which calculates
offset for records returned (relative to `limit`).
