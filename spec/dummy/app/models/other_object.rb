class OtherObject < Restly::Base

  self.path = "/api/other_objects"

  belongs_to_resource :sample_object

  field :foo_var
  field :bar_lee
  field :created_at
  field :updated_at

end