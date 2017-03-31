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

**name** | Name of coffee
**origin** | Origin of coffee
**Procucer** | Coffee producer
**Variety** | Type of coffee


cupped_coffees have the following properties:

Field | Description
------|------------
**roast_date** | Date of coffee roast
**coffee_alias** | Alternate identifier for coffee
**coffee_id** | Reference to associated coffee
**roaster_id** | Reference to associated roaster
**cupping_id** | Reference to associated cupping event


cuppings have the following properties:

Field | Description
------|------------
**location** | Location of cupping event
**cup_date** | Date of cupping event
**host_id** | Reference to associated user hosting the event
**cups_per_sample** | Number of cups per coffee being cupped


invites have the following properties:

Field | Description
------|------------
**cupping_id** | Reference to associated cupping event
**grader_id** | Reference to user being invited
**status** | Indication of whether invitee has accepted invite


roasters have the following properties:

Field | Description
------|------------
**name** | Name of the roaster
**location** | Roaster's location
**website** | Website of roaster


scores have the following properties:

Field | Description
------|------------
**cupped_coffee_id** | Reference to associated cupped coffee
**cupping_id** | Reference to associated cupping event
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
**grader_id** | Reference to associated grader
**final_score** | Decimal indicating final score attributed to cupped coffee
**flavor** | Decimal indicating flavor, determined by grader


users have the following properties:

Field | Description
------|------------
**name** | Name of user
**username** | User determined alias
**email** | Email address of user
