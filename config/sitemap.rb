if Rails.env.production?
  # Set the host name for URL creation
  SitemapGenerator::Sitemap.default_host = "http://koreachallenge.kr"

  SitemapGenerator::Sitemap.create do
    add about_path
    add intro_path
    add schedule_path
    add judge_path
    add faq_path
    add notices_path, :changefreq => 'daily'
    add stories_path, :changefreq => 'daily'

    Notice.find_each do |notice|
      add notice_path(notice), :lastmod => notice.updated_at
    end
    Story.find_each do |story|
      add story_path(story), :lastmod => story.updated_at
    end
  end
end