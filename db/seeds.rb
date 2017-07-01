data = YAML.load_file 'config/projects.yml'
data['projects'].each do |project|
  #TODO refactor this
  #name = project["name"]
  #client_name = project["client_name"]
   #Project.create!(name: name, client_name: client_name)
   Project.create!(name: project["name"], client_name: project["client_name"])
end
