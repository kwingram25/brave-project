module PagesHelper
  def prettify_resource(resource)
    JSON.pretty_generate(resource).split("\n")
  end

  def extract_fragments(line)
    match = /(\s*(?:".*?": )?")(https:\/\/swapi.co\/api\/(\w+)\/(\d+)\/)(",?)/.match(line)
    match.nil? ? nil : match.captures
  end
end
