run "rm -rf #{config.release_path}/public/uploads"
run "ln -nfs #{config.shared_path}/public/uploads #{config.release_path}/public/uploads"
run "rm -rf #{config.release_path}/private"
run "ln -nfs #{config.shared_path}/private #{config.release_path}/private"
