# Thread-safe store for attributes.
# See https://api.rubyonrails.org/classes/ActiveSupport/CurrentAttributes.html
# for more information.
class Current < ActiveSupport::CurrentAttributes
  attribute :user
end
