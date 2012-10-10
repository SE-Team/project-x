require './lib/controllers/search/twitter'

## Basic Search ##############################################
##############################################################
get '/search/:args' do
  search_term = "%"
  search_term << params[:args].gsub('%20', '%')
  search_term << "%"
  e1 = Event.all(:title.like => search_term, permission: "public")
  e2 = Event.all(:category_name.like => search_term, permission: "public")
  @events = e1.zip(e2).flatten.compact
  categories = Set[]
  @events.each do |e|
    categories.add(e.category.name)
  end
  @categories = categories
  @content = partial(:'search/response', {events: @events, categories: @categories, search_term: params[:args].gsub('%20', ' ')})
  haml :partial_wrapper
end
##############################################################
#
## Twitter Search ############################################
##############################################################
get '/twitter-search/:args' do
  search = TwitterSearch.search({q: params[:args], count: 1000})
  results = search["results"]
  @events = results.map do |tweet|
    {title: tweet["text"],
     img_url: tweet["profile_image_url"],
     event_time: tweet["created_at"],
     category: "twitter",
     classes: "twitter",
     id: tweet["id"]}
  end
  @categories = ["twitter"]
  @content = partial(:'search/twitter_response', {events: @events, categories: @categories, search_term: params[:args].gsub('%20', ' ')})
  haml :partial_wrapper
end
##############################################################
