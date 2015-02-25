# team_hub - Components for creating a team Hub using Jekyll
#
# Written in 2015 by Mike Bland (michael.bland@gsa.gov)
# on behalf of the 18F team, part of the US General Services Administration:
# https://18f.gsa.gov/
#
# To the extent possible under law, the author(s) have dedicated all copyright
# and related and neighboring rights to this software to the public domain
# worldwide. This software is distributed without any warranty.
#
# You should have received a copy of the CC0 Public Domain Dedication along
# with this software. If not, see
# <https://creativecommons.org/publicdomain/zero/1.0/>.
#
# @author Mike Bland (michael.bland@gsa.gov)

require_relative "test_helper"
require_relative "../lib/team_hub/cross_referencer"
require_relative "site"

require "minitest/autorun"

module TeamHub
  class CrossReferencerLocationsTest < ::Minitest::Test
    def setup
      config = {
      }
      @site = DummyTestSite.new(config: config)
      @site.data.delete 'private'
      @site.data.delete 'public'
      @locations = [
        {'code' => 'DCA',
         'latitude' => 38.843677,
         'longitude' => -77.046915,
         'timezone' => 'Eastern Time Zone (UTC-05:00)',
        },
        {'code' => 'NYC',
         'latitude' => 40.641311,
         'longitude' => -73.778139,
         'timezone' => 'Eastern Time Zone (UTC-05:00)',
        },
        {'code' => 'TUS',
         'latitude' => 32.11451,
         'longitude' => -110.939227,
         'timezone' => 'Mountain Time Zone (UTC-07:00)',
        },
      ]
      @site.data['locations'] = @locations
    end

    def create_xref_using_team_data(team)
      @site.data['team'] = team
      CrossReferencerImpl.new @site.data
    end

    def test_no_locations_updated_if_team_is_empty
      xref = create_xref_using_team_data []
      xref.xref_locations
      assert_empty @site.data['locations'].map{|i| i['team']}.compact!
      assert_empty @site.data['locations'].map{|i| i['projects']}.compact!
      assert_empty @site.data['locations'].map{|i| i['working_groups']}.compact!
    end

    def test_xref_locations
      projects = [
        {'name' => 'Outreach'},
        {'name' => 'C2'},
        {'name' => 'EITI'},
      ]

      working_groups = [
        {'name' => 'Documentation'},
        {'name' => 'DevOps'},
        {'name' => 'Frontend'},
        {'name' => 'Testing'},
        {'name' => 'Working Groups'},
      ]

      team = [
        {'name' => 'mbland', 'location' => 'DCA',
         'working_groups' => [
           working_groups[0],
           working_groups[3],
           working_groups[4],
         ],
        },
        {'name' => 'afeld', 'location' => 'NYC',
         'projects' => [projects[1]],
         'working_groups' => [working_groups[0], working_groups[1]],
        },
        {'name' => 'mhz', 'location' => 'TUS',
         'projects' => [projects[2]],
         'working_groups' => [working_groups[0], working_groups[2]],
        },
        {'name' => 'gboone', 'location' => 'DCA',
         'projects' => [projects[0]],
         'working_groups' => [working_groups[0]],
        },
        {'name' => 'ekamlley', 'location' => 'DCA',
         'projects' => [projects[0]],
         'working_groups' => [working_groups[0]],
        },
      ]

      xref = create_xref_using_team_data team
      xref.xref_locations

      expected = [
        {'code' => 'DCA',
         'latitude' => 38.843677,
         'longitude' => -77.046915,
         'timezone' => 'Eastern Time Zone (UTC-05:00)',
         'team' => [team[0], team[3], team[4]],
         'projects' => [projects[0]],
         'working_groups' => [
           working_groups[0], working_groups[3], working_groups[4],
         ],
        },
        {'code' => 'NYC',
         'latitude' => 40.641311,
         'longitude' => -73.778139,
         'timezone' => 'Eastern Time Zone (UTC-05:00)',
         'team' => [team[1]],
         'projects' => [projects[1]],
         'working_groups' => [working_groups[0], working_groups[1]],
        },
        {'code' => 'TUS',
         'latitude' => 32.11451,
         'longitude' => -110.939227,
         'timezone' => 'Mountain Time Zone (UTC-07:00)',
         'team' => [team[2]],
         'projects' => [projects[2]],
         'working_groups' => [working_groups[0], working_groups[2]],
        },
      ]
      ['projects', 'working_groups'].each do |category|
        expected.each {|i| i[category].sort_by!{|j| j['name']}}
      end
      assert_equal expected, @site.data['locations']
    end
  end
end
