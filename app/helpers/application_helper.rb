module ApplicationHelper
  include Orchid::ApplicationHelper

  def parse_md_brackets(query)
    /\[(.*)\]/.match(query)[1] if /\[(.*)\]/.match(query)
  end

  def parse_md_parentheses(query)
    /\]\((.*)\)/.match(query)[1] if /\]\((.*)\)/.match(query)
  end

  def construct_auth_header(options)
    username = options["es_user"]
    password = options["es_password"]
    { "Authorization" => "Basic #{Base64::encode64("#{username}:#{password}")}" }
  end

  def read_config(path)
    if File.file?(path)
      begin
        return YAML.load_file(path)
      rescue Exception => e
        puts "There was an error reading config file #{path}: #{e.message}"
      end
    end
  end

end
