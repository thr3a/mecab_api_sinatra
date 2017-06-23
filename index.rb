require 'sinatra'
require 'sinatra/json'
require 'sinatra/reloader' if development?
require 'natto'
require 'json'

class MyMecab
  attr_accessor :options, :result, :text, :m
  
  def initialize(options={})
    self.options = {}
    self.options[:type] = options[:type]
    %w"only exclude".each do |type|
      self.options[type.to_sym] = options[type.to_sym] || ''
      self.options[type.to_sym] = self.options[type.to_sym].split('|')
    end
    self.text = options[:text]
    self.m = Natto::MeCab.new
  end

  def exec
    self.result = []
    self.m.parse(self.text) do |n|
      feature = n.feature.split(',')
      next if(feature[0] == 'BOS/EOS')
      next if(self.options[:exclude].include?(feature[0]))
      next if(self.options[:only].length > 0 && !self.options[:only].include?(feature[0]))
      if self.options[:type] == 'wakati'
        self.result << n.surface
      else
        self.result << {
          surface: n.surface,
          feature: n.feature.split(',')
        }
      end
    end
  end
end

set :json_content_type, :json
get '/' do
  m = MyMecab.new(params)
  m.exec
  json m.result
end

post '/' do
  m = MyMecab.new(params)
  m.exec
  json m.result
end