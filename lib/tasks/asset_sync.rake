if defined?(AssetSync)
  Rake::Task['webpacker:compile'].enhance do
    Rake::Task['assets:sync'].invoke
  end
end
