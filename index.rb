require 'sinatra'
require 'sinatra/json'
require 'sinatra/reloader' if development?
require 'natto'

class MyMecab
  attr_accessor :options, :result, :text, :natto
  
  def initialize(options={})
    self.options = {}
    self.options[:type] = options[:type]
    %w"only exclude".each do |type|
      self.options[type.to_sym] = options[type.to_sym] || ''
      self.options[type.to_sym] = self.options[type.to_sym].split('|')
    end
    self.text = options[:text]
    self.natto = Natto::MeCab.new
  end

  def exec
    self.result = []
    self.natto.parse(self.text.strip) do |n|
      feature = n.feature.split(',')
      next if(self.options[:exclude].include?(feature[0]))
      next if(self.options[:only].length > 0 && !self.options[:only].include?(feature[0]))
      if self.options[:type] == 'wakati'
        next if(n.feature[1] == '数')
        self.result << n.surface
      else
        self.result << {
          surface: n.surface,
          feature: n.feature.split(',')
        }
      end
    end
    self.result.pop
  end
end

set :server, :puma
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

if development?
  get '/test' do
    erb :test
  end
end

__END__
@@test
<form method='post' action='/'>
  <textarea name="text">
  </textarea>
  <input type="submit">
</form>