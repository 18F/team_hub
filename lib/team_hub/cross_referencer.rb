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

  # Operations for creating cross-references between data objects
  class CrossReferencer
    # Creates an index of +collection+ items based on +key+.
    #
    # @param collection [Array<Hash>] collection from which to build an index
    # @param key [String] property used to build the index
    # @return [Hash]
    def self.create_index(collection, key)
      index = collection.group_by {|i| i[key]}
      index.delete nil
      index
    end

    # Creates cross-references between Hash objects in +sources+ and Hash
    # objects in +targets+.
    #
    # Each object in +sources+ should have a +source_key+ member that is an
    # Array<String> of target identifiers (keys into +targets+) that will be
    # replaced with an Array<Hash> of object references from +targets+.
    #
    # Objects in +targets+ should not yet contain a +target_key+ member. This
    # member will be created as an Array<Hash> of object references from
    # +sources+.
    #
    # If an object cross-referenced by an object in +sources+ does not exist
    # in +targets+, that cross-reference will be skipped without error. If an
    # object from +sources+ does not contain a +source_key+ property, it will
    # also be skipped.
    #
    # @param sources [Array<Hash>] objects containing the information
    #   needed to establish cross-references with objects in +targets+
    # @param source_key [String] identifies the cross-referenced property from
    #   +sources+
    # @param targets [Hash<Hash>] index of objects to cross-reference with
    #   objects from +sources+
    # @param target_key [String] identifies the cross-referenced property from
    #   +targets+
    def self.create_xrefs(sources, source_key, targets, target_key)
      (sources || []).each do |source|
        (source[source_key] || []).map! do |target_id|
          target = targets[target_id]
          (target[target_key] ||= Array.new) << source if target
          target
        end.compact!
      end
    end

    # Creates a copy of +collection+ where each item's +property+ member has
    # had its objects replaced with an Array of +property_key+ values.
    #
    # The primary use case is to "flatten" a list of Hash objects that have
    # cross-reference links back to Hash objects in +collection+. While
    # cross-referencing objects makes it easy to traverse the object graph
    # in-memory, it is useful to flatten these cross-references when
    # serializing data, generating API data, checking cross-references in
    # automated tests (in concert with property_map, to avoid producing
    # voluminous output for assertion failures due to extraneous data and the
    # infinite recursion between cross-referenced objects), logging, and error
    # reporting.
    #
    # @param collection [Array<Hash>] objects for which to flatten the
    #   +property+ collection
    # @param property [String] property of objects in +collection+
    #   corresponding to a list of (possibly cross-referenced) Hash objects
    # @param property_key [String] primary key of cross-referenced objects;
    #   the corresponding value should be a String
    # @return [Array] a copy of collection with +property+ items flattened
    def self.flatten_property(collection, property, property_key)
      collection.map do |i|
        item = i.clone
        item[property] = i[property].map {|p| p[property_key]} if i[property]
        item
      end
    end

    # The in-place version of flatten_property which directly replaces the
    # +property+ member of each item of +collection+ with an Array of
    # +property_key+ values.
    #
    # In addition to the use cases described in the the flatten_property
    # comment, the in-place version may be useful to help free memory by
    # eliminating circular object references.
    #
    # @see flatten_property
    def self.flatten_property!(collection, property, property_key)
      collection.each do |i|
        i[property].map! {|p| p[property_key]} if i[property]
      end
    end

    # Creates a map from +primary_key+ values to flattened +property+ values
    # for each item in +collection+.
    #
    # For checking cross-referenced property values in automated tests,
    # first process +collection+ using flatten_property to avoid voluminous
    # output due to the infinite recursion between cross-referenced objects.
    #
    # @param collection [Array<Hash>] objects for which to flatten the
    #   +property+ collection
    # @param primary_key [String] primary key for objects in +collection+; the
    #   corresponding value should be a String
    # @param property [String] property of objects in +collection+
    #   corresponding to a list of (possibly cross-referenced) Hash objects
    # @param property_key [String] primary key of cross-referenced objects; the
    #   corresponding value should be a String
    # @return [Hash<String, Array<String>>] +primary_key+ values =>
    #   flattened +property+ values
    # @see flatten_property
    def self.property_map(collection, primary_key, property, property_key)
      collection.map do |i|
        [i[primary_key], i[property].map {|p| p[property_key]}] if i[property]
      end.compact.to_h
    end
  end
end
