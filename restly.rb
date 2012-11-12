#### A Restful Object Document Mapper (ODM)

# Restly provides an easy to use mechanism to connect your RESTful APIs to Ruby Models.

### Configuration
#### The Rails Way
# When you are using rails restly comes with a configuration of generator to help you get started.
#
# You can run ```$ rails g restly:config``` Which will generate the following config.

<<YAML # config/restly.yml

development:
  default_format:   json
  session_key:      :access_token
  load_middleware:  true # Load the rails middleware to auto-authenticate oauth sessions.
  site:             http://api.example.com
  use_oauth:        false # Set to true, and set the information below if you wish to use oauth.
  oauth_options:
    client_id:        %client_id%
    client_secret:    %client_secret%
  cache:            true # Set to true, and set the information below if you wish to cache objects.
  cache_options:
    expires_in:       30

YAML

#### The Ruby Way
# If you are not using rails, then you can load the configuration using restly's config block.

Restly.config do |config|
  config.default_format = :json
  config.site           = 'http://api.example.com'
  config.cache          = true
  config.cache_options  = { expires_in: 30 }
end

### Models
# > ___Restly Extends from Active Model, which means out of the box you get rails like validations, accessible attributes
# > and more. See [ActiveModel](http://api.rubyonrails.org/classes/ActiveModel.html) for more detail.___
#
# Models can be generated by hand or by using the rails generator:
#
# ```rails g restly:model```

class Contact < Restly::Base

##### Model Config Overrides
# Site and other configuration may be overridden on a per model basis

  self.path = "/v1/contacts" # Path with try to be determined by the resource_name by default.
  self.site   = "http://api.example.com"
  self.format = :json
  self.cache  = true
  self.cache_options = { expires_in: 15.minutes }


#### Fields
# A Model must be configured with fields. This will ensure, no invalid data gets sent back to the API. The **id** field is required and therefore always assumed.

  field :first_name
  field :middle_name
  field :last_name
  field :age

#### Associations

##### has\_many\_resources
# The foreign key lies on the child resources, therefor the path to find the resources is determined in a restful nature.
#
# * **the call:**   ``contact.phone_numbers``  
# * **results in:** ``GET http://api.example.com/v1/contacts/phone_numbers``

  has_many_resources :phone_numbers

##### has\_many\_resources
# The foreign key lies on the child resource, therefor the path to find the resource is determined in a restful nature.
#
# * **the call:**   ``contact.address``  
# * **results in:** ``GET http://api.example.com/v1/contacts/address``

  has_one_resource :address
  
##### belongs\_to\_resource
# In this case the foreign key is present so we can do a direct lookup:
#
# * **given:** ``account_id = 4``  
# * **the call**: ``contact.account``  
# * **results in:** ``GET http://api.example.com/v1/accounts/1``
  
  belongs_to_resource :account

##### Associations with a custom class:
# Associations can be given a custom class by providing the class directly or by providing the classes name:
  has_many_resources :phone_numbers, class: CustomPhoneNumber
  has_many_resources :phone_numbers, class_name: "CustomPhoneNumber"

##### Associations with a custom foreign key:
# Associations can be given a custom foreign key by providing the ``foreign_key`` option.
  
  has_many_resources :phone_numbers, foreign_key: "contact_id"

#### Nested Attributes
# You can accept nested attributes for associations and they will be formatted properly before being sent off to the api.
  
  accepts_nested_attributes_for_resource :account
  
##### Rewrite Attribute
# If you are not sending to a rails application you can specify the rewritten attribute.
  
  accepts_nested_attributes_for_resource :account, rewrite_to: :account_data
  

end
  
#### Embedded Associations
# Sometimes an API may only return data embedded in other objects. In order to facilitate this restly has embedded
# associations. This is for models that can be only accessed within other objects.
  
# ***NOTE: When a object is a normal relationship it may also behave like it is embedded, only use embedded associations
# that can't be unless its embedded in another object.***

class Contact < Restly::Base

##### embeds\_resource
# When an object embeds a single resource.
  embeds_resource :role
  
##### embeds\_resource  
# When an object embeds a collection of resources.
  embeds_resources :permissions
  
##### embedded\_in
# Makes an object embedded, marking it inaccessible by any direct path.
  embedded_in :account 

#### Restful Spec
# Restly is compatible with [restful_spec](http://github.com/jwaldrip/restful_spec), which allows for API specification
# over the HTTP **OPTIONS** method. This will take care of your fields and accessible attributes automatically.
#
# _Only the API application needs **restful\_spec**. Since your app using restly is ingesting from the API,  there is no need
# to put **restful\_spec** in the Gemfile_.

end  

class Contact < Restly::Base
  
  has_specification

end

#### Restly Associations for All
# You can include the restly associations for any ruby class. Include the module and you will get all the non embedded
# associations.

class User < ActiveRecord::Base
  
  include Restly::Associations 
  
end

### Accessing your Models
# Once you have your models defined, accessing things are pretty familiar.

#### The Basics

# Get a collection...
contacts = Contact.all

# Find an Object...
contact = Contact.find

# Get an Association...
contact.phone_numbers
contact.address

#### Modifiers
# Modifiers change the outbound request. These can be added to any call within a restly query.
Model.modifer
instance.modifer
instance.association.modifer

##### Authorization:
# Authorizes a request before making it.
Contact.authorize({ access_token: 'abc123' })

##### With Parameters:
# Add parameters to the outgoing call.
Contact.with_params({ sort_by: "name" })

##### With Path
# Changes the path.
Contact.with_path("v2/contacts")

###### Prepending the Path...
Contact.with_path(prepend: "/my")

###### Appending the path...
Contact.with_path(append: "/deleted")

###### Combine them all...
Contact.with_path("v2/contacts", prepend: "/my", append: "/deleted")


### More coming soon...
##### TODO's:
# * Full Tested!
# * Polymorphic Associations
# * Many to Many Associations
# * Additional Authorization Schemes (I.E. Basic Auth, API Token, etc.)
# * And More...
