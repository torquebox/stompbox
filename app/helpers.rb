module StompBox
  class Application < Sinatra::Base 
    
    helpers do 
      include StompBox::Config 
  
      def config(key)
        StompBox::Config.get(key)
      end
  
      def home_path
        request.script_name
      end
  
      def to(location)
        location.gsub!(/^\//, '')
        "#{home_path}/#{location}"
      end
  
      def repositories
        @repositories ||= Repository.ordered
      end
  
      def classes_for(push)
        track = push.tracked? ? 'tracked' : 'ignored'
        [push.status, track, classify(push.repo_name), classify(push.branch)]
      end
  
      def selector_for(push)
        classes_for(push).join('.')
      end
  
      def classify(str)
        str.gsub('.', '-')
      end
  
    end
  end
end
