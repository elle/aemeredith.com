max_threads = Integer(ENV.fetch("WEB_MAX_THREADS", 5))
threads max_threads, max_threads

port ENV.fetch("PORT", 3000)
environment ENV.fetch("RACK_ENV", "development")

workers_count = Integer(ENV.fetch("WEB_CONCURRENCY", 0))
workers workers_count

# Run Que's worker inside the web process so no separate worker dyno is needed.
# If the process is dropped, its advisory locks release and any in-flight job
# is picked up again.
def start_embedded_que
  worker_count = Integer(ENV.fetch("QUE_WORKER_COUNT", 1))
  locker = Que::Locker.new(worker_priorities: Array.new(worker_count))
  at_exit { locker.stop! }
end

if workers_count.positive?
  preload_app!

  on_worker_boot do
    if defined?(ActiveRecord::Base)
      ActiveRecord::Base.establish_connection
    end
    start_embedded_que
  end
else
  on_booted do
    start_embedded_que
  end
end
