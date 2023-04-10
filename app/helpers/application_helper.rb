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
        return YAML.load_file(path, aliases: true)
      rescue Exception => e
        puts "There was an error reading config file #{path}: #{e.message}"
      end
    end
  end

  def render_overridable(path="", partial="", is_partial=true, **kwargs)
    # Only one arg will be passed if replacing a simple `render "template"` call
    # In that case, set partial to arg value assigned to path and empty path
    if partial == ""
      partial = path
      # template_exists? still needs a path to search; lookup_context.prefixes
      # is what render code uses when only one arg, so assign it to path here
      path = lookup_context.prefixes
    end

    # If partial still empty (no args), use controller action as template name
    if partial == ""
      partial = params[:action]
    end

    if @section.present? && path.is_a?(String) &&
      lookup_context.template_exists?(partial, "#{@section}/#{path}",
                                      is_partial)
      path = "#{@section}/#{path}"
    elsif @section.present? && path.is_a?(Array) &&
      lookup_context.template_exists?(partial, "#{@section}/#{path[0]}",
                                      is_partial)
      path = "#{@section}/#{path[0]}"
    elsif !lookup_context.template_exists?(partial, path, is_partial)
      # fallback to informative partial about customization
      path << "/" if path.present?
      @missing_partial = "#{path}#{partial}"
      return render "errors/missing_partial", kwargs
    end

    # Revert earlier assignment of lookup_context.prefixes so render args are
    # same as simple call `render "template"` being overridden
    path = "" if path == lookup_context.prefixes

    path << "/" if path.present?
    render "#{path}#{partial}", kwargs
  end

end
