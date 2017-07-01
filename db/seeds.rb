data = YAML.load_file 'config/projects.yml'
data['projects'].each do |project|
  name = project["name"]
  client_name = project["client_name"]
   Project.create!(name: name, client_name: client_name)
end
