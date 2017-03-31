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
