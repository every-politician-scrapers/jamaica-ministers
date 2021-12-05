#!/bin/env ruby
# frozen_string_literal: true

require 'every_politician_scraper/scraper_data'
require 'pry'

class MemberList
  class Member
    def name
      noko.css('h4 strong').text.tidy
    end

    def position
      return role if ['Prime Minister of Jamaica', 'Minister without Portfolio'].include? role
      return ministry.sub('Ministry', 'Minister') if role == 'Minister'
      return "#{role} at the #{ministry}" if role == 'Minister of State'

      raise "Unknown role: #{role} for #{name}"
    end

    private

    def ministry
      noko.css('p').text.tidy
    end

    def role
      noko.css('h4').last.text.tidy
    end
  end

  class Members
    def member_container
      noko.css('.cabinet-minister-profile-details')
    end
  end
end

file = Pathname.new 'html/official.html'
puts EveryPoliticianScraper::FileData.new(file).csv
