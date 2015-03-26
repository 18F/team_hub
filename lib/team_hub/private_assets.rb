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

module TeamHub

  # Operations for managing private asset files.
  class PrivateAssets

    # Copies private items into the _site directory.
    #
    # More correctly, it prepares private items for copying, which happens at
    # site generation time.
    # +site+:: Jekyll site object
    def self.copy_to_site(site)
      copy_files(site, site.config['private_data_path'],
        site.config['team_img_dir'])
      copy_files site, site.config['private_pages_path'], 'assets'
    end

    # Determines whether or not a private asset is present.
    # +site+:: Jekyll site data
    # +relative_path+:: path of asset relative to private_data_path config
    def self.exists? (site, relative_path)
      File.exists? File.join(
        site.source, site.config['private_data_path'], relative_path)
    end

    # Copies a directory of private data assets into the generated site.
    # @param site [Jekyll::Site] Jekyll site object
    # @param dir_to_copy [string] directory within
    #   site.config['private_data_path'] to copy into the generated site
    def self.copy_files(site, relative_root_path, dir_to_copy)
      abs_dir_to_copy_path = File.join(site.source, relative_root_path,
        dir_to_copy)
      begin_path = abs_dir_to_copy_path.size + File::SEPARATOR.size
      Dir[File.join(abs_dir_to_copy_path, '**', '*')].each do |filename|
        next unless File.file? filename
        site.static_files << ::Jekyll::StaticFile.new(
          site, relative_root_path, dir_to_copy, filename[begin_path..-1])
      end
    end
  end
end
