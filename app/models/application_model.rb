class ApplicationModel < ActiveRecord::Base
  self.abstract_class = true

  has_paper_trail

  def changes_for_json
    changes_for_json = {}

    previous_changes.each do |key, (old_v, new_v)|
      changes_for_json[key.to_sym] = new_v
    end

    changes_for_json.merge!(id: self.id) if self.id
    changes_for_json.merge!(errors: self.errors.to_hash) if self.errors.any?

    changes_for_json
  end
end
