class AddSeveralFieldsToFirefighters < ActiveRecord::Migration
  def change
    add_column :firefighters, :address,         :string
    add_column :firefighters, :blood_type,      :string
    add_column :firefighters, :blood_factor,    :string
    add_column :firefighters, :cellphone,       :string
    add_column :firefighters, :city,            :string
    add_column :firefighters, :dni,             :string
    add_column :firefighters, :education_level, :string
    add_column :firefighters, :email,           :string
    add_column :firefighters, :hierarchy,       :string
    add_column :firefighters, :linephone,       :string
    add_column :firefighters, :role,            :string
    add_column :firefighters, :sex,             :string
    add_column :firefighters, :state,           :string
    add_column :firefighters, :status,          :string

    add_column :firefighters, :federation,     :string
    add_column :firefighters, :firehouse_name, :string
    add_column :firefighters, :organization,   :string

    add_column :firefighters, :birth_date, :date
    add_column :firefighters, :started_at, :date

    add_column :firefighters, :is_active_boss, :boolean
    add_column :firefighters, :is_instructor,  :boolean

    add_column :firefighters, :number_of_childrens, :integer
  end
end
