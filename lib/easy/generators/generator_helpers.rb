module GeneratorHelpers

  def application_name
    Rails.application.class.name.split("::").first.underscore # surely there's a better way than this
  end

  private

  def bundle_command(command)
    # say_status :run, "bundle #{command}"
    # print `"#{Gem.ruby}" -rubygems "#{Gem.bin_path('bundler', 'bundle')}" #{command}`
    run("bundle #{command}")
  end

end
