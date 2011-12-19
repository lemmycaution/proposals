web: bundle exec thin -R config.ru start -p $PORT -e ${RACK_ENV:-development}
clock: bundle exec clockwork lib/update_tweets.rb
worker: bundle exec rake track_tweets