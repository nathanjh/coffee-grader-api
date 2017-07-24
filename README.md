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

## Table of Contents

* [Authentication](#authentication)
* [Cuppings](#cuppings)
* [Cupped-Coffees](#cupped-coffees)
* [Invites](#invites)
* [Scores](#scores)
* [Users](#users)
* [Coffees and Roasters](#coffees-and-roasters)

## Authentication
Coffee-Grader-API uses token-based authentication (leveraging the [DeviseTokenAuth](https://github.com/lynndylanhurley/devise_token_auth) gem).  The client should include the following headers in each request ([RFC 6750 Bearer Token](http://tools.ietf.org/html/rfc6750) format).
###### Example Authentication Headers:
    "access-token": "wwwwww",
    "token-type":   "Bearer",
    "client":       "xxxxxx",
    "expiry":       "yyyyyy",
    "uid":          "zzzzzz"
**Note**: Each response will include the required headers for the following request, as the access-token (for example) is reset on each authenticated request.
##### To Sign Up
`POST` to `/auth` with the following parameters:

Field | Description
------|------------
**`name`** | User's full name
**`username`** | User's nickname
**`email`** | A valid email address
**`password`** | A password (at least 8 characters)
**`password_confirmation`** | to confirm the above

##### To Sign In
`POST` to `/auth/sign_in` with a valid `email` and `password`

## Cuppings
The `cupping` resource manages more or less all aspects of the coffee grading process; samples are to be scored, graders are invited, etc.  A cupping must be created before any samples can be scored, so a `POST` request to `/cuppings` is a sensible first step.

###### The Cupping Object
Field | Description
------|------------
**`location`** | Location of cupping event as string (required)
**`cup_date`** | Date of cupping event as datetime; UTC formatted string works great (required)
**`host_id`** | Foreign key of user hosting the cupping (required)
**`cups_per_sample`** | Integer number of cups per sample (required)
**`open`** | Boolean value indicating whether the cupping has occurred; default value is `true` (for more, see [cupping-open](#open))

###### Cupping Endpoints
    GET /cuppings
    GET /cuppings/:id
    POST /cuppings
    PATCH /cuppings/:id
    DELETE /cuppings/:id
**Note**: Only a cupping's host has access to `PATCH /cuppings/:id` and `DELETE /cuppings/:id`
###### Sample Response from GET /cuppings/:id
```JSON
{
    "cupping": {
        "id": 6,
        "location": "2571 Ritchie Plain",
        "cup_date": "2017-07-16T22:52:24.155Z",
        "cups_per_sample": 5,
        "host_id": 2,
        "open": true,
        "cupped_coffees": [
            {
                "id": 1,
                "roast_date": "2017-07-16T22:52:23.155Z",
                "coffee_alias": "6-181",
                "coffee_id": 2,
                "roaster_id": 9,
                "cupping_id": 6
            },
            {
                "id": 2,
                "roast_date": "2017-07-16T22:52:23.155Z",
                "coffee_alias": "6-241",
                "coffee_id": 19,
                "roaster_id": 3,
                "cupping_id": 6
            },
            {
                "id": 3,
                "roast_date": "2017-07-16T22:52:23.155Z",
                "coffee_alias": "6-760",
                "coffee_id": 2,
                "roaster_id": 3,
                "cupping_id": 6
            }
        ],
        "scores": [],
        "invites": [
            {
                "id": 1,
                "status": "pending",
                "cupping_id": 6,
                "grader_id": 7,
                "grader_email": null,
                "invite_token": null
            },
            {
                "id": 2,
                "status": "pending",
                "cupping_id": 6,
                "grader_id": 6,
                "grader_email": null,
                "invite_token": null
            },
            {
                "id": 3,
                "status": "pending",
                "cupping_id": 6,
                "grader_id": 5,
                "grader_email": null,
                "invite_token": null
            }
        ]
    }
}
```
As you can see, a cupping includes `invites`, `scores`, and `cupped_coffees`(AKA 'samples')
###### Open?
* A cupping's status is determined by its `open` property.  When `open: true`, a cupping can receive new scores, cupped_coffees, and invites; conversely, `open: false` indicates that the cupping *occurred in the past* and is therefore closed to new scores, invites, etc.
* **The client should set the `open` property to `false` after all scores have been submitted.**

## Cupped Coffees
The Cupped Coffee object represents a unique roasted coffee sample, bringing together a green `coffee` and `roaster`, to be added to a `cupping`.
###### The CuppedCoffee Object
Field | Description
------|------------
**`roast_date`** | Date of coffee roast as datetime; UTC formatted string works great (required)
**`coffee_alias`** | Alternate identifier for coffee as string
**`coffee_id`** | Foreign key of the associated coffee (required)
**`roaster_id`** | Foreign key of the associated roaster (required)
**`cupping_id`** | Foreign key of the associated roaster (required)

###### Cupped Coffee Endpoints
    GET /cuppings/:cupping_id/cupped_coffees
    GET /cuppings/:cupping_id/cupped_coffees/:id
    POST /cuppings/:cupping_id/cupped_coffees
    PATCH /cuppings/:cupping_id/cupped_coffees/:id
    DELETE /cuppings/:cupping_id/cupped_coffees/:id
**Note**: Only a cupping's host (the user who owns the cupping referred to by `/cuppings/:cupping_id`) has access to the following:
* `POST /cuppings/:cupping_id/cupped_coffees`
* `PATCH /cuppings/:cupping_id/cupped_coffees/:id`
* `DELETE /cuppings/:cupping_id/cupped_coffees/:id`

A cupped_coffee includes its associated `roaster`, `coffee`, and `scores`.
###### Sample Response from GET /cuppings/:cupping_id/cupped_coffees/:id
```JSON
{
  "cupped_coffee": {
    "id": 2,
    "roast_date": "2017-07-16T22:52:23.155Z",
    "coffee_alias": "6-241",
    "coffee_id": 19,
    "roaster_id": 3,
    "cupping_id": 6,
    "coffee": {
      "id": 19,
      "name": "Heart Pie",
      "origin": "Mount Elgon, Uganda",
      "producer": "Marjorie Cormier",
      "variety": "Obata"
    },
    "roaster": {
      "id": 3,
      "name": "Salvia Roastery",
      "location": "Carolview",
      "website": "http://rennerromaguera.biz/leslie_fay"
    },
    "scores": []
  }
}
```

## Invites
The Invite object--like a Cupped Coffee--is dependent on a `cupping`, and may be used to associate `users` (as `graders`) with a specific `cupping` event.  Simply send a `POST` request to `cuppings/:cupping_id/invites` with the invitee's `grader_id`(alias for `user_id`) or email address (as `grader_email`).

###### The Invite Object
Field | Description
------|------------
**`cupping_id`** | Foreign key of the associated cupping event (required)
**`grader_id`** | Foreign key of the user being invited (required in the absence of `grader_email`)
**`grader_email`** | Email address of a prospective grader; to be used when no user account exists for grader, see [below](#on-invite-creation) (required in the absence of `grader_id`)
**`status`** | Indication of whether invitee has accepted invite; possible values include: `'pending'`(default), `'accepted'`, `'declined'`, or `'maybe'`

###### Invites Endpoints
    GET /cuppings/:cupping_id/invites
    GET /cuppings/:cupping_id/invites/:id
    POST /cuppings/:cupping_id/invites
    PATCH /cuppings/:cupping_id/invites/:id
    DELETE /cuppings/:cupping_id/invites/:id

###### On Invite Creation
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

###### Sample Response from GET /cuppings/:cupping_id/invites
```JSON
{
    "invites": [
        {
            "id": 13,
            "status": "pending",
            "cupping_id": 10,
            "grader_id": 6,
            "grader_email": null,
            "invite_token": null,
            "grader": {
                "id": 6,
                "name": "Jeramy Lang",
                "username": "jimmie",
                "email": "luciano@sanford.com"
            }
        },
        {
            "id": 14,
            "status": "pending",
            "cupping_id": 10,
            "grader_id": 4,
            "grader_email": null,
            "invite_token": null,
            "grader": {
                "id": 4,
                "name": "Miss Kim Heaney",
                "username": "murray",
                "email": "adriel.spinka@rempel.io"
            }
        },
        {
            "id": 15,
            "status": "pending",
            "cupping_id": 10,
            "grader_id": 3,
            "grader_email": null,
            "invite_token": null,
            "grader": {
                "id": 3,
                "name": "Earline Lemke",
                "username": "mireille.kunde",
                "email": "guido@jacobs.io"
            }
        }
    ]
}
```

## Scores
The `score` resource refers to a specific evaluation of a `cupped_coffee`/sample by a grader, storing a handful of parameters where characteristics of a coffee are assigned numeric values.  The scoring format and characteristics in question conform to current [SCAA scoring guidelines](http://www.scaa.org/?page=resources&d=cupping-protocols).
- Given that the associated `cupping`'s `open` attribute is `true`, a `score` may be created by `POST`ing to `/scores` with valid attributes.

###### The Score Object

Field | Description
------|------------
**`roast_level`** | Integer indicating roast level, determined by grader
**`aroma`** | Decimal indicating aroma, determined by grader
**`flavor`** | Decimal indicating flavor, determined by grader
**`aftertaste`** | Decimal indicating aftertaste, determined by grader
**`acidity`** | Decimal indicating acidity, determined by grader
**`body`** | Decimal indicating body, determined by grader
**`balance`** | Decimal indicating balance, determined by grader
**`sweetness`** | Decimal indicating sweetness, determined by grader
**`clean_cup`** | Decimal indicating level of cup cleanliness, determined by grader
**`uniformity`** | Decimal indicating uniformity, determined by grader
**`overall`** | Decimal indicating overall impression, determined by grader
**`total_score`** | Decimal indicating sum of all scores
**`defects`** | Integer indicating defect score, determined by grader
**`final_score`** | Decimal indicating final score attributed to cupped coffee
**`notes`** | Text notes regarding cupped coffee, entered by grader
**`cupped_coffee_id`** | Foreign key of associated cupped coffee
**`cupping_id`** | Foreign key of associated cupping event
**`grader_id`** | Foreign key of associated grader

###### Scores Endpoints
    GET /scores
    GET /scores/:id
    POST /scores
    POST /scores/submit_scores
    PATCH /scores/:id
    DELETE /scores/:id

###### Sample Response from GET /scores/:id
```JSON
{
  "score": {
    "id": 20,
    "grader_id": 7,
    "cupping_id": 3,
    "cupped_coffee_id": 23,
    "aroma": "8.25",
    "aftertaste": "6.25",
    "acidity": "8.0",
    "body": "7.0",
    "uniformity": "9.0",
    "flavor": "6.25",
    "balance": "7.5",
    "clean_cup": "6.25",
    "sweetness": "6.5",
    "overall": "9.0",
    "defects": 4,
    "total_score": "74.0",
    "final_score": "70.0",
    "notes": "bright, full, clementine, molasses, cream"
  }
}
```

###### Batch create for scores
`POST` `/scores/submit_scores` allows for the addition of multiple scores with a single call.
```JSON
Example POST data (note that score objects have been truncated in this example to save space)
{
  "scores": [
    {
      "roast_level": "3",
      "aroma": "8.5",
      "aftertaste": "9.25",
      "acidity": "9.0",
      "body": "8.75",
      "cupped_coffee_id": "123"
    },
    {
      "roast_level": "4",
      "aroma": "7.25",
      "aftertaste": "8.25",
      "acidity": "7.5",
      "body": "8.0",
      "cupped_coffee_id": "456"
    }
  ]
}

```
Please note that **any errors in a single score will prevent the entire batch of scores from processing**.
The server returns a 204 No Content response on success, and a 400 Bad Request response--along with an error message--on failure.

## Users
  The `user` resource exposes an endpoint for accessing a specific `user`, as well as a `users/search` route intended for use when implementing autocompletion in the client.

###### Users Endpoints
    GET /users/:id
    GET /users/search

###### Users search
Queries for users by both `email` and `username`. Please send search term with
key `term`, eg. `{ "term": "your_search" }`.  Also supports optional pagination
parameters: `limit`, the number of records per page, and `page`, which calculates
offset for records returned (relative to `limit`).

## Coffees and Roasters
The `coffee` and `roaster` resources represent specific coffees and roasteries.  Typically, these will be referenced when creating a `cupped_coffee`, but may also be created when new green coffees or roasters need to be added to the database.

### Coffees
The `coffee` resource represents green coffee (i.e. not yet roasted), such that a single `coffee` resource may be referenced in many `cupped_coffee`s.  

###### The Coffee Object
Field | Description
------|------------
**`name`** | Name of coffee as string (required)
**`origin`** | Origin of coffee as string (required)
**`producer`** | Coffee producer as string (required)
**`variety`** | Coffee variety as string

###### Coffees Endpoints
    GET /coffees
    GET /coffees/:id
    GET /coffees/search
    POST /coffees

###### Coffees search
Queries for coffees by  `name`, `producer` and `origin`. Please see [notes on *users search* for further information](#users-search).

### Roasters
The `roaster` resource represents a specific roastery or roaster, such that a single `roaster` resource may be referenced in many `cupped_coffee`s.  

###### The Roaster Object
Field | Description
------|------------
**`name`** | Name of the roaster/roastery as string (required)
**`location`** | Roastery location as string (required)
**`website`** | Roastery website

###### Roasters Endpoints
    GET /roasters
    GET /roasters/:id
    GET /roasters/search
    POST /roasters

###### Roasters search
Queries for roasters by `name`and `location`. Please see [notes on *users search* for further information](#users-search).
