module ActsAsArchive
  module Base
    def self.included(base)
      base.extend ActMethods
    end

    module ActMethods
      def acts_as_archive(options={})
        class_eval <<-end_eval

          def self.acts_as_archive?
            self.to_s == #{self.to_s.inspect}
          end

          def self.archive_indexes
            #{Array(options[:indexes]).collect(&:to_s).inspect}
          end

          class Archive < ActiveRecord::Base
            self.record_timestamps = false
            self.table_name = "archived_#{self.table_name}"

            def archived?
              self.class.exists?(self)
            end
          end
        end_eval
        include Destroy
        include Restore
        include Table
      end
    end
  end
end

# SQLite support
module ActsAsArchive
  module Base
    module Table
      module ClassMethods
        def create_archive_table
          if table_exists? && !archive_table_exists?
            connection.execute(%{
              CREATE TABLE archived_#{table_name}
                AS SELECT * from #{table_name};
            })
            columns = connection.columns("archived_#{table_name}").collect(&:name)
            unless columns.include?('deleted_at')
              connection.add_column("archived_#{table_name}", :deleted_at, :datetime)
            end
          end
        end

        def create_archive_indexes
          if archive_table_exists?
            indexes = "PRAGMA index_list(archived_#{table_name})"
            indexes = connection.select_all(indexes).collect { |r| r["name"] }

            (archive_indexes - indexes).each do |index|
              connection.add_index("archived_#{table_name}", index)
            end
            (indexes - archive_indexes).each do |index|
              connection.remove_index("archived_#{table_name}", index)
            end
          end
        end
      end
    end
  end
end


# better class methods
module ActsAsArchive
  module Base
    module Restore
      module ClassMethods
        def self.find_archived
          self.class::Archive.find(:all)
        end

        def self.restore(id)
          self.copy_from_archive(["#{self.class.primary_key} = ?", id])
        end
      end

      module InstanceMethods
        def restore
          if archived?
            self.class.copy_from_archive(["#{self.class.primary_key} = ?", id])
          else
            raise "Cannot restore unarchived resource."
          end
          return self
        end

        def archived?
          self.class::Archive.exists?(self)
        end

        def archive
          destroy
        end
      end
    end
  end
end