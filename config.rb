page '/*.xml', layout: false
page '/*.json', layout: false
page '/*.txt', layout: false

activate :directory_indexes

set :site_title, "Sam Ullman"

activate :syntax

set :trailing_slash, false

configure :development do
  # activate :livereload
end

# Methods defined in the helpers block are available in templates
helpers do

  def icon(icon, options={})
    resource = sitemap.find_resource_by_path("/icons/#{icon.downcase}.svg")

    classes = [icon.downcase, options[:class], 'icon'].join(' ').squeeze(' ')
    unless options[:inline]
      return "<img alt='#{icon}' class='#{classes}' src='/#{resource.path}'>"
    else
      doc = Nokogiri::HTML::DocumentFragment.parse `svgo -s '#{resource.render}'`
      svg = doc.at_css "svg"
      svg["class"] = classes
      return doc.to_s + "<span class='screenreader'>#{icon}</span>"
    end

  end

  def gravatar_for(email, params={})
    email.downcase!
    hash = Digest::MD5.hexdigest(email)
    image_tag "https://www.gravatar.com/avatar/#{hash}?s=200", params
  end

  def inline_css(path)
    file = sitemap.find_resource_by_path("/stylesheets/" + path.to_s + ".css")
    if file.nil?
      file = sitemap.find_resource_by_path(path.to_s + ".css")
    end
    "<style>#{file.render}</style>"
  end

  def inline_js(path)
    path = "/javascripts/" + path.to_s + ".js"
    "<script>#{sitemap.find_resource_by_path(path).render}</script>"
  end

end

# Build-specific configuration
configure :build do

  activate :minify_css, inline: true
  activate :minify_html
  activate :minify_javascript, inline: true

end

activate :external_pipeline,
  name: :brunch,
  command: build? ? 'brunch build --production' : 'brunch watch --production',
  source: "public",
  latency: 0
