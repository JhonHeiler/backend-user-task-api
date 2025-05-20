# Crea/sobrescribe el archivo db/seeds.rb con el contenido del script
cat <<'RUBY' > db/seeds.rb
5.times do |i|
  u = User.create!(
    email: "user#{i}@example.com",
    full_name: "Usuario #{i}",
    role: %w[admin user].sample
  )
  3.times do |j|
    u.tasks.create!(
      title: "Tarea #{j} de #{u.full_name}",
      description: "Descripción demo",
      status: %w[pending done].sample,
      due_date: Date.today + j.days
    )
  end
end
RUBY