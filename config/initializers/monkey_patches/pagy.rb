Pagy::Backend.class_eval {
  private
  def pagy_headers(pagy)
    hash = pagy_headers_hash(pagy)
    hash['Link'] = hash['Link'].map{|rel, link| %(<#{link}>; "#{rel}")}.join(', ')
    hash['Request-Url'] = request.url.sub(/\?page=(\d+)$/, '?page=')
    hash
  end
}
