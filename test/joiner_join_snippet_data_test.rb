# team_hub - Components for creating a team Hub using Jekyll
#
# Written in 2014 by Mike Bland (michael.bland@gsa.gov)
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
require_relative "../lib/team_hub/joiner"
require_relative "site"

require "minitest/autorun"
require "weekly_snippets/version"

module TeamHub
  class JoinSnippetDataTest < ::Minitest::Test
    def setup
      @site = DummyTestSite.new
      @site.data['private']['snippets'] = {'v1' => {}, 'v2' => {}, 'v3' => {}}
      @site.data['private']['team'] = []
      @impl = Joiner.new(@site)
      @expected = {}
    end

    def set_team(team_list)
      @site.data['private']['team'] = team_list
      @impl.create_team_by_email_index
      @impl.promote_private_data 'team'
    end

    def add_snippet(version, timestamp, name, full_name,
      email, public_or_private, last_week, this_week, expected: true)
      snippets = @site.data['private']['snippets'][version]
      unless snippets.member? timestamp
        snippets[timestamp] = []
      end
      collection = snippets[timestamp]

      case version
      when "v1"
        collection << {
          'Timestamp' => timestamp,
          'Username' => email,
          'Name' => full_name,
          'Snippets' => last_week
        }
      when "v2"
        unless ['Private', ''].include? public_or_private
          raise Exception.new("Invalide public_or_private for v2: "+
            "#{public_or_private}")
        end
        collection << {
          'Timestamp' => timestamp,
          'Public vs. Private' => public_or_private,
          'Last Week' => last_week,
          'This Week' => this_week,
          'Username' => email,
        }
      when "v3"
        unless ['Public', ''].include? public_or_private
          raise Exception.new("Invalide public_or_private for v3: "+
            "#{public_or_private}")
        end
        collection << {
          'Timestamp' => timestamp,
          'Public' => public_or_private,
          'Username' => email,
          'Last week' => last_week,
          'This week' => this_week,
        }
      else
        raise Exception.new "Unknown version: #{version}"
      end

      if expected
        s = {}.merge collection.last
        Joiner::SNIPPET_VERSIONS[version].standardize s
        s['name'] = name
        s['full_name'] = full_name
        @expected[timestamp] = [] unless @expected.member? timestamp
        @expected[timestamp] << s
      end
    end

    def test_empty_snippet_data
      set_team([])
      @impl.join_snippet_data Joiner::SNIPPET_VERSIONS
      assert_empty @site.data['snippets']
    end

    def test_raise_if_snippet_version_unknown
      set_team([])
      add_snippet('v1', '20141218', 'mbland', 'Mike Bland',
        'michael.bland@gsa.gov', 'unused', '- Did stuff', '')
      error = assert_raises ::WeeklySnippets::Version::UnknownVersionError do
        @impl.join_snippet_data({})
      end
      assert_equal "Unknown snippet version: v1", error.to_s
    end

    def test_joined_snippets_are_empty_if_no_team
      set_team([])
      add_snippet('v1', '20141218', 'mbland', 'Mike Bland',
        'michael.bland@gsa.gov', 'unused', '- Did stuff', '',
        expected:false)
      add_snippet('v2', '20141225', 'mbland', 'Mike Bland',
        'michael.bland@gsa.gov', '', '- Did stuff', '', expected:false)
      add_snippet('v3', '20141231', 'mbland', 'Mike Bland',
        'michael.bland@gsa.gov', 'Public', '- Did stuff', '', expected:false)
      @impl.join_snippet_data Joiner::SNIPPET_VERSIONS
      assert_empty @site.data['snippets']
    end

    def test_join_all_snippets
      set_team([
        {'name' => 'mbland', 'full_name' => 'Mike Bland',
         'email' => 'michael.bland@gsa.gov'},
      ])
      add_snippet('v1', '20141218', 'mbland', 'Mike Bland',
        'michael.bland@gsa.gov', 'unused', '- Did stuff', '')
      add_snippet('v2', '20141225', 'mbland', 'Mike Bland',
        'michael.bland@gsa.gov', '', '- Did stuff', '')
      add_snippet('v3', '20141231', 'mbland', 'Mike Bland',
        'michael.bland@gsa.gov', 'Public', '- Did stuff', '')
      @impl.join_snippet_data Joiner::SNIPPET_VERSIONS
      assert_equal @expected, @site.data['snippets']
    end

    # This tests the case where we're publishing snippets imported into
    # _data/public using _data/import-public.rb. That script will substitute
    # the original snippets' email usernames with the corresponding Hub
    # username.
    def test_join_snippets_with_hub_username_instead_of_email_address
      @site.config['public'] = true
      @impl = Joiner.new(@site)

      set_team([
        {'name' => 'mbland', 'full_name' => 'Mike Bland',
         'email' => 'michael.bland@gsa.gov'},
      ])
      add_snippet('v3', '20141231', 'mbland', 'Mike Bland', 'mbland',
        'Public', '- Did stuff', '')

      @impl.join_snippet_data Joiner::SNIPPET_VERSIONS
      assert_equal @expected, @site.data['snippets']
    end
  end
end
