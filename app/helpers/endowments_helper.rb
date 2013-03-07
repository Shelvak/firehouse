module EndowmentsHelper
  def build_endowment_form                                                     
    form = nil
                                                                                
    simple_fields_for(@intervention) do |f|                                            
      f.simple_fields_for(:endowment) do |of|                                 
        form = of                                                               
      end                                                                       
    end                                                                         
                                                                                
    form                                                                        
  end
end
