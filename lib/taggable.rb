module CitySim
  module Taggable
    def tags
      @tags ||= []
      @tags
    end

    def has_tag?(tag)
      tags.include?(tag)
    end

    def add_tag(tag)
      tags << tag
      tags.uniq!
    end

    def remove_tag(tag)
      tags.delete(tag)
    end
  end
end