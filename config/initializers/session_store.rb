# Be sure to restart your server when you modify this file.
require 'action_dispatch/middleware/session/dalli_store'

# Share devise session accross over subdomain. https://github.com/plataformatec/devise/wiki/How-To:-Use-subdomains
Rails.application.config.session_store ActionDispatch::Session::CacheStore,
                                       cache: ActiveSupport::Cache::MemCacheStore.new(
                                           ENV['MEMCACHE_SERVERS'].present? ? ENV['MEMCACHE_SERVERS'].split(',') : 'localhost:11211', {
                                           namespace: 'sessions',
                                       }),
                                       expire_after: 2.weeks