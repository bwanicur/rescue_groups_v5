# RescueGroupsV5

This is the wrapper for the new <a target="_blank" href="https://api.rescuegroups.org/v5/public/docs">Rescue Groups API V5</a>

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rescue_groups_v5'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rescue_groups_v5

## Usage

```ruby
# basic example
client = RescueGroupsV5::Client.new(API_KEY_HERE)

search_options = {
  fields: {
    animals: [ :name, :breedPrimary ],
    orgs: [ :name, :city ]
  },
  postalcode: '92107',
  radius_in_miles: 15
}
result = client.search_animals(search_options)
```

Nest Data:  This gem can nest the response "included" data under the parent object. If you want this feature, \
set `nest_data` to true.  Included data will still be under the `included` section of the response, \ 
regardless of this option.
```ruby
client_options = { nest_data: true }
client = RescueGroupsV5::Client.new(API_KEY_HERE, client_options)
```

## Request Options
### Fields Option:
A hash where each key is the name of an object and each value is an array of fields to include.  Used to scope \
down the size of the response. If not included, all fields will be returned.
```ruby
# psuedo-code
{ object: [ :collection, :of, :fields ] }
```

### Supported Objects:
- animals
- orgs

### Available Fields:
- [Animals](https://github.com/bwanicur/rescue_groups_v5/blob/master/lib/rescue_groups_v5/fields/animal.rb)
- [Breeds](https://github.com/bwanicur/rescue_groups_v5/blob/master/lib/rescue_groups_v5/fields/breed.rb)
- [Organizations](https://github.com/bwanicur/rescue_groups_v5/blob/master/lib/rescue_groups_v5/fields/organization.rb)
- [Contacts](https://github.com/bwanicur/rescue_groups_v5/blob/master/lib/rescue_groups_v5/fields/contact.rb)
- [Statuses](https://github.com/bwanicur/rescue_groups_v5/blob/master/lib/rescue_groups_v5/fields/status.rb)

Example:
```ruby
options[:fields] = {
  animals: [ :name, :ageGroup, :breedPrimary ],
  orgs: [ :name, :city ]
}
```

### Sort:
An array of hashes with the following keys:

- object: (aniamls, organizations)
- sort_value: they attribute to use for sorting
- direction:  sort direction

```ruby
# sort by Animal breedPrimary - ascending, then Organization name ascending
options[:sort] = [
  {
    object: :animals,
    sort_value: :breedPrimary,
    direction: :ascending
  },
  {
    object: :orgs,
    sort_value: :name,
    direction: :ascending
  }
]
```

### Page:
For paginating requests.  Integer value.  Defaults to 1.
```ruby
options = { page: 2 }
```

### Limit:
Simple integer limit (Rescue Groups API enforces a max limit of 250).  Defaults to 25.
```ruby
options = { limit: 50 }
```

### Location Filtering:
_Only available on search requests_

The following "global" filters are available to search by location.

```ruby
options[:postalcode] = '92107' # string postalcode
```

```ruby
options[:radius_in_miles] = 20 # integer value
```

### General Filters:
_Only available on search requests_

An array of hashes containing the following keys:

- object: animals, organizations
- field_name: the object's field
- operation: see list of operations [here](https://github.com/bwanicur/rescue_groups_v5/blob/master/lib/rescue_groups_v5/services/filter_builder.rb)
- value

```ruby
options[:filters] = [
  {
    object: :animals,
    fieldName: :breedPrimary,
    operation: :contains,
    value: 'Staffordshire'
  },
  {
    object: :animals,
    operation: :greater_than,
    fieldName: :birthDate,
    value: '01-01-2012'
  }  
]
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/bwanicur/rescue_groups_v5.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
