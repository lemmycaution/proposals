web: bundle exec thin -R config.ru start -p $PORT -e ${RACK_ENV:-development}
worker: bundle exec rake track_tweets
clock: bundle exec clockwork lib/update_tweets.rb