class Support < ActiveRecord::Base
  SUPPORT_TYPES = ['Policia', 'Bomberos', 'Bomberos Voluntarios', 'Ambulancia', 'Regadora', 'Cooperativa Electrica', 'Otros']

  has_paper_trail

  belongs_to :mobile_intervention

  attr_accessible :support_type, :number, :responsible, :driver, :owner, :mobile_intervention_id

  validates_presence_of :support_type, :responsible, :owner

end
