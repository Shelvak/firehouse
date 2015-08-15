begin
  User.create!(
    name: 'Admin',
    lastname: 'Admin',
    email: 'admin@firehouse.com',
    password: '123456',
    password_confirmation: '123456',
    role: :admin
  )
rescue
  puts "Admin ya existe"
end

begin
  User.create!(
    name: 'Console',
    lastname: 'Console',
    email: 'console@firehouse.com',
    password: 'Console',
    password_confirmation: 'Console',
    role: :admin
  )
rescue
  puts "Console ya existe"
end


%w(
  accidente_con_heridos_de_auto
  accidente_con_heridos_de_micro
  accidente_con_heridos_de_moto
  rescate_de_persona
  derrumbe
  explosion
  incendio_en_auto
  incendio_en_casa
  incendio_en_industria
  materiales_peligrosos
).each_with_index do |file, i|

  begin
    intervention_name = file.gsub('_', ' ').camelize

    if InterventionType.find_by(name: intervention_name)
      puts "#{intervention_name} existe"
    else
      InterventionType.where(priority: i+1).update_all(priority: nil)

      InterventionType.create!(
        name:     intervention_name,
        priority: i+1,
        image:    File.open(Rails.root.join('lib', 'assets', "#{file}.png")),
        color:    '#ffffff'
      )
      puts "Creado #{file}"
    end
  rescue
    puts "#{file} error..."
  end
end
