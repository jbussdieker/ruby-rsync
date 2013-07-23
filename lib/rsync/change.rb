module Rsync
  class Change
    include Enumerable

    def initialize(raw)
      @raw = raw
    end

    def each(&block)
      @raw.split("\n").each do |line|
        #if line =~ /^([<>ch.*][fdLDS][ .+\?cstTpoguax]{9}) (.*)$/
        if line =~ /^([<>ch.\*].{10}) (.*)$/
          detail = Detail.new(line)
          yield(detail) if detail.changed?
        end
      end
    end

    class Detail
      def initialize(raw)
        @raw = raw
      end

      def filename
        @raw[12..-1]
      end

      def changed?
        if update_type == :message
          return true
        elsif update_type == :recv
          return true
        end
        false
      end

      def summary
        if update_type == :message
          message
        elsif update_type == :recv and @raw[2,9] == "+++++++++"
          "creating"
        elsif update_type == :recv
          "updating"
        else
          changes = []
          #[:checksum, :size, :timestamp, :permissions, :owner, :group, :acl].each do |prop|
          [:checksum, :size, :permissions, :owner, :group, :acl].each do |prop|
            changes << prop if send(prop) == :changed
          end
          changes.join(", ")
        end
      end

      def message
        @raw[1..10].strip
      end

      def raw_update_type
        @raw[0]
      end

      def raw_file_type
        @raw[1]
      end

      def attribute_prop(index)
        case @raw[index]
          when '.'
            :no_change
          when ' '
            :identical
          when '+'
            :new
          when '?'
            :unknown
          else
            :changed
        end
      end

      def checksum
        attribute_prop(2)
      end

      def size
        attribute_prop(3)
      end

      def timestamp
        attribute_prop(4)
      end

      def permissions
        attribute_prop(5)
      end

      def owner
        attribute_prop(6)
      end

      def group
        attribute_prop(7)
      end

      def acl
        attribute_prop(9)
      end

      def ext_attr
        attribute_prop(10)
      end

      def update_type
        case raw_update_type
          when '<'
            :sent
          when '>'
            :recv
          when 'c'
            :change
          when 'h'
            :hard_link
          when '.'
            :no_update
          when '*'
            :message
        end
      end

      def file_type
        case raw_file_type
          when 'f'
            :file
          when 'd'
            :directory
          when 'L'
            :symlink
          when 'D'
            :device
          when 'S'
            :special
        end
      end
    end
  end
end
