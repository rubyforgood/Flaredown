class TopPostsMailerPreview < ActionMailer::Preview
  # Preview emails at http://localhost:3000/rails/mailers/top_posts_mailer/notify
  def notify
    TopPostsMailer.notify(email: 'test@flaredown.com', top_posts_ids: top_posts_ids)
  end

  def top_posts_ids
    posts = Post.pluck(:id).map(&:to_s)
    posts.any? ? posts.first(5) : []
  end
end
