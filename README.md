# coffee-grader-api
back-end rails api for 'coffee-grader' coffee cupping app

###### Built on RAILS 5
    bundle install
    rails db:migrate
    rails db:seed
    rails server
###### Run Tests
    bundle exec rspec


## Documentation

coffees have the following properties:

**name** | Name of coffee as string
**origin** | Origin of coffee as string
**Procucer** | Coffee producer as string
**Variety** | Type of coffee as string


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


###Coffees Endpoints
    GET /coffees
    GET /coffees/:id
    POST /coffees
    PATCH /coffees/:id
    DELETE /coffees/:id

####Sample Response from GET /coffees
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

###Cupped Coffees Endpoints
    GET /cuppings/:cupping_id/cupped_coffees
    GET /cuppings/:cupping_id/cupped_coffees/:id
    POST /cuppings/:cupping_id/cupped_coffees
    PATCH /cuppings/:cupping_id/cupped_coffees/:id
    DELETE /cuppings/:cupping_id/cupped_coffees/:id

####Sample Response from GET /cuppings/:cupping_id/cupped_coffees
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

###Cuppings Endpoints
    GET /cuppings
    GET /cuppings/:id
    POST /cuppings
    PATCH /cuppings/:id
    DELETE /cuppings/:id

####Sample Response from GET /cuppings
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

###Invites Endpoints
    GET /cuppings/:cupping_id/invites
    GET /cuppings/:cupping_id/invites/:id
    POST /cuppings/:cupping_id/invites
    PATCH /cuppings/:cupping_id/invites/:id
    DELETE /cuppings/:cupping_id/invites/:id

####Sample Response from GET /cuppings/:cupping_id/invites
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

###Roasters Endpoints
    GET /roasters
    GET /roasters/:id
    POST /roasters
    PATCH /roasters/:id
    DELETE /roasters/:id

####Sample Response from GET /roasters
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