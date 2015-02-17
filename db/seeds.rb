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

InterventionType.all.update_all(priority: nil)

%w(
  accidente_con_heridos_de_auto
  accidente_con_heridos_de_micro
  accidente_con_heridos_de_moto
  derrumbe
  explosion
  incendio_en_auto
  incendio_en_casa
  incendio_en_industria
  materiales_peligrosos
  rescate_de_persona
).each_with_index do |file, i|
  InterventionType.create!(
    name:     file.gsub('_', ' ').camelize,
    priority: i+1,
    image:    File.open(Rails.root.join('lib', 'assets', "#{file}.png")),
    color:    '#ffffff'
  )
  puts "Creado #{file}"
rescue
  puts "#{file} error..."
end
