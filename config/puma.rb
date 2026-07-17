max_threads = Integer(ENV.fetch("WEB_MAX_THREADS", 5))
threads max_threads, max_threads

port ENV.fetch("PORT", 3000)
environment ENV.fetch("RACK_ENV", "development")

workers_count = Integer(ENV.fetch("WEB_CONCURRENCY", 0))
workers workers_count

# In clustered mode, preload the app and reconnect Active Record per worker.
if workers_count.positive?
  preload_app!

  on_worker_boot do
    if defined?(ActiveRecord::Base)
      ActiveRecord::Base.establish_connection
    end
  end
end
