module ApplicationHelper
  def gravatar_for(user, opts = {})
    opts[:alt] = user.email.split('@')[0]
    image_tag "https://www.gravatar.com/avatar/#{Digest::MD5.hexdigest(user.email)}?d=retro&r=pg&s=#{opts.delete(:size) { 40 }}",
              opts
  end
end
