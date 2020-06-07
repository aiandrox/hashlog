require "administrate/base_dashboard"

class UserDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    authentications: Field::HasMany,
    registered_tags: Field::HasMany,
    tags: Field::HasMany,
    id: Field::Number,
    twitter_id: Field::String,
    uuid: Field::String,
    name: Field::String,
    description: Field::Text,
    privacy: Field::Select.with_options(collection: %i[publish closed]),
    role: Field::Select.with_options(collection: %i[genaral admin guest]),
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
    screen_name: Field::String,
    avatar_url: Field::String,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = %i[
  id
  name
  screen_name
  description
  privacy
  role
  tags
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = %i[
    id
    uuid
    twitter_id
    name
    screen_name
    description
    privacy
    role
    avatar_url
    created_at
    updated_at
    registered_tags
    tags
    authentications
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = %i[
    twitter_id
    name
    screen_name
    description
    privacy
    role
    avatar_url
    authentications
    tags
  ].freeze

  # COLLECTION_FILTERS
  # a hash that defines filters that can be used while searching via the search
  # field of the dashboard.
  #
  # For example to add an option to search for open resources by typing "open:"
  # in the search field:
  #
  #   COLLECTION_FILTERS = {
  #     open: ->(resources) { resources.where(open: true) }
  #   }.freeze
  COLLECTION_FILTERS = {}.freeze

  # Overwrite this method to customize how users are displayed
  # across all pages of the admin dashboard.
  #
  def display_resource(user)
    "#{user.name}@#{user.screen_name}"
  end
end
