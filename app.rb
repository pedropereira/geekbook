require 'rubygems'
require 'sinatra'
require 'sinatra/activerecord'
require 'nokogiri'
require 'open-uri'


class Attendee < ActiveRecord::Base
  attr_accessible :name, :avatar_filename, :geek_votes, :profile_url

  def add_geek_vote
    self.geek_votes += 1
    self.save
  end
end


get '/' do
  @attendees      = Attendee.all(:order => 'geek_votes DESC')
  total_attendees = @attendees.count

  random_number_left  = rand(total_attendees) # olha o zero!!
  random_number_right = rand(total_attendees)

  @attendee_left  = Attendee.find(random_number_left)
  @attendee_right = Attendee.find(random_number_right)

  erb :index
end


post '/attendees/vote' do
  Attendee.find(params[:attendee_id]).add_geek_vote
end


get '/copy-attendees-avatars' do
  badges_html = Nokogiri::HTML(open("https://codebits.eu/s/badges/2"))
  attendees   = badges_html.css('div.yui-g span.vcard a.url img')

  attendees.each do |attendee|
    name            = attendee.attributes['title'].to_s
    avatar_filename = attendee.attributes['src'].to_s[/\w+\/(\w+)/] + '.jpg'

    badge_url   = attendee.parent.attributes['href'].to_s
    badge_html  = Nokogiri::HTML(open("https://codebits.eu" + badge_url))

    profile_url = badge_html.css('div.yui-g p span.vcard a.url').first.attributes['href'].to_s

    File.open('public/images/' + avatar_filename,'wb') do |f|
      f.write(open('https://codebits.eu/' + avatar_filename).read)
    end

    Attendee.create(:name => name, :avatar_filename => '/images/' + avatar_filename, :profile_url => profile_url)
  end
end
