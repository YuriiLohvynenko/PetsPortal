max_threads_count = ENV.fetch("RAILS_MAX_THREADS") { 10 }
min_threads_count = ENV.fetch("RAILS_MIN_THREADS") { max_threads_count }
threads min_threads_count, max_threads_count

worker_timeout 3600 if ENV.fetch("RAILS_ENV", "development") == "development"

port ENV.fetch("PORT") { 3000 }

environment ENV.fetch("RAILS_ENV") { "development" }

pidfile ENV.fetch("PIDFILE") { "tmp/pids/puma.pid" }

#workers ENV.fetch("WEB_CONCURRENCY") { 4 }

preload_app!

plugin :tmp_restart
