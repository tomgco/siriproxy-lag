require 'cora'
require 'siri_objects'
require "RRD"

#######
#
# Remember to add other plugins to the "config.yml" file if you create them!
######

class SiriProxy::Plugin::Lag < SiriProxy::Plugin

  def initialize(config)
    #if you have custom configuration options, process them here!
  end

  listen_for /why am i lagging|lacking/i do
    file = "/var/lib/smokeping/External/VirginExchange.rrd"
    length = 1200

    loss = RRD.graph("-", "DEF:a=\"#{file}\":loss:AVERAGE", "CDEF:ploss=a,100,*,20,/", "PRINT:ploss:AVERAGE:\"Average\\: %.2lf %% avg\"", "--end", "now", "--start", "end-1200")

    say "Why not! #{loss}%" #say something to the user!

    request_completed #always complete your request! Otherwise the phone will "spin" at the user!
  end

  #demonstrate state change
  #listen_for /siri proxy test state/i do
    #set_state :some_state #set a state... this is useful when you want to change how you respond after certain conditions are met!
    #say "I set the state, try saying 'confirm state change'"

    #request_completed #always complete your request! Otherwise the phone will "spin" at the user!
  #end

  #listen_for /confirm state change/i, within_state: :some_state do #this only gets processed if you're within the :some_state state!
    #say "State change works fine!"
    #set_state nil #clear out the state!

    #request_completed #always complete your request! Otherwise the phone will "spin" at the user!
  #end

  #demonstrate asking a question
  #listen_for /siri proxy test question/i do
    #response = ask "Is this thing working?" #ask the user for something

    #if(response =~ /yes/i) #process their response
      #say "Great!" 
    #else
      #say "You could have just said 'yes'!"
    #end

    #request_completed #always complete your request! Otherwise the phone will "spin" at the user!
  #end

  ##demonstrate capturing data from the user (e.x. "Siri proxy number 15")
  #listen_for /siri proxy number ([0-9,]*[0-9])/i do |number|
    #say "Detected number: #{number}"

    #request_completed #always complete your request! Otherwise the phone will "spin" at the user!
  #end

  ##demonstrate injection of more complex objects without shortcut methods.
  #listen_for /test map/i do
    #add_views = SiriAddViews.new
    #add_views.make_root(last_ref_id)
    #map_snippet = SiriMapItemSnippet.new
    #map_snippet.items << SiriMapItem.new
    #utterance = SiriAssistantUtteranceView.new("Testing map injection!")
    #add_views.views << utterance
    #add_views.views << map_snippet

    ##you can also do "send_object object, target: :guzzoni" in order to send an object to guzzoni
    #send_object add_views #send_object takes a hash or a SiriObject object

    #request_completed #always complete your request! Otherwise the phone will "spin" at the user!
  #end
end
