require "highline"

module Healer
  module Utility

    class DataSync

      attr_reader :dbname, :username, :verbose, :cleanup

      def initialize(options = {})
        @verbose = options[:verbose] || false
        @cleanup = options[:cleanup] || true
        @dbname = local_db_name
        @username = local_db_username
      end

      def replace_local_from_heroku
        dump_local_db
        pull_heroku_database_locally

        puts "Dropping and creating database..." if verbose
        system("dropdb -U #{username} --if-exists #{dbname}")
        system("createdb -O #{username} -T template0 #{dbname}")

        puts "Restoring local DB from #{heroku_dump_path}..." if verbose
        system("pg_restore --verbose --no-acl --no-owner -h localhost -U #{username} -d #{dbname} #{heroku_dump_path}")

        FileUtils.rm_f(heroku_dump_path) if cleanup
      end

      def push_local_to_heroku
        puts "Backing up Heroku DB locally for safety..." if @verbose
        pull_heroku_database_locally(".backup")

        dump_local_db
        s3_local_backup.write(:file => local_dump_path)

        system("heroku pgbackups:restore DATABASE '#{s3_local_backup.url_for(:read).to_s}'")
        
        FileUtils.rm_f(local_dump_path) if cleanup
      end

      def back_up_heroku_database_to_s3
        pull_heroku_database_locally
        puts "Uploading to S3 at #{s3_backup_path}..." if @verbose
        s3_heroku_backup.write(:file => heroku_dump_path)
      end


      private ##################################################################

      def pull_heroku_database_locally(file_ext = "")
        puts "Capturing Heroku backup snapshot..." if @verbose
        system("heroku pgbackups:capture --expire")
        puts "Downloading locally to #{heroku_dump_path + file_ext}..." if @verbose
        system("curl -o #{heroku_dump_path + file_ext} `heroku pgbackups:url`")
      end

      def dump_local_db
        puts "Dumping local #{dbname} to #{heroku_dump_path}..." if @verbose
        system("pg_dump --verbose --no-acl --no-owner -h localhost -U #{username} -f #{local_dump_path} #{dbname}")
      end

      def heroku_dump_path
        @heroku_dump_path ||= "tmp/healer-heroku-#{Time.now.to_i}.pg.dump"
      end

      def local_dump_path
        @local_dump_path ||= "tmp/healer-local-#{Time.now.to_i}.pg.dump"
      end

      def s3_heroku_backup
        s3_connection.buckets[bucket].objects["data_backup/#{File.basename(heroku_dump_path)}"]
      end

      def s3_local_backup
        s3_connection.buckets[bucket].objects["data_backup/#{File.basename(local_dump_path)}"]
      end

      def bucket
        @bucket ||= Healer::S3_BUCKET
      end

      def s3_backup_path
        "#{bucket}:data_backup/#{File.basename(heroku_dump_path)}"
      end

      def s3_connection
        @s3_connection ||= AWS::S3.new
      end

      def local_db_username
        @local_db_username ||= if ActiveRecord::Base.connected?
          ActiveRecord::Base.connection_config[:username]
        else
          HighLine.new.ask("Local db username:") { |u| u.default = "root" }
        end
      end

      def local_db_name
        @local_db_name ||= if ActiveRecord::Base.connected?
          ActiveRecord::Base.connection_config[:database]
        else
          HighLine.new.ask("Local db:") { |u| u.default = "healer_development" }
        end
      end

    end

  end
end
