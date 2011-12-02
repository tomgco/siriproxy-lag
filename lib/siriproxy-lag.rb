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

  listen_for /why (am i|my) (lagging|lacking)/i do
    file = "/var/lib/smokeping/External/VirginExchange.rrd"
    length = 1200

    loss = RRD.graph("-", "DEF:a=#{file}:loss:AVERAGE", "CDEF:ploss=a,100,*,20,/", "PRINT:ploss:AVERAGE:%.2lf %s", "--end", "now", "--start", "end-1200")[0][0]
    lagAmount = "Nothing to report!"
    case loss
    when 1..5
      lagAmount = "Little bit of lag here."
    when 5..20
      lagAmount = "Might need to look into it."
    when 20..50
      lagAmount = "You cannot play now, too much packet loss!"
    when 50..100
      lagAmount = "Something is fucked up."
    end

    say "#{lagAmount}" #say something to the user!
    response = ask " Would you like to see a graph?" #ask the user for something

    if(response =~ /yes/i) #process their response
      endTime = Time.now.to_i
      startTime = endTime - 1200
      object = SiriAddViews.new
      object.make_root(last_ref_id)
      say "http://10.0.0.144/cgi-bin/smokeping.cgi?displaymode=a;start=#{startTime};end=#{endTime};target=External.VirginExchange;"
      answer = SiriAnswer.new("Lag Graph", [
        SiriAnswerLine.new('image','http://10.0.0.144/cgi-bin/smokeping.cgi?displaymode=a;start=#{startTime};end=#{endTime};target=External.VirginExchange;')
       ])
      object.views << SiriAnswerSnippet.new([answer])
      send_object object
    else
      say "Thanks, Bye!"
    end

    request_completed #always complete your request! Otherwise the phone will "spin" at the user!
  end
end
