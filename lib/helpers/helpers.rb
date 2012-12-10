require 'haml'

module Helpers

  def get_in(coll, keys)
    cur_coll = coll
    keys.each{|k| cur_coll = cur_coll[k]}
    return cur_coll
  end

  def partial(template,locals=nil)
    if template.is_a?(String) || template.is_a?(Symbol)
      template=(template.to_s).to_sym
    else
      locals=template
      template=template.is_a?(Array) ? (template.first.class.to_s.downcase).to_sym : (template.class.to_s.downcase).to_sym
    end
    if locals.is_a?(Hash)
      haml(template,{:layout => false},locals)
    elsif locals
      locals=[locals] unless locals.respond_to?(:inject)
      locals.inject([]) do |output,element|
        output <<     erb(template,{:layout=>false},{template.to_s.delete("_").to_sym => element})
      end.join("\n")
    else
      haml(template,{:layout => false})
    end
  end

  def self.random_string(len)
    chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
    str = ""
    1.upto(len) { |i| str << chars[rand(chars.size-1)] }
    return str
  end

  def new_comment
  	return partial (:'tumbler/new_comment')
  end

  def gravatar_for(user, i_size="")
    gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
    "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{i_size}"
  end

  def ajax_tile(event)
    puts event
  end

  def follow_btn(user)
    "<a class='btn btn-warning'> Follow #{user.user_name} </a>"
  end

  def unfollow_btn(user)
    "<a class='btn btn-primary'> Follow #{user.user_name} </a>"
  end

  def youtube_embed(youtube_url)
    if youtube_url[/youtu\.be\/([^\?]*)/]
      youtube_id = $1
    else
      youtube_url[/^.*((v\/)|(embed\/)|(watch\?))\??v?=?([^\&\?]*).*/]
      youtube_id = $5
    end
      "<iframe title='YouTube video player' width='480' height='360' src='http://www.youtube.com/embed/#{ youtube_id }' frameborder='0' allowfullscreen></iframe>"
      #'%iframe{:allowfullscreen => "", :frameborder => "0", :height => "360", :src => "http://www.youtube.com/embed/\#{ youtube_id }", :title => "YouTube video player", :width => "480"}'
  end

end
