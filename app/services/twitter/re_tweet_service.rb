require 'rubygems'
require 'bundler/setup'
require 'twitter'
require 'figaro'

Figaro.application = Figaro::Application.new(
    environment: 'production',
    path: File.expand_path('config/application.yml')
)

Figaro.load