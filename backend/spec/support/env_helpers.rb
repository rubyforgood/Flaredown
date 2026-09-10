# Several classes read their configuration straight out of ENV. `.env` is gitignored,
# so those variables are present on a developer machine and absent on CI -- a spec
# that leans on them passes locally and fails in the pipeline. Set what you need
# explicitly instead of assuming the environment provides it.
module EnvHelpers
  def with_env(values)
    original = values.keys.index_with { |key| ENV[key] }
    ENV.update(values.transform_values(&:to_s))
    yield
  ensure
    original.each { |key, value| value.nil? ? ENV.delete(key) : ENV[key] = value }
  end
end

RSpec.configure do |config|
  config.include EnvHelpers
end
