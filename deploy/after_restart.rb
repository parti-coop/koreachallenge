if 'production' == config.framework_env
  on_app_servers do
    #sudo "sleep 20s ; monit start all -g #{config.app}_sidekiq"
    run "bin/rails -s sitemap:refresh"
  end
end