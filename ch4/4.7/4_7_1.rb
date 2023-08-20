def event(description, &block)
  @events << { description: description, condition: block }
end

@events = []
load 'event.rb'
